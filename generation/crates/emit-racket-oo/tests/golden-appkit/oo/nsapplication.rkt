#lang racket/base
;; Generated binding for NSApplication (AppKit)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         (rename-in racket/contract [-> c->])
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt"
         "../../../runtime/block.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/AppKit.framework/AppKit"))
(define _objc-lib (ffi-lib "libobjc"))

(provide NSApplication)
(provide/contract
  [make-nsapplication-init-with-coder (c-> (or/c string? objc-object? #f) any/c)]
  [nsapplication-accepts-first-responder (c-> objc-object? boolean?)]
  [nsapplication-active (c-> objc-object? boolean?)]
  [nsapplication-appearance (c-> objc-object? any/c)]
  [nsapplication-set-appearance! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-application-icon-image (c-> objc-object? any/c)]
  [nsapplication-set-application-icon-image! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-application-should-suppress-high-dynamic-range-content (c-> objc-object? boolean?)]
  [nsapplication-automatic-customize-touch-bar-menu-item-enabled (c-> objc-object? boolean?)]
  [nsapplication-set-automatic-customize-touch-bar-menu-item-enabled! (c-> objc-object? boolean? void?)]
  [nsapplication-context (c-> objc-object? any/c)]
  [nsapplication-current-event (c-> objc-object? any/c)]
  [nsapplication-current-system-presentation-options (c-> objc-object? exact-nonnegative-integer?)]
  [nsapplication-delegate (c-> objc-object? any/c)]
  [nsapplication-set-delegate! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-dock-tile (c-> objc-object? any/c)]
  [nsapplication-effective-appearance (c-> objc-object? any/c)]
  [nsapplication-enabled-remote-notification-types (c-> objc-object? exact-nonnegative-integer?)]
  [nsapplication-full-keyboard-access-enabled (c-> objc-object? boolean?)]
  [nsapplication-help-menu (c-> objc-object? any/c)]
  [nsapplication-set-help-menu! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-hidden (c-> objc-object? boolean?)]
  [nsapplication-key-window (c-> objc-object? any/c)]
  [nsapplication-main-menu (c-> objc-object? any/c)]
  [nsapplication-set-main-menu! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-main-window (c-> objc-object? any/c)]
  [nsapplication-menu (c-> objc-object? any/c)]
  [nsapplication-set-menu! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-modal-window (c-> objc-object? any/c)]
  [nsapplication-next-responder (c-> objc-object? any/c)]
  [nsapplication-set-next-responder! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-occlusion-state (c-> objc-object? exact-nonnegative-integer?)]
  [nsapplication-ordered-documents (c-> objc-object? any/c)]
  [nsapplication-ordered-windows (c-> objc-object? any/c)]
  [nsapplication-presentation-options (c-> objc-object? exact-nonnegative-integer?)]
  [nsapplication-set-presentation-options! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsapplication-protected-data-available (c-> objc-object? boolean?)]
  [nsapplication-registered-for-remote-notifications (c-> objc-object? boolean?)]
  [nsapplication-restorable-state-key-paths (c-> any/c)]
  [nsapplication-running (c-> objc-object? boolean?)]
  [nsapplication-services-menu (c-> objc-object? any/c)]
  [nsapplication-set-services-menu! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-services-provider (c-> objc-object? any/c)]
  [nsapplication-set-services-provider! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-shared-application (c-> any/c)]
  [nsapplication-touch-bar (c-> objc-object? any/c)]
  [nsapplication-set-touch-bar! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-undo-manager (c-> objc-object? any/c)]
  [nsapplication-user-activity (c-> objc-object? any/c)]
  [nsapplication-set-user-activity! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-user-interface-layout-direction (c-> objc-object? exact-nonnegative-integer?)]
  [nsapplication-windows (c-> objc-object? any/c)]
  [nsapplication-windows-menu (c-> objc-object? any/c)]
  [nsapplication-set-windows-menu! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-abort-modal (c-> objc-object? void?)]
  [nsapplication-activate (c-> objc-object? void?)]
  [nsapplication-activate-ignoring-other-apps (c-> objc-object? boolean? void?)]
  [nsapplication-activation-policy (c-> objc-object? exact-nonnegative-integer?)]
  [nsapplication-become-first-responder (c-> objc-object? boolean?)]
  [nsapplication-begin-gesture-with-event! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-begin-modal-session-for-window! (c-> objc-object? (or/c string? objc-object? #f) (or/c cpointer? #f))]
  [nsapplication-cancel-user-attention-request (c-> objc-object? exact-integer? void?)]
  [nsapplication-change-mode-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-context-menu-key-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-cursor-update (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-deactivate (c-> objc-object? void?)]
  [nsapplication-end-gesture-with-event! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-end-modal-session! (c-> objc-object? (or/c cpointer? #f) void?)]
  [nsapplication-enumerate-windows-with-options-using-block (c-> objc-object? exact-nonnegative-integer? (or/c procedure? #f) void?)]
  [nsapplication-finish-launching (c-> objc-object? void?)]
  [nsapplication-flags-changed (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-flush-buffered-key-events (c-> objc-object? void?)]
  [nsapplication-help-requested (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-hide (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-hide-other-applications (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-interpret-key-events (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-is-active (c-> objc-object? boolean?)]
  [nsapplication-is-hidden (c-> objc-object? boolean?)]
  [nsapplication-is-protected-data-available (c-> objc-object? boolean?)]
  [nsapplication-is-running (c-> objc-object? boolean?)]
  [nsapplication-key-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-key-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-magnify-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-mouse-cancelled (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-mouse-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-mouse-dragged (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-mouse-entered (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-mouse-exited (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-mouse-moved (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-mouse-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-no-responder-for (c-> objc-object? string? void?)]
  [nsapplication-order-front-character-palette! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-other-mouse-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-other-mouse-dragged (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-other-mouse-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-perform-key-equivalent! (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nsapplication-pressure-change-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-prevent-window-ordering (c-> objc-object? void?)]
  [nsapplication-quick-look-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-reply-to-application-should-terminate (c-> objc-object? boolean? void?)]
  [nsapplication-reply-to-open-or-print (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsapplication-report-exception (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-request-user-attention (c-> objc-object? exact-nonnegative-integer? exact-integer?)]
  [nsapplication-resign-first-responder (c-> objc-object? boolean?)]
  [nsapplication-right-mouse-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-right-mouse-dragged (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-right-mouse-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-rotate-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-run (c-> objc-object? void?)]
  [nsapplication-run-modal-for-window (c-> objc-object? (or/c string? objc-object? #f) exact-integer?)]
  [nsapplication-run-modal-session (c-> objc-object? (or/c cpointer? #f) exact-integer?)]
  [nsapplication-scroll-wheel (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-set-activation-policy! (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nsapplication-set-windows-need-update! (c-> objc-object? boolean? void?)]
  [nsapplication-should-be-treated-as-ink-event (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nsapplication-show-context-help (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-smart-magnify-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-stop (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-stop-modal (c-> objc-object? void?)]
  [nsapplication-stop-modal-with-code (c-> objc-object? exact-integer? void?)]
  [nsapplication-supplemental-target-for-action-sender (c-> objc-object? string? (or/c string? objc-object? #f) any/c)]
  [nsapplication-swipe-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-tablet-point (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-tablet-proximity (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-terminate (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-touches-began-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-touches-cancelled-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-touches-ended-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-touches-moved-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-try-to-perform-with (c-> objc-object? string? (or/c string? objc-object? #f) boolean?)]
  [nsapplication-unhide (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-unhide-all-applications (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-unhide-without-activation (c-> objc-object? void?)]
  [nsapplication-update-windows (c-> objc-object? void?)]
  [nsapplication-valid-requestor-for-send-type-return-type (c-> objc-object? (or/c string? objc-object? #f) (or/c string? objc-object? #f) any/c)]
  [nsapplication-wants-forwarded-scroll-events-for-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nsapplication-wants-scroll-events-for-swipe-tracking-on-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nsapplication-window-with-window-number (c-> objc-object? exact-integer? any/c)]
  [nsapplication-yield-activation-to-application (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-yield-activation-to-application-with-bundle-identifier (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsapplication-detach-drawing-thread-to-target-with-object (c-> string? (or/c string? objc-object? #f) (or/c string? objc-object? #f) void?)]
  [nsapplication-load-application (c-> void?)]
  )

;; --- Class reference ---
(import-class NSApplication)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-1  ; (_fun _pointer _pointer -> _uint64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _uint64)))
(define _msg-2  ; (_fun _pointer _pointer _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool -> _void)))
(define _msg-3  ; (_fun _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _bool)))
(define _msg-4  ; (_fun _pointer _pointer _id -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _int64)))
(define _msg-5  ; (_fun _pointer _pointer _id -> _pointer)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _pointer)))
(define _msg-6  ; (_fun _pointer _pointer _int64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _id)))
(define _msg-7  ; (_fun _pointer _pointer _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _void)))
(define _msg-8  ; (_fun _pointer _pointer _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _int64)))
(define _msg-9  ; (_fun _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))
(define _msg-10  ; (_fun _pointer _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _bool)))
(define _msg-11  ; (_fun _pointer _pointer _pointer _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _id)))
(define _msg-12  ; (_fun _pointer _pointer _pointer _id _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id _id -> _void)))
(define _msg-13  ; (_fun _pointer _pointer _uint64 -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _bool)))
(define _msg-14  ; (_fun _pointer _pointer _uint64 -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _int64)))
(define _msg-15  ; (_fun _pointer _pointer _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _void)))
(define _msg-16  ; (_fun _pointer _pointer _uint64 _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 _pointer -> _void)))

;; --- Constructors ---
(define (make-nsapplication-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSApplication alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))


;; --- Properties ---
(define (nsapplication-accepts-first-responder self)
  (tell #:type _bool (coerce-arg self) acceptsFirstResponder))
(define (nsapplication-active self)
  (tell #:type _bool (coerce-arg self) active))
(define (nsapplication-appearance self)
  (wrap-objc-object
   (tell (coerce-arg self) appearance)))
(define (nsapplication-set-appearance! self value)
  (tell #:type _void (coerce-arg self) setAppearance: (coerce-arg value)))
(define (nsapplication-application-icon-image self)
  (wrap-objc-object
   (tell (coerce-arg self) applicationIconImage)))
(define (nsapplication-set-application-icon-image! self value)
  (tell #:type _void (coerce-arg self) setApplicationIconImage: (coerce-arg value)))
(define (nsapplication-application-should-suppress-high-dynamic-range-content self)
  (tell #:type _bool (coerce-arg self) applicationShouldSuppressHighDynamicRangeContent))
(define (nsapplication-automatic-customize-touch-bar-menu-item-enabled self)
  (tell #:type _bool (coerce-arg self) automaticCustomizeTouchBarMenuItemEnabled))
(define (nsapplication-set-automatic-customize-touch-bar-menu-item-enabled! self value)
  (_msg-2 (coerce-arg self) (sel_registerName "setAutomaticCustomizeTouchBarMenuItemEnabled:") value))
(define (nsapplication-context self)
  (wrap-objc-object
   (tell (coerce-arg self) context)))
(define (nsapplication-current-event self)
  (wrap-objc-object
   (tell (coerce-arg self) currentEvent)))
(define (nsapplication-current-system-presentation-options self)
  (tell #:type _uint64 (coerce-arg self) currentSystemPresentationOptions))
(define (nsapplication-delegate self)
  (wrap-objc-object
   (tell (coerce-arg self) delegate)))
(define (nsapplication-set-delegate! self value)
  (tell #:type _void (coerce-arg self) setDelegate: (coerce-arg value)))
(define (nsapplication-dock-tile self)
  (wrap-objc-object
   (tell (coerce-arg self) dockTile)))
(define (nsapplication-effective-appearance self)
  (wrap-objc-object
   (tell (coerce-arg self) effectiveAppearance)))
(define (nsapplication-enabled-remote-notification-types self)
  (tell #:type _uint64 (coerce-arg self) enabledRemoteNotificationTypes))
(define (nsapplication-full-keyboard-access-enabled self)
  (tell #:type _bool (coerce-arg self) fullKeyboardAccessEnabled))
(define (nsapplication-help-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) helpMenu)))
(define (nsapplication-set-help-menu! self value)
  (tell #:type _void (coerce-arg self) setHelpMenu: (coerce-arg value)))
(define (nsapplication-hidden self)
  (tell #:type _bool (coerce-arg self) hidden))
(define (nsapplication-key-window self)
  (wrap-objc-object
   (tell (coerce-arg self) keyWindow)))
(define (nsapplication-main-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) mainMenu)))
(define (nsapplication-set-main-menu! self value)
  (tell #:type _void (coerce-arg self) setMainMenu: (coerce-arg value)))
(define (nsapplication-main-window self)
  (wrap-objc-object
   (tell (coerce-arg self) mainWindow)))
(define (nsapplication-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) menu)))
(define (nsapplication-set-menu! self value)
  (tell #:type _void (coerce-arg self) setMenu: (coerce-arg value)))
(define (nsapplication-modal-window self)
  (wrap-objc-object
   (tell (coerce-arg self) modalWindow)))
(define (nsapplication-next-responder self)
  (wrap-objc-object
   (tell (coerce-arg self) nextResponder)))
(define (nsapplication-set-next-responder! self value)
  (tell #:type _void (coerce-arg self) setNextResponder: (coerce-arg value)))
(define (nsapplication-occlusion-state self)
  (tell #:type _uint64 (coerce-arg self) occlusionState))
(define (nsapplication-ordered-documents self)
  (wrap-objc-object
   (tell (coerce-arg self) orderedDocuments)))
(define (nsapplication-ordered-windows self)
  (wrap-objc-object
   (tell (coerce-arg self) orderedWindows)))
(define (nsapplication-presentation-options self)
  (tell #:type _uint64 (coerce-arg self) presentationOptions))
(define (nsapplication-set-presentation-options! self value)
  (_msg-15 (coerce-arg self) (sel_registerName "setPresentationOptions:") value))
(define (nsapplication-protected-data-available self)
  (tell #:type _bool (coerce-arg self) protectedDataAvailable))
(define (nsapplication-registered-for-remote-notifications self)
  (tell #:type _bool (coerce-arg self) registeredForRemoteNotifications))
(define (nsapplication-restorable-state-key-paths)
  (wrap-objc-object
   (tell NSApplication restorableStateKeyPaths)))
(define (nsapplication-running self)
  (tell #:type _bool (coerce-arg self) running))
(define (nsapplication-services-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) servicesMenu)))
(define (nsapplication-set-services-menu! self value)
  (tell #:type _void (coerce-arg self) setServicesMenu: (coerce-arg value)))
(define (nsapplication-services-provider self)
  (wrap-objc-object
   (tell (coerce-arg self) servicesProvider)))
(define (nsapplication-set-services-provider! self value)
  (tell #:type _void (coerce-arg self) setServicesProvider: (coerce-arg value)))
(define (nsapplication-shared-application)
  (wrap-objc-object
   (tell NSApplication sharedApplication)))
(define (nsapplication-touch-bar self)
  (wrap-objc-object
   (tell (coerce-arg self) touchBar)))
(define (nsapplication-set-touch-bar! self value)
  (tell #:type _void (coerce-arg self) setTouchBar: (coerce-arg value)))
(define (nsapplication-undo-manager self)
  (wrap-objc-object
   (tell (coerce-arg self) undoManager)))
(define (nsapplication-user-activity self)
  (wrap-objc-object
   (tell (coerce-arg self) userActivity)))
(define (nsapplication-set-user-activity! self value)
  (tell #:type _void (coerce-arg self) setUserActivity: (coerce-arg value)))
(define (nsapplication-user-interface-layout-direction self)
  (tell #:type _uint64 (coerce-arg self) userInterfaceLayoutDirection))
(define (nsapplication-windows self)
  (wrap-objc-object
   (tell (coerce-arg self) windows)))
(define (nsapplication-windows-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) windowsMenu)))
(define (nsapplication-set-windows-menu! self value)
  (tell #:type _void (coerce-arg self) setWindowsMenu: (coerce-arg value)))

;; --- Instance methods ---
(define (nsapplication-abort-modal self)
  (tell #:type _void (coerce-arg self) abortModal))
(define (nsapplication-activate self)
  (tell #:type _void (coerce-arg self) activate))
(define (nsapplication-activate-ignoring-other-apps self ignore-other-apps)
  (_msg-2 (coerce-arg self) (sel_registerName "activateIgnoringOtherApps:") ignore-other-apps))
(define (nsapplication-activation-policy self)
  (_msg-1 (coerce-arg self) (sel_registerName "activationPolicy")))
(define (nsapplication-become-first-responder self)
  (_msg-0 (coerce-arg self) (sel_registerName "becomeFirstResponder")))
(define (nsapplication-begin-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) beginGestureWithEvent: (coerce-arg event)))
(define (nsapplication-begin-modal-session-for-window! self window)
  (_msg-5 (coerce-arg self) (sel_registerName "beginModalSessionForWindow:") (coerce-arg window)))
(define (nsapplication-cancel-user-attention-request self request)
  (_msg-7 (coerce-arg self) (sel_registerName "cancelUserAttentionRequest:") request))
(define (nsapplication-change-mode-with-event self event)
  (tell #:type _void (coerce-arg self) changeModeWithEvent: (coerce-arg event)))
(define (nsapplication-context-menu-key-down self event)
  (tell #:type _void (coerce-arg self) contextMenuKeyDown: (coerce-arg event)))
(define (nsapplication-cursor-update self event)
  (tell #:type _void (coerce-arg self) cursorUpdate: (coerce-arg event)))
(define (nsapplication-deactivate self)
  (tell #:type _void (coerce-arg self) deactivate))
(define (nsapplication-end-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) endGestureWithEvent: (coerce-arg event)))
(define (nsapplication-end-modal-session! self session)
  (_msg-9 (coerce-arg self) (sel_registerName "endModalSession:") session))
(define (nsapplication-enumerate-windows-with-options-using-block self options block)
  (define-values (_blk1 _blk1-id)
    (make-objc-block block (list _id _pointer) _void))
  (_msg-16 (coerce-arg self) (sel_registerName "enumerateWindowsWithOptions:usingBlock:") options _blk1))
(define (nsapplication-finish-launching self)
  (tell #:type _void (coerce-arg self) finishLaunching))
(define (nsapplication-flags-changed self event)
  (tell #:type _void (coerce-arg self) flagsChanged: (coerce-arg event)))
(define (nsapplication-flush-buffered-key-events self)
  (tell #:type _void (coerce-arg self) flushBufferedKeyEvents))
(define (nsapplication-help-requested self event-ptr)
  (tell #:type _void (coerce-arg self) helpRequested: (coerce-arg event-ptr)))
(define (nsapplication-hide self sender)
  (tell #:type _void (coerce-arg self) hide: (coerce-arg sender)))
(define (nsapplication-hide-other-applications self sender)
  (tell #:type _void (coerce-arg self) hideOtherApplications: (coerce-arg sender)))
(define (nsapplication-interpret-key-events self event-array)
  (tell #:type _void (coerce-arg self) interpretKeyEvents: (coerce-arg event-array)))
(define (nsapplication-is-active self)
  (_msg-0 (coerce-arg self) (sel_registerName "isActive")))
(define (nsapplication-is-hidden self)
  (_msg-0 (coerce-arg self) (sel_registerName "isHidden")))
(define (nsapplication-is-protected-data-available self)
  (_msg-0 (coerce-arg self) (sel_registerName "isProtectedDataAvailable")))
(define (nsapplication-is-running self)
  (_msg-0 (coerce-arg self) (sel_registerName "isRunning")))
(define (nsapplication-key-down self event)
  (tell #:type _void (coerce-arg self) keyDown: (coerce-arg event)))
(define (nsapplication-key-up self event)
  (tell #:type _void (coerce-arg self) keyUp: (coerce-arg event)))
(define (nsapplication-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) magnifyWithEvent: (coerce-arg event)))
(define (nsapplication-mouse-cancelled self event)
  (tell #:type _void (coerce-arg self) mouseCancelled: (coerce-arg event)))
(define (nsapplication-mouse-down self event)
  (tell #:type _void (coerce-arg self) mouseDown: (coerce-arg event)))
(define (nsapplication-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) mouseDragged: (coerce-arg event)))
(define (nsapplication-mouse-entered self event)
  (tell #:type _void (coerce-arg self) mouseEntered: (coerce-arg event)))
(define (nsapplication-mouse-exited self event)
  (tell #:type _void (coerce-arg self) mouseExited: (coerce-arg event)))
(define (nsapplication-mouse-moved self event)
  (tell #:type _void (coerce-arg self) mouseMoved: (coerce-arg event)))
(define (nsapplication-mouse-up self event)
  (tell #:type _void (coerce-arg self) mouseUp: (coerce-arg event)))
(define (nsapplication-no-responder-for self event-selector)
  (_msg-9 (coerce-arg self) (sel_registerName "noResponderFor:") (sel_registerName event-selector)))
(define (nsapplication-order-front-character-palette! self sender)
  (tell #:type _void (coerce-arg self) orderFrontCharacterPalette: (coerce-arg sender)))
(define (nsapplication-other-mouse-down self event)
  (tell #:type _void (coerce-arg self) otherMouseDown: (coerce-arg event)))
(define (nsapplication-other-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) otherMouseDragged: (coerce-arg event)))
(define (nsapplication-other-mouse-up self event)
  (tell #:type _void (coerce-arg self) otherMouseUp: (coerce-arg event)))
(define (nsapplication-perform-key-equivalent! self event)
  (_msg-3 (coerce-arg self) (sel_registerName "performKeyEquivalent:") (coerce-arg event)))
(define (nsapplication-pressure-change-with-event self event)
  (tell #:type _void (coerce-arg self) pressureChangeWithEvent: (coerce-arg event)))
(define (nsapplication-prevent-window-ordering self)
  (tell #:type _void (coerce-arg self) preventWindowOrdering))
(define (nsapplication-quick-look-with-event self event)
  (tell #:type _void (coerce-arg self) quickLookWithEvent: (coerce-arg event)))
(define (nsapplication-reply-to-application-should-terminate self should-terminate)
  (_msg-2 (coerce-arg self) (sel_registerName "replyToApplicationShouldTerminate:") should-terminate))
(define (nsapplication-reply-to-open-or-print self reply)
  (_msg-15 (coerce-arg self) (sel_registerName "replyToOpenOrPrint:") reply))
(define (nsapplication-report-exception self exception)
  (tell #:type _void (coerce-arg self) reportException: (coerce-arg exception)))
(define (nsapplication-request-user-attention self request-type)
  (_msg-14 (coerce-arg self) (sel_registerName "requestUserAttention:") request-type))
(define (nsapplication-resign-first-responder self)
  (_msg-0 (coerce-arg self) (sel_registerName "resignFirstResponder")))
(define (nsapplication-right-mouse-down self event)
  (tell #:type _void (coerce-arg self) rightMouseDown: (coerce-arg event)))
(define (nsapplication-right-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) rightMouseDragged: (coerce-arg event)))
(define (nsapplication-right-mouse-up self event)
  (tell #:type _void (coerce-arg self) rightMouseUp: (coerce-arg event)))
(define (nsapplication-rotate-with-event self event)
  (tell #:type _void (coerce-arg self) rotateWithEvent: (coerce-arg event)))
(define (nsapplication-run self)
  (tell #:type _void (coerce-arg self) run))
(define (nsapplication-run-modal-for-window self window)
  (_msg-4 (coerce-arg self) (sel_registerName "runModalForWindow:") (coerce-arg window)))
(define (nsapplication-run-modal-session self session)
  (_msg-8 (coerce-arg self) (sel_registerName "runModalSession:") session))
(define (nsapplication-scroll-wheel self event)
  (tell #:type _void (coerce-arg self) scrollWheel: (coerce-arg event)))
(define (nsapplication-set-activation-policy! self activation-policy)
  (_msg-13 (coerce-arg self) (sel_registerName "setActivationPolicy:") activation-policy))
(define (nsapplication-set-windows-need-update! self need-update)
  (_msg-2 (coerce-arg self) (sel_registerName "setWindowsNeedUpdate:") need-update))
(define (nsapplication-should-be-treated-as-ink-event self event)
  (_msg-3 (coerce-arg self) (sel_registerName "shouldBeTreatedAsInkEvent:") (coerce-arg event)))
(define (nsapplication-show-context-help self sender)
  (tell #:type _void (coerce-arg self) showContextHelp: (coerce-arg sender)))
(define (nsapplication-smart-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) smartMagnifyWithEvent: (coerce-arg event)))
(define (nsapplication-stop self sender)
  (tell #:type _void (coerce-arg self) stop: (coerce-arg sender)))
(define (nsapplication-stop-modal self)
  (tell #:type _void (coerce-arg self) stopModal))
(define (nsapplication-stop-modal-with-code self return-code)
  (_msg-7 (coerce-arg self) (sel_registerName "stopModalWithCode:") return-code))
(define (nsapplication-supplemental-target-for-action-sender self action sender)
  (wrap-objc-object
   (_msg-11 (coerce-arg self) (sel_registerName "supplementalTargetForAction:sender:") (sel_registerName action) (coerce-arg sender))
   ))
(define (nsapplication-swipe-with-event self event)
  (tell #:type _void (coerce-arg self) swipeWithEvent: (coerce-arg event)))
(define (nsapplication-tablet-point self event)
  (tell #:type _void (coerce-arg self) tabletPoint: (coerce-arg event)))
(define (nsapplication-tablet-proximity self event)
  (tell #:type _void (coerce-arg self) tabletProximity: (coerce-arg event)))
(define (nsapplication-terminate self sender)
  (tell #:type _void (coerce-arg self) terminate: (coerce-arg sender)))
(define (nsapplication-touches-began-with-event self event)
  (tell #:type _void (coerce-arg self) touchesBeganWithEvent: (coerce-arg event)))
(define (nsapplication-touches-cancelled-with-event self event)
  (tell #:type _void (coerce-arg self) touchesCancelledWithEvent: (coerce-arg event)))
(define (nsapplication-touches-ended-with-event self event)
  (tell #:type _void (coerce-arg self) touchesEndedWithEvent: (coerce-arg event)))
(define (nsapplication-touches-moved-with-event self event)
  (tell #:type _void (coerce-arg self) touchesMovedWithEvent: (coerce-arg event)))
(define (nsapplication-try-to-perform-with self action object)
  (_msg-10 (coerce-arg self) (sel_registerName "tryToPerform:with:") (sel_registerName action) (coerce-arg object)))
(define (nsapplication-unhide self sender)
  (tell #:type _void (coerce-arg self) unhide: (coerce-arg sender)))
(define (nsapplication-unhide-all-applications self sender)
  (tell #:type _void (coerce-arg self) unhideAllApplications: (coerce-arg sender)))
(define (nsapplication-unhide-without-activation self)
  (tell #:type _void (coerce-arg self) unhideWithoutActivation))
(define (nsapplication-update-windows self)
  (tell #:type _void (coerce-arg self) updateWindows))
(define (nsapplication-valid-requestor-for-send-type-return-type self send-type return-type)
  (wrap-objc-object
   (tell (coerce-arg self) validRequestorForSendType: (coerce-arg send-type) returnType: (coerce-arg return-type))))
(define (nsapplication-wants-forwarded-scroll-events-for-axis self axis)
  (_msg-13 (coerce-arg self) (sel_registerName "wantsForwardedScrollEventsForAxis:") axis))
(define (nsapplication-wants-scroll-events-for-swipe-tracking-on-axis self axis)
  (_msg-13 (coerce-arg self) (sel_registerName "wantsScrollEventsForSwipeTrackingOnAxis:") axis))
(define (nsapplication-window-with-window-number self window-num)
  (wrap-objc-object
   (_msg-6 (coerce-arg self) (sel_registerName "windowWithWindowNumber:") window-num)
   ))
(define (nsapplication-yield-activation-to-application self application)
  (tell #:type _void (coerce-arg self) yieldActivationToApplication: (coerce-arg application)))
(define (nsapplication-yield-activation-to-application-with-bundle-identifier self bundle-identifier)
  (tell #:type _void (coerce-arg self) yieldActivationToApplicationWithBundleIdentifier: (coerce-arg bundle-identifier)))

;; --- Class methods ---
(define (nsapplication-detach-drawing-thread-to-target-with-object selector target argument)
  (_msg-12 NSApplication (sel_registerName "detachDrawingThread:toTarget:withObject:") (sel_registerName selector) (coerce-arg target) (coerce-arg argument)))
(define (nsapplication-load-application)
  (tell #:type _void NSApplication loadApplication))
