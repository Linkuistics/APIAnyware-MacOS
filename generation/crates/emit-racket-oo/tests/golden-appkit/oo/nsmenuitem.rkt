#lang racket/base
;; Generated binding for NSMenuItem (AppKit)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         (rename-in racket/contract [-> c->])
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/AppKit.framework/AppKit"))
(define _objc-lib (ffi-lib "libobjc"))


;; --- Class predicates ---
(define (nsattributedstring? v) (objc-instance-of? v "NSAttributedString"))
(define (nsimage? v) (objc-instance-of? v "NSImage"))
(define (nsmenu? v) (objc-instance-of? v "NSMenu"))
(define (nsmenuitem? v) (objc-instance-of? v "NSMenuItem"))
(define (nsmenuitembadge? v) (objc-instance-of? v "NSMenuItemBadge"))
(define (nsstring? v) (objc-instance-of? v "NSString"))
(define (nsview? v) (objc-instance-of? v "NSView"))
(provide NSMenuItem)
(provide/contract
  [make-nsmenuitem-init-with-coder (c-> (or/c string? objc-object? #f) any/c)]
  [make-nsmenuitem-init-with-title-action-key-equivalent (c-> (or/c string? objc-object? #f) string? (or/c string? objc-object? #f) any/c)]
  [nsmenuitem-action (c-> objc-object? cpointer?)]
  [nsmenuitem-set-action! (c-> objc-object? string? void?)]
  [nsmenuitem-allows-automatic-key-equivalent-localization (c-> objc-object? boolean?)]
  [nsmenuitem-set-allows-automatic-key-equivalent-localization! (c-> objc-object? boolean? void?)]
  [nsmenuitem-allows-automatic-key-equivalent-mirroring (c-> objc-object? boolean?)]
  [nsmenuitem-set-allows-automatic-key-equivalent-mirroring! (c-> objc-object? boolean? void?)]
  [nsmenuitem-allows-key-equivalent-when-hidden (c-> objc-object? boolean?)]
  [nsmenuitem-set-allows-key-equivalent-when-hidden! (c-> objc-object? boolean? void?)]
  [nsmenuitem-alternate (c-> objc-object? boolean?)]
  [nsmenuitem-set-alternate! (c-> objc-object? boolean? void?)]
  [nsmenuitem-attributed-title (c-> objc-object? (or/c nsattributedstring? objc-nil?))]
  [nsmenuitem-set-attributed-title! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenuitem-badge (c-> objc-object? (or/c nsmenuitembadge? objc-nil?))]
  [nsmenuitem-set-badge! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenuitem-enabled (c-> objc-object? boolean?)]
  [nsmenuitem-set-enabled! (c-> objc-object? boolean? void?)]
  [nsmenuitem-has-submenu (c-> objc-object? boolean?)]
  [nsmenuitem-hidden (c-> objc-object? boolean?)]
  [nsmenuitem-set-hidden! (c-> objc-object? boolean? void?)]
  [nsmenuitem-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nsmenuitem-highlighted (c-> objc-object? boolean?)]
  [nsmenuitem-image (c-> objc-object? (or/c nsimage? objc-nil?))]
  [nsmenuitem-set-image! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenuitem-indentation-level (c-> objc-object? exact-integer?)]
  [nsmenuitem-set-indentation-level! (c-> objc-object? exact-integer? void?)]
  [nsmenuitem-key-equivalent (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nsmenuitem-set-key-equivalent! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenuitem-key-equivalent-modifier-mask (c-> objc-object? exact-nonnegative-integer?)]
  [nsmenuitem-set-key-equivalent-modifier-mask! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsmenuitem-menu (c-> objc-object? (or/c nsmenu? objc-nil?))]
  [nsmenuitem-set-menu! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenuitem-mixed-state-image (c-> objc-object? (or/c nsimage? objc-nil?))]
  [nsmenuitem-set-mixed-state-image! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenuitem-off-state-image (c-> objc-object? (or/c nsimage? objc-nil?))]
  [nsmenuitem-set-off-state-image! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenuitem-on-state-image (c-> objc-object? (or/c nsimage? objc-nil?))]
  [nsmenuitem-set-on-state-image! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenuitem-parent-item (c-> objc-object? (or/c nsmenuitem? objc-nil?))]
  [nsmenuitem-represented-object (c-> objc-object? any/c)]
  [nsmenuitem-set-represented-object! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenuitem-section-header (c-> objc-object? boolean?)]
  [nsmenuitem-state (c-> objc-object? exact-integer?)]
  [nsmenuitem-set-state! (c-> objc-object? exact-integer? void?)]
  [nsmenuitem-submenu (c-> objc-object? (or/c nsmenu? objc-nil?))]
  [nsmenuitem-set-submenu! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenuitem-subtitle (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nsmenuitem-set-subtitle! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenuitem-tag (c-> objc-object? exact-integer?)]
  [nsmenuitem-set-tag! (c-> objc-object? exact-integer? void?)]
  [nsmenuitem-target (c-> objc-object? any/c)]
  [nsmenuitem-set-target! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenuitem-title (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nsmenuitem-set-title! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenuitem-tool-tip (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nsmenuitem-set-tool-tip! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenuitem-user-key-equivalent (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nsmenuitem-uses-user-key-equivalents (c-> boolean?)]
  [nsmenuitem-set-uses-user-key-equivalents! (c-> boolean? void?)]
  [nsmenuitem-view (c-> objc-object? (or/c nsview? objc-nil?))]
  [nsmenuitem-set-view! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenuitem-writing-tools-items (c-> any/c)]
  [nsmenuitem-is-alternate (c-> objc-object? boolean?)]
  [nsmenuitem-is-enabled (c-> objc-object? boolean?)]
  [nsmenuitem-is-hidden (c-> objc-object? boolean?)]
  [nsmenuitem-is-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nsmenuitem-is-highlighted (c-> objc-object? boolean?)]
  [nsmenuitem-is-section-header (c-> objc-object? boolean?)]
  [nsmenuitem-is-separator-item (c-> objc-object? boolean?)]
  [nsmenuitem-section-header-with-title (c-> (or/c string? objc-object? #f) any/c)]
  [nsmenuitem-separator-item (c-> (or/c nsmenuitem? objc-nil?))]
  )

;; --- Class reference ---
(import-class NSMenuItem)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-1  ; (_fun _pointer _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _int64)))
(define _msg-2  ; (_fun _pointer _pointer -> _pointer)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _pointer)))
(define _msg-3  ; (_fun _pointer _pointer -> _uint64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _uint64)))
(define _msg-4  ; (_fun _pointer _pointer _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool -> _void)))
(define _msg-5  ; (_fun _pointer _pointer _id _pointer _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _pointer _id -> _id)))
(define _msg-6  ; (_fun _pointer _pointer _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _void)))
(define _msg-7  ; (_fun _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))
(define _msg-8  ; (_fun _pointer _pointer _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _void)))

;; --- Constructors ---
(define (make-nsmenuitem-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSMenuItem alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))

(define (make-nsmenuitem-init-with-title-action-key-equivalent string selector char-code)
  (wrap-objc-object
   (_msg-5 (tell NSMenuItem alloc)
       (sel_registerName "initWithTitle:action:keyEquivalent:")
       (coerce-arg string)
       (sel_registerName selector)
       (coerce-arg char-code))
   #:retained #t))


;; --- Properties ---
(define (nsmenuitem-action self)
  (tell #:type _pointer (coerce-arg self) action))
(define (nsmenuitem-set-action! self value)
  (_msg-7 (coerce-arg self) (sel_registerName "setAction:") (sel_registerName value)))
(define (nsmenuitem-allows-automatic-key-equivalent-localization self)
  (tell #:type _bool (coerce-arg self) allowsAutomaticKeyEquivalentLocalization))
(define (nsmenuitem-set-allows-automatic-key-equivalent-localization! self value)
  (_msg-4 (coerce-arg self) (sel_registerName "setAllowsAutomaticKeyEquivalentLocalization:") value))
(define (nsmenuitem-allows-automatic-key-equivalent-mirroring self)
  (tell #:type _bool (coerce-arg self) allowsAutomaticKeyEquivalentMirroring))
(define (nsmenuitem-set-allows-automatic-key-equivalent-mirroring! self value)
  (_msg-4 (coerce-arg self) (sel_registerName "setAllowsAutomaticKeyEquivalentMirroring:") value))
(define (nsmenuitem-allows-key-equivalent-when-hidden self)
  (tell #:type _bool (coerce-arg self) allowsKeyEquivalentWhenHidden))
(define (nsmenuitem-set-allows-key-equivalent-when-hidden! self value)
  (_msg-4 (coerce-arg self) (sel_registerName "setAllowsKeyEquivalentWhenHidden:") value))
(define (nsmenuitem-alternate self)
  (tell #:type _bool (coerce-arg self) alternate))
(define (nsmenuitem-set-alternate! self value)
  (_msg-4 (coerce-arg self) (sel_registerName "setAlternate:") value))
(define (nsmenuitem-attributed-title self)
  (wrap-objc-object
   (tell (coerce-arg self) attributedTitle)))
(define (nsmenuitem-set-attributed-title! self value)
  (tell #:type _void (coerce-arg self) setAttributedTitle: (coerce-arg value)))
(define (nsmenuitem-badge self)
  (wrap-objc-object
   (tell (coerce-arg self) badge)))
(define (nsmenuitem-set-badge! self value)
  (tell #:type _void (coerce-arg self) setBadge: (coerce-arg value)))
(define (nsmenuitem-enabled self)
  (tell #:type _bool (coerce-arg self) enabled))
(define (nsmenuitem-set-enabled! self value)
  (_msg-4 (coerce-arg self) (sel_registerName "setEnabled:") value))
(define (nsmenuitem-has-submenu self)
  (tell #:type _bool (coerce-arg self) hasSubmenu))
(define (nsmenuitem-hidden self)
  (tell #:type _bool (coerce-arg self) hidden))
(define (nsmenuitem-set-hidden! self value)
  (_msg-4 (coerce-arg self) (sel_registerName "setHidden:") value))
(define (nsmenuitem-hidden-or-has-hidden-ancestor self)
  (tell #:type _bool (coerce-arg self) hiddenOrHasHiddenAncestor))
(define (nsmenuitem-highlighted self)
  (tell #:type _bool (coerce-arg self) highlighted))
(define (nsmenuitem-image self)
  (wrap-objc-object
   (tell (coerce-arg self) image)))
(define (nsmenuitem-set-image! self value)
  (tell #:type _void (coerce-arg self) setImage: (coerce-arg value)))
(define (nsmenuitem-indentation-level self)
  (tell #:type _int64 (coerce-arg self) indentationLevel))
(define (nsmenuitem-set-indentation-level! self value)
  (_msg-6 (coerce-arg self) (sel_registerName "setIndentationLevel:") value))
(define (nsmenuitem-key-equivalent self)
  (wrap-objc-object
   (tell (coerce-arg self) keyEquivalent)))
(define (nsmenuitem-set-key-equivalent! self value)
  (tell #:type _void (coerce-arg self) setKeyEquivalent: (coerce-arg value)))
(define (nsmenuitem-key-equivalent-modifier-mask self)
  (tell #:type _uint64 (coerce-arg self) keyEquivalentModifierMask))
(define (nsmenuitem-set-key-equivalent-modifier-mask! self value)
  (_msg-8 (coerce-arg self) (sel_registerName "setKeyEquivalentModifierMask:") value))
(define (nsmenuitem-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) menu)))
(define (nsmenuitem-set-menu! self value)
  (tell #:type _void (coerce-arg self) setMenu: (coerce-arg value)))
(define (nsmenuitem-mixed-state-image self)
  (wrap-objc-object
   (tell (coerce-arg self) mixedStateImage)))
(define (nsmenuitem-set-mixed-state-image! self value)
  (tell #:type _void (coerce-arg self) setMixedStateImage: (coerce-arg value)))
(define (nsmenuitem-off-state-image self)
  (wrap-objc-object
   (tell (coerce-arg self) offStateImage)))
(define (nsmenuitem-set-off-state-image! self value)
  (tell #:type _void (coerce-arg self) setOffStateImage: (coerce-arg value)))
(define (nsmenuitem-on-state-image self)
  (wrap-objc-object
   (tell (coerce-arg self) onStateImage)))
(define (nsmenuitem-set-on-state-image! self value)
  (tell #:type _void (coerce-arg self) setOnStateImage: (coerce-arg value)))
(define (nsmenuitem-parent-item self)
  (wrap-objc-object
   (tell (coerce-arg self) parentItem)))
(define (nsmenuitem-represented-object self)
  (wrap-objc-object
   (tell (coerce-arg self) representedObject)))
(define (nsmenuitem-set-represented-object! self value)
  (tell #:type _void (coerce-arg self) setRepresentedObject: (coerce-arg value)))
(define (nsmenuitem-section-header self)
  (tell #:type _bool (coerce-arg self) sectionHeader))
(define (nsmenuitem-state self)
  (tell #:type _int64 (coerce-arg self) state))
(define (nsmenuitem-set-state! self value)
  (_msg-6 (coerce-arg self) (sel_registerName "setState:") value))
(define (nsmenuitem-submenu self)
  (wrap-objc-object
   (tell (coerce-arg self) submenu)))
(define (nsmenuitem-set-submenu! self value)
  (tell #:type _void (coerce-arg self) setSubmenu: (coerce-arg value)))
(define (nsmenuitem-subtitle self)
  (wrap-objc-object
   (tell (coerce-arg self) subtitle)))
(define (nsmenuitem-set-subtitle! self value)
  (tell #:type _void (coerce-arg self) setSubtitle: (coerce-arg value)))
(define (nsmenuitem-tag self)
  (tell #:type _int64 (coerce-arg self) tag))
(define (nsmenuitem-set-tag! self value)
  (_msg-6 (coerce-arg self) (sel_registerName "setTag:") value))
(define (nsmenuitem-target self)
  (wrap-objc-object
   (tell (coerce-arg self) target)))
(define (nsmenuitem-set-target! self value)
  (tell #:type _void (coerce-arg self) setTarget: (coerce-arg value)))
(define (nsmenuitem-title self)
  (wrap-objc-object
   (tell (coerce-arg self) title)))
(define (nsmenuitem-set-title! self value)
  (tell #:type _void (coerce-arg self) setTitle: (coerce-arg value)))
(define (nsmenuitem-tool-tip self)
  (wrap-objc-object
   (tell (coerce-arg self) toolTip)))
(define (nsmenuitem-set-tool-tip! self value)
  (tell #:type _void (coerce-arg self) setToolTip: (coerce-arg value)))
(define (nsmenuitem-user-key-equivalent self)
  (wrap-objc-object
   (tell (coerce-arg self) userKeyEquivalent)))
(define (nsmenuitem-uses-user-key-equivalents)
  (tell #:type _bool NSMenuItem usesUserKeyEquivalents))
(define (nsmenuitem-set-uses-user-key-equivalents! value)
  (_msg-4 NSMenuItem (sel_registerName "setUsesUserKeyEquivalents:") value))
(define (nsmenuitem-view self)
  (wrap-objc-object
   (tell (coerce-arg self) view)))
(define (nsmenuitem-set-view! self value)
  (tell #:type _void (coerce-arg self) setView: (coerce-arg value)))
(define (nsmenuitem-writing-tools-items)
  (wrap-objc-object
   (tell NSMenuItem writingToolsItems)))

;; --- Instance methods ---
(define (nsmenuitem-is-alternate self)
  (_msg-0 (coerce-arg self) (sel_registerName "isAlternate")))
(define (nsmenuitem-is-enabled self)
  (_msg-0 (coerce-arg self) (sel_registerName "isEnabled")))
(define (nsmenuitem-is-hidden self)
  (_msg-0 (coerce-arg self) (sel_registerName "isHidden")))
(define (nsmenuitem-is-hidden-or-has-hidden-ancestor self)
  (_msg-0 (coerce-arg self) (sel_registerName "isHiddenOrHasHiddenAncestor")))
(define (nsmenuitem-is-highlighted self)
  (_msg-0 (coerce-arg self) (sel_registerName "isHighlighted")))
(define (nsmenuitem-is-section-header self)
  (_msg-0 (coerce-arg self) (sel_registerName "isSectionHeader")))
(define (nsmenuitem-is-separator-item self)
  (_msg-0 (coerce-arg self) (sel_registerName "isSeparatorItem")))

;; --- Class methods ---
(define (nsmenuitem-section-header-with-title title)
  (wrap-objc-object
   (tell NSMenuItem sectionHeaderWithTitle: (coerce-arg title))))
(define (nsmenuitem-separator-item)
  (wrap-objc-object
   (tell NSMenuItem separatorItem)))
