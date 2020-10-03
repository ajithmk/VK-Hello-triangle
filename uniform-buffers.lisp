(in-package #:pg3)

(defun create-descriptor-set-layout (device)
  (let ((*binding-count* 1)
	(*flags* nil))
    (with-foreign-object (p-desc-layout '%vk::descriptor-set-layout)
      (vk::awith-vk-structs (
			     (layout-create-info %vk::descriptor-set-layout-create-info  *desc-set-layout-create-info-value*))
	(%vk:create-descriptor-set-layout device layout-create-info (null-pointer) p-desc-layout)
	(let ((v nil))
	  (setf v (mem-ref p-desc-layout '%vk::descriptor-set-layout))
	  (unless (null-pointer-p v) v))))))
