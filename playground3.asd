;;;; playground3.asd

(asdf:defsystem #:playground3
  :description "Describe playground3 here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-glfw3 #:alexandria #:cl-vulkan #:cffi #:iterate)
  :components ((:file "package")
	       (:file "vulkan-type-info")
	       (:file "vulkan-structs-values")
	       (:file "vulkan-wrappers")
	       (:file "wrappers")
	       (:file "main")
	       (:file "scratch")))
