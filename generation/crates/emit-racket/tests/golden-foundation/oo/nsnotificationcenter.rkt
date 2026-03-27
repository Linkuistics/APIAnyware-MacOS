#lang racket/base
;; Generated binding for NSNotificationCenter (Foundation)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt"
         "../../../runtime/block.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/Foundation.framework/Foundation"))
(define _objc-lib (ffi-lib "libobjc"))

(provide (except-out (all-defined-out) _fw-lib _objc-lib _msg-0 _msg-1 _msg-2 _msg-3 _msg-4))

;; --- Class reference ---
(import-class NSNotificationCenter)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer _id _pointer _uint64 _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _pointer _uint64 _id -> _void)))
(define _msg-1  ; (_fun _pointer _pointer _id _uint64 _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _uint64 _id -> _void)))
(define _msg-2  ; (_fun _pointer _pointer _uint64 _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 _id -> _void)))
(define _msg-3  ; (_fun _pointer _pointer _uint64 _id _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 _id _id -> _void)))
(define _msg-4  ; (_fun _pointer _pointer _uint64 _id _id _pointer -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 _id _id _pointer -> _id)))

;; --- Properties ---
(define (nsnotificationcenter-default-center)
  (wrap-objc-object
   (tell NSNotificationCenter defaultCenter)))

;; --- Instance methods ---
(define (nsnotificationcenter-add-observer-selector-name-object! self observer a-selector a-name an-object)
  (_msg-0 (coerce-arg self) (sel_registerName "addObserver:selector:name:object:") (coerce-arg observer) a-selector a-name (coerce-arg an-object)))
(define (nsnotificationcenter-add-observer-for-name-object-queue-using-block! self name obj queue block)
  (define-values (_blk3 _blk3-id)
    (make-objc-block block (list _id) _void))
  (wrap-objc-object
   (_msg-4 (coerce-arg self) (sel_registerName "addObserverForName:object:queue:usingBlock:") name (coerce-arg obj) (coerce-arg queue) _blk3)
   ))
(define (nsnotificationcenter-post-notification self notification)
  (tell (coerce-arg self) postNotification: (coerce-arg notification)))
(define (nsnotificationcenter-post-notification-name-object self a-name an-object)
  (_msg-2 (coerce-arg self) (sel_registerName "postNotificationName:object:") a-name (coerce-arg an-object)))
(define (nsnotificationcenter-post-notification-name-object-user-info self a-name an-object a-user-info)
  (_msg-3 (coerce-arg self) (sel_registerName "postNotificationName:object:userInfo:") a-name (coerce-arg an-object) (coerce-arg a-user-info)))
(define (nsnotificationcenter-remove-observer! self observer)
  (tell (coerce-arg self) removeObserver: (coerce-arg observer)))
(define (nsnotificationcenter-remove-observer-name-object! self observer a-name an-object)
  (_msg-1 (coerce-arg self) (sel_registerName "removeObserver:name:object:") (coerce-arg observer) a-name (coerce-arg an-object)))
