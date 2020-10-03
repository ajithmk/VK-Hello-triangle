;;;; package.lisp

(defpackage #:playground3
	(:nicknames :pg3)
	(:use #:cl #:cl-vulkan #:cl-glfw3 #:cffi #:iterate #:cl-utilities #:vocabulary #:obj-reader)
	(:shadowing-import-from #:iterate :terminate)
	(:shadowing-import-from #:cl-utilities #:collect)
	(:shadowing-import-from #:cl-utilities #:collecting))
