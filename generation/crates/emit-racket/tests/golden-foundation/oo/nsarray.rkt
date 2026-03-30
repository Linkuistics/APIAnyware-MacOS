#lang racket/base
;; Generated binding for NSArray (Foundation)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/Foundation.framework/Foundation"))
(define _objc-lib (ffi-lib "libobjc"))

(provide (except-out (all-defined-out) _fw-lib _objc-lib _msg-0 _msg-1 _msg-2))

;; --- Class reference ---
(import-class NSArray)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _uint64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _uint64)))
(define _msg-1  ; (_fun _pointer _pointer _pointer _uint64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _uint64 -> _id)))
(define _msg-2  ; (_fun _pointer _pointer _uint64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _id)))

;; --- Constructors ---
(define (make-nsarray-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSArray alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))

(define (make-nsarray-init-with-objects-count objects cnt)
  (wrap-objc-object
   (_msg-1 (tell NSArray alloc)
       (sel_registerName "initWithObjects:count:")
       objects
       cnt)
   #:retained #t))


;; --- Properties ---
(define (nsarray-count self)
  (tell #:type _uint64 (coerce-arg self) count))
(define (nsarray-custom-mirror self)
  (wrap-objc-object
   (tell (coerce-arg self) customMirror)))
(define (nsarray-description self)
  (wrap-objc-object
   (tell (coerce-arg self) description)))
(define (nsarray-first-object self)
  (wrap-objc-object
   (tell (coerce-arg self) firstObject)))
(define (nsarray-last-object self)
  (wrap-objc-object
   (tell (coerce-arg self) lastObject)))
(define (nsarray-sorted-array-hint self)
  (wrap-objc-object
   (tell (coerce-arg self) sortedArrayHint)))
(define (nsarray-underestimated-count self)
  (tell #:type _int64 (coerce-arg self) underestimatedCount))

;; --- Instance methods ---
(define (nsarray-make-iterator self)
  (wrap-objc-object
   (tell (coerce-arg self) makeIterator)))
(define (nsarray-object-at-index self index)
  (wrap-objc-object
   (_msg-2 (coerce-arg self) (sel_registerName "objectAtIndex:") index)
   ))
