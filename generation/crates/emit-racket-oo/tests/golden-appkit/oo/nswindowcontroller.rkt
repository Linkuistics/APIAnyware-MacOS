#lang racket/base
;; Generated binding for NSWindowController (AppKit)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         (rename-in racket/contract [-> c->])
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/AppKit.framework/AppKit"))
(define _objc-lib (ffi-lib "libobjc"))

(provide NSWindowController)
(provide/contract
  [make-nswindowcontroller-init-with-coder (c-> (or/c string? objc-object? cpointer?) any/c)]
  [make-nswindowcontroller-init-with-window (c-> (or/c string? objc-object? cpointer?) any/c)]
  [make-nswindowcontroller-init-with-window-nib-name (c-> (or/c string? objc-object? cpointer?) any/c)]
  [make-nswindowcontroller-init-with-window-nib-name-owner (c-> (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) any/c)]
  [make-nswindowcontroller-init-with-window-nib-path-owner (c-> (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) any/c)]
  [nswindowcontroller-accepts-first-responder (c-> objc-object? boolean?)]
  [nswindowcontroller-content-view-controller (c-> objc-object? any/c)]
  [nswindowcontroller-set-content-view-controller! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-document (c-> objc-object? any/c)]
  [nswindowcontroller-set-document! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-menu (c-> objc-object? any/c)]
  [nswindowcontroller-set-menu! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-next-responder (c-> objc-object? any/c)]
  [nswindowcontroller-set-next-responder! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-owner (c-> objc-object? any/c)]
  [nswindowcontroller-preview-representable-activity-items (c-> objc-object? any/c)]
  [nswindowcontroller-set-preview-representable-activity-items! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-restorable-state-key-paths (c-> any/c)]
  [nswindowcontroller-should-cascade-windows (c-> objc-object? boolean?)]
  [nswindowcontroller-set-should-cascade-windows! (c-> objc-object? boolean? void?)]
  [nswindowcontroller-should-close-document (c-> objc-object? boolean?)]
  [nswindowcontroller-set-should-close-document! (c-> objc-object? boolean? void?)]
  [nswindowcontroller-storyboard (c-> objc-object? any/c)]
  [nswindowcontroller-touch-bar (c-> objc-object? any/c)]
  [nswindowcontroller-set-touch-bar! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-undo-manager (c-> objc-object? any/c)]
  [nswindowcontroller-user-activity (c-> objc-object? any/c)]
  [nswindowcontroller-set-user-activity! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-window (c-> objc-object? any/c)]
  [nswindowcontroller-set-window! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-window-frame-autosave-name (c-> objc-object? any/c)]
  [nswindowcontroller-set-window-frame-autosave-name! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-window-loaded (c-> objc-object? boolean?)]
  [nswindowcontroller-window-nib-name (c-> objc-object? any/c)]
  [nswindowcontroller-window-nib-path (c-> objc-object? any/c)]
  [nswindowcontroller-become-first-responder (c-> objc-object? boolean?)]
  [nswindowcontroller-begin-gesture-with-event! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-change-mode-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-close! (c-> objc-object? void?)]
  [nswindowcontroller-context-menu-key-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-cursor-update (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-end-gesture-with-event! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-flags-changed (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-flush-buffered-key-events (c-> objc-object? void?)]
  [nswindowcontroller-help-requested (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-interpret-key-events (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-is-window-loaded (c-> objc-object? boolean?)]
  [nswindowcontroller-key-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-key-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-load-window (c-> objc-object? void?)]
  [nswindowcontroller-magnify-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-mouse-cancelled (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-mouse-entered (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-mouse-exited (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-mouse-moved (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-no-responder-for (c-> objc-object? cpointer? void?)]
  [nswindowcontroller-other-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-other-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-other-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-perform-key-equivalent! (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nswindowcontroller-pressure-change-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-quick-look-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-resign-first-responder (c-> objc-object? boolean?)]
  [nswindowcontroller-right-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-right-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-right-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-rotate-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-scroll-wheel (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-set-document-edited! (c-> objc-object? boolean? void?)]
  [nswindowcontroller-should-be-treated-as-ink-event (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nswindowcontroller-show-context-help (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-show-window (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-smart-magnify-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-supplemental-target-for-action-sender (c-> objc-object? cpointer? (or/c string? objc-object? cpointer?) any/c)]
  [nswindowcontroller-swipe-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-synchronize-window-title-with-document-name (c-> objc-object? void?)]
  [nswindowcontroller-tablet-point (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-tablet-proximity (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-touches-began-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-touches-cancelled-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-touches-ended-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-touches-moved-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nswindowcontroller-try-to-perform-with (c-> objc-object? cpointer? (or/c string? objc-object? cpointer?) boolean?)]
  [nswindowcontroller-valid-requestor-for-send-type-return-type (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) any/c)]
  [nswindowcontroller-wants-forwarded-scroll-events-for-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nswindowcontroller-wants-scroll-events-for-swipe-tracking-on-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nswindowcontroller-window-did-load (c-> objc-object? void?)]
  [nswindowcontroller-window-title-for-document-display-name (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nswindowcontroller-window-will-load (c-> objc-object? void?)]
  )

;; --- Class reference ---
(import-class NSWindowController)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-1  ; (_fun _pointer _pointer _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool -> _void)))
(define _msg-2  ; (_fun _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _bool)))
(define _msg-3  ; (_fun _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))
(define _msg-4  ; (_fun _pointer _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _bool)))
(define _msg-5  ; (_fun _pointer _pointer _pointer _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _id)))
(define _msg-6  ; (_fun _pointer _pointer _uint64 -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _bool)))

;; --- Constructors ---
(define (make-nswindowcontroller-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSWindowController alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))

(define (make-nswindowcontroller-init-with-window window)
  (wrap-objc-object
   (tell (tell NSWindowController alloc)
         initWithWindow: (coerce-arg window))
   #:retained #t))

(define (make-nswindowcontroller-init-with-window-nib-name window-nib-name)
  (wrap-objc-object
   (tell (tell NSWindowController alloc)
         initWithWindowNibName: (coerce-arg window-nib-name))
   #:retained #t))

(define (make-nswindowcontroller-init-with-window-nib-name-owner window-nib-name owner)
  (wrap-objc-object
   (tell (tell NSWindowController alloc)
         initWithWindowNibName: (coerce-arg window-nib-name) owner: (coerce-arg owner))
   #:retained #t))

(define (make-nswindowcontroller-init-with-window-nib-path-owner window-nib-path owner)
  (wrap-objc-object
   (tell (tell NSWindowController alloc)
         initWithWindowNibPath: (coerce-arg window-nib-path) owner: (coerce-arg owner))
   #:retained #t))


;; --- Properties ---
(define (nswindowcontroller-accepts-first-responder self)
  (tell #:type _bool (coerce-arg self) acceptsFirstResponder))
(define (nswindowcontroller-content-view-controller self)
  (wrap-objc-object
   (tell (coerce-arg self) contentViewController)))
(define (nswindowcontroller-set-content-view-controller! self value)
  (tell #:type _void (coerce-arg self) setContentViewController: (coerce-arg value)))
(define (nswindowcontroller-document self)
  (wrap-objc-object
   (tell (coerce-arg self) document)))
(define (nswindowcontroller-set-document! self value)
  (tell #:type _void (coerce-arg self) setDocument: (coerce-arg value)))
(define (nswindowcontroller-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) menu)))
(define (nswindowcontroller-set-menu! self value)
  (tell #:type _void (coerce-arg self) setMenu: (coerce-arg value)))
(define (nswindowcontroller-next-responder self)
  (wrap-objc-object
   (tell (coerce-arg self) nextResponder)))
(define (nswindowcontroller-set-next-responder! self value)
  (tell #:type _void (coerce-arg self) setNextResponder: (coerce-arg value)))
(define (nswindowcontroller-owner self)
  (wrap-objc-object
   (tell (coerce-arg self) owner)))
(define (nswindowcontroller-preview-representable-activity-items self)
  (wrap-objc-object
   (tell (coerce-arg self) previewRepresentableActivityItems)))
(define (nswindowcontroller-set-preview-representable-activity-items! self value)
  (tell #:type _void (coerce-arg self) setPreviewRepresentableActivityItems: (coerce-arg value)))
(define (nswindowcontroller-restorable-state-key-paths)
  (wrap-objc-object
   (tell NSWindowController restorableStateKeyPaths)))
(define (nswindowcontroller-should-cascade-windows self)
  (tell #:type _bool (coerce-arg self) shouldCascadeWindows))
(define (nswindowcontroller-set-should-cascade-windows! self value)
  (_msg-1 (coerce-arg self) (sel_registerName "setShouldCascadeWindows:") value))
(define (nswindowcontroller-should-close-document self)
  (tell #:type _bool (coerce-arg self) shouldCloseDocument))
(define (nswindowcontroller-set-should-close-document! self value)
  (_msg-1 (coerce-arg self) (sel_registerName "setShouldCloseDocument:") value))
(define (nswindowcontroller-storyboard self)
  (wrap-objc-object
   (tell (coerce-arg self) storyboard)))
(define (nswindowcontroller-touch-bar self)
  (wrap-objc-object
   (tell (coerce-arg self) touchBar)))
(define (nswindowcontroller-set-touch-bar! self value)
  (tell #:type _void (coerce-arg self) setTouchBar: (coerce-arg value)))
(define (nswindowcontroller-undo-manager self)
  (wrap-objc-object
   (tell (coerce-arg self) undoManager)))
(define (nswindowcontroller-user-activity self)
  (wrap-objc-object
   (tell (coerce-arg self) userActivity)))
(define (nswindowcontroller-set-user-activity! self value)
  (tell #:type _void (coerce-arg self) setUserActivity: (coerce-arg value)))
(define (nswindowcontroller-window self)
  (wrap-objc-object
   (tell (coerce-arg self) window)))
(define (nswindowcontroller-set-window! self value)
  (tell #:type _void (coerce-arg self) setWindow: (coerce-arg value)))
(define (nswindowcontroller-window-frame-autosave-name self)
  (wrap-objc-object
   (tell (coerce-arg self) windowFrameAutosaveName)))
(define (nswindowcontroller-set-window-frame-autosave-name! self value)
  (tell #:type _void (coerce-arg self) setWindowFrameAutosaveName: (coerce-arg value)))
(define (nswindowcontroller-window-loaded self)
  (tell #:type _bool (coerce-arg self) windowLoaded))
(define (nswindowcontroller-window-nib-name self)
  (wrap-objc-object
   (tell (coerce-arg self) windowNibName)))
(define (nswindowcontroller-window-nib-path self)
  (wrap-objc-object
   (tell (coerce-arg self) windowNibPath)))

;; --- Instance methods ---
(define (nswindowcontroller-become-first-responder self)
  (_msg-0 (coerce-arg self) (sel_registerName "becomeFirstResponder")))
(define (nswindowcontroller-begin-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) beginGestureWithEvent: (coerce-arg event)))
(define (nswindowcontroller-change-mode-with-event self event)
  (tell #:type _void (coerce-arg self) changeModeWithEvent: (coerce-arg event)))
(define (nswindowcontroller-close! self)
  (tell #:type _void (coerce-arg self) close))
(define (nswindowcontroller-context-menu-key-down self event)
  (tell #:type _void (coerce-arg self) contextMenuKeyDown: (coerce-arg event)))
(define (nswindowcontroller-cursor-update self event)
  (tell #:type _void (coerce-arg self) cursorUpdate: (coerce-arg event)))
(define (nswindowcontroller-end-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) endGestureWithEvent: (coerce-arg event)))
(define (nswindowcontroller-flags-changed self event)
  (tell #:type _void (coerce-arg self) flagsChanged: (coerce-arg event)))
(define (nswindowcontroller-flush-buffered-key-events self)
  (tell #:type _void (coerce-arg self) flushBufferedKeyEvents))
(define (nswindowcontroller-help-requested self event-ptr)
  (tell #:type _void (coerce-arg self) helpRequested: (coerce-arg event-ptr)))
(define (nswindowcontroller-interpret-key-events self event-array)
  (tell #:type _void (coerce-arg self) interpretKeyEvents: (coerce-arg event-array)))
(define (nswindowcontroller-is-window-loaded self)
  (_msg-0 (coerce-arg self) (sel_registerName "isWindowLoaded")))
(define (nswindowcontroller-key-down self event)
  (tell #:type _void (coerce-arg self) keyDown: (coerce-arg event)))
(define (nswindowcontroller-key-up self event)
  (tell #:type _void (coerce-arg self) keyUp: (coerce-arg event)))
(define (nswindowcontroller-load-window self)
  (tell #:type _void (coerce-arg self) loadWindow))
(define (nswindowcontroller-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) magnifyWithEvent: (coerce-arg event)))
(define (nswindowcontroller-mouse-cancelled self event)
  (tell #:type _void (coerce-arg self) mouseCancelled: (coerce-arg event)))
(define (nswindowcontroller-mouse-down self event)
  (tell #:type _void (coerce-arg self) mouseDown: (coerce-arg event)))
(define (nswindowcontroller-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) mouseDragged: (coerce-arg event)))
(define (nswindowcontroller-mouse-entered self event)
  (tell #:type _void (coerce-arg self) mouseEntered: (coerce-arg event)))
(define (nswindowcontroller-mouse-exited self event)
  (tell #:type _void (coerce-arg self) mouseExited: (coerce-arg event)))
(define (nswindowcontroller-mouse-moved self event)
  (tell #:type _void (coerce-arg self) mouseMoved: (coerce-arg event)))
(define (nswindowcontroller-mouse-up self event)
  (tell #:type _void (coerce-arg self) mouseUp: (coerce-arg event)))
(define (nswindowcontroller-no-responder-for self event-selector)
  (_msg-3 (coerce-arg self) (sel_registerName "noResponderFor:") event-selector))
(define (nswindowcontroller-other-mouse-down self event)
  (tell #:type _void (coerce-arg self) otherMouseDown: (coerce-arg event)))
(define (nswindowcontroller-other-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) otherMouseDragged: (coerce-arg event)))
(define (nswindowcontroller-other-mouse-up self event)
  (tell #:type _void (coerce-arg self) otherMouseUp: (coerce-arg event)))
(define (nswindowcontroller-perform-key-equivalent! self event)
  (_msg-2 (coerce-arg self) (sel_registerName "performKeyEquivalent:") (coerce-arg event)))
(define (nswindowcontroller-pressure-change-with-event self event)
  (tell #:type _void (coerce-arg self) pressureChangeWithEvent: (coerce-arg event)))
(define (nswindowcontroller-quick-look-with-event self event)
  (tell #:type _void (coerce-arg self) quickLookWithEvent: (coerce-arg event)))
(define (nswindowcontroller-resign-first-responder self)
  (_msg-0 (coerce-arg self) (sel_registerName "resignFirstResponder")))
(define (nswindowcontroller-right-mouse-down self event)
  (tell #:type _void (coerce-arg self) rightMouseDown: (coerce-arg event)))
(define (nswindowcontroller-right-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) rightMouseDragged: (coerce-arg event)))
(define (nswindowcontroller-right-mouse-up self event)
  (tell #:type _void (coerce-arg self) rightMouseUp: (coerce-arg event)))
(define (nswindowcontroller-rotate-with-event self event)
  (tell #:type _void (coerce-arg self) rotateWithEvent: (coerce-arg event)))
(define (nswindowcontroller-scroll-wheel self event)
  (tell #:type _void (coerce-arg self) scrollWheel: (coerce-arg event)))
(define (nswindowcontroller-set-document-edited! self dirty-flag)
  (_msg-1 (coerce-arg self) (sel_registerName "setDocumentEdited:") dirty-flag))
(define (nswindowcontroller-should-be-treated-as-ink-event self event)
  (_msg-2 (coerce-arg self) (sel_registerName "shouldBeTreatedAsInkEvent:") (coerce-arg event)))
(define (nswindowcontroller-show-context-help self sender)
  (tell #:type _void (coerce-arg self) showContextHelp: (coerce-arg sender)))
(define (nswindowcontroller-show-window self sender)
  (tell #:type _void (coerce-arg self) showWindow: (coerce-arg sender)))
(define (nswindowcontroller-smart-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) smartMagnifyWithEvent: (coerce-arg event)))
(define (nswindowcontroller-supplemental-target-for-action-sender self action sender)
  (wrap-objc-object
   (_msg-5 (coerce-arg self) (sel_registerName "supplementalTargetForAction:sender:") action (coerce-arg sender))
   ))
(define (nswindowcontroller-swipe-with-event self event)
  (tell #:type _void (coerce-arg self) swipeWithEvent: (coerce-arg event)))
(define (nswindowcontroller-synchronize-window-title-with-document-name self)
  (tell #:type _void (coerce-arg self) synchronizeWindowTitleWithDocumentName))
(define (nswindowcontroller-tablet-point self event)
  (tell #:type _void (coerce-arg self) tabletPoint: (coerce-arg event)))
(define (nswindowcontroller-tablet-proximity self event)
  (tell #:type _void (coerce-arg self) tabletProximity: (coerce-arg event)))
(define (nswindowcontroller-touches-began-with-event self event)
  (tell #:type _void (coerce-arg self) touchesBeganWithEvent: (coerce-arg event)))
(define (nswindowcontroller-touches-cancelled-with-event self event)
  (tell #:type _void (coerce-arg self) touchesCancelledWithEvent: (coerce-arg event)))
(define (nswindowcontroller-touches-ended-with-event self event)
  (tell #:type _void (coerce-arg self) touchesEndedWithEvent: (coerce-arg event)))
(define (nswindowcontroller-touches-moved-with-event self event)
  (tell #:type _void (coerce-arg self) touchesMovedWithEvent: (coerce-arg event)))
(define (nswindowcontroller-try-to-perform-with self action object)
  (_msg-4 (coerce-arg self) (sel_registerName "tryToPerform:with:") action (coerce-arg object)))
(define (nswindowcontroller-valid-requestor-for-send-type-return-type self send-type return-type)
  (wrap-objc-object
   (tell (coerce-arg self) validRequestorForSendType: (coerce-arg send-type) returnType: (coerce-arg return-type))))
(define (nswindowcontroller-wants-forwarded-scroll-events-for-axis self axis)
  (_msg-6 (coerce-arg self) (sel_registerName "wantsForwardedScrollEventsForAxis:") axis))
(define (nswindowcontroller-wants-scroll-events-for-swipe-tracking-on-axis self axis)
  (_msg-6 (coerce-arg self) (sel_registerName "wantsScrollEventsForSwipeTrackingOnAxis:") axis))
(define (nswindowcontroller-window-did-load self)
  (tell #:type _void (coerce-arg self) windowDidLoad))
(define (nswindowcontroller-window-title-for-document-display-name self display-name)
  (wrap-objc-object
   (tell (coerce-arg self) windowTitleForDocumentDisplayName: (coerce-arg display-name))))
(define (nswindowcontroller-window-will-load self)
  (tell #:type _void (coerce-arg self) windowWillLoad))
