#lang racket/base
;; Generated protocol definition for NSLocking (Foundation)
;; Do not edit — regenerate from enriched IR
;;
;; NSLocking defines 2 methods:
;;   void-returning (2):
;;     lock  ()
;;     unlock  ()

(require "../../../../runtime/delegate.rkt")

(provide make-nslocking
         nslocking-selectors)

;; All selectors in this protocol
(define nslocking-selectors
  '("lock"
    "unlock"))

;; Create a NSLocking delegate.
;; Pass selector string → handler procedure pairs.
;; Example:
;;   (make-nslocking
;;     "lock" (lambda () ...)
;;   )
(define (make-nslocking . selector+handler-pairs)
  (apply make-delegate selector+handler-pairs))
