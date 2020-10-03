;;; vulkan-structs-values.lisp

(in-package #:pg3)

(defparameter *buffer-create-info-value* '((:s-type (:buffer-create-info)
					    :p-next ((null-pointer))
					    :flags (*flags*)
					    :size (*size*)
					    :usage (*buffer-usage-flags*)
					    :sharing-mode (*sharing-mode*)
					    :queue-family-index-count (0)
					    :p-queue-family-indices (nil)
					    )))

(defparameter *memory-allocate-info-value* '((:s-type (:memory-allocate-info)
					 :p-next ((null-pointer))
					 :allocation-size (*allocation-size*)
					 :memory-type-index (*memory-type-index*)
					)))

(defparameter *shader-module-value* ' ((:s-type (:shader-module-create-info)
						:p-next ((null-pointer))
						:flags (*flags*)
						:code-size (*code-size*)
						:p-code (*code-pointer*)
						)))

(defparameter *framebuffer-info-value* '((:s-type (:framebuffer-create-info)
					  :p-next ((null-pointer))
					  :flags (*flags*)
					  :render-pass (*render-pass*)
					  :attachment-count (1)
					  :p-attachments ((*attachments-pointer*))
					  :width (*width*)
					  :height (*height*)
					  :layers (1)
					 )))

