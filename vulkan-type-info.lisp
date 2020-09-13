;;;; vulkan-type-info.lisp

(in-package #:cl-vulkan)

(declaim (optimize (debug 3) (speed 0) (space 0)))

(proclaim '(optimize debug))

(defparameter *total-unions* '(%vk:clear-value
			       %vk:clear-color-value))

(defparameter *total-structs* '(%vk:xlib-surface-create-info-khr 
				%vk:xcb-surface-create-info-khr
				%vk:x-y-color-ext 
				%vk:write-descriptor-set 
				%vk:descriptor-buffer-info
				%vk:descriptor-image-info 
				%vk:win32-surface-create-info-khr
				%vk:win32-keyed-mutex-acquire-release-info-nv
				%vk:win32-keyed-mutex-acquire-release-info-khx
				%vk:wayland-surface-create-info-khr 
				%vk:viewport-w-scaling-nv
				%vk:viewport-swizzle-nv 
				%vk:viewport 
				%vk:vi-surface-create-info-nn
				%vk:vertex-input-binding-description 
				%vk:vertex-input-attribute-description
				%vk:validation-flags-ext 
				%vk:texture-l-o-d-gather-format-properties-amd
				%vk:swapchain-create-info-khr 
				%vk:swapchain-counter-create-info-ext
				%vk:surface-format-2-khr 
				%vk:surface-format-khr
				%vk:surface-capabilities-2-khr
				%vk:surface-capabilities-khr 
				%vk:surface-capabilities-2-ext
				%vk:subresource-layout 
				%vk:subpass-description 
				%vk:subpass-dependency
				%vk:submit-info 
				%vk:stencil-op-state 
				%vk:specialization-map-entry
				%vk:specialization-info 
				%vk:sparse-memory-bind
				%vk:sparse-image-opaque-memory-bind-info 
				%vk:sparse-image-memory-requirements
				%vk:sparse-image-memory-bind-info 
				%vk:sparse-image-memory-bind
				%vk:sparse-image-format-properties-2-khr 
				%vk:sparse-image-format-properties
				%vk:sparse-buffer-memory-bind-info
				%vk:shared-present-surface-capabilities-khr 
				%vk:shader-module-create-info
				%vk:semaphore-create-info 
				%vk:sampler-create-info
				%vk:render-pass-multiview-create-info-khx 
				%vk:render-pass-create-info
				%vk:subpass-dependency 
				%vk:subpass-description 
				%vk:attachment-reference
				%vk:attachment-description 
				%vk:render-pass-begin-info
				%vk:refresh-cycle-duration-google 
				%vk:rect-layer-khr 
				%vk:rect-3d 
				%vk:queue-family-properties-2-khr 
				%vk:queue-family-properties
				%vk:query-pool-create-info 
				%vk:push-constant-range
				%vk:present-times-info-google 
				%vk:present-time-google
				%vk:present-regions-khr 
				%vk:present-region-khr 
				%vk:rect-layer-khr 
				%vk:present-info-khr
				%vk:pipeline-viewport-w-scaling-state-create-info-nv
				%vk:viewport-w-scaling-nv 
				%vk:pipeline-viewport-swizzle-state-create-info-nv
				%vk:viewport-swizzle-nv 
				%vk:pipeline-viewport-state-create-info
				%vk:pipeline-vertex-input-state-create-info
				%vk:pipeline-tessellation-state-create-info
				%vk:pipeline-shader-stage-create-info
				%vk:pipeline-rasterization-state-rasterization-order-amd
				%vk:pipeline-rasterization-state-create-info
				%vk:pipeline-multisample-state-create-info 
				%vk:pipeline-layout-create-info
				%vk:push-constant-range 
				%vk:pipeline-input-assembly-state-create-info
				%vk:pipeline-dynamic-state-create-info
				%vk:pipeline-discard-rectangle-state-create-info-ext
				%vk:pipeline-depth-stencil-state-create-info
				%vk:pipeline-color-blend-state-create-info
				%vk:pipeline-color-blend-attachment-state 
				%vk:pipeline-cache-create-info
				%vk:physical-device-surface-info-2-khr 
				%vk:physical-device-sparse-properties
				%vk:physical-device-sparse-image-format-info-2-khr
				%vk:physical-device-push-descriptor-properties-khr
				%vk:physical-device-properties-2-khr 
				%vk:physical-device-properties
				%vk:physical-device-properties 
				%vk:physical-device-sparse-properties
				%vk:physical-device-limits 
				%vk:physical-device-multiview-properties-khx
				%vk:physical-device-multiview-per-view-attributes-properties-nvx
				%vk:physical-device-multiview-features-khx
				%vk:physical-device-memory-properties-2-khr
				%vk:physical-device-memory-properties 
				%vk:physical-device-memory-properties
				%vk:memory-heap 
				%vk:memory-type 
				%vk:physical-device-limits
				%vk:physical-device-image-format-info-2-khr
				%vk:physical-device-id-properties-khx
				%vk:physical-device-group-properties-khx 
				%vk:physical-device-features-2-khr
				%vk:physical-device-features 
				%vk:physical-device-external-semaphore-info-khx
				%vk:physical-device-external-image-format-info-khx
				%vk:physical-device-external-buffer-info-khx
				%vk:physical-device-discard-rectangle-properties-ext
				%vk:past-presentation-timing-google 
				%vk:offset-3d 
				%vk:offset-2d
				%vk:object-table-vertex-buffer-entry-nvx
				%vk:object-table-push-constant-entry-nvx 
				%vk:object-table-pipeline-entry-nvx
				%vk:object-table-index-buffer-entry-nvx 
				%vk:object-table-entry-nvx
				%vk:object-table-descriptor-set-entry-nvx 
				%vk:object-table-create-info-nvx
				%vk:mir-surface-create-info-khr 
				%vk:memory-win32-handle-properties-khx
				%vk:memory-type %vk:memory-requirements 
				%vk:memory-heap
				%vk:memory-fd-properties-khx 
				%vk:memory-barrier 
				%vk:memory-allocate-info
				%vk:memory-allocate-flags-info-khx 
				%vk:mapped-memory-range
				%vk:mac-o-s-surface-create-info-mvk 
				%vk:layer-properties
				%vk:instance-create-info 
				%vk:application-info 
				%vk:indirect-commands-token-nvx
				%vk:indirect-commands-layout-token-nvx
				%vk:indirect-commands-layout-create-info-nvx
				%vk:indirect-commands-layout-token-nvx
				%vk:import-semaphore-win32-handle-info-khx 
				%vk:import-semaphore-fd-info-khx
				%vk:import-memory-win32-handle-info-nv
				%vk:import-memory-win32-handle-info-khx 
				%vk:import-memory-fd-info-khx
				%vk:image-view-create-info 
				%vk:component-mapping
				%vk:image-swapchain-create-info-khx 
				%vk:image-subresource-range
				%vk:image-subresource-layers 
				%vk:image-subresource 
				%vk:image-resolve
				%vk:image-memory-barrier 
				%vk:image-subresource-range
				%vk:image-format-properties-2-khr 
				%vk:image-format-properties
				%vk:image-create-info 
				%vk:image-copy 
				%vk:image-blit
				%vk:i-o-s-surface-create-info-mvk 
				%vk:hdr-metadata-ext 
				%vk:x-y-color-ext
				%vk:graphics-pipeline-create-info 
				%vk:pipeline-dynamic-state-create-info
				%vk:pipeline-color-blend-state-create-info
				%vk:pipeline-color-blend-attachment-state
				%vk:pipeline-depth-stencil-state-create-info 
				%vk:stencil-op-state
				%vk:pipeline-multisample-state-create-info
				%vk:pipeline-rasterization-state-create-info
				%vk:pipeline-viewport-state-create-info 
				%vk:viewport
				%vk:pipeline-tessellation-state-create-info
				%vk:pipeline-input-assembly-state-create-info
				%vk:pipeline-vertex-input-state-create-info
				%vk:vertex-input-attribute-description 
				%vk:vertex-input-binding-description
				%vk:framebuffer-create-info 
				%vk:format-properties-2-khr 
				%vk:format-properties
				%vk:format-properties 
				%vk:fence-create-info
				%vk:external-semaphore-properties-khx 
				%vk:external-memory-properties-khx
				%vk:external-memory-image-create-info-nv
				%vk:external-memory-image-create-info-khx
				%vk:external-memory-buffer-create-info-khx
				%vk:external-image-format-properties-nv 
				%vk:image-format-properties
				%vk:external-image-format-properties-khx 
				%vk:external-buffer-properties-khx
				%vk:external-memory-properties-khx 
				%vk:extent-3d 
				%vk:extent-2d
				%vk:extension-properties 
				%vk:export-semaphore-win32-handle-info-khx
				%vk:export-semaphore-create-info-khx 
				%vk:export-memory-win32-handle-info-nv
				%vk:export-memory-win32-handle-info-khx 
				%vk:export-memory-allocate-info-nv
				%vk:export-memory-allocate-info-khx 
				%vk:event-create-info
				%vk:draw-indirect-command 
				%vk:draw-indexed-indirect-command
				%vk:display-surface-create-info-khr 
				%vk:display-properties-khr
				%vk:display-present-info-khr 
				%vk:display-power-info-ext
				%vk:display-plane-properties-khr 
				%vk:display-plane-capabilities-khr
				%vk:display-mode-properties-khr 
				%vk:display-mode-parameters-khr
				%vk:display-mode-create-info-khr 
				%vk:display-mode-parameters-khr
				%vk:display-event-info-ext 
				%vk:dispatch-indirect-command
				%vk:device-queue-create-info 
				%vk:device-group-swapchain-create-info-khx
				%vk:device-group-submit-info-khx 
				%vk:device-group-render-pass-begin-info-khx
				%vk:device-group-present-info-khx 
				%vk:device-group-present-capabilities-khx
				%vk:device-group-device-create-info-khx
				%vk:device-group-command-buffer-begin-info-khx
				%vk:device-group-bind-sparse-info-khx
				%vk:device-generated-commands-limits-nvx
				%vk:device-generated-commands-features-nvx 
				%vk:device-event-info-ext
				%vk:device-create-info 
				%vk:physical-device-features
				%vk:device-queue-create-info 
				%vk:descriptor-update-template-entry-khr
				%vk:descriptor-update-template-create-info-khr
				%vk:descriptor-update-template-entry-khr
				%vk:descriptor-set-layout-create-info 
				%vk:descriptor-set-layout-binding
				%vk:descriptor-set-layout-binding 
				%vk:descriptor-set-allocate-info
				%vk:descriptor-pool-size 
				%vk:descriptor-pool-create-info
				%vk:descriptor-pool-size 
				%vk:descriptor-image-info 
				%vk:descriptor-buffer-info
				%vk:dedicated-allocation-memory-allocate-info-nv
				%vk:dedicated-allocation-image-create-info-nv
				%vk:dedicated-allocation-buffer-create-info-nv
				%vk:debug-report-callback-create-info-ext
				%vk:debug-marker-object-tag-info-ext 
				%vk:debug-marker-object-name-info-ext
				%vk:debug-marker-marker-info-ext 
				%vk:d-3d-1-2-fence-submit-info-khx
				%vk:copy-descriptor-set 
				%vk:compute-pipeline-create-info
				%vk:pipeline-shader-stage-create-info 
				%vk:specialization-info
				%vk:specialization-map-entry 
				%vk:component-mapping
				%vk:command-pool-create-info 
				%vk:command-buffer-inheritance-info
				%vk:command-buffer-begin-info 
				%vk:command-buffer-inheritance-info
				%vk:command-buffer-allocate-info 
				%vk:cmd-reserve-space-for-commands-info-nvx
				%vk:cmd-process-commands-info-nvx 
				%vk:indirect-commands-token-nvx
				%vk:clear-rect 
				%vk:clear-depth-stencil-value 
				%vk:clear-attachment
				%vk:clear-depth-stencil-value 
				%vk:buffer-view-create-info
				%vk:buffer-memory-barrier 
				%vk:buffer-image-copy 
				%vk:image-subresource-layers
				%vk:buffer-create-info 
				%vk:buffer-copy 
				%vk:bind-sparse-info
				%vk:sparse-image-memory-bind-info 
				%vk:sparse-image-memory-bind 
				%vk:extent-3d
				%vk:offset-3d 
				%vk:image-subresource 
				%vk:sparse-image-opaque-memory-bind-info
				%vk:sparse-buffer-memory-bind-info 
				%vk:sparse-memory-bind
				%vk:bind-image-memory-swapchain-info-khx 
				%vk:bind-image-memory-info-khx
				%vk:rect-2d 
				%vk:extent-2d 
				%vk:offset-2d 
				%vk:bind-buffer-memory-info-khx
				%vk:attachment-reference 
				%vk:attachment-description 
				%vk:application-info
				%vk:android-surface-create-info-khr 
				%vk:allocation-callbacks
				%vk:acquire-next-image-info-khx 
				%vk::security_attributes
				%vk::wl_surface
				%vk::wl_display))

(defparameter *total-bitfields* '(%vk:xlib-surface-create-flags-khr
				  %vk:xcb-surface-create-flags-khr
				  %vk:win32-surface-create-flags-khr
				  %vk:wayland-surface-create-flags-khr
				  %vk:vi-surface-create-flags-nn
				  %vk:swapchain-create-flags-khr
				  %vk:swapchain-create-flag-bits-khr
				  %vk:surface-transform-flags-khr
				  %vk:surface-transform-flag-bits-khr
				  %vk:surface-counter-flags-ext
				  %vk:surface-counter-flag-bits-ext
				  %vk:subpass-description-flags
				  %vk:subpass-description-flag-bits
				  %vk:stencil-face-flags
				  %vk:stencil-face-flag-bits
				  %vk:sparse-memory-bind-flags
				  %vk:sparse-memory-bind-flag-bits
				  %vk:sparse-image-format-flags
				  %vk:sparse-image-format-flag-bits
				  %vk:shader-stage-flags
				  %vk:shader-stage-flag-bits
				  %vk:shader-module-create-flags
				  %vk:semaphore-create-flags
				  %vk:sampler-create-flags
				  %vk:sample-count-flags
				  %vk:sample-count-flag-bits
				  %vk:render-pass-create-flags
				  %vk:queue-flags
				  %vk:queue-flag-bits
				  %vk:query-result-flags
				  %vk:query-result-flag-bits
				  %vk:query-pool-create-flags
				  %vk:query-pipeline-statistic-flags
				  %vk:query-pipeline-statistic-flag-bits
				  %vk:query-control-flags
				  %vk:query-control-flag-bits
				  %vk:pipeline-viewport-swizzle-state-create-flags-nv
				  %vk:pipeline-viewport-state-create-flags
				  %vk:pipeline-vertex-input-state-create-flags
				  %vk:pipeline-tessellation-state-create-flags
				  %vk:pipeline-stage-flags
				  %vk:pipeline-stage-flag-bits
				  %vk:pipeline-shader-stage-create-flags
				  %vk:pipeline-rasterization-state-create-flags
				  %vk:pipeline-multisample-state-create-flags
				  %vk:pipeline-layout-create-flags
				  %vk:pipeline-input-assembly-state-create-flags
				  %vk:pipeline-dynamic-state-create-flags
				  %vk:pipeline-discard-rectangle-state-create-flags-ext
				  %vk:pipeline-depth-stencil-state-create-flags
				  %vk:pipeline-create-flags
				  %vk:pipeline-create-flag-bits
				  %vk:pipeline-color-blend-state-create-flags
				  %vk:pipeline-cache-create-flags
				  %vk:peer-memory-feature-flags-khx
				  %vk:peer-memory-feature-flag-bits-khx
				  %vk:object-entry-usage-flags-nvx
				  %vk:object-entry-usage-flag-bits-nvx
				  %vk:mir-surface-create-flags-khr
				  %vk:memory-property-flags
				  %vk:memory-property-flag-bits
				  %vk:memory-map-flags
				  %vk:memory-heap-flags
				  %vk:memory-heap-flag-bits
				  %vk:memory-allocate-flags-khx
				  %vk:memory-allocate-flag-bits-khx
				  %vk:mac-o-s-surface-create-flags-mvk
				  %vk:instance-create-flags
				  %vk:indirect-commands-layout-usage-flags-nvx
				  %vk:indirect-commands-layout-usage-flag-bits-nvx
				  %vk:image-view-create-flags
				  %vk:image-usage-flags
				  %vk:image-usage-flag-bits
				  %vk:image-create-flags
				  %vk:image-create-flag-bits
				  %vk:image-aspect-flags
				  %vk:image-aspect-flag-bits
				  %vk:i-o-s-surface-create-flags-mvk
				  %vk:framebuffer-create-flags
				  %vk:format-feature-flags
				  %vk:format-feature-flag-bits
				  %vk:fence-create-flags
				  %vk:fence-create-flag-bits
				  %vk:external-semaphore-handle-type-flags-khx
				  %vk:external-semaphore-handle-type-flag-bits-khx
				  %vk:external-semaphore-feature-flags-khx
				  %vk:external-semaphore-feature-flag-bits-khx
				  %vk:external-memory-handle-type-flags-nv
				  %vk:external-memory-handle-type-flags-khx
				  %vk:external-memory-handle-type-flag-bits-nv
				  %vk:external-memory-handle-type-flag-bits-khx
				  %vk:external-memory-feature-flags-nv
				  %vk:external-memory-feature-flags-khx
				  %vk:external-memory-feature-flag-bits-nv
				  %vk:external-memory-feature-flag-bits-khx
				  %vk:event-create-flags
				  %vk:display-surface-create-flags-khr
				  %vk:display-plane-alpha-flags-khr
				  %vk:display-plane-alpha-flag-bits-khr
				  %vk:display-mode-create-flags-khr
				  %vk:device-queue-create-flags
				  %vk:device-group-present-mode-flags-khx
				  %vk:device-group-present-mode-flag-bits-khx
				  %vk:device-create-flags
				  %vk:descriptor-update-template-create-flags-khr
				  %vk:descriptor-set-layout-create-flags
				  %vk:descriptor-set-layout-create-flag-bits
				  %vk:descriptor-pool-reset-flags
				  %vk:descriptor-pool-create-flags
				  %vk:descriptor-pool-create-flag-bits
				  %vk:dependency-flags
				  %vk:dependency-flag-bits
				  %vk:debug-report-flags-ext
				  %vk:debug-report-flag-bits-ext
				  %vk:cull-mode-flags
				  %vk:cull-mode-flag-bits
				  %vk:composite-alpha-flags-khr
				  %vk:composite-alpha-flag-bits-khr
				  %vk:command-pool-trim-flags-khr
				  %vk:command-pool-reset-flags
				  %vk:command-pool-reset-flag-bits
				  %vk:command-pool-create-flags
				  %vk:command-pool-create-flag-bits
				  %vk:command-buffer-usage-flags
				  %vk:command-buffer-usage-flag-bits
				  %vk:command-buffer-reset-flags
				  %vk:command-buffer-reset-flag-bits
				  %vk:color-component-flags
				  %vk:color-component-flag-bits
				  %vk:buffer-view-create-flags
				  %vk:buffer-usage-flags
				  %vk:buffer-usage-flag-bits
				  %vk:buffer-create-flags
				  %vk:buffer-create-flag-bits
				  %vk:attachment-description-flags
				  %vk:attachment-description-flag-bits
				  %vk:android-surface-create-flags-khr
				  %vk:access-flags
				  %vk:access-flag-bits))

(defparameter *total-enums* '(%vk:viewport-coordinate-swizzle-nv
			      %vk:vertex-input-rate
			      %vk:validation-check-ext
			      %vk:system-allocation-scope
			      %vk:subpass-contents
			      %vk:structure-type
			      %vk:stencil-op
			      %vk:sharing-mode
			      %vk:sampler-mipmap-mode
			      %vk:sampler-address-mode
			      %vk:result
			      %vk:rasterization-order-amd
			      %vk:query-type
			      %vk:primitive-topology
			      %vk:present-mode-khr
			      %vk:polygon-mode
			      %vk:pipeline-cache-header-version
			      %vk:pipeline-bind-point
			      %vk:physical-device-type
			      %vk:object-type
			      %vk:object-entry-type-nvx
			      %vk:logic-op
			      %vk:internal-allocation-type
			      %vk:indirect-commands-token-type-nvx
			      %vk:index-type
			      %vk:image-view-type
			      %vk:image-type
			      %vk:image-tiling
			      %vk:image-layout
			      %vk:front-face
			      %vk:format
			      %vk:filter
			      %vk:dynamic-state
			      %vk:display-power-state-ext
			      %vk:display-event-type-ext
			      %vk:discard-rectangle-mode-ext
			      %vk:device-event-type-ext
			      %vk:descriptor-update-template-type-khr
			      %vk:descriptor-type
			      %vk:debug-report-object-type-ext
			      %vk:component-swizzle
			      %vk:compare-op
			      %vk:command-buffer-level
			      %vk:color-space-khr
			      %vk:border-color
			      %vk:blend-op
			      %vk:blend-factor
			      %vk:attachment-store-op
			      %vk:attachment-load-op))

(defparameter *structs-plist-hash* (make-hash-table))

(defun prepare-structs-plist()
(setf (gethash '%vk:acquire-next-image-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:swapchain :type %vk::swapchain-khr :opaque t)
(:timeout :type :uint64)
(:semaphore :type %vk::semaphore :opaque t :optional t)
(:fence :type %vk::fence :opaque t :optional t)
(:device-mask :type :uint32)
))
(setf (gethash '%vk:allocation-callbacks *structs-plist-hash*) '(
(:p-user-data :type (:pointer :void)  :opaque t :optional t)
(:pfn-allocation :type %vk::pfn-allocation-function)
(:pfn-reallocation :type %vk::pfn-reallocation-function)
(:pfn-free :type %vk::pfn-free-function)
(:pfn-internal-allocation :type %vk::pfn-internal-allocation-notification :optional t)
(:pfn-internal-free :type %vk::pfn-internal-free-notification :optional t)
))
(setf (gethash '%vk:android-surface-create-info-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::android-surface-create-flags-khr :optional t)
(:window :type (:pointer %vk::a-native-window)  :opaque t)
))
(setf (gethash '%vk:application-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:p-application-name :type (:pointer :char)  :optional t)
(:application-version :type :uint32)
(:p-engine-name :type (:pointer :char)  :optional t)
(:engine-version :type :uint32)
(:api-version :type :uint32)
))
(setf (gethash '%vk:attachment-description *structs-plist-hash*) '(
(:flags :type %vk::attachment-description-flags :optional t)
(:format :type %vk::format)
(:samples :type %vk::sample-count-flag-bits)
(:load-op :type %vk::attachment-load-op)
(:store-op :type %vk::attachment-store-op)
(:stencil-load-op :type %vk::attachment-load-op)
(:stencil-store-op :type %vk::attachment-store-op)
(:initial-layout :type %vk::image-layout)
(:final-layout :type %vk::image-layout)
))
(setf (gethash '%vk:attachment-reference *structs-plist-hash*) '(
(:attachment :type :uint32)
(:layout :type %vk::image-layout)
))
(setf (gethash '%vk:bind-buffer-memory-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:buffer :type %vk::buffer :opaque t)
(:memory :type %vk::device-memory :opaque t)
(:memory-offset :type %vk::device-size)
(:device-index-count :type :uint32 :optional t)
(:p-device-indices :type (:pointer :uint32) )
))
(setf (gethash '%vk:bind-image-memory-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:image :type %vk::image :opaque t)
(:memory :type %vk::device-memory :opaque t)
(:memory-offset :type %vk::device-size)
(:device-index-count :type :uint32 :optional t)
(:p-device-indices :type (:pointer :uint32) )
(:s-f-r-rect-count :type :uint32 :optional t)
(:p-s-f-r-rects :type (:pointer (:struct %vk::rect-2d)) )
))
(setf (gethash '%vk:bind-image-memory-swapchain-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:swapchain :type %vk::swapchain-khr :opaque t)
(:image-index :type :uint32)
))
(setf (gethash '%vk:bind-sparse-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:wait-semaphore-count :type :uint32 :optional t)
(:p-wait-semaphores :type (:pointer %vk::semaphore)  :opaque t)
(:buffer-bind-count :type :uint32 :optional t)
(:p-buffer-binds :type (:pointer (:struct %vk::sparse-buffer-memory-bind-info)) )
(:image-opaque-bind-count :type :uint32 :optional t)
(:p-image-opaque-binds :type (:pointer (:struct %vk::sparse-image-opaque-memory-bind-info)) )
(:image-bind-count :type :uint32 :optional t)
(:p-image-binds :type (:pointer (:struct %vk::sparse-image-memory-bind-info)) )
(:signal-semaphore-count :type :uint32 :optional t)
(:p-signal-semaphores :type (:pointer %vk::semaphore)  :opaque t)
))
(setf (gethash '%vk:buffer-copy *structs-plist-hash*) '(
(:src-offset :type %vk::device-size)
(:dst-offset :type %vk::device-size)
(:size :type %vk::device-size)
))
(setf (gethash '%vk:buffer-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::buffer-create-flags :optional t)
(:size :type %vk::device-size)
(:usage :type %vk::buffer-usage-flags)
(:sharing-mode :type %vk::sharing-mode)
(:queue-family-index-count :type :uint32 :optional t)
(:p-queue-family-indices :type (:pointer :uint32) )
))
(setf (gethash '%vk:buffer-image-copy *structs-plist-hash*) '(
(:buffer-offset :type %vk::device-size)
(:buffer-row-length :type :uint32)
(:buffer-image-height :type :uint32)
(:image-subresource :type (:struct %vk::image-subresource-layers) )
(:image-offset :type (:struct %vk::offset-3d) )
(:image-extent :type (:struct %vk::extent-3d) )
))
(setf (gethash '%vk:buffer-memory-barrier *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:src-access-mask :type %vk::access-flags :optional t)
(:dst-access-mask :type %vk::access-flags :optional t)
(:src-queue-family-index :type :uint32)
(:dst-queue-family-index :type :uint32)
(:buffer :type %vk::buffer :opaque t)
(:offset :type %vk::device-size)
(:size :type %vk::device-size)
))
(setf (gethash '%vk:buffer-view-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::buffer-view-create-flags :optional t)
(:buffer :type %vk::buffer :opaque t)
(:format :type %vk::format)
(:offset :type %vk::device-size)
(:range :type %vk::device-size)
))
(setf (gethash '%vk:clear-attachment *structs-plist-hash*) '(
(:aspect-mask :type %vk::image-aspect-flags)
(:color-attachment :type :uint32)
(:clear-value :type (:union %vk::clear-value) )
))
(setf (gethash '%vk:clear-color-value *structs-plist-hash*) '(
(:float-32 :type :float)
(:int-32 :type :int32)
(:uint-32 :type :uint32)
))
(setf (gethash '%vk:clear-depth-stencil-value *structs-plist-hash*) '(
(:depth :type :float)
(:stencil :type :uint32)
))
(setf (gethash '%vk:clear-rect *structs-plist-hash*) '(
(:rect :type (:struct %vk::rect-2d) )
(:base-array-layer :type :uint32)
(:layer-count :type :uint32)
))
(setf (gethash '%vk:clear-value *structs-plist-hash*) '(
(:color :type (:union %vk::clear-color-value) )
(:depth-stencil :type (:struct %vk::clear-depth-stencil-value) )
))
(setf (gethash '%vk:cmd-process-commands-info-nvx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:object-table :type %vk::object-table-nvx :opaque t)
(:indirect-commands-layout :type %vk::indirect-commands-layout-nvx :opaque t)
(:indirect-commands-token-count :type :uint32)
(:p-indirect-commands-tokens :type (:pointer (:struct %vk::indirect-commands-token-nvx)) )
(:max-sequences-count :type :uint32)
(:target-command-buffer :type %vk::command-buffer :opaque t :optional t)
(:sequences-count-buffer :type %vk::buffer :opaque t :optional t)
(:sequences-count-offset :type %vk::device-size :optional t)
(:sequences-index-buffer :type %vk::buffer :opaque t :optional t)
(:sequences-index-offset :type %vk::device-size :optional t)
))
(setf (gethash '%vk:cmd-reserve-space-for-commands-info-nvx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:object-table :type %vk::object-table-nvx :opaque t)
(:indirect-commands-layout :type %vk::indirect-commands-layout-nvx :opaque t)
(:max-sequences-count :type :uint32)
))
(setf (gethash '%vk:command-buffer-allocate-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:command-pool :type %vk::command-pool :opaque t)
(:level :type %vk::command-buffer-level)
(:command-buffer-count :type :uint32)
))
(setf (gethash '%vk:command-buffer-begin-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::command-buffer-usage-flags :optional t)
(:p-inheritance-info :type (:pointer (:struct %vk::command-buffer-inheritance-info))  :optional t)
))
(setf (gethash '%vk:command-buffer-inheritance-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:render-pass :type %vk::render-pass :opaque t :optional t)
(:subpass :type :uint32)
(:framebuffer :type %vk::framebuffer :opaque t :optional t)
(:occlusion-query-enable :type %vk::bool32)
(:query-flags :type %vk::query-control-flags :optional t)
(:pipeline-statistics :type %vk::query-pipeline-statistic-flags :optional t)
))
(setf (gethash '%vk:command-pool-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::command-pool-create-flags :optional t)
(:queue-family-index :type :uint32)
))
(setf (gethash '%vk:component-mapping *structs-plist-hash*) '(
(:r :type %vk::component-swizzle)
(:g :type %vk::component-swizzle)
(:b :type %vk::component-swizzle)
(:a :type %vk::component-swizzle)
))
(setf (gethash '%vk:compute-pipeline-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-create-flags :optional t)
(:stage :type (:struct %vk::pipeline-shader-stage-create-info) )
(:layout :type %vk::pipeline-layout :opaque t)
(:base-pipeline-handle :type %vk::pipeline :opaque t :optional t)
(:base-pipeline-index :type :int32)
))
(setf (gethash '%vk:copy-descriptor-set *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:src-set :type %vk::descriptor-set :opaque t)
(:src-binding :type :uint32)
(:src-array-element :type :uint32)
(:dst-set :type %vk::descriptor-set :opaque t)
(:dst-binding :type :uint32)
(:dst-array-element :type :uint32)
(:descriptor-count :type :uint32)
))
(setf (gethash '%vk:d-3d-1-2-fence-submit-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:wait-semaphore-values-count :type :uint32 :optional t)
(:p-wait-semaphore-values :type (:pointer :uint64)  :optional t)
(:signal-semaphore-values-count :type :uint32 :optional t)
(:p-signal-semaphore-values :type (:pointer :uint64)  :optional t)
))
(setf (gethash '%vk:debug-marker-marker-info-ext *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:p-marker-name :type (:pointer :char) )
(:color :type :float :optional t)
))
(setf (gethash '%vk:debug-marker-object-name-info-ext *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:object-type :type %vk::debug-report-object-type-ext)
(:object :type :uint64)
(:p-object-name :type (:pointer :char) )
))
(setf (gethash '%vk:debug-marker-object-tag-info-ext *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:object-type :type %vk::debug-report-object-type-ext)
(:object :type :uint64)
(:tag-name :type :uint64)
(:tag-size :type %vk::size-t)
(:p-tag :type (:pointer :void)  :opaque t)
))
(setf (gethash '%vk:debug-report-callback-create-info-ext *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::debug-report-flags-ext :optional t)
(:pfn-callback :type %vk::pfn-debug-report-callback-ext)
(:p-user-data :type (:pointer :void)  :opaque t :optional t)
))
(setf (gethash '%vk:dedicated-allocation-buffer-create-info-nv *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:dedicated-allocation :type %vk::bool32)
))
(setf (gethash '%vk:dedicated-allocation-image-create-info-nv *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:dedicated-allocation :type %vk::bool32)
))
(setf (gethash '%vk:dedicated-allocation-memory-allocate-info-nv *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:image :type %vk::image :opaque t :optional t)
(:buffer :type %vk::buffer :opaque t :optional t)
))
(setf (gethash '%vk:descriptor-buffer-info *structs-plist-hash*) '(
(:buffer :type %vk::buffer :opaque t)
(:offset :type %vk::device-size)
(:range :type %vk::device-size)
))
(setf (gethash '%vk:descriptor-image-info *structs-plist-hash*) '(
(:sampler :type %vk::sampler :opaque t)
(:image-view :type %vk::image-view :opaque t)
(:image-layout :type %vk::image-layout)
))
(setf (gethash '%vk:descriptor-pool-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::descriptor-pool-create-flags :optional t)
(:max-sets :type :uint32)
(:pool-size-count :type :uint32)
(:p-pool-sizes :type (:pointer (:struct %vk::descriptor-pool-size)) )
))
(setf (gethash '%vk:descriptor-pool-size *structs-plist-hash*) '(
(:type :type %vk::descriptor-type)
(:descriptor-count :type :uint32)
))
(setf (gethash '%vk:descriptor-set-allocate-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:descriptor-pool :type %vk::descriptor-pool :opaque t)
(:descriptor-set-count :type :uint32)
(:p-set-layouts :type (:pointer %vk::descriptor-set-layout)  :opaque t)
))
(setf (gethash '%vk:descriptor-set-layout-binding *structs-plist-hash*) '(
(:binding :type :uint32)
(:descriptor-type :type %vk::descriptor-type)
(:descriptor-count :type :uint32 :optional t)
(:stage-flags :type %vk::shader-stage-flags)
(:p-immutable-samplers :type (:pointer %vk::sampler)  :opaque t :optional t)
))
(setf (gethash '%vk:descriptor-set-layout-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::descriptor-set-layout-create-flags :optional t)
(:binding-count :type :uint32 :optional t)
(:p-bindings :type (:pointer (:struct %vk::descriptor-set-layout-binding)) )
))
(setf (gethash '%vk:descriptor-update-template-create-info-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::descriptor-update-template-create-flags-khr :optional t)
(:descriptor-update-entry-count :type :uint32)
(:p-descriptor-update-entries :type (:pointer (:struct %vk::descriptor-update-template-entry-khr)) )
(:template-type :type %vk::descriptor-update-template-type-khr)
(:descriptor-set-layout :type %vk::descriptor-set-layout :opaque t :optional t)
(:pipeline-bind-point :type %vk::pipeline-bind-point :optional t)
(:pipeline-layout :type %vk::pipeline-layout :opaque t :optional t)
(:set :type :uint32 :optional t)
))
(setf (gethash '%vk:descriptor-update-template-entry-khr *structs-plist-hash*) '(
(:dst-binding :type :uint32)
(:dst-array-element :type :uint32)
(:descriptor-count :type :uint32)
(:descriptor-type :type %vk::descriptor-type)
(:offset :type %vk::size-t)
(:stride :type %vk::size-t)
))
(setf (gethash '%vk:device-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::device-create-flags :optional t)
(:queue-create-info-count :type :uint32)
(:p-queue-create-infos :type (:pointer (:struct %vk::device-queue-create-info)) )
(:enabled-layer-count :type :uint32 :optional t)
(:pp-enabled-layer-names :type (:pointer (:pointer :char)) )
(:enabled-extension-count :type :uint32 :optional t)
(:pp-enabled-extension-names :type (:pointer (:pointer :char)) )
(:p-enabled-features :type (:pointer (:struct %vk::physical-device-features))  :optional t)
))
(setf (gethash '%vk:device-event-info-ext *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:device-event :type %vk::device-event-type-ext)
))
(setf (gethash '%vk:device-generated-commands-features-nvx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:compute-binding-point-support :type %vk::bool32)
))
(setf (gethash '%vk:device-generated-commands-limits-nvx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:max-indirect-commands-layout-token-count :type :uint32)
(:max-object-entry-counts :type :uint32)
(:min-sequence-count-buffer-offset-alignment :type :uint32)
(:min-sequence-index-buffer-offset-alignment :type :uint32)
(:min-commands-token-buffer-offset-alignment :type :uint32)
))
(setf (gethash '%vk:device-group-bind-sparse-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:resource-device-index :type :uint32)
(:memory-device-index :type :uint32)
))
(setf (gethash '%vk:device-group-command-buffer-begin-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:device-mask :type :uint32)
))
(setf (gethash '%vk:device-group-device-create-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:physical-device-count :type :uint32 :optional t)
(:p-physical-devices :type (:pointer %vk::physical-device)  :opaque t)
))
(setf (gethash '%vk:device-group-present-capabilities-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:present-mask :type :uint32)
(:modes :type %vk::device-group-present-mode-flags-khx)
))
(setf (gethash '%vk:device-group-present-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:swapchain-count :type :uint32 :optional t)
(:p-device-masks :type (:pointer :uint32) )
(:mode :type %vk::device-group-present-mode-flag-bits-khx)
))
(setf (gethash '%vk:device-group-render-pass-begin-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:device-mask :type :uint32)
(:device-render-area-count :type :uint32 :optional t)
(:p-device-render-areas :type (:pointer (:struct %vk::rect-2d)) )
))
(setf (gethash '%vk:device-group-submit-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:wait-semaphore-count :type :uint32 :optional t)
(:p-wait-semaphore-device-indices :type (:pointer :uint32) )
(:command-buffer-count :type :uint32 :optional t)
(:p-command-buffer-device-masks :type (:pointer :uint32) )
(:signal-semaphore-count :type :uint32 :optional t)
(:p-signal-semaphore-device-indices :type (:pointer :uint32) )
))
(setf (gethash '%vk:device-group-swapchain-create-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:modes :type %vk::device-group-present-mode-flags-khx)
))
(setf (gethash '%vk:device-queue-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::device-queue-create-flags :optional t)
(:queue-family-index :type :uint32)
(:queue-count :type :uint32)
(:p-queue-priorities :type (:pointer :float) )
))
(setf (gethash '%vk:dispatch-indirect-command *structs-plist-hash*) '(
(:x :type :uint32)
(:y :type :uint32)
(:z :type :uint32)
))
(setf (gethash '%vk:display-event-info-ext *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:display-event :type %vk::display-event-type-ext)
))
(setf (gethash '%vk:display-mode-create-info-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::display-mode-create-flags-khr :optional t)
(:parameters :type (:struct %vk::display-mode-parameters-khr) )
))
(setf (gethash '%vk:display-mode-parameters-khr *structs-plist-hash*) '(
(:visible-region :type (:struct %vk::extent-2d) )
(:refresh-rate :type :uint32)
))
(setf (gethash '%vk:display-mode-properties-khr *structs-plist-hash*) '(
(:display-mode :type %vk::display-mode-khr :opaque t)
(:parameters :type (:struct %vk::display-mode-parameters-khr) )
))
(setf (gethash '%vk:display-plane-capabilities-khr *structs-plist-hash*) '(
(:supported-alpha :type %vk::display-plane-alpha-flags-khr :optional t)
(:min-src-position :type (:struct %vk::offset-2d) )
(:max-src-position :type (:struct %vk::offset-2d) )
(:min-src-extent :type (:struct %vk::extent-2d) )
(:max-src-extent :type (:struct %vk::extent-2d) )
(:min-dst-position :type (:struct %vk::offset-2d) )
(:max-dst-position :type (:struct %vk::offset-2d) )
(:min-dst-extent :type (:struct %vk::extent-2d) )
(:max-dst-extent :type (:struct %vk::extent-2d) )
))
(setf (gethash '%vk:display-plane-properties-khr *structs-plist-hash*) '(
(:current-display :type %vk::display-khr :opaque t)
(:current-stack-index :type :uint32)
))
(setf (gethash '%vk:display-power-info-ext *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:power-state :type %vk::display-power-state-ext)
))
(setf (gethash '%vk:display-present-info-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:src-rect :type (:struct %vk::rect-2d) )
(:dst-rect :type (:struct %vk::rect-2d) )
(:persistent :type %vk::bool32)
))
(setf (gethash '%vk:display-properties-khr *structs-plist-hash*) '(
(:display :type %vk::display-khr :opaque t)
(:display-name :type %vk::string)
(:physical-dimensions :type (:struct %vk::extent-2d) )
(:physical-resolution :type (:struct %vk::extent-2d) )
(:supported-transforms :type %vk::surface-transform-flags-khr :optional t)
(:plane-reorder-possible :type %vk::bool32)
(:persistent-content :type %vk::bool32)
))
(setf (gethash '%vk:display-surface-create-info-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::display-surface-create-flags-khr :optional t)
(:display-mode :type %vk::display-mode-khr :opaque t)
(:plane-index :type :uint32)
(:plane-stack-index :type :uint32)
(:transform :type %vk::surface-transform-flag-bits-khr)
(:global-alpha :type :float)
(:alpha-mode :type %vk::display-plane-alpha-flag-bits-khr)
(:image-extent :type (:struct %vk::extent-2d) )
))
(setf (gethash '%vk:draw-indexed-indirect-command *structs-plist-hash*) '(
(:index-count :type :uint32)
(:instance-count :type :uint32)
(:first-index :type :uint32)
(:vertex-offset :type :int32)
(:first-instance :type :uint32)
))
(setf (gethash '%vk:draw-indirect-command *structs-plist-hash*) '(
(:vertex-count :type :uint32)
(:instance-count :type :uint32)
(:first-vertex :type :uint32)
(:first-instance :type :uint32)
))
(setf (gethash '%vk:event-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::event-create-flags :optional t)
))
(setf (gethash '%vk:export-memory-allocate-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:handle-types :type %vk::external-memory-handle-type-flags-khx :optional t)
))
(setf (gethash '%vk:export-memory-allocate-info-nv *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:handle-types :type %vk::external-memory-handle-type-flags-nv :optional t)
))
(setf (gethash '%vk:export-memory-win32-handle-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:p-attributes :type (:pointer %vk::security_attributes)  :opaque t :optional t)
(:dw-access :type %vk::dword)
(:name :type %vk::lpcwstr)
))
(setf (gethash '%vk:export-memory-win32-handle-info-nv *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:p-attributes :type (:pointer %vk::security_attributes)  :opaque t :optional t)
(:dw-access :type %vk::dword :optional t)
))
(setf (gethash '%vk:export-semaphore-create-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:handle-types :type %vk::external-semaphore-handle-type-flags-khx :optional t)
))
(setf (gethash '%vk:export-semaphore-win32-handle-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:p-attributes :type (:pointer %vk::security_attributes)  :opaque t :optional t)
(:dw-access :type %vk::dword)
(:name :type %vk::lpcwstr)
))
(setf (gethash '%vk:extension-properties *structs-plist-hash*) '(
(:extension-name :type :char)
(:spec-version :type :uint32)
))
(setf (gethash '%vk:extent-2d *structs-plist-hash*) '(
(:width :type :uint32)
(:height :type :uint32)
))
(setf (gethash '%vk:extent-3d *structs-plist-hash*) '(
(:width :type :uint32)
(:height :type :uint32)
(:depth :type :uint32)
))
(setf (gethash '%vk:external-buffer-properties-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:external-memory-properties :type (:struct %vk::external-memory-properties-khx) )
))
(setf (gethash '%vk:external-image-format-properties-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:external-memory-properties :type (:struct %vk::external-memory-properties-khx) )
))
(setf (gethash '%vk:external-image-format-properties-nv *structs-plist-hash*) '(
(:image-format-properties :type (:struct %vk::image-format-properties) )
(:external-memory-features :type %vk::external-memory-feature-flags-nv :optional t)
(:export-from-imported-handle-types :type %vk::external-memory-handle-type-flags-nv :optional t)
(:compatible-handle-types :type %vk::external-memory-handle-type-flags-nv :optional t)
))
(setf (gethash '%vk:external-memory-buffer-create-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:handle-types :type %vk::external-memory-handle-type-flags-khx :optional t)
))
(setf (gethash '%vk:external-memory-image-create-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:handle-types :type %vk::external-memory-handle-type-flags-khx)
))
(setf (gethash '%vk:external-memory-image-create-info-nv *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:handle-types :type %vk::external-memory-handle-type-flags-nv :optional t)
))
(setf (gethash '%vk:external-memory-properties-khx *structs-plist-hash*) '(
(:external-memory-features :type %vk::external-memory-feature-flags-khx)
(:export-from-imported-handle-types :type %vk::external-memory-handle-type-flags-khx :optional t)
(:compatible-handle-types :type %vk::external-memory-handle-type-flags-khx)
))
(setf (gethash '%vk:external-semaphore-properties-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:export-from-imported-handle-types :type %vk::external-semaphore-handle-type-flags-khx)
(:compatible-handle-types :type %vk::external-semaphore-handle-type-flags-khx)
(:external-semaphore-features :type %vk::external-semaphore-feature-flags-khx :optional t)
))
(setf (gethash '%vk:fence-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::fence-create-flags :optional t)
))
(setf (gethash '%vk:format-properties *structs-plist-hash*) '(
(:linear-tiling-features :type %vk::format-feature-flags :optional t)
(:optimal-tiling-features :type %vk::format-feature-flags :optional t)
(:buffer-features :type %vk::format-feature-flags :optional t)
))
(setf (gethash '%vk:format-properties-2-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:format-properties :type (:struct %vk::format-properties) )
))
(setf (gethash '%vk:framebuffer-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::framebuffer-create-flags :optional t)
(:render-pass :type %vk::render-pass :opaque t)
(:attachment-count :type :uint32 :optional t)
(:p-attachments :type (:pointer %vk::image-view)  :opaque t)
(:width :type :uint32)
(:height :type :uint32)
(:layers :type :uint32)
))
(setf (gethash '%vk:graphics-pipeline-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-create-flags :optional t)
(:stage-count :type :uint32)
(:p-stages :type (:pointer (:struct %vk::pipeline-shader-stage-create-info)) )
(:p-vertex-input-state :type (:pointer (:struct %vk::pipeline-vertex-input-state-create-info)) )
(:p-input-assembly-state :type (:pointer (:struct %vk::pipeline-input-assembly-state-create-info)) )
(:p-tessellation-state :type (:pointer (:struct %vk::pipeline-tessellation-state-create-info))  :optional t)
(:p-viewport-state :type (:pointer (:struct %vk::pipeline-viewport-state-create-info))  :optional t)
(:p-rasterization-state :type (:pointer (:struct %vk::pipeline-rasterization-state-create-info)) )
(:p-multisample-state :type (:pointer (:struct %vk::pipeline-multisample-state-create-info))  :optional t)
(:p-depth-stencil-state :type (:pointer (:struct %vk::pipeline-depth-stencil-state-create-info))  :optional t)
(:p-color-blend-state :type (:pointer (:struct %vk::pipeline-color-blend-state-create-info))  :optional t)
(:p-dynamic-state :type (:pointer (:struct %vk::pipeline-dynamic-state-create-info))  :optional t)
(:layout :type %vk::pipeline-layout :opaque t)
(:render-pass :type %vk::render-pass :opaque t)
(:subpass :type :uint32)
(:base-pipeline-handle :type %vk::pipeline :opaque t :optional t)
(:base-pipeline-index :type :int32)
))
(setf (gethash '%vk:hdr-metadata-ext *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:display-primary-red :type (:struct %vk::x-y-color-ext) )
(:display-primary-green :type (:struct %vk::x-y-color-ext) )
(:display-primary-blue :type (:struct %vk::x-y-color-ext) )
(:white-point :type (:struct %vk::x-y-color-ext) )
(:max-luminance :type :float)
(:min-luminance :type :float)
(:max-content-light-level :type :float)
(:max-frame-average-light-level :type :float)
))
(setf (gethash '%vk:i-o-s-surface-create-info-mvk *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::i-o-s-surface-create-flags-mvk :optional t)
(:p-view :type (:pointer :void)  :opaque t)
))
(setf (gethash '%vk:image-blit *structs-plist-hash*) '(
(:src-subresource :type (:struct %vk::image-subresource-layers) )
(:src-offsets :type (:struct %vk::offset-3d) )
(:dst-subresource :type (:struct %vk::image-subresource-layers) )
(:dst-offsets :type (:struct %vk::offset-3d) )
))
(setf (gethash '%vk:image-copy *structs-plist-hash*) '(
(:src-subresource :type (:struct %vk::image-subresource-layers) )
(:src-offset :type (:struct %vk::offset-3d) )
(:dst-subresource :type (:struct %vk::image-subresource-layers) )
(:dst-offset :type (:struct %vk::offset-3d) )
(:extent :type (:struct %vk::extent-3d) )
))
(setf (gethash '%vk:image-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::image-create-flags :optional t)
(:image-type :type %vk::image-type)
(:format :type %vk::format)
(:extent :type (:struct %vk::extent-3d) )
(:mip-levels :type :uint32)
(:array-layers :type :uint32)
(:samples :type %vk::sample-count-flag-bits)
(:tiling :type %vk::image-tiling)
(:usage :type %vk::image-usage-flags)
(:sharing-mode :type %vk::sharing-mode)
(:queue-family-index-count :type :uint32 :optional t)
(:p-queue-family-indices :type (:pointer :uint32) )
(:initial-layout :type %vk::image-layout)
))
(setf (gethash '%vk:image-format-properties *structs-plist-hash*) '(
(:max-extent :type (:struct %vk::extent-3d) )
(:max-mip-levels :type :uint32)
(:max-array-layers :type :uint32)
(:sample-counts :type %vk::sample-count-flags :optional t)
(:max-resource-size :type %vk::device-size)
))
(setf (gethash '%vk:image-format-properties-2-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:image-format-properties :type (:struct %vk::image-format-properties) )
))
(setf (gethash '%vk:image-memory-barrier *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:src-access-mask :type %vk::access-flags :optional t)
(:dst-access-mask :type %vk::access-flags :optional t)
(:old-layout :type %vk::image-layout)
(:new-layout :type %vk::image-layout)
(:src-queue-family-index :type :uint32)
(:dst-queue-family-index :type :uint32)
(:image :type %vk::image :opaque t)
(:subresource-range :type (:struct %vk::image-subresource-range) )
))
(setf (gethash '%vk:image-resolve *structs-plist-hash*) '(
(:src-subresource :type (:struct %vk::image-subresource-layers) )
(:src-offset :type (:struct %vk::offset-3d) )
(:dst-subresource :type (:struct %vk::image-subresource-layers) )
(:dst-offset :type (:struct %vk::offset-3d) )
(:extent :type (:struct %vk::extent-3d) )
))
(setf (gethash '%vk:image-subresource *structs-plist-hash*) '(
(:aspect-mask :type %vk::image-aspect-flags)
(:mip-level :type :uint32)
(:array-layer :type :uint32)
))
(setf (gethash '%vk:image-subresource-layers *structs-plist-hash*) '(
(:aspect-mask :type %vk::image-aspect-flags)
(:mip-level :type :uint32)
(:base-array-layer :type :uint32)
(:layer-count :type :uint32)
))
(setf (gethash '%vk:image-subresource-range *structs-plist-hash*) '(
(:aspect-mask :type %vk::image-aspect-flags)
(:base-mip-level :type :uint32)
(:level-count :type :uint32)
(:base-array-layer :type :uint32)
(:layer-count :type :uint32)
))
(setf (gethash '%vk:image-swapchain-create-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:swapchain :type %vk::swapchain-khr :opaque t :optional t)
))
(setf (gethash '%vk:image-view-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::image-view-create-flags :optional t)
(:image :type %vk::image :opaque t)
(:view-type :type %vk::image-view-type)
(:format :type %vk::format)
(:components :type (:struct %vk::component-mapping) )
(:subresource-range :type (:struct %vk::image-subresource-range) )
))
(setf (gethash '%vk:import-memory-fd-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:handle-type :type %vk::external-memory-handle-type-flag-bits-khx :optional t)
(:fd :type :int)
))
(setf (gethash '%vk:import-memory-win32-handle-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:handle-type :type %vk::external-memory-handle-type-flag-bits-khx :optional t)
(:handle :type %vk::handle)
))
(setf (gethash '%vk:import-memory-win32-handle-info-nv *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:handle-type :type %vk::external-memory-handle-type-flags-nv :optional t)
(:handle :type %vk::handle :optional t)
))
(setf (gethash '%vk:import-semaphore-fd-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:semaphore :type %vk::semaphore :opaque t)
(:handle-type :type %vk::external-semaphore-handle-type-flag-bits-khx)
(:fd :type :int)
))
(setf (gethash '%vk:import-semaphore-win32-handle-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:semaphore :type %vk::semaphore :opaque t)
(:handle-type :type %vk::external-semaphore-handle-type-flags-khx)
(:handle :type %vk::handle)
))
(setf (gethash '%vk:indirect-commands-layout-create-info-nvx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:pipeline-bind-point :type %vk::pipeline-bind-point)
(:flags :type %vk::indirect-commands-layout-usage-flags-nvx)
(:token-count :type :uint32)
(:p-tokens :type (:pointer (:struct %vk::indirect-commands-layout-token-nvx)) )
))
(setf (gethash '%vk:indirect-commands-layout-token-nvx *structs-plist-hash*) '(
(:token-type :type %vk::indirect-commands-token-type-nvx)
(:binding-unit :type :uint32)
(:dynamic-count :type :uint32)
(:divisor :type :uint32)
))
(setf (gethash '%vk:indirect-commands-token-nvx *structs-plist-hash*) '(
(:token-type :type %vk::indirect-commands-token-type-nvx)
(:buffer :type %vk::buffer :opaque t)
(:offset :type %vk::device-size)
))
(setf (gethash '%vk:instance-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::instance-create-flags :optional t)
(:p-application-info :type (:pointer (:struct %vk::application-info))  :optional t)
(:enabled-layer-count :type :uint32 :optional t)
(:pp-enabled-layer-names :type (:pointer (:pointer :char)) )
(:enabled-extension-count :type :uint32 :optional t)
(:pp-enabled-extension-names :type (:pointer (:pointer :char)) )
))
(setf (gethash '%vk:layer-properties *structs-plist-hash*) '(
(:layer-name :type :char)
(:spec-version :type :uint32)
(:implementation-version :type :uint32)
(:description :type :char)
))
(setf (gethash '%vk:mac-o-s-surface-create-info-mvk *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::mac-o-s-surface-create-flags-mvk :optional t)
(:p-view :type (:pointer :void)  :opaque t)
))
(setf (gethash '%vk:mapped-memory-range *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:memory :type %vk::device-memory :opaque t)
(:offset :type %vk::device-size)
(:size :type %vk::device-size)
))
(setf (gethash '%vk:memory-allocate-flags-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::memory-allocate-flags-khx :optional t)
(:device-mask :type :uint32)
))
(setf (gethash '%vk:memory-allocate-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:allocation-size :type %vk::device-size)
(:memory-type-index :type :uint32)
))
(setf (gethash '%vk:memory-barrier *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:src-access-mask :type %vk::access-flags :optional t)
(:dst-access-mask :type %vk::access-flags :optional t)
))
(setf (gethash '%vk:memory-fd-properties-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:memory-type-bits :type :uint32)
))
(setf (gethash '%vk:memory-heap *structs-plist-hash*) '(
(:size :type %vk::device-size)
(:flags :type %vk::memory-heap-flags :optional t)
))
(setf (gethash '%vk:memory-requirements *structs-plist-hash*) '(
(:size :type %vk::device-size)
(:alignment :type %vk::device-size)
(:memory-type-bits :type :uint32)
))
(setf (gethash '%vk:memory-type *structs-plist-hash*) '(
(:property-flags :type %vk::memory-property-flags :optional t)
(:heap-index :type :uint32)
))
(setf (gethash '%vk:memory-win32-handle-properties-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:memory-type-bits :type :uint32)
))
(setf (gethash '%vk:mir-surface-create-info-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::mir-surface-create-flags-khr :optional t)
(:connection :type (:pointer %vk::mir-connection)  :opaque t)
(:mir-surface :type (:pointer %vk::mir-surface)  :opaque t)
))
(setf (gethash '%vk:object-table-create-info-nvx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:object-count :type :uint32)
(:p-object-entry-types :type (:pointer %vk::object-entry-type-nvx) )
(:p-object-entry-counts :type (:pointer :uint32) )
(:p-object-entry-usage-flags :type (:pointer %vk::object-entry-usage-flags-nvx) )
(:max-uniform-buffers-per-descriptor :type :uint32)
(:max-storage-buffers-per-descriptor :type :uint32)
(:max-storage-images-per-descriptor :type :uint32)
(:max-sampled-images-per-descriptor :type :uint32)
(:max-pipeline-layouts :type :uint32)
))
(setf (gethash '%vk:object-table-descriptor-set-entry-nvx *structs-plist-hash*) '(
(:type :type %vk::object-entry-type-nvx)
(:flags :type %vk::object-entry-usage-flags-nvx)
(:pipeline-layout :type %vk::pipeline-layout :opaque t)
(:descriptor-set :type %vk::descriptor-set :opaque t)
))
(setf (gethash '%vk:object-table-entry-nvx *structs-plist-hash*) '(
(:type :type %vk::object-entry-type-nvx)
(:flags :type %vk::object-entry-usage-flags-nvx)
))
(setf (gethash '%vk:object-table-index-buffer-entry-nvx *structs-plist-hash*) '(
(:type :type %vk::object-entry-type-nvx)
(:flags :type %vk::object-entry-usage-flags-nvx)
(:buffer :type %vk::buffer :opaque t)
(:index-type :type %vk::index-type)
))
(setf (gethash '%vk:object-table-pipeline-entry-nvx *structs-plist-hash*) '(
(:type :type %vk::object-entry-type-nvx)
(:flags :type %vk::object-entry-usage-flags-nvx)
(:pipeline :type %vk::pipeline :opaque t)
))
(setf (gethash '%vk:object-table-push-constant-entry-nvx *structs-plist-hash*) '(
(:type :type %vk::object-entry-type-nvx)
(:flags :type %vk::object-entry-usage-flags-nvx)
(:pipeline-layout :type %vk::pipeline-layout :opaque t)
(:stage-flags :type %vk::shader-stage-flags)
))
(setf (gethash '%vk:object-table-vertex-buffer-entry-nvx *structs-plist-hash*) '(
(:type :type %vk::object-entry-type-nvx)
(:flags :type %vk::object-entry-usage-flags-nvx)
(:buffer :type %vk::buffer :opaque t)
))
(setf (gethash '%vk:offset-2d *structs-plist-hash*) '(
(:x :type :int32)
(:y :type :int32)
))
(setf (gethash '%vk:offset-3d *structs-plist-hash*) '(
(:x :type :int32)
(:y :type :int32)
(:z :type :int32)
))
(setf (gethash '%vk:past-presentation-timing-google *structs-plist-hash*) '(
(:present-id :type :uint32)
(:desired-present-time :type :uint64)
(:actual-present-time :type :uint64)
(:earliest-present-time :type :uint64)
(:present-margin :type :uint64)
))
(setf (gethash '%vk:physical-device-discard-rectangle-properties-ext *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:max-discard-rectangles :type :uint32)
))
(setf (gethash '%vk:physical-device-external-buffer-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::buffer-create-flags :optional t)
(:usage :type %vk::buffer-usage-flags)
(:handle-type :type %vk::external-memory-handle-type-flag-bits-khx)
))
(setf (gethash '%vk:physical-device-external-image-format-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:handle-type :type %vk::external-memory-handle-type-flag-bits-khx :optional t)
))
(setf (gethash '%vk:physical-device-external-semaphore-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:handle-type :type %vk::external-semaphore-handle-type-flag-bits-khx)
))
(setf (gethash '%vk:physical-device-features *structs-plist-hash*) '(
(:robust-buffer-access :type %vk::bool32)
(:full-draw-index-uint-32 :type %vk::bool32)
(:image-cube-array :type %vk::bool32)
(:independent-blend :type %vk::bool32)
(:geometry-shader :type %vk::bool32)
(:tessellation-shader :type %vk::bool32)
(:sample-rate-shading :type %vk::bool32)
(:dual-src-blend :type %vk::bool32)
(:logic-op :type %vk::bool32)
(:multi-draw-indirect :type %vk::bool32)
(:draw-indirect-first-instance :type %vk::bool32)
(:depth-clamp :type %vk::bool32)
(:depth-bias-clamp :type %vk::bool32)
(:fill-mode-non-solid :type %vk::bool32)
(:depth-bounds :type %vk::bool32)
(:wide-lines :type %vk::bool32)
(:large-points :type %vk::bool32)
(:alpha-to-one :type %vk::bool32)
(:multi-viewport :type %vk::bool32)
(:sampler-anisotropy :type %vk::bool32)
(:texture-compression-etc2 :type %vk::bool32)
(:texture-compression-astc_-ldr :type %vk::bool32)
(:texture-compression-bc :type %vk::bool32)
(:occlusion-query-precise :type %vk::bool32)
(:pipeline-statistics-query :type %vk::bool32)
(:vertex-pipeline-stores-and-atomics :type %vk::bool32)
(:fragment-stores-and-atomics :type %vk::bool32)
(:shader-tessellation-and-geometry-point-size :type %vk::bool32)
(:shader-image-gather-extended :type %vk::bool32)
(:shader-storage-image-extended-formats :type %vk::bool32)
(:shader-storage-image-multisample :type %vk::bool32)
(:shader-storage-image-read-without-format :type %vk::bool32)
(:shader-storage-image-write-without-format :type %vk::bool32)
(:shader-uniform-buffer-array-dynamic-indexing :type %vk::bool32)
(:shader-sampled-image-array-dynamic-indexing :type %vk::bool32)
(:shader-storage-buffer-array-dynamic-indexing :type %vk::bool32)
(:shader-storage-image-array-dynamic-indexing :type %vk::bool32)
(:shader-clip-distance :type %vk::bool32)
(:shader-cull-distance :type %vk::bool32)
(:shader-float-64 :type %vk::bool32)
(:shader-int-64 :type %vk::bool32)
(:shader-int-16 :type %vk::bool32)
(:shader-resource-residency :type %vk::bool32)
(:shader-resource-min-lod :type %vk::bool32)
(:sparse-binding :type %vk::bool32)
(:sparse-residency-buffer :type %vk::bool32)
(:sparse-residency-image-2d :type %vk::bool32)
(:sparse-residency-image-3d :type %vk::bool32)
(:sparse-residency-2-samples :type %vk::bool32)
(:sparse-residency-4-samples :type %vk::bool32)
(:sparse-residency-8-samples :type %vk::bool32)
(:sparse-residency-16-samples :type %vk::bool32)
(:sparse-residency-aliased :type %vk::bool32)
(:variable-multisample-rate :type %vk::bool32)
(:inherited-queries :type %vk::bool32)
))
(setf (gethash '%vk:physical-device-features-2-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:features :type (:struct %vk::physical-device-features) )
))
(setf (gethash '%vk:physical-device-group-properties-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:physical-device-count :type :uint32)
(:physical-devices :type %vk::physical-device :opaque t)
(:subset-allocation :type %vk::bool32)
))
(setf (gethash '%vk:physical-device-id-properties-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:device-uuid :type :uint8)
(:driver-uuid :type :uint8)
(:device-l-u-id :type :uint8)
(:device-l-u-id-valid :type %vk::bool32)
))
(setf (gethash '%vk:physical-device-image-format-info-2-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:format :type %vk::format)
(:type :type %vk::image-type)
(:tiling :type %vk::image-tiling)
(:usage :type %vk::image-usage-flags)
(:flags :type %vk::image-create-flags :optional t)
))
(setf (gethash '%vk:physical-device-limits *structs-plist-hash*) '(
(:max-image-dimension-1d :type :uint32)
(:max-image-dimension-2d :type :uint32)
(:max-image-dimension-3d :type :uint32)
(:max-image-dimension-cube :type :uint32)
(:max-image-array-layers :type :uint32)
(:max-texel-buffer-elements :type :uint32)
(:max-uniform-buffer-range :type :uint32)
(:max-storage-buffer-range :type :uint32)
(:max-push-constants-size :type :uint32)
(:max-memory-allocation-count :type :uint32)
(:max-sampler-allocation-count :type :uint32)
(:buffer-image-granularity :type %vk::device-size)
(:sparse-address-space-size :type %vk::device-size)
(:max-bound-descriptor-sets :type :uint32)
(:max-per-stage-descriptor-samplers :type :uint32)
(:max-per-stage-descriptor-uniform-buffers :type :uint32)
(:max-per-stage-descriptor-storage-buffers :type :uint32)
(:max-per-stage-descriptor-sampled-images :type :uint32)
(:max-per-stage-descriptor-storage-images :type :uint32)
(:max-per-stage-descriptor-input-attachments :type :uint32)
(:max-per-stage-resources :type :uint32)
(:max-descriptor-set-samplers :type :uint32)
(:max-descriptor-set-uniform-buffers :type :uint32)
(:max-descriptor-set-uniform-buffers-dynamic :type :uint32)
(:max-descriptor-set-storage-buffers :type :uint32)
(:max-descriptor-set-storage-buffers-dynamic :type :uint32)
(:max-descriptor-set-sampled-images :type :uint32)
(:max-descriptor-set-storage-images :type :uint32)
(:max-descriptor-set-input-attachments :type :uint32)
(:max-vertex-input-attributes :type :uint32)
(:max-vertex-input-bindings :type :uint32)
(:max-vertex-input-attribute-offset :type :uint32)
(:max-vertex-input-binding-stride :type :uint32)
(:max-vertex-output-components :type :uint32)
(:max-tessellation-generation-level :type :uint32)
(:max-tessellation-patch-size :type :uint32)
(:max-tessellation-control-per-vertex-input-components :type :uint32)
(:max-tessellation-control-per-vertex-output-components :type :uint32)
(:max-tessellation-control-per-patch-output-components :type :uint32)
(:max-tessellation-control-total-output-components :type :uint32)
(:max-tessellation-evaluation-input-components :type :uint32)
(:max-tessellation-evaluation-output-components :type :uint32)
(:max-geometry-shader-invocations :type :uint32)
(:max-geometry-input-components :type :uint32)
(:max-geometry-output-components :type :uint32)
(:max-geometry-output-vertices :type :uint32)
(:max-geometry-total-output-components :type :uint32)
(:max-fragment-input-components :type :uint32)
(:max-fragment-output-attachments :type :uint32)
(:max-fragment-dual-src-attachments :type :uint32)
(:max-fragment-combined-output-resources :type :uint32)
(:max-compute-shared-memory-size :type :uint32)
(:max-compute-work-group-count :type :uint32)
(:max-compute-work-group-invocations :type :uint32)
(:max-compute-work-group-size :type :uint32)
(:sub-pixel-precision-bits :type :uint32)
(:sub-texel-precision-bits :type :uint32)
(:mipmap-precision-bits :type :uint32)
(:max-draw-indexed-index-value :type :uint32)
(:max-draw-indirect-count :type :uint32)
(:max-sampler-lod-bias :type :float)
(:max-sampler-anisotropy :type :float)
(:max-viewports :type :uint32)
(:max-viewport-dimensions :type :uint32)
(:viewport-bounds-range :type :float)
(:viewport-sub-pixel-bits :type :uint32)
(:min-memory-map-alignment :type %vk::size-t)
(:min-texel-buffer-offset-alignment :type %vk::device-size)
(:min-uniform-buffer-offset-alignment :type %vk::device-size)
(:min-storage-buffer-offset-alignment :type %vk::device-size)
(:min-texel-offset :type :int32)
(:max-texel-offset :type :uint32)
(:min-texel-gather-offset :type :int32)
(:max-texel-gather-offset :type :uint32)
(:min-interpolation-offset :type :float)
(:max-interpolation-offset :type :float)
(:sub-pixel-interpolation-offset-bits :type :uint32)
(:max-framebuffer-width :type :uint32)
(:max-framebuffer-height :type :uint32)
(:max-framebuffer-layers :type :uint32)
(:framebuffer-color-sample-counts :type %vk::sample-count-flags :optional t)
(:framebuffer-depth-sample-counts :type %vk::sample-count-flags :optional t)
(:framebuffer-stencil-sample-counts :type %vk::sample-count-flags :optional t)
(:framebuffer-no-attachments-sample-counts :type %vk::sample-count-flags :optional t)
(:max-color-attachments :type :uint32)
(:sampled-image-color-sample-counts :type %vk::sample-count-flags :optional t)
(:sampled-image-integer-sample-counts :type %vk::sample-count-flags :optional t)
(:sampled-image-depth-sample-counts :type %vk::sample-count-flags :optional t)
(:sampled-image-stencil-sample-counts :type %vk::sample-count-flags :optional t)
(:storage-image-sample-counts :type %vk::sample-count-flags :optional t)
(:max-sample-mask-words :type :uint32)
(:timestamp-compute-and-graphics :type %vk::bool32)
(:timestamp-period :type :float)
(:max-clip-distances :type :uint32)
(:max-cull-distances :type :uint32)
(:max-combined-clip-and-cull-distances :type :uint32)
(:discrete-queue-priorities :type :uint32)
(:point-size-range :type :float)
(:line-width-range :type :float)
(:point-size-granularity :type :float)
(:line-width-granularity :type :float)
(:strict-lines :type %vk::bool32)
(:standard-sample-locations :type %vk::bool32)
(:optimal-buffer-copy-offset-alignment :type %vk::device-size)
(:optimal-buffer-copy-row-pitch-alignment :type %vk::device-size)
(:non-coherent-atom-size :type %vk::device-size)
))
(setf (gethash '%vk:physical-device-memory-properties *structs-plist-hash*) '(
(:memory-type-count :type :uint32)
(:memory-types :type (:struct %vk::memory-type) )
(:memory-heap-count :type :uint32)
(:memory-heaps :type (:struct %vk::memory-heap) )
))
(setf (gethash '%vk:physical-device-memory-properties-2-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:memory-properties :type (:struct %vk::physical-device-memory-properties) )
))
(setf (gethash '%vk:physical-device-multiview-features-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:multiview :type %vk::bool32)
(:multiview-geometry-shader :type %vk::bool32)
(:multiview-tessellation-shader :type %vk::bool32)
))
(setf (gethash '%vk:physical-device-multiview-per-view-attributes-properties-nvx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:per-view-position-all-components :type %vk::bool32)
))
(setf (gethash '%vk:physical-device-multiview-properties-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:max-multiview-view-count :type :uint32)
(:max-multiview-instance-index :type :uint32)
))
(setf (gethash '%vk:physical-device-properties *structs-plist-hash*) '(
(:api-version :type :uint32)
(:driver-version :type :uint32)
(:vendor-id :type :uint32)
(:device-id :type :uint32)
(:device-type :type %vk::physical-device-type)
(:device-name :type :char)
(:pipeline-cache-uuid :type :uint8)
(:limits :type (:struct %vk::physical-device-limits) )
(:sparse-properties :type (:struct %vk::physical-device-sparse-properties) )
))
(setf (gethash '%vk:physical-device-properties-2-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:properties :type (:struct %vk::physical-device-properties) )
))
(setf (gethash '%vk:physical-device-push-descriptor-properties-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:max-push-descriptors :type :uint32)
))
(setf (gethash '%vk:physical-device-sparse-image-format-info-2-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:format :type %vk::format)
(:type :type %vk::image-type)
(:samples :type %vk::sample-count-flag-bits)
(:usage :type %vk::image-usage-flags)
(:tiling :type %vk::image-tiling)
))
(setf (gethash '%vk:physical-device-sparse-properties *structs-plist-hash*) '(
(:residency-standard-2d-block-shape :type %vk::bool32)
(:residency-standard-2d-multisample-block-shape :type %vk::bool32)
(:residency-standard-3d-block-shape :type %vk::bool32)
(:residency-aligned-mip-size :type %vk::bool32)
(:residency-non-resident-strict :type %vk::bool32)
))
(setf (gethash '%vk:physical-device-surface-info-2-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:surface :type %vk::surface-khr :opaque t)
))
(setf (gethash '%vk:pipeline-cache-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-cache-create-flags :optional t)
(:initial-data-size :type %vk::size-t :optional t)
(:p-initial-data :type (:pointer :void)  :opaque t)
))
(setf (gethash '%vk:pipeline-color-blend-attachment-state *structs-plist-hash*) '(
(:blend-enable :type %vk::bool32)
(:src-color-blend-factor :type %vk::blend-factor)
(:dst-color-blend-factor :type %vk::blend-factor)
(:color-blend-op :type %vk::blend-op)
(:src-alpha-blend-factor :type %vk::blend-factor)
(:dst-alpha-blend-factor :type %vk::blend-factor)
(:alpha-blend-op :type %vk::blend-op)
(:color-write-mask :type %vk::color-component-flags :optional t)
))
(setf (gethash '%vk:pipeline-color-blend-state-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-color-blend-state-create-flags :optional t)
(:logic-op-enable :type %vk::bool32)
(:logic-op :type %vk::logic-op)
(:attachment-count :type :uint32 :optional t)
(:p-attachments :type (:pointer (:struct %vk::pipeline-color-blend-attachment-state)) )
(:blend-constants :type :float)
))
(setf (gethash '%vk:pipeline-depth-stencil-state-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-depth-stencil-state-create-flags :optional t)
(:depth-test-enable :type %vk::bool32)
(:depth-write-enable :type %vk::bool32)
(:depth-compare-op :type %vk::compare-op)
(:depth-bounds-test-enable :type %vk::bool32)
(:stencil-test-enable :type %vk::bool32)
(:front :type (:struct %vk::stencil-op-state) )
(:back :type (:struct %vk::stencil-op-state) )
(:min-depth-bounds :type :float)
(:max-depth-bounds :type :float)
))
(setf (gethash '%vk:pipeline-discard-rectangle-state-create-info-ext *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-discard-rectangle-state-create-flags-ext :optional t)
(:discard-rectangle-mode :type %vk::discard-rectangle-mode-ext)
(:discard-rectangle-count :type :uint32 :optional t)
(:p-discard-rectangles :type (:pointer (:struct %vk::rect-2d))  :optional t)
))
(setf (gethash '%vk:pipeline-dynamic-state-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-dynamic-state-create-flags :optional t)
(:dynamic-state-count :type :uint32)
(:p-dynamic-states :type (:pointer %vk::dynamic-state) )
))
(setf (gethash '%vk:pipeline-input-assembly-state-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-input-assembly-state-create-flags :optional t)
(:topology :type %vk::primitive-topology)
(:primitive-restart-enable :type %vk::bool32)
))
(setf (gethash '%vk:pipeline-layout-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-layout-create-flags :optional t)
(:set-layout-count :type :uint32 :optional t)
(:p-set-layouts :type (:pointer %vk::descriptor-set-layout)  :opaque t)
(:push-constant-range-count :type :uint32 :optional t)
(:p-push-constant-ranges :type (:pointer (:struct %vk::push-constant-range)) )
))
(setf (gethash '%vk:pipeline-multisample-state-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-multisample-state-create-flags :optional t)
(:rasterization-samples :type %vk::sample-count-flag-bits)
(:sample-shading-enable :type %vk::bool32)
(:min-sample-shading :type :float)
(:p-sample-mask :type (:pointer %vk::sample-mask)  :optional t)
(:alpha-to-coverage-enable :type %vk::bool32)
(:alpha-to-one-enable :type %vk::bool32)
))
(setf (gethash '%vk:pipeline-rasterization-state-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-rasterization-state-create-flags :optional t)
(:depth-clamp-enable :type %vk::bool32)
(:rasterizer-discard-enable :type %vk::bool32)
(:polygon-mode :type %vk::polygon-mode)
(:cull-mode :type %vk::cull-mode-flags :optional t)
(:front-face :type %vk::front-face)
(:depth-bias-enable :type %vk::bool32)
(:depth-bias-constant-factor :type :float)
(:depth-bias-clamp :type :float)
(:depth-bias-slope-factor :type :float)
(:line-width :type :float)
))
(setf (gethash '%vk:pipeline-rasterization-state-rasterization-order-amd *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:rasterization-order :type %vk::rasterization-order-amd)
))
(setf (gethash '%vk:pipeline-shader-stage-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-shader-stage-create-flags :optional t)
(:stage :type %vk::shader-stage-flag-bits)
(:module :type %vk::shader-module :opaque t)
(:p-name :type (:pointer :char) )
(:p-specialization-info :type (:pointer (:struct %vk::specialization-info))  :optional t)
))
(setf (gethash '%vk:pipeline-tessellation-state-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-tessellation-state-create-flags :optional t)
(:patch-control-points :type :uint32)
))
(setf (gethash '%vk:pipeline-vertex-input-state-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-vertex-input-state-create-flags :optional t)
(:vertex-binding-description-count :type :uint32 :optional t)
(:p-vertex-binding-descriptions :type (:pointer (:struct %vk::vertex-input-binding-description)) )
(:vertex-attribute-description-count :type :uint32 :optional t)
(:p-vertex-attribute-descriptions :type (:pointer (:struct %vk::vertex-input-attribute-description)) )
))
(setf (gethash '%vk:pipeline-viewport-state-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-viewport-state-create-flags :optional t)
(:viewport-count :type :uint32)
(:p-viewports :type (:pointer (:struct %vk::viewport))  :optional t)
(:scissor-count :type :uint32)
(:p-scissors :type (:pointer (:struct %vk::rect-2d))  :optional t)
))
(setf (gethash '%vk:pipeline-viewport-swizzle-state-create-info-nv *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::pipeline-viewport-swizzle-state-create-flags-nv :optional t)
(:viewport-count :type :uint32)
(:p-viewport-swizzles :type (:pointer (:struct %vk::viewport-swizzle-nv))  :optional t)
))
(setf (gethash '%vk:pipeline-viewport-w-scaling-state-create-info-nv *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:viewport-w-scaling-enable :type %vk::bool32)
(:viewport-count :type :uint32)
(:p-viewport-w-scalings :type (:pointer (:struct %vk::viewport-w-scaling-nv)) )
))
(setf (gethash '%vk:present-info-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:wait-semaphore-count :type :uint32 :optional t)
(:p-wait-semaphores :type (:pointer %vk::semaphore)  :opaque t :optional t)
(:swapchain-count :type :uint32)
(:p-swapchains :type (:pointer %vk::swapchain-khr)  :opaque t)
(:p-image-indices :type (:pointer :uint32) )
(:p-results :type (:pointer %vk::result)  :optional t)
))
(setf (gethash '%vk:present-region-khr *structs-plist-hash*) '(
(:rectangle-count :type :uint32 :optional t)
(:p-rectangles :type (:pointer (:struct %vk::rect-layer-khr))  :optional t)
))
(setf (gethash '%vk:present-regions-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:swapchain-count :type :uint32)
(:p-regions :type (:pointer (:struct %vk::present-region-khr))  :optional t)
))
(setf (gethash '%vk:present-time-google *structs-plist-hash*) '(
(:present-id :type :uint32)
(:desired-present-time :type :uint64)
))
(setf (gethash '%vk:present-times-info-google *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:swapchain-count :type :uint32)
(:p-times :type (:pointer (:struct %vk::present-time-google))  :optional t)
))
(setf (gethash '%vk:push-constant-range *structs-plist-hash*) '(
(:stage-flags :type %vk::shader-stage-flags)
(:offset :type :uint32)
(:size :type :uint32)
))
(setf (gethash '%vk:query-pool-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::query-pool-create-flags :optional t)
(:query-type :type %vk::query-type)
(:query-count :type :uint32)
(:pipeline-statistics :type %vk::query-pipeline-statistic-flags :optional t)
))
(setf (gethash '%vk:queue-family-properties *structs-plist-hash*) '(
(:queue-flags :type %vk::queue-flags :optional t)
(:queue-count :type :uint32)
(:timestamp-valid-bits :type :uint32)
(:min-image-transfer-granularity :type (:struct %vk::extent-3d) )
))
(setf (gethash '%vk:queue-family-properties-2-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:queue-family-properties :type (:struct %vk::queue-family-properties) )
))
(setf (gethash '%vk:rect-2d *structs-plist-hash*) '(
(:offset :type (:struct %vk::offset-2d) )
(:extent :type (:struct %vk::extent-2d) )
))
(setf (gethash '%vk:rect-3d *structs-plist-hash*) '(
(:offset :type (:struct %vk::offset-3d) )
(:extent :type (:struct %vk::extent-3d) )
))
(setf (gethash '%vk:rect-layer-khr *structs-plist-hash*) '(
(:offset :type (:struct %vk::offset-2d) )
(:extent :type (:struct %vk::extent-2d) )
(:layer :type :uint32)
))
(setf (gethash '%vk:refresh-cycle-duration-google *structs-plist-hash*) '(
(:refresh-duration :type :uint64)
))
(setf (gethash '%vk:render-pass-begin-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:render-pass :type %vk::render-pass :opaque t)
(:framebuffer :type %vk::framebuffer :opaque t)
(:render-area :type (:struct %vk::rect-2d) )
(:clear-value-count :type :uint32 :optional t)
(:p-clear-values :type (:pointer (:union %vk::clear-value)) )
))
(setf (gethash '%vk:render-pass-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::render-pass-create-flags :optional t)
(:attachment-count :type :uint32 :optional t)
(:p-attachments :type (:pointer (:struct %vk::attachment-description)) )
(:subpass-count :type :uint32)
(:p-subpasses :type (:pointer (:struct %vk::subpass-description)) )
(:dependency-count :type :uint32 :optional t)
(:p-dependencies :type (:pointer (:struct %vk::subpass-dependency)) )
))
(setf (gethash '%vk:render-pass-multiview-create-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:subpass-count :type :uint32 :optional t)
(:p-view-masks :type (:pointer :uint32) )
(:dependency-count :type :uint32 :optional t)
(:p-view-offsets :type (:pointer :int32) )
(:correlation-mask-count :type :uint32 :optional t)
(:p-correlation-masks :type (:pointer :uint32) )
))
(setf (gethash '%vk:sampler-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::sampler-create-flags :optional t)
(:mag-filter :type %vk::filter)
(:min-filter :type %vk::filter)
(:mipmap-mode :type %vk::sampler-mipmap-mode)
(:address-mode-u :type %vk::sampler-address-mode)
(:address-mode-v :type %vk::sampler-address-mode)
(:address-mode-w :type %vk::sampler-address-mode)
(:mip-lod-bias :type :float)
(:anisotropy-enable :type %vk::bool32)
(:max-anisotropy :type :float)
(:compare-enable :type %vk::bool32)
(:compare-op :type %vk::compare-op)
(:min-lod :type :float)
(:max-lod :type :float)
(:border-color :type %vk::border-color)
(:unnormalized-coordinates :type %vk::bool32)
))
(setf (gethash '%vk:semaphore-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::semaphore-create-flags :optional t)
))
(setf (gethash '%vk:shader-module-create-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::shader-module-create-flags :optional t)
(:code-size :type %vk::size-t)
(:p-code :type (:pointer :char) )
))
(setf (gethash '%vk:shared-present-surface-capabilities-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:shared-present-supported-usage-flags :type %vk::image-usage-flags :optional t)
))
(setf (gethash '%vk:sparse-buffer-memory-bind-info *structs-plist-hash*) '(
(:buffer :type %vk::buffer :opaque t)
(:bind-count :type :uint32)
(:p-binds :type (:pointer (:struct %vk::sparse-memory-bind)) )
))
(setf (gethash '%vk:sparse-image-format-properties *structs-plist-hash*) '(
(:aspect-mask :type %vk::image-aspect-flags :optional t)
(:image-granularity :type (:struct %vk::extent-3d) )
(:flags :type %vk::sparse-image-format-flags :optional t)
))
(setf (gethash '%vk:sparse-image-format-properties-2-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:properties :type (:struct %vk::sparse-image-format-properties) )
))
(setf (gethash '%vk:sparse-image-memory-bind *structs-plist-hash*) '(
(:subresource :type (:struct %vk::image-subresource) )
(:offset :type (:struct %vk::offset-3d) )
(:extent :type (:struct %vk::extent-3d) )
(:memory :type %vk::device-memory :opaque t :optional t)
(:memory-offset :type %vk::device-size)
(:flags :type %vk::sparse-memory-bind-flags :optional t)
))
(setf (gethash '%vk:sparse-image-memory-bind-info *structs-plist-hash*) '(
(:image :type %vk::image :opaque t)
(:bind-count :type :uint32)
(:p-binds :type (:pointer (:struct %vk::sparse-image-memory-bind)) )
))
(setf (gethash '%vk:sparse-image-memory-requirements *structs-plist-hash*) '(
(:format-properties :type (:struct %vk::sparse-image-format-properties) )
(:image-mip-tail-first-lod :type :uint32)
(:image-mip-tail-size :type %vk::device-size)
(:image-mip-tail-offset :type %vk::device-size)
(:image-mip-tail-stride :type %vk::device-size)
))
(setf (gethash '%vk:sparse-image-opaque-memory-bind-info *structs-plist-hash*) '(
(:image :type %vk::image :opaque t)
(:bind-count :type :uint32)
(:p-binds :type (:pointer (:struct %vk::sparse-memory-bind)) )
))
(setf (gethash '%vk:sparse-memory-bind *structs-plist-hash*) '(
(:resource-offset :type %vk::device-size)
(:size :type %vk::device-size)
(:memory :type %vk::device-memory :opaque t :optional t)
(:memory-offset :type %vk::device-size)
(:flags :type %vk::sparse-memory-bind-flags :optional t)
))
(setf (gethash '%vk:specialization-info *structs-plist-hash*) '(
(:map-entry-count :type :uint32 :optional t)
(:p-map-entries :type (:pointer (:struct %vk::specialization-map-entry)) )
(:data-size :type %vk::size-t :optional t)
(:p-data :type (:pointer :void)  :opaque t)
))
(setf (gethash '%vk:specialization-map-entry *structs-plist-hash*) '(
(:constant-id :type :uint32)
(:offset :type :uint32)
(:size :type %vk::size-t)
))
(setf (gethash '%vk:stencil-op-state *structs-plist-hash*) '(
(:fail-op :type %vk::stencil-op)
(:pass-op :type %vk::stencil-op)
(:depth-fail-op :type %vk::stencil-op)
(:compare-op :type %vk::compare-op)
(:compare-mask :type :uint32)
(:write-mask :type :uint32)
(:reference :type :uint32)
))
(setf (gethash '%vk:submit-info *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:wait-semaphore-count :type :uint32 :optional t)
(:p-wait-semaphores :type (:pointer %vk::semaphore)  :opaque t)
(:p-wait-dst-stage-mask :type (:pointer %vk::pipeline-stage-flags) )
(:command-buffer-count :type :uint32 :optional t)
(:p-command-buffers :type (:pointer %vk::command-buffer)  :opaque t)
(:signal-semaphore-count :type :uint32 :optional t)
(:p-signal-semaphores :type (:pointer %vk::semaphore)  :opaque t)
))
(setf (gethash '%vk:subpass-dependency *structs-plist-hash*) '(
(:src-subpass :type :uint32)
(:dst-subpass :type :uint32)
(:src-stage-mask :type %vk::pipeline-stage-flags)
(:dst-stage-mask :type %vk::pipeline-stage-flags)
(:src-access-mask :type %vk::access-flags :optional t)
(:dst-access-mask :type %vk::access-flags :optional t)
(:dependency-flags :type %vk::dependency-flags :optional t)
))
(setf (gethash '%vk:subpass-description *structs-plist-hash*) '(
(:flags :type %vk::subpass-description-flags :optional t)
(:pipeline-bind-point :type %vk::pipeline-bind-point)
(:input-attachment-count :type :uint32 :optional t)
(:p-input-attachments :type (:pointer (:struct %vk::attachment-reference)) )
(:color-attachment-count :type :uint32 :optional t)
(:p-color-attachments :type (:pointer (:struct %vk::attachment-reference)) )
(:p-resolve-attachments :type (:pointer (:struct %vk::attachment-reference))  :optional t)
(:p-depth-stencil-attachment :type (:pointer (:struct %vk::attachment-reference))  :optional t)
(:preserve-attachment-count :type :uint32 :optional t)
(:p-preserve-attachments :type (:pointer :uint32) )
))
(setf (gethash '%vk:subresource-layout *structs-plist-hash*) '(
(:offset :type %vk::device-size)
(:size :type %vk::device-size)
(:row-pitch :type %vk::device-size)
(:array-pitch :type %vk::device-size)
(:depth-pitch :type %vk::device-size)
))
(setf (gethash '%vk:surface-capabilities-2-ext *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:min-image-count :type :uint32)
(:max-image-count :type :uint32)
(:current-extent :type (:struct %vk::extent-2d) )
(:min-image-extent :type (:struct %vk::extent-2d) )
(:max-image-extent :type (:struct %vk::extent-2d) )
(:max-image-array-layers :type :uint32)
(:supported-transforms :type %vk::surface-transform-flags-khr :optional t)
(:current-transform :type %vk::surface-transform-flag-bits-khr)
(:supported-composite-alpha :type %vk::composite-alpha-flags-khr :optional t)
(:supported-usage-flags :type %vk::image-usage-flags :optional t)
(:supported-surface-counters :type %vk::surface-counter-flags-ext :optional t)
))
(setf (gethash '%vk:surface-capabilities-2-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:surface-capabilities :type (:struct %vk::surface-capabilities-khr) )
))
(setf (gethash '%vk:surface-capabilities-khr *structs-plist-hash*) '(
(:min-image-count :type :uint32)
(:max-image-count :type :uint32)
(:current-extent :type (:struct %vk::extent-2d) )
(:min-image-extent :type (:struct %vk::extent-2d) )
(:max-image-extent :type (:struct %vk::extent-2d) )
(:max-image-array-layers :type :uint32)
(:supported-transforms :type %vk::surface-transform-flags-khr :optional t)
(:current-transform :type %vk::surface-transform-flag-bits-khr)
(:supported-composite-alpha :type %vk::composite-alpha-flags-khr :optional t)
(:supported-usage-flags :type %vk::image-usage-flags :optional t)
))
(setf (gethash '%vk:surface-format-2-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:surface-format :type (:struct %vk::surface-format-khr) )
))
(setf (gethash '%vk:surface-format-khr *structs-plist-hash*) '(
(:format :type %vk::format)
(:color-space :type %vk::color-space-khr)
))
(setf (gethash '%vk:swapchain-counter-create-info-ext *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:surface-counters :type %vk::surface-counter-flags-ext :optional t)
))
(setf (gethash '%vk:swapchain-create-info-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::swapchain-create-flags-khr :optional t)
(:surface :type %vk::surface-khr :opaque t)
(:min-image-count :type :uint32)
(:image-format :type %vk::format)
(:image-color-space :type %vk::color-space-khr)
(:image-extent :type (:struct %vk::extent-2d) )
(:image-array-layers :type :uint32)
(:image-usage :type %vk::image-usage-flags)
(:image-sharing-mode :type %vk::sharing-mode)
(:queue-family-index-count :type :uint32 :optional t)
(:p-queue-family-indices :type (:pointer :uint32) )
(:pre-transform :type %vk::surface-transform-flag-bits-khr)
(:composite-alpha :type %vk::composite-alpha-flag-bits-khr)
(:present-mode :type %vk::present-mode-khr)
(:clipped :type %vk::bool32)
(:old-swapchain :type %vk::swapchain-khr :opaque t :optional t)
))
(setf (gethash '%vk:texture-l-o-d-gather-format-properties-amd *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:supports-texture-gather-l-o-d-bias-a-m-d :type %vk::bool32)
))
(setf (gethash '%vk:validation-flags-ext *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:disabled-validation-check-count :type :uint32)
(:p-disabled-validation-checks :type (:pointer %vk::validation-check-ext) )
))
(setf (gethash '%vk:vertex-input-attribute-description *structs-plist-hash*) '(
(:location :type :uint32)
(:binding :type :uint32)
(:format :type %vk::format)
(:offset :type :uint32)
))
(setf (gethash '%vk:vertex-input-binding-description *structs-plist-hash*) '(
(:binding :type :uint32)
(:stride :type :uint32)
(:input-rate :type %vk::vertex-input-rate)
))
(setf (gethash '%vk:vi-surface-create-info-nn *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::vi-surface-create-flags-nn :optional t)
(:window :type (:pointer :void)  :opaque t)
))
(setf (gethash '%vk:viewport *structs-plist-hash*) '(
(:x :type :float)
(:y :type :float)
(:width :type :float)
(:height :type :float)
(:min-depth :type :float)
(:max-depth :type :float)
))
(setf (gethash '%vk:viewport-swizzle-nv *structs-plist-hash*) '(
(:x :type %vk::viewport-coordinate-swizzle-nv)
(:y :type %vk::viewport-coordinate-swizzle-nv)
(:z :type %vk::viewport-coordinate-swizzle-nv)
(:w :type %vk::viewport-coordinate-swizzle-nv)
))
(setf (gethash '%vk:viewport-w-scaling-nv *structs-plist-hash*) '(
(:xcoeff :type :float)
(:ycoeff :type :float)
))
(setf (gethash '%vk:wayland-surface-create-info-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::wayland-surface-create-flags-khr :optional t)
(:display :type (:pointer (:struct %vk::wl_display))  :opaque t)
(:surface :type (:pointer (:struct %vk::wl_surface))  :opaque t)
))
(setf (gethash '%vk:win32-keyed-mutex-acquire-release-info-khx *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:acquire-count :type :uint32 :optional t)
(:p-acquire-syncs :type (:pointer %vk::device-memory)  :opaque t)
(:p-acquire-keys :type (:pointer :uint64) )
(:p-acquire-timeouts :type (:pointer :uint32) )
(:release-count :type :uint32 :optional t)
(:p-release-syncs :type (:pointer %vk::device-memory)  :opaque t)
(:p-release-keys :type (:pointer :uint64) )
))
(setf (gethash '%vk:win32-keyed-mutex-acquire-release-info-nv *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:acquire-count :type :uint32 :optional t)
(:p-acquire-syncs :type (:pointer %vk::device-memory)  :opaque t)
(:p-acquire-keys :type (:pointer :uint64) )
(:p-acquire-timeout-milliseconds :type (:pointer :uint32) )
(:release-count :type :uint32 :optional t)
(:p-release-syncs :type (:pointer %vk::device-memory)  :opaque t)
(:p-release-keys :type (:pointer :uint64) )
))
(setf (gethash '%vk:win32-surface-create-info-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::win32-surface-create-flags-khr :optional t)
(:hinstance :type %vk::hinstance)
(:hwnd :type %vk::hwnd)
))
(setf (gethash '%vk:write-descriptor-set *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:dst-set :type %vk::descriptor-set :opaque t)
(:dst-binding :type :uint32)
(:dst-array-element :type :uint32)
(:descriptor-count :type :uint32)
(:descriptor-type :type %vk::descriptor-type)
(:p-image-info :type (:pointer (:struct %vk::descriptor-image-info)) )
(:p-buffer-info :type (:pointer (:struct %vk::descriptor-buffer-info)) )
(:p-texel-buffer-view :type (:pointer %vk::buffer-view)  :opaque t)
))
(setf (gethash '%vk:x-y-color-ext *structs-plist-hash*) '(
(:x :type :float)
(:y :type :float)
))
(setf (gethash '%vk:xcb-surface-create-info-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::xcb-surface-create-flags-khr :optional t)
(:connection :type (:pointer %vk::xcb_connection_t)  :opaque t)
(:window :type %vk::xcb_window_t)
))
(setf (gethash '%vk:xlib-surface-create-info-khr *structs-plist-hash*) '(
(:s-type :type %vk::structure-type)
(:p-next :type (:pointer :void)  :opaque t)
(:flags :type %vk::xlib-surface-create-flags-khr :optional t)
(:dpy :type (:pointer %vk::display)  :opaque t)
(:window :type %vk::window)
)))

(prepare-structs-plist)
