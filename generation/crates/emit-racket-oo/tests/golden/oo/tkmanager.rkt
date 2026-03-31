#lang racket/base
;; Generated binding for TKManager (TestKit)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/TestKit.framework/TestKit"))
(define _objc-lib (ffi-lib "libobjc"))

(provide (except-out (all-defined-out) _fw-lib _objc-lib))

;; --- Class reference ---
(import-class TKManager)

;; --- Constructors ---

;; --- Instance methods ---
(define (tkmanager-dealloc self)
  (tell (coerce-arg self) dealloc))
(define (tkmanager-description self)
  (wrap-objc-object
   (tell (coerce-arg self) description)))
