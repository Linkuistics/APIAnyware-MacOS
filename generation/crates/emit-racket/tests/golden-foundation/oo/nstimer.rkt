#lang racket/base
;; Generated binding for NSTimer (Foundation)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt"
         "../../../runtime/block.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/Foundation.framework/Foundation"))
(define _objc-lib (ffi-lib "libobjc"))

(provide (except-out (all-defined-out) _fw-lib _objc-lib _msg-0 _msg-1 _msg-2 _msg-3 _msg-4 _msg-5 _msg-6 _msg-7))

;; --- Class reference ---
(import-class NSTimer)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-1  ; (_fun _pointer _pointer -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _double)))
(define _msg-2  ; (_fun _pointer _pointer _double -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double -> _void)))
(define _msg-3  ; (_fun _pointer _pointer _double _bool _pointer -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double _bool _pointer -> _id)))
(define _msg-4  ; (_fun _pointer _pointer _double _id _bool -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double _id _bool -> _id)))
(define _msg-5  ; (_fun _pointer _pointer _double _id _pointer _id _bool -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double _id _pointer _id _bool -> _id)))
(define _msg-6  ; (_fun _pointer _pointer _id _double _bool _pointer -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _double _bool _pointer -> _id)))
(define _msg-7  ; (_fun _pointer _pointer _id _double _id _pointer _id _bool -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _double _id _pointer _id _bool -> _id)))

;; --- Constructors ---
(define (make-nstimer-init-with-fire-date-interval-repeats-block date interval repeats block)
  (define-values (_blk3 _blk3-id)
    (make-objc-block block (list _id) _void))
  (wrap-objc-object
   (_msg-6 (tell NSTimer alloc)
       (sel_registerName "initWithFireDate:interval:repeats:block:")
       (coerce-arg date)
       interval
       repeats
       _blk3)
   #:retained #t))

(define (make-nstimer-init-with-fire-date-interval-target-selector-user-info-repeats date ti t s ui rep)
  (wrap-objc-object
   (_msg-7 (tell NSTimer alloc)
       (sel_registerName "initWithFireDate:interval:target:selector:userInfo:repeats:")
       (coerce-arg date)
       ti
       (coerce-arg t)
       s
       (coerce-arg ui)
       rep)
   #:retained #t))


;; --- Properties ---
(define (nstimer-fire-date self)
  (wrap-objc-object
   (tell (coerce-arg self) fireDate)))
(define (nstimer-set-fire-date! self value)
  (tell (coerce-arg self) setFireDate: (coerce-arg value)))
(define (nstimer-time-interval self)
  (tell #:type _double (coerce-arg self) timeInterval))
(define (nstimer-tolerance self)
  (tell #:type _double (coerce-arg self) tolerance))
(define (nstimer-set-tolerance! self value)
  (_msg-2 (coerce-arg self) (sel_registerName "setTolerance:") value))
(define (nstimer-user-info self)
  (wrap-objc-object
   (tell (coerce-arg self) userInfo)))
(define (nstimer-valid self)
  (tell #:type _bool (coerce-arg self) valid))

;; --- Instance methods ---
(define (nstimer-fire self)
  (tell (coerce-arg self) fire))
(define (nstimer-invalidate self)
  (tell (coerce-arg self) invalidate))
(define (nstimer-is-valid self)
  (_msg-0 (coerce-arg self) (sel_registerName "isValid")))

;; --- Class methods ---
(define (nstimer-scheduled-timer-with-time-interval-invocation-repeats ti invocation yes-or-no)
  (wrap-objc-object
   (_msg-4 NSTimer (sel_registerName "scheduledTimerWithTimeInterval:invocation:repeats:") ti (coerce-arg invocation) yes-or-no)
   ))
(define (nstimer-scheduled-timer-with-time-interval-repeats-block interval repeats block)
  (define-values (_blk2 _blk2-id)
    (make-objc-block block (list _id) _void))
  (wrap-objc-object
   (_msg-3 NSTimer (sel_registerName "scheduledTimerWithTimeInterval:repeats:block:") interval repeats _blk2)
   ))
(define (nstimer-scheduled-timer-with-time-interval-target-selector-user-info-repeats ti a-target a-selector user-info yes-or-no)
  (wrap-objc-object
   (_msg-5 NSTimer (sel_registerName "scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:") ti (coerce-arg a-target) a-selector (coerce-arg user-info) yes-or-no)
   ))
(define (nstimer-timer-with-time-interval-invocation-repeats ti invocation yes-or-no)
  (wrap-objc-object
   (_msg-4 NSTimer (sel_registerName "timerWithTimeInterval:invocation:repeats:") ti (coerce-arg invocation) yes-or-no)
   ))
(define (nstimer-timer-with-time-interval-repeats-block interval repeats block)
  (define-values (_blk2 _blk2-id)
    (make-objc-block block (list _id) _void))
  (wrap-objc-object
   (_msg-3 NSTimer (sel_registerName "timerWithTimeInterval:repeats:block:") interval repeats _blk2)
   ))
(define (nstimer-timer-with-time-interval-target-selector-user-info-repeats ti a-target a-selector user-info yes-or-no)
  (wrap-objc-object
   (_msg-5 NSTimer (sel_registerName "timerWithTimeInterval:target:selector:userInfo:repeats:") ti (coerce-arg a-target) a-selector (coerce-arg user-info) yes-or-no)
   ))
