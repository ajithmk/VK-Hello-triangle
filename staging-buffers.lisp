(in-package #:playground3)

(defun copy-model-to-stage (device vertices normals tangents uvs indices)
  (let ((size nil))
    (setf size (+ (* (foreign-type-size '(:struct raw-vertex)) (length vertices))
		  (* (foreign-type-size :uint32) (length indices))))
  (setf *staging-buffer* (create-buffer *device* '(:transfer-src) :exclusive size))
  (store-resource "buffer" "staging-buffer" *staging-buffer*)
  (setf *staging-memory* (allocate-memory (car *phy-devices*)
					 device
					 *staging-buffer*
					 '(:host-visible :host-coherent)))
  (store-resource "device-memory" "staging-memory" *staging-memory*)
  (with-foreign-object (mapped-pointer :pointer)
    (%vk::map-memory device *staging-memory* 0 size 0 mapped-pointer)
    (fill-vk-vertex-index-buffer (mem-ref mapped-pointer :pointer)
				 vertices
				 normals
				 tangents
				 uvs
				 indices)
    (%vk::unmap-memory device *staging-memory*))
  (setf *buffer* (create-buffer *device* '(:transfer-dst :vertex-buffer :index-buffer) :exclusive size))
  (store-resource "buffer" "buffer" *buffer*)
  (setf *device-memory* (allocate-memory (car *phy-devices*)
					 device
					 *buffer*
					 '(:device-local)))
  (store-resource "device-memory" "device-memory" *device-memory*)
  (%vk::bind-buffer-memory device *buffer* *device-memory* 0)
  (%vk::bind-buffer-memory device *staging-buffer* *staging-memory* 0)
  (copy-stage-to-device device *command-pool* *staging-buffer* *buffer* size)
  ))

(defun copy-stage-to-device (device command-pool src-buffer dst-buffer size)
  (setf *staging-command-buffer* (vk:allocate-command-buffers device command-pool 1))
  (let ((*flags* '(:one-time-submit))
	(*wait-semaphore-count* 0)
	(*signal-semaphore-count* 0)
	(*command-buffer-count* 1)
	(*wait-dst-stage-mask* nil))
	(with-foreign-objects ((copy-buffer '(:struct %vk::buffer-copy))
			       (*command-buffers* '%vk::command-buffer 1)
				(*wait-semaphores* '%vk::semaphore 1)
			       (*signal-semaphores* '%vk::semaphore 1))
	  (setf (mem-ref *command-buffers* '%vk::command-buffer) (car *staging-command-buffer*))
	  (setf (mem-ref *wait-semaphores* '%vk::semaphore) (null-pointer))
	  (setf (mem-ref *signal-semaphores* '%vk::semaphore) (null-pointer))
	  (vk::awith-vk-structs ((begin-info %vk::command-buffer-begin-info *command-begin-info-value*)
				 (submit-info %vk::submit-info *submit-info-value*))
	    (setf (foreign-slot-value copy-buffer '(:struct %vk::buffer-copy) :src-offset) 0
		  (foreign-slot-value copy-buffer '(:struct %vk::buffer-copy) :dst-offset) 0
		  (foreign-slot-value copy-buffer '(:struct %vk::buffer-copy) :size) size)
	    (%vk:begin-command-buffer (car *staging-command-buffer*) begin-info)
	    (%vk:cmd-copy-buffer (car *staging-command-buffer*) src-buffer dst-buffer 1 copy-buffer)
	    (%vk:end-command-buffer (car *staging-command-buffer*))
	    (%vk:queue-submit *present-queue* 1 submit-info (null-pointer))
	    (%vk:queue-wait-idle *present-queue*)))))

