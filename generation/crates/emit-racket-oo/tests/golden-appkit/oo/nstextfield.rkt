#lang racket/base
;; Generated binding for NSTextField (AppKit)
;; Do not edit — regenerate from enriched IR

(require ffi/unsafe
         ffi/unsafe/objc
         (rename-in racket/contract [-> c->])
         "../../../runtime/objc-base.rkt"
         "../../../runtime/coerce.rkt"
         "../../../runtime/type-mapping.rkt")

;; Load framework and ObjC runtime
(define _fw-lib (ffi-lib "/System/Library/Frameworks/AppKit.framework/AppKit"))
(define _objc-lib (ffi-lib "libobjc"))

(provide NSTextField)
(provide/contract
  [make-nstextfield-init-with-coder (c-> (or/c string? objc-object? cpointer?) any/c)]
  [make-nstextfield-init-with-frame (c-> any/c any/c)]
  [nstextfield-accepts-first-responder (c-> objc-object? boolean?)]
  [nstextfield-accepts-touch-events (c-> objc-object? boolean?)]
  [nstextfield-set-accepts-touch-events! (c-> objc-object? boolean? void?)]
  [nstextfield-action (c-> objc-object? cpointer?)]
  [nstextfield-set-action! (c-> objc-object? cpointer? void?)]
  [nstextfield-additional-safe-area-insets (c-> objc-object? any/c)]
  [nstextfield-set-additional-safe-area-insets! (c-> objc-object? any/c void?)]
  [nstextfield-alignment (c-> objc-object? exact-nonnegative-integer?)]
  [nstextfield-set-alignment! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextfield-alignment-rect-insets (c-> objc-object? any/c)]
  [nstextfield-allowed-touch-types (c-> objc-object? exact-nonnegative-integer?)]
  [nstextfield-set-allowed-touch-types! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextfield-allows-character-picker-touch-bar-item (c-> objc-object? boolean?)]
  [nstextfield-set-allows-character-picker-touch-bar-item! (c-> objc-object? boolean? void?)]
  [nstextfield-allows-default-tightening-for-truncation (c-> objc-object? boolean?)]
  [nstextfield-set-allows-default-tightening-for-truncation! (c-> objc-object? boolean? void?)]
  [nstextfield-allows-editing-text-attributes (c-> objc-object? boolean?)]
  [nstextfield-set-allows-editing-text-attributes! (c-> objc-object? boolean? void?)]
  [nstextfield-allows-expansion-tool-tips (c-> objc-object? boolean?)]
  [nstextfield-set-allows-expansion-tool-tips! (c-> objc-object? boolean? void?)]
  [nstextfield-allows-vibrancy (c-> objc-object? boolean?)]
  [nstextfield-allows-writing-tools (c-> objc-object? boolean?)]
  [nstextfield-set-allows-writing-tools! (c-> objc-object? boolean? void?)]
  [nstextfield-allows-writing-tools-affordance (c-> objc-object? boolean?)]
  [nstextfield-set-allows-writing-tools-affordance! (c-> objc-object? boolean? void?)]
  [nstextfield-alpha-value (c-> objc-object? real?)]
  [nstextfield-set-alpha-value! (c-> objc-object? real? void?)]
  [nstextfield-attributed-string-value (c-> objc-object? any/c)]
  [nstextfield-set-attributed-string-value! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-automatic-text-completion-enabled (c-> objc-object? boolean?)]
  [nstextfield-set-automatic-text-completion-enabled! (c-> objc-object? boolean? void?)]
  [nstextfield-autoresizes-subviews (c-> objc-object? boolean?)]
  [nstextfield-set-autoresizes-subviews! (c-> objc-object? boolean? void?)]
  [nstextfield-autoresizing-mask (c-> objc-object? exact-nonnegative-integer?)]
  [nstextfield-set-autoresizing-mask! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextfield-background-color (c-> objc-object? any/c)]
  [nstextfield-set-background-color! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-background-filters (c-> objc-object? any/c)]
  [nstextfield-set-background-filters! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-base-writing-direction (c-> objc-object? exact-nonnegative-integer?)]
  [nstextfield-set-base-writing-direction! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextfield-baseline-offset-from-bottom (c-> objc-object? real?)]
  [nstextfield-bezel-style (c-> objc-object? exact-nonnegative-integer?)]
  [nstextfield-set-bezel-style! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextfield-bezeled (c-> objc-object? boolean?)]
  [nstextfield-set-bezeled! (c-> objc-object? boolean? void?)]
  [nstextfield-bordered (c-> objc-object? boolean?)]
  [nstextfield-set-bordered! (c-> objc-object? boolean? void?)]
  [nstextfield-bottom-anchor (c-> objc-object? any/c)]
  [nstextfield-bounds (c-> objc-object? any/c)]
  [nstextfield-set-bounds! (c-> objc-object? any/c void?)]
  [nstextfield-bounds-rotation (c-> objc-object? real?)]
  [nstextfield-set-bounds-rotation! (c-> objc-object? real? void?)]
  [nstextfield-can-become-key-view (c-> objc-object? boolean?)]
  [nstextfield-can-draw (c-> objc-object? boolean?)]
  [nstextfield-can-draw-concurrently (c-> objc-object? boolean?)]
  [nstextfield-set-can-draw-concurrently! (c-> objc-object? boolean? void?)]
  [nstextfield-can-draw-subviews-into-layer (c-> objc-object? boolean?)]
  [nstextfield-set-can-draw-subviews-into-layer! (c-> objc-object? boolean? void?)]
  [nstextfield-candidate-list-touch-bar-item (c-> objc-object? any/c)]
  [nstextfield-cell (c-> objc-object? any/c)]
  [nstextfield-set-cell! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-cell-class (c-> cpointer?)]
  [nstextfield-set-cell-class! (c-> cpointer? void?)]
  [nstextfield-center-x-anchor (c-> objc-object? any/c)]
  [nstextfield-center-y-anchor (c-> objc-object? any/c)]
  [nstextfield-clips-to-bounds (c-> objc-object? boolean?)]
  [nstextfield-set-clips-to-bounds! (c-> objc-object? boolean? void?)]
  [nstextfield-compatible-with-responsive-scrolling (c-> boolean?)]
  [nstextfield-compositing-filter (c-> objc-object? any/c)]
  [nstextfield-set-compositing-filter! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-constraints (c-> objc-object? any/c)]
  [nstextfield-content-filters (c-> objc-object? any/c)]
  [nstextfield-set-content-filters! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-continuous (c-> objc-object? boolean?)]
  [nstextfield-set-continuous! (c-> objc-object? boolean? void?)]
  [nstextfield-control-size (c-> objc-object? exact-nonnegative-integer?)]
  [nstextfield-set-control-size! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextfield-default-focus-ring-type (c-> exact-nonnegative-integer?)]
  [nstextfield-default-menu (c-> any/c)]
  [nstextfield-delegate (c-> objc-object? any/c)]
  [nstextfield-set-delegate! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-double-value (c-> objc-object? real?)]
  [nstextfield-set-double-value! (c-> objc-object? real? void?)]
  [nstextfield-drawing-find-indicator (c-> objc-object? boolean?)]
  [nstextfield-draws-background (c-> objc-object? boolean?)]
  [nstextfield-set-draws-background! (c-> objc-object? boolean? void?)]
  [nstextfield-editable (c-> objc-object? boolean?)]
  [nstextfield-set-editable! (c-> objc-object? boolean? void?)]
  [nstextfield-enabled (c-> objc-object? boolean?)]
  [nstextfield-set-enabled! (c-> objc-object? boolean? void?)]
  [nstextfield-enclosing-menu-item (c-> objc-object? any/c)]
  [nstextfield-enclosing-scroll-view (c-> objc-object? any/c)]
  [nstextfield-first-baseline-anchor (c-> objc-object? any/c)]
  [nstextfield-first-baseline-offset-from-top (c-> objc-object? real?)]
  [nstextfield-fitting-size (c-> objc-object? any/c)]
  [nstextfield-flipped (c-> objc-object? boolean?)]
  [nstextfield-float-value (c-> objc-object? real?)]
  [nstextfield-set-float-value! (c-> objc-object? real? void?)]
  [nstextfield-focus-ring-mask-bounds (c-> objc-object? any/c)]
  [nstextfield-focus-ring-type (c-> objc-object? exact-nonnegative-integer?)]
  [nstextfield-set-focus-ring-type! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextfield-focus-view (c-> any/c)]
  [nstextfield-font (c-> objc-object? any/c)]
  [nstextfield-set-font! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-formatter (c-> objc-object? any/c)]
  [nstextfield-set-formatter! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-frame (c-> objc-object? any/c)]
  [nstextfield-set-frame! (c-> objc-object? any/c void?)]
  [nstextfield-frame-center-rotation (c-> objc-object? real?)]
  [nstextfield-set-frame-center-rotation! (c-> objc-object? real? void?)]
  [nstextfield-frame-rotation (c-> objc-object? real?)]
  [nstextfield-set-frame-rotation! (c-> objc-object? real? void?)]
  [nstextfield-gesture-recognizers (c-> objc-object? any/c)]
  [nstextfield-set-gesture-recognizers! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-has-ambiguous-layout (c-> objc-object? boolean?)]
  [nstextfield-height-adjust-limit (c-> objc-object? real?)]
  [nstextfield-height-anchor (c-> objc-object? any/c)]
  [nstextfield-hidden (c-> objc-object? boolean?)]
  [nstextfield-set-hidden! (c-> objc-object? boolean? void?)]
  [nstextfield-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nstextfield-highlighted (c-> objc-object? boolean?)]
  [nstextfield-set-highlighted! (c-> objc-object? boolean? void?)]
  [nstextfield-horizontal-content-size-constraint-active (c-> objc-object? boolean?)]
  [nstextfield-set-horizontal-content-size-constraint-active! (c-> objc-object? boolean? void?)]
  [nstextfield-ignores-multi-click (c-> objc-object? boolean?)]
  [nstextfield-set-ignores-multi-click! (c-> objc-object? boolean? void?)]
  [nstextfield-imports-graphics (c-> objc-object? boolean?)]
  [nstextfield-set-imports-graphics! (c-> objc-object? boolean? void?)]
  [nstextfield-in-full-screen-mode (c-> objc-object? boolean?)]
  [nstextfield-in-live-resize (c-> objc-object? boolean?)]
  [nstextfield-input-context (c-> objc-object? any/c)]
  [nstextfield-int-value (c-> objc-object? exact-integer?)]
  [nstextfield-set-int-value! (c-> objc-object? exact-integer? void?)]
  [nstextfield-integer-value (c-> objc-object? exact-integer?)]
  [nstextfield-set-integer-value! (c-> objc-object? exact-integer? void?)]
  [nstextfield-intrinsic-content-size (c-> objc-object? any/c)]
  [nstextfield-last-baseline-anchor (c-> objc-object? any/c)]
  [nstextfield-last-baseline-offset-from-bottom (c-> objc-object? real?)]
  [nstextfield-layer (c-> objc-object? any/c)]
  [nstextfield-set-layer! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-layer-contents-placement (c-> objc-object? exact-nonnegative-integer?)]
  [nstextfield-set-layer-contents-placement! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextfield-layer-contents-redraw-policy (c-> objc-object? exact-nonnegative-integer?)]
  [nstextfield-set-layer-contents-redraw-policy! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextfield-layer-uses-core-image-filters (c-> objc-object? boolean?)]
  [nstextfield-set-layer-uses-core-image-filters! (c-> objc-object? boolean? void?)]
  [nstextfield-layout-guides (c-> objc-object? any/c)]
  [nstextfield-layout-margins-guide (c-> objc-object? any/c)]
  [nstextfield-leading-anchor (c-> objc-object? any/c)]
  [nstextfield-left-anchor (c-> objc-object? any/c)]
  [nstextfield-line-break-mode (c-> objc-object? exact-nonnegative-integer?)]
  [nstextfield-set-line-break-mode! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextfield-line-break-strategy (c-> objc-object? exact-nonnegative-integer?)]
  [nstextfield-set-line-break-strategy! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextfield-maximum-number-of-lines (c-> objc-object? exact-integer?)]
  [nstextfield-set-maximum-number-of-lines! (c-> objc-object? exact-integer? void?)]
  [nstextfield-menu (c-> objc-object? any/c)]
  [nstextfield-set-menu! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-mouse-down-can-move-window (c-> objc-object? boolean?)]
  [nstextfield-needs-display (c-> objc-object? boolean?)]
  [nstextfield-set-needs-display! (c-> objc-object? boolean? void?)]
  [nstextfield-needs-layout (c-> objc-object? boolean?)]
  [nstextfield-set-needs-layout! (c-> objc-object? boolean? void?)]
  [nstextfield-needs-panel-to-become-key (c-> objc-object? boolean?)]
  [nstextfield-needs-update-constraints (c-> objc-object? boolean?)]
  [nstextfield-set-needs-update-constraints! (c-> objc-object? boolean? void?)]
  [nstextfield-next-key-view (c-> objc-object? any/c)]
  [nstextfield-set-next-key-view! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-next-responder (c-> objc-object? any/c)]
  [nstextfield-set-next-responder! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-next-valid-key-view (c-> objc-object? any/c)]
  [nstextfield-object-value (c-> objc-object? any/c)]
  [nstextfield-set-object-value! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-opaque (c-> objc-object? boolean?)]
  [nstextfield-opaque-ancestor (c-> objc-object? any/c)]
  [nstextfield-page-footer (c-> objc-object? any/c)]
  [nstextfield-page-header (c-> objc-object? any/c)]
  [nstextfield-placeholder-attributed-string (c-> objc-object? any/c)]
  [nstextfield-set-placeholder-attributed-string! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-placeholder-attributed-strings (c-> objc-object? any/c)]
  [nstextfield-set-placeholder-attributed-strings! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-placeholder-string (c-> objc-object? any/c)]
  [nstextfield-set-placeholder-string! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-placeholder-strings (c-> objc-object? any/c)]
  [nstextfield-set-placeholder-strings! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-posts-bounds-changed-notifications (c-> objc-object? boolean?)]
  [nstextfield-set-posts-bounds-changed-notifications! (c-> objc-object? boolean? void?)]
  [nstextfield-posts-frame-changed-notifications (c-> objc-object? boolean?)]
  [nstextfield-set-posts-frame-changed-notifications! (c-> objc-object? boolean? void?)]
  [nstextfield-preferred-max-layout-width (c-> objc-object? real?)]
  [nstextfield-set-preferred-max-layout-width! (c-> objc-object? real? void?)]
  [nstextfield-prefers-compact-control-size-metrics (c-> objc-object? boolean?)]
  [nstextfield-set-prefers-compact-control-size-metrics! (c-> objc-object? boolean? void?)]
  [nstextfield-prepared-content-rect (c-> objc-object? any/c)]
  [nstextfield-set-prepared-content-rect! (c-> objc-object? any/c void?)]
  [nstextfield-preserves-content-during-live-resize (c-> objc-object? boolean?)]
  [nstextfield-pressure-configuration (c-> objc-object? any/c)]
  [nstextfield-set-pressure-configuration! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-previous-key-view (c-> objc-object? any/c)]
  [nstextfield-previous-valid-key-view (c-> objc-object? any/c)]
  [nstextfield-print-job-title (c-> objc-object? any/c)]
  [nstextfield-rect-preserved-during-live-resize (c-> objc-object? any/c)]
  [nstextfield-refuses-first-responder (c-> objc-object? boolean?)]
  [nstextfield-set-refuses-first-responder! (c-> objc-object? boolean? void?)]
  [nstextfield-registered-dragged-types (c-> objc-object? any/c)]
  [nstextfield-requires-constraint-based-layout (c-> boolean?)]
  [nstextfield-resolves-natural-alignment-with-base-writing-direction (c-> objc-object? boolean?)]
  [nstextfield-set-resolves-natural-alignment-with-base-writing-direction! (c-> objc-object? boolean? void?)]
  [nstextfield-restorable-state-key-paths (c-> any/c)]
  [nstextfield-right-anchor (c-> objc-object? any/c)]
  [nstextfield-rotated-from-base (c-> objc-object? boolean?)]
  [nstextfield-rotated-or-scaled-from-base (c-> objc-object? boolean?)]
  [nstextfield-safe-area-insets (c-> objc-object? any/c)]
  [nstextfield-safe-area-layout-guide (c-> objc-object? any/c)]
  [nstextfield-safe-area-rect (c-> objc-object? any/c)]
  [nstextfield-selectable (c-> objc-object? boolean?)]
  [nstextfield-set-selectable! (c-> objc-object? boolean? void?)]
  [nstextfield-shadow (c-> objc-object? any/c)]
  [nstextfield-set-shadow! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-string-value (c-> objc-object? any/c)]
  [nstextfield-set-string-value! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-subviews (c-> objc-object? any/c)]
  [nstextfield-set-subviews! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-suggestions-delegate (c-> objc-object? any/c)]
  [nstextfield-set-suggestions-delegate! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-superview (c-> objc-object? any/c)]
  [nstextfield-tag (c-> objc-object? exact-integer?)]
  [nstextfield-set-tag! (c-> objc-object? exact-integer? void?)]
  [nstextfield-target (c-> objc-object? any/c)]
  [nstextfield-set-target! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-text-color (c-> objc-object? any/c)]
  [nstextfield-set-text-color! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-tool-tip (c-> objc-object? any/c)]
  [nstextfield-set-tool-tip! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-top-anchor (c-> objc-object? any/c)]
  [nstextfield-touch-bar (c-> objc-object? any/c)]
  [nstextfield-set-touch-bar! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-tracking-areas (c-> objc-object? any/c)]
  [nstextfield-trailing-anchor (c-> objc-object? any/c)]
  [nstextfield-translates-autoresizing-mask-into-constraints (c-> objc-object? boolean?)]
  [nstextfield-set-translates-autoresizing-mask-into-constraints! (c-> objc-object? boolean? void?)]
  [nstextfield-undo-manager (c-> objc-object? any/c)]
  [nstextfield-user-activity (c-> objc-object? any/c)]
  [nstextfield-set-user-activity! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-user-interface-layout-direction (c-> objc-object? exact-nonnegative-integer?)]
  [nstextfield-set-user-interface-layout-direction! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextfield-uses-single-line-mode (c-> objc-object? boolean?)]
  [nstextfield-set-uses-single-line-mode! (c-> objc-object? boolean? void?)]
  [nstextfield-vertical-content-size-constraint-active (c-> objc-object? boolean?)]
  [nstextfield-set-vertical-content-size-constraint-active! (c-> objc-object? boolean? void?)]
  [nstextfield-visible-rect (c-> objc-object? any/c)]
  [nstextfield-wants-best-resolution-open-gl-surface (c-> objc-object? boolean?)]
  [nstextfield-set-wants-best-resolution-open-gl-surface! (c-> objc-object? boolean? void?)]
  [nstextfield-wants-default-clipping (c-> objc-object? boolean?)]
  [nstextfield-wants-extended-dynamic-range-open-gl-surface (c-> objc-object? boolean?)]
  [nstextfield-set-wants-extended-dynamic-range-open-gl-surface! (c-> objc-object? boolean? void?)]
  [nstextfield-wants-layer (c-> objc-object? boolean?)]
  [nstextfield-set-wants-layer! (c-> objc-object? boolean? void?)]
  [nstextfield-wants-resting-touches (c-> objc-object? boolean?)]
  [nstextfield-set-wants-resting-touches! (c-> objc-object? boolean? void?)]
  [nstextfield-wants-update-layer (c-> objc-object? boolean?)]
  [nstextfield-width-adjust-limit (c-> objc-object? real?)]
  [nstextfield-width-anchor (c-> objc-object? any/c)]
  [nstextfield-window (c-> objc-object? any/c)]
  [nstextfield-writing-tools-coordinator (c-> objc-object? any/c)]
  [nstextfield-set-writing-tools-coordinator! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-accepts-first-mouse (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextfield-add-subview! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-add-subview-positioned-relative-to! (c-> objc-object? (or/c string? objc-object? cpointer?) exact-nonnegative-integer? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-add-tool-tip-rect-owner-user-data! (c-> objc-object? any/c (or/c string? objc-object? cpointer?) (or/c cpointer? #f) exact-integer?)]
  [nstextfield-adjust-scroll (c-> objc-object? any/c any/c)]
  [nstextfield-ancestor-shared-with-view (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nstextfield-autoscroll (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextfield-backing-aligned-rect-options (c-> objc-object? any/c exact-nonnegative-integer? any/c)]
  [nstextfield-become-first-responder (c-> objc-object? boolean?)]
  [nstextfield-begin-gesture-with-event! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-bitmap-image-rep-for-caching-display-in-rect (c-> objc-object? any/c any/c)]
  [nstextfield-cache-display-in-rect-to-bitmap-image-rep (c-> objc-object? any/c (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-center-scan-rect! (c-> objc-object? any/c any/c)]
  [nstextfield-change-mode-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-context-menu-key-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-convert-point-from-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstextfield-convert-point-to-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstextfield-convert-point-from-backing (c-> objc-object? any/c any/c)]
  [nstextfield-convert-point-from-layer (c-> objc-object? any/c any/c)]
  [nstextfield-convert-point-to-backing (c-> objc-object? any/c any/c)]
  [nstextfield-convert-point-to-layer (c-> objc-object? any/c any/c)]
  [nstextfield-convert-rect-from-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstextfield-convert-rect-to-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstextfield-convert-rect-from-backing (c-> objc-object? any/c any/c)]
  [nstextfield-convert-rect-from-layer (c-> objc-object? any/c any/c)]
  [nstextfield-convert-rect-to-backing (c-> objc-object? any/c any/c)]
  [nstextfield-convert-rect-to-layer (c-> objc-object? any/c any/c)]
  [nstextfield-convert-size-from-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstextfield-convert-size-to-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstextfield-convert-size-from-backing (c-> objc-object? any/c any/c)]
  [nstextfield-convert-size-from-layer (c-> objc-object? any/c any/c)]
  [nstextfield-convert-size-to-backing (c-> objc-object? any/c any/c)]
  [nstextfield-convert-size-to-layer (c-> objc-object? any/c any/c)]
  [nstextfield-cursor-update (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-did-add-subview (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-did-close-menu-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-display! (c-> objc-object? void?)]
  [nstextfield-display-if-needed! (c-> objc-object? void?)]
  [nstextfield-display-if-needed-ignoring-opacity! (c-> objc-object? void?)]
  [nstextfield-display-if-needed-in-rect! (c-> objc-object? any/c void?)]
  [nstextfield-display-if-needed-in-rect-ignoring-opacity! (c-> objc-object? any/c void?)]
  [nstextfield-display-rect! (c-> objc-object? any/c void?)]
  [nstextfield-display-rect-ignoring-opacity! (c-> objc-object? any/c void?)]
  [nstextfield-display-rect-ignoring-opacity-in-context! (c-> objc-object? any/c (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-draw-rect (c-> objc-object? any/c void?)]
  [nstextfield-draw-with-expansion-frame-in-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-end-gesture-with-event! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-expansion-frame-with-frame (c-> objc-object? any/c any/c)]
  [nstextfield-flags-changed (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-flush-buffered-key-events (c-> objc-object? void?)]
  [nstextfield-get-rects-being-drawn-count (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nstextfield-get-rects-exposed-during-live-resize-count (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nstextfield-help-requested (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-hit-test (c-> objc-object? any/c any/c)]
  [nstextfield-interpret-key-events (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-is-bezeled (c-> objc-object? boolean?)]
  [nstextfield-is-bordered (c-> objc-object? boolean?)]
  [nstextfield-is-continuous (c-> objc-object? boolean?)]
  [nstextfield-is-descendant-of (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextfield-is-editable (c-> objc-object? boolean?)]
  [nstextfield-is-enabled (c-> objc-object? boolean?)]
  [nstextfield-is-flipped (c-> objc-object? boolean?)]
  [nstextfield-is-hidden (c-> objc-object? boolean?)]
  [nstextfield-is-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nstextfield-is-highlighted (c-> objc-object? boolean?)]
  [nstextfield-is-opaque (c-> objc-object? boolean?)]
  [nstextfield-is-rotated-from-base (c-> objc-object? boolean?)]
  [nstextfield-is-rotated-or-scaled-from-base (c-> objc-object? boolean?)]
  [nstextfield-is-selectable (c-> objc-object? boolean?)]
  [nstextfield-key-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-key-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-layout (c-> objc-object? void?)]
  [nstextfield-layout-subtree-if-needed (c-> objc-object? void?)]
  [nstextfield-magnify-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-make-backing-layer (c-> objc-object? any/c)]
  [nstextfield-menu-for-event (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nstextfield-mouse-in-rect (c-> objc-object? any/c any/c boolean?)]
  [nstextfield-mouse-cancelled (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-mouse-entered (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-mouse-exited (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-mouse-moved (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-needs-to-draw-rect (c-> objc-object? any/c boolean?)]
  [nstextfield-no-responder-for (c-> objc-object? cpointer? void?)]
  [nstextfield-other-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-other-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-other-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-perform-click! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-perform-key-equivalent! (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextfield-prepare-content-in-rect (c-> objc-object? any/c void?)]
  [nstextfield-prepare-for-reuse (c-> objc-object? void?)]
  [nstextfield-pressure-change-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-quick-look-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-rect-for-smart-magnification-at-point-in-rect (c-> objc-object? any/c any/c any/c)]
  [nstextfield-remove-all-tool-tips! (c-> objc-object? void?)]
  [nstextfield-remove-from-superview! (c-> objc-object? void?)]
  [nstextfield-remove-from-superview-without-needing-display! (c-> objc-object? void?)]
  [nstextfield-remove-tool-tip! (c-> objc-object? exact-integer? void?)]
  [nstextfield-replace-subview-with! (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-resign-first-responder (c-> objc-object? boolean?)]
  [nstextfield-resize-subviews-with-old-size (c-> objc-object? any/c void?)]
  [nstextfield-resize-with-old-superview-size (c-> objc-object? any/c void?)]
  [nstextfield-right-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-right-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-right-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-rotate-by-angle (c-> objc-object? real? void?)]
  [nstextfield-rotate-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-scale-unit-square-to-size (c-> objc-object? any/c void?)]
  [nstextfield-scroll-point (c-> objc-object? any/c void?)]
  [nstextfield-scroll-rect-to-visible (c-> objc-object? any/c boolean?)]
  [nstextfield-scroll-wheel (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-select-text (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-send-action-to (c-> objc-object? cpointer? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextfield-send-action-on (c-> objc-object? exact-nonnegative-integer? exact-integer?)]
  [nstextfield-set-bounds-origin! (c-> objc-object? any/c void?)]
  [nstextfield-set-bounds-size! (c-> objc-object? any/c void?)]
  [nstextfield-set-frame-origin! (c-> objc-object? any/c void?)]
  [nstextfield-set-frame-size! (c-> objc-object? any/c void?)]
  [nstextfield-set-needs-display-in-rect! (c-> objc-object? any/c void?)]
  [nstextfield-should-be-treated-as-ink-event (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextfield-should-delay-window-ordering-for-event (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextfield-show-context-help (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-size-that-fits (c-> objc-object? any/c any/c)]
  [nstextfield-size-to-fit (c-> objc-object? void?)]
  [nstextfield-smart-magnify-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-sort-subviews-using-function-context (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nstextfield-supplemental-target-for-action-sender (c-> objc-object? cpointer? (or/c string? objc-object? cpointer?) any/c)]
  [nstextfield-swipe-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-tablet-point (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-tablet-proximity (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-take-double-value-from (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-take-float-value-from (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-take-int-value-from (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-take-integer-value-from (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-take-object-value-from (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-take-string-value-from (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-text-did-begin-editing (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-text-did-change (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-text-did-end-editing (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-text-should-begin-editing (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextfield-text-should-end-editing (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextfield-touches-began-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-touches-cancelled-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-touches-ended-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-touches-moved-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-translate-origin-to-point (c-> objc-object? any/c void?)]
  [nstextfield-translate-rects-needing-display-in-rect-by (c-> objc-object? any/c any/c void?)]
  [nstextfield-try-to-perform-with (c-> objc-object? cpointer? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextfield-update-layer (c-> objc-object? void?)]
  [nstextfield-valid-requestor-for-send-type-return-type (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) any/c)]
  [nstextfield-view-did-change-backing-properties (c-> objc-object? void?)]
  [nstextfield-view-did-change-effective-appearance (c-> objc-object? void?)]
  [nstextfield-view-did-end-live-resize (c-> objc-object? void?)]
  [nstextfield-view-did-hide (c-> objc-object? void?)]
  [nstextfield-view-did-move-to-superview (c-> objc-object? void?)]
  [nstextfield-view-did-move-to-window (c-> objc-object? void?)]
  [nstextfield-view-did-unhide (c-> objc-object? void?)]
  [nstextfield-view-will-draw (c-> objc-object? void?)]
  [nstextfield-view-will-move-to-superview (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-view-will-move-to-window (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-view-will-start-live-resize (c-> objc-object? void?)]
  [nstextfield-view-with-tag (c-> objc-object? exact-integer? any/c)]
  [nstextfield-wants-forwarded-scroll-events-for-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nstextfield-wants-scroll-events-for-swipe-tracking-on-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nstextfield-will-open-menu-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-will-remove-subview (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextfield-is-compatible-with-responsive-scrolling (c-> boolean?)]
  )

;; --- Class reference ---
(import-class NSTextField)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _NSRect)))
(define _msg-1  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-2  ; (_fun _pointer _pointer -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _double)))
(define _msg-3  ; (_fun _pointer _pointer -> _float)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _float)))
(define _msg-4  ; (_fun _pointer _pointer -> _int32)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _int32)))
(define _msg-5  ; (_fun _pointer _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _int64)))
(define _msg-6  ; (_fun _pointer _pointer -> _pointer)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _pointer)))
(define _msg-7  ; (_fun _pointer _pointer -> _uint64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _uint64)))
(define _msg-8  ; (_fun _pointer _pointer _NSEdgeInsets -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSEdgeInsets -> _void)))
(define _msg-9  ; (_fun _pointer _pointer _NSPoint -> _NSPoint)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _NSPoint)))
(define _msg-10  ; (_fun _pointer _pointer _NSPoint -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _id)))
(define _msg-11  ; (_fun _pointer _pointer _NSPoint -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _void)))
(define _msg-12  ; (_fun _pointer _pointer _NSPoint _NSRect -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _NSRect -> _NSRect)))
(define _msg-13  ; (_fun _pointer _pointer _NSPoint _NSRect -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _NSRect -> _bool)))
(define _msg-14  ; (_fun _pointer _pointer _NSPoint _id -> _NSPoint)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _id -> _NSPoint)))
(define _msg-15  ; (_fun _pointer _pointer _NSRect -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _NSRect)))
(define _msg-16  ; (_fun _pointer _pointer _NSRect -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _bool)))
(define _msg-17  ; (_fun _pointer _pointer _NSRect -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _id)))
(define _msg-18  ; (_fun _pointer _pointer _NSRect -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _void)))
(define _msg-19  ; (_fun _pointer _pointer _NSRect _NSSize -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _NSSize -> _void)))
(define _msg-20  ; (_fun _pointer _pointer _NSRect _id -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id -> _NSRect)))
(define _msg-21  ; (_fun _pointer _pointer _NSRect _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id -> _void)))
(define _msg-22  ; (_fun _pointer _pointer _NSRect _id _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id _pointer -> _int64)))
(define _msg-23  ; (_fun _pointer _pointer _NSRect _uint64 -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _uint64 -> _NSRect)))
(define _msg-24  ; (_fun _pointer _pointer _NSSize -> _NSSize)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize -> _NSSize)))
(define _msg-25  ; (_fun _pointer _pointer _NSSize -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize -> _void)))
(define _msg-26  ; (_fun _pointer _pointer _NSSize _id -> _NSSize)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize _id -> _NSSize)))
(define _msg-27  ; (_fun _pointer _pointer _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool -> _void)))
(define _msg-28  ; (_fun _pointer _pointer _double -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double -> _void)))
(define _msg-29  ; (_fun _pointer _pointer _float -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _float -> _void)))
(define _msg-30  ; (_fun _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _bool)))
(define _msg-31  ; (_fun _pointer _pointer _id _uint64 _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _uint64 _id -> _void)))
(define _msg-32  ; (_fun _pointer _pointer _int32 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int32 -> _void)))
(define _msg-33  ; (_fun _pointer _pointer _int64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _id)))
(define _msg-34  ; (_fun _pointer _pointer _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _void)))
(define _msg-35  ; (_fun _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))
(define _msg-36  ; (_fun _pointer _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _bool)))
(define _msg-37  ; (_fun _pointer _pointer _pointer _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _id)))
(define _msg-38  ; (_fun _pointer _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _pointer -> _void)))
(define _msg-39  ; (_fun _pointer _pointer _uint64 -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _bool)))
(define _msg-40  ; (_fun _pointer _pointer _uint64 -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _int64)))
(define _msg-41  ; (_fun _pointer _pointer _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _void)))

;; --- Constructors ---
(define (make-nstextfield-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSTextField alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))

(define (make-nstextfield-init-with-frame frame-rect)
  (wrap-objc-object
   (_msg-17 (tell NSTextField alloc)
       (sel_registerName "initWithFrame:")
       frame-rect)
   #:retained #t))


;; --- Properties ---
(define (nstextfield-accepts-first-responder self)
  (tell #:type _bool (coerce-arg self) acceptsFirstResponder))
(define (nstextfield-accepts-touch-events self)
  (tell #:type _bool (coerce-arg self) acceptsTouchEvents))
(define (nstextfield-set-accepts-touch-events! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setAcceptsTouchEvents:") value))
(define (nstextfield-action self)
  (tell #:type _pointer (coerce-arg self) action))
(define (nstextfield-set-action! self value)
  (_msg-35 (coerce-arg self) (sel_registerName "setAction:") value))
(define (nstextfield-additional-safe-area-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) additionalSafeAreaInsets))
(define (nstextfield-set-additional-safe-area-insets! self value)
  (_msg-8 (coerce-arg self) (sel_registerName "setAdditionalSafeAreaInsets:") value))
(define (nstextfield-alignment self)
  (tell #:type _uint64 (coerce-arg self) alignment))
(define (nstextfield-set-alignment! self value)
  (_msg-41 (coerce-arg self) (sel_registerName "setAlignment:") value))
(define (nstextfield-alignment-rect-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) alignmentRectInsets))
(define (nstextfield-allowed-touch-types self)
  (tell #:type _uint64 (coerce-arg self) allowedTouchTypes))
(define (nstextfield-set-allowed-touch-types! self value)
  (_msg-41 (coerce-arg self) (sel_registerName "setAllowedTouchTypes:") value))
(define (nstextfield-allows-character-picker-touch-bar-item self)
  (tell #:type _bool (coerce-arg self) allowsCharacterPickerTouchBarItem))
(define (nstextfield-set-allows-character-picker-touch-bar-item! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setAllowsCharacterPickerTouchBarItem:") value))
(define (nstextfield-allows-default-tightening-for-truncation self)
  (tell #:type _bool (coerce-arg self) allowsDefaultTighteningForTruncation))
(define (nstextfield-set-allows-default-tightening-for-truncation! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setAllowsDefaultTighteningForTruncation:") value))
(define (nstextfield-allows-editing-text-attributes self)
  (tell #:type _bool (coerce-arg self) allowsEditingTextAttributes))
(define (nstextfield-set-allows-editing-text-attributes! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setAllowsEditingTextAttributes:") value))
(define (nstextfield-allows-expansion-tool-tips self)
  (tell #:type _bool (coerce-arg self) allowsExpansionToolTips))
(define (nstextfield-set-allows-expansion-tool-tips! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setAllowsExpansionToolTips:") value))
(define (nstextfield-allows-vibrancy self)
  (tell #:type _bool (coerce-arg self) allowsVibrancy))
(define (nstextfield-allows-writing-tools self)
  (tell #:type _bool (coerce-arg self) allowsWritingTools))
(define (nstextfield-set-allows-writing-tools! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setAllowsWritingTools:") value))
(define (nstextfield-allows-writing-tools-affordance self)
  (tell #:type _bool (coerce-arg self) allowsWritingToolsAffordance))
(define (nstextfield-set-allows-writing-tools-affordance! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setAllowsWritingToolsAffordance:") value))
(define (nstextfield-alpha-value self)
  (tell #:type _double (coerce-arg self) alphaValue))
(define (nstextfield-set-alpha-value! self value)
  (_msg-28 (coerce-arg self) (sel_registerName "setAlphaValue:") value))
(define (nstextfield-attributed-string-value self)
  (wrap-objc-object
   (tell (coerce-arg self) attributedStringValue)))
(define (nstextfield-set-attributed-string-value! self value)
  (tell #:type _void (coerce-arg self) setAttributedStringValue: (coerce-arg value)))
(define (nstextfield-automatic-text-completion-enabled self)
  (tell #:type _bool (coerce-arg self) automaticTextCompletionEnabled))
(define (nstextfield-set-automatic-text-completion-enabled! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setAutomaticTextCompletionEnabled:") value))
(define (nstextfield-autoresizes-subviews self)
  (tell #:type _bool (coerce-arg self) autoresizesSubviews))
(define (nstextfield-set-autoresizes-subviews! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setAutoresizesSubviews:") value))
(define (nstextfield-autoresizing-mask self)
  (tell #:type _uint64 (coerce-arg self) autoresizingMask))
(define (nstextfield-set-autoresizing-mask! self value)
  (_msg-41 (coerce-arg self) (sel_registerName "setAutoresizingMask:") value))
(define (nstextfield-background-color self)
  (wrap-objc-object
   (tell (coerce-arg self) backgroundColor)))
(define (nstextfield-set-background-color! self value)
  (tell #:type _void (coerce-arg self) setBackgroundColor: (coerce-arg value)))
(define (nstextfield-background-filters self)
  (wrap-objc-object
   (tell (coerce-arg self) backgroundFilters)))
(define (nstextfield-set-background-filters! self value)
  (tell #:type _void (coerce-arg self) setBackgroundFilters: (coerce-arg value)))
(define (nstextfield-base-writing-direction self)
  (tell #:type _uint64 (coerce-arg self) baseWritingDirection))
(define (nstextfield-set-base-writing-direction! self value)
  (_msg-41 (coerce-arg self) (sel_registerName "setBaseWritingDirection:") value))
(define (nstextfield-baseline-offset-from-bottom self)
  (tell #:type _double (coerce-arg self) baselineOffsetFromBottom))
(define (nstextfield-bezel-style self)
  (tell #:type _uint64 (coerce-arg self) bezelStyle))
(define (nstextfield-set-bezel-style! self value)
  (_msg-41 (coerce-arg self) (sel_registerName "setBezelStyle:") value))
(define (nstextfield-bezeled self)
  (tell #:type _bool (coerce-arg self) bezeled))
(define (nstextfield-set-bezeled! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setBezeled:") value))
(define (nstextfield-bordered self)
  (tell #:type _bool (coerce-arg self) bordered))
(define (nstextfield-set-bordered! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setBordered:") value))
(define (nstextfield-bottom-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) bottomAnchor)))
(define (nstextfield-bounds self)
  (tell #:type _NSRect (coerce-arg self) bounds))
(define (nstextfield-set-bounds! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setBounds:") value))
(define (nstextfield-bounds-rotation self)
  (tell #:type _double (coerce-arg self) boundsRotation))
(define (nstextfield-set-bounds-rotation! self value)
  (_msg-28 (coerce-arg self) (sel_registerName "setBoundsRotation:") value))
(define (nstextfield-can-become-key-view self)
  (tell #:type _bool (coerce-arg self) canBecomeKeyView))
(define (nstextfield-can-draw self)
  (tell #:type _bool (coerce-arg self) canDraw))
(define (nstextfield-can-draw-concurrently self)
  (tell #:type _bool (coerce-arg self) canDrawConcurrently))
(define (nstextfield-set-can-draw-concurrently! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setCanDrawConcurrently:") value))
(define (nstextfield-can-draw-subviews-into-layer self)
  (tell #:type _bool (coerce-arg self) canDrawSubviewsIntoLayer))
(define (nstextfield-set-can-draw-subviews-into-layer! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setCanDrawSubviewsIntoLayer:") value))
(define (nstextfield-candidate-list-touch-bar-item self)
  (wrap-objc-object
   (tell (coerce-arg self) candidateListTouchBarItem)))
(define (nstextfield-cell self)
  (wrap-objc-object
   (tell (coerce-arg self) cell)))
(define (nstextfield-set-cell! self value)
  (tell #:type _void (coerce-arg self) setCell: (coerce-arg value)))
(define (nstextfield-cell-class)
  (tell #:type _pointer NSTextField cellClass))
(define (nstextfield-set-cell-class! value)
  (_msg-35 NSTextField (sel_registerName "setCellClass:") value))
(define (nstextfield-center-x-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) centerXAnchor)))
(define (nstextfield-center-y-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) centerYAnchor)))
(define (nstextfield-clips-to-bounds self)
  (tell #:type _bool (coerce-arg self) clipsToBounds))
(define (nstextfield-set-clips-to-bounds! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setClipsToBounds:") value))
(define (nstextfield-compatible-with-responsive-scrolling)
  (tell #:type _bool NSTextField compatibleWithResponsiveScrolling))
(define (nstextfield-compositing-filter self)
  (wrap-objc-object
   (tell (coerce-arg self) compositingFilter)))
(define (nstextfield-set-compositing-filter! self value)
  (tell #:type _void (coerce-arg self) setCompositingFilter: (coerce-arg value)))
(define (nstextfield-constraints self)
  (wrap-objc-object
   (tell (coerce-arg self) constraints)))
(define (nstextfield-content-filters self)
  (wrap-objc-object
   (tell (coerce-arg self) contentFilters)))
(define (nstextfield-set-content-filters! self value)
  (tell #:type _void (coerce-arg self) setContentFilters: (coerce-arg value)))
(define (nstextfield-continuous self)
  (tell #:type _bool (coerce-arg self) continuous))
(define (nstextfield-set-continuous! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setContinuous:") value))
(define (nstextfield-control-size self)
  (tell #:type _uint64 (coerce-arg self) controlSize))
(define (nstextfield-set-control-size! self value)
  (_msg-41 (coerce-arg self) (sel_registerName "setControlSize:") value))
(define (nstextfield-default-focus-ring-type)
  (tell #:type _uint64 NSTextField defaultFocusRingType))
(define (nstextfield-default-menu)
  (wrap-objc-object
   (tell NSTextField defaultMenu)))
(define (nstextfield-delegate self)
  (wrap-objc-object
   (tell (coerce-arg self) delegate)))
(define (nstextfield-set-delegate! self value)
  (tell #:type _void (coerce-arg self) setDelegate: (coerce-arg value)))
(define (nstextfield-double-value self)
  (tell #:type _double (coerce-arg self) doubleValue))
(define (nstextfield-set-double-value! self value)
  (_msg-28 (coerce-arg self) (sel_registerName "setDoubleValue:") value))
(define (nstextfield-drawing-find-indicator self)
  (tell #:type _bool (coerce-arg self) drawingFindIndicator))
(define (nstextfield-draws-background self)
  (tell #:type _bool (coerce-arg self) drawsBackground))
(define (nstextfield-set-draws-background! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setDrawsBackground:") value))
(define (nstextfield-editable self)
  (tell #:type _bool (coerce-arg self) editable))
(define (nstextfield-set-editable! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setEditable:") value))
(define (nstextfield-enabled self)
  (tell #:type _bool (coerce-arg self) enabled))
(define (nstextfield-set-enabled! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setEnabled:") value))
(define (nstextfield-enclosing-menu-item self)
  (wrap-objc-object
   (tell (coerce-arg self) enclosingMenuItem)))
(define (nstextfield-enclosing-scroll-view self)
  (wrap-objc-object
   (tell (coerce-arg self) enclosingScrollView)))
(define (nstextfield-first-baseline-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) firstBaselineAnchor)))
(define (nstextfield-first-baseline-offset-from-top self)
  (tell #:type _double (coerce-arg self) firstBaselineOffsetFromTop))
(define (nstextfield-fitting-size self)
  (tell #:type _NSSize (coerce-arg self) fittingSize))
(define (nstextfield-flipped self)
  (tell #:type _bool (coerce-arg self) flipped))
(define (nstextfield-float-value self)
  (tell #:type _float (coerce-arg self) floatValue))
(define (nstextfield-set-float-value! self value)
  (_msg-29 (coerce-arg self) (sel_registerName "setFloatValue:") value))
(define (nstextfield-focus-ring-mask-bounds self)
  (tell #:type _NSRect (coerce-arg self) focusRingMaskBounds))
(define (nstextfield-focus-ring-type self)
  (tell #:type _uint64 (coerce-arg self) focusRingType))
(define (nstextfield-set-focus-ring-type! self value)
  (_msg-41 (coerce-arg self) (sel_registerName "setFocusRingType:") value))
(define (nstextfield-focus-view)
  (wrap-objc-object
   (tell NSTextField focusView)))
(define (nstextfield-font self)
  (wrap-objc-object
   (tell (coerce-arg self) font)))
(define (nstextfield-set-font! self value)
  (tell #:type _void (coerce-arg self) setFont: (coerce-arg value)))
(define (nstextfield-formatter self)
  (wrap-objc-object
   (tell (coerce-arg self) formatter)))
(define (nstextfield-set-formatter! self value)
  (tell #:type _void (coerce-arg self) setFormatter: (coerce-arg value)))
(define (nstextfield-frame self)
  (tell #:type _NSRect (coerce-arg self) frame))
(define (nstextfield-set-frame! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setFrame:") value))
(define (nstextfield-frame-center-rotation self)
  (tell #:type _double (coerce-arg self) frameCenterRotation))
(define (nstextfield-set-frame-center-rotation! self value)
  (_msg-28 (coerce-arg self) (sel_registerName "setFrameCenterRotation:") value))
(define (nstextfield-frame-rotation self)
  (tell #:type _double (coerce-arg self) frameRotation))
(define (nstextfield-set-frame-rotation! self value)
  (_msg-28 (coerce-arg self) (sel_registerName "setFrameRotation:") value))
(define (nstextfield-gesture-recognizers self)
  (wrap-objc-object
   (tell (coerce-arg self) gestureRecognizers)))
(define (nstextfield-set-gesture-recognizers! self value)
  (tell #:type _void (coerce-arg self) setGestureRecognizers: (coerce-arg value)))
(define (nstextfield-has-ambiguous-layout self)
  (tell #:type _bool (coerce-arg self) hasAmbiguousLayout))
(define (nstextfield-height-adjust-limit self)
  (tell #:type _double (coerce-arg self) heightAdjustLimit))
(define (nstextfield-height-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) heightAnchor)))
(define (nstextfield-hidden self)
  (tell #:type _bool (coerce-arg self) hidden))
(define (nstextfield-set-hidden! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setHidden:") value))
(define (nstextfield-hidden-or-has-hidden-ancestor self)
  (tell #:type _bool (coerce-arg self) hiddenOrHasHiddenAncestor))
(define (nstextfield-highlighted self)
  (tell #:type _bool (coerce-arg self) highlighted))
(define (nstextfield-set-highlighted! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setHighlighted:") value))
(define (nstextfield-horizontal-content-size-constraint-active self)
  (tell #:type _bool (coerce-arg self) horizontalContentSizeConstraintActive))
(define (nstextfield-set-horizontal-content-size-constraint-active! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setHorizontalContentSizeConstraintActive:") value))
(define (nstextfield-ignores-multi-click self)
  (tell #:type _bool (coerce-arg self) ignoresMultiClick))
(define (nstextfield-set-ignores-multi-click! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setIgnoresMultiClick:") value))
(define (nstextfield-imports-graphics self)
  (tell #:type _bool (coerce-arg self) importsGraphics))
(define (nstextfield-set-imports-graphics! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setImportsGraphics:") value))
(define (nstextfield-in-full-screen-mode self)
  (tell #:type _bool (coerce-arg self) inFullScreenMode))
(define (nstextfield-in-live-resize self)
  (tell #:type _bool (coerce-arg self) inLiveResize))
(define (nstextfield-input-context self)
  (wrap-objc-object
   (tell (coerce-arg self) inputContext)))
(define (nstextfield-int-value self)
  (tell #:type _int32 (coerce-arg self) intValue))
(define (nstextfield-set-int-value! self value)
  (_msg-32 (coerce-arg self) (sel_registerName "setIntValue:") value))
(define (nstextfield-integer-value self)
  (tell #:type _int64 (coerce-arg self) integerValue))
(define (nstextfield-set-integer-value! self value)
  (_msg-34 (coerce-arg self) (sel_registerName "setIntegerValue:") value))
(define (nstextfield-intrinsic-content-size self)
  (tell #:type _NSSize (coerce-arg self) intrinsicContentSize))
(define (nstextfield-last-baseline-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) lastBaselineAnchor)))
(define (nstextfield-last-baseline-offset-from-bottom self)
  (tell #:type _double (coerce-arg self) lastBaselineOffsetFromBottom))
(define (nstextfield-layer self)
  (wrap-objc-object
   (tell (coerce-arg self) layer)))
(define (nstextfield-set-layer! self value)
  (tell #:type _void (coerce-arg self) setLayer: (coerce-arg value)))
(define (nstextfield-layer-contents-placement self)
  (tell #:type _uint64 (coerce-arg self) layerContentsPlacement))
(define (nstextfield-set-layer-contents-placement! self value)
  (_msg-41 (coerce-arg self) (sel_registerName "setLayerContentsPlacement:") value))
(define (nstextfield-layer-contents-redraw-policy self)
  (tell #:type _uint64 (coerce-arg self) layerContentsRedrawPolicy))
(define (nstextfield-set-layer-contents-redraw-policy! self value)
  (_msg-41 (coerce-arg self) (sel_registerName "setLayerContentsRedrawPolicy:") value))
(define (nstextfield-layer-uses-core-image-filters self)
  (tell #:type _bool (coerce-arg self) layerUsesCoreImageFilters))
(define (nstextfield-set-layer-uses-core-image-filters! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setLayerUsesCoreImageFilters:") value))
(define (nstextfield-layout-guides self)
  (wrap-objc-object
   (tell (coerce-arg self) layoutGuides)))
(define (nstextfield-layout-margins-guide self)
  (wrap-objc-object
   (tell (coerce-arg self) layoutMarginsGuide)))
(define (nstextfield-leading-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) leadingAnchor)))
(define (nstextfield-left-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) leftAnchor)))
(define (nstextfield-line-break-mode self)
  (tell #:type _uint64 (coerce-arg self) lineBreakMode))
(define (nstextfield-set-line-break-mode! self value)
  (_msg-41 (coerce-arg self) (sel_registerName "setLineBreakMode:") value))
(define (nstextfield-line-break-strategy self)
  (tell #:type _uint64 (coerce-arg self) lineBreakStrategy))
(define (nstextfield-set-line-break-strategy! self value)
  (_msg-41 (coerce-arg self) (sel_registerName "setLineBreakStrategy:") value))
(define (nstextfield-maximum-number-of-lines self)
  (tell #:type _int64 (coerce-arg self) maximumNumberOfLines))
(define (nstextfield-set-maximum-number-of-lines! self value)
  (_msg-34 (coerce-arg self) (sel_registerName "setMaximumNumberOfLines:") value))
(define (nstextfield-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) menu)))
(define (nstextfield-set-menu! self value)
  (tell #:type _void (coerce-arg self) setMenu: (coerce-arg value)))
(define (nstextfield-mouse-down-can-move-window self)
  (tell #:type _bool (coerce-arg self) mouseDownCanMoveWindow))
(define (nstextfield-needs-display self)
  (tell #:type _bool (coerce-arg self) needsDisplay))
(define (nstextfield-set-needs-display! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setNeedsDisplay:") value))
(define (nstextfield-needs-layout self)
  (tell #:type _bool (coerce-arg self) needsLayout))
(define (nstextfield-set-needs-layout! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setNeedsLayout:") value))
(define (nstextfield-needs-panel-to-become-key self)
  (tell #:type _bool (coerce-arg self) needsPanelToBecomeKey))
(define (nstextfield-needs-update-constraints self)
  (tell #:type _bool (coerce-arg self) needsUpdateConstraints))
(define (nstextfield-set-needs-update-constraints! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setNeedsUpdateConstraints:") value))
(define (nstextfield-next-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) nextKeyView)))
(define (nstextfield-set-next-key-view! self value)
  (tell #:type _void (coerce-arg self) setNextKeyView: (coerce-arg value)))
(define (nstextfield-next-responder self)
  (wrap-objc-object
   (tell (coerce-arg self) nextResponder)))
(define (nstextfield-set-next-responder! self value)
  (tell #:type _void (coerce-arg self) setNextResponder: (coerce-arg value)))
(define (nstextfield-next-valid-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) nextValidKeyView)))
(define (nstextfield-object-value self)
  (wrap-objc-object
   (tell (coerce-arg self) objectValue)))
(define (nstextfield-set-object-value! self value)
  (tell #:type _void (coerce-arg self) setObjectValue: (coerce-arg value)))
(define (nstextfield-opaque self)
  (tell #:type _bool (coerce-arg self) opaque))
(define (nstextfield-opaque-ancestor self)
  (wrap-objc-object
   (tell (coerce-arg self) opaqueAncestor)))
(define (nstextfield-page-footer self)
  (wrap-objc-object
   (tell (coerce-arg self) pageFooter)))
(define (nstextfield-page-header self)
  (wrap-objc-object
   (tell (coerce-arg self) pageHeader)))
(define (nstextfield-placeholder-attributed-string self)
  (wrap-objc-object
   (tell (coerce-arg self) placeholderAttributedString)))
(define (nstextfield-set-placeholder-attributed-string! self value)
  (tell #:type _void (coerce-arg self) setPlaceholderAttributedString: (coerce-arg value)))
(define (nstextfield-placeholder-attributed-strings self)
  (wrap-objc-object
   (tell (coerce-arg self) placeholderAttributedStrings)))
(define (nstextfield-set-placeholder-attributed-strings! self value)
  (tell #:type _void (coerce-arg self) setPlaceholderAttributedStrings: (coerce-arg value)))
(define (nstextfield-placeholder-string self)
  (wrap-objc-object
   (tell (coerce-arg self) placeholderString)))
(define (nstextfield-set-placeholder-string! self value)
  (tell #:type _void (coerce-arg self) setPlaceholderString: (coerce-arg value)))
(define (nstextfield-placeholder-strings self)
  (wrap-objc-object
   (tell (coerce-arg self) placeholderStrings)))
(define (nstextfield-set-placeholder-strings! self value)
  (tell #:type _void (coerce-arg self) setPlaceholderStrings: (coerce-arg value)))
(define (nstextfield-posts-bounds-changed-notifications self)
  (tell #:type _bool (coerce-arg self) postsBoundsChangedNotifications))
(define (nstextfield-set-posts-bounds-changed-notifications! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setPostsBoundsChangedNotifications:") value))
(define (nstextfield-posts-frame-changed-notifications self)
  (tell #:type _bool (coerce-arg self) postsFrameChangedNotifications))
(define (nstextfield-set-posts-frame-changed-notifications! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setPostsFrameChangedNotifications:") value))
(define (nstextfield-preferred-max-layout-width self)
  (tell #:type _double (coerce-arg self) preferredMaxLayoutWidth))
(define (nstextfield-set-preferred-max-layout-width! self value)
  (_msg-28 (coerce-arg self) (sel_registerName "setPreferredMaxLayoutWidth:") value))
(define (nstextfield-prefers-compact-control-size-metrics self)
  (tell #:type _bool (coerce-arg self) prefersCompactControlSizeMetrics))
(define (nstextfield-set-prefers-compact-control-size-metrics! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setPrefersCompactControlSizeMetrics:") value))
(define (nstextfield-prepared-content-rect self)
  (tell #:type _NSRect (coerce-arg self) preparedContentRect))
(define (nstextfield-set-prepared-content-rect! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setPreparedContentRect:") value))
(define (nstextfield-preserves-content-during-live-resize self)
  (tell #:type _bool (coerce-arg self) preservesContentDuringLiveResize))
(define (nstextfield-pressure-configuration self)
  (wrap-objc-object
   (tell (coerce-arg self) pressureConfiguration)))
(define (nstextfield-set-pressure-configuration! self value)
  (tell #:type _void (coerce-arg self) setPressureConfiguration: (coerce-arg value)))
(define (nstextfield-previous-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) previousKeyView)))
(define (nstextfield-previous-valid-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) previousValidKeyView)))
(define (nstextfield-print-job-title self)
  (wrap-objc-object
   (tell (coerce-arg self) printJobTitle)))
(define (nstextfield-rect-preserved-during-live-resize self)
  (tell #:type _NSRect (coerce-arg self) rectPreservedDuringLiveResize))
(define (nstextfield-refuses-first-responder self)
  (tell #:type _bool (coerce-arg self) refusesFirstResponder))
(define (nstextfield-set-refuses-first-responder! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setRefusesFirstResponder:") value))
(define (nstextfield-registered-dragged-types self)
  (wrap-objc-object
   (tell (coerce-arg self) registeredDraggedTypes)))
(define (nstextfield-requires-constraint-based-layout)
  (tell #:type _bool NSTextField requiresConstraintBasedLayout))
(define (nstextfield-resolves-natural-alignment-with-base-writing-direction self)
  (tell #:type _bool (coerce-arg self) resolvesNaturalAlignmentWithBaseWritingDirection))
(define (nstextfield-set-resolves-natural-alignment-with-base-writing-direction! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setResolvesNaturalAlignmentWithBaseWritingDirection:") value))
(define (nstextfield-restorable-state-key-paths)
  (wrap-objc-object
   (tell NSTextField restorableStateKeyPaths)))
(define (nstextfield-right-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) rightAnchor)))
(define (nstextfield-rotated-from-base self)
  (tell #:type _bool (coerce-arg self) rotatedFromBase))
(define (nstextfield-rotated-or-scaled-from-base self)
  (tell #:type _bool (coerce-arg self) rotatedOrScaledFromBase))
(define (nstextfield-safe-area-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) safeAreaInsets))
(define (nstextfield-safe-area-layout-guide self)
  (wrap-objc-object
   (tell (coerce-arg self) safeAreaLayoutGuide)))
(define (nstextfield-safe-area-rect self)
  (tell #:type _NSRect (coerce-arg self) safeAreaRect))
(define (nstextfield-selectable self)
  (tell #:type _bool (coerce-arg self) selectable))
(define (nstextfield-set-selectable! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setSelectable:") value))
(define (nstextfield-shadow self)
  (wrap-objc-object
   (tell (coerce-arg self) shadow)))
(define (nstextfield-set-shadow! self value)
  (tell #:type _void (coerce-arg self) setShadow: (coerce-arg value)))
(define (nstextfield-string-value self)
  (wrap-objc-object
   (tell (coerce-arg self) stringValue)))
(define (nstextfield-set-string-value! self value)
  (tell #:type _void (coerce-arg self) setStringValue: (coerce-arg value)))
(define (nstextfield-subviews self)
  (wrap-objc-object
   (tell (coerce-arg self) subviews)))
(define (nstextfield-set-subviews! self value)
  (tell #:type _void (coerce-arg self) setSubviews: (coerce-arg value)))
(define (nstextfield-suggestions-delegate self)
  (wrap-objc-object
   (tell (coerce-arg self) suggestionsDelegate)))
(define (nstextfield-set-suggestions-delegate! self value)
  (tell #:type _void (coerce-arg self) setSuggestionsDelegate: (coerce-arg value)))
(define (nstextfield-superview self)
  (wrap-objc-object
   (tell (coerce-arg self) superview)))
(define (nstextfield-tag self)
  (tell #:type _int64 (coerce-arg self) tag))
(define (nstextfield-set-tag! self value)
  (_msg-34 (coerce-arg self) (sel_registerName "setTag:") value))
(define (nstextfield-target self)
  (wrap-objc-object
   (tell (coerce-arg self) target)))
(define (nstextfield-set-target! self value)
  (tell #:type _void (coerce-arg self) setTarget: (coerce-arg value)))
(define (nstextfield-text-color self)
  (wrap-objc-object
   (tell (coerce-arg self) textColor)))
(define (nstextfield-set-text-color! self value)
  (tell #:type _void (coerce-arg self) setTextColor: (coerce-arg value)))
(define (nstextfield-tool-tip self)
  (wrap-objc-object
   (tell (coerce-arg self) toolTip)))
(define (nstextfield-set-tool-tip! self value)
  (tell #:type _void (coerce-arg self) setToolTip: (coerce-arg value)))
(define (nstextfield-top-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) topAnchor)))
(define (nstextfield-touch-bar self)
  (wrap-objc-object
   (tell (coerce-arg self) touchBar)))
(define (nstextfield-set-touch-bar! self value)
  (tell #:type _void (coerce-arg self) setTouchBar: (coerce-arg value)))
(define (nstextfield-tracking-areas self)
  (wrap-objc-object
   (tell (coerce-arg self) trackingAreas)))
(define (nstextfield-trailing-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) trailingAnchor)))
(define (nstextfield-translates-autoresizing-mask-into-constraints self)
  (tell #:type _bool (coerce-arg self) translatesAutoresizingMaskIntoConstraints))
(define (nstextfield-set-translates-autoresizing-mask-into-constraints! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setTranslatesAutoresizingMaskIntoConstraints:") value))
(define (nstextfield-undo-manager self)
  (wrap-objc-object
   (tell (coerce-arg self) undoManager)))
(define (nstextfield-user-activity self)
  (wrap-objc-object
   (tell (coerce-arg self) userActivity)))
(define (nstextfield-set-user-activity! self value)
  (tell #:type _void (coerce-arg self) setUserActivity: (coerce-arg value)))
(define (nstextfield-user-interface-layout-direction self)
  (tell #:type _uint64 (coerce-arg self) userInterfaceLayoutDirection))
(define (nstextfield-set-user-interface-layout-direction! self value)
  (_msg-41 (coerce-arg self) (sel_registerName "setUserInterfaceLayoutDirection:") value))
(define (nstextfield-uses-single-line-mode self)
  (tell #:type _bool (coerce-arg self) usesSingleLineMode))
(define (nstextfield-set-uses-single-line-mode! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setUsesSingleLineMode:") value))
(define (nstextfield-vertical-content-size-constraint-active self)
  (tell #:type _bool (coerce-arg self) verticalContentSizeConstraintActive))
(define (nstextfield-set-vertical-content-size-constraint-active! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setVerticalContentSizeConstraintActive:") value))
(define (nstextfield-visible-rect self)
  (tell #:type _NSRect (coerce-arg self) visibleRect))
(define (nstextfield-wants-best-resolution-open-gl-surface self)
  (tell #:type _bool (coerce-arg self) wantsBestResolutionOpenGLSurface))
(define (nstextfield-set-wants-best-resolution-open-gl-surface! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setWantsBestResolutionOpenGLSurface:") value))
(define (nstextfield-wants-default-clipping self)
  (tell #:type _bool (coerce-arg self) wantsDefaultClipping))
(define (nstextfield-wants-extended-dynamic-range-open-gl-surface self)
  (tell #:type _bool (coerce-arg self) wantsExtendedDynamicRangeOpenGLSurface))
(define (nstextfield-set-wants-extended-dynamic-range-open-gl-surface! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setWantsExtendedDynamicRangeOpenGLSurface:") value))
(define (nstextfield-wants-layer self)
  (tell #:type _bool (coerce-arg self) wantsLayer))
(define (nstextfield-set-wants-layer! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setWantsLayer:") value))
(define (nstextfield-wants-resting-touches self)
  (tell #:type _bool (coerce-arg self) wantsRestingTouches))
(define (nstextfield-set-wants-resting-touches! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setWantsRestingTouches:") value))
(define (nstextfield-wants-update-layer self)
  (tell #:type _bool (coerce-arg self) wantsUpdateLayer))
(define (nstextfield-width-adjust-limit self)
  (tell #:type _double (coerce-arg self) widthAdjustLimit))
(define (nstextfield-width-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) widthAnchor)))
(define (nstextfield-window self)
  (wrap-objc-object
   (tell (coerce-arg self) window)))
(define (nstextfield-writing-tools-coordinator self)
  (wrap-objc-object
   (tell (coerce-arg self) writingToolsCoordinator)))
(define (nstextfield-set-writing-tools-coordinator! self value)
  (tell #:type _void (coerce-arg self) setWritingToolsCoordinator: (coerce-arg value)))

;; --- Instance methods ---
(define (nstextfield-accepts-first-mouse self event)
  (_msg-30 (coerce-arg self) (sel_registerName "acceptsFirstMouse:") (coerce-arg event)))
(define (nstextfield-add-subview! self view)
  (tell #:type _void (coerce-arg self) addSubview: (coerce-arg view)))
(define (nstextfield-add-subview-positioned-relative-to! self view place other-view)
  (_msg-31 (coerce-arg self) (sel_registerName "addSubview:positioned:relativeTo:") (coerce-arg view) place (coerce-arg other-view)))
(define (nstextfield-add-tool-tip-rect-owner-user-data! self rect owner data)
  (_msg-22 (coerce-arg self) (sel_registerName "addToolTipRect:owner:userData:") rect (coerce-arg owner) data))
(define (nstextfield-adjust-scroll self new-visible)
  (_msg-15 (coerce-arg self) (sel_registerName "adjustScroll:") new-visible))
(define (nstextfield-ancestor-shared-with-view self view)
  (wrap-objc-object
   (tell (coerce-arg self) ancestorSharedWithView: (coerce-arg view))))
(define (nstextfield-autoscroll self event)
  (_msg-30 (coerce-arg self) (sel_registerName "autoscroll:") (coerce-arg event)))
(define (nstextfield-backing-aligned-rect-options self rect options)
  (_msg-23 (coerce-arg self) (sel_registerName "backingAlignedRect:options:") rect options))
(define (nstextfield-become-first-responder self)
  (_msg-1 (coerce-arg self) (sel_registerName "becomeFirstResponder")))
(define (nstextfield-begin-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) beginGestureWithEvent: (coerce-arg event)))
(define (nstextfield-bitmap-image-rep-for-caching-display-in-rect self rect)
  (wrap-objc-object
   (_msg-17 (coerce-arg self) (sel_registerName "bitmapImageRepForCachingDisplayInRect:") rect)
   ))
(define (nstextfield-cache-display-in-rect-to-bitmap-image-rep self rect bitmap-image-rep)
  (_msg-21 (coerce-arg self) (sel_registerName "cacheDisplayInRect:toBitmapImageRep:") rect (coerce-arg bitmap-image-rep)))
(define (nstextfield-center-scan-rect! self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "centerScanRect:") rect))
(define (nstextfield-change-mode-with-event self event)
  (tell #:type _void (coerce-arg self) changeModeWithEvent: (coerce-arg event)))
(define (nstextfield-context-menu-key-down self event)
  (tell #:type _void (coerce-arg self) contextMenuKeyDown: (coerce-arg event)))
(define (nstextfield-convert-point-from-view self point view)
  (_msg-14 (coerce-arg self) (sel_registerName "convertPoint:fromView:") point (coerce-arg view)))
(define (nstextfield-convert-point-to-view self point view)
  (_msg-14 (coerce-arg self) (sel_registerName "convertPoint:toView:") point (coerce-arg view)))
(define (nstextfield-convert-point-from-backing self point)
  (_msg-9 (coerce-arg self) (sel_registerName "convertPointFromBacking:") point))
(define (nstextfield-convert-point-from-layer self point)
  (_msg-9 (coerce-arg self) (sel_registerName "convertPointFromLayer:") point))
(define (nstextfield-convert-point-to-backing self point)
  (_msg-9 (coerce-arg self) (sel_registerName "convertPointToBacking:") point))
(define (nstextfield-convert-point-to-layer self point)
  (_msg-9 (coerce-arg self) (sel_registerName "convertPointToLayer:") point))
(define (nstextfield-convert-rect-from-view self rect view)
  (_msg-20 (coerce-arg self) (sel_registerName "convertRect:fromView:") rect (coerce-arg view)))
(define (nstextfield-convert-rect-to-view self rect view)
  (_msg-20 (coerce-arg self) (sel_registerName "convertRect:toView:") rect (coerce-arg view)))
(define (nstextfield-convert-rect-from-backing self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "convertRectFromBacking:") rect))
(define (nstextfield-convert-rect-from-layer self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "convertRectFromLayer:") rect))
(define (nstextfield-convert-rect-to-backing self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "convertRectToBacking:") rect))
(define (nstextfield-convert-rect-to-layer self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "convertRectToLayer:") rect))
(define (nstextfield-convert-size-from-view self size view)
  (_msg-26 (coerce-arg self) (sel_registerName "convertSize:fromView:") size (coerce-arg view)))
(define (nstextfield-convert-size-to-view self size view)
  (_msg-26 (coerce-arg self) (sel_registerName "convertSize:toView:") size (coerce-arg view)))
(define (nstextfield-convert-size-from-backing self size)
  (_msg-24 (coerce-arg self) (sel_registerName "convertSizeFromBacking:") size))
(define (nstextfield-convert-size-from-layer self size)
  (_msg-24 (coerce-arg self) (sel_registerName "convertSizeFromLayer:") size))
(define (nstextfield-convert-size-to-backing self size)
  (_msg-24 (coerce-arg self) (sel_registerName "convertSizeToBacking:") size))
(define (nstextfield-convert-size-to-layer self size)
  (_msg-24 (coerce-arg self) (sel_registerName "convertSizeToLayer:") size))
(define (nstextfield-cursor-update self event)
  (tell #:type _void (coerce-arg self) cursorUpdate: (coerce-arg event)))
(define (nstextfield-did-add-subview self subview)
  (tell #:type _void (coerce-arg self) didAddSubview: (coerce-arg subview)))
(define (nstextfield-did-close-menu-with-event self menu event)
  (tell #:type _void (coerce-arg self) didCloseMenu: (coerce-arg menu) withEvent: (coerce-arg event)))
(define (nstextfield-display! self)
  (tell #:type _void (coerce-arg self) display))
(define (nstextfield-display-if-needed! self)
  (tell #:type _void (coerce-arg self) displayIfNeeded))
(define (nstextfield-display-if-needed-ignoring-opacity! self)
  (tell #:type _void (coerce-arg self) displayIfNeededIgnoringOpacity))
(define (nstextfield-display-if-needed-in-rect! self rect)
  (_msg-18 (coerce-arg self) (sel_registerName "displayIfNeededInRect:") rect))
(define (nstextfield-display-if-needed-in-rect-ignoring-opacity! self rect)
  (_msg-18 (coerce-arg self) (sel_registerName "displayIfNeededInRectIgnoringOpacity:") rect))
(define (nstextfield-display-rect! self rect)
  (_msg-18 (coerce-arg self) (sel_registerName "displayRect:") rect))
(define (nstextfield-display-rect-ignoring-opacity! self rect)
  (_msg-18 (coerce-arg self) (sel_registerName "displayRectIgnoringOpacity:") rect))
(define (nstextfield-display-rect-ignoring-opacity-in-context! self rect context)
  (_msg-21 (coerce-arg self) (sel_registerName "displayRectIgnoringOpacity:inContext:") rect (coerce-arg context)))
(define (nstextfield-draw-rect self dirty-rect)
  (_msg-18 (coerce-arg self) (sel_registerName "drawRect:") dirty-rect))
(define (nstextfield-draw-with-expansion-frame-in-view self content-frame view)
  (_msg-21 (coerce-arg self) (sel_registerName "drawWithExpansionFrame:inView:") content-frame (coerce-arg view)))
(define (nstextfield-end-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) endGestureWithEvent: (coerce-arg event)))
(define (nstextfield-expansion-frame-with-frame self content-frame)
  (_msg-15 (coerce-arg self) (sel_registerName "expansionFrameWithFrame:") content-frame))
(define (nstextfield-flags-changed self event)
  (tell #:type _void (coerce-arg self) flagsChanged: (coerce-arg event)))
(define (nstextfield-flush-buffered-key-events self)
  (tell #:type _void (coerce-arg self) flushBufferedKeyEvents))
(define (nstextfield-get-rects-being-drawn-count self rects count)
  (_msg-38 (coerce-arg self) (sel_registerName "getRectsBeingDrawn:count:") rects count))
(define (nstextfield-get-rects-exposed-during-live-resize-count self exposed-rects count)
  (_msg-38 (coerce-arg self) (sel_registerName "getRectsExposedDuringLiveResize:count:") exposed-rects count))
(define (nstextfield-help-requested self event-ptr)
  (tell #:type _void (coerce-arg self) helpRequested: (coerce-arg event-ptr)))
(define (nstextfield-hit-test self point)
  (wrap-objc-object
   (_msg-10 (coerce-arg self) (sel_registerName "hitTest:") point)
   ))
(define (nstextfield-interpret-key-events self event-array)
  (tell #:type _void (coerce-arg self) interpretKeyEvents: (coerce-arg event-array)))
(define (nstextfield-is-bezeled self)
  (_msg-1 (coerce-arg self) (sel_registerName "isBezeled")))
(define (nstextfield-is-bordered self)
  (_msg-1 (coerce-arg self) (sel_registerName "isBordered")))
(define (nstextfield-is-continuous self)
  (_msg-1 (coerce-arg self) (sel_registerName "isContinuous")))
(define (nstextfield-is-descendant-of self view)
  (_msg-30 (coerce-arg self) (sel_registerName "isDescendantOf:") (coerce-arg view)))
(define (nstextfield-is-editable self)
  (_msg-1 (coerce-arg self) (sel_registerName "isEditable")))
(define (nstextfield-is-enabled self)
  (_msg-1 (coerce-arg self) (sel_registerName "isEnabled")))
(define (nstextfield-is-flipped self)
  (_msg-1 (coerce-arg self) (sel_registerName "isFlipped")))
(define (nstextfield-is-hidden self)
  (_msg-1 (coerce-arg self) (sel_registerName "isHidden")))
(define (nstextfield-is-hidden-or-has-hidden-ancestor self)
  (_msg-1 (coerce-arg self) (sel_registerName "isHiddenOrHasHiddenAncestor")))
(define (nstextfield-is-highlighted self)
  (_msg-1 (coerce-arg self) (sel_registerName "isHighlighted")))
(define (nstextfield-is-opaque self)
  (_msg-1 (coerce-arg self) (sel_registerName "isOpaque")))
(define (nstextfield-is-rotated-from-base self)
  (_msg-1 (coerce-arg self) (sel_registerName "isRotatedFromBase")))
(define (nstextfield-is-rotated-or-scaled-from-base self)
  (_msg-1 (coerce-arg self) (sel_registerName "isRotatedOrScaledFromBase")))
(define (nstextfield-is-selectable self)
  (_msg-1 (coerce-arg self) (sel_registerName "isSelectable")))
(define (nstextfield-key-down self event)
  (tell #:type _void (coerce-arg self) keyDown: (coerce-arg event)))
(define (nstextfield-key-up self event)
  (tell #:type _void (coerce-arg self) keyUp: (coerce-arg event)))
(define (nstextfield-layout self)
  (tell #:type _void (coerce-arg self) layout))
(define (nstextfield-layout-subtree-if-needed self)
  (tell #:type _void (coerce-arg self) layoutSubtreeIfNeeded))
(define (nstextfield-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) magnifyWithEvent: (coerce-arg event)))
(define (nstextfield-make-backing-layer self)
  (wrap-objc-object
   (tell (coerce-arg self) makeBackingLayer)))
(define (nstextfield-menu-for-event self event)
  (wrap-objc-object
   (tell (coerce-arg self) menuForEvent: (coerce-arg event))))
(define (nstextfield-mouse-in-rect self point rect)
  (_msg-13 (coerce-arg self) (sel_registerName "mouse:inRect:") point rect))
(define (nstextfield-mouse-cancelled self event)
  (tell #:type _void (coerce-arg self) mouseCancelled: (coerce-arg event)))
(define (nstextfield-mouse-down self event)
  (tell #:type _void (coerce-arg self) mouseDown: (coerce-arg event)))
(define (nstextfield-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) mouseDragged: (coerce-arg event)))
(define (nstextfield-mouse-entered self event)
  (tell #:type _void (coerce-arg self) mouseEntered: (coerce-arg event)))
(define (nstextfield-mouse-exited self event)
  (tell #:type _void (coerce-arg self) mouseExited: (coerce-arg event)))
(define (nstextfield-mouse-moved self event)
  (tell #:type _void (coerce-arg self) mouseMoved: (coerce-arg event)))
(define (nstextfield-mouse-up self event)
  (tell #:type _void (coerce-arg self) mouseUp: (coerce-arg event)))
(define (nstextfield-needs-to-draw-rect self rect)
  (_msg-16 (coerce-arg self) (sel_registerName "needsToDrawRect:") rect))
(define (nstextfield-no-responder-for self event-selector)
  (_msg-35 (coerce-arg self) (sel_registerName "noResponderFor:") event-selector))
(define (nstextfield-other-mouse-down self event)
  (tell #:type _void (coerce-arg self) otherMouseDown: (coerce-arg event)))
(define (nstextfield-other-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) otherMouseDragged: (coerce-arg event)))
(define (nstextfield-other-mouse-up self event)
  (tell #:type _void (coerce-arg self) otherMouseUp: (coerce-arg event)))
(define (nstextfield-perform-click! self sender)
  (tell #:type _void (coerce-arg self) performClick: (coerce-arg sender)))
(define (nstextfield-perform-key-equivalent! self event)
  (_msg-30 (coerce-arg self) (sel_registerName "performKeyEquivalent:") (coerce-arg event)))
(define (nstextfield-prepare-content-in-rect self rect)
  (_msg-18 (coerce-arg self) (sel_registerName "prepareContentInRect:") rect))
(define (nstextfield-prepare-for-reuse self)
  (tell #:type _void (coerce-arg self) prepareForReuse))
(define (nstextfield-pressure-change-with-event self event)
  (tell #:type _void (coerce-arg self) pressureChangeWithEvent: (coerce-arg event)))
(define (nstextfield-quick-look-with-event self event)
  (tell #:type _void (coerce-arg self) quickLookWithEvent: (coerce-arg event)))
(define (nstextfield-rect-for-smart-magnification-at-point-in-rect self location visible-rect)
  (_msg-12 (coerce-arg self) (sel_registerName "rectForSmartMagnificationAtPoint:inRect:") location visible-rect))
(define (nstextfield-remove-all-tool-tips! self)
  (tell #:type _void (coerce-arg self) removeAllToolTips))
(define (nstextfield-remove-from-superview! self)
  (tell #:type _void (coerce-arg self) removeFromSuperview))
(define (nstextfield-remove-from-superview-without-needing-display! self)
  (tell #:type _void (coerce-arg self) removeFromSuperviewWithoutNeedingDisplay))
(define (nstextfield-remove-tool-tip! self tag)
  (_msg-34 (coerce-arg self) (sel_registerName "removeToolTip:") tag))
(define (nstextfield-replace-subview-with! self old-view new-view)
  (tell #:type _void (coerce-arg self) replaceSubview: (coerce-arg old-view) with: (coerce-arg new-view)))
(define (nstextfield-resign-first-responder self)
  (_msg-1 (coerce-arg self) (sel_registerName "resignFirstResponder")))
(define (nstextfield-resize-subviews-with-old-size self old-size)
  (_msg-25 (coerce-arg self) (sel_registerName "resizeSubviewsWithOldSize:") old-size))
(define (nstextfield-resize-with-old-superview-size self old-size)
  (_msg-25 (coerce-arg self) (sel_registerName "resizeWithOldSuperviewSize:") old-size))
(define (nstextfield-right-mouse-down self event)
  (tell #:type _void (coerce-arg self) rightMouseDown: (coerce-arg event)))
(define (nstextfield-right-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) rightMouseDragged: (coerce-arg event)))
(define (nstextfield-right-mouse-up self event)
  (tell #:type _void (coerce-arg self) rightMouseUp: (coerce-arg event)))
(define (nstextfield-rotate-by-angle self angle)
  (_msg-28 (coerce-arg self) (sel_registerName "rotateByAngle:") angle))
(define (nstextfield-rotate-with-event self event)
  (tell #:type _void (coerce-arg self) rotateWithEvent: (coerce-arg event)))
(define (nstextfield-scale-unit-square-to-size self new-unit-size)
  (_msg-25 (coerce-arg self) (sel_registerName "scaleUnitSquareToSize:") new-unit-size))
(define (nstextfield-scroll-point self point)
  (_msg-11 (coerce-arg self) (sel_registerName "scrollPoint:") point))
(define (nstextfield-scroll-rect-to-visible self rect)
  (_msg-16 (coerce-arg self) (sel_registerName "scrollRectToVisible:") rect))
(define (nstextfield-scroll-wheel self event)
  (tell #:type _void (coerce-arg self) scrollWheel: (coerce-arg event)))
(define (nstextfield-select-text self sender)
  (tell #:type _void (coerce-arg self) selectText: (coerce-arg sender)))
(define (nstextfield-send-action-to self action target)
  (_msg-36 (coerce-arg self) (sel_registerName "sendAction:to:") action (coerce-arg target)))
(define (nstextfield-send-action-on self mask)
  (_msg-40 (coerce-arg self) (sel_registerName "sendActionOn:") mask))
(define (nstextfield-set-bounds-origin! self new-origin)
  (_msg-11 (coerce-arg self) (sel_registerName "setBoundsOrigin:") new-origin))
(define (nstextfield-set-bounds-size! self new-size)
  (_msg-25 (coerce-arg self) (sel_registerName "setBoundsSize:") new-size))
(define (nstextfield-set-frame-origin! self new-origin)
  (_msg-11 (coerce-arg self) (sel_registerName "setFrameOrigin:") new-origin))
(define (nstextfield-set-frame-size! self new-size)
  (_msg-25 (coerce-arg self) (sel_registerName "setFrameSize:") new-size))
(define (nstextfield-set-needs-display-in-rect! self invalid-rect)
  (_msg-18 (coerce-arg self) (sel_registerName "setNeedsDisplayInRect:") invalid-rect))
(define (nstextfield-should-be-treated-as-ink-event self event)
  (_msg-30 (coerce-arg self) (sel_registerName "shouldBeTreatedAsInkEvent:") (coerce-arg event)))
(define (nstextfield-should-delay-window-ordering-for-event self event)
  (_msg-30 (coerce-arg self) (sel_registerName "shouldDelayWindowOrderingForEvent:") (coerce-arg event)))
(define (nstextfield-show-context-help self sender)
  (tell #:type _void (coerce-arg self) showContextHelp: (coerce-arg sender)))
(define (nstextfield-size-that-fits self size)
  (_msg-24 (coerce-arg self) (sel_registerName "sizeThatFits:") size))
(define (nstextfield-size-to-fit self)
  (tell #:type _void (coerce-arg self) sizeToFit))
(define (nstextfield-smart-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) smartMagnifyWithEvent: (coerce-arg event)))
(define (nstextfield-sort-subviews-using-function-context self compare context)
  (_msg-38 (coerce-arg self) (sel_registerName "sortSubviewsUsingFunction:context:") compare context))
(define (nstextfield-supplemental-target-for-action-sender self action sender)
  (wrap-objc-object
   (_msg-37 (coerce-arg self) (sel_registerName "supplementalTargetForAction:sender:") action (coerce-arg sender))
   ))
(define (nstextfield-swipe-with-event self event)
  (tell #:type _void (coerce-arg self) swipeWithEvent: (coerce-arg event)))
(define (nstextfield-tablet-point self event)
  (tell #:type _void (coerce-arg self) tabletPoint: (coerce-arg event)))
(define (nstextfield-tablet-proximity self event)
  (tell #:type _void (coerce-arg self) tabletProximity: (coerce-arg event)))
(define (nstextfield-take-double-value-from self sender)
  (tell #:type _void (coerce-arg self) takeDoubleValueFrom: (coerce-arg sender)))
(define (nstextfield-take-float-value-from self sender)
  (tell #:type _void (coerce-arg self) takeFloatValueFrom: (coerce-arg sender)))
(define (nstextfield-take-int-value-from self sender)
  (tell #:type _void (coerce-arg self) takeIntValueFrom: (coerce-arg sender)))
(define (nstextfield-take-integer-value-from self sender)
  (tell #:type _void (coerce-arg self) takeIntegerValueFrom: (coerce-arg sender)))
(define (nstextfield-take-object-value-from self sender)
  (tell #:type _void (coerce-arg self) takeObjectValueFrom: (coerce-arg sender)))
(define (nstextfield-take-string-value-from self sender)
  (tell #:type _void (coerce-arg self) takeStringValueFrom: (coerce-arg sender)))
(define (nstextfield-text-did-begin-editing self notification)
  (tell #:type _void (coerce-arg self) textDidBeginEditing: (coerce-arg notification)))
(define (nstextfield-text-did-change self notification)
  (tell #:type _void (coerce-arg self) textDidChange: (coerce-arg notification)))
(define (nstextfield-text-did-end-editing self notification)
  (tell #:type _void (coerce-arg self) textDidEndEditing: (coerce-arg notification)))
(define (nstextfield-text-should-begin-editing self text-object)
  (_msg-30 (coerce-arg self) (sel_registerName "textShouldBeginEditing:") (coerce-arg text-object)))
(define (nstextfield-text-should-end-editing self text-object)
  (_msg-30 (coerce-arg self) (sel_registerName "textShouldEndEditing:") (coerce-arg text-object)))
(define (nstextfield-touches-began-with-event self event)
  (tell #:type _void (coerce-arg self) touchesBeganWithEvent: (coerce-arg event)))
(define (nstextfield-touches-cancelled-with-event self event)
  (tell #:type _void (coerce-arg self) touchesCancelledWithEvent: (coerce-arg event)))
(define (nstextfield-touches-ended-with-event self event)
  (tell #:type _void (coerce-arg self) touchesEndedWithEvent: (coerce-arg event)))
(define (nstextfield-touches-moved-with-event self event)
  (tell #:type _void (coerce-arg self) touchesMovedWithEvent: (coerce-arg event)))
(define (nstextfield-translate-origin-to-point self translation)
  (_msg-11 (coerce-arg self) (sel_registerName "translateOriginToPoint:") translation))
(define (nstextfield-translate-rects-needing-display-in-rect-by self clip-rect delta)
  (_msg-19 (coerce-arg self) (sel_registerName "translateRectsNeedingDisplayInRect:by:") clip-rect delta))
(define (nstextfield-try-to-perform-with self action object)
  (_msg-36 (coerce-arg self) (sel_registerName "tryToPerform:with:") action (coerce-arg object)))
(define (nstextfield-update-layer self)
  (tell #:type _void (coerce-arg self) updateLayer))
(define (nstextfield-valid-requestor-for-send-type-return-type self send-type return-type)
  (wrap-objc-object
   (tell (coerce-arg self) validRequestorForSendType: (coerce-arg send-type) returnType: (coerce-arg return-type))))
(define (nstextfield-view-did-change-backing-properties self)
  (tell #:type _void (coerce-arg self) viewDidChangeBackingProperties))
(define (nstextfield-view-did-change-effective-appearance self)
  (tell #:type _void (coerce-arg self) viewDidChangeEffectiveAppearance))
(define (nstextfield-view-did-end-live-resize self)
  (tell #:type _void (coerce-arg self) viewDidEndLiveResize))
(define (nstextfield-view-did-hide self)
  (tell #:type _void (coerce-arg self) viewDidHide))
(define (nstextfield-view-did-move-to-superview self)
  (tell #:type _void (coerce-arg self) viewDidMoveToSuperview))
(define (nstextfield-view-did-move-to-window self)
  (tell #:type _void (coerce-arg self) viewDidMoveToWindow))
(define (nstextfield-view-did-unhide self)
  (tell #:type _void (coerce-arg self) viewDidUnhide))
(define (nstextfield-view-will-draw self)
  (tell #:type _void (coerce-arg self) viewWillDraw))
(define (nstextfield-view-will-move-to-superview self new-superview)
  (tell #:type _void (coerce-arg self) viewWillMoveToSuperview: (coerce-arg new-superview)))
(define (nstextfield-view-will-move-to-window self new-window)
  (tell #:type _void (coerce-arg self) viewWillMoveToWindow: (coerce-arg new-window)))
(define (nstextfield-view-will-start-live-resize self)
  (tell #:type _void (coerce-arg self) viewWillStartLiveResize))
(define (nstextfield-view-with-tag self tag)
  (wrap-objc-object
   (_msg-33 (coerce-arg self) (sel_registerName "viewWithTag:") tag)
   ))
(define (nstextfield-wants-forwarded-scroll-events-for-axis self axis)
  (_msg-39 (coerce-arg self) (sel_registerName "wantsForwardedScrollEventsForAxis:") axis))
(define (nstextfield-wants-scroll-events-for-swipe-tracking-on-axis self axis)
  (_msg-39 (coerce-arg self) (sel_registerName "wantsScrollEventsForSwipeTrackingOnAxis:") axis))
(define (nstextfield-will-open-menu-with-event self menu event)
  (tell #:type _void (coerce-arg self) willOpenMenu: (coerce-arg menu) withEvent: (coerce-arg event)))
(define (nstextfield-will-remove-subview self subview)
  (tell #:type _void (coerce-arg self) willRemoveSubview: (coerce-arg subview)))

;; --- Class methods ---
(define (nstextfield-is-compatible-with-responsive-scrolling)
  (_msg-1 NSTextField (sel_registerName "isCompatibleWithResponsiveScrolling")))
