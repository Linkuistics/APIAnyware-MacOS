#lang racket/base
;; Generated protocol definition for NSCoding (Foundation)
;; Do not edit — regenerate from enriched IR
;;
;; NSCoding defines 2 methods:
;;   void-returning (1):
;;     encodeWithCoder:  (coder:NSCoder)
;;   id-returning (1):
;;     initWithCoder:  (coder:NSCoder)

(require "../../../../runtime/delegate.rkt")

(provide make-nscoding
         nscoding-selectors)

;; All selectors in this protocol
(define nscoding-selectors
  '("encodeWithCoder:"
    "initWithCoder:"))

;; Create a NSCoding delegate.
;; Pass selector string → handler procedure pairs.
;; Example:
;;   (make-nscoding
;;     "encodeWithCoder:" (lambda (coder) ...)
;;   )
(define (make-nscoding . selector+handler-pairs)
  (apply make-delegate
    #:return-types
    (hash "initWithCoder:" 'id)
    selector+handler-pairs))
