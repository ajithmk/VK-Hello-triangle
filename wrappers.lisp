(in-package #:playground3)

(defconstant MAX_UINT64 9223372036854775807)

(defparameter *width* 250)
(defparameter *height* 250)
(defparameter *resize-required-p* nil)

(cffi:defcfun ("glfwCreateWindowSurface" %create-window-surface :library %glfw::glfw) %vk:result
  (instance %vk:instance) (window :pointer) (alloc :pointer) (surface :pointer))

(cffi:defcfun ("glfwVulkanSupported" vulkan-supported) :int32)

(defparameter *window-resize-callback* #'(lambda (width height)
					   (setf *width* width)
					   (setf *height* height)
					   (setf *resize-required-p* t)))

(defcallback window-resize-callback :void ((window :pointer) (width :int32) (height :int32))
    (funcall *window-resize-callback* width height))

(defun create-window-surface (&key instance window (alloc (cffi:null-pointer)))
  (cffi:with-foreign-objects ((s '%vk:surface-khr))
    (setf (cffi:mem-ref s :pointer) (cffi:null-pointer))
    (if (eql (%create-window-surface instance window alloc s) :success)
        (cffi:mem-ref s '%vk:surface-khr))))

(defmacro with-window-instance-device-surface-swapchain-swapchainimages-prqueue (
										 instance
										 phy-devices
										 device
										 surface
										 pr-queue
										 width
										 height
										 &body body)
  `(with-init-window (:width ,width :height ,height :title "vulkan" :resizable t :client-api :no-api)
     (with-instance (,instance :layers '("VK_LAYER_KHRONOS_validation" "VK_LAYER_LUNARG_api_dump")
			       :exts '("VK_KHR_surface" "VK_KHR_xcb_surface"))
       (let ((,phy-devices nil)
	     (,pr-queue nil)
	     (,surface nil))
       (setf ,phy-devices (enumerate-physical-devices ,instance))
       (with-device (,device (car ,phy-devices) :exts '("VK_KHR_swapchain"))
	 (setf ,surface (create-window-surface :instance ,instance
					      :window glfw:*window*))
	 (setf ,pr-queue (vk::get-device-queue ,device 0 0))
	 (vk::get-physical-device-surface-support-khr (car ,phy-devices) 0 ,surface)
	 ,@body
	  (unless (null-pointer-p ,surface) (%vk:destroy-surface-khr ,instance ,surface (null-pointer)))
	  )))))
	  

(defun create-swapchain-with-images (device surface)
  (let ((swapchain nil)
	(swapchain-images nil))
	(setf swapchain (vk::create-swapchain-khr device surface *width* *height*
					      :min-image-count 2
					      :image-format :b8g8r8a8-unorm
					      :image-usage '(:color-attachment)))
	(setf swapchain-images (get-swapchain-images-khr device swapchain))
	(values swapchain swapchain-images)))


(defun create-shader-module (device file-name)
   (with-open-file (file file-name  :element-type '(unsigned-byte 8))
     (let ((file-size (file-length file)))
       (with-foreign-pointer (ptr file-size)
	 (loop for i from 0 below file-size
	    do (setf (mem-ref (inc-pointer ptr i) :uint8) (read-byte file nil)))
	 (with-foreign-objects ((sm '(:pointer :uint32)))
	      (setf (mem-ref sm '(:pointer :uint32)) (null-pointer))
	      (let ((*code-size* file-size)
		    (*code-pointer* ptr))
	     
	     (vk::awith-vk-structs ((sm-struct %vk:shader-module-create-info *shader-module-value*))
	   (%vk::create-shader-module device sm-struct (null-pointer) sm)
	 (unless (null-pointer-p sm) (mem-ref sm '(:pointer :uint32)))
	 )))))))

(defun create-render-pass (device)
  (with-foreign-objects ((renderpass '%vk::render-pass))
    (setf (mem-ref renderpass '%vk::render-pass) (null-pointer))
  (vk::awith-vk-structs ((render-pass-info %vk::render-pass-create-info *render-pass-info-value*))
  (%vk::create-render-pass device render-pass-info (null-pointer) renderpass)
    (let ((v nil))
      (setf v (mem-ref renderpass '%vk::render-pass))
      (unless (null-pointer-p v) v)
      ))))

(defun create-pipeline-layout (device)
  (with-foreign-object (layout '%vk::pipeline-layout)
    (setf (mem-ref layout '%vk:pipeline-layout) (null-pointer))
    (vk::awith-vk-structs ((layout-info %vk::pipeline-layout-create-info *pipeline-layout-value*))
      (%vk::create-pipeline-layout device layout-info (null-pointer) layout)
      (let ((v nil))
	(setf v (mem-ref layout '%vk::pipeline-layout))
	(unless (null-pointer-p v) v)
	))))

(defun create-graphics-pipeline (device vert-module frag-module pipeline-layout render-pass)
  (with-foreign-object (graphics-pipeline '%vk::pipeline)
    (setf (mem-ref graphics-pipeline '%vk::pipeline) (null-pointer))
    (let ((*vertex-module* vert-module)
	  (*fragment-module* frag-module)
	  (*pipeline-layout* pipeline-layout)
	  (*render-pass* render-pass))
    (vk::awith-vk-structs ((gpci %vk::graphics-pipeline-create-info *graphics-pipeline-value*))
      (%vk::create-graphics-pipelines device (null-pointer) 1 gpci (null-pointer) graphics-pipeline)
      (let ((v nil))
	(setf v (mem-ref graphics-pipeline '%vk::pipeline))
	(unless (null-pointer-p v) v)
	)))))

(defun create-framebuffer (device attachments render-pass)
  (with-foreign-objects ((fbuffer '%vk::framebuffer)
			 (*attachments-pointer* '%vk::image-view 1))
    (setf (mem-ref *attachments-pointer* '%vk::image-view) attachments)
    (let ((*render-pass* render-pass))
    (vk::awith-vk-structs ((framebuffer-info %vk::framebuffer-create-info *framebuffer-info-value*))
      (%vk::create-framebuffer device framebuffer-info (null-pointer) fbuffer)
      (let ((v nil))
	(setf v (mem-ref fbuffer '%vk::framebuffer))
	(unless (null-pointer-p v)
	  v
	  ))))))

(defun create-buffer (device usage-flags sharing-mode size)
  (with-foreign-object (buffer '%vk::buffer)
    (let ((*buffer-usage-flags* usage-flags)
	  (*sharing-mode* sharing-mode)
	  (*size* size))
      (vk::awith-vk-structs ((buffer-info %vk::buffer-create-info *buffer-create-info-value*))
	(setf (mem-ref buffer '%vk::buffer) (null-pointer))
	(%vk::create-buffer device buffer-info (null-pointer) buffer)
	(let ((v nil))
	  (setf v (mem-ref buffer '%vk::buffer))
	  (unless (null-pointer-p v) v))))))

(defun allocate-memory (phy-device device buffer flags-to-check)
  (declare (optimize (debug 3) (speed 0) (space 0)))
    (let ((memory-type-index nil)
	  (memory-size nil)
	  (memory-alignment nil))
      (multiple-value-setq (memory-type-index memory-size memory-alignment)
	(get-memory-details phy-device device buffer flags-to-check))
    (let ((*allocation-size* memory-size)
	  (*memory-type-index* memory-type-index))
      (with-foreign-object (device-memory '%vk::device-memory)
	(setf (mem-ref device-memory '%vk::device-memory) (null-pointer))
	(vk::awith-vk-structs ((allocate-info
				%vk::memory-allocate-info
				*memory-allocate-info-value*))
	  (%vk::allocate-memory device allocate-info (null-pointer) device-memory)
	  (let ((v nil))
	    (setf v (mem-ref device-memory '%vk::device-memory))
	    (unless (null-pointer-p v) v)))))))

(defun record-commands (command-buffer swapchain-framebuffer render-pass graphics-pipeline)
      (let ((*framebuffer* swapchain-framebuffer)
	    (*render-pass* render-pass))
	(vk::awith-vk-structs ((cmd-begin-info %vk::command-buffer-begin-info *command-begin-info-value*)
			       (render-begin-info %vk::render-pass-begin-info *render-pass-begin-info*))
	  
	  
	  (%vk:begin-command-buffer command-buffer cmd-begin-info)
	  (%vk:cmd-begin-render-pass command-buffer render-begin-info :inline)
	  (%vk:cmd-bind-pipeline command-buffer :graphics graphics-pipeline)
	  (%vk:cmd-draw command-buffer 3 1 0 0)
	  (%vk:cmd-end-render-pass command-buffer)
	  (%vk:end-command-buffer command-buffer)
	  )))

(defun submit-queue (queue wait-semaphore signal-semaphore wait-fence command-buffer)
  (let ((*wait-semaphore-count* 1)
	(*signal-semaphore-count* 1)
	(*command-buffer-count* 1))
    (with-foreign-objects ((*command-buffers* '%vk::command-buffer 1)
			   (*wait-semaphores* '%vk::semaphore 1)
			   (*signal-semaphores* '%vk::semaphore 1))
      (setf (mem-ref *command-buffers* '%vk::command-buffer) command-buffer)
      (setf (mem-ref *wait-semaphores* '%vk::semaphore) wait-semaphore)
      (setf (mem-ref *signal-semaphores* '%vk::semaphore) signal-semaphore)
    (vk::awith-vk-structs ((submit-info %vk:submit-info *submit-info-value*))
      (%vk::queue-submit queue 1 submit-info wait-fence)
      ))))

(defun present-queue (queue wait-semaphore swapchains index)
  (let ((*wait-semaphore-count* 1))
    (with-foreign-objects ((*image-index* :uint32 1)
			   (*wait-semaphores* '%vk::semaphore 1)
			   (*swapchains* '%vk::swapchain-khr 1)
			   (present-result '%vk:result))
      (setf (mem-ref *wait-semaphores* '%vk::semaphore) wait-semaphore)
      (setf (mem-ref *swapchains* '%vk::swapchain-khr) swapchains)
      (setf (mem-ref *image-index* :uint32) index)
	(vk::awith-vk-structs ((present-info %vk::present-info-khr *present-info-value*))
	  (setf present-result (%vk::queue-present-khr queue present-info))
	   present-result))))

(defun acquire-next-image-khr1 (device swap-chain timeout semaphore fence)
  (let ((result nil))
    (with-foreign-object (image-index '(:pointer :uint32))
      (setf (mem-ref image-index '(:pointer :uint32)) (null-pointer))
      (setf result (%vk::acquire-next-image-khr device swap-chain timeout semaphore fence image-index))
      (values result (mem-ref image-index :uint32)))))

(defun get-memory-details (phy-device device buffer flags-to-check)
  (declare (optimize (debug 3) (speed 0) (space 0)))
  (let* ((memory-properties (vk:get-physical-device-memory-properties phy-device))
	(found-index (iter (for el in (getf memory-properties :memory-types))
			   (with index = 0)
			   (when (and (getf el :property-flags)
				      (every #'(lambda (x) (member x (getf el :property-flags))) flags-to-check))
			     (return index))
			   (incf index)))
	 (requirements (vk::get-buffer-memory-requirements device buffer))
	 (size (getf requirements :size))
	 (alignment (getf requirements :alignment))
	 (memory-type-bits (getf requirements :memory-type-bits)))
    (if (char= (elt (reverse (format nil "~B" memory-type-bits)) found-index) #\1)
	(values found-index size alignment)
	(error "proper memory type not found"))))

;(defun get-memory-heaps (phy-device)
 ; (let ((memory-properties (vk:get-physical-device-memory-properties phy-device)))
  ;  (iter (for el in (getf *memory-properties* :memory-heaps))
;	   (if (and (getf el :flags)
;		    (not (equal 0 (getf el :size)))) (collect (list (getf el :flags)
					;

(defun recreate-swapchain()
  (device-wait-idle *device*)
  (destroy-swapchain-resources *instance* *device*)
  (setf *command-buffers* '())
  (setf *swapchain-image-views* '())
  (setf *swapchain-framebuffers* '())
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
	(record-commands command-buffer swapchain-framebuffer *render-pass* *graphics-pipeline*)))


(defun free-command-buffers ()
  (with-foreign-objects ((buffers '%vk:command-buffer (length *command-buffers*)))
    (iter (for i from 0 below (length *command-buffers*))
	  (setf (mem-ref (inc-pointer buffers (* i (foreign-type-size '%vk:command-buffer))) '%vk:command-buffer)
		(nth i *command-buffers*)))
    (vk::free-command-buffers *device* *command-pool* *command-buffers*)))

(defun destroy-swapchain-resources (instance device)
  (vk::free-command-buffers *device* *command-pool* *command-buffers*)
    (loop
     for v being the hash-values in *vulkan-state-book* using (hash-key k)
     do (cond 
	      ((equalp "framebuffer" k)
	       (loop
		  for (nil . resource) in v
		  unless (null-pointer-p resource)
		  do (%vk::destroy-framebuffer device resource (null-pointer))))
	      ((equalp "graphics-pipeline" k)
	       (loop
		  for (nil . resource) in v
		  unless (null-pointer-p resource)
		  do (%vk::destroy-pipeline device resource (null-pointer))))
	      ((equalp "pipeline-layout" k)
	       (loop
		  for (nil . resource) in v
		  unless (null-pointer-p resource)
		  do (%vk::destroy-pipeline-layout device resource (null-pointer))))
	      ((equalp "renderpass" k)
	       (loop
		  for (nil . resource) in v
		  unless (null-pointer-p resource)
		  do (%vk::destroy-render-pass device resource (null-pointer))))
	      ((equalp "image-view" k)
	       (loop
		  for (nil . resource) in v
		  unless (null-pointer-p resource)
		  do (%vk::destroy-image-view device resource (null-pointer))))
	      ((equalp "swapchain" k)
	       (loop
		  for (nil . resource) in v
		  unless (null-pointer-p resource)
		  do (%vk:destroy-swapchain-khr device resource (null-pointer))))
	      ))
    (let ((to-remove-list '("renderpass"
			    "graphics-pipeline"
			    "framebuffer"
			    "image-view"
			    "command-buffer"
			    "swapchain"
			    "pipeline-layout")))
    (iter (for (key value) in-hashtable *vulkan-state-book*)
	  (if (member key to-remove-list :test #'equal) (setf (gethash key *vulkan-state-book*) nil)))))

(defun destroy-resources (instance device)
  (loop
     for v being the hash-values in *vulkan-state-book* using (hash-key k)
     do (cond ((equalp "shader" k)
	       (loop
		  for (nil . resource) in v
		  unless (null-pointer-p resource)
		  do (%vk::destroy-shader-module device resource (null-pointer))))
	      ((equalp "semaphore" k)
	       (loop
		  for (nil . resource) in v
		  unless (null-pointer-p resource)
		  do (%vk:destroy-semaphore device resource (null-pointer))))
	      ((equalp "fence" k)
	       (loop
		  for (nil . resource) in v
		  unless (null-pointer-p resource)
		  do (%vk:destroy-fence device resource (null-pointer))))
	      ((equalp "buffer" k)
	       (loop
		  for (nil . resource) in v
		  unless (null-pointer-p resource)
		  do (%vk:destroy-buffer device resource (null-pointer))))
	      ((equalp "device-memory" k)
	       (loop
		  for (nil . resource) in v
		  unless (null-pointer-p resource)
		  do (%vk:free-memory device resource (null-pointer))))
	       )
       )
  (let ((to-remove-list '("shader"
			  "semaphore"
			  "fence"
			  "buffer"
			  "device-memory")))
    (iter (for (key value) in-hashtable *vulkan-state-book*)
	  (if (member key to-remove-list :test #'equal) (setf (gethash key *vulkan-state-book*) nil))))
  (destroy-swapchain-resources instance device))

(defun reset-hash-table (table)
  (loop
     for key being the hash-keys in table
     do (setf (gethash key table) nil)))

(defun store-resource (type name resource)
  (setf (gethash type *vulkan-state-book*)
	 (acons name resource (gethash type *vulkan-state-book*))))

(defun remove-resource (type name)
  (let ((a-list (gethash type *vulkan-state-book*)))
    (setf (gethash type *vulkan-state-book*) (delete-if #'(lambda (element) (string= name (car element)))
	       a-list))))

