#lang racket/base
;; Generated binding for NSTableView (AppKit)
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

(provide NSTableView)
(provide/contract
  [make-nstableview-init-with-coder (c-> (or/c string? objc-object? cpointer?) any/c)]
  [make-nstableview-init-with-frame (c-> any/c any/c)]
  [nstableview-accepts-first-responder (c-> objc-object? boolean?)]
  [nstableview-accepts-touch-events (c-> objc-object? boolean?)]
  [nstableview-set-accepts-touch-events! (c-> objc-object? boolean? void?)]
  [nstableview-action (c-> objc-object? cpointer?)]
  [nstableview-set-action! (c-> objc-object? cpointer? void?)]
  [nstableview-additional-safe-area-insets (c-> objc-object? any/c)]
  [nstableview-set-additional-safe-area-insets! (c-> objc-object? any/c void?)]
  [nstableview-alignment (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-alignment! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-alignment-rect-insets (c-> objc-object? any/c)]
  [nstableview-allowed-touch-types (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-allowed-touch-types! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-allows-column-reordering (c-> objc-object? boolean?)]
  [nstableview-set-allows-column-reordering! (c-> objc-object? boolean? void?)]
  [nstableview-allows-column-resizing (c-> objc-object? boolean?)]
  [nstableview-set-allows-column-resizing! (c-> objc-object? boolean? void?)]
  [nstableview-allows-column-selection (c-> objc-object? boolean?)]
  [nstableview-set-allows-column-selection! (c-> objc-object? boolean? void?)]
  [nstableview-allows-empty-selection (c-> objc-object? boolean?)]
  [nstableview-set-allows-empty-selection! (c-> objc-object? boolean? void?)]
  [nstableview-allows-expansion-tool-tips (c-> objc-object? boolean?)]
  [nstableview-set-allows-expansion-tool-tips! (c-> objc-object? boolean? void?)]
  [nstableview-allows-multiple-selection (c-> objc-object? boolean?)]
  [nstableview-set-allows-multiple-selection! (c-> objc-object? boolean? void?)]
  [nstableview-allows-type-select (c-> objc-object? boolean?)]
  [nstableview-set-allows-type-select! (c-> objc-object? boolean? void?)]
  [nstableview-allows-vibrancy (c-> objc-object? boolean?)]
  [nstableview-alpha-value (c-> objc-object? real?)]
  [nstableview-set-alpha-value! (c-> objc-object? real? void?)]
  [nstableview-attributed-string-value (c-> objc-object? any/c)]
  [nstableview-set-attributed-string-value! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-autoresizes-subviews (c-> objc-object? boolean?)]
  [nstableview-set-autoresizes-subviews! (c-> objc-object? boolean? void?)]
  [nstableview-autoresizing-mask (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-autoresizing-mask! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-autosave-name (c-> objc-object? any/c)]
  [nstableview-set-autosave-name! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-autosave-table-columns (c-> objc-object? boolean?)]
  [nstableview-set-autosave-table-columns! (c-> objc-object? boolean? void?)]
  [nstableview-background-color (c-> objc-object? any/c)]
  [nstableview-set-background-color! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-background-filters (c-> objc-object? any/c)]
  [nstableview-set-background-filters! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-base-writing-direction (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-base-writing-direction! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-baseline-offset-from-bottom (c-> objc-object? real?)]
  [nstableview-bottom-anchor (c-> objc-object? any/c)]
  [nstableview-bounds (c-> objc-object? any/c)]
  [nstableview-set-bounds! (c-> objc-object? any/c void?)]
  [nstableview-bounds-rotation (c-> objc-object? real?)]
  [nstableview-set-bounds-rotation! (c-> objc-object? real? void?)]
  [nstableview-can-become-key-view (c-> objc-object? boolean?)]
  [nstableview-can-draw (c-> objc-object? boolean?)]
  [nstableview-can-draw-concurrently (c-> objc-object? boolean?)]
  [nstableview-set-can-draw-concurrently! (c-> objc-object? boolean? void?)]
  [nstableview-can-draw-subviews-into-layer (c-> objc-object? boolean?)]
  [nstableview-set-can-draw-subviews-into-layer! (c-> objc-object? boolean? void?)]
  [nstableview-candidate-list-touch-bar-item (c-> objc-object? any/c)]
  [nstableview-cell (c-> objc-object? any/c)]
  [nstableview-set-cell! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-cell-class (c-> cpointer?)]
  [nstableview-set-cell-class! (c-> cpointer? void?)]
  [nstableview-center-x-anchor (c-> objc-object? any/c)]
  [nstableview-center-y-anchor (c-> objc-object? any/c)]
  [nstableview-clicked-column (c-> objc-object? exact-integer?)]
  [nstableview-clicked-row (c-> objc-object? exact-integer?)]
  [nstableview-clips-to-bounds (c-> objc-object? boolean?)]
  [nstableview-set-clips-to-bounds! (c-> objc-object? boolean? void?)]
  [nstableview-column-autoresizing-style (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-column-autoresizing-style! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-compatible-with-responsive-scrolling (c-> boolean?)]
  [nstableview-compositing-filter (c-> objc-object? any/c)]
  [nstableview-set-compositing-filter! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-constraints (c-> objc-object? any/c)]
  [nstableview-content-filters (c-> objc-object? any/c)]
  [nstableview-set-content-filters! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-continuous (c-> objc-object? boolean?)]
  [nstableview-set-continuous! (c-> objc-object? boolean? void?)]
  [nstableview-control-size (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-control-size! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-corner-view (c-> objc-object? any/c)]
  [nstableview-set-corner-view! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-data-source (c-> objc-object? any/c)]
  [nstableview-set-data-source! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-default-focus-ring-type (c-> exact-nonnegative-integer?)]
  [nstableview-default-menu (c-> any/c)]
  [nstableview-delegate (c-> objc-object? any/c)]
  [nstableview-set-delegate! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-double-action (c-> objc-object? cpointer?)]
  [nstableview-set-double-action! (c-> objc-object? cpointer? void?)]
  [nstableview-double-value (c-> objc-object? real?)]
  [nstableview-set-double-value! (c-> objc-object? real? void?)]
  [nstableview-dragging-destination-feedback-style (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-dragging-destination-feedback-style! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-drawing-find-indicator (c-> objc-object? boolean?)]
  [nstableview-edited-column (c-> objc-object? exact-integer?)]
  [nstableview-edited-row (c-> objc-object? exact-integer?)]
  [nstableview-effective-row-size-style (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-effective-style (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-enabled (c-> objc-object? boolean?)]
  [nstableview-set-enabled! (c-> objc-object? boolean? void?)]
  [nstableview-enclosing-menu-item (c-> objc-object? any/c)]
  [nstableview-enclosing-scroll-view (c-> objc-object? any/c)]
  [nstableview-first-baseline-anchor (c-> objc-object? any/c)]
  [nstableview-first-baseline-offset-from-top (c-> objc-object? real?)]
  [nstableview-fitting-size (c-> objc-object? any/c)]
  [nstableview-flipped (c-> objc-object? boolean?)]
  [nstableview-float-value (c-> objc-object? real?)]
  [nstableview-set-float-value! (c-> objc-object? real? void?)]
  [nstableview-floats-group-rows (c-> objc-object? boolean?)]
  [nstableview-set-floats-group-rows! (c-> objc-object? boolean? void?)]
  [nstableview-focus-ring-mask-bounds (c-> objc-object? any/c)]
  [nstableview-focus-ring-type (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-focus-ring-type! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-focus-view (c-> any/c)]
  [nstableview-font (c-> objc-object? any/c)]
  [nstableview-set-font! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-formatter (c-> objc-object? any/c)]
  [nstableview-set-formatter! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-frame (c-> objc-object? any/c)]
  [nstableview-set-frame! (c-> objc-object? any/c void?)]
  [nstableview-frame-center-rotation (c-> objc-object? real?)]
  [nstableview-set-frame-center-rotation! (c-> objc-object? real? void?)]
  [nstableview-frame-rotation (c-> objc-object? real?)]
  [nstableview-set-frame-rotation! (c-> objc-object? real? void?)]
  [nstableview-gesture-recognizers (c-> objc-object? any/c)]
  [nstableview-set-gesture-recognizers! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-grid-color (c-> objc-object? any/c)]
  [nstableview-set-grid-color! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-grid-style-mask (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-grid-style-mask! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-has-ambiguous-layout (c-> objc-object? boolean?)]
  [nstableview-header-view (c-> objc-object? any/c)]
  [nstableview-set-header-view! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-height-adjust-limit (c-> objc-object? real?)]
  [nstableview-height-anchor (c-> objc-object? any/c)]
  [nstableview-hidden (c-> objc-object? boolean?)]
  [nstableview-set-hidden! (c-> objc-object? boolean? void?)]
  [nstableview-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nstableview-hidden-row-indexes (c-> objc-object? any/c)]
  [nstableview-highlighted (c-> objc-object? boolean?)]
  [nstableview-set-highlighted! (c-> objc-object? boolean? void?)]
  [nstableview-highlighted-table-column (c-> objc-object? any/c)]
  [nstableview-set-highlighted-table-column! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-horizontal-content-size-constraint-active (c-> objc-object? boolean?)]
  [nstableview-set-horizontal-content-size-constraint-active! (c-> objc-object? boolean? void?)]
  [nstableview-ignores-multi-click (c-> objc-object? boolean?)]
  [nstableview-set-ignores-multi-click! (c-> objc-object? boolean? void?)]
  [nstableview-in-full-screen-mode (c-> objc-object? boolean?)]
  [nstableview-in-live-resize (c-> objc-object? boolean?)]
  [nstableview-input-context (c-> objc-object? any/c)]
  [nstableview-int-value (c-> objc-object? exact-integer?)]
  [nstableview-set-int-value! (c-> objc-object? exact-integer? void?)]
  [nstableview-integer-value (c-> objc-object? exact-integer?)]
  [nstableview-set-integer-value! (c-> objc-object? exact-integer? void?)]
  [nstableview-intercell-spacing (c-> objc-object? any/c)]
  [nstableview-set-intercell-spacing! (c-> objc-object? any/c void?)]
  [nstableview-intrinsic-content-size (c-> objc-object? any/c)]
  [nstableview-last-baseline-anchor (c-> objc-object? any/c)]
  [nstableview-last-baseline-offset-from-bottom (c-> objc-object? real?)]
  [nstableview-layer (c-> objc-object? any/c)]
  [nstableview-set-layer! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-layer-contents-placement (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-layer-contents-placement! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-layer-contents-redraw-policy (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-layer-contents-redraw-policy! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-layer-uses-core-image-filters (c-> objc-object? boolean?)]
  [nstableview-set-layer-uses-core-image-filters! (c-> objc-object? boolean? void?)]
  [nstableview-layout-guides (c-> objc-object? any/c)]
  [nstableview-layout-margins-guide (c-> objc-object? any/c)]
  [nstableview-leading-anchor (c-> objc-object? any/c)]
  [nstableview-left-anchor (c-> objc-object? any/c)]
  [nstableview-line-break-mode (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-line-break-mode! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-menu (c-> objc-object? any/c)]
  [nstableview-set-menu! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-mouse-down-can-move-window (c-> objc-object? boolean?)]
  [nstableview-needs-display (c-> objc-object? boolean?)]
  [nstableview-set-needs-display! (c-> objc-object? boolean? void?)]
  [nstableview-needs-layout (c-> objc-object? boolean?)]
  [nstableview-set-needs-layout! (c-> objc-object? boolean? void?)]
  [nstableview-needs-panel-to-become-key (c-> objc-object? boolean?)]
  [nstableview-needs-update-constraints (c-> objc-object? boolean?)]
  [nstableview-set-needs-update-constraints! (c-> objc-object? boolean? void?)]
  [nstableview-next-key-view (c-> objc-object? any/c)]
  [nstableview-set-next-key-view! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-next-responder (c-> objc-object? any/c)]
  [nstableview-set-next-responder! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-next-valid-key-view (c-> objc-object? any/c)]
  [nstableview-number-of-columns (c-> objc-object? exact-integer?)]
  [nstableview-number-of-rows (c-> objc-object? exact-integer?)]
  [nstableview-number-of-selected-columns (c-> objc-object? exact-integer?)]
  [nstableview-number-of-selected-rows (c-> objc-object? exact-integer?)]
  [nstableview-object-value (c-> objc-object? any/c)]
  [nstableview-set-object-value! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-opaque (c-> objc-object? boolean?)]
  [nstableview-opaque-ancestor (c-> objc-object? any/c)]
  [nstableview-page-footer (c-> objc-object? any/c)]
  [nstableview-page-header (c-> objc-object? any/c)]
  [nstableview-posts-bounds-changed-notifications (c-> objc-object? boolean?)]
  [nstableview-set-posts-bounds-changed-notifications! (c-> objc-object? boolean? void?)]
  [nstableview-posts-frame-changed-notifications (c-> objc-object? boolean?)]
  [nstableview-set-posts-frame-changed-notifications! (c-> objc-object? boolean? void?)]
  [nstableview-prefers-compact-control-size-metrics (c-> objc-object? boolean?)]
  [nstableview-set-prefers-compact-control-size-metrics! (c-> objc-object? boolean? void?)]
  [nstableview-prepared-content-rect (c-> objc-object? any/c)]
  [nstableview-set-prepared-content-rect! (c-> objc-object? any/c void?)]
  [nstableview-preserves-content-during-live-resize (c-> objc-object? boolean?)]
  [nstableview-pressure-configuration (c-> objc-object? any/c)]
  [nstableview-set-pressure-configuration! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-previous-key-view (c-> objc-object? any/c)]
  [nstableview-previous-valid-key-view (c-> objc-object? any/c)]
  [nstableview-print-job-title (c-> objc-object? any/c)]
  [nstableview-rect-preserved-during-live-resize (c-> objc-object? any/c)]
  [nstableview-refuses-first-responder (c-> objc-object? boolean?)]
  [nstableview-set-refuses-first-responder! (c-> objc-object? boolean? void?)]
  [nstableview-registered-dragged-types (c-> objc-object? any/c)]
  [nstableview-registered-nibs-by-identifier (c-> objc-object? any/c)]
  [nstableview-requires-constraint-based-layout (c-> boolean?)]
  [nstableview-restorable-state-key-paths (c-> any/c)]
  [nstableview-right-anchor (c-> objc-object? any/c)]
  [nstableview-rotated-from-base (c-> objc-object? boolean?)]
  [nstableview-rotated-or-scaled-from-base (c-> objc-object? boolean?)]
  [nstableview-row-actions-visible (c-> objc-object? boolean?)]
  [nstableview-set-row-actions-visible! (c-> objc-object? boolean? void?)]
  [nstableview-row-height (c-> objc-object? real?)]
  [nstableview-set-row-height! (c-> objc-object? real? void?)]
  [nstableview-row-size-style (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-row-size-style! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-safe-area-insets (c-> objc-object? any/c)]
  [nstableview-safe-area-layout-guide (c-> objc-object? any/c)]
  [nstableview-safe-area-rect (c-> objc-object? any/c)]
  [nstableview-selected-column (c-> objc-object? exact-integer?)]
  [nstableview-selected-column-indexes (c-> objc-object? any/c)]
  [nstableview-selected-row (c-> objc-object? exact-integer?)]
  [nstableview-selected-row-indexes (c-> objc-object? any/c)]
  [nstableview-selection-highlight-style (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-selection-highlight-style! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-shadow (c-> objc-object? any/c)]
  [nstableview-set-shadow! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-sort-descriptors (c-> objc-object? any/c)]
  [nstableview-set-sort-descriptors! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-string-value (c-> objc-object? any/c)]
  [nstableview-set-string-value! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-style (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-style! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-subviews (c-> objc-object? any/c)]
  [nstableview-set-subviews! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-superview (c-> objc-object? any/c)]
  [nstableview-table-columns (c-> objc-object? any/c)]
  [nstableview-tag (c-> objc-object? exact-integer?)]
  [nstableview-set-tag! (c-> objc-object? exact-integer? void?)]
  [nstableview-target (c-> objc-object? any/c)]
  [nstableview-set-target! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-tool-tip (c-> objc-object? any/c)]
  [nstableview-set-tool-tip! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-top-anchor (c-> objc-object? any/c)]
  [nstableview-touch-bar (c-> objc-object? any/c)]
  [nstableview-set-touch-bar! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-tracking-areas (c-> objc-object? any/c)]
  [nstableview-trailing-anchor (c-> objc-object? any/c)]
  [nstableview-translates-autoresizing-mask-into-constraints (c-> objc-object? boolean?)]
  [nstableview-set-translates-autoresizing-mask-into-constraints! (c-> objc-object? boolean? void?)]
  [nstableview-undo-manager (c-> objc-object? any/c)]
  [nstableview-user-activity (c-> objc-object? any/c)]
  [nstableview-set-user-activity! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-user-interface-layout-direction (c-> objc-object? exact-nonnegative-integer?)]
  [nstableview-set-user-interface-layout-direction! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstableview-uses-alternating-row-background-colors (c-> objc-object? boolean?)]
  [nstableview-set-uses-alternating-row-background-colors! (c-> objc-object? boolean? void?)]
  [nstableview-uses-automatic-row-heights (c-> objc-object? boolean?)]
  [nstableview-set-uses-automatic-row-heights! (c-> objc-object? boolean? void?)]
  [nstableview-uses-single-line-mode (c-> objc-object? boolean?)]
  [nstableview-set-uses-single-line-mode! (c-> objc-object? boolean? void?)]
  [nstableview-uses-static-contents (c-> objc-object? boolean?)]
  [nstableview-set-uses-static-contents! (c-> objc-object? boolean? void?)]
  [nstableview-vertical-content-size-constraint-active (c-> objc-object? boolean?)]
  [nstableview-set-vertical-content-size-constraint-active! (c-> objc-object? boolean? void?)]
  [nstableview-vertical-motion-can-begin-drag (c-> objc-object? boolean?)]
  [nstableview-set-vertical-motion-can-begin-drag! (c-> objc-object? boolean? void?)]
  [nstableview-visible-rect (c-> objc-object? any/c)]
  [nstableview-wants-best-resolution-open-gl-surface (c-> objc-object? boolean?)]
  [nstableview-set-wants-best-resolution-open-gl-surface! (c-> objc-object? boolean? void?)]
  [nstableview-wants-default-clipping (c-> objc-object? boolean?)]
  [nstableview-wants-extended-dynamic-range-open-gl-surface (c-> objc-object? boolean?)]
  [nstableview-set-wants-extended-dynamic-range-open-gl-surface! (c-> objc-object? boolean? void?)]
  [nstableview-wants-layer (c-> objc-object? boolean?)]
  [nstableview-set-wants-layer! (c-> objc-object? boolean? void?)]
  [nstableview-wants-resting-touches (c-> objc-object? boolean?)]
  [nstableview-set-wants-resting-touches! (c-> objc-object? boolean? void?)]
  [nstableview-wants-update-layer (c-> objc-object? boolean?)]
  [nstableview-width-adjust-limit (c-> objc-object? real?)]
  [nstableview-width-anchor (c-> objc-object? any/c)]
  [nstableview-window (c-> objc-object? any/c)]
  [nstableview-writing-tools-coordinator (c-> objc-object? any/c)]
  [nstableview-set-writing-tools-coordinator! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-accepts-first-mouse (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstableview-add-subview! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-add-subview-positioned-relative-to! (c-> objc-object? (or/c string? objc-object? cpointer?) exact-nonnegative-integer? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-add-table-column! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-add-tool-tip-rect-owner-user-data! (c-> objc-object? any/c (or/c string? objc-object? cpointer?) (or/c cpointer? #f) exact-integer?)]
  [nstableview-adjust-scroll (c-> objc-object? any/c any/c)]
  [nstableview-ancestor-shared-with-view (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nstableview-autoscroll (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstableview-backing-aligned-rect-options (c-> objc-object? any/c exact-nonnegative-integer? any/c)]
  [nstableview-become-first-responder (c-> objc-object? boolean?)]
  [nstableview-begin-gesture-with-event! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-begin-updates! (c-> objc-object? void?)]
  [nstableview-bitmap-image-rep-for-caching-display-in-rect (c-> objc-object? any/c any/c)]
  [nstableview-cache-display-in-rect-to-bitmap-image-rep (c-> objc-object? any/c (or/c string? objc-object? cpointer?) void?)]
  [nstableview-can-drag-rows-with-indexes-at-point (c-> objc-object? (or/c string? objc-object? cpointer?) any/c boolean?)]
  [nstableview-center-scan-rect! (c-> objc-object? any/c any/c)]
  [nstableview-change-mode-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-column-at-point (c-> objc-object? any/c exact-integer?)]
  [nstableview-column-for-view (c-> objc-object? (or/c string? objc-object? cpointer?) exact-integer?)]
  [nstableview-column-indexes-in-rect (c-> objc-object? any/c any/c)]
  [nstableview-column-with-identifier (c-> objc-object? (or/c string? objc-object? cpointer?) exact-integer?)]
  [nstableview-context-menu-key-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-convert-point-from-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstableview-convert-point-to-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstableview-convert-point-from-backing (c-> objc-object? any/c any/c)]
  [nstableview-convert-point-from-layer (c-> objc-object? any/c any/c)]
  [nstableview-convert-point-to-backing (c-> objc-object? any/c any/c)]
  [nstableview-convert-point-to-layer (c-> objc-object? any/c any/c)]
  [nstableview-convert-rect-from-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstableview-convert-rect-to-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstableview-convert-rect-from-backing (c-> objc-object? any/c any/c)]
  [nstableview-convert-rect-from-layer (c-> objc-object? any/c any/c)]
  [nstableview-convert-rect-to-backing (c-> objc-object? any/c any/c)]
  [nstableview-convert-rect-to-layer (c-> objc-object? any/c any/c)]
  [nstableview-convert-size-from-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstableview-convert-size-to-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstableview-convert-size-from-backing (c-> objc-object? any/c any/c)]
  [nstableview-convert-size-from-layer (c-> objc-object? any/c any/c)]
  [nstableview-convert-size-to-backing (c-> objc-object? any/c any/c)]
  [nstableview-convert-size-to-layer (c-> objc-object? any/c any/c)]
  [nstableview-cursor-update (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-deselect-all (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-deselect-column (c-> objc-object? exact-integer? void?)]
  [nstableview-deselect-row (c-> objc-object? exact-integer? void?)]
  [nstableview-did-add-row-view-for-row (c-> objc-object? (or/c string? objc-object? cpointer?) exact-integer? void?)]
  [nstableview-did-add-subview (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-did-close-menu-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstableview-did-remove-row-view-for-row (c-> objc-object? (or/c string? objc-object? cpointer?) exact-integer? void?)]
  [nstableview-display! (c-> objc-object? void?)]
  [nstableview-display-if-needed! (c-> objc-object? void?)]
  [nstableview-display-if-needed-ignoring-opacity! (c-> objc-object? void?)]
  [nstableview-display-if-needed-in-rect! (c-> objc-object? any/c void?)]
  [nstableview-display-if-needed-in-rect-ignoring-opacity! (c-> objc-object? any/c void?)]
  [nstableview-display-rect! (c-> objc-object? any/c void?)]
  [nstableview-display-rect-ignoring-opacity! (c-> objc-object? any/c void?)]
  [nstableview-display-rect-ignoring-opacity-in-context! (c-> objc-object? any/c (or/c string? objc-object? cpointer?) void?)]
  [nstableview-drag-image-for-rows-with-indexes-table-columns-event-offset (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) (or/c cpointer? #f) any/c)]
  [nstableview-draw-background-in-clip-rect (c-> objc-object? any/c void?)]
  [nstableview-draw-grid-in-clip-rect (c-> objc-object? any/c void?)]
  [nstableview-draw-rect (c-> objc-object? any/c void?)]
  [nstableview-draw-row-clip-rect (c-> objc-object? exact-integer? any/c void?)]
  [nstableview-draw-with-expansion-frame-in-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) void?)]
  [nstableview-edit-column-row-with-event-select (c-> objc-object? exact-integer? exact-integer? (or/c string? objc-object? cpointer?) boolean? void?)]
  [nstableview-end-gesture-with-event! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-end-updates! (c-> objc-object? void?)]
  [nstableview-enumerate-available-row-views-using-block (c-> objc-object? (or/c procedure? #f) void?)]
  [nstableview-expansion-frame-with-frame (c-> objc-object? any/c any/c)]
  [nstableview-flags-changed (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-flush-buffered-key-events (c-> objc-object? void?)]
  [nstableview-frame-of-cell-at-column-row (c-> objc-object? exact-integer? exact-integer? any/c)]
  [nstableview-get-rects-being-drawn-count (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nstableview-get-rects-exposed-during-live-resize-count (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nstableview-help-requested (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-hide-rows-at-indexes-with-animation (c-> objc-object? (or/c string? objc-object? cpointer?) exact-nonnegative-integer? void?)]
  [nstableview-highlight-selection-in-clip-rect (c-> objc-object? any/c void?)]
  [nstableview-hit-test (c-> objc-object? any/c any/c)]
  [nstableview-indicator-image-in-table-column (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nstableview-insert-rows-at-indexes-with-animation! (c-> objc-object? (or/c string? objc-object? cpointer?) exact-nonnegative-integer? void?)]
  [nstableview-interpret-key-events (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-is-column-selected (c-> objc-object? exact-integer? boolean?)]
  [nstableview-is-continuous (c-> objc-object? boolean?)]
  [nstableview-is-descendant-of (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstableview-is-enabled (c-> objc-object? boolean?)]
  [nstableview-is-flipped (c-> objc-object? boolean?)]
  [nstableview-is-hidden (c-> objc-object? boolean?)]
  [nstableview-is-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nstableview-is-highlighted (c-> objc-object? boolean?)]
  [nstableview-is-opaque (c-> objc-object? boolean?)]
  [nstableview-is-rotated-from-base (c-> objc-object? boolean?)]
  [nstableview-is-rotated-or-scaled-from-base (c-> objc-object? boolean?)]
  [nstableview-is-row-selected (c-> objc-object? exact-integer? boolean?)]
  [nstableview-key-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-key-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-layout (c-> objc-object? void?)]
  [nstableview-layout-subtree-if-needed (c-> objc-object? void?)]
  [nstableview-magnify-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-make-backing-layer (c-> objc-object? any/c)]
  [nstableview-make-view-with-identifier-owner (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) any/c)]
  [nstableview-menu-for-event (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nstableview-mouse-in-rect (c-> objc-object? any/c any/c boolean?)]
  [nstableview-mouse-cancelled (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-mouse-entered (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-mouse-exited (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-mouse-moved (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-move-column-to-column! (c-> objc-object? exact-integer? exact-integer? void?)]
  [nstableview-move-row-at-index-to-index! (c-> objc-object? exact-integer? exact-integer? void?)]
  [nstableview-needs-to-draw-rect (c-> objc-object? any/c boolean?)]
  [nstableview-no-responder-for (c-> objc-object? cpointer? void?)]
  [nstableview-note-height-of-rows-with-indexes-changed (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-note-number-of-rows-changed (c-> objc-object? void?)]
  [nstableview-other-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-other-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-other-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-perform-click! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-perform-key-equivalent! (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstableview-prepare-content-in-rect (c-> objc-object? any/c void?)]
  [nstableview-prepare-for-reuse (c-> objc-object? void?)]
  [nstableview-pressure-change-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-quick-look-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-rect-for-smart-magnification-at-point-in-rect (c-> objc-object? any/c any/c any/c)]
  [nstableview-rect-of-column (c-> objc-object? exact-integer? any/c)]
  [nstableview-rect-of-row (c-> objc-object? exact-integer? any/c)]
  [nstableview-register-nib-for-identifier (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstableview-reload-data (c-> objc-object? void?)]
  [nstableview-reload-data-for-row-indexes-column-indexes (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstableview-remove-all-tool-tips! (c-> objc-object? void?)]
  [nstableview-remove-from-superview! (c-> objc-object? void?)]
  [nstableview-remove-from-superview-without-needing-display! (c-> objc-object? void?)]
  [nstableview-remove-rows-at-indexes-with-animation! (c-> objc-object? (or/c string? objc-object? cpointer?) exact-nonnegative-integer? void?)]
  [nstableview-remove-table-column! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-remove-tool-tip! (c-> objc-object? exact-integer? void?)]
  [nstableview-replace-subview-with! (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstableview-resign-first-responder (c-> objc-object? boolean?)]
  [nstableview-resize-subviews-with-old-size (c-> objc-object? any/c void?)]
  [nstableview-resize-with-old-superview-size (c-> objc-object? any/c void?)]
  [nstableview-right-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-right-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-right-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-rotate-by-angle (c-> objc-object? real? void?)]
  [nstableview-rotate-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-row-at-point (c-> objc-object? any/c exact-integer?)]
  [nstableview-row-for-view (c-> objc-object? (or/c string? objc-object? cpointer?) exact-integer?)]
  [nstableview-row-view-at-row-make-if-necessary (c-> objc-object? exact-integer? boolean? any/c)]
  [nstableview-rows-in-rect (c-> objc-object? any/c any/c)]
  [nstableview-scale-unit-square-to-size (c-> objc-object? any/c void?)]
  [nstableview-scroll-column-to-visible (c-> objc-object? exact-integer? void?)]
  [nstableview-scroll-point (c-> objc-object? any/c void?)]
  [nstableview-scroll-rect-to-visible (c-> objc-object? any/c boolean?)]
  [nstableview-scroll-row-to-visible (c-> objc-object? exact-integer? void?)]
  [nstableview-scroll-wheel (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-select-all (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-select-column-indexes-by-extending-selection (c-> objc-object? (or/c string? objc-object? cpointer?) boolean? void?)]
  [nstableview-select-row-indexes-by-extending-selection (c-> objc-object? (or/c string? objc-object? cpointer?) boolean? void?)]
  [nstableview-send-action-to (c-> objc-object? cpointer? (or/c string? objc-object? cpointer?) boolean?)]
  [nstableview-send-action-on (c-> objc-object? exact-nonnegative-integer? exact-integer?)]
  [nstableview-set-bounds-origin! (c-> objc-object? any/c void?)]
  [nstableview-set-bounds-size! (c-> objc-object? any/c void?)]
  [nstableview-set-dragging-source-operation-mask-for-local! (c-> objc-object? exact-nonnegative-integer? boolean? void?)]
  [nstableview-set-drop-row-drop-operation! (c-> objc-object? exact-integer? exact-nonnegative-integer? void?)]
  [nstableview-set-frame-origin! (c-> objc-object? any/c void?)]
  [nstableview-set-frame-size! (c-> objc-object? any/c void?)]
  [nstableview-set-indicator-image-in-table-column! (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstableview-set-needs-display-in-rect! (c-> objc-object? any/c void?)]
  [nstableview-should-be-treated-as-ink-event (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstableview-should-delay-window-ordering-for-event (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstableview-show-context-help (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-size-last-column-to-fit (c-> objc-object? void?)]
  [nstableview-size-that-fits (c-> objc-object? any/c any/c)]
  [nstableview-size-to-fit (c-> objc-object? void?)]
  [nstableview-smart-magnify-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-sort-subviews-using-function-context (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nstableview-supplemental-target-for-action-sender (c-> objc-object? cpointer? (or/c string? objc-object? cpointer?) any/c)]
  [nstableview-swipe-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-table-column-with-identifier (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nstableview-tablet-point (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-tablet-proximity (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-take-double-value-from (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-take-float-value-from (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-take-int-value-from (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-take-integer-value-from (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-take-object-value-from (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-take-string-value-from (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-tile (c-> objc-object? void?)]
  [nstableview-touches-began-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-touches-cancelled-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-touches-ended-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-touches-moved-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-translate-origin-to-point (c-> objc-object? any/c void?)]
  [nstableview-translate-rects-needing-display-in-rect-by (c-> objc-object? any/c any/c void?)]
  [nstableview-try-to-perform-with (c-> objc-object? cpointer? (or/c string? objc-object? cpointer?) boolean?)]
  [nstableview-unhide-rows-at-indexes-with-animation (c-> objc-object? (or/c string? objc-object? cpointer?) exact-nonnegative-integer? void?)]
  [nstableview-update-layer (c-> objc-object? void?)]
  [nstableview-valid-requestor-for-send-type-return-type (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) any/c)]
  [nstableview-view-at-column-row-make-if-necessary (c-> objc-object? exact-integer? exact-integer? boolean? any/c)]
  [nstableview-view-did-change-backing-properties (c-> objc-object? void?)]
  [nstableview-view-did-change-effective-appearance (c-> objc-object? void?)]
  [nstableview-view-did-end-live-resize (c-> objc-object? void?)]
  [nstableview-view-did-hide (c-> objc-object? void?)]
  [nstableview-view-did-move-to-superview (c-> objc-object? void?)]
  [nstableview-view-did-move-to-window (c-> objc-object? void?)]
  [nstableview-view-did-unhide (c-> objc-object? void?)]
  [nstableview-view-will-draw (c-> objc-object? void?)]
  [nstableview-view-will-move-to-superview (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-view-will-move-to-window (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-view-will-start-live-resize (c-> objc-object? void?)]
  [nstableview-view-with-tag (c-> objc-object? exact-integer? any/c)]
  [nstableview-wants-forwarded-scroll-events-for-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nstableview-wants-scroll-events-for-swipe-tracking-on-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nstableview-will-open-menu-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstableview-will-remove-subview (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstableview-is-compatible-with-responsive-scrolling (c-> boolean?)]
  )

;; --- Class reference ---
(import-class NSTableView)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _NSRect)))
(define _msg-1  ; (_fun _pointer _pointer -> _NSSize)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _NSSize)))
(define _msg-2  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-3  ; (_fun _pointer _pointer -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _double)))
(define _msg-4  ; (_fun _pointer _pointer -> _float)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _float)))
(define _msg-5  ; (_fun _pointer _pointer -> _int32)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _int32)))
(define _msg-6  ; (_fun _pointer _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _int64)))
(define _msg-7  ; (_fun _pointer _pointer -> _pointer)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _pointer)))
(define _msg-8  ; (_fun _pointer _pointer -> _uint64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _uint64)))
(define _msg-9  ; (_fun _pointer _pointer _NSEdgeInsets -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSEdgeInsets -> _void)))
(define _msg-10  ; (_fun _pointer _pointer _NSPoint -> _NSPoint)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _NSPoint)))
(define _msg-11  ; (_fun _pointer _pointer _NSPoint -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _id)))
(define _msg-12  ; (_fun _pointer _pointer _NSPoint -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _int64)))
(define _msg-13  ; (_fun _pointer _pointer _NSPoint -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _void)))
(define _msg-14  ; (_fun _pointer _pointer _NSPoint _NSRect -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _NSRect -> _NSRect)))
(define _msg-15  ; (_fun _pointer _pointer _NSPoint _NSRect -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _NSRect -> _bool)))
(define _msg-16  ; (_fun _pointer _pointer _NSPoint _id -> _NSPoint)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _id -> _NSPoint)))
(define _msg-17  ; (_fun _pointer _pointer _NSRect -> _NSRange)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _NSRange)))
(define _msg-18  ; (_fun _pointer _pointer _NSRect -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _NSRect)))
(define _msg-19  ; (_fun _pointer _pointer _NSRect -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _bool)))
(define _msg-20  ; (_fun _pointer _pointer _NSRect -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _id)))
(define _msg-21  ; (_fun _pointer _pointer _NSRect -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _void)))
(define _msg-22  ; (_fun _pointer _pointer _NSRect _NSSize -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _NSSize -> _void)))
(define _msg-23  ; (_fun _pointer _pointer _NSRect _id -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id -> _NSRect)))
(define _msg-24  ; (_fun _pointer _pointer _NSRect _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id -> _void)))
(define _msg-25  ; (_fun _pointer _pointer _NSRect _id _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id _pointer -> _int64)))
(define _msg-26  ; (_fun _pointer _pointer _NSRect _uint64 -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _uint64 -> _NSRect)))
(define _msg-27  ; (_fun _pointer _pointer _NSSize -> _NSSize)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize -> _NSSize)))
(define _msg-28  ; (_fun _pointer _pointer _NSSize -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize -> _void)))
(define _msg-29  ; (_fun _pointer _pointer _NSSize _id -> _NSSize)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize _id -> _NSSize)))
(define _msg-30  ; (_fun _pointer _pointer _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool -> _void)))
(define _msg-31  ; (_fun _pointer _pointer _double -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double -> _void)))
(define _msg-32  ; (_fun _pointer _pointer _float -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _float -> _void)))
(define _msg-33  ; (_fun _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _bool)))
(define _msg-34  ; (_fun _pointer _pointer _id -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _int64)))
(define _msg-35  ; (_fun _pointer _pointer _id _NSPoint -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _NSPoint -> _bool)))
(define _msg-36  ; (_fun _pointer _pointer _id _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _bool -> _void)))
(define _msg-37  ; (_fun _pointer _pointer _id _id _id _pointer -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _id _id _pointer -> _id)))
(define _msg-38  ; (_fun _pointer _pointer _id _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _int64 -> _void)))
(define _msg-39  ; (_fun _pointer _pointer _id _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _uint64 -> _void)))
(define _msg-40  ; (_fun _pointer _pointer _id _uint64 _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _uint64 _id -> _void)))
(define _msg-41  ; (_fun _pointer _pointer _int32 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int32 -> _void)))
(define _msg-42  ; (_fun _pointer _pointer _int64 -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _NSRect)))
(define _msg-43  ; (_fun _pointer _pointer _int64 -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _bool)))
(define _msg-44  ; (_fun _pointer _pointer _int64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _id)))
(define _msg-45  ; (_fun _pointer _pointer _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _void)))
(define _msg-46  ; (_fun _pointer _pointer _int64 _NSRect -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 _NSRect -> _void)))
(define _msg-47  ; (_fun _pointer _pointer _int64 _bool -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 _bool -> _id)))
(define _msg-48  ; (_fun _pointer _pointer _int64 _int64 -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 _int64 -> _NSRect)))
(define _msg-49  ; (_fun _pointer _pointer _int64 _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 _int64 -> _void)))
(define _msg-50  ; (_fun _pointer _pointer _int64 _int64 _bool -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 _int64 _bool -> _id)))
(define _msg-51  ; (_fun _pointer _pointer _int64 _int64 _id _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 _int64 _id _bool -> _void)))
(define _msg-52  ; (_fun _pointer _pointer _int64 _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 _uint64 -> _void)))
(define _msg-53  ; (_fun _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))
(define _msg-54  ; (_fun _pointer _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _bool)))
(define _msg-55  ; (_fun _pointer _pointer _pointer _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _id)))
(define _msg-56  ; (_fun _pointer _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _pointer -> _void)))
(define _msg-57  ; (_fun _pointer _pointer _uint64 -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _bool)))
(define _msg-58  ; (_fun _pointer _pointer _uint64 -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _int64)))
(define _msg-59  ; (_fun _pointer _pointer _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _void)))
(define _msg-60  ; (_fun _pointer _pointer _uint64 _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 _bool -> _void)))

;; --- Constructors ---
(define (make-nstableview-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSTableView alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))

(define (make-nstableview-init-with-frame frame-rect)
  (wrap-objc-object
   (_msg-20 (tell NSTableView alloc)
       (sel_registerName "initWithFrame:")
       frame-rect)
   #:retained #t))


;; --- Properties ---
(define (nstableview-accepts-first-responder self)
  (tell #:type _bool (coerce-arg self) acceptsFirstResponder))
(define (nstableview-accepts-touch-events self)
  (tell #:type _bool (coerce-arg self) acceptsTouchEvents))
(define (nstableview-set-accepts-touch-events! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setAcceptsTouchEvents:") value))
(define (nstableview-action self)
  (tell #:type _pointer (coerce-arg self) action))
(define (nstableview-set-action! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setAction:") value))
(define (nstableview-additional-safe-area-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) additionalSafeAreaInsets))
(define (nstableview-set-additional-safe-area-insets! self value)
  (_msg-9 (coerce-arg self) (sel_registerName "setAdditionalSafeAreaInsets:") value))
(define (nstableview-alignment self)
  (tell #:type _uint64 (coerce-arg self) alignment))
(define (nstableview-set-alignment! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setAlignment:") value))
(define (nstableview-alignment-rect-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) alignmentRectInsets))
(define (nstableview-allowed-touch-types self)
  (tell #:type _uint64 (coerce-arg self) allowedTouchTypes))
(define (nstableview-set-allowed-touch-types! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setAllowedTouchTypes:") value))
(define (nstableview-allows-column-reordering self)
  (tell #:type _bool (coerce-arg self) allowsColumnReordering))
(define (nstableview-set-allows-column-reordering! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setAllowsColumnReordering:") value))
(define (nstableview-allows-column-resizing self)
  (tell #:type _bool (coerce-arg self) allowsColumnResizing))
(define (nstableview-set-allows-column-resizing! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setAllowsColumnResizing:") value))
(define (nstableview-allows-column-selection self)
  (tell #:type _bool (coerce-arg self) allowsColumnSelection))
(define (nstableview-set-allows-column-selection! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setAllowsColumnSelection:") value))
(define (nstableview-allows-empty-selection self)
  (tell #:type _bool (coerce-arg self) allowsEmptySelection))
(define (nstableview-set-allows-empty-selection! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setAllowsEmptySelection:") value))
(define (nstableview-allows-expansion-tool-tips self)
  (tell #:type _bool (coerce-arg self) allowsExpansionToolTips))
(define (nstableview-set-allows-expansion-tool-tips! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setAllowsExpansionToolTips:") value))
(define (nstableview-allows-multiple-selection self)
  (tell #:type _bool (coerce-arg self) allowsMultipleSelection))
(define (nstableview-set-allows-multiple-selection! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setAllowsMultipleSelection:") value))
(define (nstableview-allows-type-select self)
  (tell #:type _bool (coerce-arg self) allowsTypeSelect))
(define (nstableview-set-allows-type-select! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setAllowsTypeSelect:") value))
(define (nstableview-allows-vibrancy self)
  (tell #:type _bool (coerce-arg self) allowsVibrancy))
(define (nstableview-alpha-value self)
  (tell #:type _double (coerce-arg self) alphaValue))
(define (nstableview-set-alpha-value! self value)
  (_msg-31 (coerce-arg self) (sel_registerName "setAlphaValue:") value))
(define (nstableview-attributed-string-value self)
  (wrap-objc-object
   (tell (coerce-arg self) attributedStringValue)))
(define (nstableview-set-attributed-string-value! self value)
  (tell #:type _void (coerce-arg self) setAttributedStringValue: (coerce-arg value)))
(define (nstableview-autoresizes-subviews self)
  (tell #:type _bool (coerce-arg self) autoresizesSubviews))
(define (nstableview-set-autoresizes-subviews! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setAutoresizesSubviews:") value))
(define (nstableview-autoresizing-mask self)
  (tell #:type _uint64 (coerce-arg self) autoresizingMask))
(define (nstableview-set-autoresizing-mask! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setAutoresizingMask:") value))
(define (nstableview-autosave-name self)
  (wrap-objc-object
   (tell (coerce-arg self) autosaveName)))
(define (nstableview-set-autosave-name! self value)
  (tell #:type _void (coerce-arg self) setAutosaveName: (coerce-arg value)))
(define (nstableview-autosave-table-columns self)
  (tell #:type _bool (coerce-arg self) autosaveTableColumns))
(define (nstableview-set-autosave-table-columns! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setAutosaveTableColumns:") value))
(define (nstableview-background-color self)
  (wrap-objc-object
   (tell (coerce-arg self) backgroundColor)))
(define (nstableview-set-background-color! self value)
  (tell #:type _void (coerce-arg self) setBackgroundColor: (coerce-arg value)))
(define (nstableview-background-filters self)
  (wrap-objc-object
   (tell (coerce-arg self) backgroundFilters)))
(define (nstableview-set-background-filters! self value)
  (tell #:type _void (coerce-arg self) setBackgroundFilters: (coerce-arg value)))
(define (nstableview-base-writing-direction self)
  (tell #:type _uint64 (coerce-arg self) baseWritingDirection))
(define (nstableview-set-base-writing-direction! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setBaseWritingDirection:") value))
(define (nstableview-baseline-offset-from-bottom self)
  (tell #:type _double (coerce-arg self) baselineOffsetFromBottom))
(define (nstableview-bottom-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) bottomAnchor)))
(define (nstableview-bounds self)
  (tell #:type _NSRect (coerce-arg self) bounds))
(define (nstableview-set-bounds! self value)
  (_msg-21 (coerce-arg self) (sel_registerName "setBounds:") value))
(define (nstableview-bounds-rotation self)
  (tell #:type _double (coerce-arg self) boundsRotation))
(define (nstableview-set-bounds-rotation! self value)
  (_msg-31 (coerce-arg self) (sel_registerName "setBoundsRotation:") value))
(define (nstableview-can-become-key-view self)
  (tell #:type _bool (coerce-arg self) canBecomeKeyView))
(define (nstableview-can-draw self)
  (tell #:type _bool (coerce-arg self) canDraw))
(define (nstableview-can-draw-concurrently self)
  (tell #:type _bool (coerce-arg self) canDrawConcurrently))
(define (nstableview-set-can-draw-concurrently! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setCanDrawConcurrently:") value))
(define (nstableview-can-draw-subviews-into-layer self)
  (tell #:type _bool (coerce-arg self) canDrawSubviewsIntoLayer))
(define (nstableview-set-can-draw-subviews-into-layer! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setCanDrawSubviewsIntoLayer:") value))
(define (nstableview-candidate-list-touch-bar-item self)
  (wrap-objc-object
   (tell (coerce-arg self) candidateListTouchBarItem)))
(define (nstableview-cell self)
  (wrap-objc-object
   (tell (coerce-arg self) cell)))
(define (nstableview-set-cell! self value)
  (tell #:type _void (coerce-arg self) setCell: (coerce-arg value)))
(define (nstableview-cell-class)
  (tell #:type _pointer NSTableView cellClass))
(define (nstableview-set-cell-class! value)
  (_msg-53 NSTableView (sel_registerName "setCellClass:") value))
(define (nstableview-center-x-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) centerXAnchor)))
(define (nstableview-center-y-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) centerYAnchor)))
(define (nstableview-clicked-column self)
  (tell #:type _int64 (coerce-arg self) clickedColumn))
(define (nstableview-clicked-row self)
  (tell #:type _int64 (coerce-arg self) clickedRow))
(define (nstableview-clips-to-bounds self)
  (tell #:type _bool (coerce-arg self) clipsToBounds))
(define (nstableview-set-clips-to-bounds! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setClipsToBounds:") value))
(define (nstableview-column-autoresizing-style self)
  (tell #:type _uint64 (coerce-arg self) columnAutoresizingStyle))
(define (nstableview-set-column-autoresizing-style! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setColumnAutoresizingStyle:") value))
(define (nstableview-compatible-with-responsive-scrolling)
  (tell #:type _bool NSTableView compatibleWithResponsiveScrolling))
(define (nstableview-compositing-filter self)
  (wrap-objc-object
   (tell (coerce-arg self) compositingFilter)))
(define (nstableview-set-compositing-filter! self value)
  (tell #:type _void (coerce-arg self) setCompositingFilter: (coerce-arg value)))
(define (nstableview-constraints self)
  (wrap-objc-object
   (tell (coerce-arg self) constraints)))
(define (nstableview-content-filters self)
  (wrap-objc-object
   (tell (coerce-arg self) contentFilters)))
(define (nstableview-set-content-filters! self value)
  (tell #:type _void (coerce-arg self) setContentFilters: (coerce-arg value)))
(define (nstableview-continuous self)
  (tell #:type _bool (coerce-arg self) continuous))
(define (nstableview-set-continuous! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setContinuous:") value))
(define (nstableview-control-size self)
  (tell #:type _uint64 (coerce-arg self) controlSize))
(define (nstableview-set-control-size! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setControlSize:") value))
(define (nstableview-corner-view self)
  (wrap-objc-object
   (tell (coerce-arg self) cornerView)))
(define (nstableview-set-corner-view! self value)
  (tell #:type _void (coerce-arg self) setCornerView: (coerce-arg value)))
(define (nstableview-data-source self)
  (wrap-objc-object
   (tell (coerce-arg self) dataSource)))
(define (nstableview-set-data-source! self value)
  (tell #:type _void (coerce-arg self) setDataSource: (coerce-arg value)))
(define (nstableview-default-focus-ring-type)
  (tell #:type _uint64 NSTableView defaultFocusRingType))
(define (nstableview-default-menu)
  (wrap-objc-object
   (tell NSTableView defaultMenu)))
(define (nstableview-delegate self)
  (wrap-objc-object
   (tell (coerce-arg self) delegate)))
(define (nstableview-set-delegate! self value)
  (tell #:type _void (coerce-arg self) setDelegate: (coerce-arg value)))
(define (nstableview-double-action self)
  (tell #:type _pointer (coerce-arg self) doubleAction))
(define (nstableview-set-double-action! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setDoubleAction:") value))
(define (nstableview-double-value self)
  (tell #:type _double (coerce-arg self) doubleValue))
(define (nstableview-set-double-value! self value)
  (_msg-31 (coerce-arg self) (sel_registerName "setDoubleValue:") value))
(define (nstableview-dragging-destination-feedback-style self)
  (tell #:type _uint64 (coerce-arg self) draggingDestinationFeedbackStyle))
(define (nstableview-set-dragging-destination-feedback-style! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setDraggingDestinationFeedbackStyle:") value))
(define (nstableview-drawing-find-indicator self)
  (tell #:type _bool (coerce-arg self) drawingFindIndicator))
(define (nstableview-edited-column self)
  (tell #:type _int64 (coerce-arg self) editedColumn))
(define (nstableview-edited-row self)
  (tell #:type _int64 (coerce-arg self) editedRow))
(define (nstableview-effective-row-size-style self)
  (tell #:type _uint64 (coerce-arg self) effectiveRowSizeStyle))
(define (nstableview-effective-style self)
  (tell #:type _uint64 (coerce-arg self) effectiveStyle))
(define (nstableview-enabled self)
  (tell #:type _bool (coerce-arg self) enabled))
(define (nstableview-set-enabled! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setEnabled:") value))
(define (nstableview-enclosing-menu-item self)
  (wrap-objc-object
   (tell (coerce-arg self) enclosingMenuItem)))
(define (nstableview-enclosing-scroll-view self)
  (wrap-objc-object
   (tell (coerce-arg self) enclosingScrollView)))
(define (nstableview-first-baseline-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) firstBaselineAnchor)))
(define (nstableview-first-baseline-offset-from-top self)
  (tell #:type _double (coerce-arg self) firstBaselineOffsetFromTop))
(define (nstableview-fitting-size self)
  (tell #:type _NSSize (coerce-arg self) fittingSize))
(define (nstableview-flipped self)
  (tell #:type _bool (coerce-arg self) flipped))
(define (nstableview-float-value self)
  (tell #:type _float (coerce-arg self) floatValue))
(define (nstableview-set-float-value! self value)
  (_msg-32 (coerce-arg self) (sel_registerName "setFloatValue:") value))
(define (nstableview-floats-group-rows self)
  (tell #:type _bool (coerce-arg self) floatsGroupRows))
(define (nstableview-set-floats-group-rows! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setFloatsGroupRows:") value))
(define (nstableview-focus-ring-mask-bounds self)
  (tell #:type _NSRect (coerce-arg self) focusRingMaskBounds))
(define (nstableview-focus-ring-type self)
  (tell #:type _uint64 (coerce-arg self) focusRingType))
(define (nstableview-set-focus-ring-type! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setFocusRingType:") value))
(define (nstableview-focus-view)
  (wrap-objc-object
   (tell NSTableView focusView)))
(define (nstableview-font self)
  (wrap-objc-object
   (tell (coerce-arg self) font)))
(define (nstableview-set-font! self value)
  (tell #:type _void (coerce-arg self) setFont: (coerce-arg value)))
(define (nstableview-formatter self)
  (wrap-objc-object
   (tell (coerce-arg self) formatter)))
(define (nstableview-set-formatter! self value)
  (tell #:type _void (coerce-arg self) setFormatter: (coerce-arg value)))
(define (nstableview-frame self)
  (tell #:type _NSRect (coerce-arg self) frame))
(define (nstableview-set-frame! self value)
  (_msg-21 (coerce-arg self) (sel_registerName "setFrame:") value))
(define (nstableview-frame-center-rotation self)
  (tell #:type _double (coerce-arg self) frameCenterRotation))
(define (nstableview-set-frame-center-rotation! self value)
  (_msg-31 (coerce-arg self) (sel_registerName "setFrameCenterRotation:") value))
(define (nstableview-frame-rotation self)
  (tell #:type _double (coerce-arg self) frameRotation))
(define (nstableview-set-frame-rotation! self value)
  (_msg-31 (coerce-arg self) (sel_registerName "setFrameRotation:") value))
(define (nstableview-gesture-recognizers self)
  (wrap-objc-object
   (tell (coerce-arg self) gestureRecognizers)))
(define (nstableview-set-gesture-recognizers! self value)
  (tell #:type _void (coerce-arg self) setGestureRecognizers: (coerce-arg value)))
(define (nstableview-grid-color self)
  (wrap-objc-object
   (tell (coerce-arg self) gridColor)))
(define (nstableview-set-grid-color! self value)
  (tell #:type _void (coerce-arg self) setGridColor: (coerce-arg value)))
(define (nstableview-grid-style-mask self)
  (tell #:type _uint64 (coerce-arg self) gridStyleMask))
(define (nstableview-set-grid-style-mask! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setGridStyleMask:") value))
(define (nstableview-has-ambiguous-layout self)
  (tell #:type _bool (coerce-arg self) hasAmbiguousLayout))
(define (nstableview-header-view self)
  (wrap-objc-object
   (tell (coerce-arg self) headerView)))
(define (nstableview-set-header-view! self value)
  (tell #:type _void (coerce-arg self) setHeaderView: (coerce-arg value)))
(define (nstableview-height-adjust-limit self)
  (tell #:type _double (coerce-arg self) heightAdjustLimit))
(define (nstableview-height-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) heightAnchor)))
(define (nstableview-hidden self)
  (tell #:type _bool (coerce-arg self) hidden))
(define (nstableview-set-hidden! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setHidden:") value))
(define (nstableview-hidden-or-has-hidden-ancestor self)
  (tell #:type _bool (coerce-arg self) hiddenOrHasHiddenAncestor))
(define (nstableview-hidden-row-indexes self)
  (wrap-objc-object
   (tell (coerce-arg self) hiddenRowIndexes)))
(define (nstableview-highlighted self)
  (tell #:type _bool (coerce-arg self) highlighted))
(define (nstableview-set-highlighted! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setHighlighted:") value))
(define (nstableview-highlighted-table-column self)
  (wrap-objc-object
   (tell (coerce-arg self) highlightedTableColumn)))
(define (nstableview-set-highlighted-table-column! self value)
  (tell #:type _void (coerce-arg self) setHighlightedTableColumn: (coerce-arg value)))
(define (nstableview-horizontal-content-size-constraint-active self)
  (tell #:type _bool (coerce-arg self) horizontalContentSizeConstraintActive))
(define (nstableview-set-horizontal-content-size-constraint-active! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setHorizontalContentSizeConstraintActive:") value))
(define (nstableview-ignores-multi-click self)
  (tell #:type _bool (coerce-arg self) ignoresMultiClick))
(define (nstableview-set-ignores-multi-click! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setIgnoresMultiClick:") value))
(define (nstableview-in-full-screen-mode self)
  (tell #:type _bool (coerce-arg self) inFullScreenMode))
(define (nstableview-in-live-resize self)
  (tell #:type _bool (coerce-arg self) inLiveResize))
(define (nstableview-input-context self)
  (wrap-objc-object
   (tell (coerce-arg self) inputContext)))
(define (nstableview-int-value self)
  (tell #:type _int32 (coerce-arg self) intValue))
(define (nstableview-set-int-value! self value)
  (_msg-41 (coerce-arg self) (sel_registerName "setIntValue:") value))
(define (nstableview-integer-value self)
  (tell #:type _int64 (coerce-arg self) integerValue))
(define (nstableview-set-integer-value! self value)
  (_msg-45 (coerce-arg self) (sel_registerName "setIntegerValue:") value))
(define (nstableview-intercell-spacing self)
  (tell #:type _NSSize (coerce-arg self) intercellSpacing))
(define (nstableview-set-intercell-spacing! self value)
  (_msg-28 (coerce-arg self) (sel_registerName "setIntercellSpacing:") value))
(define (nstableview-intrinsic-content-size self)
  (tell #:type _NSSize (coerce-arg self) intrinsicContentSize))
(define (nstableview-last-baseline-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) lastBaselineAnchor)))
(define (nstableview-last-baseline-offset-from-bottom self)
  (tell #:type _double (coerce-arg self) lastBaselineOffsetFromBottom))
(define (nstableview-layer self)
  (wrap-objc-object
   (tell (coerce-arg self) layer)))
(define (nstableview-set-layer! self value)
  (tell #:type _void (coerce-arg self) setLayer: (coerce-arg value)))
(define (nstableview-layer-contents-placement self)
  (tell #:type _uint64 (coerce-arg self) layerContentsPlacement))
(define (nstableview-set-layer-contents-placement! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setLayerContentsPlacement:") value))
(define (nstableview-layer-contents-redraw-policy self)
  (tell #:type _uint64 (coerce-arg self) layerContentsRedrawPolicy))
(define (nstableview-set-layer-contents-redraw-policy! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setLayerContentsRedrawPolicy:") value))
(define (nstableview-layer-uses-core-image-filters self)
  (tell #:type _bool (coerce-arg self) layerUsesCoreImageFilters))
(define (nstableview-set-layer-uses-core-image-filters! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setLayerUsesCoreImageFilters:") value))
(define (nstableview-layout-guides self)
  (wrap-objc-object
   (tell (coerce-arg self) layoutGuides)))
(define (nstableview-layout-margins-guide self)
  (wrap-objc-object
   (tell (coerce-arg self) layoutMarginsGuide)))
(define (nstableview-leading-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) leadingAnchor)))
(define (nstableview-left-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) leftAnchor)))
(define (nstableview-line-break-mode self)
  (tell #:type _uint64 (coerce-arg self) lineBreakMode))
(define (nstableview-set-line-break-mode! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setLineBreakMode:") value))
(define (nstableview-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) menu)))
(define (nstableview-set-menu! self value)
  (tell #:type _void (coerce-arg self) setMenu: (coerce-arg value)))
(define (nstableview-mouse-down-can-move-window self)
  (tell #:type _bool (coerce-arg self) mouseDownCanMoveWindow))
(define (nstableview-needs-display self)
  (tell #:type _bool (coerce-arg self) needsDisplay))
(define (nstableview-set-needs-display! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setNeedsDisplay:") value))
(define (nstableview-needs-layout self)
  (tell #:type _bool (coerce-arg self) needsLayout))
(define (nstableview-set-needs-layout! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setNeedsLayout:") value))
(define (nstableview-needs-panel-to-become-key self)
  (tell #:type _bool (coerce-arg self) needsPanelToBecomeKey))
(define (nstableview-needs-update-constraints self)
  (tell #:type _bool (coerce-arg self) needsUpdateConstraints))
(define (nstableview-set-needs-update-constraints! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setNeedsUpdateConstraints:") value))
(define (nstableview-next-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) nextKeyView)))
(define (nstableview-set-next-key-view! self value)
  (tell #:type _void (coerce-arg self) setNextKeyView: (coerce-arg value)))
(define (nstableview-next-responder self)
  (wrap-objc-object
   (tell (coerce-arg self) nextResponder)))
(define (nstableview-set-next-responder! self value)
  (tell #:type _void (coerce-arg self) setNextResponder: (coerce-arg value)))
(define (nstableview-next-valid-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) nextValidKeyView)))
(define (nstableview-number-of-columns self)
  (tell #:type _int64 (coerce-arg self) numberOfColumns))
(define (nstableview-number-of-rows self)
  (tell #:type _int64 (coerce-arg self) numberOfRows))
(define (nstableview-number-of-selected-columns self)
  (tell #:type _int64 (coerce-arg self) numberOfSelectedColumns))
(define (nstableview-number-of-selected-rows self)
  (tell #:type _int64 (coerce-arg self) numberOfSelectedRows))
(define (nstableview-object-value self)
  (wrap-objc-object
   (tell (coerce-arg self) objectValue)))
(define (nstableview-set-object-value! self value)
  (tell #:type _void (coerce-arg self) setObjectValue: (coerce-arg value)))
(define (nstableview-opaque self)
  (tell #:type _bool (coerce-arg self) opaque))
(define (nstableview-opaque-ancestor self)
  (wrap-objc-object
   (tell (coerce-arg self) opaqueAncestor)))
(define (nstableview-page-footer self)
  (wrap-objc-object
   (tell (coerce-arg self) pageFooter)))
(define (nstableview-page-header self)
  (wrap-objc-object
   (tell (coerce-arg self) pageHeader)))
(define (nstableview-posts-bounds-changed-notifications self)
  (tell #:type _bool (coerce-arg self) postsBoundsChangedNotifications))
(define (nstableview-set-posts-bounds-changed-notifications! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setPostsBoundsChangedNotifications:") value))
(define (nstableview-posts-frame-changed-notifications self)
  (tell #:type _bool (coerce-arg self) postsFrameChangedNotifications))
(define (nstableview-set-posts-frame-changed-notifications! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setPostsFrameChangedNotifications:") value))
(define (nstableview-prefers-compact-control-size-metrics self)
  (tell #:type _bool (coerce-arg self) prefersCompactControlSizeMetrics))
(define (nstableview-set-prefers-compact-control-size-metrics! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setPrefersCompactControlSizeMetrics:") value))
(define (nstableview-prepared-content-rect self)
  (tell #:type _NSRect (coerce-arg self) preparedContentRect))
(define (nstableview-set-prepared-content-rect! self value)
  (_msg-21 (coerce-arg self) (sel_registerName "setPreparedContentRect:") value))
(define (nstableview-preserves-content-during-live-resize self)
  (tell #:type _bool (coerce-arg self) preservesContentDuringLiveResize))
(define (nstableview-pressure-configuration self)
  (wrap-objc-object
   (tell (coerce-arg self) pressureConfiguration)))
(define (nstableview-set-pressure-configuration! self value)
  (tell #:type _void (coerce-arg self) setPressureConfiguration: (coerce-arg value)))
(define (nstableview-previous-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) previousKeyView)))
(define (nstableview-previous-valid-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) previousValidKeyView)))
(define (nstableview-print-job-title self)
  (wrap-objc-object
   (tell (coerce-arg self) printJobTitle)))
(define (nstableview-rect-preserved-during-live-resize self)
  (tell #:type _NSRect (coerce-arg self) rectPreservedDuringLiveResize))
(define (nstableview-refuses-first-responder self)
  (tell #:type _bool (coerce-arg self) refusesFirstResponder))
(define (nstableview-set-refuses-first-responder! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setRefusesFirstResponder:") value))
(define (nstableview-registered-dragged-types self)
  (wrap-objc-object
   (tell (coerce-arg self) registeredDraggedTypes)))
(define (nstableview-registered-nibs-by-identifier self)
  (wrap-objc-object
   (tell (coerce-arg self) registeredNibsByIdentifier)))
(define (nstableview-requires-constraint-based-layout)
  (tell #:type _bool NSTableView requiresConstraintBasedLayout))
(define (nstableview-restorable-state-key-paths)
  (wrap-objc-object
   (tell NSTableView restorableStateKeyPaths)))
(define (nstableview-right-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) rightAnchor)))
(define (nstableview-rotated-from-base self)
  (tell #:type _bool (coerce-arg self) rotatedFromBase))
(define (nstableview-rotated-or-scaled-from-base self)
  (tell #:type _bool (coerce-arg self) rotatedOrScaledFromBase))
(define (nstableview-row-actions-visible self)
  (tell #:type _bool (coerce-arg self) rowActionsVisible))
(define (nstableview-set-row-actions-visible! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setRowActionsVisible:") value))
(define (nstableview-row-height self)
  (tell #:type _double (coerce-arg self) rowHeight))
(define (nstableview-set-row-height! self value)
  (_msg-31 (coerce-arg self) (sel_registerName "setRowHeight:") value))
(define (nstableview-row-size-style self)
  (tell #:type _uint64 (coerce-arg self) rowSizeStyle))
(define (nstableview-set-row-size-style! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setRowSizeStyle:") value))
(define (nstableview-safe-area-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) safeAreaInsets))
(define (nstableview-safe-area-layout-guide self)
  (wrap-objc-object
   (tell (coerce-arg self) safeAreaLayoutGuide)))
(define (nstableview-safe-area-rect self)
  (tell #:type _NSRect (coerce-arg self) safeAreaRect))
(define (nstableview-selected-column self)
  (tell #:type _int64 (coerce-arg self) selectedColumn))
(define (nstableview-selected-column-indexes self)
  (wrap-objc-object
   (tell (coerce-arg self) selectedColumnIndexes)))
(define (nstableview-selected-row self)
  (tell #:type _int64 (coerce-arg self) selectedRow))
(define (nstableview-selected-row-indexes self)
  (wrap-objc-object
   (tell (coerce-arg self) selectedRowIndexes)))
(define (nstableview-selection-highlight-style self)
  (tell #:type _uint64 (coerce-arg self) selectionHighlightStyle))
(define (nstableview-set-selection-highlight-style! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setSelectionHighlightStyle:") value))
(define (nstableview-shadow self)
  (wrap-objc-object
   (tell (coerce-arg self) shadow)))
(define (nstableview-set-shadow! self value)
  (tell #:type _void (coerce-arg self) setShadow: (coerce-arg value)))
(define (nstableview-sort-descriptors self)
  (wrap-objc-object
   (tell (coerce-arg self) sortDescriptors)))
(define (nstableview-set-sort-descriptors! self value)
  (tell #:type _void (coerce-arg self) setSortDescriptors: (coerce-arg value)))
(define (nstableview-string-value self)
  (wrap-objc-object
   (tell (coerce-arg self) stringValue)))
(define (nstableview-set-string-value! self value)
  (tell #:type _void (coerce-arg self) setStringValue: (coerce-arg value)))
(define (nstableview-style self)
  (tell #:type _uint64 (coerce-arg self) style))
(define (nstableview-set-style! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setStyle:") value))
(define (nstableview-subviews self)
  (wrap-objc-object
   (tell (coerce-arg self) subviews)))
(define (nstableview-set-subviews! self value)
  (tell #:type _void (coerce-arg self) setSubviews: (coerce-arg value)))
(define (nstableview-superview self)
  (wrap-objc-object
   (tell (coerce-arg self) superview)))
(define (nstableview-table-columns self)
  (wrap-objc-object
   (tell (coerce-arg self) tableColumns)))
(define (nstableview-tag self)
  (tell #:type _int64 (coerce-arg self) tag))
(define (nstableview-set-tag! self value)
  (_msg-45 (coerce-arg self) (sel_registerName "setTag:") value))
(define (nstableview-target self)
  (wrap-objc-object
   (tell (coerce-arg self) target)))
(define (nstableview-set-target! self value)
  (tell #:type _void (coerce-arg self) setTarget: (coerce-arg value)))
(define (nstableview-tool-tip self)
  (wrap-objc-object
   (tell (coerce-arg self) toolTip)))
(define (nstableview-set-tool-tip! self value)
  (tell #:type _void (coerce-arg self) setToolTip: (coerce-arg value)))
(define (nstableview-top-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) topAnchor)))
(define (nstableview-touch-bar self)
  (wrap-objc-object
   (tell (coerce-arg self) touchBar)))
(define (nstableview-set-touch-bar! self value)
  (tell #:type _void (coerce-arg self) setTouchBar: (coerce-arg value)))
(define (nstableview-tracking-areas self)
  (wrap-objc-object
   (tell (coerce-arg self) trackingAreas)))
(define (nstableview-trailing-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) trailingAnchor)))
(define (nstableview-translates-autoresizing-mask-into-constraints self)
  (tell #:type _bool (coerce-arg self) translatesAutoresizingMaskIntoConstraints))
(define (nstableview-set-translates-autoresizing-mask-into-constraints! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setTranslatesAutoresizingMaskIntoConstraints:") value))
(define (nstableview-undo-manager self)
  (wrap-objc-object
   (tell (coerce-arg self) undoManager)))
(define (nstableview-user-activity self)
  (wrap-objc-object
   (tell (coerce-arg self) userActivity)))
(define (nstableview-set-user-activity! self value)
  (tell #:type _void (coerce-arg self) setUserActivity: (coerce-arg value)))
(define (nstableview-user-interface-layout-direction self)
  (tell #:type _uint64 (coerce-arg self) userInterfaceLayoutDirection))
(define (nstableview-set-user-interface-layout-direction! self value)
  (_msg-59 (coerce-arg self) (sel_registerName "setUserInterfaceLayoutDirection:") value))
(define (nstableview-uses-alternating-row-background-colors self)
  (tell #:type _bool (coerce-arg self) usesAlternatingRowBackgroundColors))
(define (nstableview-set-uses-alternating-row-background-colors! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setUsesAlternatingRowBackgroundColors:") value))
(define (nstableview-uses-automatic-row-heights self)
  (tell #:type _bool (coerce-arg self) usesAutomaticRowHeights))
(define (nstableview-set-uses-automatic-row-heights! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setUsesAutomaticRowHeights:") value))
(define (nstableview-uses-single-line-mode self)
  (tell #:type _bool (coerce-arg self) usesSingleLineMode))
(define (nstableview-set-uses-single-line-mode! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setUsesSingleLineMode:") value))
(define (nstableview-uses-static-contents self)
  (tell #:type _bool (coerce-arg self) usesStaticContents))
(define (nstableview-set-uses-static-contents! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setUsesStaticContents:") value))
(define (nstableview-vertical-content-size-constraint-active self)
  (tell #:type _bool (coerce-arg self) verticalContentSizeConstraintActive))
(define (nstableview-set-vertical-content-size-constraint-active! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setVerticalContentSizeConstraintActive:") value))
(define (nstableview-vertical-motion-can-begin-drag self)
  (tell #:type _bool (coerce-arg self) verticalMotionCanBeginDrag))
(define (nstableview-set-vertical-motion-can-begin-drag! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setVerticalMotionCanBeginDrag:") value))
(define (nstableview-visible-rect self)
  (tell #:type _NSRect (coerce-arg self) visibleRect))
(define (nstableview-wants-best-resolution-open-gl-surface self)
  (tell #:type _bool (coerce-arg self) wantsBestResolutionOpenGLSurface))
(define (nstableview-set-wants-best-resolution-open-gl-surface! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setWantsBestResolutionOpenGLSurface:") value))
(define (nstableview-wants-default-clipping self)
  (tell #:type _bool (coerce-arg self) wantsDefaultClipping))
(define (nstableview-wants-extended-dynamic-range-open-gl-surface self)
  (tell #:type _bool (coerce-arg self) wantsExtendedDynamicRangeOpenGLSurface))
(define (nstableview-set-wants-extended-dynamic-range-open-gl-surface! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setWantsExtendedDynamicRangeOpenGLSurface:") value))
(define (nstableview-wants-layer self)
  (tell #:type _bool (coerce-arg self) wantsLayer))
(define (nstableview-set-wants-layer! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setWantsLayer:") value))
(define (nstableview-wants-resting-touches self)
  (tell #:type _bool (coerce-arg self) wantsRestingTouches))
(define (nstableview-set-wants-resting-touches! self value)
  (_msg-30 (coerce-arg self) (sel_registerName "setWantsRestingTouches:") value))
(define (nstableview-wants-update-layer self)
  (tell #:type _bool (coerce-arg self) wantsUpdateLayer))
(define (nstableview-width-adjust-limit self)
  (tell #:type _double (coerce-arg self) widthAdjustLimit))
(define (nstableview-width-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) widthAnchor)))
(define (nstableview-window self)
  (wrap-objc-object
   (tell (coerce-arg self) window)))
(define (nstableview-writing-tools-coordinator self)
  (wrap-objc-object
   (tell (coerce-arg self) writingToolsCoordinator)))
(define (nstableview-set-writing-tools-coordinator! self value)
  (tell #:type _void (coerce-arg self) setWritingToolsCoordinator: (coerce-arg value)))

;; --- Instance methods ---
(define (nstableview-accepts-first-mouse self event)
  (_msg-33 (coerce-arg self) (sel_registerName "acceptsFirstMouse:") (coerce-arg event)))
(define (nstableview-add-subview! self view)
  (tell #:type _void (coerce-arg self) addSubview: (coerce-arg view)))
(define (nstableview-add-subview-positioned-relative-to! self view place other-view)
  (_msg-40 (coerce-arg self) (sel_registerName "addSubview:positioned:relativeTo:") (coerce-arg view) place (coerce-arg other-view)))
(define (nstableview-add-table-column! self table-column)
  (tell #:type _void (coerce-arg self) addTableColumn: (coerce-arg table-column)))
(define (nstableview-add-tool-tip-rect-owner-user-data! self rect owner data)
  (_msg-25 (coerce-arg self) (sel_registerName "addToolTipRect:owner:userData:") rect (coerce-arg owner) data))
(define (nstableview-adjust-scroll self new-visible)
  (_msg-18 (coerce-arg self) (sel_registerName "adjustScroll:") new-visible))
(define (nstableview-ancestor-shared-with-view self view)
  (wrap-objc-object
   (tell (coerce-arg self) ancestorSharedWithView: (coerce-arg view))))
(define (nstableview-autoscroll self event)
  (_msg-33 (coerce-arg self) (sel_registerName "autoscroll:") (coerce-arg event)))
(define (nstableview-backing-aligned-rect-options self rect options)
  (_msg-26 (coerce-arg self) (sel_registerName "backingAlignedRect:options:") rect options))
(define (nstableview-become-first-responder self)
  (_msg-2 (coerce-arg self) (sel_registerName "becomeFirstResponder")))
(define (nstableview-begin-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) beginGestureWithEvent: (coerce-arg event)))
(define (nstableview-begin-updates! self)
  (tell #:type _void (coerce-arg self) beginUpdates))
(define (nstableview-bitmap-image-rep-for-caching-display-in-rect self rect)
  (wrap-objc-object
   (_msg-20 (coerce-arg self) (sel_registerName "bitmapImageRepForCachingDisplayInRect:") rect)
   ))
(define (nstableview-cache-display-in-rect-to-bitmap-image-rep self rect bitmap-image-rep)
  (_msg-24 (coerce-arg self) (sel_registerName "cacheDisplayInRect:toBitmapImageRep:") rect (coerce-arg bitmap-image-rep)))
(define (nstableview-can-drag-rows-with-indexes-at-point self row-indexes mouse-down-point)
  (_msg-35 (coerce-arg self) (sel_registerName "canDragRowsWithIndexes:atPoint:") (coerce-arg row-indexes) mouse-down-point))
(define (nstableview-center-scan-rect! self rect)
  (_msg-18 (coerce-arg self) (sel_registerName "centerScanRect:") rect))
(define (nstableview-change-mode-with-event self event)
  (tell #:type _void (coerce-arg self) changeModeWithEvent: (coerce-arg event)))
(define (nstableview-column-at-point self point)
  (_msg-12 (coerce-arg self) (sel_registerName "columnAtPoint:") point))
(define (nstableview-column-for-view self view)
  (_msg-34 (coerce-arg self) (sel_registerName "columnForView:") (coerce-arg view)))
(define (nstableview-column-indexes-in-rect self rect)
  (wrap-objc-object
   (_msg-20 (coerce-arg self) (sel_registerName "columnIndexesInRect:") rect)
   ))
(define (nstableview-column-with-identifier self identifier)
  (_msg-34 (coerce-arg self) (sel_registerName "columnWithIdentifier:") (coerce-arg identifier)))
(define (nstableview-context-menu-key-down self event)
  (tell #:type _void (coerce-arg self) contextMenuKeyDown: (coerce-arg event)))
(define (nstableview-convert-point-from-view self point view)
  (_msg-16 (coerce-arg self) (sel_registerName "convertPoint:fromView:") point (coerce-arg view)))
(define (nstableview-convert-point-to-view self point view)
  (_msg-16 (coerce-arg self) (sel_registerName "convertPoint:toView:") point (coerce-arg view)))
(define (nstableview-convert-point-from-backing self point)
  (_msg-10 (coerce-arg self) (sel_registerName "convertPointFromBacking:") point))
(define (nstableview-convert-point-from-layer self point)
  (_msg-10 (coerce-arg self) (sel_registerName "convertPointFromLayer:") point))
(define (nstableview-convert-point-to-backing self point)
  (_msg-10 (coerce-arg self) (sel_registerName "convertPointToBacking:") point))
(define (nstableview-convert-point-to-layer self point)
  (_msg-10 (coerce-arg self) (sel_registerName "convertPointToLayer:") point))
(define (nstableview-convert-rect-from-view self rect view)
  (_msg-23 (coerce-arg self) (sel_registerName "convertRect:fromView:") rect (coerce-arg view)))
(define (nstableview-convert-rect-to-view self rect view)
  (_msg-23 (coerce-arg self) (sel_registerName "convertRect:toView:") rect (coerce-arg view)))
(define (nstableview-convert-rect-from-backing self rect)
  (_msg-18 (coerce-arg self) (sel_registerName "convertRectFromBacking:") rect))
(define (nstableview-convert-rect-from-layer self rect)
  (_msg-18 (coerce-arg self) (sel_registerName "convertRectFromLayer:") rect))
(define (nstableview-convert-rect-to-backing self rect)
  (_msg-18 (coerce-arg self) (sel_registerName "convertRectToBacking:") rect))
(define (nstableview-convert-rect-to-layer self rect)
  (_msg-18 (coerce-arg self) (sel_registerName "convertRectToLayer:") rect))
(define (nstableview-convert-size-from-view self size view)
  (_msg-29 (coerce-arg self) (sel_registerName "convertSize:fromView:") size (coerce-arg view)))
(define (nstableview-convert-size-to-view self size view)
  (_msg-29 (coerce-arg self) (sel_registerName "convertSize:toView:") size (coerce-arg view)))
(define (nstableview-convert-size-from-backing self size)
  (_msg-27 (coerce-arg self) (sel_registerName "convertSizeFromBacking:") size))
(define (nstableview-convert-size-from-layer self size)
  (_msg-27 (coerce-arg self) (sel_registerName "convertSizeFromLayer:") size))
(define (nstableview-convert-size-to-backing self size)
  (_msg-27 (coerce-arg self) (sel_registerName "convertSizeToBacking:") size))
(define (nstableview-convert-size-to-layer self size)
  (_msg-27 (coerce-arg self) (sel_registerName "convertSizeToLayer:") size))
(define (nstableview-cursor-update self event)
  (tell #:type _void (coerce-arg self) cursorUpdate: (coerce-arg event)))
(define (nstableview-deselect-all self sender)
  (tell #:type _void (coerce-arg self) deselectAll: (coerce-arg sender)))
(define (nstableview-deselect-column self column)
  (_msg-45 (coerce-arg self) (sel_registerName "deselectColumn:") column))
(define (nstableview-deselect-row self row)
  (_msg-45 (coerce-arg self) (sel_registerName "deselectRow:") row))
(define (nstableview-did-add-row-view-for-row self row-view row)
  (_msg-38 (coerce-arg self) (sel_registerName "didAddRowView:forRow:") (coerce-arg row-view) row))
(define (nstableview-did-add-subview self subview)
  (tell #:type _void (coerce-arg self) didAddSubview: (coerce-arg subview)))
(define (nstableview-did-close-menu-with-event self menu event)
  (tell #:type _void (coerce-arg self) didCloseMenu: (coerce-arg menu) withEvent: (coerce-arg event)))
(define (nstableview-did-remove-row-view-for-row self row-view row)
  (_msg-38 (coerce-arg self) (sel_registerName "didRemoveRowView:forRow:") (coerce-arg row-view) row))
(define (nstableview-display! self)
  (tell #:type _void (coerce-arg self) display))
(define (nstableview-display-if-needed! self)
  (tell #:type _void (coerce-arg self) displayIfNeeded))
(define (nstableview-display-if-needed-ignoring-opacity! self)
  (tell #:type _void (coerce-arg self) displayIfNeededIgnoringOpacity))
(define (nstableview-display-if-needed-in-rect! self rect)
  (_msg-21 (coerce-arg self) (sel_registerName "displayIfNeededInRect:") rect))
(define (nstableview-display-if-needed-in-rect-ignoring-opacity! self rect)
  (_msg-21 (coerce-arg self) (sel_registerName "displayIfNeededInRectIgnoringOpacity:") rect))
(define (nstableview-display-rect! self rect)
  (_msg-21 (coerce-arg self) (sel_registerName "displayRect:") rect))
(define (nstableview-display-rect-ignoring-opacity! self rect)
  (_msg-21 (coerce-arg self) (sel_registerName "displayRectIgnoringOpacity:") rect))
(define (nstableview-display-rect-ignoring-opacity-in-context! self rect context)
  (_msg-24 (coerce-arg self) (sel_registerName "displayRectIgnoringOpacity:inContext:") rect (coerce-arg context)))
(define (nstableview-drag-image-for-rows-with-indexes-table-columns-event-offset self drag-rows table-columns drag-event drag-image-offset)
  (wrap-objc-object
   (_msg-37 (coerce-arg self) (sel_registerName "dragImageForRowsWithIndexes:tableColumns:event:offset:") (coerce-arg drag-rows) (coerce-arg table-columns) (coerce-arg drag-event) drag-image-offset)
   ))
(define (nstableview-draw-background-in-clip-rect self clip-rect)
  (_msg-21 (coerce-arg self) (sel_registerName "drawBackgroundInClipRect:") clip-rect))
(define (nstableview-draw-grid-in-clip-rect self clip-rect)
  (_msg-21 (coerce-arg self) (sel_registerName "drawGridInClipRect:") clip-rect))
(define (nstableview-draw-rect self dirty-rect)
  (_msg-21 (coerce-arg self) (sel_registerName "drawRect:") dirty-rect))
(define (nstableview-draw-row-clip-rect self row clip-rect)
  (_msg-46 (coerce-arg self) (sel_registerName "drawRow:clipRect:") row clip-rect))
(define (nstableview-draw-with-expansion-frame-in-view self content-frame view)
  (_msg-24 (coerce-arg self) (sel_registerName "drawWithExpansionFrame:inView:") content-frame (coerce-arg view)))
(define (nstableview-edit-column-row-with-event-select self column row event select)
  (_msg-51 (coerce-arg self) (sel_registerName "editColumn:row:withEvent:select:") column row (coerce-arg event) select))
(define (nstableview-end-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) endGestureWithEvent: (coerce-arg event)))
(define (nstableview-end-updates! self)
  (tell #:type _void (coerce-arg self) endUpdates))
(define (nstableview-enumerate-available-row-views-using-block self handler)
  (define-values (_blk0 _blk0-id)
    (make-objc-block handler (list _id _int64) _void))
  (_msg-53 (coerce-arg self) (sel_registerName "enumerateAvailableRowViewsUsingBlock:") _blk0))
(define (nstableview-expansion-frame-with-frame self content-frame)
  (_msg-18 (coerce-arg self) (sel_registerName "expansionFrameWithFrame:") content-frame))
(define (nstableview-flags-changed self event)
  (tell #:type _void (coerce-arg self) flagsChanged: (coerce-arg event)))
(define (nstableview-flush-buffered-key-events self)
  (tell #:type _void (coerce-arg self) flushBufferedKeyEvents))
(define (nstableview-frame-of-cell-at-column-row self column row)
  (_msg-48 (coerce-arg self) (sel_registerName "frameOfCellAtColumn:row:") column row))
(define (nstableview-get-rects-being-drawn-count self rects count)
  (_msg-56 (coerce-arg self) (sel_registerName "getRectsBeingDrawn:count:") rects count))
(define (nstableview-get-rects-exposed-during-live-resize-count self exposed-rects count)
  (_msg-56 (coerce-arg self) (sel_registerName "getRectsExposedDuringLiveResize:count:") exposed-rects count))
(define (nstableview-help-requested self event-ptr)
  (tell #:type _void (coerce-arg self) helpRequested: (coerce-arg event-ptr)))
(define (nstableview-hide-rows-at-indexes-with-animation self indexes row-animation)
  (_msg-39 (coerce-arg self) (sel_registerName "hideRowsAtIndexes:withAnimation:") (coerce-arg indexes) row-animation))
(define (nstableview-highlight-selection-in-clip-rect self clip-rect)
  (_msg-21 (coerce-arg self) (sel_registerName "highlightSelectionInClipRect:") clip-rect))
(define (nstableview-hit-test self point)
  (wrap-objc-object
   (_msg-11 (coerce-arg self) (sel_registerName "hitTest:") point)
   ))
(define (nstableview-indicator-image-in-table-column self table-column)
  (wrap-objc-object
   (tell (coerce-arg self) indicatorImageInTableColumn: (coerce-arg table-column))))
(define (nstableview-insert-rows-at-indexes-with-animation! self indexes animation-options)
  (_msg-39 (coerce-arg self) (sel_registerName "insertRowsAtIndexes:withAnimation:") (coerce-arg indexes) animation-options))
(define (nstableview-interpret-key-events self event-array)
  (tell #:type _void (coerce-arg self) interpretKeyEvents: (coerce-arg event-array)))
(define (nstableview-is-column-selected self column)
  (_msg-43 (coerce-arg self) (sel_registerName "isColumnSelected:") column))
(define (nstableview-is-continuous self)
  (_msg-2 (coerce-arg self) (sel_registerName "isContinuous")))
(define (nstableview-is-descendant-of self view)
  (_msg-33 (coerce-arg self) (sel_registerName "isDescendantOf:") (coerce-arg view)))
(define (nstableview-is-enabled self)
  (_msg-2 (coerce-arg self) (sel_registerName "isEnabled")))
(define (nstableview-is-flipped self)
  (_msg-2 (coerce-arg self) (sel_registerName "isFlipped")))
(define (nstableview-is-hidden self)
  (_msg-2 (coerce-arg self) (sel_registerName "isHidden")))
(define (nstableview-is-hidden-or-has-hidden-ancestor self)
  (_msg-2 (coerce-arg self) (sel_registerName "isHiddenOrHasHiddenAncestor")))
(define (nstableview-is-highlighted self)
  (_msg-2 (coerce-arg self) (sel_registerName "isHighlighted")))
(define (nstableview-is-opaque self)
  (_msg-2 (coerce-arg self) (sel_registerName "isOpaque")))
(define (nstableview-is-rotated-from-base self)
  (_msg-2 (coerce-arg self) (sel_registerName "isRotatedFromBase")))
(define (nstableview-is-rotated-or-scaled-from-base self)
  (_msg-2 (coerce-arg self) (sel_registerName "isRotatedOrScaledFromBase")))
(define (nstableview-is-row-selected self row)
  (_msg-43 (coerce-arg self) (sel_registerName "isRowSelected:") row))
(define (nstableview-key-down self event)
  (tell #:type _void (coerce-arg self) keyDown: (coerce-arg event)))
(define (nstableview-key-up self event)
  (tell #:type _void (coerce-arg self) keyUp: (coerce-arg event)))
(define (nstableview-layout self)
  (tell #:type _void (coerce-arg self) layout))
(define (nstableview-layout-subtree-if-needed self)
  (tell #:type _void (coerce-arg self) layoutSubtreeIfNeeded))
(define (nstableview-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) magnifyWithEvent: (coerce-arg event)))
(define (nstableview-make-backing-layer self)
  (wrap-objc-object
   (tell (coerce-arg self) makeBackingLayer)))
(define (nstableview-make-view-with-identifier-owner self identifier owner)
  (wrap-objc-object
   (tell (coerce-arg self) makeViewWithIdentifier: (coerce-arg identifier) owner: (coerce-arg owner))))
(define (nstableview-menu-for-event self event)
  (wrap-objc-object
   (tell (coerce-arg self) menuForEvent: (coerce-arg event))))
(define (nstableview-mouse-in-rect self point rect)
  (_msg-15 (coerce-arg self) (sel_registerName "mouse:inRect:") point rect))
(define (nstableview-mouse-cancelled self event)
  (tell #:type _void (coerce-arg self) mouseCancelled: (coerce-arg event)))
(define (nstableview-mouse-down self event)
  (tell #:type _void (coerce-arg self) mouseDown: (coerce-arg event)))
(define (nstableview-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) mouseDragged: (coerce-arg event)))
(define (nstableview-mouse-entered self event)
  (tell #:type _void (coerce-arg self) mouseEntered: (coerce-arg event)))
(define (nstableview-mouse-exited self event)
  (tell #:type _void (coerce-arg self) mouseExited: (coerce-arg event)))
(define (nstableview-mouse-moved self event)
  (tell #:type _void (coerce-arg self) mouseMoved: (coerce-arg event)))
(define (nstableview-mouse-up self event)
  (tell #:type _void (coerce-arg self) mouseUp: (coerce-arg event)))
(define (nstableview-move-column-to-column! self old-index new-index)
  (_msg-49 (coerce-arg self) (sel_registerName "moveColumn:toColumn:") old-index new-index))
(define (nstableview-move-row-at-index-to-index! self old-index new-index)
  (_msg-49 (coerce-arg self) (sel_registerName "moveRowAtIndex:toIndex:") old-index new-index))
(define (nstableview-needs-to-draw-rect self rect)
  (_msg-19 (coerce-arg self) (sel_registerName "needsToDrawRect:") rect))
(define (nstableview-no-responder-for self event-selector)
  (_msg-53 (coerce-arg self) (sel_registerName "noResponderFor:") event-selector))
(define (nstableview-note-height-of-rows-with-indexes-changed self index-set)
  (tell #:type _void (coerce-arg self) noteHeightOfRowsWithIndexesChanged: (coerce-arg index-set)))
(define (nstableview-note-number-of-rows-changed self)
  (tell #:type _void (coerce-arg self) noteNumberOfRowsChanged))
(define (nstableview-other-mouse-down self event)
  (tell #:type _void (coerce-arg self) otherMouseDown: (coerce-arg event)))
(define (nstableview-other-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) otherMouseDragged: (coerce-arg event)))
(define (nstableview-other-mouse-up self event)
  (tell #:type _void (coerce-arg self) otherMouseUp: (coerce-arg event)))
(define (nstableview-perform-click! self sender)
  (tell #:type _void (coerce-arg self) performClick: (coerce-arg sender)))
(define (nstableview-perform-key-equivalent! self event)
  (_msg-33 (coerce-arg self) (sel_registerName "performKeyEquivalent:") (coerce-arg event)))
(define (nstableview-prepare-content-in-rect self rect)
  (_msg-21 (coerce-arg self) (sel_registerName "prepareContentInRect:") rect))
(define (nstableview-prepare-for-reuse self)
  (tell #:type _void (coerce-arg self) prepareForReuse))
(define (nstableview-pressure-change-with-event self event)
  (tell #:type _void (coerce-arg self) pressureChangeWithEvent: (coerce-arg event)))
(define (nstableview-quick-look-with-event self event)
  (tell #:type _void (coerce-arg self) quickLookWithEvent: (coerce-arg event)))
(define (nstableview-rect-for-smart-magnification-at-point-in-rect self location visible-rect)
  (_msg-14 (coerce-arg self) (sel_registerName "rectForSmartMagnificationAtPoint:inRect:") location visible-rect))
(define (nstableview-rect-of-column self column)
  (_msg-42 (coerce-arg self) (sel_registerName "rectOfColumn:") column))
(define (nstableview-rect-of-row self row)
  (_msg-42 (coerce-arg self) (sel_registerName "rectOfRow:") row))
(define (nstableview-register-nib-for-identifier self nib identifier)
  (tell #:type _void (coerce-arg self) registerNib: (coerce-arg nib) forIdentifier: (coerce-arg identifier)))
(define (nstableview-reload-data self)
  (tell #:type _void (coerce-arg self) reloadData))
(define (nstableview-reload-data-for-row-indexes-column-indexes self row-indexes column-indexes)
  (tell #:type _void (coerce-arg self) reloadDataForRowIndexes: (coerce-arg row-indexes) columnIndexes: (coerce-arg column-indexes)))
(define (nstableview-remove-all-tool-tips! self)
  (tell #:type _void (coerce-arg self) removeAllToolTips))
(define (nstableview-remove-from-superview! self)
  (tell #:type _void (coerce-arg self) removeFromSuperview))
(define (nstableview-remove-from-superview-without-needing-display! self)
  (tell #:type _void (coerce-arg self) removeFromSuperviewWithoutNeedingDisplay))
(define (nstableview-remove-rows-at-indexes-with-animation! self indexes animation-options)
  (_msg-39 (coerce-arg self) (sel_registerName "removeRowsAtIndexes:withAnimation:") (coerce-arg indexes) animation-options))
(define (nstableview-remove-table-column! self table-column)
  (tell #:type _void (coerce-arg self) removeTableColumn: (coerce-arg table-column)))
(define (nstableview-remove-tool-tip! self tag)
  (_msg-45 (coerce-arg self) (sel_registerName "removeToolTip:") tag))
(define (nstableview-replace-subview-with! self old-view new-view)
  (tell #:type _void (coerce-arg self) replaceSubview: (coerce-arg old-view) with: (coerce-arg new-view)))
(define (nstableview-resign-first-responder self)
  (_msg-2 (coerce-arg self) (sel_registerName "resignFirstResponder")))
(define (nstableview-resize-subviews-with-old-size self old-size)
  (_msg-28 (coerce-arg self) (sel_registerName "resizeSubviewsWithOldSize:") old-size))
(define (nstableview-resize-with-old-superview-size self old-size)
  (_msg-28 (coerce-arg self) (sel_registerName "resizeWithOldSuperviewSize:") old-size))
(define (nstableview-right-mouse-down self event)
  (tell #:type _void (coerce-arg self) rightMouseDown: (coerce-arg event)))
(define (nstableview-right-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) rightMouseDragged: (coerce-arg event)))
(define (nstableview-right-mouse-up self event)
  (tell #:type _void (coerce-arg self) rightMouseUp: (coerce-arg event)))
(define (nstableview-rotate-by-angle self angle)
  (_msg-31 (coerce-arg self) (sel_registerName "rotateByAngle:") angle))
(define (nstableview-rotate-with-event self event)
  (tell #:type _void (coerce-arg self) rotateWithEvent: (coerce-arg event)))
(define (nstableview-row-at-point self point)
  (_msg-12 (coerce-arg self) (sel_registerName "rowAtPoint:") point))
(define (nstableview-row-for-view self view)
  (_msg-34 (coerce-arg self) (sel_registerName "rowForView:") (coerce-arg view)))
(define (nstableview-row-view-at-row-make-if-necessary self row make-if-necessary)
  (wrap-objc-object
   (_msg-47 (coerce-arg self) (sel_registerName "rowViewAtRow:makeIfNecessary:") row make-if-necessary)
   ))
(define (nstableview-rows-in-rect self rect)
  (_msg-17 (coerce-arg self) (sel_registerName "rowsInRect:") rect))
(define (nstableview-scale-unit-square-to-size self new-unit-size)
  (_msg-28 (coerce-arg self) (sel_registerName "scaleUnitSquareToSize:") new-unit-size))
(define (nstableview-scroll-column-to-visible self column)
  (_msg-45 (coerce-arg self) (sel_registerName "scrollColumnToVisible:") column))
(define (nstableview-scroll-point self point)
  (_msg-13 (coerce-arg self) (sel_registerName "scrollPoint:") point))
(define (nstableview-scroll-rect-to-visible self rect)
  (_msg-19 (coerce-arg self) (sel_registerName "scrollRectToVisible:") rect))
(define (nstableview-scroll-row-to-visible self row)
  (_msg-45 (coerce-arg self) (sel_registerName "scrollRowToVisible:") row))
(define (nstableview-scroll-wheel self event)
  (tell #:type _void (coerce-arg self) scrollWheel: (coerce-arg event)))
(define (nstableview-select-all self sender)
  (tell #:type _void (coerce-arg self) selectAll: (coerce-arg sender)))
(define (nstableview-select-column-indexes-by-extending-selection self indexes extend)
  (_msg-36 (coerce-arg self) (sel_registerName "selectColumnIndexes:byExtendingSelection:") (coerce-arg indexes) extend))
(define (nstableview-select-row-indexes-by-extending-selection self indexes extend)
  (_msg-36 (coerce-arg self) (sel_registerName "selectRowIndexes:byExtendingSelection:") (coerce-arg indexes) extend))
(define (nstableview-send-action-to self action target)
  (_msg-54 (coerce-arg self) (sel_registerName "sendAction:to:") action (coerce-arg target)))
(define (nstableview-send-action-on self mask)
  (_msg-58 (coerce-arg self) (sel_registerName "sendActionOn:") mask))
(define (nstableview-set-bounds-origin! self new-origin)
  (_msg-13 (coerce-arg self) (sel_registerName "setBoundsOrigin:") new-origin))
(define (nstableview-set-bounds-size! self new-size)
  (_msg-28 (coerce-arg self) (sel_registerName "setBoundsSize:") new-size))
(define (nstableview-set-dragging-source-operation-mask-for-local! self mask is-local)
  (_msg-60 (coerce-arg self) (sel_registerName "setDraggingSourceOperationMask:forLocal:") mask is-local))
(define (nstableview-set-drop-row-drop-operation! self row drop-operation)
  (_msg-52 (coerce-arg self) (sel_registerName "setDropRow:dropOperation:") row drop-operation))
(define (nstableview-set-frame-origin! self new-origin)
  (_msg-13 (coerce-arg self) (sel_registerName "setFrameOrigin:") new-origin))
(define (nstableview-set-frame-size! self new-size)
  (_msg-28 (coerce-arg self) (sel_registerName "setFrameSize:") new-size))
(define (nstableview-set-indicator-image-in-table-column! self image table-column)
  (tell #:type _void (coerce-arg self) setIndicatorImage: (coerce-arg image) inTableColumn: (coerce-arg table-column)))
(define (nstableview-set-needs-display-in-rect! self invalid-rect)
  (_msg-21 (coerce-arg self) (sel_registerName "setNeedsDisplayInRect:") invalid-rect))
(define (nstableview-should-be-treated-as-ink-event self event)
  (_msg-33 (coerce-arg self) (sel_registerName "shouldBeTreatedAsInkEvent:") (coerce-arg event)))
(define (nstableview-should-delay-window-ordering-for-event self event)
  (_msg-33 (coerce-arg self) (sel_registerName "shouldDelayWindowOrderingForEvent:") (coerce-arg event)))
(define (nstableview-show-context-help self sender)
  (tell #:type _void (coerce-arg self) showContextHelp: (coerce-arg sender)))
(define (nstableview-size-last-column-to-fit self)
  (tell #:type _void (coerce-arg self) sizeLastColumnToFit))
(define (nstableview-size-that-fits self size)
  (_msg-27 (coerce-arg self) (sel_registerName "sizeThatFits:") size))
(define (nstableview-size-to-fit self)
  (tell #:type _void (coerce-arg self) sizeToFit))
(define (nstableview-smart-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) smartMagnifyWithEvent: (coerce-arg event)))
(define (nstableview-sort-subviews-using-function-context self compare context)
  (_msg-56 (coerce-arg self) (sel_registerName "sortSubviewsUsingFunction:context:") compare context))
(define (nstableview-supplemental-target-for-action-sender self action sender)
  (wrap-objc-object
   (_msg-55 (coerce-arg self) (sel_registerName "supplementalTargetForAction:sender:") action (coerce-arg sender))
   ))
(define (nstableview-swipe-with-event self event)
  (tell #:type _void (coerce-arg self) swipeWithEvent: (coerce-arg event)))
(define (nstableview-table-column-with-identifier self identifier)
  (wrap-objc-object
   (tell (coerce-arg self) tableColumnWithIdentifier: (coerce-arg identifier))))
(define (nstableview-tablet-point self event)
  (tell #:type _void (coerce-arg self) tabletPoint: (coerce-arg event)))
(define (nstableview-tablet-proximity self event)
  (tell #:type _void (coerce-arg self) tabletProximity: (coerce-arg event)))
(define (nstableview-take-double-value-from self sender)
  (tell #:type _void (coerce-arg self) takeDoubleValueFrom: (coerce-arg sender)))
(define (nstableview-take-float-value-from self sender)
  (tell #:type _void (coerce-arg self) takeFloatValueFrom: (coerce-arg sender)))
(define (nstableview-take-int-value-from self sender)
  (tell #:type _void (coerce-arg self) takeIntValueFrom: (coerce-arg sender)))
(define (nstableview-take-integer-value-from self sender)
  (tell #:type _void (coerce-arg self) takeIntegerValueFrom: (coerce-arg sender)))
(define (nstableview-take-object-value-from self sender)
  (tell #:type _void (coerce-arg self) takeObjectValueFrom: (coerce-arg sender)))
(define (nstableview-take-string-value-from self sender)
  (tell #:type _void (coerce-arg self) takeStringValueFrom: (coerce-arg sender)))
(define (nstableview-tile self)
  (tell #:type _void (coerce-arg self) tile))
(define (nstableview-touches-began-with-event self event)
  (tell #:type _void (coerce-arg self) touchesBeganWithEvent: (coerce-arg event)))
(define (nstableview-touches-cancelled-with-event self event)
  (tell #:type _void (coerce-arg self) touchesCancelledWithEvent: (coerce-arg event)))
(define (nstableview-touches-ended-with-event self event)
  (tell #:type _void (coerce-arg self) touchesEndedWithEvent: (coerce-arg event)))
(define (nstableview-touches-moved-with-event self event)
  (tell #:type _void (coerce-arg self) touchesMovedWithEvent: (coerce-arg event)))
(define (nstableview-translate-origin-to-point self translation)
  (_msg-13 (coerce-arg self) (sel_registerName "translateOriginToPoint:") translation))
(define (nstableview-translate-rects-needing-display-in-rect-by self clip-rect delta)
  (_msg-22 (coerce-arg self) (sel_registerName "translateRectsNeedingDisplayInRect:by:") clip-rect delta))
(define (nstableview-try-to-perform-with self action object)
  (_msg-54 (coerce-arg self) (sel_registerName "tryToPerform:with:") action (coerce-arg object)))
(define (nstableview-unhide-rows-at-indexes-with-animation self indexes row-animation)
  (_msg-39 (coerce-arg self) (sel_registerName "unhideRowsAtIndexes:withAnimation:") (coerce-arg indexes) row-animation))
(define (nstableview-update-layer self)
  (tell #:type _void (coerce-arg self) updateLayer))
(define (nstableview-valid-requestor-for-send-type-return-type self send-type return-type)
  (wrap-objc-object
   (tell (coerce-arg self) validRequestorForSendType: (coerce-arg send-type) returnType: (coerce-arg return-type))))
(define (nstableview-view-at-column-row-make-if-necessary self column row make-if-necessary)
  (wrap-objc-object
   (_msg-50 (coerce-arg self) (sel_registerName "viewAtColumn:row:makeIfNecessary:") column row make-if-necessary)
   ))
(define (nstableview-view-did-change-backing-properties self)
  (tell #:type _void (coerce-arg self) viewDidChangeBackingProperties))
(define (nstableview-view-did-change-effective-appearance self)
  (tell #:type _void (coerce-arg self) viewDidChangeEffectiveAppearance))
(define (nstableview-view-did-end-live-resize self)
  (tell #:type _void (coerce-arg self) viewDidEndLiveResize))
(define (nstableview-view-did-hide self)
  (tell #:type _void (coerce-arg self) viewDidHide))
(define (nstableview-view-did-move-to-superview self)
  (tell #:type _void (coerce-arg self) viewDidMoveToSuperview))
(define (nstableview-view-did-move-to-window self)
  (tell #:type _void (coerce-arg self) viewDidMoveToWindow))
(define (nstableview-view-did-unhide self)
  (tell #:type _void (coerce-arg self) viewDidUnhide))
(define (nstableview-view-will-draw self)
  (tell #:type _void (coerce-arg self) viewWillDraw))
(define (nstableview-view-will-move-to-superview self new-superview)
  (tell #:type _void (coerce-arg self) viewWillMoveToSuperview: (coerce-arg new-superview)))
(define (nstableview-view-will-move-to-window self new-window)
  (tell #:type _void (coerce-arg self) viewWillMoveToWindow: (coerce-arg new-window)))
(define (nstableview-view-will-start-live-resize self)
  (tell #:type _void (coerce-arg self) viewWillStartLiveResize))
(define (nstableview-view-with-tag self tag)
  (wrap-objc-object
   (_msg-44 (coerce-arg self) (sel_registerName "viewWithTag:") tag)
   ))
(define (nstableview-wants-forwarded-scroll-events-for-axis self axis)
  (_msg-57 (coerce-arg self) (sel_registerName "wantsForwardedScrollEventsForAxis:") axis))
(define (nstableview-wants-scroll-events-for-swipe-tracking-on-axis self axis)
  (_msg-57 (coerce-arg self) (sel_registerName "wantsScrollEventsForSwipeTrackingOnAxis:") axis))
(define (nstableview-will-open-menu-with-event self menu event)
  (tell #:type _void (coerce-arg self) willOpenMenu: (coerce-arg menu) withEvent: (coerce-arg event)))
(define (nstableview-will-remove-subview self subview)
  (tell #:type _void (coerce-arg self) willRemoveSubview: (coerce-arg subview)))

;; --- Class methods ---
(define (nstableview-is-compatible-with-responsive-scrolling)
  (_msg-2 NSTableView (sel_registerName "isCompatibleWithResponsiveScrolling")))
