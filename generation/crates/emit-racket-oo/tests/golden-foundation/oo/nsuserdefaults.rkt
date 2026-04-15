#lang racket/base
;; Generated binding for NSUserDefaults (Foundation)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         (rename-in racket/contract [-> c->])
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/Foundation.framework/Foundation"))
(define _objc-lib (ffi-lib "libobjc"))

(provide NSUserDefaults)
(provide/contract
  [make-nsuserdefaults-init-with-suite-name (c-> (or/c string? objc-object? cpointer?) any/c)]
  [nsuserdefaults-standard-user-defaults (c-> any/c)]
  [nsuserdefaults-volatile-domain-names (c-> objc-object? any/c)]
  [nsuserdefaults-url-for-key (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nsuserdefaults-add-suite-named! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsuserdefaults-array-for-key (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nsuserdefaults-bool-for-key (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nsuserdefaults-data-for-key (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nsuserdefaults-dictionary-for-key (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nsuserdefaults-dictionary-representation (c-> objc-object? any/c)]
  [nsuserdefaults-double-for-key (c-> objc-object? (or/c string? objc-object? cpointer?) real?)]
  [nsuserdefaults-float-for-key (c-> objc-object? (or/c string? objc-object? cpointer?) real?)]
  [nsuserdefaults-integer-for-key (c-> objc-object? (or/c string? objc-object? cpointer?) exact-integer?)]
  [nsuserdefaults-object-for-key (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nsuserdefaults-object-is-forced-for-key (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nsuserdefaults-object-is-forced-for-key-in-domain (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) boolean?)]
  [nsuserdefaults-persistent-domain-for-name (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nsuserdefaults-register-defaults (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsuserdefaults-remove-object-for-key! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsuserdefaults-remove-persistent-domain-for-name! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsuserdefaults-remove-suite-named! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsuserdefaults-remove-volatile-domain-for-name! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsuserdefaults-set-bool-for-key! (c-> objc-object? boolean? (or/c string? objc-object? cpointer?) void?)]
  [nsuserdefaults-set-double-for-key! (c-> objc-object? real? (or/c string? objc-object? cpointer?) void?)]
  [nsuserdefaults-set-float-for-key! (c-> objc-object? real? (or/c string? objc-object? cpointer?) void?)]
  [nsuserdefaults-set-integer-for-key! (c-> objc-object? exact-integer? (or/c string? objc-object? cpointer?) void?)]
  [nsuserdefaults-set-object-for-key! (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nsuserdefaults-set-persistent-domain-for-name! (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nsuserdefaults-set-url-for-key! (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nsuserdefaults-set-volatile-domain-for-name! (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nsuserdefaults-string-array-for-key (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nsuserdefaults-string-for-key (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nsuserdefaults-synchronize (c-> objc-object? boolean?)]
  [nsuserdefaults-volatile-domain-for-name (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nsuserdefaults-reset-standard-user-defaults! (c-> void?)]
  )

;; --- Class reference ---
(import-class NSUserDefaults)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-1  ; (_fun _pointer _pointer _bool _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool _id -> _void)))
(define _msg-2  ; (_fun _pointer _pointer _double _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double _id -> _void)))
(define _msg-3  ; (_fun _pointer _pointer _float _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _float _id -> _void)))
(define _msg-4  ; (_fun _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _bool)))
(define _msg-5  ; (_fun _pointer _pointer _id -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _double)))
(define _msg-6  ; (_fun _pointer _pointer _id -> _float)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _float)))
(define _msg-7  ; (_fun _pointer _pointer _id -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _int64)))
(define _msg-8  ; (_fun _pointer _pointer _id _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _id -> _bool)))
(define _msg-9  ; (_fun _pointer _pointer _int64 _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 _id -> _void)))

;; --- Constructors ---
(define (make-nsuserdefaults-init-with-suite-name suitename)
  (wrap-objc-object
   (tell (tell NSUserDefaults alloc)
         initWithSuiteName: (coerce-arg suitename))
   #:retained #t))


;; --- Properties ---
(define (nsuserdefaults-standard-user-defaults)
  (wrap-objc-object
   (tell NSUserDefaults standardUserDefaults)))
(define (nsuserdefaults-volatile-domain-names self)
  (wrap-objc-object
   (tell (coerce-arg self) volatileDomainNames)))

;; --- Instance methods ---
(define (nsuserdefaults-url-for-key self default-name)
  (wrap-objc-object
   (tell (coerce-arg self) URLForKey: (coerce-arg default-name))))
(define (nsuserdefaults-add-suite-named! self suite-name)
  (tell #:type _void (coerce-arg self) addSuiteNamed: (coerce-arg suite-name)))
(define (nsuserdefaults-array-for-key self default-name)
  (wrap-objc-object
   (tell (coerce-arg self) arrayForKey: (coerce-arg default-name))))
(define (nsuserdefaults-bool-for-key self default-name)
  (_msg-4 (coerce-arg self) (sel_registerName "boolForKey:") (coerce-arg default-name)))
(define (nsuserdefaults-data-for-key self default-name)
  (wrap-objc-object
   (tell (coerce-arg self) dataForKey: (coerce-arg default-name))))
(define (nsuserdefaults-dictionary-for-key self default-name)
  (wrap-objc-object
   (tell (coerce-arg self) dictionaryForKey: (coerce-arg default-name))))
(define (nsuserdefaults-dictionary-representation self)
  (wrap-objc-object
   (tell (coerce-arg self) dictionaryRepresentation)))
(define (nsuserdefaults-double-for-key self default-name)
  (_msg-5 (coerce-arg self) (sel_registerName "doubleForKey:") (coerce-arg default-name)))
(define (nsuserdefaults-float-for-key self default-name)
  (_msg-6 (coerce-arg self) (sel_registerName "floatForKey:") (coerce-arg default-name)))
(define (nsuserdefaults-integer-for-key self default-name)
  (_msg-7 (coerce-arg self) (sel_registerName "integerForKey:") (coerce-arg default-name)))
(define (nsuserdefaults-object-for-key self default-name)
  (wrap-objc-object
   (tell (coerce-arg self) objectForKey: (coerce-arg default-name))))
(define (nsuserdefaults-object-is-forced-for-key self key)
  (_msg-4 (coerce-arg self) (sel_registerName "objectIsForcedForKey:") (coerce-arg key)))
(define (nsuserdefaults-object-is-forced-for-key-in-domain self key domain)
  (_msg-8 (coerce-arg self) (sel_registerName "objectIsForcedForKey:inDomain:") (coerce-arg key) (coerce-arg domain)))
(define (nsuserdefaults-persistent-domain-for-name self domain-name)
  (wrap-objc-object
   (tell (coerce-arg self) persistentDomainForName: (coerce-arg domain-name))))
(define (nsuserdefaults-register-defaults self registration-dictionary)
  (tell #:type _void (coerce-arg self) registerDefaults: (coerce-arg registration-dictionary)))
(define (nsuserdefaults-remove-object-for-key! self default-name)
  (tell #:type _void (coerce-arg self) removeObjectForKey: (coerce-arg default-name)))
(define (nsuserdefaults-remove-persistent-domain-for-name! self domain-name)
  (tell #:type _void (coerce-arg self) removePersistentDomainForName: (coerce-arg domain-name)))
(define (nsuserdefaults-remove-suite-named! self suite-name)
  (tell #:type _void (coerce-arg self) removeSuiteNamed: (coerce-arg suite-name)))
(define (nsuserdefaults-remove-volatile-domain-for-name! self domain-name)
  (tell #:type _void (coerce-arg self) removeVolatileDomainForName: (coerce-arg domain-name)))
(define (nsuserdefaults-set-bool-for-key! self value default-name)
  (_msg-1 (coerce-arg self) (sel_registerName "setBool:forKey:") value (coerce-arg default-name)))
(define (nsuserdefaults-set-double-for-key! self value default-name)
  (_msg-2 (coerce-arg self) (sel_registerName "setDouble:forKey:") value (coerce-arg default-name)))
(define (nsuserdefaults-set-float-for-key! self value default-name)
  (_msg-3 (coerce-arg self) (sel_registerName "setFloat:forKey:") value (coerce-arg default-name)))
(define (nsuserdefaults-set-integer-for-key! self value default-name)
  (_msg-9 (coerce-arg self) (sel_registerName "setInteger:forKey:") value (coerce-arg default-name)))
(define (nsuserdefaults-set-object-for-key! self value default-name)
  (tell #:type _void (coerce-arg self) setObject: (coerce-arg value) forKey: (coerce-arg default-name)))
(define (nsuserdefaults-set-persistent-domain-for-name! self domain domain-name)
  (tell #:type _void (coerce-arg self) setPersistentDomain: (coerce-arg domain) forName: (coerce-arg domain-name)))
(define (nsuserdefaults-set-url-for-key! self url default-name)
  (tell #:type _void (coerce-arg self) setURL: (coerce-arg url) forKey: (coerce-arg default-name)))
(define (nsuserdefaults-set-volatile-domain-for-name! self domain domain-name)
  (tell #:type _void (coerce-arg self) setVolatileDomain: (coerce-arg domain) forName: (coerce-arg domain-name)))
(define (nsuserdefaults-string-array-for-key self default-name)
  (wrap-objc-object
   (tell (coerce-arg self) stringArrayForKey: (coerce-arg default-name))))
(define (nsuserdefaults-string-for-key self default-name)
  (wrap-objc-object
   (tell (coerce-arg self) stringForKey: (coerce-arg default-name))))
(define (nsuserdefaults-synchronize self)
  (_msg-0 (coerce-arg self) (sel_registerName "synchronize")))
(define (nsuserdefaults-volatile-domain-for-name self domain-name)
  (wrap-objc-object
   (tell (coerce-arg self) volatileDomainForName: (coerce-arg domain-name))))

;; --- Class methods ---
(define (nsuserdefaults-reset-standard-user-defaults!)
  (tell #:type _void NSUserDefaults resetStandardUserDefaults))
