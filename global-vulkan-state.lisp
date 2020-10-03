(in-package #:pg3)

(defparameter *vulkan-state-book* (make-hash-table :test 'equalp))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Alright, if you have come to such
;;a state of affairs, you need to think
;;about the architecture of your application
(defparameter *phy-devices* nil)
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
(defparameter *staging-command-buffer* nil)

(defparameter *render-pass* nil)
(defparameter *descriptor-set-layout* nil)
(defparameter *pipeline-layout* nil)
(defparameter *graphics-pipeline* nil)

(defparameter *vertex-shader* nil)
(defparameter *fragment-shader* nil)

(defparameter *semaphores* '())
(defparameter *fences* '())

(defparameter *buffer* '())
(defparameter *staging-buffer* '())

(defparameter *device-memory* '())
(defparameter *staging-memory* '())

(defparameter *cffi-pointer* nil)

(defparameter *vertices* nil)
(defparameter *normals* nil)
(defparameter *uvs* nil)
(defparameter *indices* nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
