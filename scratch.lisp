(in-package #:playground3)

(defcstruct vec2
    "vector2 of floats"
  (x :float :count 2))

(defcstruct vec3
    "vector2 of floats"
  (x :float :count 3))

(defcstruct vec4
    "vector2 of floats"
    (x :float :count 4))

(defcstruct (shader-vertex :size 64)
  "A structure to send vertex data to shaders"
  (:pos (:struct vec4) :offset 0)
  (:normal (:struct vec4) :offset 16)
  (:tangent (:struct vec4) :offset 32)
  (:uv (:struct vec2) :offset 48))
  
(defun number-of-vertices (file)
  (with-open-file (f file)
    (iter (for line next (read-line f nil nil))
	  (if (not line) (terminate))
	  (if (not (string= line ""))
	      (counting (string= (subseq line 0 2) "v "))))))

(defun pointer-test-bed (file)
  (let ((main-pointer nil)
	(vertex-count (number-of-vertices file)))
    (unwind-protect (progn
		      (setf main-pointer (cffi:foreign-alloc '(:struct shader-vertex)
							     :count vertex-count))
		      (iter (for line next (read-line file nil nil))
			    (if (not line) (terminate))
			    (if (not (string= line ""))
				(cond ((string= line "v ")
				       nil)
				      )))
		      )
      (format t "~S" "Freeing main pointer")
      (cffi:foreign-free main-pointer))
    ))


