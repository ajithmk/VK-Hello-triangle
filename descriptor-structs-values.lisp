(in-package #:pg3)


(defparameter *desc-set-layout-create-info-value* '((:s-type (:descriptor-set-layout-create-info)
						     :p-next ((null-pointer))
						     :flags (*flags*)
						     :binding-count (*binding-count*)
						     :p-bindings (((:binding (0)
								   :descriptor-type (:uniform-buffer)
								   :descriptor-count (1)
								   :stage-flags ('(:vertex :fragment))
								   :p-immutable-samplers (((null-pointer)))
					  )))
						     )))

(defparameter *desc-pool-create-info-value* '((:s-type (:descriptor-pool-create-info)
					       :p-next ((null-pointer))
					       :flags (*flags*)
					       :max-sets (*max-sets*)
					       :pool-size-count (*pool-size-count*)
					       :descriptor-pool-size (*descriptor-pool-size*)
					       )))

