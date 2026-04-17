#lang racket/base
;; scenekit-viewer.rkt — SceneKit Viewer sample app (OO style)
;;
;; A rotating 3D geometry (cube / sphere / torus / cylinder) the user
;; can swap via an NSPopUpButton and recolor via NSColorPanel. SCNView's
;; allowsCameraControl gives orbit-on-drag and scroll-to-zoom for free.
;;
;; Exercises: SceneKit framework end-to-end, chained object construction
;; (scene → node → geometry → material), NSColorPanel continuous
;; target-action, and two protocol-inherited methods reached via typed
;; objc_msgSend aliases (runAction: on SCNActionable, setAutoenables-
;; DefaultLighting: on SCNSceneRenderer — neither is emitted on the
;; class binding because the generator does not currently emit
;; protocol-inherited methods).
;;
;; Run with: racket scenekit-viewer.rkt

(require ffi/unsafe
         ffi/unsafe/objc
         "../../generated/oo/appkit/nsapplication.rkt"
         "../../generated/oo/appkit/nswindow.rkt"
         "../../generated/oo/appkit/nsview.rkt"
         "../../generated/oo/appkit/nsbutton.rkt"
         "../../generated/oo/appkit/nspopupbutton.rkt"
         "../../generated/oo/appkit/nsstackview.rkt"
         "../../generated/oo/appkit/nscolor.rkt"
         "../../generated/oo/appkit/nscolorpanel.rkt"
         "../../generated/oo/appkit/nscolorspace.rkt"
         "../../generated/oo/scenekit/scnview.rkt"
         "../../generated/oo/scenekit/scnscene.rkt"
         "../../generated/oo/scenekit/scnnode.rkt"
         "../../generated/oo/scenekit/scnbox.rkt"
         "../../generated/oo/scenekit/scnsphere.rkt"
         "../../generated/oo/scenekit/scntorus.rkt"
         "../../generated/oo/scenekit/scncylinder.rkt"
         "../../generated/oo/scenekit/scngeometry.rkt"
         "../../generated/oo/scenekit/scnmaterial.rkt"
         "../../generated/oo/scenekit/scnmaterialproperty.rkt"
         "../../generated/oo/scenekit/scnaction.rkt"
         "../../runtime/objc-base.rkt"
         "../../runtime/type-mapping.rkt"
         "../../runtime/coerce.rkt"
         "../../runtime/delegate.rkt"
         "../../runtime/app-menu.rkt")

;; --- Constants (not yet extracted by collector) ---
;; NSWindowStyleMask
(define NSWindowStyleMaskTitled         1)
(define NSWindowStyleMaskClosable       2)
(define NSWindowStyleMaskMiniaturizable 4)
(define NSWindowStyleMaskResizable      8)
;; NSBackingStoreType
(define NSBackingStoreBuffered 2)
;; NSBezelStyle
(define NSBezelStyleRounded 1)
;; NSViewAutoresizingMask
(define NSViewWidthSizable  2)
(define NSViewHeightSizable 16)
(define NSViewMinYMargin    8)
;; NSUserInterfaceLayoutOrientation
(define NSUserInterfaceLayoutOrientationHorizontal 0)
;; NSLayoutAttribute
(define NSLayoutAttributeFirstBaseline 12)

;; --- Typed objc_msgSend aliases for protocol-inherited methods ---
;;
;; Two selectors reach protocol methods the generator does not emit on
;; the class binding:
;;   -[SCNNode runAction:]                (SCNActionable protocol)
;;   -[SCNView setAutoenablesDefaultLighting:]  (SCNSceneRenderer protocol)
;; Typed objc_msgSend aliases bypass `tell` the same way app-menu.rkt
;; does for SEL-taking menu selectors — no special-cased args in `tell`
;; are required.
(define _objc-lib (ffi-lib "libobjc"))
(define _msg-run-action
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))
(define _msg-set-autoenables-default-lighting
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool -> _void)))
(define sel-run-action (sel_registerName "runAction:"))
(define sel-set-autoenables-default-lighting
  (sel_registerName "setAutoenablesDefaultLighting:"))

(define (node-run-action! node action)
  (_msg-run-action (coerce-arg node) sel-run-action (coerce-arg action)))

(define (scn-view-set-autoenables-default-lighting! scn-view enabled?)
  (_msg-set-autoenables-default-lighting (coerce-arg scn-view)
                                         sel-set-autoenables-default-lighting
                                         enabled?))

;; --- Application setup ---
(define app (nsapplication-shared-application))
(nsapplication-set-activation-policy! app 0)
(install-standard-app-menu! app "SceneKit Viewer")

;; --- Window ---
(define window
  (make-nswindow-init-with-content-rect-style-mask-backing-defer
   (make-nsrect 0 0 640 480)
   (bitwise-ior NSWindowStyleMaskTitled
                NSWindowStyleMaskClosable
                NSWindowStyleMaskMiniaturizable
                NSWindowStyleMaskResizable)
   NSBackingStoreBuffered
   #f))
(nswindow-set-title! window "SceneKit Viewer")
(nswindow-center! window)
(nswindow-set-min-size! window (make-nssize 480 360))

(define content-view (nswindow-content-view window))

;; --- Toolbar controls ---
(define geometry-picker
  (make-nspopupbutton-init-with-frame-pulls-down (make-nsrect 0 0 140 28) #f))
(nspopupbutton-add-item-with-title! geometry-picker "Cube")
(nspopupbutton-add-item-with-title! geometry-picker "Sphere")
(nspopupbutton-add-item-with-title! geometry-picker "Torus")
(nspopupbutton-add-item-with-title! geometry-picker "Cylinder")

(define color-button (make-nsbutton-init-with-frame (make-nsrect 0 0 80 28)))
(nsbutton-set-title! color-button "Color…")
(nsbutton-set-bezel-style! color-button NSBezelStyleRounded)

(define toolbar-stack
  (make-nsstackview-init-with-frame (make-nsrect 12 440 616 32)))
(nsstackview-set-orientation! toolbar-stack NSUserInterfaceLayoutOrientationHorizontal)
(nsstackview-set-alignment! toolbar-stack NSLayoutAttributeFirstBaseline)
(nsstackview-set-spacing! toolbar-stack 8.0)
(nsstackview-add-arranged-subview! toolbar-stack geometry-picker)
(nsstackview-add-arranged-subview! toolbar-stack color-button)
(nsview-set-autoresizing-mask! toolbar-stack
  (bitwise-ior NSViewWidthSizable NSViewMinYMargin))
(nsview-add-subview! content-view toolbar-stack)

;; --- SCNView ---
;; Fills the window below the toolbar. `allowsCameraControl` is the
;; whole reason this app doesn't need a custom SCNView subclass or any
;; SCNVector3 plumbing for camera positioning — SceneKit installs a
;; default camera controller that the user drives with the mouse.
;; `autoenablesDefaultLighting` gives the rendered geometry an ambient
;; + directional key light without having to wire an SCNLight node.
(define scn-view
  (make-scnview-init-with-frame (make-nsrect 0 0 640 432)))
(nsview-set-autoresizing-mask! scn-view
  (bitwise-ior NSViewWidthSizable NSViewHeightSizable))
(scnview-set-allows-camera-control! scn-view #t)
(scn-view-set-autoenables-default-lighting! scn-view #t)
(scnview-set-background-color! scn-view (nscolor-dark-gray-color))
(nsview-add-subview! content-view scn-view)

;; --- Scene + geometry node ---
(define scene (scnscene-scene))
(scnview-set-scene! scn-view scene)
(define root-node (scnscene-root-node scene))

(define (make-geometry index)
  (cond
    [(= index 0) (scnbox-box-with-width-height-length-chamfer-radius 2.0 2.0 2.0 0.1)]
    [(= index 1) (scnsphere-sphere-with-radius 1.2)]
    [(= index 2) (scntorus-torus-with-ring-radius-pipe-radius 1.0 0.35)]
    [(= index 3) (scncylinder-cylinder-with-radius-height 1.0 2.0)]
    [else (scnbox-box-with-width-height-length-chamfer-radius 2.0 2.0 2.0 0.1)]))

(define geometry-node (scnnode-node-with-geometry (make-geometry 0)))
(scnnode-add-child-node! root-node geometry-node)

;; --- Material color state ---
;;
;; Track the current NSColor in Racket state so geometry swaps re-apply
;; the user's choice to the new material. SceneKit creates a fresh
;; firstMaterial for every geometry — if we didn't re-apply, every swap
;; would reset the color to white.
(define current-color (nscolor-system-red-color))

(define (apply-current-color!)
  (define geom (scnnode-geometry geometry-node))
  (when geom
    (define material (scngeometry-first-material geom))
    (when material
      (define property (scnmaterial-diffuse material))
      (when property
        (scnmaterialproperty-set-contents! property current-color)))))

(apply-current-color!)

;; --- Rotation animation ---
;;
;; rotateByX:y:z:duration: is a single finite rotate; wrapping it in
;; repeatActionForever: yields a continuous spin. The action is
;; installed once via the typed runAction: alias above and runs
;; independently of geometry swaps — swapping `node.geometry` does not
;; cancel actions on the node, so the spin survives across picker
;; changes without any extra bookkeeping.
(define spin-action
  (scnaction-repeat-action-forever
   (scnaction-rotate-by-x-y-z-duration 0.0 1.5 0.0 4.0)))
(node-run-action! geometry-node spin-action)

;; --- Target-action wiring ---
(define toolbar-target
  (make-delegate
   #:return-types (hash "geometryChanged:" 'void
                        "openColor:"       'void
                        "colorChanged:"    'void)
   ;; colorChanged: sender is the NSColorPanel — wrap the raw cpointer
   ;; arg so nscolorpanel-color's self contract accepts it.
   #:param-types  (hash "colorChanged:" '(object))
   "geometryChanged:"
   (lambda (_sender)
     (define idx (nspopupbutton-index-of-selected-item geometry-picker))
     (scnnode-set-geometry! geometry-node (make-geometry idx))
     (apply-current-color!))
   "openColor:"
   (lambda (_sender)
     (define panel (nscolorpanel-shared-color-panel))
     (nscolorpanel-set-target! panel toolbar-target)
     (nscolorpanel-set-action! panel "colorChanged:")
     (nscolorpanel-set-continuous! panel #t)
     (nscolorpanel-make-key-and-order-front panel #f))
   "colorChanged:"
   (lambda (sender)
     ;; NSColorPanel colors can be in any color space — normalize to
     ;; device-RGB before use so downstream component accessors (if we
     ;; ever add them for HUD display) don't raise. Even for the
     ;; SceneKit material path, which doesn't call -redComponent etc.
     ;; directly, the conversion is cheap insurance against a color
     ;; space SceneKit can't sample from.
     (with-handlers ([exn:fail?
                      (lambda (e)
                        (eprintf "colorChanged: ~a\n" (exn-message e)))])
       (define raw (nscolorpanel-color sender))
       (when raw
         (define rgb (nscolor-color-using-color-space
                      raw (nscolorspace-device-rgb-color-space)))
         (when rgb
           (set! current-color rgb)
           (apply-current-color!)))))))

(nspopupbutton-set-target! geometry-picker toolbar-target)
(nspopupbutton-set-action! geometry-picker "geometryChanged:")
(nsbutton-set-target! color-button toolbar-target)
(nsbutton-set-action! color-button "openColor:")

;; --- Show window and run ---
(nswindow-make-key-and-order-front window #f)
(nsapplication-activate-ignoring-other-apps app #t)

(displayln "SceneKit Viewer running. Close window or Ctrl+C to exit.")
(nsapplication-run app)
