
;;;; playground3.lisp

(in-package #:cl-vulkan)

(declaim (optimize (debug 3) (speed 0) (space 0)))
(proclaim '(optimize debug))

(defun agenerate-member (var ;;some-var
			 type ;;:rect-2d
			 value ;;(:offset-2d (:x 10 :y 20) :extent-2d (:width 30 :height 40))
			 previous-var
			 gensyms-book
			 )
  
  (let ((members (gethash type *structs-plist-hash*))
	(forms '()))
    (loop
       for member in members
       with struct
       with struct-pointer-p
       with t-slot-name
       with t-type
	 with v-value
       with t-opaque-p
       with v-len
       with v-count
       do (setf t-slot-name (car member))
	 (setf t-type (getf (cdr member) :type))
	 (setf v-value (first (getf (car value) t-slot-name)))
	 (setf t-opaque-p (getf (cdr member) :opaque))
	 (setf v-len (third (getf (car value) t-slot-name)))
	 (setf v-count (fourth (getf (car value) t-slot-name)))
	 (when (eql t-slot-name :p-clear-values) )
         (multiple-value-setq (struct struct-pointer-p) (parse-struct t-type))
       when (and (member struct *total-structs*) struct-pointer-p) ;; pointer to struct
       do (let* ((array (getf (car value) t-slot-name))
		 (length-of-pointer (length array))
		 (this-let-gensym (funcall (cadr gensyms-book) struct length-of-pointer)))
	    (dotimes (current-index length-of-pointer)
	      (when (nth current-index array)
	      (push `(setf current-pointer  (inc-pointer ,this-let-gensym (* (foreign-type-size '(:struct ,struct)) ,current-index))) forms)
	      (setf forms (append (reverse (agenerate-member
		      'current-pointer
		      struct
		      (nth current-index array)
		      this-let-gensym
		      gensyms-book)) forms))))
	     (push `(setf current-pointer  (inc-pointer ,previous-var (* (foreign-type-size '(:struct ,type)) 0))) forms)
	     (if (car array)
		(push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) ,this-let-gensym) forms)
		(push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) (null-pointer)) forms)))
       when (and (member struct *total-structs*) (not struct-pointer-p)) ;; struct
       do (let ((this-let-gensym (funcall (cadr gensyms-book ) struct 1)))
	    (setf forms (append  (reverse (agenerate-member
					   this-let-gensym
					   struct
					   (getf (car value) t-slot-name)
					   this-let-gensym
					   gensyms-book)) forms))
	 (push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) ,this-let-gensym) forms))
       when (not (member struct *total-structs*))
       do  ;;(push `(setf current-pointer  (inc-pointer ,var (* (foreign-type-size '(:struct ,type)) 0))) forms)
	 (cond ((eq t-slot-name :s-type) ;; s-type
		 (push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) (foreign-enum-value '%vk::structure-type ,v-value)) forms))
		
		 ((eq t-slot-name :p-next) ;; p-next
		  (push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) (null-pointer)) forms))

		 ((eq t-slot-name :p-code) ;; It's a pointer to char but treated specially
		  (push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) ,v-value) forms))
		  
		  ((member t-type *total-enums*) ;; enums
		 (push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) (foreign-enum-value ',t-type ,v-value)) forms))
		 
		 (v-count ;; fixed size arrays in structs
		  
		 (push `(setf array-pointer (foreign-slot-value ,previous-var '(:struct ,type) ,t-slot-name)) forms)
		 (dotimes (index v-count)
		   (push `(setf (mem-ref (inc-pointer array-pointer (* ,index (foreign-type-size ,t-type))) ,t-type) (nth ,index ,v-value)) forms)))
		
		(t-opaque-p ;; opaque type or pointer to opaque type
		 (if (eql :pointer (car (alexandria:ensure-list t-type)))
		     (push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) ,(car v-value)) forms) ;; pointer to opaque type
		     (push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) ,v-value) forms))) ;; opaque type
		
		((or (eq :union (car (alexandria:ensure-list t-type))) ;; :union or pointer to union
			 (and (parse-pointer t-type) (eql (car (alexandria:ensure-list (parse-pointer t-type))) :union)))
		 (unless (eq :pointer (car (alexandria:ensure-list t-type))) ; :union
		   (break))
		 (when (eq :pointer (car (alexandria:ensure-list t-type))) ; pointer to union
		   (let ((this-let-gensym (funcall (cadr gensyms-book) (cadr (parse-pointer t-type)) (length (getf (car value) t-slot-name)))))
		     (dotimes (index-one (length (getf (car value) t-slot-name)))
		       (cond ((eql :color (car (nth index-one (getf (car value) t-slot-name))))
			      (push `(setf union-pointer (foreign-slot-value ,this-let-gensym '(:union %vk::clear-value) :color)) forms)
			      (push `(setf union-pointer (inc-pointer union-pointer
								      (* ,index-one (foreign-type-size ',(parse-pointer t-type))))) forms)
			      (let ((union-value-type (first (cadr (nth index-one (getf (car value) t-slot-name)))))
				    (union-value-value (second (cadr (nth index-one (getf (car value) t-slot-name))))))
			      (dotimes (index-two (length union-value-value))
				(push `(setf (mem-ref (inc-pointer union-pointer (* ,index-two
										    (foreign-type-size ,union-value-type))) ,union-value-type)
					     (nth ,index-two ',union-value-value)) forms))))
			     (t (break))))
		     (push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) ,this-let-gensym) forms))))

		((and (eql :pointer (car (alexandria:ensure-list t-type)))
		      (cffi-type-p (cadr (alexandria:ensure-list t-type)))) ;; pointer to int32/int8/float/char etc
		 (when (listp v-value)
		 (let ((this-let-gensym
			(if (eql (parse-pointer t-type) :char)
			    (funcall (cadr gensyms-book) (parse-pointer t-type) (+ 1 (length (cadr v-value))))
			    (funcall (cadr gensyms-book) (parse-pointer t-type) (length (cadr v-value))))))
	   
		 (push `(dotimes (index (length ,v-value) )
			  (setf (mem-ref (inc-pointer ,this-let-gensym
						      (* index (foreign-type-size ,(parse-pointer t-type)))) ,(parse-pointer t-type)) ,
				(if (eql (parse-pointer t-type) :char)
				    `(char-code (nth index ,v-value))
				    `(nth index ,v-value)))) forms)
		 (if (eql (parse-pointer t-type) :char)
		     (push  `(setf (mem-ref (inc-pointer ,this-let-gensym
							 (* ,(length (cadr v-value)) (foreign-type-size :char))) :char) 0) forms))
		 (push `(setf (foreign-slot-value current-pointer '(:struct ,type) ,t-slot-name) ,this-let-gensym) forms)))
		 (unless (listp v-value)
		   (push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) ,v-value) forms)))

		((or (and (parse-pointer t-type) ;; bitfields or pointer to bitfields
			  (member (car (alexandria:ensure-list (parse-pointer t-type))) *total-bitfields*))
		     (and (not (parse-pointer t-type))(member t-type *total-bitfields* :test #'string-equal))) 
		 (cond ((and (numberp v-value) (= v-value 0)) ;; special bitfield with value 0
			(push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) 0) forms))
		       ((and (not (parse-pointer t-type))
			     (member t-type *total-bitfields* :test #'string-equal))  ;; bitfield
			(push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) (foreign-bitfield-value ',t-type ,v-value)) forms))
		       (t ;; pointer to bitfield
			(let ((this-let-gensym (funcall (cadr gensyms-book) (parse-pointer t-type) (length (getf (car value) t-slot-name)))))
			  (dotimes (index-one (length (getf (car value) t-slot-name)))
			    (push `(setf bitfield-pointer (inc-pointer ,this-let-gensym
								       (* ,index-one (foreign-type-size ',(parse-pointer t-type))))) forms)
			    (push `(setf (mem-ref bitfield-pointer ',(parse-pointer t-type)) (foreign-bitfield-value ',(parse-pointer t-type) ,v-value)) forms))
			  (push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) ,this-let-gensym) forms)))))
		
		((eql :pointer (car (alexandria:ensure-list t-type))) ;; pointer to opaque types
		 (push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) ,v-value) forms))
		
		(t
		 (push `(setf (foreign-slot-value ,var '(:struct ,type) ,t-slot-name) ,v-value) forms))))
    (nreverse (push '() forms))))

(defmacro awith-vk-structs (((var type value &optional count)
			     &rest more-bindings) &body body)
  
  `,(let ((gensym-book '()))
      (push (generate-gensyms type (eval value)) gensym-book)
      (loop
	 for (l-var l-type l-value l-count) in more-bindings
	 do (push (generate-gensyms l-type (eval l-value)) gensym-book))
      (setf gensym-book (nreverse gensym-book))
      `(let ((current-pointer nil)
	     (union-pointer nil)
	     (array-pointer nil)
	     (bitfield-pointer nil))    
     (with-foreign-objects ((,var '(:struct ,type) ,(if count count 1))
			    ,@(let ((forms '()))
				(loop
				   for (l-var l-type l-value l-count) in more-bindings
				   do (push `(,l-var '(:struct ,l-type) ,(if l-count l-count 1)) forms))
				forms)
			  ,@(generate-foreign-object-bindings (car gensym-book))
			  ,@(let ((forms '()))
			      (loop
				 for (l-var l-type l-value l-count) in more-bindings
				 for index from 1
				 do (setf forms
					  (append forms
						  (generate-foreign-object-bindings (nth index gensym-book)))))
			  forms))
    ,@(agenerate-member var type (eval value) var (car gensym-book))
     ,@(let ((forms '()))
	 (loop
	    for (l-var l-type l-value l-count) in more-bindings
	    for index from 1
	    do (setf forms
		     (append forms
			     (agenerate-member l-var l-type (eval l-value) l-var (nth index gensym-book)))))
	 forms)
     ,@body))))

#|(awith-vk-structs ((sbi %vk:offset-2d pg3::*offset2d-value*)))|#

#|(awith-vk-structs ((gpci %vk:graphics-pipeline-create-info pg3::*graphics-pipeline-value*)
		   (ov %vk:offset-2d pg3::*offset2d-value*)))|#

(defun generate-foreign-object-bindings (book)
  (let ((forms '()))
  (loop
     for v being the hash-values in (third book) using (hash-key k)
     when v
     do (loop
	   for l in v
	   do (loop
		 for inner-list in (cdr l)
		 when (member k *total-structs*)
		 do (push `(,inner-list '(:struct ,k) ,(car l)) forms)
		 when (member k *total-unions*)
		   do (push `(,inner-list '(:union ,k) ,(car l)) forms)
		 when (and (not (member k *total-structs*)) (not (member k *total-unions*)) (not (cffi-type-p k)))
		 do (push `(,inner-list ',k ,(car l)) forms)
		 when (cffi-type-p k)
		   do (push `(,inner-list ,k ,(car l)) forms))))
  forms))

(defun cffi-type-p (type)
  (let ((cffi-types '(:char :uint8 :uint32 :uint64 :float)))
    (member type cffi-types)))
  
(defun generate-gensyms (type value)
  (let* ((book (structures-numbers))
	 (h  (get-structures
	      (gethash type *structs-plist-hash*)
	      value  book)))
    book))

(defun get-structures (tree-template tree-value book ;;any hash value from *structs-plist-hash*
		       )
  (flet ((structp (struct)
	   (member struct *total-structs*)))
    (loop
       for (slot-name nil type . attribs) in tree-template
       with struct
       with struct-pointer-p
       do (multiple-value-setq (struct struct-pointer-p) (parse-struct type))
	 
       when (and (structp struct) struct-pointer-p) ;; pointer to struct
       do (funcall (car book) struct (length (getf (car tree-value) slot-name)))
	 (loop
	    for entity in (getf (car tree-value) slot-name)
	    when entity do (get-structures (gethash struct *structs-plist-hash*) entity book))
	 
       when (and (structp struct) (not struct-pointer-p)) ;; struct
       do (funcall (car book) struct 1)
	 (get-structures (gethash struct *structs-plist-hash*) (getf (car tree-value) slot-name) book)
	 
       when (and (not struct) (parse-pointer type) (not (eql (car (alexandria:ensure-list (parse-pointer type))) :union))) ;; pointer to uint8/uint32/uint64/float/char
       do (if (eql (parse-pointer type) :char)
	      (if (not (eql slot-name :p-code))
			    (funcall (car book) (parse-pointer type) (+ 1 (length (alexandria:ensure-list (cadr (first (getf (car tree-value) slot-name))))))))
	      (if (listp (car (getf (car tree-value) slot-name)))
		  (funcall (car book) (parse-pointer type) (length (alexandria:ensure-list (cadr (first (getf (car tree-value) slot-name))))))))
	 
       when (and (not struct) (parse-pointer type) (eql (car (alexandria:ensure-list (parse-pointer type))) :union)) ;; pointer to union
       do (funcall (car book) (cadr (parse-pointer type)) (length (getf (car tree-value) slot-name)))
          (dolist (union-value  (getf (car tree-value) slot-name))
	    (cond ((eql (car union-value) :color) (funcall (car book) '%vk::clear-color-value 1))
		  ((eql (car union-value) :clear-depth-stencil-value) (funcall (car book) '%vk::clear-depth-stencil-value 1))))
	 
       when (and (not struct) (not (parse-pointer type)) (eql (car (alexandria:ensure-list type)) :union)) ;; union
       do (funcall (car book) (cadr type) 1)))
  
  (third book))
 
(defun parse-struct (member ;;(:pointer (:struct blahblah)) | (:struct blahblah) => blahblah 
		     )
  (let ((pointer-p nil) (struct nil))
  (if (listp member)
  (let ((str
  (if (eql (car member) :pointer)
      (when (and (listp (second member)) (eql (first (second member)) :struct))
	  (setf pointer-p t) (second (second member)))
      (if (eql (first member) :struct)
	  (second member)))))
    (if str (setf struct str))
    (if struct (values struct pointer-p))))))

(defun parse-pointer (member ;; pointer to something
		      )
  (if (and (eql (car(alexandria:ensure-list member)) :pointer)
	   (not (eql (cadr member) :void)))
      (cadr member))
)

(defun structures-book (append-fun remove-fun initial-value)
  (let ((book (make-hash-table)))
    (list
     #'(lambda (key value)
	 (if (not (gethash key book)) (setf (gethash key book) initial-value))
	 (setf (gethash key book) (funcall append-fun (gethash key book) value)))
     #'(lambda (key value)
	   (funcall remove-fun (gethash key book) value))
     book)))

(defun structures-numbers ()
  (flet ((number-push (place value2)
	   (let* ((a-list place)
		  (existing-datum-value2 (cdr (assoc value2 a-list))))
	     (when (not (assoc value2 a-list)) (setf a-list (acons value2 '() a-list)))
	     (rplacd (assoc value2 a-list) (push (gensym) existing-datum-value2))
	   a-list))
	   (number-pop (place value1)
		       	   (let* ((a-list place)
				  (existing-datum-value1 (cdr (assoc value1 a-list)))
				  (popped-value (pop existing-datum-value1)))
			     
	     (rplacd (assoc value1 a-list) existing-datum-value1)
	   popped-value)))
    (structures-book #'number-push #'number-pop '())))

