#lang racket/base
;; Generated binding for NSResponder (AppKit)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         (rename-in racket/contract [-> c->])
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/AppKit.framework/AppKit"))
(define _objc-lib (ffi-lib "libobjc"))

(provide NSResponder)
(provide/contract
  [make-nsresponder-init-with-coder (c-> (or/c string? objc-object? cpointer?) any/c)]
  [nsresponder-accepts-first-responder (c-> objc-object? boolean?)]
  [nsresponder-menu (c-> objc-object? any/c)]
  [nsresponder-set-menu! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-next-responder (c-> objc-object? any/c)]
  [nsresponder-set-next-responder! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-restorable-state-key-paths (c-> any/c)]
  [nsresponder-touch-bar (c-> objc-object? any/c)]
  [nsresponder-set-touch-bar! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-undo-manager (c-> objc-object? any/c)]
  [nsresponder-user-activity (c-> objc-object? any/c)]
  [nsresponder-set-user-activity! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-become-first-responder (c-> objc-object? boolean?)]
  [nsresponder-begin-gesture-with-event! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-change-mode-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-context-menu-key-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-cursor-update (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-end-gesture-with-event! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-flags-changed (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-flush-buffered-key-events (c-> objc-object? void?)]
  [nsresponder-help-requested (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-interpret-key-events (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-key-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-key-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-magnify-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-mouse-cancelled (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-mouse-entered (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-mouse-exited (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-mouse-moved (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-no-responder-for (c-> objc-object? cpointer? void?)]
  [nsresponder-other-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-other-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-other-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-perform-key-equivalent! (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nsresponder-pressure-change-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-quick-look-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-resign-first-responder (c-> objc-object? boolean?)]
  [nsresponder-right-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-right-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-right-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-rotate-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-scroll-wheel (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-should-be-treated-as-ink-event (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nsresponder-show-context-help (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-smart-magnify-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-supplemental-target-for-action-sender (c-> objc-object? cpointer? (or/c string? objc-object? cpointer?) any/c)]
  [nsresponder-swipe-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-tablet-point (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-tablet-proximity (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-touches-began-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-touches-cancelled-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-touches-ended-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-touches-moved-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsresponder-try-to-perform-with (c-> objc-object? cpointer? (or/c string? objc-object? cpointer?) boolean?)]
  [nsresponder-valid-requestor-for-send-type-return-type (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) any/c)]
  [nsresponder-wants-forwarded-scroll-events-for-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nsresponder-wants-scroll-events-for-swipe-tracking-on-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  )

;; --- Class reference ---
(import-class NSResponder)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-1  ; (_fun _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _bool)))
(define _msg-2  ; (_fun _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))
(define _msg-3  ; (_fun _pointer _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _bool)))
(define _msg-4  ; (_fun _pointer _pointer _pointer _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _id)))
(define _msg-5  ; (_fun _pointer _pointer _uint64 -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _bool)))

;; --- Constructors ---
(define (make-nsresponder-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSResponder alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))


;; --- Properties ---
(define (nsresponder-accepts-first-responder self)
  (tell #:type _bool (coerce-arg self) acceptsFirstResponder))
(define (nsresponder-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) menu)))
(define (nsresponder-set-menu! self value)
  (tell #:type _void (coerce-arg self) setMenu: (coerce-arg value)))
(define (nsresponder-next-responder self)
  (wrap-objc-object
   (tell (coerce-arg self) nextResponder)))
(define (nsresponder-set-next-responder! self value)
  (tell #:type _void (coerce-arg self) setNextResponder: (coerce-arg value)))
(define (nsresponder-restorable-state-key-paths)
  (wrap-objc-object
   (tell NSResponder restorableStateKeyPaths)))
(define (nsresponder-touch-bar self)
  (wrap-objc-object
   (tell (coerce-arg self) touchBar)))
(define (nsresponder-set-touch-bar! self value)
  (tell #:type _void (coerce-arg self) setTouchBar: (coerce-arg value)))
(define (nsresponder-undo-manager self)
  (wrap-objc-object
   (tell (coerce-arg self) undoManager)))
(define (nsresponder-user-activity self)
  (wrap-objc-object
   (tell (coerce-arg self) userActivity)))
(define (nsresponder-set-user-activity! self value)
  (tell #:type _void (coerce-arg self) setUserActivity: (coerce-arg value)))

;; --- Instance methods ---
(define (nsresponder-become-first-responder self)
  (_msg-0 (coerce-arg self) (sel_registerName "becomeFirstResponder")))
(define (nsresponder-begin-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) beginGestureWithEvent: (coerce-arg event)))
(define (nsresponder-change-mode-with-event self event)
  (tell #:type _void (coerce-arg self) changeModeWithEvent: (coerce-arg event)))
(define (nsresponder-context-menu-key-down self event)
  (tell #:type _void (coerce-arg self) contextMenuKeyDown: (coerce-arg event)))
(define (nsresponder-cursor-update self event)
  (tell #:type _void (coerce-arg self) cursorUpdate: (coerce-arg event)))
(define (nsresponder-end-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) endGestureWithEvent: (coerce-arg event)))
(define (nsresponder-flags-changed self event)
  (tell #:type _void (coerce-arg self) flagsChanged: (coerce-arg event)))
(define (nsresponder-flush-buffered-key-events self)
  (tell #:type _void (coerce-arg self) flushBufferedKeyEvents))
(define (nsresponder-help-requested self event-ptr)
  (tell #:type _void (coerce-arg self) helpRequested: (coerce-arg event-ptr)))
(define (nsresponder-interpret-key-events self event-array)
  (tell #:type _void (coerce-arg self) interpretKeyEvents: (coerce-arg event-array)))
(define (nsresponder-key-down self event)
  (tell #:type _void (coerce-arg self) keyDown: (coerce-arg event)))
(define (nsresponder-key-up self event)
  (tell #:type _void (coerce-arg self) keyUp: (coerce-arg event)))
(define (nsresponder-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) magnifyWithEvent: (coerce-arg event)))
(define (nsresponder-mouse-cancelled self event)
  (tell #:type _void (coerce-arg self) mouseCancelled: (coerce-arg event)))
(define (nsresponder-mouse-down self event)
  (tell #:type _void (coerce-arg self) mouseDown: (coerce-arg event)))
(define (nsresponder-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) mouseDragged: (coerce-arg event)))
(define (nsresponder-mouse-entered self event)
  (tell #:type _void (coerce-arg self) mouseEntered: (coerce-arg event)))
(define (nsresponder-mouse-exited self event)
  (tell #:type _void (coerce-arg self) mouseExited: (coerce-arg event)))
(define (nsresponder-mouse-moved self event)
  (tell #:type _void (coerce-arg self) mouseMoved: (coerce-arg event)))
(define (nsresponder-mouse-up self event)
  (tell #:type _void (coerce-arg self) mouseUp: (coerce-arg event)))
(define (nsresponder-no-responder-for self event-selector)
  (_msg-2 (coerce-arg self) (sel_registerName "noResponderFor:") event-selector))
(define (nsresponder-other-mouse-down self event)
  (tell #:type _void (coerce-arg self) otherMouseDown: (coerce-arg event)))
(define (nsresponder-other-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) otherMouseDragged: (coerce-arg event)))
(define (nsresponder-other-mouse-up self event)
  (tell #:type _void (coerce-arg self) otherMouseUp: (coerce-arg event)))
(define (nsresponder-perform-key-equivalent! self event)
  (_msg-1 (coerce-arg self) (sel_registerName "performKeyEquivalent:") (coerce-arg event)))
(define (nsresponder-pressure-change-with-event self event)
  (tell #:type _void (coerce-arg self) pressureChangeWithEvent: (coerce-arg event)))
(define (nsresponder-quick-look-with-event self event)
  (tell #:type _void (coerce-arg self) quickLookWithEvent: (coerce-arg event)))
(define (nsresponder-resign-first-responder self)
  (_msg-0 (coerce-arg self) (sel_registerName "resignFirstResponder")))
(define (nsresponder-right-mouse-down self event)
  (tell #:type _void (coerce-arg self) rightMouseDown: (coerce-arg event)))
(define (nsresponder-right-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) rightMouseDragged: (coerce-arg event)))
(define (nsresponder-right-mouse-up self event)
  (tell #:type _void (coerce-arg self) rightMouseUp: (coerce-arg event)))
(define (nsresponder-rotate-with-event self event)
  (tell #:type _void (coerce-arg self) rotateWithEvent: (coerce-arg event)))
(define (nsresponder-scroll-wheel self event)
  (tell #:type _void (coerce-arg self) scrollWheel: (coerce-arg event)))
(define (nsresponder-should-be-treated-as-ink-event self event)
  (_msg-1 (coerce-arg self) (sel_registerName "shouldBeTreatedAsInkEvent:") (coerce-arg event)))
(define (nsresponder-show-context-help self sender)
  (tell #:type _void (coerce-arg self) showContextHelp: (coerce-arg sender)))
(define (nsresponder-smart-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) smartMagnifyWithEvent: (coerce-arg event)))
(define (nsresponder-supplemental-target-for-action-sender self action sender)
  (wrap-objc-object
   (_msg-4 (coerce-arg self) (sel_registerName "supplementalTargetForAction:sender:") action (coerce-arg sender))
   ))
(define (nsresponder-swipe-with-event self event)
  (tell #:type _void (coerce-arg self) swipeWithEvent: (coerce-arg event)))
(define (nsresponder-tablet-point self event)
  (tell #:type _void (coerce-arg self) tabletPoint: (coerce-arg event)))
(define (nsresponder-tablet-proximity self event)
  (tell #:type _void (coerce-arg self) tabletProximity: (coerce-arg event)))
(define (nsresponder-touches-began-with-event self event)
  (tell #:type _void (coerce-arg self) touchesBeganWithEvent: (coerce-arg event)))
(define (nsresponder-touches-cancelled-with-event self event)
  (tell #:type _void (coerce-arg self) touchesCancelledWithEvent: (coerce-arg event)))
(define (nsresponder-touches-ended-with-event self event)
  (tell #:type _void (coerce-arg self) touchesEndedWithEvent: (coerce-arg event)))
(define (nsresponder-touches-moved-with-event self event)
  (tell #:type _void (coerce-arg self) touchesMovedWithEvent: (coerce-arg event)))
(define (nsresponder-try-to-perform-with self action object)
  (_msg-3 (coerce-arg self) (sel_registerName "tryToPerform:with:") action (coerce-arg object)))
(define (nsresponder-valid-requestor-for-send-type-return-type self send-type return-type)
  (wrap-objc-object
   (tell (coerce-arg self) validRequestorForSendType: (coerce-arg send-type) returnType: (coerce-arg return-type))))
(define (nsresponder-wants-forwarded-scroll-events-for-axis self axis)
  (_msg-5 (coerce-arg self) (sel_registerName "wantsForwardedScrollEventsForAxis:") axis))
(define (nsresponder-wants-scroll-events-for-swipe-tracking-on-axis self axis)
  (_msg-5 (coerce-arg self) (sel_registerName "wantsScrollEventsForSwipeTrackingOnAxis:") axis))
