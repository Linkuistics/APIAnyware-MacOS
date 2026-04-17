#lang racket/base
;; Generated binding for TKHelper (TestKit)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         (rename-in racket/contract [-> c->])
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/TestKit.framework/TestKit"))
(define _objc-lib (ffi-lib "libobjc"))


;; --- Class predicates ---
(define (nsstring? v) (objc-instance-of? v "NSString"))
(provide TKHelper)
(provide/contract
  [tkhelper-dealloc (c-> objc-object? void?)]
  [tkhelper-description (c-> objc-object? (or/c nsstring? objc-nil?))]
  )

;; --- Class reference ---
(import-class TKHelper)

;; --- Constructors ---

;; --- Instance methods ---
(define (tkhelper-dealloc self)
  (tell #:type _void (coerce-arg self) dealloc))
(define (tkhelper-description self)
  (wrap-objc-object
   (tell (coerce-arg self) description)))
