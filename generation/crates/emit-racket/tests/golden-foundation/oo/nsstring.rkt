#lang racket/base
;; Generated binding for NSString (Foundation)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/Foundation.framework/Foundation"))
(define _objc-lib (ffi-lib "libobjc"))

(provide (except-out (all-defined-out) _fw-lib _objc-lib _msg-0 _msg-1))

;; --- Class reference ---
(import-class NSString)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _uint64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _uint64)))
(define _msg-1  ; (_fun _pointer _pointer _uint64 -> _uint64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _uint64)))

;; --- Constructors ---
(define (make-nsstring-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSString alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))


;; --- Properties ---
(define (nsstring-utf8-string self)
  (tell #:type _pointer (coerce-arg self) UTF8String))
(define (nsstring-absolute-path self)
  (tell #:type _bool (coerce-arg self) absolutePath))
(define (nsstring-available-string-encodings)
  (tell #:type _pointer NSString availableStringEncodings))
(define (nsstring-bool-value self)
  (tell #:type _bool (coerce-arg self) boolValue))
(define (nsstring-capitalized-string self)
  (wrap-objc-object
   (tell (coerce-arg self) capitalizedString)))
(define (nsstring-custom-playground-quick-look self)
  (tell #:type _pointer (coerce-arg self) customPlaygroundQuickLook))
(define (nsstring-decomposed-string-with-canonical-mapping self)
  (wrap-objc-object
   (tell (coerce-arg self) decomposedStringWithCanonicalMapping)))
(define (nsstring-decomposed-string-with-compatibility-mapping self)
  (wrap-objc-object
   (tell (coerce-arg self) decomposedStringWithCompatibilityMapping)))
(define (nsstring-default-c-string-encoding)
  (tell #:type _uint64 NSString defaultCStringEncoding))
(define (nsstring-description self)
  (wrap-objc-object
   (tell (coerce-arg self) description)))
(define (nsstring-double-value self)
  (tell #:type _double (coerce-arg self) doubleValue))
(define (nsstring-fastest-encoding self)
  (tell #:type _uint64 (coerce-arg self) fastestEncoding))
(define (nsstring-file-system-representation self)
  (tell #:type _pointer (coerce-arg self) fileSystemRepresentation))
(define (nsstring-float-value self)
  (tell #:type _float (coerce-arg self) floatValue))
(define (nsstring-hash self)
  (tell #:type _uint64 (coerce-arg self) hash))
(define (nsstring-int-value self)
  (tell #:type _int32 (coerce-arg self) intValue))
(define (nsstring-integer-value self)
  (tell #:type _int64 (coerce-arg self) integerValue))
(define (nsstring-last-path-component self)
  (wrap-objc-object
   (tell (coerce-arg self) lastPathComponent)))
(define (nsstring-length self)
  (tell #:type _uint64 (coerce-arg self) length))
(define (nsstring-localized-capitalized-string self)
  (wrap-objc-object
   (tell (coerce-arg self) localizedCapitalizedString)))
(define (nsstring-localized-lowercase-string self)
  (wrap-objc-object
   (tell (coerce-arg self) localizedLowercaseString)))
(define (nsstring-localized-uppercase-string self)
  (wrap-objc-object
   (tell (coerce-arg self) localizedUppercaseString)))
(define (nsstring-long-long-value self)
  (tell #:type _int64 (coerce-arg self) longLongValue))
(define (nsstring-lowercase-string self)
  (wrap-objc-object
   (tell (coerce-arg self) lowercaseString)))
(define (nsstring-path-components self)
  (wrap-objc-object
   (tell (coerce-arg self) pathComponents)))
(define (nsstring-path-extension self)
  (wrap-objc-object
   (tell (coerce-arg self) pathExtension)))
(define (nsstring-precomposed-string-with-canonical-mapping self)
  (wrap-objc-object
   (tell (coerce-arg self) precomposedStringWithCanonicalMapping)))
(define (nsstring-precomposed-string-with-compatibility-mapping self)
  (wrap-objc-object
   (tell (coerce-arg self) precomposedStringWithCompatibilityMapping)))
(define (nsstring-smallest-encoding self)
  (tell #:type _uint64 (coerce-arg self) smallestEncoding))
(define (nsstring-string-by-abbreviating-with-tilde-in-path self)
  (wrap-objc-object
   (tell (coerce-arg self) stringByAbbreviatingWithTildeInPath)))
(define (nsstring-string-by-deleting-last-path-component self)
  (wrap-objc-object
   (tell (coerce-arg self) stringByDeletingLastPathComponent)))
(define (nsstring-string-by-deleting-path-extension self)
  (wrap-objc-object
   (tell (coerce-arg self) stringByDeletingPathExtension)))
(define (nsstring-string-by-expanding-tilde-in-path self)
  (wrap-objc-object
   (tell (coerce-arg self) stringByExpandingTildeInPath)))
(define (nsstring-string-by-removing-percent-encoding self)
  (wrap-objc-object
   (tell (coerce-arg self) stringByRemovingPercentEncoding)))
(define (nsstring-string-by-resolving-symlinks-in-path self)
  (wrap-objc-object
   (tell (coerce-arg self) stringByResolvingSymlinksInPath)))
(define (nsstring-string-by-standardizing-path self)
  (wrap-objc-object
   (tell (coerce-arg self) stringByStandardizingPath)))
(define (nsstring-uppercase-string self)
  (wrap-objc-object
   (tell (coerce-arg self) uppercaseString)))

;; --- Instance methods ---
(define (nsstring-character-at-index self index)
  (_msg-1 (coerce-arg self) (sel_registerName "characterAtIndex:") index))

;; --- Class methods ---
