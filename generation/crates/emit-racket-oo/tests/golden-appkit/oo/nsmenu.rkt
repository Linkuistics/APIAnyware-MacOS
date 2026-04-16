#lang racket/base
;; Generated binding for NSMenu (AppKit)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         (rename-in racket/contract [-> c->])
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt"
         "../../../runtime/block.rkt"
         "../../../runtime/type-mapping.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/AppKit.framework/AppKit"))
(define _objc-lib (ffi-lib "libobjc"))

(provide NSMenu)
(provide/contract
  [make-nsmenu-init-with-coder (c-> (or/c string? objc-object? #f) any/c)]
  [make-nsmenu-init-with-title (c-> (or/c string? objc-object? #f) any/c)]
  [nsmenu-allows-context-menu-plug-ins (c-> objc-object? boolean?)]
  [nsmenu-set-allows-context-menu-plug-ins! (c-> objc-object? boolean? void?)]
  [nsmenu-autoenables-items (c-> objc-object? boolean?)]
  [nsmenu-set-autoenables-items! (c-> objc-object? boolean? void?)]
  [nsmenu-automatically-inserts-writing-tools-items (c-> objc-object? boolean?)]
  [nsmenu-set-automatically-inserts-writing-tools-items! (c-> objc-object? boolean? void?)]
  [nsmenu-delegate (c-> objc-object? any/c)]
  [nsmenu-set-delegate! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenu-font (c-> objc-object? any/c)]
  [nsmenu-set-font! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenu-highlighted-item (c-> objc-object? any/c)]
  [nsmenu-item-array (c-> objc-object? any/c)]
  [nsmenu-set-item-array! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenu-menu-bar-height (c-> objc-object? real?)]
  [nsmenu-menu-changed-messages-enabled (c-> objc-object? boolean?)]
  [nsmenu-set-menu-changed-messages-enabled! (c-> objc-object? boolean? void?)]
  [nsmenu-minimum-width (c-> objc-object? real?)]
  [nsmenu-set-minimum-width! (c-> objc-object? real? void?)]
  [nsmenu-number-of-items (c-> objc-object? exact-integer?)]
  [nsmenu-presentation-style (c-> objc-object? exact-nonnegative-integer?)]
  [nsmenu-set-presentation-style! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsmenu-properties-to-update (c-> objc-object? exact-nonnegative-integer?)]
  [nsmenu-selected-items (c-> objc-object? any/c)]
  [nsmenu-set-selected-items! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenu-selection-mode (c-> objc-object? exact-nonnegative-integer?)]
  [nsmenu-set-selection-mode! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsmenu-shows-state-column (c-> objc-object? boolean?)]
  [nsmenu-set-shows-state-column! (c-> objc-object? boolean? void?)]
  [nsmenu-size (c-> objc-object? any/c)]
  [nsmenu-supermenu (c-> objc-object? any/c)]
  [nsmenu-set-supermenu! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenu-title (c-> objc-object? any/c)]
  [nsmenu-set-title! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenu-torn-off (c-> objc-object? boolean?)]
  [nsmenu-user-interface-layout-direction (c-> objc-object? exact-nonnegative-integer?)]
  [nsmenu-set-user-interface-layout-direction! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsmenu-add-item! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenu-add-item-with-title-action-key-equivalent! (c-> objc-object? (or/c string? objc-object? #f) string? (or/c string? objc-object? #f) any/c)]
  [nsmenu-cancel-tracking (c-> objc-object? void?)]
  [nsmenu-cancel-tracking-without-animation (c-> objc-object? void?)]
  [nsmenu-index-of-item (c-> objc-object? (or/c string? objc-object? #f) exact-integer?)]
  [nsmenu-index-of-item-with-represented-object (c-> objc-object? (or/c string? objc-object? #f) exact-integer?)]
  [nsmenu-index-of-item-with-submenu (c-> objc-object? (or/c string? objc-object? #f) exact-integer?)]
  [nsmenu-index-of-item-with-tag (c-> objc-object? exact-integer? exact-integer?)]
  [nsmenu-index-of-item-with-target-and-action (c-> objc-object? (or/c string? objc-object? #f) string? exact-integer?)]
  [nsmenu-index-of-item-with-title (c-> objc-object? (or/c string? objc-object? #f) exact-integer?)]
  [nsmenu-insert-item-at-index! (c-> objc-object? (or/c string? objc-object? #f) exact-integer? void?)]
  [nsmenu-insert-item-with-title-action-key-equivalent-at-index! (c-> objc-object? (or/c string? objc-object? #f) string? (or/c string? objc-object? #f) exact-integer? any/c)]
  [nsmenu-item-at-index (c-> objc-object? exact-integer? any/c)]
  [nsmenu-item-changed (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenu-item-with-tag (c-> objc-object? exact-integer? any/c)]
  [nsmenu-item-with-title (c-> objc-object? (or/c string? objc-object? #f) any/c)]
  [nsmenu-perform-action-for-item-at-index! (c-> objc-object? exact-integer? void?)]
  [nsmenu-perform-key-equivalent! (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nsmenu-pop-up-menu-positioning-item-at-location-in-view (c-> objc-object? (or/c string? objc-object? #f) any/c (or/c string? objc-object? #f) boolean?)]
  [nsmenu-remove-all-items! (c-> objc-object? void?)]
  [nsmenu-remove-item! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsmenu-remove-item-at-index! (c-> objc-object? exact-integer? void?)]
  [nsmenu-set-submenu-for-item! (c-> objc-object? (or/c string? objc-object? #f) (or/c string? objc-object? #f) void?)]
  [nsmenu-update (c-> objc-object? void?)]
  [nsmenu-menu-bar-visible (c-> boolean?)]
  [nsmenu-pop-up-context-menu-with-event-for-view (c-> (or/c string? objc-object? #f) (or/c string? objc-object? #f) (or/c string? objc-object? #f) void?)]
  [nsmenu-pop-up-context-menu-with-event-for-view-with-font (c-> (or/c string? objc-object? #f) (or/c string? objc-object? #f) (or/c string? objc-object? #f) (or/c string? objc-object? #f) void?)]
  [nsmenu-set-menu-bar-visible! (c-> boolean? void?)]
  )

;; --- Class reference ---
(import-class NSMenu)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _NSSize)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _NSSize)))
(define _msg-1  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-2  ; (_fun _pointer _pointer -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _double)))
(define _msg-3  ; (_fun _pointer _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _int64)))
(define _msg-4  ; (_fun _pointer _pointer -> _uint64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _uint64)))
(define _msg-5  ; (_fun _pointer _pointer _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool -> _void)))
(define _msg-6  ; (_fun _pointer _pointer _double -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double -> _void)))
(define _msg-7  ; (_fun _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _bool)))
(define _msg-8  ; (_fun _pointer _pointer _id -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _int64)))
(define _msg-9  ; (_fun _pointer _pointer _id _NSPoint _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _NSPoint _id -> _bool)))
(define _msg-10  ; (_fun _pointer _pointer _id _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _int64 -> _void)))
(define _msg-11  ; (_fun _pointer _pointer _id _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _pointer -> _int64)))
(define _msg-12  ; (_fun _pointer _pointer _id _pointer _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _pointer _id -> _id)))
(define _msg-13  ; (_fun _pointer _pointer _id _pointer _id _int64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _pointer _id _int64 -> _id)))
(define _msg-14  ; (_fun _pointer _pointer _int64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _id)))
(define _msg-15  ; (_fun _pointer _pointer _int64 -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _int64)))
(define _msg-16  ; (_fun _pointer _pointer _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _void)))
(define _msg-17  ; (_fun _pointer _pointer _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _void)))

;; --- Constructors ---
(define (make-nsmenu-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSMenu alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))

(define (make-nsmenu-init-with-title title)
  (wrap-objc-object
   (tell (tell NSMenu alloc)
         initWithTitle: (coerce-arg title))
   #:retained #t))


;; --- Properties ---
(define (nsmenu-allows-context-menu-plug-ins self)
  (tell #:type _bool (coerce-arg self) allowsContextMenuPlugIns))
(define (nsmenu-set-allows-context-menu-plug-ins! self value)
  (_msg-5 (coerce-arg self) (sel_registerName "setAllowsContextMenuPlugIns:") value))
(define (nsmenu-autoenables-items self)
  (tell #:type _bool (coerce-arg self) autoenablesItems))
(define (nsmenu-set-autoenables-items! self value)
  (_msg-5 (coerce-arg self) (sel_registerName "setAutoenablesItems:") value))
(define (nsmenu-automatically-inserts-writing-tools-items self)
  (tell #:type _bool (coerce-arg self) automaticallyInsertsWritingToolsItems))
(define (nsmenu-set-automatically-inserts-writing-tools-items! self value)
  (_msg-5 (coerce-arg self) (sel_registerName "setAutomaticallyInsertsWritingToolsItems:") value))
(define (nsmenu-delegate self)
  (wrap-objc-object
   (tell (coerce-arg self) delegate)))
(define (nsmenu-set-delegate! self value)
  (tell #:type _void (coerce-arg self) setDelegate: (coerce-arg value)))
(define (nsmenu-font self)
  (wrap-objc-object
   (tell (coerce-arg self) font)))
(define (nsmenu-set-font! self value)
  (tell #:type _void (coerce-arg self) setFont: (coerce-arg value)))
(define (nsmenu-highlighted-item self)
  (wrap-objc-object
   (tell (coerce-arg self) highlightedItem)))
(define (nsmenu-item-array self)
  (wrap-objc-object
   (tell (coerce-arg self) itemArray)))
(define (nsmenu-set-item-array! self value)
  (tell #:type _void (coerce-arg self) setItemArray: (coerce-arg value)))
(define (nsmenu-menu-bar-height self)
  (tell #:type _double (coerce-arg self) menuBarHeight))
(define (nsmenu-menu-changed-messages-enabled self)
  (tell #:type _bool (coerce-arg self) menuChangedMessagesEnabled))
(define (nsmenu-set-menu-changed-messages-enabled! self value)
  (_msg-5 (coerce-arg self) (sel_registerName "setMenuChangedMessagesEnabled:") value))
(define (nsmenu-minimum-width self)
  (tell #:type _double (coerce-arg self) minimumWidth))
(define (nsmenu-set-minimum-width! self value)
  (_msg-6 (coerce-arg self) (sel_registerName "setMinimumWidth:") value))
(define (nsmenu-number-of-items self)
  (tell #:type _int64 (coerce-arg self) numberOfItems))
(define (nsmenu-presentation-style self)
  (tell #:type _uint64 (coerce-arg self) presentationStyle))
(define (nsmenu-set-presentation-style! self value)
  (_msg-17 (coerce-arg self) (sel_registerName "setPresentationStyle:") value))
(define (nsmenu-properties-to-update self)
  (tell #:type _uint64 (coerce-arg self) propertiesToUpdate))
(define (nsmenu-selected-items self)
  (wrap-objc-object
   (tell (coerce-arg self) selectedItems)))
(define (nsmenu-set-selected-items! self value)
  (tell #:type _void (coerce-arg self) setSelectedItems: (coerce-arg value)))
(define (nsmenu-selection-mode self)
  (tell #:type _uint64 (coerce-arg self) selectionMode))
(define (nsmenu-set-selection-mode! self value)
  (_msg-17 (coerce-arg self) (sel_registerName "setSelectionMode:") value))
(define (nsmenu-shows-state-column self)
  (tell #:type _bool (coerce-arg self) showsStateColumn))
(define (nsmenu-set-shows-state-column! self value)
  (_msg-5 (coerce-arg self) (sel_registerName "setShowsStateColumn:") value))
(define (nsmenu-size self)
  (tell #:type _NSSize (coerce-arg self) size))
(define (nsmenu-supermenu self)
  (wrap-objc-object
   (tell (coerce-arg self) supermenu)))
(define (nsmenu-set-supermenu! self value)
  (tell #:type _void (coerce-arg self) setSupermenu: (coerce-arg value)))
(define (nsmenu-title self)
  (wrap-objc-object
   (tell (coerce-arg self) title)))
(define (nsmenu-set-title! self value)
  (tell #:type _void (coerce-arg self) setTitle: (coerce-arg value)))
(define (nsmenu-torn-off self)
  (tell #:type _bool (coerce-arg self) tornOff))
(define (nsmenu-user-interface-layout-direction self)
  (tell #:type _uint64 (coerce-arg self) userInterfaceLayoutDirection))
(define (nsmenu-set-user-interface-layout-direction! self value)
  (_msg-17 (coerce-arg self) (sel_registerName "setUserInterfaceLayoutDirection:") value))

;; --- Instance methods ---
(define (nsmenu-add-item! self new-item)
  (tell #:type _void (coerce-arg self) addItem: (coerce-arg new-item)))
(define (nsmenu-add-item-with-title-action-key-equivalent! self string selector char-code)
  (wrap-objc-object
   (_msg-12 (coerce-arg self) (sel_registerName "addItemWithTitle:action:keyEquivalent:") (coerce-arg string) (sel_registerName selector) (coerce-arg char-code))
   ))
(define (nsmenu-cancel-tracking self)
  (tell #:type _void (coerce-arg self) cancelTracking))
(define (nsmenu-cancel-tracking-without-animation self)
  (tell #:type _void (coerce-arg self) cancelTrackingWithoutAnimation))
(define (nsmenu-index-of-item self item)
  (_msg-8 (coerce-arg self) (sel_registerName "indexOfItem:") (coerce-arg item)))
(define (nsmenu-index-of-item-with-represented-object self object)
  (_msg-8 (coerce-arg self) (sel_registerName "indexOfItemWithRepresentedObject:") (coerce-arg object)))
(define (nsmenu-index-of-item-with-submenu self submenu)
  (_msg-8 (coerce-arg self) (sel_registerName "indexOfItemWithSubmenu:") (coerce-arg submenu)))
(define (nsmenu-index-of-item-with-tag self tag)
  (_msg-15 (coerce-arg self) (sel_registerName "indexOfItemWithTag:") tag))
(define (nsmenu-index-of-item-with-target-and-action self target action-selector)
  (_msg-11 (coerce-arg self) (sel_registerName "indexOfItemWithTarget:andAction:") (coerce-arg target) (sel_registerName action-selector)))
(define (nsmenu-index-of-item-with-title self title)
  (_msg-8 (coerce-arg self) (sel_registerName "indexOfItemWithTitle:") (coerce-arg title)))
(define (nsmenu-insert-item-at-index! self new-item index)
  (_msg-10 (coerce-arg self) (sel_registerName "insertItem:atIndex:") (coerce-arg new-item) index))
(define (nsmenu-insert-item-with-title-action-key-equivalent-at-index! self string selector char-code index)
  (wrap-objc-object
   (_msg-13 (coerce-arg self) (sel_registerName "insertItemWithTitle:action:keyEquivalent:atIndex:") (coerce-arg string) (sel_registerName selector) (coerce-arg char-code) index)
   ))
(define (nsmenu-item-at-index self index)
  (wrap-objc-object
   (_msg-14 (coerce-arg self) (sel_registerName "itemAtIndex:") index)
   ))
(define (nsmenu-item-changed self item)
  (tell #:type _void (coerce-arg self) itemChanged: (coerce-arg item)))
(define (nsmenu-item-with-tag self tag)
  (wrap-objc-object
   (_msg-14 (coerce-arg self) (sel_registerName "itemWithTag:") tag)
   ))
(define (nsmenu-item-with-title self title)
  (wrap-objc-object
   (tell (coerce-arg self) itemWithTitle: (coerce-arg title))))
(define (nsmenu-perform-action-for-item-at-index! self index)
  (_msg-16 (coerce-arg self) (sel_registerName "performActionForItemAtIndex:") index))
(define (nsmenu-perform-key-equivalent! self event)
  (_msg-7 (coerce-arg self) (sel_registerName "performKeyEquivalent:") (coerce-arg event)))
(define (nsmenu-pop-up-menu-positioning-item-at-location-in-view self item location view)
  (_msg-9 (coerce-arg self) (sel_registerName "popUpMenuPositioningItem:atLocation:inView:") (coerce-arg item) location (coerce-arg view)))
(define (nsmenu-remove-all-items! self)
  (tell #:type _void (coerce-arg self) removeAllItems))
(define (nsmenu-remove-item! self item)
  (tell #:type _void (coerce-arg self) removeItem: (coerce-arg item)))
(define (nsmenu-remove-item-at-index! self index)
  (_msg-16 (coerce-arg self) (sel_registerName "removeItemAtIndex:") index))
(define (nsmenu-set-submenu-for-item! self menu item)
  (tell #:type _void (coerce-arg self) setSubmenu: (coerce-arg menu) forItem: (coerce-arg item)))
(define (nsmenu-update self)
  (tell #:type _void (coerce-arg self) update))

;; --- Class methods ---
(define (nsmenu-menu-bar-visible)
  (_msg-1 NSMenu (sel_registerName "menuBarVisible")))
(define (nsmenu-pop-up-context-menu-with-event-for-view menu event view)
  (tell #:type _void NSMenu popUpContextMenu: (coerce-arg menu) withEvent: (coerce-arg event) forView: (coerce-arg view)))
(define (nsmenu-pop-up-context-menu-with-event-for-view-with-font menu event view font)
  (tell #:type _void NSMenu popUpContextMenu: (coerce-arg menu) withEvent: (coerce-arg event) forView: (coerce-arg view) withFont: (coerce-arg font)))
(define (nsmenu-set-menu-bar-visible! visible)
  (_msg-5 NSMenu (sel_registerName "setMenuBarVisible:") visible))
