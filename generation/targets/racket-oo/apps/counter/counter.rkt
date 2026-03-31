#lang racket/base
;; counter.rkt — Counter sample app (OO style)
;;
;; Window with +/−/Reset buttons and a large counter display.
;; Exercises: target-action pattern, delegate bridging, mutable state, buttons.
;;
;; Run with: racket counter.rkt

(require ffi/unsafe
         ffi/unsafe/objc
         "../../../generated/oo/appkit/nsapplication.rkt"
         "../../../generated/oo/appkit/nswindow.rkt"
         "../../../generated/oo/appkit/nsbutton.rkt"
         "../../../generated/oo/appkit/nstextfield.rkt"
         "../../../generated/oo/appkit/nsview.rkt"
         "../../../generated/oo/appkit/nsfont.rkt"
         "../../../runtime/objc-base.rkt"
         "../../../runtime/type-mapping.rkt"
         "../../../runtime/delegate.rkt")

;; --- Constants (not yet extracted by collector) ---
;; NSWindowStyleMask
(define NSWindowStyleMaskTitled 1)
(define NSWindowStyleMaskClosable 2)
(define NSWindowStyleMaskMiniaturizable 4)
;; NSBackingStoreType
(define NSBackingStoreBuffered 2)
;; NSTextAlignment (macOS: Left=0, Center=1, Right=2)
(define NSTextAlignmentCenter 1)
;; NSBezelStyle
(define NSBezelStyleRounded 1)

;; --- Application setup ---
(define app (nsapplication-shared-application))
(nsapplication-set-activation-policy! app 0) ; NSApplicationActivationPolicyRegular

;; --- Create window (300x180, centered, not resizable) ---
(define window
  (make-nswindow-init-with-content-rect-style-mask-backing-defer
   (make-nsrect 0 0 300 180)
   (bitwise-ior NSWindowStyleMaskTitled
                NSWindowStyleMaskClosable
                NSWindowStyleMaskMiniaturizable)
   NSBackingStoreBuffered
   #f))

(nswindow-set-title! window "Counter")
(nswindow-center! window)

(define content-view (nswindow-content-view window))

;; --- Counter state ---
(define counter 0)

;; --- Counter label (centered, upper area, 48pt bold) ---
(define counter-label
  (make-nstextfield-init-with-frame (make-nsrect 0 90 300 60)))

(nstextfield-set-string-value! counter-label "0")
(nstextfield-set-font! counter-label (nsfont-bold-system-font-of-size 48.0))
(nstextfield-set-alignment! counter-label NSTextAlignmentCenter)
(nstextfield-set-editable! counter-label #f)
(nstextfield-set-selectable! counter-label #f)
(nstextfield-set-bezeled! counter-label #f)
(nstextfield-set-draws-background! counter-label #f)
(nsview-add-subview! content-view counter-label)

;; --- Helper: update the label from counter ---
(define (update-label!)
  (nstextfield-set-string-value! counter-label (number->string counter)))

;; --- Target object for button actions ---
(define target
  (make-delegate
   #:return-types (hash "increment:" 'void "decrement:" 'void "reset:" 'void)
   "increment:" (lambda (sender)
                  (set! counter (add1 counter))
                  (update-label!))
   "decrement:" (lambda (sender)
                  (set! counter (sub1 counter))
                  (update-label!))
   "reset:"     (lambda (sender)
                  (set! counter 0)
                  (update-label!))))

;; --- Helper: create a button ---
(define (make-action-button x title action-sel)
  (let ([btn (make-nsbutton-init-with-frame (make-nsrect x 20 80 32))])
    (nsbutton-set-title! btn title)
    (nsbutton-set-bezel-style! btn NSBezelStyleRounded)
    (nsbutton-set-target! btn target)
    (nsbutton-set-action! btn (sel_registerName action-sel))
    (nsview-add-subview! content-view btn)
    btn))

;; --- Buttons (evenly spaced across 300px width) ---
;; 3 buttons of 80px each = 240px, leaving 60px gap → 15px margins, 30px between
(define btn-minus (make-action-button 15  "\u2212" "decrement:"))
(define btn-reset (make-action-button 110 "Reset" "reset:"))
(define btn-plus  (make-action-button 205 "+"     "increment:"))

;; --- Show window and run ---
(nswindow-make-key-and-order-front window #f)
(nsapplication-activate-ignoring-other-apps app #t)

(displayln "Counter app running. Close window or Ctrl+C to exit.")
(nsapplication-run app)
