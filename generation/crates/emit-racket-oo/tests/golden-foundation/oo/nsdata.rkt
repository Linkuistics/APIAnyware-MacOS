#lang racket/base
;; Generated binding for NSData (Foundation)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         (rename-in racket/contract [-> c->])
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/Foundation.framework/Foundation"))
(define _objc-lib (ffi-lib "libobjc"))

(provide NSData)
(provide/contract
  [nsdata-bytes (c-> objc-object? (or/c cpointer? #f))]
  [nsdata-description (c-> objc-object? any/c)]
  [nsdata-end-index (c-> objc-object? exact-integer?)]
  [nsdata-length (c-> objc-object? exact-nonnegative-integer?)]
  [nsdata-regions (c-> objc-object? any/c)]
  [nsdata-start-index (c-> objc-object? exact-integer?)]
  )

;; --- Class reference ---
(import-class NSData)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _pointer)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _pointer)))
(define _msg-1  ; (_fun _pointer _pointer -> _uint64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _uint64)))

;; --- Properties ---
(define (nsdata-bytes self)
  (tell #:type _pointer (coerce-arg self) bytes))
(define (nsdata-description self)
  (wrap-objc-object
   (tell (coerce-arg self) description)))
(define (nsdata-end-index self)
  (tell #:type _int64 (coerce-arg self) endIndex))
(define (nsdata-length self)
  (tell #:type _uint64 (coerce-arg self) length))
(define (nsdata-regions self)
  (wrap-objc-object
   (tell (coerce-arg self) regions)))
(define (nsdata-start-index self)
  (tell #:type _int64 (coerce-arg self) startIndex))

;; --- Instance methods ---
