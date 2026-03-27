#lang racket/base
;; hello-window.rkt — Hello Window sample app (OO style)
;;
;; Minimal macOS GUI app: creates a window with a centered label.
;; Exercises: object lifecycle, property setters, NSWindow, NSApplication.
;;
;; Run with:
;;   racket generation/targets/racket/apps/oo/hello-window.rkt

(require ffi/unsafe
         ffi/unsafe/objc
         "../../runtime/objc-base.rkt"
         "../../runtime/coerce.rkt"
         "../../runtime/type-mapping.rkt"
         ;; Generated bindings — individual modules, not main.rkt
         "../../generated/oo/appkit/nsapplication.rkt"
         "../../generated/oo/appkit/nswindow.rkt"
         "../../generated/oo/appkit/nstextfield.rkt"
         "../../generated/oo/appkit/nsview.rkt"
         "../../generated/oo/appkit/nsfont.rkt")

;; --- AppKit constants (option sets not yet extracted by collector) ---

;; NSWindowStyleMask
(define NSWindowStyleMaskTitled 1)
(define NSWindowStyleMaskClosable 2)
(define NSWindowStyleMaskMiniaturizable 4)

;; NSBackingStoreType
(define NSBackingStoreBuffered 2)

;; NSTextAlignment
(define NSTextAlignmentCenter 2)

;; NSApplicationActivationPolicy
(define NSApplicationActivationPolicyRegular 0)

;; --- Application setup ---

(define app (nsapplication-shared-application))

;; Set activation policy to Regular (shows in dock)
(nsapplication-set-activation-policy! app NSApplicationActivationPolicyRegular)

;; --- Create window: 400x200, centered ---

(define window
  (make-nswindow-init-with-content-rect-style-mask-backing-defer
   (make-nsrect 0 0 400 200)
   (bitwise-ior NSWindowStyleMaskTitled
                NSWindowStyleMaskClosable
                NSWindowStyleMaskMiniaturizable)
   NSBackingStoreBuffered
   #f))

(nswindow-set-title! window "Hello from Racket")

;; --- Create label: centered in window ---
;; NSTextField renders text at the top of its frame, so we position the label
;; vertically centered. For 24pt system font (~30px line height), center in
;; the 200px window height: y = (200 - 30) / 2 = 85

(define label
  (make-nstextfield-init-with-frame (make-nsrect 0 85 400 30)))

(nstextfield-set-string-value! label "Hello, macOS!")
(nstextfield-set-alignment! label NSTextAlignmentCenter)
(nstextfield-set-editable! label #f)
(nstextfield-set-bezeled! label #f)
(nstextfield-set-draws-background! label #f)
(nstextfield-set-selectable! label #f)

;; Set font to system 24pt
(let ([font (nsfont-system-font-of-size 24.0)])
  (nstextfield-set-font! label font))

;; --- Add label to window's content view ---

(let ([content-view (nswindow-content-view window)])
  (nsview-add-subview! content-view label))

;; --- Show window ---

(nswindow-center! window)
(nswindow-make-key-and-order-front window #f)
(nsapplication-activate-ignoring-other-apps app #t)

(displayln "Hello Window opened. Close window or Ctrl+C to exit.")

;; --- Enter run loop ---

(nsapplication-run app)
