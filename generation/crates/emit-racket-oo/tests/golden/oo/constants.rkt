#lang racket/base
;; Generated constant definitions for TestKit

(require ffi/unsafe
         ffi/unsafe/objc
         (rename-in racket/contract [-> c->]))

(provide/contract
  [TKVersionString cpointer?]
  [TKDefaultTimeout real?]
  )

(define _fw-lib (ffi-lib "/System/Library/Frameworks/TestKit.framework/TestKit"))

(define TKVersionString (get-ffi-obj 'TKVersionString _fw-lib _id))
(define TKDefaultTimeout (get-ffi-obj 'TKDefaultTimeout _fw-lib _double))
