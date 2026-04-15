#lang racket/base
;; Generated binding for NSURL (Foundation)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         (rename-in racket/contract [-> c->])
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/Foundation.framework/Foundation"))
(define _objc-lib (ffi-lib "libobjc"))

(provide NSURL)
(provide/contract
  [make-nsurl-init-with-data-representation-relative-to-url (c-> any/c any/c any/c)]
  [make-nsurl-init-with-string (c-> any/c any/c)]
  [make-nsurl-init-with-string-encoding-invalid-characters (c-> any/c boolean? any/c)]
  [make-nsurl-init-with-string-relative-to-url (c-> any/c any/c any/c)]
  [nsurl-url-by-deleting-last-path-component (c-> objc-object? any/c)]
  [nsurl-url-by-deleting-path-extension (c-> objc-object? any/c)]
  [nsurl-url-by-resolving-symlinks-in-path (c-> objc-object? any/c)]
  [nsurl-url-by-standardizing-path (c-> objc-object? any/c)]
  [nsurl-absolute-string (c-> objc-object? any/c)]
  [nsurl-absolute-url (c-> objc-object? any/c)]
  [nsurl-base-url (c-> objc-object? any/c)]
  [nsurl-custom-playground-quick-look (c-> objc-object? any/c)]
  [nsurl-data-representation (c-> objc-object? any/c)]
  [nsurl-file-path-url (c-> objc-object? any/c)]
  [nsurl-file-system-representation (c-> objc-object? (or/c cpointer? #f))]
  [nsurl-file-url (c-> objc-object? boolean?)]
  [nsurl-fragment (c-> objc-object? any/c)]
  [nsurl-has-directory-path (c-> objc-object? boolean?)]
  [nsurl-host (c-> objc-object? any/c)]
  [nsurl-last-path-component (c-> objc-object? any/c)]
  [nsurl-parameter-string (c-> objc-object? any/c)]
  [nsurl-password (c-> objc-object? any/c)]
  [nsurl-path (c-> objc-object? any/c)]
  [nsurl-path-components (c-> objc-object? any/c)]
  [nsurl-path-extension (c-> objc-object? any/c)]
  [nsurl-port (c-> objc-object? any/c)]
  [nsurl-query (c-> objc-object? any/c)]
  [nsurl-relative-path (c-> objc-object? any/c)]
  [nsurl-relative-string (c-> objc-object? any/c)]
  [nsurl-resource-specifier (c-> objc-object? any/c)]
  [nsurl-scheme (c-> objc-object? any/c)]
  [nsurl-standardized-url (c-> objc-object? any/c)]
  [nsurl-user (c-> objc-object? any/c)]
  [nsurl-bookmark-data-with-options-including-resource-values-for-keys-relative-to-url-error (c-> objc-object? exact-nonnegative-integer? any/c any/c (or/c cpointer? #f) any/c)]
  [nsurl-file-reference-url (c-> objc-object? any/c)]
  [nsurl-get-file-system-representation-max-length (c-> objc-object? (or/c cpointer? #f) exact-nonnegative-integer? boolean?)]
  [nsurl-get-resource-value-for-key-error (c-> objc-object? (or/c cpointer? #f) any/c (or/c cpointer? #f) boolean?)]
  [nsurl-init-absolute-url-with-data-representation-relative-to-url (c-> objc-object? any/c any/c any/c)]
  [nsurl-init-by-resolving-bookmark-data-options-relative-to-url-bookmark-data-is-stale-error (c-> objc-object? any/c exact-nonnegative-integer? any/c (or/c cpointer? #f) (or/c cpointer? #f) any/c)]
  [nsurl-init-file-url-with-file-system-representation-is-directory-relative-to-url (c-> objc-object? (or/c cpointer? #f) boolean? any/c any/c)]
  [nsurl-init-file-url-with-path (c-> objc-object? any/c any/c)]
  [nsurl-init-file-url-with-path-is-directory (c-> objc-object? any/c boolean? any/c)]
  [nsurl-init-file-url-with-path-is-directory-relative-to-url (c-> objc-object? any/c boolean? any/c any/c)]
  [nsurl-init-file-url-with-path-relative-to-url (c-> objc-object? any/c any/c any/c)]
  [nsurl-is-file-reference-url (c-> objc-object? boolean?)]
  [nsurl-is-file-url (c-> objc-object? boolean?)]
  [nsurl-remove-all-cached-resource-values! (c-> objc-object? void?)]
  [nsurl-remove-cached-resource-value-for-key! (c-> objc-object? any/c void?)]
  [nsurl-resource-values-for-keys-error (c-> objc-object? any/c (or/c cpointer? #f) any/c)]
  [nsurl-set-resource-value-for-key-error! (c-> objc-object? any/c any/c (or/c cpointer? #f) boolean?)]
  [nsurl-set-resource-values-error! (c-> objc-object? any/c (or/c cpointer? #f) boolean?)]
  [nsurl-set-temporary-resource-value-for-key! (c-> objc-object? any/c any/c void?)]
  [nsurl-start-accessing-security-scoped-resource (c-> objc-object? boolean?)]
  [nsurl-stop-accessing-security-scoped-resource (c-> objc-object? void?)]
  [nsurl-url-by-resolving-alias-file-at-url-options-error (c-> any/c exact-nonnegative-integer? (or/c cpointer? #f) any/c)]
  [nsurl-url-by-resolving-bookmark-data-options-relative-to-url-bookmark-data-is-stale-error (c-> any/c exact-nonnegative-integer? any/c (or/c cpointer? #f) (or/c cpointer? #f) any/c)]
  [nsurl-url-with-data-representation-relative-to-url (c-> any/c any/c any/c)]
  [nsurl-url-with-string (c-> any/c any/c)]
  [nsurl-url-with-string-encoding-invalid-characters (c-> any/c boolean? any/c)]
  [nsurl-url-with-string-relative-to-url (c-> any/c any/c any/c)]
  [nsurl-absolute-url-with-data-representation-relative-to-url (c-> any/c any/c any/c)]
  [nsurl-bookmark-data-with-contents-of-url-error (c-> any/c (or/c cpointer? #f) any/c)]
  [nsurl-file-url-with-file-system-representation-is-directory-relative-to-url (c-> (or/c cpointer? #f) boolean? any/c any/c)]
  [nsurl-file-url-with-path (c-> any/c any/c)]
  [nsurl-file-url-with-path-is-directory (c-> any/c boolean? any/c)]
  [nsurl-file-url-with-path-is-directory-relative-to-url (c-> any/c boolean? any/c any/c)]
  [nsurl-file-url-with-path-relative-to-url (c-> any/c any/c any/c)]
  [nsurl-resource-values-for-keys-from-bookmark-data (c-> any/c any/c any/c)]
  [nsurl-write-bookmark-data-to-url-options-error (c-> any/c any/c exact-nonnegative-integer? (or/c cpointer? #f) boolean?)]
  )

;; --- Class reference ---
(import-class NSURL)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-1  ; (_fun _pointer _pointer -> _pointer)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _pointer)))
(define _msg-2  ; (_fun _pointer _pointer _id _bool -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _bool -> _id)))
(define _msg-3  ; (_fun _pointer _pointer _id _bool _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _bool _id -> _id)))
(define _msg-4  ; (_fun _pointer _pointer _id _id _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _id _pointer -> _bool)))
(define _msg-5  ; (_fun _pointer _pointer _id _id _uint64 _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _id _uint64 _pointer -> _bool)))
(define _msg-6  ; (_fun _pointer _pointer _id _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _pointer -> _bool)))
(define _msg-7  ; (_fun _pointer _pointer _id _pointer -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _pointer -> _id)))
(define _msg-8  ; (_fun _pointer _pointer _id _uint64 _id _pointer _pointer -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _uint64 _id _pointer _pointer -> _id)))
(define _msg-9  ; (_fun _pointer _pointer _id _uint64 _pointer -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _uint64 _pointer -> _id)))
(define _msg-10  ; (_fun _pointer _pointer _pointer _bool _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _bool _id -> _id)))
(define _msg-11  ; (_fun _pointer _pointer _pointer _id _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id _pointer -> _bool)))
(define _msg-12  ; (_fun _pointer _pointer _pointer _uint64 -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _uint64 -> _bool)))
(define _msg-13  ; (_fun _pointer _pointer _uint64 _id _id _pointer -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 _id _id _pointer -> _id)))

;; --- Constructors ---
(define (make-nsurl-init-with-data-representation-relative-to-url data base-url)
  (wrap-objc-object
   (tell (tell NSURL alloc)
         initWithDataRepresentation: (coerce-arg data) relativeToURL: (coerce-arg base-url))
   #:retained #t))

(define (make-nsurl-init-with-string url-string)
  (wrap-objc-object
   (tell (tell NSURL alloc)
         initWithString: (coerce-arg url-string))
   #:retained #t))

(define (make-nsurl-init-with-string-encoding-invalid-characters url-string encoding-invalid-characters)
  (wrap-objc-object
   (_msg-2 (tell NSURL alloc)
       (sel_registerName "initWithString:encodingInvalidCharacters:")
       (coerce-arg url-string)
       encoding-invalid-characters)
   #:retained #t))

(define (make-nsurl-init-with-string-relative-to-url url-string base-url)
  (wrap-objc-object
   (tell (tell NSURL alloc)
         initWithString: (coerce-arg url-string) relativeToURL: (coerce-arg base-url))
   #:retained #t))


;; --- Properties ---
(define (nsurl-url-by-deleting-last-path-component self)
  (wrap-objc-object
   (tell (coerce-arg self) URLByDeletingLastPathComponent)))
(define (nsurl-url-by-deleting-path-extension self)
  (wrap-objc-object
   (tell (coerce-arg self) URLByDeletingPathExtension)))
(define (nsurl-url-by-resolving-symlinks-in-path self)
  (wrap-objc-object
   (tell (coerce-arg self) URLByResolvingSymlinksInPath)))
(define (nsurl-url-by-standardizing-path self)
  (wrap-objc-object
   (tell (coerce-arg self) URLByStandardizingPath)))
(define (nsurl-absolute-string self)
  (wrap-objc-object
   (tell (coerce-arg self) absoluteString)))
(define (nsurl-absolute-url self)
  (wrap-objc-object
   (tell (coerce-arg self) absoluteURL)))
(define (nsurl-base-url self)
  (wrap-objc-object
   (tell (coerce-arg self) baseURL)))
(define (nsurl-custom-playground-quick-look self)
  (wrap-objc-object
   (tell (coerce-arg self) customPlaygroundQuickLook)))
(define (nsurl-data-representation self)
  (wrap-objc-object
   (tell (coerce-arg self) dataRepresentation)))
(define (nsurl-file-path-url self)
  (wrap-objc-object
   (tell (coerce-arg self) filePathURL)))
(define (nsurl-file-system-representation self)
  (tell #:type _pointer (coerce-arg self) fileSystemRepresentation))
(define (nsurl-file-url self)
  (tell #:type _bool (coerce-arg self) fileURL))
(define (nsurl-fragment self)
  (wrap-objc-object
   (tell (coerce-arg self) fragment)))
(define (nsurl-has-directory-path self)
  (tell #:type _bool (coerce-arg self) hasDirectoryPath))
(define (nsurl-host self)
  (wrap-objc-object
   (tell (coerce-arg self) host)))
(define (nsurl-last-path-component self)
  (wrap-objc-object
   (tell (coerce-arg self) lastPathComponent)))
(define (nsurl-parameter-string self)
  (wrap-objc-object
   (tell (coerce-arg self) parameterString)))
(define (nsurl-password self)
  (wrap-objc-object
   (tell (coerce-arg self) password)))
(define (nsurl-path self)
  (wrap-objc-object
   (tell (coerce-arg self) path)))
(define (nsurl-path-components self)
  (wrap-objc-object
   (tell (coerce-arg self) pathComponents)))
(define (nsurl-path-extension self)
  (wrap-objc-object
   (tell (coerce-arg self) pathExtension)))
(define (nsurl-port self)
  (wrap-objc-object
   (tell (coerce-arg self) port)))
(define (nsurl-query self)
  (wrap-objc-object
   (tell (coerce-arg self) query)))
(define (nsurl-relative-path self)
  (wrap-objc-object
   (tell (coerce-arg self) relativePath)))
(define (nsurl-relative-string self)
  (wrap-objc-object
   (tell (coerce-arg self) relativeString)))
(define (nsurl-resource-specifier self)
  (wrap-objc-object
   (tell (coerce-arg self) resourceSpecifier)))
(define (nsurl-scheme self)
  (wrap-objc-object
   (tell (coerce-arg self) scheme)))
(define (nsurl-standardized-url self)
  (wrap-objc-object
   (tell (coerce-arg self) standardizedURL)))
(define (nsurl-user self)
  (wrap-objc-object
   (tell (coerce-arg self) user)))

;; --- Instance methods ---
(define (nsurl-bookmark-data-with-options-including-resource-values-for-keys-relative-to-url-error self options keys relative-url error)
  (wrap-objc-object
   (_msg-13 (coerce-arg self) (sel_registerName "bookmarkDataWithOptions:includingResourceValuesForKeys:relativeToURL:error:") options (coerce-arg keys) (coerce-arg relative-url) error)
   ))
(define (nsurl-file-reference-url self)
  (wrap-objc-object
   (tell (coerce-arg self) fileReferenceURL)))
(define (nsurl-get-file-system-representation-max-length self buffer max-buffer-length)
  (_msg-12 (coerce-arg self) (sel_registerName "getFileSystemRepresentation:maxLength:") buffer max-buffer-length))
(define (nsurl-get-resource-value-for-key-error self value key error)
  (_msg-11 (coerce-arg self) (sel_registerName "getResourceValue:forKey:error:") value (coerce-arg key) error))
(define (nsurl-init-absolute-url-with-data-representation-relative-to-url self data base-url)
  (wrap-objc-object
   (tell (coerce-arg self) initAbsoluteURLWithDataRepresentation: (coerce-arg data) relativeToURL: (coerce-arg base-url))
   #:retained #t))
(define (nsurl-init-by-resolving-bookmark-data-options-relative-to-url-bookmark-data-is-stale-error self bookmark-data options relative-url is-stale error)
  (wrap-objc-object
   (_msg-8 (coerce-arg self) (sel_registerName "initByResolvingBookmarkData:options:relativeToURL:bookmarkDataIsStale:error:") (coerce-arg bookmark-data) options (coerce-arg relative-url) is-stale error)
   #:retained #t))
(define (nsurl-init-file-url-with-file-system-representation-is-directory-relative-to-url self path is-dir base-url)
  (wrap-objc-object
   (_msg-10 (coerce-arg self) (sel_registerName "initFileURLWithFileSystemRepresentation:isDirectory:relativeToURL:") path is-dir (coerce-arg base-url))
   #:retained #t))
(define (nsurl-init-file-url-with-path self path)
  (wrap-objc-object
   (tell (coerce-arg self) initFileURLWithPath: (coerce-arg path))
   #:retained #t))
(define (nsurl-init-file-url-with-path-is-directory self path is-dir)
  (wrap-objc-object
   (_msg-2 (coerce-arg self) (sel_registerName "initFileURLWithPath:isDirectory:") (coerce-arg path) is-dir)
   #:retained #t))
(define (nsurl-init-file-url-with-path-is-directory-relative-to-url self path is-dir base-url)
  (wrap-objc-object
   (_msg-3 (coerce-arg self) (sel_registerName "initFileURLWithPath:isDirectory:relativeToURL:") (coerce-arg path) is-dir (coerce-arg base-url))
   #:retained #t))
(define (nsurl-init-file-url-with-path-relative-to-url self path base-url)
  (wrap-objc-object
   (tell (coerce-arg self) initFileURLWithPath: (coerce-arg path) relativeToURL: (coerce-arg base-url))
   #:retained #t))
(define (nsurl-is-file-reference-url self)
  (_msg-0 (coerce-arg self) (sel_registerName "isFileReferenceURL")))
(define (nsurl-is-file-url self)
  (_msg-0 (coerce-arg self) (sel_registerName "isFileURL")))
(define (nsurl-remove-all-cached-resource-values! self)
  (tell #:type _void (coerce-arg self) removeAllCachedResourceValues))
(define (nsurl-remove-cached-resource-value-for-key! self key)
  (tell #:type _void (coerce-arg self) removeCachedResourceValueForKey: (coerce-arg key)))
(define (nsurl-resource-values-for-keys-error self keys error)
  (wrap-objc-object
   (_msg-7 (coerce-arg self) (sel_registerName "resourceValuesForKeys:error:") (coerce-arg keys) error)
   ))
(define (nsurl-set-resource-value-for-key-error! self value key error)
  (_msg-4 (coerce-arg self) (sel_registerName "setResourceValue:forKey:error:") (coerce-arg value) (coerce-arg key) error))
(define (nsurl-set-resource-values-error! self keyed-values error)
  (_msg-6 (coerce-arg self) (sel_registerName "setResourceValues:error:") (coerce-arg keyed-values) error))
(define (nsurl-set-temporary-resource-value-for-key! self value key)
  (tell #:type _void (coerce-arg self) setTemporaryResourceValue: (coerce-arg value) forKey: (coerce-arg key)))
(define (nsurl-start-accessing-security-scoped-resource self)
  (_msg-0 (coerce-arg self) (sel_registerName "startAccessingSecurityScopedResource")))
(define (nsurl-stop-accessing-security-scoped-resource self)
  (tell #:type _void (coerce-arg self) stopAccessingSecurityScopedResource))

;; --- Class methods ---
(define (nsurl-url-by-resolving-alias-file-at-url-options-error url options error)
  (wrap-objc-object
   (_msg-9 NSURL (sel_registerName "URLByResolvingAliasFileAtURL:options:error:") (coerce-arg url) options error)
   ))
(define (nsurl-url-by-resolving-bookmark-data-options-relative-to-url-bookmark-data-is-stale-error bookmark-data options relative-url is-stale error)
  (wrap-objc-object
   (_msg-8 NSURL (sel_registerName "URLByResolvingBookmarkData:options:relativeToURL:bookmarkDataIsStale:error:") (coerce-arg bookmark-data) options (coerce-arg relative-url) is-stale error)
   ))
(define (nsurl-url-with-data-representation-relative-to-url data base-url)
  (wrap-objc-object
   (tell NSURL URLWithDataRepresentation: (coerce-arg data) relativeToURL: (coerce-arg base-url))))
(define (nsurl-url-with-string url-string)
  (wrap-objc-object
   (tell NSURL URLWithString: (coerce-arg url-string))))
(define (nsurl-url-with-string-encoding-invalid-characters url-string encoding-invalid-characters)
  (wrap-objc-object
   (_msg-2 NSURL (sel_registerName "URLWithString:encodingInvalidCharacters:") (coerce-arg url-string) encoding-invalid-characters)
   ))
(define (nsurl-url-with-string-relative-to-url url-string base-url)
  (wrap-objc-object
   (tell NSURL URLWithString: (coerce-arg url-string) relativeToURL: (coerce-arg base-url))))
(define (nsurl-absolute-url-with-data-representation-relative-to-url data base-url)
  (wrap-objc-object
   (tell NSURL absoluteURLWithDataRepresentation: (coerce-arg data) relativeToURL: (coerce-arg base-url))))
(define (nsurl-bookmark-data-with-contents-of-url-error bookmark-file-url error)
  (wrap-objc-object
   (_msg-7 NSURL (sel_registerName "bookmarkDataWithContentsOfURL:error:") (coerce-arg bookmark-file-url) error)
   ))
(define (nsurl-file-url-with-file-system-representation-is-directory-relative-to-url path is-dir base-url)
  (wrap-objc-object
   (_msg-10 NSURL (sel_registerName "fileURLWithFileSystemRepresentation:isDirectory:relativeToURL:") path is-dir (coerce-arg base-url))
   ))
(define (nsurl-file-url-with-path path)
  (wrap-objc-object
   (tell NSURL fileURLWithPath: (coerce-arg path))))
(define (nsurl-file-url-with-path-is-directory path is-dir)
  (wrap-objc-object
   (_msg-2 NSURL (sel_registerName "fileURLWithPath:isDirectory:") (coerce-arg path) is-dir)
   ))
(define (nsurl-file-url-with-path-is-directory-relative-to-url path is-dir base-url)
  (wrap-objc-object
   (_msg-3 NSURL (sel_registerName "fileURLWithPath:isDirectory:relativeToURL:") (coerce-arg path) is-dir (coerce-arg base-url))
   ))
(define (nsurl-file-url-with-path-relative-to-url path base-url)
  (wrap-objc-object
   (tell NSURL fileURLWithPath: (coerce-arg path) relativeToURL: (coerce-arg base-url))))
(define (nsurl-resource-values-for-keys-from-bookmark-data keys bookmark-data)
  (wrap-objc-object
   (tell NSURL resourceValuesForKeys: (coerce-arg keys) fromBookmarkData: (coerce-arg bookmark-data))))
(define (nsurl-write-bookmark-data-to-url-options-error bookmark-data bookmark-file-url options error)
  (_msg-5 NSURL (sel_registerName "writeBookmarkData:toURL:options:error:") (coerce-arg bookmark-data) (coerce-arg bookmark-file-url) options error))
