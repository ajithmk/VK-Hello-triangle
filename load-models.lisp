(in-package #:pg3)

(defun get-vertices-uvs-normals-indices (file)
  (let ((vertices-array (make-array 1 :fill-pointer 0))
	(normals-array (make-array 1 :fill-pointer 0))
	(uvs-array (make-array 1 :fill-pointer 0))
	(indices (make-array 1 :fill-pointer 0)))
    (with-open-file (f file)
      (iter (for line next (read f nil nil))
	    (when (not line) (terminate))
	    (cond ((eq (type-of line) 'vertex)
		   (vector-push-extend line vertices-array))
		  ((eq (type-of line) 'uv)
		   (vector-push-extend line uvs-array))
		  ((eq (type-of line) 'normal)
		   (vector-push-extend line normals-array))
		  (t
		   (vector-push-extend line indices)))))
    (values vertices-array
	    uvs-array
	    normals-array
	    indices)))
