(in-package #:playground3)


(defun fill-vk-vertex-index-buffer (mapped-pointer vertices normals tangents uvs indices)
  (let ((size nil))
    (setf size (+ (* (foreign-type-size '(:struct raw-vertex)) (length vertices))
		  (* (foreign-type-size :uint32) (length indices))))
    (iter (for index from 0 below (length vertices))
	  (with current-struct-pointer)
	  (with current-normal-pointer)
	  (with current-tangent-pointer)
	  (with current-uv-pointer)
	  (setf current-struct-pointer (inc-pointer mapped-pointer (* index
							       (foreign-type-size '(:struct raw-vertex)))))
	  (setf (mem-aref current-struct-pointer :float 0) (vertex-x (elt vertices index)))
	  (setf (mem-aref current-struct-pointer :float 1) (vertex-y (elt vertices index)))
	  (setf (mem-aref current-struct-pointer :float 2) (vertex-z (elt vertices index)))
	  (setf (mem-aref current-struct-pointer :float 3) (vertex-w (elt vertices index)))

	  (when normals
	      (setf current-normal-pointer (foreign-slot-value
					    current-struct-pointer
					    '(:struct raw-vertex) 'normal))
	    (setf (mem-aref current-normal-pointer :float 0) (normal-x (elt normals index)))
	    (setf (mem-aref current-normal-pointer :float 1) (normal-y (elt normals index)))
	    (setf (mem-aref current-normal-pointer :float 2) (normal-z (elt normals index))))

	  (when tangents
	  (setf current-tangent-pointer (foreign-slot-value
					current-struct-pointer
					'(:struct raw-vertex) 'tangent))
	  (setf (mem-aref current-tangent-pointer :float 0) (tangent-x (elt tangents index)))
	  (setf (mem-aref current-tangent-pointer :float 1) (tangent-y (elt tangents index)))
	  (setf (mem-aref current-tangent-pointer :float 2) (tangent-z (elt tangents index))))

	  (when uvs
	  (setf current-uv-pointer (foreign-slot-value
					current-struct-pointer
					'(:struct raw-vertex) 'uv))
	  (setf (mem-aref current-uv-pointer :float 0) (uv-u (elt uvs index)))
	  (setf (mem-aref current-uv-pointer :float 1) (uv-v (elt uvs index)))))

    (iter (for index from 0 below (length indices))
	  (with current-pointer = (inc-pointer mapped-pointer (* (foreign-type-size '(:struct raw-vertex)) (length vertices))))
	  (setf (mem-aref current-pointer :uint32 index) (elt indices index)))
		))
