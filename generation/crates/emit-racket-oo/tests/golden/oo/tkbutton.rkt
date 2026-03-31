#lang racket/base
;; Generated binding for TKButton (TestKit)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt"
         "../../../runtime/block.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/TestKit.framework/TestKit"))
(define _objc-lib (ffi-lib "libobjc"))

(provide (except-out (all-defined-out) _fw-lib _objc-lib _msg-0 _msg-1))

;; --- Class reference ---
(import-class TKButton)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer _double _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double _pointer -> _void)))
(define _msg-1  ; (_fun _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))

;; --- Properties ---
(define (tkbutton-title self)
  (wrap-objc-object
   (tell (coerce-arg self) title)))
(define (tkbutton-set-title! self value)
  (tell (coerce-arg self) setTitle: (coerce-arg value)))
(define (tkbutton-hidden self)
  (tell #:type _pointer (coerce-arg self) hidden))
(define (tkbutton-set-hidden! self value)
  (_msg-1 (coerce-arg self) (sel_registerName "setHidden:") value))
(define (tkbutton-tag self)
  (tell #:type _pointer (coerce-arg self) tag))
(define (tkbutton-set-tag! self value)
  (_msg-1 (coerce-arg self) (sel_registerName "setTag:") value))
(define (tkbutton-frame self)
  (wrap-objc-object
   (tell (coerce-arg self) frame)))

;; --- Instance methods ---
(define (tkbutton-dealloc self)
  (tell (coerce-arg self) dealloc))
(define (tkbutton-description self)
  (wrap-objc-object
   (tell (coerce-arg self) description)))
(define (tkbutton-set-needs-display! self)
  (tell (coerce-arg self) setNeedsDisplay))
(define (tkbutton-animate-with-duration-animations self duration animations)
  (define-values (_blk1 _blk1-id)
    (make-objc-block animations (list ) _void))
  (_msg-0 (coerce-arg self) (sel_registerName "animateWithDuration:animations:") duration _blk1))
