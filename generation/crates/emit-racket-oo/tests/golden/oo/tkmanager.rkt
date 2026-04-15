#lang racket/base
;; Generated binding for TKManager (TestKit)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         (rename-in racket/contract [-> c->])
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/TestKit.framework/TestKit"))
(define _objc-lib (ffi-lib "libobjc"))

(provide TKManager)
(provide/contract
  [tkmanager-dealloc (c-> objc-object? void?)]
  [tkmanager-description (c-> objc-object? any/c)]
  )

;; --- Class reference ---
(import-class TKManager)

;; --- Constructors ---

;; --- Instance methods ---
(define (tkmanager-dealloc self)
  (tell #:type _void (coerce-arg self) dealloc))
(define (tkmanager-description self)
  (wrap-objc-object
   (tell (coerce-arg self) description)))
