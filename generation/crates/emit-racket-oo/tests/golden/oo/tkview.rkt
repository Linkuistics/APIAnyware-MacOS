#lang racket/base
;; Generated binding for TKView (TestKit)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         (rename-in racket/contract [-> c->])
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/TestKit.framework/TestKit"))
(define _objc-lib (ffi-lib "libobjc"))

(provide TKView)
(provide/contract
  [tkview-title (c-> objc-object? any/c)]
  [tkview-set-title! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [tkview-hidden (c-> objc-object? boolean?)]
  [tkview-set-hidden! (c-> objc-object? boolean? void?)]
  [tkview-tag (c-> objc-object? any/c)]
  [tkview-set-tag! (c-> objc-object? any/c void?)]
  [tkview-frame (c-> objc-object? any/c)]
  [tkview-dealloc (c-> objc-object? void?)]
  [tkview-description (c-> objc-object? any/c)]
  )

;; --- Class reference ---
(import-class TKView)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool -> _void)))
(define _msg-1  ; (_fun _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))

;; --- Properties ---
(define (tkview-title self)
  (wrap-objc-object
   (tell (coerce-arg self) title)))
(define (tkview-set-title! self value)
  (tell #:type _void (coerce-arg self) setTitle: (coerce-arg value)))
(define (tkview-hidden self)
  (tell #:type _bool (coerce-arg self) hidden))
(define (tkview-set-hidden! self value)
  (_msg-0 (coerce-arg self) (sel_registerName "setHidden:") value))
(define (tkview-tag self)
  (tell #:type _pointer (coerce-arg self) tag))
(define (tkview-set-tag! self value)
  (_msg-1 (coerce-arg self) (sel_registerName "setTag:") value))
(define (tkview-frame self)
  (wrap-objc-object
   (tell (coerce-arg self) frame)))

;; --- Instance methods ---
(define (tkview-dealloc self)
  (tell #:type _void (coerce-arg self) dealloc))
(define (tkview-description self)
  (wrap-objc-object
   (tell (coerce-arg self) description)))
