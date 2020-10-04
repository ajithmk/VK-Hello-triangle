;;;; playground3.asd

(asdf:defsystem #:playground3
  :description "Describe playground3 here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-glfw3 #:alexandria #:cl-vulkan #:cffi #:iterate #:cl-utilities #:vocabulary #:obj-reader)
  :components ((:file "package")
	       (:file "vulkan-type-info")
	       
	       (:file "temporary-math")
	       (:file "load-models")
	       
	       (:file "vulkan-structs-values")
	       (:file "command-buffer-structs-values")
	       (:file "render-structs-values")
	       (:file "descriptor-structs-values")
	       (:file "vulkan-wrappers")
	       (:file "wrappers")
	       (:file "global-vulkan-state")
	       (:file "buffer-memory")
	       (:file "staging-buffers")
	       (:file "uniform-buffers")
	       (:file "main")
	       (:file "scratch")))
