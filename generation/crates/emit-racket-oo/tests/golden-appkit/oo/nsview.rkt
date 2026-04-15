#lang racket/base
;; Generated binding for NSView (AppKit)
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

(provide NSView)
(provide/contract
  [make-nsview-init-with-coder (c-> (or/c string? objc-object? cpointer?) any/c)]
  [make-nsview-init-with-frame (c-> any/c any/c)]
  [nsview-accepts-first-responder (c-> objc-object? boolean?)]
  [nsview-accepts-touch-events (c-> objc-object? boolean?)]
  [nsview-set-accepts-touch-events! (c-> objc-object? boolean? void?)]
  [nsview-additional-safe-area-insets (c-> objc-object? any/c)]
  [nsview-set-additional-safe-area-insets! (c-> objc-object? any/c void?)]
  [nsview-alignment-rect-insets (c-> objc-object? any/c)]
  [nsview-allowed-touch-types (c-> objc-object? exact-nonnegative-integer?)]
  [nsview-set-allowed-touch-types! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsview-allows-vibrancy (c-> objc-object? boolean?)]
  [nsview-alpha-value (c-> objc-object? real?)]
  [nsview-set-alpha-value! (c-> objc-object? real? void?)]
  [nsview-autoresizes-subviews (c-> objc-object? boolean?)]
  [nsview-set-autoresizes-subviews! (c-> objc-object? boolean? void?)]
  [nsview-autoresizing-mask (c-> objc-object? exact-nonnegative-integer?)]
  [nsview-set-autoresizing-mask! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsview-background-filters (c-> objc-object? any/c)]
  [nsview-set-background-filters! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-baseline-offset-from-bottom (c-> objc-object? real?)]
  [nsview-bottom-anchor (c-> objc-object? any/c)]
  [nsview-bounds (c-> objc-object? any/c)]
  [nsview-set-bounds! (c-> objc-object? any/c void?)]
  [nsview-bounds-rotation (c-> objc-object? real?)]
  [nsview-set-bounds-rotation! (c-> objc-object? real? void?)]
  [nsview-can-become-key-view (c-> objc-object? boolean?)]
  [nsview-can-draw (c-> objc-object? boolean?)]
  [nsview-can-draw-concurrently (c-> objc-object? boolean?)]
  [nsview-set-can-draw-concurrently! (c-> objc-object? boolean? void?)]
  [nsview-can-draw-subviews-into-layer (c-> objc-object? boolean?)]
  [nsview-set-can-draw-subviews-into-layer! (c-> objc-object? boolean? void?)]
  [nsview-candidate-list-touch-bar-item (c-> objc-object? any/c)]
  [nsview-center-x-anchor (c-> objc-object? any/c)]
  [nsview-center-y-anchor (c-> objc-object? any/c)]
  [nsview-clips-to-bounds (c-> objc-object? boolean?)]
  [nsview-set-clips-to-bounds! (c-> objc-object? boolean? void?)]
  [nsview-compatible-with-responsive-scrolling (c-> boolean?)]
  [nsview-compositing-filter (c-> objc-object? any/c)]
  [nsview-set-compositing-filter! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-constraints (c-> objc-object? any/c)]
  [nsview-content-filters (c-> objc-object? any/c)]
  [nsview-set-content-filters! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-default-focus-ring-type (c-> exact-nonnegative-integer?)]
  [nsview-default-menu (c-> any/c)]
  [nsview-drawing-find-indicator (c-> objc-object? boolean?)]
  [nsview-enclosing-menu-item (c-> objc-object? any/c)]
  [nsview-enclosing-scroll-view (c-> objc-object? any/c)]
  [nsview-first-baseline-anchor (c-> objc-object? any/c)]
  [nsview-first-baseline-offset-from-top (c-> objc-object? real?)]
  [nsview-fitting-size (c-> objc-object? any/c)]
  [nsview-flipped (c-> objc-object? boolean?)]
  [nsview-focus-ring-mask-bounds (c-> objc-object? any/c)]
  [nsview-focus-ring-type (c-> objc-object? exact-nonnegative-integer?)]
  [nsview-set-focus-ring-type! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsview-focus-view (c-> any/c)]
  [nsview-frame (c-> objc-object? any/c)]
  [nsview-set-frame! (c-> objc-object? any/c void?)]
  [nsview-frame-center-rotation (c-> objc-object? real?)]
  [nsview-set-frame-center-rotation! (c-> objc-object? real? void?)]
  [nsview-frame-rotation (c-> objc-object? real?)]
  [nsview-set-frame-rotation! (c-> objc-object? real? void?)]
  [nsview-gesture-recognizers (c-> objc-object? any/c)]
  [nsview-set-gesture-recognizers! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-has-ambiguous-layout (c-> objc-object? boolean?)]
  [nsview-height-adjust-limit (c-> objc-object? real?)]
  [nsview-height-anchor (c-> objc-object? any/c)]
  [nsview-hidden (c-> objc-object? boolean?)]
  [nsview-set-hidden! (c-> objc-object? boolean? void?)]
  [nsview-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nsview-horizontal-content-size-constraint-active (c-> objc-object? boolean?)]
  [nsview-set-horizontal-content-size-constraint-active! (c-> objc-object? boolean? void?)]
  [nsview-in-full-screen-mode (c-> objc-object? boolean?)]
  [nsview-in-live-resize (c-> objc-object? boolean?)]
  [nsview-input-context (c-> objc-object? any/c)]
  [nsview-intrinsic-content-size (c-> objc-object? any/c)]
  [nsview-last-baseline-anchor (c-> objc-object? any/c)]
  [nsview-last-baseline-offset-from-bottom (c-> objc-object? real?)]
  [nsview-layer (c-> objc-object? any/c)]
  [nsview-set-layer! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-layer-contents-placement (c-> objc-object? exact-nonnegative-integer?)]
  [nsview-set-layer-contents-placement! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsview-layer-contents-redraw-policy (c-> objc-object? exact-nonnegative-integer?)]
  [nsview-set-layer-contents-redraw-policy! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsview-layer-uses-core-image-filters (c-> objc-object? boolean?)]
  [nsview-set-layer-uses-core-image-filters! (c-> objc-object? boolean? void?)]
  [nsview-layout-guides (c-> objc-object? any/c)]
  [nsview-layout-margins-guide (c-> objc-object? any/c)]
  [nsview-leading-anchor (c-> objc-object? any/c)]
  [nsview-left-anchor (c-> objc-object? any/c)]
  [nsview-menu (c-> objc-object? any/c)]
  [nsview-set-menu! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-mouse-down-can-move-window (c-> objc-object? boolean?)]
  [nsview-needs-display (c-> objc-object? boolean?)]
  [nsview-set-needs-display! (c-> objc-object? boolean? void?)]
  [nsview-needs-layout (c-> objc-object? boolean?)]
  [nsview-set-needs-layout! (c-> objc-object? boolean? void?)]
  [nsview-needs-panel-to-become-key (c-> objc-object? boolean?)]
  [nsview-needs-update-constraints (c-> objc-object? boolean?)]
  [nsview-set-needs-update-constraints! (c-> objc-object? boolean? void?)]
  [nsview-next-key-view (c-> objc-object? any/c)]
  [nsview-set-next-key-view! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-next-responder (c-> objc-object? any/c)]
  [nsview-set-next-responder! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-next-valid-key-view (c-> objc-object? any/c)]
  [nsview-opaque (c-> objc-object? boolean?)]
  [nsview-opaque-ancestor (c-> objc-object? any/c)]
  [nsview-page-footer (c-> objc-object? any/c)]
  [nsview-page-header (c-> objc-object? any/c)]
  [nsview-posts-bounds-changed-notifications (c-> objc-object? boolean?)]
  [nsview-set-posts-bounds-changed-notifications! (c-> objc-object? boolean? void?)]
  [nsview-posts-frame-changed-notifications (c-> objc-object? boolean?)]
  [nsview-set-posts-frame-changed-notifications! (c-> objc-object? boolean? void?)]
  [nsview-prefers-compact-control-size-metrics (c-> objc-object? boolean?)]
  [nsview-set-prefers-compact-control-size-metrics! (c-> objc-object? boolean? void?)]
  [nsview-prepared-content-rect (c-> objc-object? any/c)]
  [nsview-set-prepared-content-rect! (c-> objc-object? any/c void?)]
  [nsview-preserves-content-during-live-resize (c-> objc-object? boolean?)]
  [nsview-pressure-configuration (c-> objc-object? any/c)]
  [nsview-set-pressure-configuration! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-previous-key-view (c-> objc-object? any/c)]
  [nsview-previous-valid-key-view (c-> objc-object? any/c)]
  [nsview-print-job-title (c-> objc-object? any/c)]
  [nsview-rect-preserved-during-live-resize (c-> objc-object? any/c)]
  [nsview-registered-dragged-types (c-> objc-object? any/c)]
  [nsview-requires-constraint-based-layout (c-> boolean?)]
  [nsview-restorable-state-key-paths (c-> any/c)]
  [nsview-right-anchor (c-> objc-object? any/c)]
  [nsview-rotated-from-base (c-> objc-object? boolean?)]
  [nsview-rotated-or-scaled-from-base (c-> objc-object? boolean?)]
  [nsview-safe-area-insets (c-> objc-object? any/c)]
  [nsview-safe-area-layout-guide (c-> objc-object? any/c)]
  [nsview-safe-area-rect (c-> objc-object? any/c)]
  [nsview-shadow (c-> objc-object? any/c)]
  [nsview-set-shadow! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-subviews (c-> objc-object? any/c)]
  [nsview-set-subviews! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-superview (c-> objc-object? any/c)]
  [nsview-tag (c-> objc-object? exact-integer?)]
  [nsview-tool-tip (c-> objc-object? any/c)]
  [nsview-set-tool-tip! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-top-anchor (c-> objc-object? any/c)]
  [nsview-touch-bar (c-> objc-object? any/c)]
  [nsview-set-touch-bar! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-tracking-areas (c-> objc-object? any/c)]
  [nsview-trailing-anchor (c-> objc-object? any/c)]
  [nsview-translates-autoresizing-mask-into-constraints (c-> objc-object? boolean?)]
  [nsview-set-translates-autoresizing-mask-into-constraints! (c-> objc-object? boolean? void?)]
  [nsview-undo-manager (c-> objc-object? any/c)]
  [nsview-user-activity (c-> objc-object? any/c)]
  [nsview-set-user-activity! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-user-interface-layout-direction (c-> objc-object? exact-nonnegative-integer?)]
  [nsview-set-user-interface-layout-direction! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsview-vertical-content-size-constraint-active (c-> objc-object? boolean?)]
  [nsview-set-vertical-content-size-constraint-active! (c-> objc-object? boolean? void?)]
  [nsview-visible-rect (c-> objc-object? any/c)]
  [nsview-wants-best-resolution-open-gl-surface (c-> objc-object? boolean?)]
  [nsview-set-wants-best-resolution-open-gl-surface! (c-> objc-object? boolean? void?)]
  [nsview-wants-default-clipping (c-> objc-object? boolean?)]
  [nsview-wants-extended-dynamic-range-open-gl-surface (c-> objc-object? boolean?)]
  [nsview-set-wants-extended-dynamic-range-open-gl-surface! (c-> objc-object? boolean? void?)]
  [nsview-wants-layer (c-> objc-object? boolean?)]
  [nsview-set-wants-layer! (c-> objc-object? boolean? void?)]
  [nsview-wants-resting-touches (c-> objc-object? boolean?)]
  [nsview-set-wants-resting-touches! (c-> objc-object? boolean? void?)]
  [nsview-wants-update-layer (c-> objc-object? boolean?)]
  [nsview-width-adjust-limit (c-> objc-object? real?)]
  [nsview-width-anchor (c-> objc-object? any/c)]
  [nsview-window (c-> objc-object? any/c)]
  [nsview-writing-tools-coordinator (c-> objc-object? any/c)]
  [nsview-set-writing-tools-coordinator! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-accepts-first-mouse (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nsview-add-subview! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-add-subview-positioned-relative-to! (c-> objc-object? (or/c string? objc-object? cpointer?) exact-nonnegative-integer? (or/c string? objc-object? cpointer?) void?)]
  [nsview-add-tool-tip-rect-owner-user-data! (c-> objc-object? any/c (or/c string? objc-object? cpointer?) (or/c cpointer? #f) exact-integer?)]
  [nsview-adjust-scroll (c-> objc-object? any/c any/c)]
  [nsview-ancestor-shared-with-view (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nsview-autoscroll (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nsview-backing-aligned-rect-options (c-> objc-object? any/c exact-nonnegative-integer? any/c)]
  [nsview-become-first-responder (c-> objc-object? boolean?)]
  [nsview-begin-gesture-with-event! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-bitmap-image-rep-for-caching-display-in-rect (c-> objc-object? any/c any/c)]
  [nsview-cache-display-in-rect-to-bitmap-image-rep (c-> objc-object? any/c (or/c string? objc-object? cpointer?) void?)]
  [nsview-center-scan-rect! (c-> objc-object? any/c any/c)]
  [nsview-change-mode-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-context-menu-key-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-convert-point-from-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nsview-convert-point-to-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nsview-convert-point-from-backing (c-> objc-object? any/c any/c)]
  [nsview-convert-point-from-layer (c-> objc-object? any/c any/c)]
  [nsview-convert-point-to-backing (c-> objc-object? any/c any/c)]
  [nsview-convert-point-to-layer (c-> objc-object? any/c any/c)]
  [nsview-convert-rect-from-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nsview-convert-rect-to-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nsview-convert-rect-from-backing (c-> objc-object? any/c any/c)]
  [nsview-convert-rect-from-layer (c-> objc-object? any/c any/c)]
  [nsview-convert-rect-to-backing (c-> objc-object? any/c any/c)]
  [nsview-convert-rect-to-layer (c-> objc-object? any/c any/c)]
  [nsview-convert-size-from-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nsview-convert-size-to-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nsview-convert-size-from-backing (c-> objc-object? any/c any/c)]
  [nsview-convert-size-from-layer (c-> objc-object? any/c any/c)]
  [nsview-convert-size-to-backing (c-> objc-object? any/c any/c)]
  [nsview-convert-size-to-layer (c-> objc-object? any/c any/c)]
  [nsview-cursor-update (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-did-add-subview (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-did-close-menu-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nsview-display! (c-> objc-object? void?)]
  [nsview-display-if-needed! (c-> objc-object? void?)]
  [nsview-display-if-needed-ignoring-opacity! (c-> objc-object? void?)]
  [nsview-display-if-needed-in-rect! (c-> objc-object? any/c void?)]
  [nsview-display-if-needed-in-rect-ignoring-opacity! (c-> objc-object? any/c void?)]
  [nsview-display-rect! (c-> objc-object? any/c void?)]
  [nsview-display-rect-ignoring-opacity! (c-> objc-object? any/c void?)]
  [nsview-display-rect-ignoring-opacity-in-context! (c-> objc-object? any/c (or/c string? objc-object? cpointer?) void?)]
  [nsview-draw-rect (c-> objc-object? any/c void?)]
  [nsview-end-gesture-with-event! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-flags-changed (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-flush-buffered-key-events (c-> objc-object? void?)]
  [nsview-get-rects-being-drawn-count (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nsview-get-rects-exposed-during-live-resize-count (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nsview-help-requested (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-hit-test (c-> objc-object? any/c any/c)]
  [nsview-interpret-key-events (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-is-descendant-of (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nsview-is-flipped (c-> objc-object? boolean?)]
  [nsview-is-hidden (c-> objc-object? boolean?)]
  [nsview-is-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nsview-is-opaque (c-> objc-object? boolean?)]
  [nsview-is-rotated-from-base (c-> objc-object? boolean?)]
  [nsview-is-rotated-or-scaled-from-base (c-> objc-object? boolean?)]
  [nsview-key-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-key-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-layout (c-> objc-object? void?)]
  [nsview-layout-subtree-if-needed (c-> objc-object? void?)]
  [nsview-magnify-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-make-backing-layer (c-> objc-object? any/c)]
  [nsview-menu-for-event (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nsview-mouse-in-rect (c-> objc-object? any/c any/c boolean?)]
  [nsview-mouse-cancelled (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-mouse-entered (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-mouse-exited (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-mouse-moved (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-needs-to-draw-rect (c-> objc-object? any/c boolean?)]
  [nsview-no-responder-for (c-> objc-object? cpointer? void?)]
  [nsview-other-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-other-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-other-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-perform-key-equivalent! (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nsview-prepare-content-in-rect (c-> objc-object? any/c void?)]
  [nsview-prepare-for-reuse (c-> objc-object? void?)]
  [nsview-pressure-change-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-quick-look-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-rect-for-smart-magnification-at-point-in-rect (c-> objc-object? any/c any/c any/c)]
  [nsview-remove-all-tool-tips! (c-> objc-object? void?)]
  [nsview-remove-from-superview! (c-> objc-object? void?)]
  [nsview-remove-from-superview-without-needing-display! (c-> objc-object? void?)]
  [nsview-remove-tool-tip! (c-> objc-object? exact-integer? void?)]
  [nsview-replace-subview-with! (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nsview-resign-first-responder (c-> objc-object? boolean?)]
  [nsview-resize-subviews-with-old-size (c-> objc-object? any/c void?)]
  [nsview-resize-with-old-superview-size (c-> objc-object? any/c void?)]
  [nsview-right-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-right-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-right-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-rotate-by-angle (c-> objc-object? real? void?)]
  [nsview-rotate-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-scale-unit-square-to-size (c-> objc-object? any/c void?)]
  [nsview-scroll-point (c-> objc-object? any/c void?)]
  [nsview-scroll-rect-to-visible (c-> objc-object? any/c boolean?)]
  [nsview-scroll-wheel (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-set-bounds-origin! (c-> objc-object? any/c void?)]
  [nsview-set-bounds-size! (c-> objc-object? any/c void?)]
  [nsview-set-frame-origin! (c-> objc-object? any/c void?)]
  [nsview-set-frame-size! (c-> objc-object? any/c void?)]
  [nsview-set-needs-display-in-rect! (c-> objc-object? any/c void?)]
  [nsview-should-be-treated-as-ink-event (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nsview-should-delay-window-ordering-for-event (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nsview-show-context-help (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-smart-magnify-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-sort-subviews-using-function-context (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nsview-supplemental-target-for-action-sender (c-> objc-object? cpointer? (or/c string? objc-object? cpointer?) any/c)]
  [nsview-swipe-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-tablet-point (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-tablet-proximity (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-touches-began-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-touches-cancelled-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-touches-ended-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-touches-moved-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-translate-origin-to-point (c-> objc-object? any/c void?)]
  [nsview-translate-rects-needing-display-in-rect-by (c-> objc-object? any/c any/c void?)]
  [nsview-try-to-perform-with (c-> objc-object? cpointer? (or/c string? objc-object? cpointer?) boolean?)]
  [nsview-update-layer (c-> objc-object? void?)]
  [nsview-valid-requestor-for-send-type-return-type (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) any/c)]
  [nsview-view-did-change-backing-properties (c-> objc-object? void?)]
  [nsview-view-did-change-effective-appearance (c-> objc-object? void?)]
  [nsview-view-did-end-live-resize (c-> objc-object? void?)]
  [nsview-view-did-hide (c-> objc-object? void?)]
  [nsview-view-did-move-to-superview (c-> objc-object? void?)]
  [nsview-view-did-move-to-window (c-> objc-object? void?)]
  [nsview-view-did-unhide (c-> objc-object? void?)]
  [nsview-view-will-draw (c-> objc-object? void?)]
  [nsview-view-will-move-to-superview (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-view-will-move-to-window (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-view-will-start-live-resize (c-> objc-object? void?)]
  [nsview-view-with-tag (c-> objc-object? exact-integer? any/c)]
  [nsview-wants-forwarded-scroll-events-for-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nsview-wants-scroll-events-for-swipe-tracking-on-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nsview-will-open-menu-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nsview-will-remove-subview (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nsview-is-compatible-with-responsive-scrolling (c-> boolean?)]
  )

;; --- Class reference ---
(import-class NSView)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _NSRect)))
(define _msg-1  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-2  ; (_fun _pointer _pointer -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _double)))
(define _msg-3  ; (_fun _pointer _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _int64)))
(define _msg-4  ; (_fun _pointer _pointer -> _uint64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _uint64)))
(define _msg-5  ; (_fun _pointer _pointer _NSEdgeInsets -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSEdgeInsets -> _void)))
(define _msg-6  ; (_fun _pointer _pointer _NSPoint -> _NSPoint)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _NSPoint)))
(define _msg-7  ; (_fun _pointer _pointer _NSPoint -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _id)))
(define _msg-8  ; (_fun _pointer _pointer _NSPoint -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _void)))
(define _msg-9  ; (_fun _pointer _pointer _NSPoint _NSRect -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _NSRect -> _NSRect)))
(define _msg-10  ; (_fun _pointer _pointer _NSPoint _NSRect -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _NSRect -> _bool)))
(define _msg-11  ; (_fun _pointer _pointer _NSPoint _id -> _NSPoint)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _id -> _NSPoint)))
(define _msg-12  ; (_fun _pointer _pointer _NSRect -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _NSRect)))
(define _msg-13  ; (_fun _pointer _pointer _NSRect -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _bool)))
(define _msg-14  ; (_fun _pointer _pointer _NSRect -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _id)))
(define _msg-15  ; (_fun _pointer _pointer _NSRect -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _void)))
(define _msg-16  ; (_fun _pointer _pointer _NSRect _NSSize -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _NSSize -> _void)))
(define _msg-17  ; (_fun _pointer _pointer _NSRect _id -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id -> _NSRect)))
(define _msg-18  ; (_fun _pointer _pointer _NSRect _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id -> _void)))
(define _msg-19  ; (_fun _pointer _pointer _NSRect _id _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id _pointer -> _int64)))
(define _msg-20  ; (_fun _pointer _pointer _NSRect _uint64 -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _uint64 -> _NSRect)))
(define _msg-21  ; (_fun _pointer _pointer _NSSize -> _NSSize)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize -> _NSSize)))
(define _msg-22  ; (_fun _pointer _pointer _NSSize -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize -> _void)))
(define _msg-23  ; (_fun _pointer _pointer _NSSize _id -> _NSSize)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize _id -> _NSSize)))
(define _msg-24  ; (_fun _pointer _pointer _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool -> _void)))
(define _msg-25  ; (_fun _pointer _pointer _double -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double -> _void)))
(define _msg-26  ; (_fun _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _bool)))
(define _msg-27  ; (_fun _pointer _pointer _id _uint64 _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _uint64 _id -> _void)))
(define _msg-28  ; (_fun _pointer _pointer _int64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _id)))
(define _msg-29  ; (_fun _pointer _pointer _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _void)))
(define _msg-30  ; (_fun _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))
(define _msg-31  ; (_fun _pointer _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _bool)))
(define _msg-32  ; (_fun _pointer _pointer _pointer _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _id)))
(define _msg-33  ; (_fun _pointer _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _pointer -> _void)))
(define _msg-34  ; (_fun _pointer _pointer _uint64 -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _bool)))
(define _msg-35  ; (_fun _pointer _pointer _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _void)))

;; --- Constructors ---
(define (make-nsview-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSView alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))

(define (make-nsview-init-with-frame frame-rect)
  (wrap-objc-object
   (_msg-14 (tell NSView alloc)
       (sel_registerName "initWithFrame:")
       frame-rect)
   #:retained #t))


;; --- Properties ---
(define (nsview-accepts-first-responder self)
  (tell #:type _bool (coerce-arg self) acceptsFirstResponder))
(define (nsview-accepts-touch-events self)
  (tell #:type _bool (coerce-arg self) acceptsTouchEvents))
(define (nsview-set-accepts-touch-events! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setAcceptsTouchEvents:") value))
(define (nsview-additional-safe-area-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) additionalSafeAreaInsets))
(define (nsview-set-additional-safe-area-insets! self value)
  (_msg-5 (coerce-arg self) (sel_registerName "setAdditionalSafeAreaInsets:") value))
(define (nsview-alignment-rect-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) alignmentRectInsets))
(define (nsview-allowed-touch-types self)
  (tell #:type _uint64 (coerce-arg self) allowedTouchTypes))
(define (nsview-set-allowed-touch-types! self value)
  (_msg-35 (coerce-arg self) (sel_registerName "setAllowedTouchTypes:") value))
(define (nsview-allows-vibrancy self)
  (tell #:type _bool (coerce-arg self) allowsVibrancy))
(define (nsview-alpha-value self)
  (tell #:type _double (coerce-arg self) alphaValue))
(define (nsview-set-alpha-value! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setAlphaValue:") value))
(define (nsview-autoresizes-subviews self)
  (tell #:type _bool (coerce-arg self) autoresizesSubviews))
(define (nsview-set-autoresizes-subviews! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setAutoresizesSubviews:") value))
(define (nsview-autoresizing-mask self)
  (tell #:type _uint64 (coerce-arg self) autoresizingMask))
(define (nsview-set-autoresizing-mask! self value)
  (_msg-35 (coerce-arg self) (sel_registerName "setAutoresizingMask:") value))
(define (nsview-background-filters self)
  (wrap-objc-object
   (tell (coerce-arg self) backgroundFilters)))
(define (nsview-set-background-filters! self value)
  (tell #:type _void (coerce-arg self) setBackgroundFilters: (coerce-arg value)))
(define (nsview-baseline-offset-from-bottom self)
  (tell #:type _double (coerce-arg self) baselineOffsetFromBottom))
(define (nsview-bottom-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) bottomAnchor)))
(define (nsview-bounds self)
  (tell #:type _NSRect (coerce-arg self) bounds))
(define (nsview-set-bounds! self value)
  (_msg-15 (coerce-arg self) (sel_registerName "setBounds:") value))
(define (nsview-bounds-rotation self)
  (tell #:type _double (coerce-arg self) boundsRotation))
(define (nsview-set-bounds-rotation! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setBoundsRotation:") value))
(define (nsview-can-become-key-view self)
  (tell #:type _bool (coerce-arg self) canBecomeKeyView))
(define (nsview-can-draw self)
  (tell #:type _bool (coerce-arg self) canDraw))
(define (nsview-can-draw-concurrently self)
  (tell #:type _bool (coerce-arg self) canDrawConcurrently))
(define (nsview-set-can-draw-concurrently! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setCanDrawConcurrently:") value))
(define (nsview-can-draw-subviews-into-layer self)
  (tell #:type _bool (coerce-arg self) canDrawSubviewsIntoLayer))
(define (nsview-set-can-draw-subviews-into-layer! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setCanDrawSubviewsIntoLayer:") value))
(define (nsview-candidate-list-touch-bar-item self)
  (wrap-objc-object
   (tell (coerce-arg self) candidateListTouchBarItem)))
(define (nsview-center-x-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) centerXAnchor)))
(define (nsview-center-y-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) centerYAnchor)))
(define (nsview-clips-to-bounds self)
  (tell #:type _bool (coerce-arg self) clipsToBounds))
(define (nsview-set-clips-to-bounds! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setClipsToBounds:") value))
(define (nsview-compatible-with-responsive-scrolling)
  (tell #:type _bool NSView compatibleWithResponsiveScrolling))
(define (nsview-compositing-filter self)
  (wrap-objc-object
   (tell (coerce-arg self) compositingFilter)))
(define (nsview-set-compositing-filter! self value)
  (tell #:type _void (coerce-arg self) setCompositingFilter: (coerce-arg value)))
(define (nsview-constraints self)
  (wrap-objc-object
   (tell (coerce-arg self) constraints)))
(define (nsview-content-filters self)
  (wrap-objc-object
   (tell (coerce-arg self) contentFilters)))
(define (nsview-set-content-filters! self value)
  (tell #:type _void (coerce-arg self) setContentFilters: (coerce-arg value)))
(define (nsview-default-focus-ring-type)
  (tell #:type _uint64 NSView defaultFocusRingType))
(define (nsview-default-menu)
  (wrap-objc-object
   (tell NSView defaultMenu)))
(define (nsview-drawing-find-indicator self)
  (tell #:type _bool (coerce-arg self) drawingFindIndicator))
(define (nsview-enclosing-menu-item self)
  (wrap-objc-object
   (tell (coerce-arg self) enclosingMenuItem)))
(define (nsview-enclosing-scroll-view self)
  (wrap-objc-object
   (tell (coerce-arg self) enclosingScrollView)))
(define (nsview-first-baseline-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) firstBaselineAnchor)))
(define (nsview-first-baseline-offset-from-top self)
  (tell #:type _double (coerce-arg self) firstBaselineOffsetFromTop))
(define (nsview-fitting-size self)
  (tell #:type _NSSize (coerce-arg self) fittingSize))
(define (nsview-flipped self)
  (tell #:type _bool (coerce-arg self) flipped))
(define (nsview-focus-ring-mask-bounds self)
  (tell #:type _NSRect (coerce-arg self) focusRingMaskBounds))
(define (nsview-focus-ring-type self)
  (tell #:type _uint64 (coerce-arg self) focusRingType))
(define (nsview-set-focus-ring-type! self value)
  (_msg-35 (coerce-arg self) (sel_registerName "setFocusRingType:") value))
(define (nsview-focus-view)
  (wrap-objc-object
   (tell NSView focusView)))
(define (nsview-frame self)
  (tell #:type _NSRect (coerce-arg self) frame))
(define (nsview-set-frame! self value)
  (_msg-15 (coerce-arg self) (sel_registerName "setFrame:") value))
(define (nsview-frame-center-rotation self)
  (tell #:type _double (coerce-arg self) frameCenterRotation))
(define (nsview-set-frame-center-rotation! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setFrameCenterRotation:") value))
(define (nsview-frame-rotation self)
  (tell #:type _double (coerce-arg self) frameRotation))
(define (nsview-set-frame-rotation! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setFrameRotation:") value))
(define (nsview-gesture-recognizers self)
  (wrap-objc-object
   (tell (coerce-arg self) gestureRecognizers)))
(define (nsview-set-gesture-recognizers! self value)
  (tell #:type _void (coerce-arg self) setGestureRecognizers: (coerce-arg value)))
(define (nsview-has-ambiguous-layout self)
  (tell #:type _bool (coerce-arg self) hasAmbiguousLayout))
(define (nsview-height-adjust-limit self)
  (tell #:type _double (coerce-arg self) heightAdjustLimit))
(define (nsview-height-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) heightAnchor)))
(define (nsview-hidden self)
  (tell #:type _bool (coerce-arg self) hidden))
(define (nsview-set-hidden! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setHidden:") value))
(define (nsview-hidden-or-has-hidden-ancestor self)
  (tell #:type _bool (coerce-arg self) hiddenOrHasHiddenAncestor))
(define (nsview-horizontal-content-size-constraint-active self)
  (tell #:type _bool (coerce-arg self) horizontalContentSizeConstraintActive))
(define (nsview-set-horizontal-content-size-constraint-active! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setHorizontalContentSizeConstraintActive:") value))
(define (nsview-in-full-screen-mode self)
  (tell #:type _bool (coerce-arg self) inFullScreenMode))
(define (nsview-in-live-resize self)
  (tell #:type _bool (coerce-arg self) inLiveResize))
(define (nsview-input-context self)
  (wrap-objc-object
   (tell (coerce-arg self) inputContext)))
(define (nsview-intrinsic-content-size self)
  (tell #:type _NSSize (coerce-arg self) intrinsicContentSize))
(define (nsview-last-baseline-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) lastBaselineAnchor)))
(define (nsview-last-baseline-offset-from-bottom self)
  (tell #:type _double (coerce-arg self) lastBaselineOffsetFromBottom))
(define (nsview-layer self)
  (wrap-objc-object
   (tell (coerce-arg self) layer)))
(define (nsview-set-layer! self value)
  (tell #:type _void (coerce-arg self) setLayer: (coerce-arg value)))
(define (nsview-layer-contents-placement self)
  (tell #:type _uint64 (coerce-arg self) layerContentsPlacement))
(define (nsview-set-layer-contents-placement! self value)
  (_msg-35 (coerce-arg self) (sel_registerName "setLayerContentsPlacement:") value))
(define (nsview-layer-contents-redraw-policy self)
  (tell #:type _uint64 (coerce-arg self) layerContentsRedrawPolicy))
(define (nsview-set-layer-contents-redraw-policy! self value)
  (_msg-35 (coerce-arg self) (sel_registerName "setLayerContentsRedrawPolicy:") value))
(define (nsview-layer-uses-core-image-filters self)
  (tell #:type _bool (coerce-arg self) layerUsesCoreImageFilters))
(define (nsview-set-layer-uses-core-image-filters! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setLayerUsesCoreImageFilters:") value))
(define (nsview-layout-guides self)
  (wrap-objc-object
   (tell (coerce-arg self) layoutGuides)))
(define (nsview-layout-margins-guide self)
  (wrap-objc-object
   (tell (coerce-arg self) layoutMarginsGuide)))
(define (nsview-leading-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) leadingAnchor)))
(define (nsview-left-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) leftAnchor)))
(define (nsview-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) menu)))
(define (nsview-set-menu! self value)
  (tell #:type _void (coerce-arg self) setMenu: (coerce-arg value)))
(define (nsview-mouse-down-can-move-window self)
  (tell #:type _bool (coerce-arg self) mouseDownCanMoveWindow))
(define (nsview-needs-display self)
  (tell #:type _bool (coerce-arg self) needsDisplay))
(define (nsview-set-needs-display! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setNeedsDisplay:") value))
(define (nsview-needs-layout self)
  (tell #:type _bool (coerce-arg self) needsLayout))
(define (nsview-set-needs-layout! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setNeedsLayout:") value))
(define (nsview-needs-panel-to-become-key self)
  (tell #:type _bool (coerce-arg self) needsPanelToBecomeKey))
(define (nsview-needs-update-constraints self)
  (tell #:type _bool (coerce-arg self) needsUpdateConstraints))
(define (nsview-set-needs-update-constraints! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setNeedsUpdateConstraints:") value))
(define (nsview-next-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) nextKeyView)))
(define (nsview-set-next-key-view! self value)
  (tell #:type _void (coerce-arg self) setNextKeyView: (coerce-arg value)))
(define (nsview-next-responder self)
  (wrap-objc-object
   (tell (coerce-arg self) nextResponder)))
(define (nsview-set-next-responder! self value)
  (tell #:type _void (coerce-arg self) setNextResponder: (coerce-arg value)))
(define (nsview-next-valid-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) nextValidKeyView)))
(define (nsview-opaque self)
  (tell #:type _bool (coerce-arg self) opaque))
(define (nsview-opaque-ancestor self)
  (wrap-objc-object
   (tell (coerce-arg self) opaqueAncestor)))
(define (nsview-page-footer self)
  (wrap-objc-object
   (tell (coerce-arg self) pageFooter)))
(define (nsview-page-header self)
  (wrap-objc-object
   (tell (coerce-arg self) pageHeader)))
(define (nsview-posts-bounds-changed-notifications self)
  (tell #:type _bool (coerce-arg self) postsBoundsChangedNotifications))
(define (nsview-set-posts-bounds-changed-notifications! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setPostsBoundsChangedNotifications:") value))
(define (nsview-posts-frame-changed-notifications self)
  (tell #:type _bool (coerce-arg self) postsFrameChangedNotifications))
(define (nsview-set-posts-frame-changed-notifications! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setPostsFrameChangedNotifications:") value))
(define (nsview-prefers-compact-control-size-metrics self)
  (tell #:type _bool (coerce-arg self) prefersCompactControlSizeMetrics))
(define (nsview-set-prefers-compact-control-size-metrics! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setPrefersCompactControlSizeMetrics:") value))
(define (nsview-prepared-content-rect self)
  (tell #:type _NSRect (coerce-arg self) preparedContentRect))
(define (nsview-set-prepared-content-rect! self value)
  (_msg-15 (coerce-arg self) (sel_registerName "setPreparedContentRect:") value))
(define (nsview-preserves-content-during-live-resize self)
  (tell #:type _bool (coerce-arg self) preservesContentDuringLiveResize))
(define (nsview-pressure-configuration self)
  (wrap-objc-object
   (tell (coerce-arg self) pressureConfiguration)))
(define (nsview-set-pressure-configuration! self value)
  (tell #:type _void (coerce-arg self) setPressureConfiguration: (coerce-arg value)))
(define (nsview-previous-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) previousKeyView)))
(define (nsview-previous-valid-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) previousValidKeyView)))
(define (nsview-print-job-title self)
  (wrap-objc-object
   (tell (coerce-arg self) printJobTitle)))
(define (nsview-rect-preserved-during-live-resize self)
  (tell #:type _NSRect (coerce-arg self) rectPreservedDuringLiveResize))
(define (nsview-registered-dragged-types self)
  (wrap-objc-object
   (tell (coerce-arg self) registeredDraggedTypes)))
(define (nsview-requires-constraint-based-layout)
  (tell #:type _bool NSView requiresConstraintBasedLayout))
(define (nsview-restorable-state-key-paths)
  (wrap-objc-object
   (tell NSView restorableStateKeyPaths)))
(define (nsview-right-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) rightAnchor)))
(define (nsview-rotated-from-base self)
  (tell #:type _bool (coerce-arg self) rotatedFromBase))
(define (nsview-rotated-or-scaled-from-base self)
  (tell #:type _bool (coerce-arg self) rotatedOrScaledFromBase))
(define (nsview-safe-area-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) safeAreaInsets))
(define (nsview-safe-area-layout-guide self)
  (wrap-objc-object
   (tell (coerce-arg self) safeAreaLayoutGuide)))
(define (nsview-safe-area-rect self)
  (tell #:type _NSRect (coerce-arg self) safeAreaRect))
(define (nsview-shadow self)
  (wrap-objc-object
   (tell (coerce-arg self) shadow)))
(define (nsview-set-shadow! self value)
  (tell #:type _void (coerce-arg self) setShadow: (coerce-arg value)))
(define (nsview-subviews self)
  (wrap-objc-object
   (tell (coerce-arg self) subviews)))
(define (nsview-set-subviews! self value)
  (tell #:type _void (coerce-arg self) setSubviews: (coerce-arg value)))
(define (nsview-superview self)
  (wrap-objc-object
   (tell (coerce-arg self) superview)))
(define (nsview-tag self)
  (tell #:type _int64 (coerce-arg self) tag))
(define (nsview-tool-tip self)
  (wrap-objc-object
   (tell (coerce-arg self) toolTip)))
(define (nsview-set-tool-tip! self value)
  (tell #:type _void (coerce-arg self) setToolTip: (coerce-arg value)))
(define (nsview-top-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) topAnchor)))
(define (nsview-touch-bar self)
  (wrap-objc-object
   (tell (coerce-arg self) touchBar)))
(define (nsview-set-touch-bar! self value)
  (tell #:type _void (coerce-arg self) setTouchBar: (coerce-arg value)))
(define (nsview-tracking-areas self)
  (wrap-objc-object
   (tell (coerce-arg self) trackingAreas)))
(define (nsview-trailing-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) trailingAnchor)))
(define (nsview-translates-autoresizing-mask-into-constraints self)
  (tell #:type _bool (coerce-arg self) translatesAutoresizingMaskIntoConstraints))
(define (nsview-set-translates-autoresizing-mask-into-constraints! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setTranslatesAutoresizingMaskIntoConstraints:") value))
(define (nsview-undo-manager self)
  (wrap-objc-object
   (tell (coerce-arg self) undoManager)))
(define (nsview-user-activity self)
  (wrap-objc-object
   (tell (coerce-arg self) userActivity)))
(define (nsview-set-user-activity! self value)
  (tell #:type _void (coerce-arg self) setUserActivity: (coerce-arg value)))
(define (nsview-user-interface-layout-direction self)
  (tell #:type _uint64 (coerce-arg self) userInterfaceLayoutDirection))
(define (nsview-set-user-interface-layout-direction! self value)
  (_msg-35 (coerce-arg self) (sel_registerName "setUserInterfaceLayoutDirection:") value))
(define (nsview-vertical-content-size-constraint-active self)
  (tell #:type _bool (coerce-arg self) verticalContentSizeConstraintActive))
(define (nsview-set-vertical-content-size-constraint-active! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setVerticalContentSizeConstraintActive:") value))
(define (nsview-visible-rect self)
  (tell #:type _NSRect (coerce-arg self) visibleRect))
(define (nsview-wants-best-resolution-open-gl-surface self)
  (tell #:type _bool (coerce-arg self) wantsBestResolutionOpenGLSurface))
(define (nsview-set-wants-best-resolution-open-gl-surface! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setWantsBestResolutionOpenGLSurface:") value))
(define (nsview-wants-default-clipping self)
  (tell #:type _bool (coerce-arg self) wantsDefaultClipping))
(define (nsview-wants-extended-dynamic-range-open-gl-surface self)
  (tell #:type _bool (coerce-arg self) wantsExtendedDynamicRangeOpenGLSurface))
(define (nsview-set-wants-extended-dynamic-range-open-gl-surface! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setWantsExtendedDynamicRangeOpenGLSurface:") value))
(define (nsview-wants-layer self)
  (tell #:type _bool (coerce-arg self) wantsLayer))
(define (nsview-set-wants-layer! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setWantsLayer:") value))
(define (nsview-wants-resting-touches self)
  (tell #:type _bool (coerce-arg self) wantsRestingTouches))
(define (nsview-set-wants-resting-touches! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setWantsRestingTouches:") value))
(define (nsview-wants-update-layer self)
  (tell #:type _bool (coerce-arg self) wantsUpdateLayer))
(define (nsview-width-adjust-limit self)
  (tell #:type _double (coerce-arg self) widthAdjustLimit))
(define (nsview-width-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) widthAnchor)))
(define (nsview-window self)
  (wrap-objc-object
   (tell (coerce-arg self) window)))
(define (nsview-writing-tools-coordinator self)
  (wrap-objc-object
   (tell (coerce-arg self) writingToolsCoordinator)))
(define (nsview-set-writing-tools-coordinator! self value)
  (tell #:type _void (coerce-arg self) setWritingToolsCoordinator: (coerce-arg value)))

;; --- Instance methods ---
(define (nsview-accepts-first-mouse self event)
  (_msg-26 (coerce-arg self) (sel_registerName "acceptsFirstMouse:") (coerce-arg event)))
(define (nsview-add-subview! self view)
  (tell #:type _void (coerce-arg self) addSubview: (coerce-arg view)))
(define (nsview-add-subview-positioned-relative-to! self view place other-view)
  (_msg-27 (coerce-arg self) (sel_registerName "addSubview:positioned:relativeTo:") (coerce-arg view) place (coerce-arg other-view)))
(define (nsview-add-tool-tip-rect-owner-user-data! self rect owner data)
  (_msg-19 (coerce-arg self) (sel_registerName "addToolTipRect:owner:userData:") rect (coerce-arg owner) data))
(define (nsview-adjust-scroll self new-visible)
  (_msg-12 (coerce-arg self) (sel_registerName "adjustScroll:") new-visible))
(define (nsview-ancestor-shared-with-view self view)
  (wrap-objc-object
   (tell (coerce-arg self) ancestorSharedWithView: (coerce-arg view))))
(define (nsview-autoscroll self event)
  (_msg-26 (coerce-arg self) (sel_registerName "autoscroll:") (coerce-arg event)))
(define (nsview-backing-aligned-rect-options self rect options)
  (_msg-20 (coerce-arg self) (sel_registerName "backingAlignedRect:options:") rect options))
(define (nsview-become-first-responder self)
  (_msg-1 (coerce-arg self) (sel_registerName "becomeFirstResponder")))
(define (nsview-begin-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) beginGestureWithEvent: (coerce-arg event)))
(define (nsview-bitmap-image-rep-for-caching-display-in-rect self rect)
  (wrap-objc-object
   (_msg-14 (coerce-arg self) (sel_registerName "bitmapImageRepForCachingDisplayInRect:") rect)
   ))
(define (nsview-cache-display-in-rect-to-bitmap-image-rep self rect bitmap-image-rep)
  (_msg-18 (coerce-arg self) (sel_registerName "cacheDisplayInRect:toBitmapImageRep:") rect (coerce-arg bitmap-image-rep)))
(define (nsview-center-scan-rect! self rect)
  (_msg-12 (coerce-arg self) (sel_registerName "centerScanRect:") rect))
(define (nsview-change-mode-with-event self event)
  (tell #:type _void (coerce-arg self) changeModeWithEvent: (coerce-arg event)))
(define (nsview-context-menu-key-down self event)
  (tell #:type _void (coerce-arg self) contextMenuKeyDown: (coerce-arg event)))
(define (nsview-convert-point-from-view self point view)
  (_msg-11 (coerce-arg self) (sel_registerName "convertPoint:fromView:") point (coerce-arg view)))
(define (nsview-convert-point-to-view self point view)
  (_msg-11 (coerce-arg self) (sel_registerName "convertPoint:toView:") point (coerce-arg view)))
(define (nsview-convert-point-from-backing self point)
  (_msg-6 (coerce-arg self) (sel_registerName "convertPointFromBacking:") point))
(define (nsview-convert-point-from-layer self point)
  (_msg-6 (coerce-arg self) (sel_registerName "convertPointFromLayer:") point))
(define (nsview-convert-point-to-backing self point)
  (_msg-6 (coerce-arg self) (sel_registerName "convertPointToBacking:") point))
(define (nsview-convert-point-to-layer self point)
  (_msg-6 (coerce-arg self) (sel_registerName "convertPointToLayer:") point))
(define (nsview-convert-rect-from-view self rect view)
  (_msg-17 (coerce-arg self) (sel_registerName "convertRect:fromView:") rect (coerce-arg view)))
(define (nsview-convert-rect-to-view self rect view)
  (_msg-17 (coerce-arg self) (sel_registerName "convertRect:toView:") rect (coerce-arg view)))
(define (nsview-convert-rect-from-backing self rect)
  (_msg-12 (coerce-arg self) (sel_registerName "convertRectFromBacking:") rect))
(define (nsview-convert-rect-from-layer self rect)
  (_msg-12 (coerce-arg self) (sel_registerName "convertRectFromLayer:") rect))
(define (nsview-convert-rect-to-backing self rect)
  (_msg-12 (coerce-arg self) (sel_registerName "convertRectToBacking:") rect))
(define (nsview-convert-rect-to-layer self rect)
  (_msg-12 (coerce-arg self) (sel_registerName "convertRectToLayer:") rect))
(define (nsview-convert-size-from-view self size view)
  (_msg-23 (coerce-arg self) (sel_registerName "convertSize:fromView:") size (coerce-arg view)))
(define (nsview-convert-size-to-view self size view)
  (_msg-23 (coerce-arg self) (sel_registerName "convertSize:toView:") size (coerce-arg view)))
(define (nsview-convert-size-from-backing self size)
  (_msg-21 (coerce-arg self) (sel_registerName "convertSizeFromBacking:") size))
(define (nsview-convert-size-from-layer self size)
  (_msg-21 (coerce-arg self) (sel_registerName "convertSizeFromLayer:") size))
(define (nsview-convert-size-to-backing self size)
  (_msg-21 (coerce-arg self) (sel_registerName "convertSizeToBacking:") size))
(define (nsview-convert-size-to-layer self size)
  (_msg-21 (coerce-arg self) (sel_registerName "convertSizeToLayer:") size))
(define (nsview-cursor-update self event)
  (tell #:type _void (coerce-arg self) cursorUpdate: (coerce-arg event)))
(define (nsview-did-add-subview self subview)
  (tell #:type _void (coerce-arg self) didAddSubview: (coerce-arg subview)))
(define (nsview-did-close-menu-with-event self menu event)
  (tell #:type _void (coerce-arg self) didCloseMenu: (coerce-arg menu) withEvent: (coerce-arg event)))
(define (nsview-display! self)
  (tell #:type _void (coerce-arg self) display))
(define (nsview-display-if-needed! self)
  (tell #:type _void (coerce-arg self) displayIfNeeded))
(define (nsview-display-if-needed-ignoring-opacity! self)
  (tell #:type _void (coerce-arg self) displayIfNeededIgnoringOpacity))
(define (nsview-display-if-needed-in-rect! self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "displayIfNeededInRect:") rect))
(define (nsview-display-if-needed-in-rect-ignoring-opacity! self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "displayIfNeededInRectIgnoringOpacity:") rect))
(define (nsview-display-rect! self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "displayRect:") rect))
(define (nsview-display-rect-ignoring-opacity! self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "displayRectIgnoringOpacity:") rect))
(define (nsview-display-rect-ignoring-opacity-in-context! self rect context)
  (_msg-18 (coerce-arg self) (sel_registerName "displayRectIgnoringOpacity:inContext:") rect (coerce-arg context)))
(define (nsview-draw-rect self dirty-rect)
  (_msg-15 (coerce-arg self) (sel_registerName "drawRect:") dirty-rect))
(define (nsview-end-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) endGestureWithEvent: (coerce-arg event)))
(define (nsview-flags-changed self event)
  (tell #:type _void (coerce-arg self) flagsChanged: (coerce-arg event)))
(define (nsview-flush-buffered-key-events self)
  (tell #:type _void (coerce-arg self) flushBufferedKeyEvents))
(define (nsview-get-rects-being-drawn-count self rects count)
  (_msg-33 (coerce-arg self) (sel_registerName "getRectsBeingDrawn:count:") rects count))
(define (nsview-get-rects-exposed-during-live-resize-count self exposed-rects count)
  (_msg-33 (coerce-arg self) (sel_registerName "getRectsExposedDuringLiveResize:count:") exposed-rects count))
(define (nsview-help-requested self event-ptr)
  (tell #:type _void (coerce-arg self) helpRequested: (coerce-arg event-ptr)))
(define (nsview-hit-test self point)
  (wrap-objc-object
   (_msg-7 (coerce-arg self) (sel_registerName "hitTest:") point)
   ))
(define (nsview-interpret-key-events self event-array)
  (tell #:type _void (coerce-arg self) interpretKeyEvents: (coerce-arg event-array)))
(define (nsview-is-descendant-of self view)
  (_msg-26 (coerce-arg self) (sel_registerName "isDescendantOf:") (coerce-arg view)))
(define (nsview-is-flipped self)
  (_msg-1 (coerce-arg self) (sel_registerName "isFlipped")))
(define (nsview-is-hidden self)
  (_msg-1 (coerce-arg self) (sel_registerName "isHidden")))
(define (nsview-is-hidden-or-has-hidden-ancestor self)
  (_msg-1 (coerce-arg self) (sel_registerName "isHiddenOrHasHiddenAncestor")))
(define (nsview-is-opaque self)
  (_msg-1 (coerce-arg self) (sel_registerName "isOpaque")))
(define (nsview-is-rotated-from-base self)
  (_msg-1 (coerce-arg self) (sel_registerName "isRotatedFromBase")))
(define (nsview-is-rotated-or-scaled-from-base self)
  (_msg-1 (coerce-arg self) (sel_registerName "isRotatedOrScaledFromBase")))
(define (nsview-key-down self event)
  (tell #:type _void (coerce-arg self) keyDown: (coerce-arg event)))
(define (nsview-key-up self event)
  (tell #:type _void (coerce-arg self) keyUp: (coerce-arg event)))
(define (nsview-layout self)
  (tell #:type _void (coerce-arg self) layout))
(define (nsview-layout-subtree-if-needed self)
  (tell #:type _void (coerce-arg self) layoutSubtreeIfNeeded))
(define (nsview-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) magnifyWithEvent: (coerce-arg event)))
(define (nsview-make-backing-layer self)
  (wrap-objc-object
   (tell (coerce-arg self) makeBackingLayer)))
(define (nsview-menu-for-event self event)
  (wrap-objc-object
   (tell (coerce-arg self) menuForEvent: (coerce-arg event))))
(define (nsview-mouse-in-rect self point rect)
  (_msg-10 (coerce-arg self) (sel_registerName "mouse:inRect:") point rect))
(define (nsview-mouse-cancelled self event)
  (tell #:type _void (coerce-arg self) mouseCancelled: (coerce-arg event)))
(define (nsview-mouse-down self event)
  (tell #:type _void (coerce-arg self) mouseDown: (coerce-arg event)))
(define (nsview-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) mouseDragged: (coerce-arg event)))
(define (nsview-mouse-entered self event)
  (tell #:type _void (coerce-arg self) mouseEntered: (coerce-arg event)))
(define (nsview-mouse-exited self event)
  (tell #:type _void (coerce-arg self) mouseExited: (coerce-arg event)))
(define (nsview-mouse-moved self event)
  (tell #:type _void (coerce-arg self) mouseMoved: (coerce-arg event)))
(define (nsview-mouse-up self event)
  (tell #:type _void (coerce-arg self) mouseUp: (coerce-arg event)))
(define (nsview-needs-to-draw-rect self rect)
  (_msg-13 (coerce-arg self) (sel_registerName "needsToDrawRect:") rect))
(define (nsview-no-responder-for self event-selector)
  (_msg-30 (coerce-arg self) (sel_registerName "noResponderFor:") event-selector))
(define (nsview-other-mouse-down self event)
  (tell #:type _void (coerce-arg self) otherMouseDown: (coerce-arg event)))
(define (nsview-other-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) otherMouseDragged: (coerce-arg event)))
(define (nsview-other-mouse-up self event)
  (tell #:type _void (coerce-arg self) otherMouseUp: (coerce-arg event)))
(define (nsview-perform-key-equivalent! self event)
  (_msg-26 (coerce-arg self) (sel_registerName "performKeyEquivalent:") (coerce-arg event)))
(define (nsview-prepare-content-in-rect self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "prepareContentInRect:") rect))
(define (nsview-prepare-for-reuse self)
  (tell #:type _void (coerce-arg self) prepareForReuse))
(define (nsview-pressure-change-with-event self event)
  (tell #:type _void (coerce-arg self) pressureChangeWithEvent: (coerce-arg event)))
(define (nsview-quick-look-with-event self event)
  (tell #:type _void (coerce-arg self) quickLookWithEvent: (coerce-arg event)))
(define (nsview-rect-for-smart-magnification-at-point-in-rect self location visible-rect)
  (_msg-9 (coerce-arg self) (sel_registerName "rectForSmartMagnificationAtPoint:inRect:") location visible-rect))
(define (nsview-remove-all-tool-tips! self)
  (tell #:type _void (coerce-arg self) removeAllToolTips))
(define (nsview-remove-from-superview! self)
  (tell #:type _void (coerce-arg self) removeFromSuperview))
(define (nsview-remove-from-superview-without-needing-display! self)
  (tell #:type _void (coerce-arg self) removeFromSuperviewWithoutNeedingDisplay))
(define (nsview-remove-tool-tip! self tag)
  (_msg-29 (coerce-arg self) (sel_registerName "removeToolTip:") tag))
(define (nsview-replace-subview-with! self old-view new-view)
  (tell #:type _void (coerce-arg self) replaceSubview: (coerce-arg old-view) with: (coerce-arg new-view)))
(define (nsview-resign-first-responder self)
  (_msg-1 (coerce-arg self) (sel_registerName "resignFirstResponder")))
(define (nsview-resize-subviews-with-old-size self old-size)
  (_msg-22 (coerce-arg self) (sel_registerName "resizeSubviewsWithOldSize:") old-size))
(define (nsview-resize-with-old-superview-size self old-size)
  (_msg-22 (coerce-arg self) (sel_registerName "resizeWithOldSuperviewSize:") old-size))
(define (nsview-right-mouse-down self event)
  (tell #:type _void (coerce-arg self) rightMouseDown: (coerce-arg event)))
(define (nsview-right-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) rightMouseDragged: (coerce-arg event)))
(define (nsview-right-mouse-up self event)
  (tell #:type _void (coerce-arg self) rightMouseUp: (coerce-arg event)))
(define (nsview-rotate-by-angle self angle)
  (_msg-25 (coerce-arg self) (sel_registerName "rotateByAngle:") angle))
(define (nsview-rotate-with-event self event)
  (tell #:type _void (coerce-arg self) rotateWithEvent: (coerce-arg event)))
(define (nsview-scale-unit-square-to-size self new-unit-size)
  (_msg-22 (coerce-arg self) (sel_registerName "scaleUnitSquareToSize:") new-unit-size))
(define (nsview-scroll-point self point)
  (_msg-8 (coerce-arg self) (sel_registerName "scrollPoint:") point))
(define (nsview-scroll-rect-to-visible self rect)
  (_msg-13 (coerce-arg self) (sel_registerName "scrollRectToVisible:") rect))
(define (nsview-scroll-wheel self event)
  (tell #:type _void (coerce-arg self) scrollWheel: (coerce-arg event)))
(define (nsview-set-bounds-origin! self new-origin)
  (_msg-8 (coerce-arg self) (sel_registerName "setBoundsOrigin:") new-origin))
(define (nsview-set-bounds-size! self new-size)
  (_msg-22 (coerce-arg self) (sel_registerName "setBoundsSize:") new-size))
(define (nsview-set-frame-origin! self new-origin)
  (_msg-8 (coerce-arg self) (sel_registerName "setFrameOrigin:") new-origin))
(define (nsview-set-frame-size! self new-size)
  (_msg-22 (coerce-arg self) (sel_registerName "setFrameSize:") new-size))
(define (nsview-set-needs-display-in-rect! self invalid-rect)
  (_msg-15 (coerce-arg self) (sel_registerName "setNeedsDisplayInRect:") invalid-rect))
(define (nsview-should-be-treated-as-ink-event self event)
  (_msg-26 (coerce-arg self) (sel_registerName "shouldBeTreatedAsInkEvent:") (coerce-arg event)))
(define (nsview-should-delay-window-ordering-for-event self event)
  (_msg-26 (coerce-arg self) (sel_registerName "shouldDelayWindowOrderingForEvent:") (coerce-arg event)))
(define (nsview-show-context-help self sender)
  (tell #:type _void (coerce-arg self) showContextHelp: (coerce-arg sender)))
(define (nsview-smart-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) smartMagnifyWithEvent: (coerce-arg event)))
(define (nsview-sort-subviews-using-function-context self compare context)
  (_msg-33 (coerce-arg self) (sel_registerName "sortSubviewsUsingFunction:context:") compare context))
(define (nsview-supplemental-target-for-action-sender self action sender)
  (wrap-objc-object
   (_msg-32 (coerce-arg self) (sel_registerName "supplementalTargetForAction:sender:") action (coerce-arg sender))
   ))
(define (nsview-swipe-with-event self event)
  (tell #:type _void (coerce-arg self) swipeWithEvent: (coerce-arg event)))
(define (nsview-tablet-point self event)
  (tell #:type _void (coerce-arg self) tabletPoint: (coerce-arg event)))
(define (nsview-tablet-proximity self event)
  (tell #:type _void (coerce-arg self) tabletProximity: (coerce-arg event)))
(define (nsview-touches-began-with-event self event)
  (tell #:type _void (coerce-arg self) touchesBeganWithEvent: (coerce-arg event)))
(define (nsview-touches-cancelled-with-event self event)
  (tell #:type _void (coerce-arg self) touchesCancelledWithEvent: (coerce-arg event)))
(define (nsview-touches-ended-with-event self event)
  (tell #:type _void (coerce-arg self) touchesEndedWithEvent: (coerce-arg event)))
(define (nsview-touches-moved-with-event self event)
  (tell #:type _void (coerce-arg self) touchesMovedWithEvent: (coerce-arg event)))
(define (nsview-translate-origin-to-point self translation)
  (_msg-8 (coerce-arg self) (sel_registerName "translateOriginToPoint:") translation))
(define (nsview-translate-rects-needing-display-in-rect-by self clip-rect delta)
  (_msg-16 (coerce-arg self) (sel_registerName "translateRectsNeedingDisplayInRect:by:") clip-rect delta))
(define (nsview-try-to-perform-with self action object)
  (_msg-31 (coerce-arg self) (sel_registerName "tryToPerform:with:") action (coerce-arg object)))
(define (nsview-update-layer self)
  (tell #:type _void (coerce-arg self) updateLayer))
(define (nsview-valid-requestor-for-send-type-return-type self send-type return-type)
  (wrap-objc-object
   (tell (coerce-arg self) validRequestorForSendType: (coerce-arg send-type) returnType: (coerce-arg return-type))))
(define (nsview-view-did-change-backing-properties self)
  (tell #:type _void (coerce-arg self) viewDidChangeBackingProperties))
(define (nsview-view-did-change-effective-appearance self)
  (tell #:type _void (coerce-arg self) viewDidChangeEffectiveAppearance))
(define (nsview-view-did-end-live-resize self)
  (tell #:type _void (coerce-arg self) viewDidEndLiveResize))
(define (nsview-view-did-hide self)
  (tell #:type _void (coerce-arg self) viewDidHide))
(define (nsview-view-did-move-to-superview self)
  (tell #:type _void (coerce-arg self) viewDidMoveToSuperview))
(define (nsview-view-did-move-to-window self)
  (tell #:type _void (coerce-arg self) viewDidMoveToWindow))
(define (nsview-view-did-unhide self)
  (tell #:type _void (coerce-arg self) viewDidUnhide))
(define (nsview-view-will-draw self)
  (tell #:type _void (coerce-arg self) viewWillDraw))
(define (nsview-view-will-move-to-superview self new-superview)
  (tell #:type _void (coerce-arg self) viewWillMoveToSuperview: (coerce-arg new-superview)))
(define (nsview-view-will-move-to-window self new-window)
  (tell #:type _void (coerce-arg self) viewWillMoveToWindow: (coerce-arg new-window)))
(define (nsview-view-will-start-live-resize self)
  (tell #:type _void (coerce-arg self) viewWillStartLiveResize))
(define (nsview-view-with-tag self tag)
  (wrap-objc-object
   (_msg-28 (coerce-arg self) (sel_registerName "viewWithTag:") tag)
   ))
(define (nsview-wants-forwarded-scroll-events-for-axis self axis)
  (_msg-34 (coerce-arg self) (sel_registerName "wantsForwardedScrollEventsForAxis:") axis))
(define (nsview-wants-scroll-events-for-swipe-tracking-on-axis self axis)
  (_msg-34 (coerce-arg self) (sel_registerName "wantsScrollEventsForSwipeTrackingOnAxis:") axis))
(define (nsview-will-open-menu-with-event self menu event)
  (tell #:type _void (coerce-arg self) willOpenMenu: (coerce-arg menu) withEvent: (coerce-arg event)))
(define (nsview-will-remove-subview self subview)
  (tell #:type _void (coerce-arg self) willRemoveSubview: (coerce-arg subview)))

;; --- Class methods ---
(define (nsview-is-compatible-with-responsive-scrolling)
  (_msg-1 NSView (sel_registerName "isCompatibleWithResponsiveScrolling")))
