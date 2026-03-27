#lang racket/base
;; Generated protocol definition for NSCopying (Foundation)
;; Do not edit — regenerate from enriched IR
;;
;; NSCopying defines 1 methods:
;;   id-returning (1):
;;     copyWithZone:  (zone:pointer)

(require "../../../../runtime/delegate.rkt")

(provide make-nscopying
         nscopying-selectors)

;; All selectors in this protocol
(define nscopying-selectors
  '("copyWithZone:"))

;; Create a NSCopying delegate.
;; Pass selector string → handler procedure pairs.
;; Example:
;;   (make-nscopying
;;   )
(define (make-nscopying . selector+handler-pairs)
  (apply make-delegate
    #:return-types
    (hash "copyWithZone:" 'id)
    selector+handler-pairs))
