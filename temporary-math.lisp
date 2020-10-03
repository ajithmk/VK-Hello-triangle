(in-package #:pg3)

(defparameter *yaw* 0)
(defparameter *pitch* 0)
(defparameter *roll* 0)

(defparameter *mat1* #(1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0))
(defparameter *mat2* #(1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0))
(defparameter *mat3* #(1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0))

(defun matrix-multiply (a b dest)
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0)))
  (declare (simple-vector a b dest))
  (iter (for row from 0 below 4)
	(declare (fixnum row))
	(iter (for column from 0 below 4)
	      (declare (fixnum column))
	      (setf (svref dest (the (unsigned-byte 8) (+ (the (unsigned-byte 8) (* 4 row)) column)))
		     (the single-float
			     (+ 
			      (the single-float
				   (* (the single-float (svref a (the (unsigned-byte 8) (+ (the (unsigned-byte 8) (* 4 row)) 0))))
				      (the single-float (svref b (+ 0 column)))))
			      
			      (the single-float
				   (* (the single-float (svref a (the (unsigned-byte 8) (+ (the (unsigned-byte 8) (* 4 row)) 1))))
				      (the single-float (svref b (+ 4 column)))))
			      
			      (the single-float
				   (* (the single-float (svref a (the (unsigned-byte 8) (+ (the (unsigned-byte 8) (* 4 row)) 2))))
				      (the single-float (svref b (+ 8 column)))))
			      
			      (the single-float
				   (* (the single-float (svref a (the (unsigned-byte 8) (+ (the (unsigned-byte 8) (* 4 row)) 3))))
				      (the single-float (svref b (+ 12 column))))))))))
  dest)

(defun test-fun()
  (dotimes (count 1000000000)
    (matrix-multiply *mat1* *mat2* *mat3*)))



(defun matrix-vector-multiply (matrix vector dest-vector)
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0)))
	(iter (for column from 0 below 4)
	      (declare (fixnum column))
	      (setf (svref dest-vector column)
		     (the single-float
			     (+ 
			      (the single-float
				   (* (the single-float (svref vector 0))
				      (the single-float (svref matrix (+ 0 column)))))
			      
			      (the single-float
				   (* (the single-float (svref vector 1))
				      (the single-float (svref matrix (+ 4 column)))))
			      
			      (the single-float
				   (* (the single-float (svref vector 2))
				      (the single-float (svref matrix (+ 8 column)))))
			      
			      (the single-float
				   (* (the single-float (svref vector 3))
				      (the single-float (svref matrix (+ 12 column)))))))))
	dest-vector)

(defun euler-to-matrix (euler-angles dest-matrix)
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0)))
  (let ((sa (the single-float (coerce (sin (svref euler-angles 2)) 'single-float)))
	(ca (the single-float (coerce (cos (svref euler-angles 2)) 'single-float)))
	(sb (the single-float (coerce (sin (svref euler-angles 0)) 'single-float)))
	(cb (the single-float (coerce (cos (svref euler-angles 0)) 'single-float)))
	(sh (the single-float (coerce (sin (svref euler-angles 1)) 'single-float)))
	(ch (the single-float (coerce (cos (svref euler-angles 1)) 'single-float))))
  
  (setf (svref dest-matrix 0) (the single-float (* ch ca)))
  (setf (svref dest-matrix 1) (the single-float (+
						 (the single-float (* (* -1 ch) sa cb))
						 (the single-float (* sh sb)))))
  (setf (svref dest-matrix 2) (the single-float (+
						 (the single-float (* ch sa sb))
						 (the single-float (* sh cb)))))
  (setf (svref dest-matrix 3) 0.0)
  
  (setf (svref dest-matrix 4) sa)
  (setf (svref dest-matrix 5) (the single-float (* ca cb)))
  (setf (svref dest-matrix 6) (the single-float (* (* -1 ca) sb)))
  (setf (svref dest-matrix 7) 0.0)
  
  (setf (svref dest-matrix 8) (the single-float (* (* -1 sh) ca)))
  (setf (svref dest-matrix 9) (the single-float (+
						 (the single-float (* sh sa cb))
						 (the single-float (* ch sb)))))
  (setf (svref dest-matrix 10) (the single-float (+
						 (the single-float (* (* -1 sh) sa sb))
						 (the single-float (* ch cb)))))
  (setf (svref dest-matrix 11) 0.0)
  
  (setf (svref dest-matrix 12) 0.0)
  (setf (svref dest-matrix 13) 0.0)
  (setf (svref dest-matrix 14) 0.0)
  (setf (svref dest-matrix 15) 1.0)
  dest-matrix))

