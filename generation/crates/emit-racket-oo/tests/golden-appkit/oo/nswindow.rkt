#lang racket/base
;; Generated binding for NSWindow (AppKit)
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

(provide NSWindow)
(provide/contract
  [make-nswindow-init-with-coder (c-> any/c any/c)]
  [make-nswindow-init-with-content-rect-style-mask-backing-defer (c-> any/c exact-nonnegative-integer? exact-nonnegative-integer? boolean? any/c)]
  [make-nswindow-init-with-content-rect-style-mask-backing-defer-screen (c-> any/c exact-nonnegative-integer? exact-nonnegative-integer? boolean? any/c any/c)]
  [nswindow-accepts-first-responder (c-> objc-object? boolean?)]
  [nswindow-accepts-mouse-moved-events (c-> objc-object? boolean?)]
  [nswindow-set-accepts-mouse-moved-events! (c-> objc-object? boolean? void?)]
  [nswindow-allows-automatic-window-tabbing (c-> boolean?)]
  [nswindow-set-allows-automatic-window-tabbing! (c-> boolean? void?)]
  [nswindow-allows-concurrent-view-drawing (c-> objc-object? boolean?)]
  [nswindow-set-allows-concurrent-view-drawing! (c-> objc-object? boolean? void?)]
  [nswindow-allows-tool-tips-when-application-is-inactive (c-> objc-object? boolean?)]
  [nswindow-set-allows-tool-tips-when-application-is-inactive! (c-> objc-object? boolean? void?)]
  [nswindow-alpha-value (c-> objc-object? real?)]
  [nswindow-set-alpha-value! (c-> objc-object? real? void?)]
  [nswindow-animation-behavior (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-set-animation-behavior! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nswindow-appearance-source (c-> objc-object? any/c)]
  [nswindow-set-appearance-source! (c-> objc-object? any/c void?)]
  [nswindow-are-cursor-rects-enabled (c-> objc-object? boolean?)]
  [nswindow-aspect-ratio (c-> objc-object? any/c)]
  [nswindow-set-aspect-ratio! (c-> objc-object? any/c void?)]
  [nswindow-attached-sheet (c-> objc-object? any/c)]
  [nswindow-autodisplay (c-> objc-object? boolean?)]
  [nswindow-set-autodisplay! (c-> objc-object? boolean? void?)]
  [nswindow-autorecalculates-key-view-loop (c-> objc-object? boolean?)]
  [nswindow-set-autorecalculates-key-view-loop! (c-> objc-object? boolean? void?)]
  [nswindow-background-color (c-> objc-object? any/c)]
  [nswindow-set-background-color! (c-> objc-object? any/c void?)]
  [nswindow-backing-location (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-backing-scale-factor (c-> objc-object? real?)]
  [nswindow-backing-type (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-set-backing-type! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nswindow-can-become-key-window (c-> objc-object? boolean?)]
  [nswindow-can-become-main-window (c-> objc-object? boolean?)]
  [nswindow-can-become-visible-without-login (c-> objc-object? boolean?)]
  [nswindow-set-can-become-visible-without-login! (c-> objc-object? boolean? void?)]
  [nswindow-can-hide (c-> objc-object? boolean?)]
  [nswindow-set-can-hide! (c-> objc-object? boolean? void?)]
  [nswindow-cascading-reference-frame (c-> objc-object? any/c)]
  [nswindow-child-windows (c-> objc-object? any/c)]
  [nswindow-collection-behavior (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-set-collection-behavior! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nswindow-color-space (c-> objc-object? any/c)]
  [nswindow-set-color-space! (c-> objc-object? any/c void?)]
  [nswindow-content-aspect-ratio (c-> objc-object? any/c)]
  [nswindow-set-content-aspect-ratio! (c-> objc-object? any/c void?)]
  [nswindow-content-layout-guide (c-> objc-object? any/c)]
  [nswindow-content-layout-rect (c-> objc-object? any/c)]
  [nswindow-content-max-size (c-> objc-object? any/c)]
  [nswindow-set-content-max-size! (c-> objc-object? any/c void?)]
  [nswindow-content-min-size (c-> objc-object? any/c)]
  [nswindow-set-content-min-size! (c-> objc-object? any/c void?)]
  [nswindow-content-resize-increments (c-> objc-object? any/c)]
  [nswindow-set-content-resize-increments! (c-> objc-object? any/c void?)]
  [nswindow-content-view (c-> objc-object? any/c)]
  [nswindow-set-content-view! (c-> objc-object? any/c void?)]
  [nswindow-content-view-controller (c-> objc-object? any/c)]
  [nswindow-set-content-view-controller! (c-> objc-object? any/c void?)]
  [nswindow-current-event (c-> objc-object? any/c)]
  [nswindow-deepest-screen (c-> objc-object? any/c)]
  [nswindow-default-button-cell (c-> objc-object? any/c)]
  [nswindow-set-default-button-cell! (c-> objc-object? any/c void?)]
  [nswindow-default-depth-limit (c-> exact-nonnegative-integer?)]
  [nswindow-delegate (c-> objc-object? any/c)]
  [nswindow-set-delegate! (c-> objc-object? any/c void?)]
  [nswindow-depth-limit (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-set-depth-limit! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nswindow-device-description (c-> objc-object? any/c)]
  [nswindow-displays-when-screen-profile-changes (c-> objc-object? boolean?)]
  [nswindow-set-displays-when-screen-profile-changes! (c-> objc-object? boolean? void?)]
  [nswindow-dock-tile (c-> objc-object? any/c)]
  [nswindow-document-edited (c-> objc-object? boolean?)]
  [nswindow-set-document-edited! (c-> objc-object? boolean? void?)]
  [nswindow-drawers (c-> objc-object? any/c)]
  [nswindow-excluded-from-windows-menu (c-> objc-object? boolean?)]
  [nswindow-set-excluded-from-windows-menu! (c-> objc-object? boolean? void?)]
  [nswindow-first-responder (c-> objc-object? any/c)]
  [nswindow-floating-panel (c-> objc-object? boolean?)]
  [nswindow-flush-window-disabled (c-> objc-object? boolean?)]
  [nswindow-frame (c-> objc-object? any/c)]
  [nswindow-frame-autosave-name (c-> objc-object? any/c)]
  [nswindow-graphics-context (c-> objc-object? any/c)]
  [nswindow-has-active-window-sharing-session (c-> objc-object? boolean?)]
  [nswindow-has-close-box (c-> objc-object? boolean?)]
  [nswindow-has-dynamic-depth-limit (c-> objc-object? boolean?)]
  [nswindow-has-shadow (c-> objc-object? boolean?)]
  [nswindow-set-has-shadow! (c-> objc-object? boolean? void?)]
  [nswindow-has-title-bar (c-> objc-object? boolean?)]
  [nswindow-hides-on-deactivate (c-> objc-object? boolean?)]
  [nswindow-set-hides-on-deactivate! (c-> objc-object? boolean? void?)]
  [nswindow-ignores-mouse-events (c-> objc-object? boolean?)]
  [nswindow-set-ignores-mouse-events! (c-> objc-object? boolean? void?)]
  [nswindow-in-live-resize (c-> objc-object? boolean?)]
  [nswindow-initial-first-responder (c-> objc-object? any/c)]
  [nswindow-set-initial-first-responder! (c-> objc-object? any/c void?)]
  [nswindow-key-view-selection-direction (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-key-window (c-> objc-object? boolean?)]
  [nswindow-level (c-> objc-object? exact-integer?)]
  [nswindow-set-level! (c-> objc-object? exact-integer? void?)]
  [nswindow-main-window (c-> objc-object? boolean?)]
  [nswindow-max-full-screen-content-size (c-> objc-object? any/c)]
  [nswindow-set-max-full-screen-content-size! (c-> objc-object? any/c void?)]
  [nswindow-max-size (c-> objc-object? any/c)]
  [nswindow-set-max-size! (c-> objc-object? any/c void?)]
  [nswindow-menu (c-> objc-object? any/c)]
  [nswindow-set-menu! (c-> objc-object? any/c void?)]
  [nswindow-min-full-screen-content-size (c-> objc-object? any/c)]
  [nswindow-set-min-full-screen-content-size! (c-> objc-object? any/c void?)]
  [nswindow-min-size (c-> objc-object? any/c)]
  [nswindow-set-min-size! (c-> objc-object? any/c void?)]
  [nswindow-miniaturizable (c-> objc-object? boolean?)]
  [nswindow-miniaturized (c-> objc-object? boolean?)]
  [nswindow-miniwindow-image (c-> objc-object? any/c)]
  [nswindow-set-miniwindow-image! (c-> objc-object? any/c void?)]
  [nswindow-miniwindow-title (c-> objc-object? any/c)]
  [nswindow-set-miniwindow-title! (c-> objc-object? any/c void?)]
  [nswindow-modal-panel (c-> objc-object? boolean?)]
  [nswindow-mouse-location-outside-of-event-stream (c-> objc-object? any/c)]
  [nswindow-movable (c-> objc-object? boolean?)]
  [nswindow-set-movable! (c-> objc-object? boolean? void?)]
  [nswindow-movable-by-window-background (c-> objc-object? boolean?)]
  [nswindow-set-movable-by-window-background! (c-> objc-object? boolean? void?)]
  [nswindow-next-responder (c-> objc-object? any/c)]
  [nswindow-set-next-responder! (c-> objc-object? any/c void?)]
  [nswindow-occlusion-state (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-on-active-space (c-> objc-object? boolean?)]
  [nswindow-one-shot (c-> objc-object? boolean?)]
  [nswindow-set-one-shot! (c-> objc-object? boolean? void?)]
  [nswindow-opaque (c-> objc-object? boolean?)]
  [nswindow-set-opaque! (c-> objc-object? boolean? void?)]
  [nswindow-ordered-index (c-> objc-object? exact-integer?)]
  [nswindow-set-ordered-index! (c-> objc-object? exact-integer? void?)]
  [nswindow-parent-window (c-> objc-object? any/c)]
  [nswindow-set-parent-window! (c-> objc-object? any/c void?)]
  [nswindow-preferred-backing-location (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-set-preferred-backing-location! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nswindow-preserves-content-during-live-resize (c-> objc-object? boolean?)]
  [nswindow-set-preserves-content-during-live-resize! (c-> objc-object? boolean? void?)]
  [nswindow-prevents-application-termination-when-modal (c-> objc-object? boolean?)]
  [nswindow-set-prevents-application-termination-when-modal! (c-> objc-object? boolean? void?)]
  [nswindow-released-when-closed (c-> objc-object? boolean?)]
  [nswindow-set-released-when-closed! (c-> objc-object? boolean? void?)]
  [nswindow-represented-filename (c-> objc-object? any/c)]
  [nswindow-set-represented-filename! (c-> objc-object? any/c void?)]
  [nswindow-represented-url (c-> objc-object? any/c)]
  [nswindow-set-represented-url! (c-> objc-object? any/c void?)]
  [nswindow-resizable (c-> objc-object? boolean?)]
  [nswindow-resize-flags (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-resize-increments (c-> objc-object? any/c)]
  [nswindow-set-resize-increments! (c-> objc-object? any/c void?)]
  [nswindow-restorable (c-> objc-object? boolean?)]
  [nswindow-set-restorable! (c-> objc-object? boolean? void?)]
  [nswindow-restorable-state-key-paths (c-> any/c)]
  [nswindow-restoration-class (c-> objc-object? any/c)]
  [nswindow-set-restoration-class! (c-> objc-object? any/c void?)]
  [nswindow-screen (c-> objc-object? any/c)]
  [nswindow-sharing-type (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-set-sharing-type! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nswindow-sheet (c-> objc-object? boolean?)]
  [nswindow-sheet-parent (c-> objc-object? any/c)]
  [nswindow-sheets (c-> objc-object? any/c)]
  [nswindow-shows-resize-indicator (c-> objc-object? boolean?)]
  [nswindow-set-shows-resize-indicator! (c-> objc-object? boolean? void?)]
  [nswindow-shows-toolbar-button (c-> objc-object? boolean?)]
  [nswindow-set-shows-toolbar-button! (c-> objc-object? boolean? void?)]
  [nswindow-string-with-saved-frame (c-> objc-object? any/c)]
  [nswindow-style-mask (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-set-style-mask! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nswindow-subtitle (c-> objc-object? any/c)]
  [nswindow-set-subtitle! (c-> objc-object? any/c void?)]
  [nswindow-tab (c-> objc-object? any/c)]
  [nswindow-tab-group (c-> objc-object? any/c)]
  [nswindow-tabbed-windows (c-> objc-object? any/c)]
  [nswindow-tabbing-identifier (c-> objc-object? any/c)]
  [nswindow-set-tabbing-identifier! (c-> objc-object? any/c void?)]
  [nswindow-tabbing-mode (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-set-tabbing-mode! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nswindow-title (c-> objc-object? any/c)]
  [nswindow-set-title! (c-> objc-object? any/c void?)]
  [nswindow-title-visibility (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-set-title-visibility! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nswindow-titlebar-accessory-view-controllers (c-> objc-object? any/c)]
  [nswindow-set-titlebar-accessory-view-controllers! (c-> objc-object? any/c void?)]
  [nswindow-titlebar-appears-transparent (c-> objc-object? boolean?)]
  [nswindow-set-titlebar-appears-transparent! (c-> objc-object? boolean? void?)]
  [nswindow-titlebar-separator-style (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-set-titlebar-separator-style! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nswindow-toolbar (c-> objc-object? any/c)]
  [nswindow-set-toolbar! (c-> objc-object? any/c void?)]
  [nswindow-toolbar-style (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-set-toolbar-style! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nswindow-touch-bar (c-> objc-object? any/c)]
  [nswindow-set-touch-bar! (c-> objc-object? any/c void?)]
  [nswindow-undo-manager (c-> objc-object? any/c)]
  [nswindow-user-activity (c-> objc-object? any/c)]
  [nswindow-set-user-activity! (c-> objc-object? any/c void?)]
  [nswindow-user-tabbing-preference (c-> exact-nonnegative-integer?)]
  [nswindow-views-need-display (c-> objc-object? boolean?)]
  [nswindow-set-views-need-display! (c-> objc-object? boolean? void?)]
  [nswindow-visible (c-> objc-object? boolean?)]
  [nswindow-window-controller (c-> objc-object? any/c)]
  [nswindow-set-window-controller! (c-> objc-object? any/c void?)]
  [nswindow-window-number (c-> objc-object? exact-integer?)]
  [nswindow-window-ref (c-> objc-object? (or/c cpointer? #f))]
  [nswindow-window-titlebar-layout-direction (c-> objc-object? exact-nonnegative-integer?)]
  [nswindow-works-when-modal (c-> objc-object? boolean?)]
  [nswindow-zoomable (c-> objc-object? boolean?)]
  [nswindow-zoomed (c-> objc-object? boolean?)]
  [nswindow-add-child-window-ordered! (c-> objc-object? any/c exact-nonnegative-integer? void?)]
  [nswindow-add-tabbed-window-ordered! (c-> objc-object? any/c exact-nonnegative-integer? void?)]
  [nswindow-add-titlebar-accessory-view-controller! (c-> objc-object? any/c void?)]
  [nswindow-animation-resize-time (c-> objc-object? any/c real?)]
  [nswindow-autorecalculates-content-border-thickness-for-edge (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nswindow-backing-aligned-rect-options (c-> objc-object? any/c exact-nonnegative-integer? any/c)]
  [nswindow-become-first-responder (c-> objc-object? boolean?)]
  [nswindow-become-key-window (c-> objc-object? void?)]
  [nswindow-become-main-window (c-> objc-object? void?)]
  [nswindow-begin-critical-sheet-completion-handler! (c-> objc-object? any/c (or/c procedure? #f) void?)]
  [nswindow-begin-gesture-with-event! (c-> objc-object? any/c void?)]
  [nswindow-begin-sheet-completion-handler! (c-> objc-object? any/c (or/c procedure? #f) void?)]
  [nswindow-can-represent-display-gamut (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nswindow-cascade-top-left-from-point (c-> objc-object? any/c any/c)]
  [nswindow-center! (c-> objc-object? void?)]
  [nswindow-change-mode-with-event (c-> objc-object? any/c void?)]
  [nswindow-close! (c-> objc-object? void?)]
  [nswindow-constrain-frame-rect-to-screen (c-> objc-object? any/c any/c any/c)]
  [nswindow-content-border-thickness-for-edge (c-> objc-object? exact-nonnegative-integer? real?)]
  [nswindow-content-rect-for-frame-rect (c-> objc-object? any/c any/c)]
  [nswindow-context-menu-key-down (c-> objc-object? any/c void?)]
  [nswindow-convert-point-from-backing (c-> objc-object? any/c any/c)]
  [nswindow-convert-point-from-screen (c-> objc-object? any/c any/c)]
  [nswindow-convert-point-to-backing (c-> objc-object? any/c any/c)]
  [nswindow-convert-point-to-screen (c-> objc-object? any/c any/c)]
  [nswindow-convert-rect-from-backing (c-> objc-object? any/c any/c)]
  [nswindow-convert-rect-from-screen (c-> objc-object? any/c any/c)]
  [nswindow-convert-rect-to-backing (c-> objc-object? any/c any/c)]
  [nswindow-convert-rect-to-screen (c-> objc-object? any/c any/c)]
  [nswindow-cursor-update (c-> objc-object? any/c void?)]
  [nswindow-data-with-eps-inside-rect (c-> objc-object? any/c any/c)]
  [nswindow-data-with-pdf-inside-rect (c-> objc-object? any/c any/c)]
  [nswindow-deminiaturize (c-> objc-object? any/c void?)]
  [nswindow-disable-key-equivalent-for-default-button-cell (c-> objc-object? void?)]
  [nswindow-display! (c-> objc-object? void?)]
  [nswindow-display-if-needed! (c-> objc-object? void?)]
  [nswindow-displays-when-screen-profile-changes! (c-> objc-object? boolean?)]
  [nswindow-enable-key-equivalent-for-default-button-cell (c-> objc-object? void?)]
  [nswindow-end-editing-for! (c-> objc-object? any/c void?)]
  [nswindow-end-gesture-with-event! (c-> objc-object? any/c void?)]
  [nswindow-end-sheet! (c-> objc-object? any/c void?)]
  [nswindow-end-sheet-return-code! (c-> objc-object? any/c exact-integer? void?)]
  [nswindow-field-editor-for-object (c-> objc-object? boolean? any/c any/c)]
  [nswindow-flags-changed (c-> objc-object? any/c void?)]
  [nswindow-flush-buffered-key-events (c-> objc-object? void?)]
  [nswindow-frame-rect-for-content-rect (c-> objc-object? any/c any/c)]
  [nswindow-help-requested (c-> objc-object? any/c void?)]
  [nswindow-insert-titlebar-accessory-view-controller-at-index! (c-> objc-object? any/c exact-integer? void?)]
  [nswindow-interpret-key-events (c-> objc-object? any/c void?)]
  [nswindow-invalidate-shadow (c-> objc-object? void?)]
  [nswindow-is-document-edited (c-> objc-object? boolean?)]
  [nswindow-is-excluded-from-windows-menu (c-> objc-object? boolean?)]
  [nswindow-is-key-window (c-> objc-object? boolean?)]
  [nswindow-is-main-window (c-> objc-object? boolean?)]
  [nswindow-is-miniaturized (c-> objc-object? boolean?)]
  [nswindow-is-movable (c-> objc-object? boolean?)]
  [nswindow-is-movable-by-window-background (c-> objc-object? boolean?)]
  [nswindow-is-on-active-space (c-> objc-object? boolean?)]
  [nswindow-is-opaque (c-> objc-object? boolean?)]
  [nswindow-is-released-when-closed (c-> objc-object? boolean?)]
  [nswindow-is-sheet (c-> objc-object? boolean?)]
  [nswindow-is-visible (c-> objc-object? boolean?)]
  [nswindow-is-zoomed (c-> objc-object? boolean?)]
  [nswindow-key-down (c-> objc-object? any/c void?)]
  [nswindow-key-up (c-> objc-object? any/c void?)]
  [nswindow-magnify-with-event (c-> objc-object? any/c void?)]
  [nswindow-make-first-responder (c-> objc-object? any/c boolean?)]
  [nswindow-make-key-and-order-front (c-> objc-object? any/c void?)]
  [nswindow-make-key-window (c-> objc-object? void?)]
  [nswindow-make-main-window (c-> objc-object? void?)]
  [nswindow-merge-all-windows (c-> objc-object? any/c void?)]
  [nswindow-miniaturize (c-> objc-object? any/c void?)]
  [nswindow-mouse-cancelled (c-> objc-object? any/c void?)]
  [nswindow-mouse-down (c-> objc-object? any/c void?)]
  [nswindow-mouse-dragged (c-> objc-object? any/c void?)]
  [nswindow-mouse-entered (c-> objc-object? any/c void?)]
  [nswindow-mouse-exited (c-> objc-object? any/c void?)]
  [nswindow-mouse-moved (c-> objc-object? any/c void?)]
  [nswindow-mouse-up (c-> objc-object? any/c void?)]
  [nswindow-move-tab-to-new-window! (c-> objc-object? any/c void?)]
  [nswindow-no-responder-for (c-> objc-object? cpointer? void?)]
  [nswindow-order-back! (c-> objc-object? any/c void?)]
  [nswindow-order-front! (c-> objc-object? any/c void?)]
  [nswindow-order-front-regardless! (c-> objc-object? void?)]
  [nswindow-order-out! (c-> objc-object? any/c void?)]
  [nswindow-order-window-relative-to! (c-> objc-object? exact-nonnegative-integer? exact-integer? void?)]
  [nswindow-other-mouse-down (c-> objc-object? any/c void?)]
  [nswindow-other-mouse-dragged (c-> objc-object? any/c void?)]
  [nswindow-other-mouse-up (c-> objc-object? any/c void?)]
  [nswindow-perform-close! (c-> objc-object? any/c void?)]
  [nswindow-perform-key-equivalent! (c-> objc-object? any/c boolean?)]
  [nswindow-perform-miniaturize! (c-> objc-object? any/c void?)]
  [nswindow-perform-window-drag-with-event! (c-> objc-object? any/c void?)]
  [nswindow-perform-zoom! (c-> objc-object? any/c void?)]
  [nswindow-pressure-change-with-event (c-> objc-object? any/c void?)]
  [nswindow-print (c-> objc-object? any/c void?)]
  [nswindow-quick-look-with-event (c-> objc-object? any/c void?)]
  [nswindow-recalculate-key-view-loop (c-> objc-object? void?)]
  [nswindow-remove-child-window! (c-> objc-object? any/c void?)]
  [nswindow-remove-titlebar-accessory-view-controller-at-index! (c-> objc-object? exact-integer? void?)]
  [nswindow-request-sharing-of-window-completion-handler (c-> objc-object? any/c (or/c procedure? #f) void?)]
  [nswindow-request-sharing-of-window-using-preview-title-completion-handler (c-> objc-object? any/c any/c (or/c procedure? #f) void?)]
  [nswindow-resign-first-responder (c-> objc-object? boolean?)]
  [nswindow-resign-key-window (c-> objc-object? void?)]
  [nswindow-resign-main-window (c-> objc-object? void?)]
  [nswindow-right-mouse-down (c-> objc-object? any/c void?)]
  [nswindow-right-mouse-dragged (c-> objc-object? any/c void?)]
  [nswindow-right-mouse-up (c-> objc-object? any/c void?)]
  [nswindow-rotate-with-event (c-> objc-object? any/c void?)]
  [nswindow-run-toolbar-customization-palette (c-> objc-object? any/c void?)]
  [nswindow-save-frame-using-name (c-> objc-object? any/c void?)]
  [nswindow-scroll-wheel (c-> objc-object? any/c void?)]
  [nswindow-select-key-view-following-view (c-> objc-object? any/c void?)]
  [nswindow-select-key-view-preceding-view (c-> objc-object? any/c void?)]
  [nswindow-select-next-key-view (c-> objc-object? any/c void?)]
  [nswindow-select-next-tab (c-> objc-object? any/c void?)]
  [nswindow-select-previous-key-view (c-> objc-object? any/c void?)]
  [nswindow-select-previous-tab (c-> objc-object? any/c void?)]
  [nswindow-set-autorecalculates-content-border-thickness-for-edge! (c-> objc-object? boolean? exact-nonnegative-integer? void?)]
  [nswindow-set-content-border-thickness-for-edge! (c-> objc-object? real? exact-nonnegative-integer? void?)]
  [nswindow-set-content-size! (c-> objc-object? any/c void?)]
  [nswindow-set-dynamic-depth-limit! (c-> objc-object? boolean? void?)]
  [nswindow-set-frame-display! (c-> objc-object? any/c boolean? void?)]
  [nswindow-set-frame-display-animate! (c-> objc-object? any/c boolean? boolean? void?)]
  [nswindow-set-frame-autosave-name! (c-> objc-object? any/c boolean?)]
  [nswindow-set-frame-from-string! (c-> objc-object? any/c void?)]
  [nswindow-set-frame-origin! (c-> objc-object? any/c void?)]
  [nswindow-set-frame-top-left-point! (c-> objc-object? any/c void?)]
  [nswindow-set-frame-using-name! (c-> objc-object? any/c boolean?)]
  [nswindow-set-frame-using-name-force! (c-> objc-object? any/c boolean? boolean?)]
  [nswindow-set-title-with-represented-filename! (c-> objc-object? any/c void?)]
  [nswindow-should-be-treated-as-ink-event (c-> objc-object? any/c boolean?)]
  [nswindow-show-context-help (c-> objc-object? any/c void?)]
  [nswindow-smart-magnify-with-event (c-> objc-object? any/c void?)]
  [nswindow-standard-window-button (c-> objc-object? exact-nonnegative-integer? any/c)]
  [nswindow-supplemental-target-for-action-sender (c-> objc-object? cpointer? any/c any/c)]
  [nswindow-swipe-with-event (c-> objc-object? any/c void?)]
  [nswindow-tablet-point (c-> objc-object? any/c void?)]
  [nswindow-tablet-proximity (c-> objc-object? any/c void?)]
  [nswindow-toggle-full-screen! (c-> objc-object? any/c void?)]
  [nswindow-toggle-tab-bar! (c-> objc-object? any/c void?)]
  [nswindow-toggle-tab-overview! (c-> objc-object? any/c void?)]
  [nswindow-toggle-toolbar-shown! (c-> objc-object? any/c void?)]
  [nswindow-touches-began-with-event (c-> objc-object? any/c void?)]
  [nswindow-touches-cancelled-with-event (c-> objc-object? any/c void?)]
  [nswindow-touches-ended-with-event (c-> objc-object? any/c void?)]
  [nswindow-touches-moved-with-event (c-> objc-object? any/c void?)]
  [nswindow-transfer-window-sharing-to-window-completion-handler (c-> objc-object? any/c (or/c procedure? #f) void?)]
  [nswindow-try-to-perform-with (c-> objc-object? cpointer? any/c boolean?)]
  [nswindow-update (c-> objc-object? void?)]
  [nswindow-valid-requestor-for-send-type-return-type (c-> objc-object? any/c any/c any/c)]
  [nswindow-wants-forwarded-scroll-events-for-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nswindow-wants-scroll-events-for-swipe-tracking-on-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nswindow-zoom (c-> objc-object? any/c void?)]
  [nswindow-content-rect-for-frame-rect-style-mask (c-> any/c exact-nonnegative-integer? any/c)]
  [nswindow-frame-rect-for-content-rect-style-mask (c-> any/c exact-nonnegative-integer? any/c)]
  [nswindow-min-frame-width-with-title-style-mask (c-> any/c exact-nonnegative-integer? real?)]
  [nswindow-remove-frame-using-name! (c-> any/c void?)]
  [nswindow-standard-window-button-for-style-mask (c-> exact-nonnegative-integer? exact-nonnegative-integer? any/c)]
  [nswindow-window-number-at-point-below-window-with-window-number (c-> any/c exact-integer? exact-integer?)]
  [nswindow-window-numbers-with-options (c-> exact-nonnegative-integer? any/c)]
  [nswindow-window-with-content-view-controller (c-> any/c any/c)]
  )

;; --- Class reference ---
(import-class NSWindow)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _NSRect)))
(define _msg-1  ; (_fun _pointer _pointer -> _NSSize)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _NSSize)))
(define _msg-2  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-3  ; (_fun _pointer _pointer -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _double)))
(define _msg-4  ; (_fun _pointer _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _int64)))
(define _msg-5  ; (_fun _pointer _pointer -> _uint64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _uint64)))
(define _msg-6  ; (_fun _pointer _pointer _NSPoint -> _NSPoint)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _NSPoint)))
(define _msg-7  ; (_fun _pointer _pointer _NSPoint -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _void)))
(define _msg-8  ; (_fun _pointer _pointer _NSPoint _int64 -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _int64 -> _int64)))
(define _msg-9  ; (_fun _pointer _pointer _NSRect -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _NSRect)))
(define _msg-10  ; (_fun _pointer _pointer _NSRect -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _double)))
(define _msg-11  ; (_fun _pointer _pointer _NSRect -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _id)))
(define _msg-12  ; (_fun _pointer _pointer _NSRect _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _bool -> _void)))
(define _msg-13  ; (_fun _pointer _pointer _NSRect _bool _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _bool _bool -> _void)))
(define _msg-14  ; (_fun _pointer _pointer _NSRect _id -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id -> _NSRect)))
(define _msg-15  ; (_fun _pointer _pointer _NSRect _uint64 -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _uint64 -> _NSRect)))
(define _msg-16  ; (_fun _pointer _pointer _NSRect _uint64 _uint64 _bool -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _uint64 _uint64 _bool -> _id)))
(define _msg-17  ; (_fun _pointer _pointer _NSRect _uint64 _uint64 _bool _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _uint64 _uint64 _bool _id -> _id)))
(define _msg-18  ; (_fun _pointer _pointer _NSSize -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize -> _void)))
(define _msg-19  ; (_fun _pointer _pointer _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool -> _void)))
(define _msg-20  ; (_fun _pointer _pointer _bool _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool _id -> _id)))
(define _msg-21  ; (_fun _pointer _pointer _bool _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool _uint64 -> _void)))
(define _msg-22  ; (_fun _pointer _pointer _double -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double -> _void)))
(define _msg-23  ; (_fun _pointer _pointer _double _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double _uint64 -> _void)))
(define _msg-24  ; (_fun _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _bool)))
(define _msg-25  ; (_fun _pointer _pointer _id _bool -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _bool -> _bool)))
(define _msg-26  ; (_fun _pointer _pointer _id _id _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _id _pointer -> _void)))
(define _msg-27  ; (_fun _pointer _pointer _id _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _int64 -> _void)))
(define _msg-28  ; (_fun _pointer _pointer _id _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _pointer -> _void)))
(define _msg-29  ; (_fun _pointer _pointer _id _uint64 -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _uint64 -> _double)))
(define _msg-30  ; (_fun _pointer _pointer _id _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _uint64 -> _void)))
(define _msg-31  ; (_fun _pointer _pointer _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _void)))
(define _msg-32  ; (_fun _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))
(define _msg-33  ; (_fun _pointer _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _bool)))
(define _msg-34  ; (_fun _pointer _pointer _pointer _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _id)))
(define _msg-35  ; (_fun _pointer _pointer _uint64 -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _bool)))
(define _msg-36  ; (_fun _pointer _pointer _uint64 -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _double)))
(define _msg-37  ; (_fun _pointer _pointer _uint64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _id)))
(define _msg-38  ; (_fun _pointer _pointer _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _void)))
(define _msg-39  ; (_fun _pointer _pointer _uint64 _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 _int64 -> _void)))
(define _msg-40  ; (_fun _pointer _pointer _uint64 _uint64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 _uint64 -> _id)))

;; --- Constructors ---
(define (make-nswindow-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSWindow alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))

(define (make-nswindow-init-with-content-rect-style-mask-backing-defer content-rect style backing-store-type flag)
  (wrap-objc-object
   (_msg-16 (tell NSWindow alloc)
       (sel_registerName "initWithContentRect:styleMask:backing:defer:")
       content-rect
       style
       backing-store-type
       flag)
   #:retained #t))

(define (make-nswindow-init-with-content-rect-style-mask-backing-defer-screen content-rect style backing-store-type flag screen)
  (wrap-objc-object
   (_msg-17 (tell NSWindow alloc)
       (sel_registerName "initWithContentRect:styleMask:backing:defer:screen:")
       content-rect
       style
       backing-store-type
       flag
       (coerce-arg screen))
   #:retained #t))


;; --- Properties ---
(define (nswindow-accepts-first-responder self)
  (tell #:type _bool (coerce-arg self) acceptsFirstResponder))
(define (nswindow-accepts-mouse-moved-events self)
  (tell #:type _bool (coerce-arg self) acceptsMouseMovedEvents))
(define (nswindow-set-accepts-mouse-moved-events! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setAcceptsMouseMovedEvents:") value))
(define (nswindow-allows-automatic-window-tabbing)
  (tell #:type _bool NSWindow allowsAutomaticWindowTabbing))
(define (nswindow-set-allows-automatic-window-tabbing! value)
  (_msg-19 NSWindow (sel_registerName "setAllowsAutomaticWindowTabbing:") value))
(define (nswindow-allows-concurrent-view-drawing self)
  (tell #:type _bool (coerce-arg self) allowsConcurrentViewDrawing))
(define (nswindow-set-allows-concurrent-view-drawing! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setAllowsConcurrentViewDrawing:") value))
(define (nswindow-allows-tool-tips-when-application-is-inactive self)
  (tell #:type _bool (coerce-arg self) allowsToolTipsWhenApplicationIsInactive))
(define (nswindow-set-allows-tool-tips-when-application-is-inactive! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setAllowsToolTipsWhenApplicationIsInactive:") value))
(define (nswindow-alpha-value self)
  (tell #:type _double (coerce-arg self) alphaValue))
(define (nswindow-set-alpha-value! self value)
  (_msg-22 (coerce-arg self) (sel_registerName "setAlphaValue:") value))
(define (nswindow-animation-behavior self)
  (tell #:type _uint64 (coerce-arg self) animationBehavior))
(define (nswindow-set-animation-behavior! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setAnimationBehavior:") value))
(define (nswindow-appearance-source self)
  (wrap-objc-object
   (tell (coerce-arg self) appearanceSource)))
(define (nswindow-set-appearance-source! self value)
  (tell #:type _void (coerce-arg self) setAppearanceSource: (coerce-arg value)))
(define (nswindow-are-cursor-rects-enabled self)
  (tell #:type _bool (coerce-arg self) areCursorRectsEnabled))
(define (nswindow-aspect-ratio self)
  (tell #:type _NSSize (coerce-arg self) aspectRatio))
(define (nswindow-set-aspect-ratio! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setAspectRatio:") value))
(define (nswindow-attached-sheet self)
  (wrap-objc-object
   (tell (coerce-arg self) attachedSheet)))
(define (nswindow-autodisplay self)
  (tell #:type _bool (coerce-arg self) autodisplay))
(define (nswindow-set-autodisplay! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setAutodisplay:") value))
(define (nswindow-autorecalculates-key-view-loop self)
  (tell #:type _bool (coerce-arg self) autorecalculatesKeyViewLoop))
(define (nswindow-set-autorecalculates-key-view-loop! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setAutorecalculatesKeyViewLoop:") value))
(define (nswindow-background-color self)
  (wrap-objc-object
   (tell (coerce-arg self) backgroundColor)))
(define (nswindow-set-background-color! self value)
  (tell #:type _void (coerce-arg self) setBackgroundColor: (coerce-arg value)))
(define (nswindow-backing-location self)
  (tell #:type _uint64 (coerce-arg self) backingLocation))
(define (nswindow-backing-scale-factor self)
  (tell #:type _double (coerce-arg self) backingScaleFactor))
(define (nswindow-backing-type self)
  (tell #:type _uint64 (coerce-arg self) backingType))
(define (nswindow-set-backing-type! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setBackingType:") value))
(define (nswindow-can-become-key-window self)
  (tell #:type _bool (coerce-arg self) canBecomeKeyWindow))
(define (nswindow-can-become-main-window self)
  (tell #:type _bool (coerce-arg self) canBecomeMainWindow))
(define (nswindow-can-become-visible-without-login self)
  (tell #:type _bool (coerce-arg self) canBecomeVisibleWithoutLogin))
(define (nswindow-set-can-become-visible-without-login! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setCanBecomeVisibleWithoutLogin:") value))
(define (nswindow-can-hide self)
  (tell #:type _bool (coerce-arg self) canHide))
(define (nswindow-set-can-hide! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setCanHide:") value))
(define (nswindow-cascading-reference-frame self)
  (tell #:type _NSRect (coerce-arg self) cascadingReferenceFrame))
(define (nswindow-child-windows self)
  (wrap-objc-object
   (tell (coerce-arg self) childWindows)))
(define (nswindow-collection-behavior self)
  (tell #:type _uint64 (coerce-arg self) collectionBehavior))
(define (nswindow-set-collection-behavior! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setCollectionBehavior:") value))
(define (nswindow-color-space self)
  (wrap-objc-object
   (tell (coerce-arg self) colorSpace)))
(define (nswindow-set-color-space! self value)
  (tell #:type _void (coerce-arg self) setColorSpace: (coerce-arg value)))
(define (nswindow-content-aspect-ratio self)
  (tell #:type _NSSize (coerce-arg self) contentAspectRatio))
(define (nswindow-set-content-aspect-ratio! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setContentAspectRatio:") value))
(define (nswindow-content-layout-guide self)
  (wrap-objc-object
   (tell (coerce-arg self) contentLayoutGuide)))
(define (nswindow-content-layout-rect self)
  (tell #:type _NSRect (coerce-arg self) contentLayoutRect))
(define (nswindow-content-max-size self)
  (tell #:type _NSSize (coerce-arg self) contentMaxSize))
(define (nswindow-set-content-max-size! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setContentMaxSize:") value))
(define (nswindow-content-min-size self)
  (tell #:type _NSSize (coerce-arg self) contentMinSize))
(define (nswindow-set-content-min-size! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setContentMinSize:") value))
(define (nswindow-content-resize-increments self)
  (tell #:type _NSSize (coerce-arg self) contentResizeIncrements))
(define (nswindow-set-content-resize-increments! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setContentResizeIncrements:") value))
(define (nswindow-content-view self)
  (wrap-objc-object
   (tell (coerce-arg self) contentView)))
(define (nswindow-set-content-view! self value)
  (tell #:type _void (coerce-arg self) setContentView: (coerce-arg value)))
(define (nswindow-content-view-controller self)
  (wrap-objc-object
   (tell (coerce-arg self) contentViewController)))
(define (nswindow-set-content-view-controller! self value)
  (tell #:type _void (coerce-arg self) setContentViewController: (coerce-arg value)))
(define (nswindow-current-event self)
  (wrap-objc-object
   (tell (coerce-arg self) currentEvent)))
(define (nswindow-deepest-screen self)
  (wrap-objc-object
   (tell (coerce-arg self) deepestScreen)))
(define (nswindow-default-button-cell self)
  (wrap-objc-object
   (tell (coerce-arg self) defaultButtonCell)))
(define (nswindow-set-default-button-cell! self value)
  (tell #:type _void (coerce-arg self) setDefaultButtonCell: (coerce-arg value)))
(define (nswindow-default-depth-limit)
  (tell #:type _uint64 NSWindow defaultDepthLimit))
(define (nswindow-delegate self)
  (wrap-objc-object
   (tell (coerce-arg self) delegate)))
(define (nswindow-set-delegate! self value)
  (tell #:type _void (coerce-arg self) setDelegate: (coerce-arg value)))
(define (nswindow-depth-limit self)
  (tell #:type _uint64 (coerce-arg self) depthLimit))
(define (nswindow-set-depth-limit! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setDepthLimit:") value))
(define (nswindow-device-description self)
  (wrap-objc-object
   (tell (coerce-arg self) deviceDescription)))
(define (nswindow-displays-when-screen-profile-changes self)
  (tell #:type _bool (coerce-arg self) displaysWhenScreenProfileChanges))
(define (nswindow-set-displays-when-screen-profile-changes! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setDisplaysWhenScreenProfileChanges:") value))
(define (nswindow-dock-tile self)
  (wrap-objc-object
   (tell (coerce-arg self) dockTile)))
(define (nswindow-document-edited self)
  (tell #:type _bool (coerce-arg self) documentEdited))
(define (nswindow-set-document-edited! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setDocumentEdited:") value))
(define (nswindow-drawers self)
  (wrap-objc-object
   (tell (coerce-arg self) drawers)))
(define (nswindow-excluded-from-windows-menu self)
  (tell #:type _bool (coerce-arg self) excludedFromWindowsMenu))
(define (nswindow-set-excluded-from-windows-menu! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setExcludedFromWindowsMenu:") value))
(define (nswindow-first-responder self)
  (wrap-objc-object
   (tell (coerce-arg self) firstResponder)))
(define (nswindow-floating-panel self)
  (tell #:type _bool (coerce-arg self) floatingPanel))
(define (nswindow-flush-window-disabled self)
  (tell #:type _bool (coerce-arg self) flushWindowDisabled))
(define (nswindow-frame self)
  (tell #:type _NSRect (coerce-arg self) frame))
(define (nswindow-frame-autosave-name self)
  (wrap-objc-object
   (tell (coerce-arg self) frameAutosaveName)))
(define (nswindow-graphics-context self)
  (wrap-objc-object
   (tell (coerce-arg self) graphicsContext)))
(define (nswindow-has-active-window-sharing-session self)
  (tell #:type _bool (coerce-arg self) hasActiveWindowSharingSession))
(define (nswindow-has-close-box self)
  (tell #:type _bool (coerce-arg self) hasCloseBox))
(define (nswindow-has-dynamic-depth-limit self)
  (tell #:type _bool (coerce-arg self) hasDynamicDepthLimit))
(define (nswindow-has-shadow self)
  (tell #:type _bool (coerce-arg self) hasShadow))
(define (nswindow-set-has-shadow! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setHasShadow:") value))
(define (nswindow-has-title-bar self)
  (tell #:type _bool (coerce-arg self) hasTitleBar))
(define (nswindow-hides-on-deactivate self)
  (tell #:type _bool (coerce-arg self) hidesOnDeactivate))
(define (nswindow-set-hides-on-deactivate! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setHidesOnDeactivate:") value))
(define (nswindow-ignores-mouse-events self)
  (tell #:type _bool (coerce-arg self) ignoresMouseEvents))
(define (nswindow-set-ignores-mouse-events! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setIgnoresMouseEvents:") value))
(define (nswindow-in-live-resize self)
  (tell #:type _bool (coerce-arg self) inLiveResize))
(define (nswindow-initial-first-responder self)
  (wrap-objc-object
   (tell (coerce-arg self) initialFirstResponder)))
(define (nswindow-set-initial-first-responder! self value)
  (tell #:type _void (coerce-arg self) setInitialFirstResponder: (coerce-arg value)))
(define (nswindow-key-view-selection-direction self)
  (tell #:type _uint64 (coerce-arg self) keyViewSelectionDirection))
(define (nswindow-key-window self)
  (tell #:type _bool (coerce-arg self) keyWindow))
(define (nswindow-level self)
  (tell #:type _int64 (coerce-arg self) level))
(define (nswindow-set-level! self value)
  (_msg-31 (coerce-arg self) (sel_registerName "setLevel:") value))
(define (nswindow-main-window self)
  (tell #:type _bool (coerce-arg self) mainWindow))
(define (nswindow-max-full-screen-content-size self)
  (tell #:type _NSSize (coerce-arg self) maxFullScreenContentSize))
(define (nswindow-set-max-full-screen-content-size! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setMaxFullScreenContentSize:") value))
(define (nswindow-max-size self)
  (tell #:type _NSSize (coerce-arg self) maxSize))
(define (nswindow-set-max-size! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setMaxSize:") value))
(define (nswindow-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) menu)))
(define (nswindow-set-menu! self value)
  (tell #:type _void (coerce-arg self) setMenu: (coerce-arg value)))
(define (nswindow-min-full-screen-content-size self)
  (tell #:type _NSSize (coerce-arg self) minFullScreenContentSize))
(define (nswindow-set-min-full-screen-content-size! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setMinFullScreenContentSize:") value))
(define (nswindow-min-size self)
  (tell #:type _NSSize (coerce-arg self) minSize))
(define (nswindow-set-min-size! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setMinSize:") value))
(define (nswindow-miniaturizable self)
  (tell #:type _bool (coerce-arg self) miniaturizable))
(define (nswindow-miniaturized self)
  (tell #:type _bool (coerce-arg self) miniaturized))
(define (nswindow-miniwindow-image self)
  (wrap-objc-object
   (tell (coerce-arg self) miniwindowImage)))
(define (nswindow-set-miniwindow-image! self value)
  (tell #:type _void (coerce-arg self) setMiniwindowImage: (coerce-arg value)))
(define (nswindow-miniwindow-title self)
  (wrap-objc-object
   (tell (coerce-arg self) miniwindowTitle)))
(define (nswindow-set-miniwindow-title! self value)
  (tell #:type _void (coerce-arg self) setMiniwindowTitle: (coerce-arg value)))
(define (nswindow-modal-panel self)
  (tell #:type _bool (coerce-arg self) modalPanel))
(define (nswindow-mouse-location-outside-of-event-stream self)
  (tell #:type _NSPoint (coerce-arg self) mouseLocationOutsideOfEventStream))
(define (nswindow-movable self)
  (tell #:type _bool (coerce-arg self) movable))
(define (nswindow-set-movable! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setMovable:") value))
(define (nswindow-movable-by-window-background self)
  (tell #:type _bool (coerce-arg self) movableByWindowBackground))
(define (nswindow-set-movable-by-window-background! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setMovableByWindowBackground:") value))
(define (nswindow-next-responder self)
  (wrap-objc-object
   (tell (coerce-arg self) nextResponder)))
(define (nswindow-set-next-responder! self value)
  (tell #:type _void (coerce-arg self) setNextResponder: (coerce-arg value)))
(define (nswindow-occlusion-state self)
  (tell #:type _uint64 (coerce-arg self) occlusionState))
(define (nswindow-on-active-space self)
  (tell #:type _bool (coerce-arg self) onActiveSpace))
(define (nswindow-one-shot self)
  (tell #:type _bool (coerce-arg self) oneShot))
(define (nswindow-set-one-shot! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setOneShot:") value))
(define (nswindow-opaque self)
  (tell #:type _bool (coerce-arg self) opaque))
(define (nswindow-set-opaque! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setOpaque:") value))
(define (nswindow-ordered-index self)
  (tell #:type _int64 (coerce-arg self) orderedIndex))
(define (nswindow-set-ordered-index! self value)
  (_msg-31 (coerce-arg self) (sel_registerName "setOrderedIndex:") value))
(define (nswindow-parent-window self)
  (wrap-objc-object
   (tell (coerce-arg self) parentWindow)))
(define (nswindow-set-parent-window! self value)
  (tell #:type _void (coerce-arg self) setParentWindow: (coerce-arg value)))
(define (nswindow-preferred-backing-location self)
  (tell #:type _uint64 (coerce-arg self) preferredBackingLocation))
(define (nswindow-set-preferred-backing-location! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setPreferredBackingLocation:") value))
(define (nswindow-preserves-content-during-live-resize self)
  (tell #:type _bool (coerce-arg self) preservesContentDuringLiveResize))
(define (nswindow-set-preserves-content-during-live-resize! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setPreservesContentDuringLiveResize:") value))
(define (nswindow-prevents-application-termination-when-modal self)
  (tell #:type _bool (coerce-arg self) preventsApplicationTerminationWhenModal))
(define (nswindow-set-prevents-application-termination-when-modal! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setPreventsApplicationTerminationWhenModal:") value))
(define (nswindow-released-when-closed self)
  (tell #:type _bool (coerce-arg self) releasedWhenClosed))
(define (nswindow-set-released-when-closed! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setReleasedWhenClosed:") value))
(define (nswindow-represented-filename self)
  (wrap-objc-object
   (tell (coerce-arg self) representedFilename)))
(define (nswindow-set-represented-filename! self value)
  (tell #:type _void (coerce-arg self) setRepresentedFilename: (coerce-arg value)))
(define (nswindow-represented-url self)
  (wrap-objc-object
   (tell (coerce-arg self) representedURL)))
(define (nswindow-set-represented-url! self value)
  (tell #:type _void (coerce-arg self) setRepresentedURL: (coerce-arg value)))
(define (nswindow-resizable self)
  (tell #:type _bool (coerce-arg self) resizable))
(define (nswindow-resize-flags self)
  (tell #:type _uint64 (coerce-arg self) resizeFlags))
(define (nswindow-resize-increments self)
  (tell #:type _NSSize (coerce-arg self) resizeIncrements))
(define (nswindow-set-resize-increments! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setResizeIncrements:") value))
(define (nswindow-restorable self)
  (tell #:type _bool (coerce-arg self) restorable))
(define (nswindow-set-restorable! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setRestorable:") value))
(define (nswindow-restorable-state-key-paths)
  (wrap-objc-object
   (tell NSWindow restorableStateKeyPaths)))
(define (nswindow-restoration-class self)
  (wrap-objc-object
   (tell (coerce-arg self) restorationClass)))
(define (nswindow-set-restoration-class! self value)
  (tell #:type _void (coerce-arg self) setRestorationClass: (coerce-arg value)))
(define (nswindow-screen self)
  (wrap-objc-object
   (tell (coerce-arg self) screen)))
(define (nswindow-sharing-type self)
  (tell #:type _uint64 (coerce-arg self) sharingType))
(define (nswindow-set-sharing-type! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setSharingType:") value))
(define (nswindow-sheet self)
  (tell #:type _bool (coerce-arg self) sheet))
(define (nswindow-sheet-parent self)
  (wrap-objc-object
   (tell (coerce-arg self) sheetParent)))
(define (nswindow-sheets self)
  (wrap-objc-object
   (tell (coerce-arg self) sheets)))
(define (nswindow-shows-resize-indicator self)
  (tell #:type _bool (coerce-arg self) showsResizeIndicator))
(define (nswindow-set-shows-resize-indicator! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setShowsResizeIndicator:") value))
(define (nswindow-shows-toolbar-button self)
  (tell #:type _bool (coerce-arg self) showsToolbarButton))
(define (nswindow-set-shows-toolbar-button! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setShowsToolbarButton:") value))
(define (nswindow-string-with-saved-frame self)
  (wrap-objc-object
   (tell (coerce-arg self) stringWithSavedFrame)))
(define (nswindow-style-mask self)
  (tell #:type _uint64 (coerce-arg self) styleMask))
(define (nswindow-set-style-mask! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setStyleMask:") value))
(define (nswindow-subtitle self)
  (wrap-objc-object
   (tell (coerce-arg self) subtitle)))
(define (nswindow-set-subtitle! self value)
  (tell #:type _void (coerce-arg self) setSubtitle: (coerce-arg value)))
(define (nswindow-tab self)
  (wrap-objc-object
   (tell (coerce-arg self) tab)))
(define (nswindow-tab-group self)
  (wrap-objc-object
   (tell (coerce-arg self) tabGroup)))
(define (nswindow-tabbed-windows self)
  (wrap-objc-object
   (tell (coerce-arg self) tabbedWindows)))
(define (nswindow-tabbing-identifier self)
  (wrap-objc-object
   (tell (coerce-arg self) tabbingIdentifier)))
(define (nswindow-set-tabbing-identifier! self value)
  (tell #:type _void (coerce-arg self) setTabbingIdentifier: (coerce-arg value)))
(define (nswindow-tabbing-mode self)
  (tell #:type _uint64 (coerce-arg self) tabbingMode))
(define (nswindow-set-tabbing-mode! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setTabbingMode:") value))
(define (nswindow-title self)
  (wrap-objc-object
   (tell (coerce-arg self) title)))
(define (nswindow-set-title! self value)
  (tell #:type _void (coerce-arg self) setTitle: (coerce-arg value)))
(define (nswindow-title-visibility self)
  (tell #:type _uint64 (coerce-arg self) titleVisibility))
(define (nswindow-set-title-visibility! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setTitleVisibility:") value))
(define (nswindow-titlebar-accessory-view-controllers self)
  (wrap-objc-object
   (tell (coerce-arg self) titlebarAccessoryViewControllers)))
(define (nswindow-set-titlebar-accessory-view-controllers! self value)
  (tell #:type _void (coerce-arg self) setTitlebarAccessoryViewControllers: (coerce-arg value)))
(define (nswindow-titlebar-appears-transparent self)
  (tell #:type _bool (coerce-arg self) titlebarAppearsTransparent))
(define (nswindow-set-titlebar-appears-transparent! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setTitlebarAppearsTransparent:") value))
(define (nswindow-titlebar-separator-style self)
  (tell #:type _uint64 (coerce-arg self) titlebarSeparatorStyle))
(define (nswindow-set-titlebar-separator-style! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setTitlebarSeparatorStyle:") value))
(define (nswindow-toolbar self)
  (wrap-objc-object
   (tell (coerce-arg self) toolbar)))
(define (nswindow-set-toolbar! self value)
  (tell #:type _void (coerce-arg self) setToolbar: (coerce-arg value)))
(define (nswindow-toolbar-style self)
  (tell #:type _uint64 (coerce-arg self) toolbarStyle))
(define (nswindow-set-toolbar-style! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setToolbarStyle:") value))
(define (nswindow-touch-bar self)
  (wrap-objc-object
   (tell (coerce-arg self) touchBar)))
(define (nswindow-set-touch-bar! self value)
  (tell #:type _void (coerce-arg self) setTouchBar: (coerce-arg value)))
(define (nswindow-undo-manager self)
  (wrap-objc-object
   (tell (coerce-arg self) undoManager)))
(define (nswindow-user-activity self)
  (wrap-objc-object
   (tell (coerce-arg self) userActivity)))
(define (nswindow-set-user-activity! self value)
  (tell #:type _void (coerce-arg self) setUserActivity: (coerce-arg value)))
(define (nswindow-user-tabbing-preference)
  (tell #:type _uint64 NSWindow userTabbingPreference))
(define (nswindow-views-need-display self)
  (tell #:type _bool (coerce-arg self) viewsNeedDisplay))
(define (nswindow-set-views-need-display! self value)
  (_msg-19 (coerce-arg self) (sel_registerName "setViewsNeedDisplay:") value))
(define (nswindow-visible self)
  (tell #:type _bool (coerce-arg self) visible))
(define (nswindow-window-controller self)
  (wrap-objc-object
   (tell (coerce-arg self) windowController)))
(define (nswindow-set-window-controller! self value)
  (tell #:type _void (coerce-arg self) setWindowController: (coerce-arg value)))
(define (nswindow-window-number self)
  (tell #:type _int64 (coerce-arg self) windowNumber))
(define (nswindow-window-ref self)
  (tell #:type _pointer (coerce-arg self) windowRef))
(define (nswindow-window-titlebar-layout-direction self)
  (tell #:type _uint64 (coerce-arg self) windowTitlebarLayoutDirection))
(define (nswindow-works-when-modal self)
  (tell #:type _bool (coerce-arg self) worksWhenModal))
(define (nswindow-zoomable self)
  (tell #:type _bool (coerce-arg self) zoomable))
(define (nswindow-zoomed self)
  (tell #:type _bool (coerce-arg self) zoomed))

;; --- Instance methods ---
(define (nswindow-add-child-window-ordered! self child-win place)
  (_msg-30 (coerce-arg self) (sel_registerName "addChildWindow:ordered:") (coerce-arg child-win) place))
(define (nswindow-add-tabbed-window-ordered! self window ordered)
  (_msg-30 (coerce-arg self) (sel_registerName "addTabbedWindow:ordered:") (coerce-arg window) ordered))
(define (nswindow-add-titlebar-accessory-view-controller! self child-view-controller)
  (tell #:type _void (coerce-arg self) addTitlebarAccessoryViewController: (coerce-arg child-view-controller)))
(define (nswindow-animation-resize-time self new-frame)
  (_msg-10 (coerce-arg self) (sel_registerName "animationResizeTime:") new-frame))
(define (nswindow-autorecalculates-content-border-thickness-for-edge self edge)
  (_msg-35 (coerce-arg self) (sel_registerName "autorecalculatesContentBorderThicknessForEdge:") edge))
(define (nswindow-backing-aligned-rect-options self rect options)
  (_msg-15 (coerce-arg self) (sel_registerName "backingAlignedRect:options:") rect options))
(define (nswindow-become-first-responder self)
  (_msg-2 (coerce-arg self) (sel_registerName "becomeFirstResponder")))
(define (nswindow-become-key-window self)
  (tell #:type _void (coerce-arg self) becomeKeyWindow))
(define (nswindow-become-main-window self)
  (tell #:type _void (coerce-arg self) becomeMainWindow))
(define (nswindow-begin-critical-sheet-completion-handler! self sheet-window handler)
  (define-values (_blk1 _blk1-id)
    (make-objc-block handler (list _int64) _void))
  (_msg-28 (coerce-arg self) (sel_registerName "beginCriticalSheet:completionHandler:") (coerce-arg sheet-window) _blk1))
(define (nswindow-begin-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) beginGestureWithEvent: (coerce-arg event)))
(define (nswindow-begin-sheet-completion-handler! self sheet-window handler)
  (define-values (_blk1 _blk1-id)
    (make-objc-block handler (list _int64) _void))
  (_msg-28 (coerce-arg self) (sel_registerName "beginSheet:completionHandler:") (coerce-arg sheet-window) _blk1))
(define (nswindow-can-represent-display-gamut self display-gamut)
  (_msg-35 (coerce-arg self) (sel_registerName "canRepresentDisplayGamut:") display-gamut))
(define (nswindow-cascade-top-left-from-point self top-left-point)
  (_msg-6 (coerce-arg self) (sel_registerName "cascadeTopLeftFromPoint:") top-left-point))
(define (nswindow-center! self)
  (tell #:type _void (coerce-arg self) center))
(define (nswindow-change-mode-with-event self event)
  (tell #:type _void (coerce-arg self) changeModeWithEvent: (coerce-arg event)))
(define (nswindow-close! self)
  (tell #:type _void (coerce-arg self) close))
(define (nswindow-constrain-frame-rect-to-screen self frame-rect screen)
  (_msg-14 (coerce-arg self) (sel_registerName "constrainFrameRect:toScreen:") frame-rect (coerce-arg screen)))
(define (nswindow-content-border-thickness-for-edge self edge)
  (_msg-36 (coerce-arg self) (sel_registerName "contentBorderThicknessForEdge:") edge))
(define (nswindow-content-rect-for-frame-rect self frame-rect)
  (_msg-9 (coerce-arg self) (sel_registerName "contentRectForFrameRect:") frame-rect))
(define (nswindow-context-menu-key-down self event)
  (tell #:type _void (coerce-arg self) contextMenuKeyDown: (coerce-arg event)))
(define (nswindow-convert-point-from-backing self point)
  (_msg-6 (coerce-arg self) (sel_registerName "convertPointFromBacking:") point))
(define (nswindow-convert-point-from-screen self point)
  (_msg-6 (coerce-arg self) (sel_registerName "convertPointFromScreen:") point))
(define (nswindow-convert-point-to-backing self point)
  (_msg-6 (coerce-arg self) (sel_registerName "convertPointToBacking:") point))
(define (nswindow-convert-point-to-screen self point)
  (_msg-6 (coerce-arg self) (sel_registerName "convertPointToScreen:") point))
(define (nswindow-convert-rect-from-backing self rect)
  (_msg-9 (coerce-arg self) (sel_registerName "convertRectFromBacking:") rect))
(define (nswindow-convert-rect-from-screen self rect)
  (_msg-9 (coerce-arg self) (sel_registerName "convertRectFromScreen:") rect))
(define (nswindow-convert-rect-to-backing self rect)
  (_msg-9 (coerce-arg self) (sel_registerName "convertRectToBacking:") rect))
(define (nswindow-convert-rect-to-screen self rect)
  (_msg-9 (coerce-arg self) (sel_registerName "convertRectToScreen:") rect))
(define (nswindow-cursor-update self event)
  (tell #:type _void (coerce-arg self) cursorUpdate: (coerce-arg event)))
(define (nswindow-data-with-eps-inside-rect self rect)
  (wrap-objc-object
   (_msg-11 (coerce-arg self) (sel_registerName "dataWithEPSInsideRect:") rect)
   ))
(define (nswindow-data-with-pdf-inside-rect self rect)
  (wrap-objc-object
   (_msg-11 (coerce-arg self) (sel_registerName "dataWithPDFInsideRect:") rect)
   ))
(define (nswindow-deminiaturize self sender)
  (tell #:type _void (coerce-arg self) deminiaturize: (coerce-arg sender)))
(define (nswindow-disable-key-equivalent-for-default-button-cell self)
  (tell #:type _void (coerce-arg self) disableKeyEquivalentForDefaultButtonCell))
(define (nswindow-display! self)
  (tell #:type _void (coerce-arg self) display))
(define (nswindow-display-if-needed! self)
  (tell #:type _void (coerce-arg self) displayIfNeeded))
(define (nswindow-displays-when-screen-profile-changes! self)
  (_msg-2 (coerce-arg self) (sel_registerName "displaysWhenScreenProfileChanges")))
(define (nswindow-enable-key-equivalent-for-default-button-cell self)
  (tell #:type _void (coerce-arg self) enableKeyEquivalentForDefaultButtonCell))
(define (nswindow-end-editing-for! self object)
  (tell #:type _void (coerce-arg self) endEditingFor: (coerce-arg object)))
(define (nswindow-end-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) endGestureWithEvent: (coerce-arg event)))
(define (nswindow-end-sheet! self sheet-window)
  (tell #:type _void (coerce-arg self) endSheet: (coerce-arg sheet-window)))
(define (nswindow-end-sheet-return-code! self sheet-window return-code)
  (_msg-27 (coerce-arg self) (sel_registerName "endSheet:returnCode:") (coerce-arg sheet-window) return-code))
(define (nswindow-field-editor-for-object self create-flag object)
  (wrap-objc-object
   (_msg-20 (coerce-arg self) (sel_registerName "fieldEditor:forObject:") create-flag (coerce-arg object))
   ))
(define (nswindow-flags-changed self event)
  (tell #:type _void (coerce-arg self) flagsChanged: (coerce-arg event)))
(define (nswindow-flush-buffered-key-events self)
  (tell #:type _void (coerce-arg self) flushBufferedKeyEvents))
(define (nswindow-frame-rect-for-content-rect self content-rect)
  (_msg-9 (coerce-arg self) (sel_registerName "frameRectForContentRect:") content-rect))
(define (nswindow-help-requested self event-ptr)
  (tell #:type _void (coerce-arg self) helpRequested: (coerce-arg event-ptr)))
(define (nswindow-insert-titlebar-accessory-view-controller-at-index! self child-view-controller index)
  (_msg-27 (coerce-arg self) (sel_registerName "insertTitlebarAccessoryViewController:atIndex:") (coerce-arg child-view-controller) index))
(define (nswindow-interpret-key-events self event-array)
  (tell #:type _void (coerce-arg self) interpretKeyEvents: (coerce-arg event-array)))
(define (nswindow-invalidate-shadow self)
  (tell #:type _void (coerce-arg self) invalidateShadow))
(define (nswindow-is-document-edited self)
  (_msg-2 (coerce-arg self) (sel_registerName "isDocumentEdited")))
(define (nswindow-is-excluded-from-windows-menu self)
  (_msg-2 (coerce-arg self) (sel_registerName "isExcludedFromWindowsMenu")))
(define (nswindow-is-key-window self)
  (_msg-2 (coerce-arg self) (sel_registerName "isKeyWindow")))
(define (nswindow-is-main-window self)
  (_msg-2 (coerce-arg self) (sel_registerName "isMainWindow")))
(define (nswindow-is-miniaturized self)
  (_msg-2 (coerce-arg self) (sel_registerName "isMiniaturized")))
(define (nswindow-is-movable self)
  (_msg-2 (coerce-arg self) (sel_registerName "isMovable")))
(define (nswindow-is-movable-by-window-background self)
  (_msg-2 (coerce-arg self) (sel_registerName "isMovableByWindowBackground")))
(define (nswindow-is-on-active-space self)
  (_msg-2 (coerce-arg self) (sel_registerName "isOnActiveSpace")))
(define (nswindow-is-opaque self)
  (_msg-2 (coerce-arg self) (sel_registerName "isOpaque")))
(define (nswindow-is-released-when-closed self)
  (_msg-2 (coerce-arg self) (sel_registerName "isReleasedWhenClosed")))
(define (nswindow-is-sheet self)
  (_msg-2 (coerce-arg self) (sel_registerName "isSheet")))
(define (nswindow-is-visible self)
  (_msg-2 (coerce-arg self) (sel_registerName "isVisible")))
(define (nswindow-is-zoomed self)
  (_msg-2 (coerce-arg self) (sel_registerName "isZoomed")))
(define (nswindow-key-down self event)
  (tell #:type _void (coerce-arg self) keyDown: (coerce-arg event)))
(define (nswindow-key-up self event)
  (tell #:type _void (coerce-arg self) keyUp: (coerce-arg event)))
(define (nswindow-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) magnifyWithEvent: (coerce-arg event)))
(define (nswindow-make-first-responder self responder)
  (_msg-24 (coerce-arg self) (sel_registerName "makeFirstResponder:") (coerce-arg responder)))
(define (nswindow-make-key-and-order-front self sender)
  (tell #:type _void (coerce-arg self) makeKeyAndOrderFront: (coerce-arg sender)))
(define (nswindow-make-key-window self)
  (tell #:type _void (coerce-arg self) makeKeyWindow))
(define (nswindow-make-main-window self)
  (tell #:type _void (coerce-arg self) makeMainWindow))
(define (nswindow-merge-all-windows self sender)
  (tell #:type _void (coerce-arg self) mergeAllWindows: (coerce-arg sender)))
(define (nswindow-miniaturize self sender)
  (tell #:type _void (coerce-arg self) miniaturize: (coerce-arg sender)))
(define (nswindow-mouse-cancelled self event)
  (tell #:type _void (coerce-arg self) mouseCancelled: (coerce-arg event)))
(define (nswindow-mouse-down self event)
  (tell #:type _void (coerce-arg self) mouseDown: (coerce-arg event)))
(define (nswindow-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) mouseDragged: (coerce-arg event)))
(define (nswindow-mouse-entered self event)
  (tell #:type _void (coerce-arg self) mouseEntered: (coerce-arg event)))
(define (nswindow-mouse-exited self event)
  (tell #:type _void (coerce-arg self) mouseExited: (coerce-arg event)))
(define (nswindow-mouse-moved self event)
  (tell #:type _void (coerce-arg self) mouseMoved: (coerce-arg event)))
(define (nswindow-mouse-up self event)
  (tell #:type _void (coerce-arg self) mouseUp: (coerce-arg event)))
(define (nswindow-move-tab-to-new-window! self sender)
  (tell #:type _void (coerce-arg self) moveTabToNewWindow: (coerce-arg sender)))
(define (nswindow-no-responder-for self event-selector)
  (_msg-32 (coerce-arg self) (sel_registerName "noResponderFor:") event-selector))
(define (nswindow-order-back! self sender)
  (tell #:type _void (coerce-arg self) orderBack: (coerce-arg sender)))
(define (nswindow-order-front! self sender)
  (tell #:type _void (coerce-arg self) orderFront: (coerce-arg sender)))
(define (nswindow-order-front-regardless! self)
  (tell #:type _void (coerce-arg self) orderFrontRegardless))
(define (nswindow-order-out! self sender)
  (tell #:type _void (coerce-arg self) orderOut: (coerce-arg sender)))
(define (nswindow-order-window-relative-to! self place other-win)
  (_msg-39 (coerce-arg self) (sel_registerName "orderWindow:relativeTo:") place other-win))
(define (nswindow-other-mouse-down self event)
  (tell #:type _void (coerce-arg self) otherMouseDown: (coerce-arg event)))
(define (nswindow-other-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) otherMouseDragged: (coerce-arg event)))
(define (nswindow-other-mouse-up self event)
  (tell #:type _void (coerce-arg self) otherMouseUp: (coerce-arg event)))
(define (nswindow-perform-close! self sender)
  (tell #:type _void (coerce-arg self) performClose: (coerce-arg sender)))
(define (nswindow-perform-key-equivalent! self event)
  (_msg-24 (coerce-arg self) (sel_registerName "performKeyEquivalent:") (coerce-arg event)))
(define (nswindow-perform-miniaturize! self sender)
  (tell #:type _void (coerce-arg self) performMiniaturize: (coerce-arg sender)))
(define (nswindow-perform-window-drag-with-event! self event)
  (tell #:type _void (coerce-arg self) performWindowDragWithEvent: (coerce-arg event)))
(define (nswindow-perform-zoom! self sender)
  (tell #:type _void (coerce-arg self) performZoom: (coerce-arg sender)))
(define (nswindow-pressure-change-with-event self event)
  (tell #:type _void (coerce-arg self) pressureChangeWithEvent: (coerce-arg event)))
(define (nswindow-print self sender)
  (tell #:type _void (coerce-arg self) print: (coerce-arg sender)))
(define (nswindow-quick-look-with-event self event)
  (tell #:type _void (coerce-arg self) quickLookWithEvent: (coerce-arg event)))
(define (nswindow-recalculate-key-view-loop self)
  (tell #:type _void (coerce-arg self) recalculateKeyViewLoop))
(define (nswindow-remove-child-window! self child-win)
  (tell #:type _void (coerce-arg self) removeChildWindow: (coerce-arg child-win)))
(define (nswindow-remove-titlebar-accessory-view-controller-at-index! self index)
  (_msg-31 (coerce-arg self) (sel_registerName "removeTitlebarAccessoryViewControllerAtIndex:") index))
(define (nswindow-request-sharing-of-window-completion-handler self window completion-handler)
  (define-values (_blk1 _blk1-id)
    (make-objc-block completion-handler (list _id) _void))
  (_msg-28 (coerce-arg self) (sel_registerName "requestSharingOfWindow:completionHandler:") (coerce-arg window) _blk1))
(define (nswindow-request-sharing-of-window-using-preview-title-completion-handler self image title completion-handler)
  (define-values (_blk2 _blk2-id)
    (make-objc-block completion-handler (list _id) _void))
  (_msg-26 (coerce-arg self) (sel_registerName "requestSharingOfWindowUsingPreview:title:completionHandler:") (coerce-arg image) (coerce-arg title) _blk2))
(define (nswindow-resign-first-responder self)
  (_msg-2 (coerce-arg self) (sel_registerName "resignFirstResponder")))
(define (nswindow-resign-key-window self)
  (tell #:type _void (coerce-arg self) resignKeyWindow))
(define (nswindow-resign-main-window self)
  (tell #:type _void (coerce-arg self) resignMainWindow))
(define (nswindow-right-mouse-down self event)
  (tell #:type _void (coerce-arg self) rightMouseDown: (coerce-arg event)))
(define (nswindow-right-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) rightMouseDragged: (coerce-arg event)))
(define (nswindow-right-mouse-up self event)
  (tell #:type _void (coerce-arg self) rightMouseUp: (coerce-arg event)))
(define (nswindow-rotate-with-event self event)
  (tell #:type _void (coerce-arg self) rotateWithEvent: (coerce-arg event)))
(define (nswindow-run-toolbar-customization-palette self sender)
  (tell #:type _void (coerce-arg self) runToolbarCustomizationPalette: (coerce-arg sender)))
(define (nswindow-save-frame-using-name self name)
  (tell #:type _void (coerce-arg self) saveFrameUsingName: (coerce-arg name)))
(define (nswindow-scroll-wheel self event)
  (tell #:type _void (coerce-arg self) scrollWheel: (coerce-arg event)))
(define (nswindow-select-key-view-following-view self view)
  (tell #:type _void (coerce-arg self) selectKeyViewFollowingView: (coerce-arg view)))
(define (nswindow-select-key-view-preceding-view self view)
  (tell #:type _void (coerce-arg self) selectKeyViewPrecedingView: (coerce-arg view)))
(define (nswindow-select-next-key-view self sender)
  (tell #:type _void (coerce-arg self) selectNextKeyView: (coerce-arg sender)))
(define (nswindow-select-next-tab self sender)
  (tell #:type _void (coerce-arg self) selectNextTab: (coerce-arg sender)))
(define (nswindow-select-previous-key-view self sender)
  (tell #:type _void (coerce-arg self) selectPreviousKeyView: (coerce-arg sender)))
(define (nswindow-select-previous-tab self sender)
  (tell #:type _void (coerce-arg self) selectPreviousTab: (coerce-arg sender)))
(define (nswindow-set-autorecalculates-content-border-thickness-for-edge! self flag edge)
  (_msg-21 (coerce-arg self) (sel_registerName "setAutorecalculatesContentBorderThickness:forEdge:") flag edge))
(define (nswindow-set-content-border-thickness-for-edge! self thickness edge)
  (_msg-23 (coerce-arg self) (sel_registerName "setContentBorderThickness:forEdge:") thickness edge))
(define (nswindow-set-content-size! self size)
  (_msg-18 (coerce-arg self) (sel_registerName "setContentSize:") size))
(define (nswindow-set-dynamic-depth-limit! self flag)
  (_msg-19 (coerce-arg self) (sel_registerName "setDynamicDepthLimit:") flag))
(define (nswindow-set-frame-display! self frame-rect flag)
  (_msg-12 (coerce-arg self) (sel_registerName "setFrame:display:") frame-rect flag))
(define (nswindow-set-frame-display-animate! self frame-rect display-flag animate-flag)
  (_msg-13 (coerce-arg self) (sel_registerName "setFrame:display:animate:") frame-rect display-flag animate-flag))
(define (nswindow-set-frame-autosave-name! self name)
  (_msg-24 (coerce-arg self) (sel_registerName "setFrameAutosaveName:") (coerce-arg name)))
(define (nswindow-set-frame-from-string! self string)
  (tell #:type _void (coerce-arg self) setFrameFromString: (coerce-arg string)))
(define (nswindow-set-frame-origin! self point)
  (_msg-7 (coerce-arg self) (sel_registerName "setFrameOrigin:") point))
(define (nswindow-set-frame-top-left-point! self point)
  (_msg-7 (coerce-arg self) (sel_registerName "setFrameTopLeftPoint:") point))
(define (nswindow-set-frame-using-name! self name)
  (_msg-24 (coerce-arg self) (sel_registerName "setFrameUsingName:") (coerce-arg name)))
(define (nswindow-set-frame-using-name-force! self name force)
  (_msg-25 (coerce-arg self) (sel_registerName "setFrameUsingName:force:") (coerce-arg name) force))
(define (nswindow-set-title-with-represented-filename! self filename)
  (tell #:type _void (coerce-arg self) setTitleWithRepresentedFilename: (coerce-arg filename)))
(define (nswindow-should-be-treated-as-ink-event self event)
  (_msg-24 (coerce-arg self) (sel_registerName "shouldBeTreatedAsInkEvent:") (coerce-arg event)))
(define (nswindow-show-context-help self sender)
  (tell #:type _void (coerce-arg self) showContextHelp: (coerce-arg sender)))
(define (nswindow-smart-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) smartMagnifyWithEvent: (coerce-arg event)))
(define (nswindow-standard-window-button self b)
  (wrap-objc-object
   (_msg-37 (coerce-arg self) (sel_registerName "standardWindowButton:") b)
   ))
(define (nswindow-supplemental-target-for-action-sender self action sender)
  (wrap-objc-object
   (_msg-34 (coerce-arg self) (sel_registerName "supplementalTargetForAction:sender:") action (coerce-arg sender))
   ))
(define (nswindow-swipe-with-event self event)
  (tell #:type _void (coerce-arg self) swipeWithEvent: (coerce-arg event)))
(define (nswindow-tablet-point self event)
  (tell #:type _void (coerce-arg self) tabletPoint: (coerce-arg event)))
(define (nswindow-tablet-proximity self event)
  (tell #:type _void (coerce-arg self) tabletProximity: (coerce-arg event)))
(define (nswindow-toggle-full-screen! self sender)
  (tell #:type _void (coerce-arg self) toggleFullScreen: (coerce-arg sender)))
(define (nswindow-toggle-tab-bar! self sender)
  (tell #:type _void (coerce-arg self) toggleTabBar: (coerce-arg sender)))
(define (nswindow-toggle-tab-overview! self sender)
  (tell #:type _void (coerce-arg self) toggleTabOverview: (coerce-arg sender)))
(define (nswindow-toggle-toolbar-shown! self sender)
  (tell #:type _void (coerce-arg self) toggleToolbarShown: (coerce-arg sender)))
(define (nswindow-touches-began-with-event self event)
  (tell #:type _void (coerce-arg self) touchesBeganWithEvent: (coerce-arg event)))
(define (nswindow-touches-cancelled-with-event self event)
  (tell #:type _void (coerce-arg self) touchesCancelledWithEvent: (coerce-arg event)))
(define (nswindow-touches-ended-with-event self event)
  (tell #:type _void (coerce-arg self) touchesEndedWithEvent: (coerce-arg event)))
(define (nswindow-touches-moved-with-event self event)
  (tell #:type _void (coerce-arg self) touchesMovedWithEvent: (coerce-arg event)))
(define (nswindow-transfer-window-sharing-to-window-completion-handler self window completion-handler)
  (define-values (_blk1 _blk1-id)
    (make-objc-block completion-handler (list _id) _void))
  (_msg-28 (coerce-arg self) (sel_registerName "transferWindowSharingToWindow:completionHandler:") (coerce-arg window) _blk1))
(define (nswindow-try-to-perform-with self action object)
  (_msg-33 (coerce-arg self) (sel_registerName "tryToPerform:with:") action (coerce-arg object)))
(define (nswindow-update self)
  (tell #:type _void (coerce-arg self) update))
(define (nswindow-valid-requestor-for-send-type-return-type self send-type return-type)
  (wrap-objc-object
   (tell (coerce-arg self) validRequestorForSendType: (coerce-arg send-type) returnType: (coerce-arg return-type))))
(define (nswindow-wants-forwarded-scroll-events-for-axis self axis)
  (_msg-35 (coerce-arg self) (sel_registerName "wantsForwardedScrollEventsForAxis:") axis))
(define (nswindow-wants-scroll-events-for-swipe-tracking-on-axis self axis)
  (_msg-35 (coerce-arg self) (sel_registerName "wantsScrollEventsForSwipeTrackingOnAxis:") axis))
(define (nswindow-zoom self sender)
  (tell #:type _void (coerce-arg self) zoom: (coerce-arg sender)))

;; --- Class methods ---
(define (nswindow-content-rect-for-frame-rect-style-mask f-rect style)
  (_msg-15 NSWindow (sel_registerName "contentRectForFrameRect:styleMask:") f-rect style))
(define (nswindow-frame-rect-for-content-rect-style-mask c-rect style)
  (_msg-15 NSWindow (sel_registerName "frameRectForContentRect:styleMask:") c-rect style))
(define (nswindow-min-frame-width-with-title-style-mask title style)
  (_msg-29 NSWindow (sel_registerName "minFrameWidthWithTitle:styleMask:") (coerce-arg title) style))
(define (nswindow-remove-frame-using-name! name)
  (tell #:type _void NSWindow removeFrameUsingName: (coerce-arg name)))
(define (nswindow-standard-window-button-for-style-mask b style-mask)
  (wrap-objc-object
   (_msg-40 NSWindow (sel_registerName "standardWindowButton:forStyleMask:") b style-mask)
   ))
(define (nswindow-window-number-at-point-below-window-with-window-number point window-number)
  (_msg-8 NSWindow (sel_registerName "windowNumberAtPoint:belowWindowWithWindowNumber:") point window-number))
(define (nswindow-window-numbers-with-options options)
  (wrap-objc-object
   (_msg-37 NSWindow (sel_registerName "windowNumbersWithOptions:") options)
   ))
(define (nswindow-window-with-content-view-controller content-view-controller)
  (wrap-objc-object
   (tell NSWindow windowWithContentViewController: (coerce-arg content-view-controller))))
