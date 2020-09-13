(in-package #:playground3)

(defparameter *vulkan-state-book* (make-hash-table :test 'equalp))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Alright, if you have come to such
;;a state of affairs, you need to think
;;about the architecture of your application
(defparameter *phy-device* nil)
(defparameter *device* nil)
(defparameter *instance* nil)
(defparameter *surface* nil)
(defparameter *present-queue* nil)

(defparameter *swapchain* nil)
(defparameter *swapchain-images* nil)
(defparameter *swapchain-image-views* '())
(defparameter *swapchain-framebuffers* '())

(defparameter *command-pool* nil)
(defparameter *command-buffers* '())

(defparameter *render-pass* nil)
(defparameter *pipeline-layout* nil)
(defparameter *graphics-pipeline* nil)

(defparameter *vertex-shader* nil)
(defparameter *fragment-shader* nil)

(defparameter *semaphores* '())
(defparameter *fences* '())

(defparameter *buffer* '())

(defparameter *device-memory* '())
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun main()
  (declare (optimize (debug 3) (speed 0) (safety 0)))
  ;;(setf *width* 250)
  ;;(setf *height* 250)
  (with-window-instance-device-surface-swapchain-swapchainimages-prqueue *instance*
      *phy-devices*
      *device*
      *surface*
      *present-queue*
      *width*
      *height*
      
    (reset-hash-table *vulkan-state-book*)

    (vk::with-command-pool (*command-pool* *device* :queue-family 0)
      
	(let ((index 0)
	      (acquire-result nil)
	      (present-result nil)
	      (render-complete-semaphores '())
	      (presentation-complete-semaphores '())
	      (wait-fences '())
	      (buffer nil)
	      (mem-requirements nil)
	      (device-memory nil))

	  (setf *command-buffers* '())
	  (setf *swapchain-image-views* '())
	  (setf *swapchain-framebuffers* '())
	  (glfw:set-window-size-callback 'window-resize-callback)
	  (setf *resize-required-p* nil)
	  (setf *semaphores* '())
	  (setf *fences* '())
	  (setf *buffer* '())
	  (setf *device-memory* '())

	  ;(setf *buffer* (create-buffer *device* '(:vertex-buffer) :exclusive 100))
	  ;(store-resource "buffer" "buffer1" *buffer*)
	  ;(get-memory-details (car *phy-devices*) *device* *buffer* '(:host-visible :host-coherent))
	  ;;(break)
	  ;(setf *device-memory* (allocate-memory (car *phy-devices*)
	;					 *device*
	;					 *buffer*
	;					 '(:host-visible :host-coherent)))
	 ; (store-resource "device-memory" "device-memory1" *device-memory*)
	  
	  (multiple-value-setq (*swapchain* *swapchain-images*) (create-swapchain-with-images *device* *surface*))
	  (store-resource "swapchain" "swapchain" *swapchain*)
	  (setf *command-buffers* (vk:allocate-command-buffers *device* *command-pool* 2 :level :primary))
	  (store-resource "command-buffer" "command-buffer1" (car *command-buffers*))
	   (store-resource "command-buffer" "command-buffer1" (cadr *command-buffers*))
	
	;;(setf swap-chain-images (nreverse swap-chain-images))
	(loop for image in *swapchain-images*
	   do (push (create-image-view *device* image :format :b8g8r8a8-unorm) *swapchain-image-views*))
	(setf *swapchain-image-views* (nreverse *swapchain-image-views*))
	(store-resource "image-view" "swapchain-image-view1" (car *swapchain-image-views*))
	(store-resource "image-view" "swapchain-image-view2" (cadr *swapchain-image-views*))
	(setf *vertex-shader* (create-shader-module *device* #P"/media/ajith/Lindows/lisp-projects/playground2/vert.spv" ))
	(setf *fragment-shader* (create-shader-module *device* #P"/media/ajith/Lindows/lisp-projects/playground2/frag.spv"))
	(store-resource "shader" "vertex-shader" *vertex-shader*)
	(store-resource "shader" "fragment-shader" *fragment-shader*)
	(setf *render-pass* (create-render-pass *device*))
	(store-resource "renderpass" "render-pass" *render-pass*)
	(setf *pipeline-layout* (create-pipeline-layout *device*))
	(store-resource "pipeline-layout" "pipeline-layout" *pipeline-layout*)
	(setf *graphics-pipeline* (create-graphics-pipeline *device* *vertex-shader*
							  *fragment-shader* *pipeline-layout* *render-pass*))
	(store-resource "graphics-pipeline" "graphics-pipeline" *graphics-pipeline*)
	(loop for image-view in *swapchain-image-views*
	   do (push (create-framebuffer *device* image-view *render-pass*) *swapchain-framebuffers*))
	(setf *swapchain-framebuffers* (nreverse *swapchain-framebuffers*))
	(store-resource "framebuffer" "swapchain-framebuffer1" (car *swapchain-framebuffers*))
	(store-resource "framebuffer" "swapchain-framebuffer2" (cadr *swapchain-framebuffers*))
	(iter (for command-buffer in *command-buffers*)
	      (for swapchain-framebuffer in *swapchain-framebuffers*)
	      (record-commands command-buffer swapchain-framebuffer *render-pass* *graphics-pipeline*))
	
	(iter (for i from 0 below 4)
	      (push (vk::create-semaphore *device*) *semaphores*))
	(store-resource "semaphore" "semaphore1" (nth 0 *semaphores*))
	(store-resource "semaphore" "semaphore2" (nth 1 *semaphores*))
	(store-resource "semaphore" "semaphore3" (nth 2 *semaphores*))
	(store-resource "semaphore" "semaphore4" (nth 3 *semaphores*))
	(iter (for i from 0 below 2)
	      (push (vk::create-fence *device* :signaled t) *fences*))
	(store-resource "fence" "fence1" (nth 0 *fences*))
	(store-resource "fence" "fence2" (nth 1 *fences*))
	(push (nth 0 *semaphores*) render-complete-semaphores)
	(push (nth 1 *semaphores*) render-complete-semaphores)
	(push (nth 2 *semaphores*) presentation-complete-semaphores)
	(push (nth 3 *semaphores*) presentation-complete-semaphores)
	(push (nth 0 *fences*) wait-fences)
	(push (nth 1 *fences*) wait-fences)
	
	(let ((current-fence '()))
	    (iter (until (window-should-close-p))
	       (poll-events)
	       (multiple-value-setq (acquire-result index)
		    (acquire-next-image-khr1 *device* *swapchain*
					     MAX_UINT64
					     (nth 0 presentation-complete-semaphores)
					     (null-pointer)))
	       (pop current-fence)
	       (push (nth index wait-fences) current-fence)
	       (vk::wait-for-fences *device* current-fence t MAX_UINT64)
	       (vk::reset-fences *device* current-fence)
	       (when (or
		       (eql acquire-result :error-out-of-date-khr))
		 (recreate-swapchain)
		 (next-iteration))
	       (when (and (not (eql acquire-result :success))
			   (not (eql acquire-result :error-out-of-date-khr))
			   (not (eql acquire-result :suboptimal-khr)))
		 (break))
	       (submit-queue *present-queue*
				(nth 0 presentation-complete-semaphores)
				(nth 0 render-complete-semaphores)
				(nth index wait-fences)
				(nth index *command-buffers*))
	       (setf present-result (present-queue *present-queue*
						   (nth 0 render-complete-semaphores)
						   *swapchain*
						   index))
	       (when (or
		       (eql present-result :error-out-of-date-khr)
		       (eql present-result :suboptimal-khr)
		       *resize-required-p*)
		 (recreate-swapchain)
		 (setf *resize-required-p* nil))
	       (when (and (not (eql acquire-result :success))
			  (not (eql acquire-result :error-out-of-date-khr))
			  (not (eql acquire-result :suboptimal-khr)))
		 (break))
	       ;;(queue-wait-idle *present-queue*)
	       ))
	(device-wait-idle *device*)
	(destroy-resources *instance* *device*)))))