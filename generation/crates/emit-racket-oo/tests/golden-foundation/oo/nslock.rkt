#lang racket/base
;; Generated binding for NSLock (Foundation)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/Foundation.framework/Foundation"))
(define _objc-lib (ffi-lib "libobjc"))

(provide (except-out (all-defined-out) _fw-lib _objc-lib _msg-0 _msg-1))

;; --- Class reference ---
(import-class NSLock)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-1  ; (_fun _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _bool)))

;; --- Properties ---
(define (nslock-name self)
  (wrap-objc-object
   (tell (coerce-arg self) name)))
(define (nslock-set-name! self value)
  (tell (coerce-arg self) setName: (coerce-arg value)))

;; --- Instance methods ---
(define (nslock-lock-before-date self limit)
  (_msg-1 (coerce-arg self) (sel_registerName "lockBeforeDate:") (coerce-arg limit)))
(define (nslock-try-lock self)
  (_msg-0 (coerce-arg self) (sel_registerName "tryLock")))
