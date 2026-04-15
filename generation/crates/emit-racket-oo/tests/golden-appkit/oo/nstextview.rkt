#lang racket/base
;; Generated binding for NSTextView (AppKit)
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

(provide NSTextView)
(provide/contract
  [make-nstextview-init-with-coder (c-> (or/c string? objc-object? cpointer?) any/c)]
  [make-nstextview-init-with-frame (c-> any/c any/c)]
  [make-nstextview-init-with-frame-text-container (c-> any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstextview-acceptable-drag-types (c-> objc-object? any/c)]
  [nstextview-accepts-first-responder (c-> objc-object? boolean?)]
  [nstextview-accepts-glyph-info (c-> objc-object? boolean?)]
  [nstextview-set-accepts-glyph-info! (c-> objc-object? boolean? void?)]
  [nstextview-accepts-touch-events (c-> objc-object? boolean?)]
  [nstextview-set-accepts-touch-events! (c-> objc-object? boolean? void?)]
  [nstextview-additional-safe-area-insets (c-> objc-object? any/c)]
  [nstextview-set-additional-safe-area-insets! (c-> objc-object? any/c void?)]
  [nstextview-alignment (c-> objc-object? exact-nonnegative-integer?)]
  [nstextview-set-alignment! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextview-alignment-rect-insets (c-> objc-object? any/c)]
  [nstextview-allowed-input-source-locales (c-> objc-object? any/c)]
  [nstextview-set-allowed-input-source-locales! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-allowed-touch-types (c-> objc-object? exact-nonnegative-integer?)]
  [nstextview-set-allowed-touch-types! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextview-allowed-writing-tools-result-options (c-> objc-object? exact-nonnegative-integer?)]
  [nstextview-set-allowed-writing-tools-result-options! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextview-allows-character-picker-touch-bar-item (c-> objc-object? boolean?)]
  [nstextview-set-allows-character-picker-touch-bar-item! (c-> objc-object? boolean? void?)]
  [nstextview-allows-document-background-color-change (c-> objc-object? boolean?)]
  [nstextview-set-allows-document-background-color-change! (c-> objc-object? boolean? void?)]
  [nstextview-allows-image-editing (c-> objc-object? boolean?)]
  [nstextview-set-allows-image-editing! (c-> objc-object? boolean? void?)]
  [nstextview-allows-undo (c-> objc-object? boolean?)]
  [nstextview-set-allows-undo! (c-> objc-object? boolean? void?)]
  [nstextview-allows-vibrancy (c-> objc-object? boolean?)]
  [nstextview-alpha-value (c-> objc-object? real?)]
  [nstextview-set-alpha-value! (c-> objc-object? real? void?)]
  [nstextview-automatic-dash-substitution-enabled (c-> objc-object? boolean?)]
  [nstextview-set-automatic-dash-substitution-enabled! (c-> objc-object? boolean? void?)]
  [nstextview-automatic-data-detection-enabled (c-> objc-object? boolean?)]
  [nstextview-set-automatic-data-detection-enabled! (c-> objc-object? boolean? void?)]
  [nstextview-automatic-link-detection-enabled (c-> objc-object? boolean?)]
  [nstextview-set-automatic-link-detection-enabled! (c-> objc-object? boolean? void?)]
  [nstextview-automatic-quote-substitution-enabled (c-> objc-object? boolean?)]
  [nstextview-set-automatic-quote-substitution-enabled! (c-> objc-object? boolean? void?)]
  [nstextview-automatic-spelling-correction-enabled (c-> objc-object? boolean?)]
  [nstextview-set-automatic-spelling-correction-enabled! (c-> objc-object? boolean? void?)]
  [nstextview-automatic-text-completion-enabled (c-> objc-object? boolean?)]
  [nstextview-set-automatic-text-completion-enabled! (c-> objc-object? boolean? void?)]
  [nstextview-automatic-text-replacement-enabled (c-> objc-object? boolean?)]
  [nstextview-set-automatic-text-replacement-enabled! (c-> objc-object? boolean? void?)]
  [nstextview-autoresizes-subviews (c-> objc-object? boolean?)]
  [nstextview-set-autoresizes-subviews! (c-> objc-object? boolean? void?)]
  [nstextview-autoresizing-mask (c-> objc-object? exact-nonnegative-integer?)]
  [nstextview-set-autoresizing-mask! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextview-background-color (c-> objc-object? any/c)]
  [nstextview-set-background-color! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-background-filters (c-> objc-object? any/c)]
  [nstextview-set-background-filters! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-base-writing-direction (c-> objc-object? exact-nonnegative-integer?)]
  [nstextview-set-base-writing-direction! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextview-baseline-offset-from-bottom (c-> objc-object? real?)]
  [nstextview-bottom-anchor (c-> objc-object? any/c)]
  [nstextview-bounds (c-> objc-object? any/c)]
  [nstextview-set-bounds! (c-> objc-object? any/c void?)]
  [nstextview-bounds-rotation (c-> objc-object? real?)]
  [nstextview-set-bounds-rotation! (c-> objc-object? real? void?)]
  [nstextview-can-become-key-view (c-> objc-object? boolean?)]
  [nstextview-can-draw (c-> objc-object? boolean?)]
  [nstextview-can-draw-concurrently (c-> objc-object? boolean?)]
  [nstextview-set-can-draw-concurrently! (c-> objc-object? boolean? void?)]
  [nstextview-can-draw-subviews-into-layer (c-> objc-object? boolean?)]
  [nstextview-set-can-draw-subviews-into-layer! (c-> objc-object? boolean? void?)]
  [nstextview-candidate-list-touch-bar-item (c-> objc-object? any/c)]
  [nstextview-center-x-anchor (c-> objc-object? any/c)]
  [nstextview-center-y-anchor (c-> objc-object? any/c)]
  [nstextview-clips-to-bounds (c-> objc-object? boolean?)]
  [nstextview-set-clips-to-bounds! (c-> objc-object? boolean? void?)]
  [nstextview-coalescing-undo (c-> objc-object? boolean?)]
  [nstextview-compatible-with-responsive-scrolling (c-> boolean?)]
  [nstextview-compositing-filter (c-> objc-object? any/c)]
  [nstextview-set-compositing-filter! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-constraints (c-> objc-object? any/c)]
  [nstextview-content-filters (c-> objc-object? any/c)]
  [nstextview-set-content-filters! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-continuous-spell-checking-enabled (c-> objc-object? boolean?)]
  [nstextview-set-continuous-spell-checking-enabled! (c-> objc-object? boolean? void?)]
  [nstextview-default-focus-ring-type (c-> exact-nonnegative-integer?)]
  [nstextview-default-menu (c-> any/c)]
  [nstextview-default-paragraph-style (c-> objc-object? any/c)]
  [nstextview-set-default-paragraph-style! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-delegate (c-> objc-object? any/c)]
  [nstextview-set-delegate! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-displays-link-tool-tips (c-> objc-object? boolean?)]
  [nstextview-set-displays-link-tool-tips! (c-> objc-object? boolean? void?)]
  [nstextview-drawing-find-indicator (c-> objc-object? boolean?)]
  [nstextview-draws-background (c-> objc-object? boolean?)]
  [nstextview-set-draws-background! (c-> objc-object? boolean? void?)]
  [nstextview-editable (c-> objc-object? boolean?)]
  [nstextview-set-editable! (c-> objc-object? boolean? void?)]
  [nstextview-enabled-text-checking-types (c-> objc-object? exact-nonnegative-integer?)]
  [nstextview-set-enabled-text-checking-types! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextview-enclosing-menu-item (c-> objc-object? any/c)]
  [nstextview-enclosing-scroll-view (c-> objc-object? any/c)]
  [nstextview-field-editor (c-> objc-object? boolean?)]
  [nstextview-set-field-editor! (c-> objc-object? boolean? void?)]
  [nstextview-first-baseline-anchor (c-> objc-object? any/c)]
  [nstextview-first-baseline-offset-from-top (c-> objc-object? real?)]
  [nstextview-fitting-size (c-> objc-object? any/c)]
  [nstextview-flipped (c-> objc-object? boolean?)]
  [nstextview-focus-ring-mask-bounds (c-> objc-object? any/c)]
  [nstextview-focus-ring-type (c-> objc-object? exact-nonnegative-integer?)]
  [nstextview-set-focus-ring-type! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextview-focus-view (c-> any/c)]
  [nstextview-font (c-> objc-object? any/c)]
  [nstextview-set-font! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-frame (c-> objc-object? any/c)]
  [nstextview-set-frame! (c-> objc-object? any/c void?)]
  [nstextview-frame-center-rotation (c-> objc-object? real?)]
  [nstextview-set-frame-center-rotation! (c-> objc-object? real? void?)]
  [nstextview-frame-rotation (c-> objc-object? real?)]
  [nstextview-set-frame-rotation! (c-> objc-object? real? void?)]
  [nstextview-gesture-recognizers (c-> objc-object? any/c)]
  [nstextview-set-gesture-recognizers! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-grammar-checking-enabled (c-> objc-object? boolean?)]
  [nstextview-set-grammar-checking-enabled! (c-> objc-object? boolean? void?)]
  [nstextview-has-ambiguous-layout (c-> objc-object? boolean?)]
  [nstextview-height-adjust-limit (c-> objc-object? real?)]
  [nstextview-height-anchor (c-> objc-object? any/c)]
  [nstextview-hidden (c-> objc-object? boolean?)]
  [nstextview-set-hidden! (c-> objc-object? boolean? void?)]
  [nstextview-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nstextview-horizontal-content-size-constraint-active (c-> objc-object? boolean?)]
  [nstextview-set-horizontal-content-size-constraint-active! (c-> objc-object? boolean? void?)]
  [nstextview-horizontally-resizable (c-> objc-object? boolean?)]
  [nstextview-set-horizontally-resizable! (c-> objc-object? boolean? void?)]
  [nstextview-imports-graphics (c-> objc-object? boolean?)]
  [nstextview-set-imports-graphics! (c-> objc-object? boolean? void?)]
  [nstextview-in-full-screen-mode (c-> objc-object? boolean?)]
  [nstextview-in-live-resize (c-> objc-object? boolean?)]
  [nstextview-incremental-searching-enabled (c-> objc-object? boolean?)]
  [nstextview-set-incremental-searching-enabled! (c-> objc-object? boolean? void?)]
  [nstextview-inline-prediction-type (c-> objc-object? exact-nonnegative-integer?)]
  [nstextview-set-inline-prediction-type! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextview-input-context (c-> objc-object? any/c)]
  [nstextview-insertion-point-color (c-> objc-object? any/c)]
  [nstextview-set-insertion-point-color! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-intrinsic-content-size (c-> objc-object? any/c)]
  [nstextview-last-baseline-anchor (c-> objc-object? any/c)]
  [nstextview-last-baseline-offset-from-bottom (c-> objc-object? real?)]
  [nstextview-layer (c-> objc-object? any/c)]
  [nstextview-set-layer! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-layer-contents-placement (c-> objc-object? exact-nonnegative-integer?)]
  [nstextview-set-layer-contents-placement! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextview-layer-contents-redraw-policy (c-> objc-object? exact-nonnegative-integer?)]
  [nstextview-set-layer-contents-redraw-policy! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextview-layer-uses-core-image-filters (c-> objc-object? boolean?)]
  [nstextview-set-layer-uses-core-image-filters! (c-> objc-object? boolean? void?)]
  [nstextview-layout-guides (c-> objc-object? any/c)]
  [nstextview-layout-manager (c-> objc-object? any/c)]
  [nstextview-layout-margins-guide (c-> objc-object? any/c)]
  [nstextview-leading-anchor (c-> objc-object? any/c)]
  [nstextview-left-anchor (c-> objc-object? any/c)]
  [nstextview-link-text-attributes (c-> objc-object? any/c)]
  [nstextview-set-link-text-attributes! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-marked-text-attributes (c-> objc-object? any/c)]
  [nstextview-set-marked-text-attributes! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-math-expression-completion-type (c-> objc-object? exact-nonnegative-integer?)]
  [nstextview-set-math-expression-completion-type! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextview-max-size (c-> objc-object? any/c)]
  [nstextview-set-max-size! (c-> objc-object? any/c void?)]
  [nstextview-menu (c-> objc-object? any/c)]
  [nstextview-set-menu! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-min-size (c-> objc-object? any/c)]
  [nstextview-set-min-size! (c-> objc-object? any/c void?)]
  [nstextview-mouse-down-can-move-window (c-> objc-object? boolean?)]
  [nstextview-needs-display (c-> objc-object? boolean?)]
  [nstextview-set-needs-display! (c-> objc-object? boolean? void?)]
  [nstextview-needs-layout (c-> objc-object? boolean?)]
  [nstextview-set-needs-layout! (c-> objc-object? boolean? void?)]
  [nstextview-needs-panel-to-become-key (c-> objc-object? boolean?)]
  [nstextview-needs-update-constraints (c-> objc-object? boolean?)]
  [nstextview-set-needs-update-constraints! (c-> objc-object? boolean? void?)]
  [nstextview-next-key-view (c-> objc-object? any/c)]
  [nstextview-set-next-key-view! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-next-responder (c-> objc-object? any/c)]
  [nstextview-set-next-responder! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-next-valid-key-view (c-> objc-object? any/c)]
  [nstextview-opaque (c-> objc-object? boolean?)]
  [nstextview-opaque-ancestor (c-> objc-object? any/c)]
  [nstextview-page-footer (c-> objc-object? any/c)]
  [nstextview-page-header (c-> objc-object? any/c)]
  [nstextview-posts-bounds-changed-notifications (c-> objc-object? boolean?)]
  [nstextview-set-posts-bounds-changed-notifications! (c-> objc-object? boolean? void?)]
  [nstextview-posts-frame-changed-notifications (c-> objc-object? boolean?)]
  [nstextview-set-posts-frame-changed-notifications! (c-> objc-object? boolean? void?)]
  [nstextview-prefers-compact-control-size-metrics (c-> objc-object? boolean?)]
  [nstextview-set-prefers-compact-control-size-metrics! (c-> objc-object? boolean? void?)]
  [nstextview-prepared-content-rect (c-> objc-object? any/c)]
  [nstextview-set-prepared-content-rect! (c-> objc-object? any/c void?)]
  [nstextview-preserves-content-during-live-resize (c-> objc-object? boolean?)]
  [nstextview-pressure-configuration (c-> objc-object? any/c)]
  [nstextview-set-pressure-configuration! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-previous-key-view (c-> objc-object? any/c)]
  [nstextview-previous-valid-key-view (c-> objc-object? any/c)]
  [nstextview-print-job-title (c-> objc-object? any/c)]
  [nstextview-range-for-user-character-attribute-change (c-> objc-object? any/c)]
  [nstextview-range-for-user-completion (c-> objc-object? any/c)]
  [nstextview-range-for-user-paragraph-attribute-change (c-> objc-object? any/c)]
  [nstextview-range-for-user-text-change (c-> objc-object? any/c)]
  [nstextview-ranges-for-user-character-attribute-change (c-> objc-object? any/c)]
  [nstextview-ranges-for-user-paragraph-attribute-change (c-> objc-object? any/c)]
  [nstextview-ranges-for-user-text-change (c-> objc-object? any/c)]
  [nstextview-readable-pasteboard-types (c-> objc-object? any/c)]
  [nstextview-rect-preserved-during-live-resize (c-> objc-object? any/c)]
  [nstextview-registered-dragged-types (c-> objc-object? any/c)]
  [nstextview-requires-constraint-based-layout (c-> boolean?)]
  [nstextview-restorable-state-key-paths (c-> any/c)]
  [nstextview-rich-text (c-> objc-object? boolean?)]
  [nstextview-set-rich-text! (c-> objc-object? boolean? void?)]
  [nstextview-right-anchor (c-> objc-object? any/c)]
  [nstextview-rotated-from-base (c-> objc-object? boolean?)]
  [nstextview-rotated-or-scaled-from-base (c-> objc-object? boolean?)]
  [nstextview-ruler-visible (c-> objc-object? boolean?)]
  [nstextview-set-ruler-visible! (c-> objc-object? boolean? void?)]
  [nstextview-safe-area-insets (c-> objc-object? any/c)]
  [nstextview-safe-area-layout-guide (c-> objc-object? any/c)]
  [nstextview-safe-area-rect (c-> objc-object? any/c)]
  [nstextview-selectable (c-> objc-object? boolean?)]
  [nstextview-set-selectable! (c-> objc-object? boolean? void?)]
  [nstextview-selected-range (c-> objc-object? any/c)]
  [nstextview-set-selected-range! (c-> objc-object? any/c void?)]
  [nstextview-selected-ranges (c-> objc-object? any/c)]
  [nstextview-set-selected-ranges! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-selected-text-attributes (c-> objc-object? any/c)]
  [nstextview-set-selected-text-attributes! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-selection-affinity (c-> objc-object? exact-nonnegative-integer?)]
  [nstextview-selection-granularity (c-> objc-object? exact-nonnegative-integer?)]
  [nstextview-set-selection-granularity! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextview-shadow (c-> objc-object? any/c)]
  [nstextview-set-shadow! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-should-draw-insertion-point (c-> objc-object? boolean?)]
  [nstextview-smart-insert-delete-enabled (c-> objc-object? boolean?)]
  [nstextview-set-smart-insert-delete-enabled! (c-> objc-object? boolean? void?)]
  [nstextview-spell-checker-document-tag (c-> objc-object? exact-integer?)]
  [nstextview-string (c-> objc-object? any/c)]
  [nstextview-set-string! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-strongly-references-text-storage (c-> boolean?)]
  [nstextview-subviews (c-> objc-object? any/c)]
  [nstextview-set-subviews! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-superview (c-> objc-object? any/c)]
  [nstextview-tag (c-> objc-object? exact-integer?)]
  [nstextview-text-color (c-> objc-object? any/c)]
  [nstextview-set-text-color! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-text-container (c-> objc-object? any/c)]
  [nstextview-set-text-container! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-text-container-inset (c-> objc-object? any/c)]
  [nstextview-set-text-container-inset! (c-> objc-object? any/c void?)]
  [nstextview-text-container-origin (c-> objc-object? any/c)]
  [nstextview-text-content-storage (c-> objc-object? any/c)]
  [nstextview-text-highlight-attributes (c-> objc-object? any/c)]
  [nstextview-set-text-highlight-attributes! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-text-layout-manager (c-> objc-object? any/c)]
  [nstextview-text-storage (c-> objc-object? any/c)]
  [nstextview-tool-tip (c-> objc-object? any/c)]
  [nstextview-set-tool-tip! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-top-anchor (c-> objc-object? any/c)]
  [nstextview-touch-bar (c-> objc-object? any/c)]
  [nstextview-set-touch-bar! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-tracking-areas (c-> objc-object? any/c)]
  [nstextview-trailing-anchor (c-> objc-object? any/c)]
  [nstextview-translates-autoresizing-mask-into-constraints (c-> objc-object? boolean?)]
  [nstextview-set-translates-autoresizing-mask-into-constraints! (c-> objc-object? boolean? void?)]
  [nstextview-typing-attributes (c-> objc-object? any/c)]
  [nstextview-set-typing-attributes! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-undo-manager (c-> objc-object? any/c)]
  [nstextview-user-activity (c-> objc-object? any/c)]
  [nstextview-set-user-activity! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-user-interface-layout-direction (c-> objc-object? exact-nonnegative-integer?)]
  [nstextview-set-user-interface-layout-direction! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextview-uses-adaptive-color-mapping-for-dark-appearance (c-> objc-object? boolean?)]
  [nstextview-set-uses-adaptive-color-mapping-for-dark-appearance! (c-> objc-object? boolean? void?)]
  [nstextview-uses-find-bar (c-> objc-object? boolean?)]
  [nstextview-set-uses-find-bar! (c-> objc-object? boolean? void?)]
  [nstextview-uses-find-panel (c-> objc-object? boolean?)]
  [nstextview-set-uses-find-panel! (c-> objc-object? boolean? void?)]
  [nstextview-uses-font-panel (c-> objc-object? boolean?)]
  [nstextview-set-uses-font-panel! (c-> objc-object? boolean? void?)]
  [nstextview-uses-inspector-bar (c-> objc-object? boolean?)]
  [nstextview-set-uses-inspector-bar! (c-> objc-object? boolean? void?)]
  [nstextview-uses-rollover-button-for-selection (c-> objc-object? boolean?)]
  [nstextview-set-uses-rollover-button-for-selection! (c-> objc-object? boolean? void?)]
  [nstextview-uses-ruler (c-> objc-object? boolean?)]
  [nstextview-set-uses-ruler! (c-> objc-object? boolean? void?)]
  [nstextview-vertical-content-size-constraint-active (c-> objc-object? boolean?)]
  [nstextview-set-vertical-content-size-constraint-active! (c-> objc-object? boolean? void?)]
  [nstextview-vertically-resizable (c-> objc-object? boolean?)]
  [nstextview-set-vertically-resizable! (c-> objc-object? boolean? void?)]
  [nstextview-visible-rect (c-> objc-object? any/c)]
  [nstextview-wants-best-resolution-open-gl-surface (c-> objc-object? boolean?)]
  [nstextview-set-wants-best-resolution-open-gl-surface! (c-> objc-object? boolean? void?)]
  [nstextview-wants-default-clipping (c-> objc-object? boolean?)]
  [nstextview-wants-extended-dynamic-range-open-gl-surface (c-> objc-object? boolean?)]
  [nstextview-set-wants-extended-dynamic-range-open-gl-surface! (c-> objc-object? boolean? void?)]
  [nstextview-wants-layer (c-> objc-object? boolean?)]
  [nstextview-set-wants-layer! (c-> objc-object? boolean? void?)]
  [nstextview-wants-resting-touches (c-> objc-object? boolean?)]
  [nstextview-set-wants-resting-touches! (c-> objc-object? boolean? void?)]
  [nstextview-wants-update-layer (c-> objc-object? boolean?)]
  [nstextview-width-adjust-limit (c-> objc-object? real?)]
  [nstextview-width-anchor (c-> objc-object? any/c)]
  [nstextview-window (c-> objc-object? any/c)]
  [nstextview-writable-pasteboard-types (c-> objc-object? any/c)]
  [nstextview-writing-tools-active (c-> objc-object? boolean?)]
  [nstextview-writing-tools-behavior (c-> objc-object? exact-nonnegative-integer?)]
  [nstextview-set-writing-tools-behavior! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextview-writing-tools-coordinator (c-> objc-object? any/c)]
  [nstextview-set-writing-tools-coordinator! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-rtfd-from-range (c-> objc-object? any/c any/c)]
  [nstextview-rtf-from-range (c-> objc-object? any/c any/c)]
  [nstextview-accepts-first-mouse (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextview-add-subview! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-add-subview-positioned-relative-to! (c-> objc-object? (or/c string? objc-object? cpointer?) exact-nonnegative-integer? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-add-tool-tip-rect-owner-user-data! (c-> objc-object? any/c (or/c string? objc-object? cpointer?) (or/c cpointer? #f) exact-integer?)]
  [nstextview-adjust-scroll (c-> objc-object? any/c any/c)]
  [nstextview-align-center (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-align-justified (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-align-left (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-align-right (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-ancestor-shared-with-view (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nstextview-autoscroll (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextview-backing-aligned-rect-options (c-> objc-object? any/c exact-nonnegative-integer? any/c)]
  [nstextview-become-first-responder (c-> objc-object? boolean?)]
  [nstextview-begin-gesture-with-event! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-bitmap-image-rep-for-caching-display-in-rect (c-> objc-object? any/c any/c)]
  [nstextview-cache-display-in-rect-to-bitmap-image-rep (c-> objc-object? any/c (or/c string? objc-object? cpointer?) void?)]
  [nstextview-center-scan-rect! (c-> objc-object? any/c any/c)]
  [nstextview-change-attributes (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-change-color (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-change-document-background-color (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-change-font (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-change-layout-orientation (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-change-mode-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-character-index-for-insertion-at-point (c-> objc-object? any/c exact-nonnegative-integer?)]
  [nstextview-check-spelling (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-clicked-on-link-at-index (c-> objc-object? (or/c string? objc-object? cpointer?) exact-nonnegative-integer? void?)]
  [nstextview-context-menu-key-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-convert-point-from-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstextview-convert-point-to-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstextview-convert-point-from-backing (c-> objc-object? any/c any/c)]
  [nstextview-convert-point-from-layer (c-> objc-object? any/c any/c)]
  [nstextview-convert-point-to-backing (c-> objc-object? any/c any/c)]
  [nstextview-convert-point-to-layer (c-> objc-object? any/c any/c)]
  [nstextview-convert-rect-from-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstextview-convert-rect-to-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstextview-convert-rect-from-backing (c-> objc-object? any/c any/c)]
  [nstextview-convert-rect-from-layer (c-> objc-object? any/c any/c)]
  [nstextview-convert-rect-to-backing (c-> objc-object? any/c any/c)]
  [nstextview-convert-rect-to-layer (c-> objc-object? any/c any/c)]
  [nstextview-convert-size-from-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstextview-convert-size-to-view (c-> objc-object? any/c (or/c string? objc-object? cpointer?) any/c)]
  [nstextview-convert-size-from-backing (c-> objc-object? any/c any/c)]
  [nstextview-convert-size-from-layer (c-> objc-object? any/c any/c)]
  [nstextview-convert-size-to-backing (c-> objc-object? any/c any/c)]
  [nstextview-convert-size-to-layer (c-> objc-object? any/c any/c)]
  [nstextview-copy (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-copy-font (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-copy-ruler (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-cursor-update (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-cut (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-delete (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-did-add-subview (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-did-close-menu-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstextview-display! (c-> objc-object? void?)]
  [nstextview-display-if-needed! (c-> objc-object? void?)]
  [nstextview-display-if-needed-ignoring-opacity! (c-> objc-object? void?)]
  [nstextview-display-if-needed-in-rect! (c-> objc-object? any/c void?)]
  [nstextview-display-if-needed-in-rect-ignoring-opacity! (c-> objc-object? any/c void?)]
  [nstextview-display-rect! (c-> objc-object? any/c void?)]
  [nstextview-display-rect-ignoring-opacity! (c-> objc-object? any/c void?)]
  [nstextview-display-rect-ignoring-opacity-in-context! (c-> objc-object? any/c (or/c string? objc-object? cpointer?) void?)]
  [nstextview-draw-insertion-point-in-rect-color-turned-on (c-> objc-object? any/c (or/c string? objc-object? cpointer?) boolean? void?)]
  [nstextview-draw-rect (c-> objc-object? any/c void?)]
  [nstextview-draw-view-background-in-rect (c-> objc-object? any/c void?)]
  [nstextview-end-gesture-with-event! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-flags-changed (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-flush-buffered-key-events (c-> objc-object? void?)]
  [nstextview-get-rects-being-drawn-count (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nstextview-get-rects-exposed-during-live-resize-count (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nstextview-help-requested (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-hit-test (c-> objc-object? any/c any/c)]
  [nstextview-init-using-text-layout-manager (c-> objc-object? boolean? any/c)]
  [nstextview-interpret-key-events (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-invalidate-text-container-origin (c-> objc-object? void?)]
  [nstextview-is-descendant-of (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextview-is-editable (c-> objc-object? boolean?)]
  [nstextview-is-field-editor (c-> objc-object? boolean?)]
  [nstextview-is-flipped (c-> objc-object? boolean?)]
  [nstextview-is-hidden (c-> objc-object? boolean?)]
  [nstextview-is-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nstextview-is-horizontally-resizable (c-> objc-object? boolean?)]
  [nstextview-is-opaque (c-> objc-object? boolean?)]
  [nstextview-is-rich-text (c-> objc-object? boolean?)]
  [nstextview-is-rotated-from-base (c-> objc-object? boolean?)]
  [nstextview-is-rotated-or-scaled-from-base (c-> objc-object? boolean?)]
  [nstextview-is-ruler-visible (c-> objc-object? boolean?)]
  [nstextview-is-selectable (c-> objc-object? boolean?)]
  [nstextview-is-vertically-resizable (c-> objc-object? boolean?)]
  [nstextview-key-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-key-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-layout (c-> objc-object? void?)]
  [nstextview-layout-subtree-if-needed (c-> objc-object? void?)]
  [nstextview-loosen-kerning (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-lower-baseline (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-magnify-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-make-backing-layer (c-> objc-object? any/c)]
  [nstextview-menu-for-event (c-> objc-object? (or/c string? objc-object? cpointer?) any/c)]
  [nstextview-mouse-in-rect (c-> objc-object? any/c any/c boolean?)]
  [nstextview-mouse-cancelled (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-mouse-entered (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-mouse-exited (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-mouse-moved (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-needs-to-draw-rect (c-> objc-object? any/c boolean?)]
  [nstextview-no-responder-for (c-> objc-object? cpointer? void?)]
  [nstextview-order-front-link-panel! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-order-front-list-panel! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-order-front-spacing-panel! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-order-front-table-panel! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-other-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-other-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-other-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-outline (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-paste (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-paste-font (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-paste-ruler (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-perform-find-panel-action! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-perform-key-equivalent! (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextview-perform-validated-replacement-in-range-with-attributed-string! (c-> objc-object? any/c (or/c string? objc-object? cpointer?) boolean?)]
  [nstextview-prepare-content-in-rect (c-> objc-object? any/c void?)]
  [nstextview-prepare-for-reuse (c-> objc-object? void?)]
  [nstextview-pressure-change-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-quick-look-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-raise-baseline (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-read-rtfd-from-file (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextview-rect-for-smart-magnification-at-point-in-rect (c-> objc-object? any/c any/c any/c)]
  [nstextview-remove-all-tool-tips! (c-> objc-object? void?)]
  [nstextview-remove-from-superview! (c-> objc-object? void?)]
  [nstextview-remove-from-superview-without-needing-display! (c-> objc-object? void?)]
  [nstextview-remove-tool-tip! (c-> objc-object? exact-integer? void?)]
  [nstextview-replace-characters-in-range-with-rtf! (c-> objc-object? any/c (or/c string? objc-object? cpointer?) void?)]
  [nstextview-replace-characters-in-range-with-rtfd! (c-> objc-object? any/c (or/c string? objc-object? cpointer?) void?)]
  [nstextview-replace-characters-in-range-with-string! (c-> objc-object? any/c (or/c string? objc-object? cpointer?) void?)]
  [nstextview-replace-subview-with! (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstextview-replace-text-container! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-resign-first-responder (c-> objc-object? boolean?)]
  [nstextview-resize-subviews-with-old-size (c-> objc-object? any/c void?)]
  [nstextview-resize-with-old-superview-size (c-> objc-object? any/c void?)]
  [nstextview-right-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-right-mouse-dragged (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-right-mouse-up (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-rotate-by-angle (c-> objc-object? real? void?)]
  [nstextview-rotate-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-ruler-view-did-add-marker (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstextview-ruler-view-did-move-marker (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstextview-ruler-view-did-remove-marker (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstextview-ruler-view-handle-mouse-down (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstextview-ruler-view-should-add-marker (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) boolean?)]
  [nstextview-ruler-view-should-move-marker (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) boolean?)]
  [nstextview-ruler-view-should-remove-marker (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) boolean?)]
  [nstextview-ruler-view-will-add-marker-at-location (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) real? real?)]
  [nstextview-ruler-view-will-move-marker-to-location (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) real? real?)]
  [nstextview-scale-unit-square-to-size (c-> objc-object? any/c void?)]
  [nstextview-scroll-point (c-> objc-object? any/c void?)]
  [nstextview-scroll-range-to-visible (c-> objc-object? any/c void?)]
  [nstextview-scroll-rect-to-visible (c-> objc-object? any/c boolean?)]
  [nstextview-scroll-wheel (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-select-all (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-selection-range-for-proposed-range-granularity (c-> objc-object? any/c exact-nonnegative-integer? any/c)]
  [nstextview-set-alignment-range! (c-> objc-object? exact-nonnegative-integer? any/c void?)]
  [nstextview-set-base-writing-direction-range! (c-> objc-object? exact-nonnegative-integer? any/c void?)]
  [nstextview-set-bounds-origin! (c-> objc-object? any/c void?)]
  [nstextview-set-bounds-size! (c-> objc-object? any/c void?)]
  [nstextview-set-constrained-frame-size! (c-> objc-object? any/c void?)]
  [nstextview-set-font-range! (c-> objc-object? (or/c string? objc-object? cpointer?) any/c void?)]
  [nstextview-set-frame-origin! (c-> objc-object? any/c void?)]
  [nstextview-set-frame-size! (c-> objc-object? any/c void?)]
  [nstextview-set-layout-orientation! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nstextview-set-needs-display-in-rect! (c-> objc-object? any/c void?)]
  [nstextview-set-needs-display-in-rect-avoid-additional-layout! (c-> objc-object? any/c boolean? void?)]
  [nstextview-set-text-color-range! (c-> objc-object? (or/c string? objc-object? cpointer?) any/c void?)]
  [nstextview-should-be-treated-as-ink-event (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextview-should-delay-window-ordering-for-event (c-> objc-object? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextview-show-context-help (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-show-guess-panel (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-size-to-fit (c-> objc-object? void?)]
  [nstextview-smart-magnify-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-sort-subviews-using-function-context (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nstextview-start-speaking (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-stop-speaking (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-subscript (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-superscript (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-supplemental-target-for-action-sender (c-> objc-object? cpointer? (or/c string? objc-object? cpointer?) any/c)]
  [nstextview-swipe-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-tablet-point (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-tablet-proximity (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-tighten-kerning (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-toggle-ruler! (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-touches-began-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-touches-cancelled-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-touches-ended-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-touches-moved-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-translate-origin-to-point (c-> objc-object? any/c void?)]
  [nstextview-translate-rects-needing-display-in-rect-by (c-> objc-object? any/c any/c void?)]
  [nstextview-try-to-perform-with (c-> objc-object? cpointer? (or/c string? objc-object? cpointer?) boolean?)]
  [nstextview-turn-off-kerning (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-turn-off-ligatures (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-underline (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-unscript (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-update-drag-type-registration (c-> objc-object? void?)]
  [nstextview-update-font-panel (c-> objc-object? void?)]
  [nstextview-update-layer (c-> objc-object? void?)]
  [nstextview-update-ruler (c-> objc-object? void?)]
  [nstextview-use-all-ligatures (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-use-standard-kerning (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-use-standard-ligatures (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-valid-requestor-for-send-type-return-type (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) any/c)]
  [nstextview-view-did-change-backing-properties (c-> objc-object? void?)]
  [nstextview-view-did-change-effective-appearance (c-> objc-object? void?)]
  [nstextview-view-did-end-live-resize (c-> objc-object? void?)]
  [nstextview-view-did-hide (c-> objc-object? void?)]
  [nstextview-view-did-move-to-superview (c-> objc-object? void?)]
  [nstextview-view-did-move-to-window (c-> objc-object? void?)]
  [nstextview-view-did-unhide (c-> objc-object? void?)]
  [nstextview-view-will-draw (c-> objc-object? void?)]
  [nstextview-view-will-move-to-superview (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-view-will-move-to-window (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-view-will-start-live-resize (c-> objc-object? void?)]
  [nstextview-view-with-tag (c-> objc-object? exact-integer? any/c)]
  [nstextview-wants-forwarded-scroll-events-for-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nstextview-wants-scroll-events-for-swipe-tracking-on-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nstextview-will-open-menu-with-event (c-> objc-object? (or/c string? objc-object? cpointer?) (or/c string? objc-object? cpointer?) void?)]
  [nstextview-will-remove-subview (c-> objc-object? (or/c string? objc-object? cpointer?) void?)]
  [nstextview-write-rtfd-to-file-atomically (c-> objc-object? (or/c string? objc-object? cpointer?) boolean? boolean?)]
  [nstextview-is-compatible-with-responsive-scrolling (c-> boolean?)]
  [nstextview-text-view-using-text-layout-manager (c-> boolean? any/c)]
  )

;; --- Class reference ---
(import-class NSTextView)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _NSPoint)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _NSPoint)))
(define _msg-1  ; (_fun _pointer _pointer -> _NSRange)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _NSRange)))
(define _msg-2  ; (_fun _pointer _pointer -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _NSRect)))
(define _msg-3  ; (_fun _pointer _pointer -> _NSSize)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _NSSize)))
(define _msg-4  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-5  ; (_fun _pointer _pointer -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _double)))
(define _msg-6  ; (_fun _pointer _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _int64)))
(define _msg-7  ; (_fun _pointer _pointer -> _uint64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _uint64)))
(define _msg-8  ; (_fun _pointer _pointer _NSEdgeInsets -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSEdgeInsets -> _void)))
(define _msg-9  ; (_fun _pointer _pointer _NSPoint -> _NSPoint)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _NSPoint)))
(define _msg-10  ; (_fun _pointer _pointer _NSPoint -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _id)))
(define _msg-11  ; (_fun _pointer _pointer _NSPoint -> _uint64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _uint64)))
(define _msg-12  ; (_fun _pointer _pointer _NSPoint -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _void)))
(define _msg-13  ; (_fun _pointer _pointer _NSPoint _NSRect -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _NSRect -> _NSRect)))
(define _msg-14  ; (_fun _pointer _pointer _NSPoint _NSRect -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _NSRect -> _bool)))
(define _msg-15  ; (_fun _pointer _pointer _NSPoint _id -> _NSPoint)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _id -> _NSPoint)))
(define _msg-16  ; (_fun _pointer _pointer _NSRange -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRange -> _id)))
(define _msg-17  ; (_fun _pointer _pointer _NSRange -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRange -> _void)))
(define _msg-18  ; (_fun _pointer _pointer _NSRange _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRange _id -> _bool)))
(define _msg-19  ; (_fun _pointer _pointer _NSRange _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRange _id -> _void)))
(define _msg-20  ; (_fun _pointer _pointer _NSRange _uint64 -> _NSRange)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRange _uint64 -> _NSRange)))
(define _msg-21  ; (_fun _pointer _pointer _NSRect -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _NSRect)))
(define _msg-22  ; (_fun _pointer _pointer _NSRect -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _bool)))
(define _msg-23  ; (_fun _pointer _pointer _NSRect -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _id)))
(define _msg-24  ; (_fun _pointer _pointer _NSRect -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _void)))
(define _msg-25  ; (_fun _pointer _pointer _NSRect _NSSize -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _NSSize -> _void)))
(define _msg-26  ; (_fun _pointer _pointer _NSRect _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _bool -> _void)))
(define _msg-27  ; (_fun _pointer _pointer _NSRect _id -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id -> _NSRect)))
(define _msg-28  ; (_fun _pointer _pointer _NSRect _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id -> _id)))
(define _msg-29  ; (_fun _pointer _pointer _NSRect _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id -> _void)))
(define _msg-30  ; (_fun _pointer _pointer _NSRect _id _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id _bool -> _void)))
(define _msg-31  ; (_fun _pointer _pointer _NSRect _id _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id _pointer -> _int64)))
(define _msg-32  ; (_fun _pointer _pointer _NSRect _uint64 -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _uint64 -> _NSRect)))
(define _msg-33  ; (_fun _pointer _pointer _NSSize -> _NSSize)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize -> _NSSize)))
(define _msg-34  ; (_fun _pointer _pointer _NSSize -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize -> _void)))
(define _msg-35  ; (_fun _pointer _pointer _NSSize _id -> _NSSize)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize _id -> _NSSize)))
(define _msg-36  ; (_fun _pointer _pointer _bool -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool -> _id)))
(define _msg-37  ; (_fun _pointer _pointer _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool -> _void)))
(define _msg-38  ; (_fun _pointer _pointer _double -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double -> _void)))
(define _msg-39  ; (_fun _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _bool)))
(define _msg-40  ; (_fun _pointer _pointer _id _NSRange -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _NSRange -> _void)))
(define _msg-41  ; (_fun _pointer _pointer _id _bool -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _bool -> _bool)))
(define _msg-42  ; (_fun _pointer _pointer _id _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _id -> _bool)))
(define _msg-43  ; (_fun _pointer _pointer _id _id _double -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _id _double -> _double)))
(define _msg-44  ; (_fun _pointer _pointer _id _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _uint64 -> _void)))
(define _msg-45  ; (_fun _pointer _pointer _id _uint64 _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _uint64 _id -> _void)))
(define _msg-46  ; (_fun _pointer _pointer _int64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _id)))
(define _msg-47  ; (_fun _pointer _pointer _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _void)))
(define _msg-48  ; (_fun _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))
(define _msg-49  ; (_fun _pointer _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _bool)))
(define _msg-50  ; (_fun _pointer _pointer _pointer _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _id)))
(define _msg-51  ; (_fun _pointer _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _pointer -> _void)))
(define _msg-52  ; (_fun _pointer _pointer _uint64 -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _bool)))
(define _msg-53  ; (_fun _pointer _pointer _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _void)))
(define _msg-54  ; (_fun _pointer _pointer _uint64 _NSRange -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 _NSRange -> _void)))

;; --- Constructors ---
(define (make-nstextview-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSTextView alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))

(define (make-nstextview-init-with-frame frame-rect)
  (wrap-objc-object
   (_msg-23 (tell NSTextView alloc)
       (sel_registerName "initWithFrame:")
       frame-rect)
   #:retained #t))

(define (make-nstextview-init-with-frame-text-container frame-rect container)
  (wrap-objc-object
   (_msg-28 (tell NSTextView alloc)
       (sel_registerName "initWithFrame:textContainer:")
       frame-rect
       (coerce-arg container))
   #:retained #t))


;; --- Properties ---
(define (nstextview-acceptable-drag-types self)
  (wrap-objc-object
   (tell (coerce-arg self) acceptableDragTypes)))
(define (nstextview-accepts-first-responder self)
  (tell #:type _bool (coerce-arg self) acceptsFirstResponder))
(define (nstextview-accepts-glyph-info self)
  (tell #:type _bool (coerce-arg self) acceptsGlyphInfo))
(define (nstextview-set-accepts-glyph-info! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setAcceptsGlyphInfo:") value))
(define (nstextview-accepts-touch-events self)
  (tell #:type _bool (coerce-arg self) acceptsTouchEvents))
(define (nstextview-set-accepts-touch-events! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setAcceptsTouchEvents:") value))
(define (nstextview-additional-safe-area-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) additionalSafeAreaInsets))
(define (nstextview-set-additional-safe-area-insets! self value)
  (_msg-8 (coerce-arg self) (sel_registerName "setAdditionalSafeAreaInsets:") value))
(define (nstextview-alignment self)
  (tell #:type _uint64 (coerce-arg self) alignment))
(define (nstextview-set-alignment! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setAlignment:") value))
(define (nstextview-alignment-rect-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) alignmentRectInsets))
(define (nstextview-allowed-input-source-locales self)
  (wrap-objc-object
   (tell (coerce-arg self) allowedInputSourceLocales)))
(define (nstextview-set-allowed-input-source-locales! self value)
  (tell #:type _void (coerce-arg self) setAllowedInputSourceLocales: (coerce-arg value)))
(define (nstextview-allowed-touch-types self)
  (tell #:type _uint64 (coerce-arg self) allowedTouchTypes))
(define (nstextview-set-allowed-touch-types! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setAllowedTouchTypes:") value))
(define (nstextview-allowed-writing-tools-result-options self)
  (tell #:type _uint64 (coerce-arg self) allowedWritingToolsResultOptions))
(define (nstextview-set-allowed-writing-tools-result-options! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setAllowedWritingToolsResultOptions:") value))
(define (nstextview-allows-character-picker-touch-bar-item self)
  (tell #:type _bool (coerce-arg self) allowsCharacterPickerTouchBarItem))
(define (nstextview-set-allows-character-picker-touch-bar-item! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setAllowsCharacterPickerTouchBarItem:") value))
(define (nstextview-allows-document-background-color-change self)
  (tell #:type _bool (coerce-arg self) allowsDocumentBackgroundColorChange))
(define (nstextview-set-allows-document-background-color-change! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setAllowsDocumentBackgroundColorChange:") value))
(define (nstextview-allows-image-editing self)
  (tell #:type _bool (coerce-arg self) allowsImageEditing))
(define (nstextview-set-allows-image-editing! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setAllowsImageEditing:") value))
(define (nstextview-allows-undo self)
  (tell #:type _bool (coerce-arg self) allowsUndo))
(define (nstextview-set-allows-undo! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setAllowsUndo:") value))
(define (nstextview-allows-vibrancy self)
  (tell #:type _bool (coerce-arg self) allowsVibrancy))
(define (nstextview-alpha-value self)
  (tell #:type _double (coerce-arg self) alphaValue))
(define (nstextview-set-alpha-value! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setAlphaValue:") value))
(define (nstextview-automatic-dash-substitution-enabled self)
  (tell #:type _bool (coerce-arg self) automaticDashSubstitutionEnabled))
(define (nstextview-set-automatic-dash-substitution-enabled! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setAutomaticDashSubstitutionEnabled:") value))
(define (nstextview-automatic-data-detection-enabled self)
  (tell #:type _bool (coerce-arg self) automaticDataDetectionEnabled))
(define (nstextview-set-automatic-data-detection-enabled! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setAutomaticDataDetectionEnabled:") value))
(define (nstextview-automatic-link-detection-enabled self)
  (tell #:type _bool (coerce-arg self) automaticLinkDetectionEnabled))
(define (nstextview-set-automatic-link-detection-enabled! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setAutomaticLinkDetectionEnabled:") value))
(define (nstextview-automatic-quote-substitution-enabled self)
  (tell #:type _bool (coerce-arg self) automaticQuoteSubstitutionEnabled))
(define (nstextview-set-automatic-quote-substitution-enabled! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setAutomaticQuoteSubstitutionEnabled:") value))
(define (nstextview-automatic-spelling-correction-enabled self)
  (tell #:type _bool (coerce-arg self) automaticSpellingCorrectionEnabled))
(define (nstextview-set-automatic-spelling-correction-enabled! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setAutomaticSpellingCorrectionEnabled:") value))
(define (nstextview-automatic-text-completion-enabled self)
  (tell #:type _bool (coerce-arg self) automaticTextCompletionEnabled))
(define (nstextview-set-automatic-text-completion-enabled! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setAutomaticTextCompletionEnabled:") value))
(define (nstextview-automatic-text-replacement-enabled self)
  (tell #:type _bool (coerce-arg self) automaticTextReplacementEnabled))
(define (nstextview-set-automatic-text-replacement-enabled! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setAutomaticTextReplacementEnabled:") value))
(define (nstextview-autoresizes-subviews self)
  (tell #:type _bool (coerce-arg self) autoresizesSubviews))
(define (nstextview-set-autoresizes-subviews! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setAutoresizesSubviews:") value))
(define (nstextview-autoresizing-mask self)
  (tell #:type _uint64 (coerce-arg self) autoresizingMask))
(define (nstextview-set-autoresizing-mask! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setAutoresizingMask:") value))
(define (nstextview-background-color self)
  (wrap-objc-object
   (tell (coerce-arg self) backgroundColor)))
(define (nstextview-set-background-color! self value)
  (tell #:type _void (coerce-arg self) setBackgroundColor: (coerce-arg value)))
(define (nstextview-background-filters self)
  (wrap-objc-object
   (tell (coerce-arg self) backgroundFilters)))
(define (nstextview-set-background-filters! self value)
  (tell #:type _void (coerce-arg self) setBackgroundFilters: (coerce-arg value)))
(define (nstextview-base-writing-direction self)
  (tell #:type _uint64 (coerce-arg self) baseWritingDirection))
(define (nstextview-set-base-writing-direction! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setBaseWritingDirection:") value))
(define (nstextview-baseline-offset-from-bottom self)
  (tell #:type _double (coerce-arg self) baselineOffsetFromBottom))
(define (nstextview-bottom-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) bottomAnchor)))
(define (nstextview-bounds self)
  (tell #:type _NSRect (coerce-arg self) bounds))
(define (nstextview-set-bounds! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setBounds:") value))
(define (nstextview-bounds-rotation self)
  (tell #:type _double (coerce-arg self) boundsRotation))
(define (nstextview-set-bounds-rotation! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setBoundsRotation:") value))
(define (nstextview-can-become-key-view self)
  (tell #:type _bool (coerce-arg self) canBecomeKeyView))
(define (nstextview-can-draw self)
  (tell #:type _bool (coerce-arg self) canDraw))
(define (nstextview-can-draw-concurrently self)
  (tell #:type _bool (coerce-arg self) canDrawConcurrently))
(define (nstextview-set-can-draw-concurrently! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setCanDrawConcurrently:") value))
(define (nstextview-can-draw-subviews-into-layer self)
  (tell #:type _bool (coerce-arg self) canDrawSubviewsIntoLayer))
(define (nstextview-set-can-draw-subviews-into-layer! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setCanDrawSubviewsIntoLayer:") value))
(define (nstextview-candidate-list-touch-bar-item self)
  (wrap-objc-object
   (tell (coerce-arg self) candidateListTouchBarItem)))
(define (nstextview-center-x-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) centerXAnchor)))
(define (nstextview-center-y-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) centerYAnchor)))
(define (nstextview-clips-to-bounds self)
  (tell #:type _bool (coerce-arg self) clipsToBounds))
(define (nstextview-set-clips-to-bounds! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setClipsToBounds:") value))
(define (nstextview-coalescing-undo self)
  (tell #:type _bool (coerce-arg self) coalescingUndo))
(define (nstextview-compatible-with-responsive-scrolling)
  (tell #:type _bool NSTextView compatibleWithResponsiveScrolling))
(define (nstextview-compositing-filter self)
  (wrap-objc-object
   (tell (coerce-arg self) compositingFilter)))
(define (nstextview-set-compositing-filter! self value)
  (tell #:type _void (coerce-arg self) setCompositingFilter: (coerce-arg value)))
(define (nstextview-constraints self)
  (wrap-objc-object
   (tell (coerce-arg self) constraints)))
(define (nstextview-content-filters self)
  (wrap-objc-object
   (tell (coerce-arg self) contentFilters)))
(define (nstextview-set-content-filters! self value)
  (tell #:type _void (coerce-arg self) setContentFilters: (coerce-arg value)))
(define (nstextview-continuous-spell-checking-enabled self)
  (tell #:type _bool (coerce-arg self) continuousSpellCheckingEnabled))
(define (nstextview-set-continuous-spell-checking-enabled! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setContinuousSpellCheckingEnabled:") value))
(define (nstextview-default-focus-ring-type)
  (tell #:type _uint64 NSTextView defaultFocusRingType))
(define (nstextview-default-menu)
  (wrap-objc-object
   (tell NSTextView defaultMenu)))
(define (nstextview-default-paragraph-style self)
  (wrap-objc-object
   (tell (coerce-arg self) defaultParagraphStyle)))
(define (nstextview-set-default-paragraph-style! self value)
  (tell #:type _void (coerce-arg self) setDefaultParagraphStyle: (coerce-arg value)))
(define (nstextview-delegate self)
  (wrap-objc-object
   (tell (coerce-arg self) delegate)))
(define (nstextview-set-delegate! self value)
  (tell #:type _void (coerce-arg self) setDelegate: (coerce-arg value)))
(define (nstextview-displays-link-tool-tips self)
  (tell #:type _bool (coerce-arg self) displaysLinkToolTips))
(define (nstextview-set-displays-link-tool-tips! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setDisplaysLinkToolTips:") value))
(define (nstextview-drawing-find-indicator self)
  (tell #:type _bool (coerce-arg self) drawingFindIndicator))
(define (nstextview-draws-background self)
  (tell #:type _bool (coerce-arg self) drawsBackground))
(define (nstextview-set-draws-background! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setDrawsBackground:") value))
(define (nstextview-editable self)
  (tell #:type _bool (coerce-arg self) editable))
(define (nstextview-set-editable! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setEditable:") value))
(define (nstextview-enabled-text-checking-types self)
  (tell #:type _uint64 (coerce-arg self) enabledTextCheckingTypes))
(define (nstextview-set-enabled-text-checking-types! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setEnabledTextCheckingTypes:") value))
(define (nstextview-enclosing-menu-item self)
  (wrap-objc-object
   (tell (coerce-arg self) enclosingMenuItem)))
(define (nstextview-enclosing-scroll-view self)
  (wrap-objc-object
   (tell (coerce-arg self) enclosingScrollView)))
(define (nstextview-field-editor self)
  (tell #:type _bool (coerce-arg self) fieldEditor))
(define (nstextview-set-field-editor! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setFieldEditor:") value))
(define (nstextview-first-baseline-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) firstBaselineAnchor)))
(define (nstextview-first-baseline-offset-from-top self)
  (tell #:type _double (coerce-arg self) firstBaselineOffsetFromTop))
(define (nstextview-fitting-size self)
  (tell #:type _NSSize (coerce-arg self) fittingSize))
(define (nstextview-flipped self)
  (tell #:type _bool (coerce-arg self) flipped))
(define (nstextview-focus-ring-mask-bounds self)
  (tell #:type _NSRect (coerce-arg self) focusRingMaskBounds))
(define (nstextview-focus-ring-type self)
  (tell #:type _uint64 (coerce-arg self) focusRingType))
(define (nstextview-set-focus-ring-type! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setFocusRingType:") value))
(define (nstextview-focus-view)
  (wrap-objc-object
   (tell NSTextView focusView)))
(define (nstextview-font self)
  (wrap-objc-object
   (tell (coerce-arg self) font)))
(define (nstextview-set-font! self value)
  (tell #:type _void (coerce-arg self) setFont: (coerce-arg value)))
(define (nstextview-frame self)
  (tell #:type _NSRect (coerce-arg self) frame))
(define (nstextview-set-frame! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setFrame:") value))
(define (nstextview-frame-center-rotation self)
  (tell #:type _double (coerce-arg self) frameCenterRotation))
(define (nstextview-set-frame-center-rotation! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setFrameCenterRotation:") value))
(define (nstextview-frame-rotation self)
  (tell #:type _double (coerce-arg self) frameRotation))
(define (nstextview-set-frame-rotation! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setFrameRotation:") value))
(define (nstextview-gesture-recognizers self)
  (wrap-objc-object
   (tell (coerce-arg self) gestureRecognizers)))
(define (nstextview-set-gesture-recognizers! self value)
  (tell #:type _void (coerce-arg self) setGestureRecognizers: (coerce-arg value)))
(define (nstextview-grammar-checking-enabled self)
  (tell #:type _bool (coerce-arg self) grammarCheckingEnabled))
(define (nstextview-set-grammar-checking-enabled! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setGrammarCheckingEnabled:") value))
(define (nstextview-has-ambiguous-layout self)
  (tell #:type _bool (coerce-arg self) hasAmbiguousLayout))
(define (nstextview-height-adjust-limit self)
  (tell #:type _double (coerce-arg self) heightAdjustLimit))
(define (nstextview-height-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) heightAnchor)))
(define (nstextview-hidden self)
  (tell #:type _bool (coerce-arg self) hidden))
(define (nstextview-set-hidden! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setHidden:") value))
(define (nstextview-hidden-or-has-hidden-ancestor self)
  (tell #:type _bool (coerce-arg self) hiddenOrHasHiddenAncestor))
(define (nstextview-horizontal-content-size-constraint-active self)
  (tell #:type _bool (coerce-arg self) horizontalContentSizeConstraintActive))
(define (nstextview-set-horizontal-content-size-constraint-active! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setHorizontalContentSizeConstraintActive:") value))
(define (nstextview-horizontally-resizable self)
  (tell #:type _bool (coerce-arg self) horizontallyResizable))
(define (nstextview-set-horizontally-resizable! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setHorizontallyResizable:") value))
(define (nstextview-imports-graphics self)
  (tell #:type _bool (coerce-arg self) importsGraphics))
(define (nstextview-set-imports-graphics! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setImportsGraphics:") value))
(define (nstextview-in-full-screen-mode self)
  (tell #:type _bool (coerce-arg self) inFullScreenMode))
(define (nstextview-in-live-resize self)
  (tell #:type _bool (coerce-arg self) inLiveResize))
(define (nstextview-incremental-searching-enabled self)
  (tell #:type _bool (coerce-arg self) incrementalSearchingEnabled))
(define (nstextview-set-incremental-searching-enabled! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setIncrementalSearchingEnabled:") value))
(define (nstextview-inline-prediction-type self)
  (tell #:type _uint64 (coerce-arg self) inlinePredictionType))
(define (nstextview-set-inline-prediction-type! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setInlinePredictionType:") value))
(define (nstextview-input-context self)
  (wrap-objc-object
   (tell (coerce-arg self) inputContext)))
(define (nstextview-insertion-point-color self)
  (wrap-objc-object
   (tell (coerce-arg self) insertionPointColor)))
(define (nstextview-set-insertion-point-color! self value)
  (tell #:type _void (coerce-arg self) setInsertionPointColor: (coerce-arg value)))
(define (nstextview-intrinsic-content-size self)
  (tell #:type _NSSize (coerce-arg self) intrinsicContentSize))
(define (nstextview-last-baseline-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) lastBaselineAnchor)))
(define (nstextview-last-baseline-offset-from-bottom self)
  (tell #:type _double (coerce-arg self) lastBaselineOffsetFromBottom))
(define (nstextview-layer self)
  (wrap-objc-object
   (tell (coerce-arg self) layer)))
(define (nstextview-set-layer! self value)
  (tell #:type _void (coerce-arg self) setLayer: (coerce-arg value)))
(define (nstextview-layer-contents-placement self)
  (tell #:type _uint64 (coerce-arg self) layerContentsPlacement))
(define (nstextview-set-layer-contents-placement! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setLayerContentsPlacement:") value))
(define (nstextview-layer-contents-redraw-policy self)
  (tell #:type _uint64 (coerce-arg self) layerContentsRedrawPolicy))
(define (nstextview-set-layer-contents-redraw-policy! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setLayerContentsRedrawPolicy:") value))
(define (nstextview-layer-uses-core-image-filters self)
  (tell #:type _bool (coerce-arg self) layerUsesCoreImageFilters))
(define (nstextview-set-layer-uses-core-image-filters! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setLayerUsesCoreImageFilters:") value))
(define (nstextview-layout-guides self)
  (wrap-objc-object
   (tell (coerce-arg self) layoutGuides)))
(define (nstextview-layout-manager self)
  (wrap-objc-object
   (tell (coerce-arg self) layoutManager)))
(define (nstextview-layout-margins-guide self)
  (wrap-objc-object
   (tell (coerce-arg self) layoutMarginsGuide)))
(define (nstextview-leading-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) leadingAnchor)))
(define (nstextview-left-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) leftAnchor)))
(define (nstextview-link-text-attributes self)
  (wrap-objc-object
   (tell (coerce-arg self) linkTextAttributes)))
(define (nstextview-set-link-text-attributes! self value)
  (tell #:type _void (coerce-arg self) setLinkTextAttributes: (coerce-arg value)))
(define (nstextview-marked-text-attributes self)
  (wrap-objc-object
   (tell (coerce-arg self) markedTextAttributes)))
(define (nstextview-set-marked-text-attributes! self value)
  (tell #:type _void (coerce-arg self) setMarkedTextAttributes: (coerce-arg value)))
(define (nstextview-math-expression-completion-type self)
  (tell #:type _uint64 (coerce-arg self) mathExpressionCompletionType))
(define (nstextview-set-math-expression-completion-type! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setMathExpressionCompletionType:") value))
(define (nstextview-max-size self)
  (tell #:type _NSSize (coerce-arg self) maxSize))
(define (nstextview-set-max-size! self value)
  (_msg-34 (coerce-arg self) (sel_registerName "setMaxSize:") value))
(define (nstextview-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) menu)))
(define (nstextview-set-menu! self value)
  (tell #:type _void (coerce-arg self) setMenu: (coerce-arg value)))
(define (nstextview-min-size self)
  (tell #:type _NSSize (coerce-arg self) minSize))
(define (nstextview-set-min-size! self value)
  (_msg-34 (coerce-arg self) (sel_registerName "setMinSize:") value))
(define (nstextview-mouse-down-can-move-window self)
  (tell #:type _bool (coerce-arg self) mouseDownCanMoveWindow))
(define (nstextview-needs-display self)
  (tell #:type _bool (coerce-arg self) needsDisplay))
(define (nstextview-set-needs-display! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setNeedsDisplay:") value))
(define (nstextview-needs-layout self)
  (tell #:type _bool (coerce-arg self) needsLayout))
(define (nstextview-set-needs-layout! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setNeedsLayout:") value))
(define (nstextview-needs-panel-to-become-key self)
  (tell #:type _bool (coerce-arg self) needsPanelToBecomeKey))
(define (nstextview-needs-update-constraints self)
  (tell #:type _bool (coerce-arg self) needsUpdateConstraints))
(define (nstextview-set-needs-update-constraints! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setNeedsUpdateConstraints:") value))
(define (nstextview-next-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) nextKeyView)))
(define (nstextview-set-next-key-view! self value)
  (tell #:type _void (coerce-arg self) setNextKeyView: (coerce-arg value)))
(define (nstextview-next-responder self)
  (wrap-objc-object
   (tell (coerce-arg self) nextResponder)))
(define (nstextview-set-next-responder! self value)
  (tell #:type _void (coerce-arg self) setNextResponder: (coerce-arg value)))
(define (nstextview-next-valid-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) nextValidKeyView)))
(define (nstextview-opaque self)
  (tell #:type _bool (coerce-arg self) opaque))
(define (nstextview-opaque-ancestor self)
  (wrap-objc-object
   (tell (coerce-arg self) opaqueAncestor)))
(define (nstextview-page-footer self)
  (wrap-objc-object
   (tell (coerce-arg self) pageFooter)))
(define (nstextview-page-header self)
  (wrap-objc-object
   (tell (coerce-arg self) pageHeader)))
(define (nstextview-posts-bounds-changed-notifications self)
  (tell #:type _bool (coerce-arg self) postsBoundsChangedNotifications))
(define (nstextview-set-posts-bounds-changed-notifications! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setPostsBoundsChangedNotifications:") value))
(define (nstextview-posts-frame-changed-notifications self)
  (tell #:type _bool (coerce-arg self) postsFrameChangedNotifications))
(define (nstextview-set-posts-frame-changed-notifications! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setPostsFrameChangedNotifications:") value))
(define (nstextview-prefers-compact-control-size-metrics self)
  (tell #:type _bool (coerce-arg self) prefersCompactControlSizeMetrics))
(define (nstextview-set-prefers-compact-control-size-metrics! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setPrefersCompactControlSizeMetrics:") value))
(define (nstextview-prepared-content-rect self)
  (tell #:type _NSRect (coerce-arg self) preparedContentRect))
(define (nstextview-set-prepared-content-rect! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setPreparedContentRect:") value))
(define (nstextview-preserves-content-during-live-resize self)
  (tell #:type _bool (coerce-arg self) preservesContentDuringLiveResize))
(define (nstextview-pressure-configuration self)
  (wrap-objc-object
   (tell (coerce-arg self) pressureConfiguration)))
(define (nstextview-set-pressure-configuration! self value)
  (tell #:type _void (coerce-arg self) setPressureConfiguration: (coerce-arg value)))
(define (nstextview-previous-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) previousKeyView)))
(define (nstextview-previous-valid-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) previousValidKeyView)))
(define (nstextview-print-job-title self)
  (wrap-objc-object
   (tell (coerce-arg self) printJobTitle)))
(define (nstextview-range-for-user-character-attribute-change self)
  (tell #:type _NSRange (coerce-arg self) rangeForUserCharacterAttributeChange))
(define (nstextview-range-for-user-completion self)
  (tell #:type _NSRange (coerce-arg self) rangeForUserCompletion))
(define (nstextview-range-for-user-paragraph-attribute-change self)
  (tell #:type _NSRange (coerce-arg self) rangeForUserParagraphAttributeChange))
(define (nstextview-range-for-user-text-change self)
  (tell #:type _NSRange (coerce-arg self) rangeForUserTextChange))
(define (nstextview-ranges-for-user-character-attribute-change self)
  (wrap-objc-object
   (tell (coerce-arg self) rangesForUserCharacterAttributeChange)))
(define (nstextview-ranges-for-user-paragraph-attribute-change self)
  (wrap-objc-object
   (tell (coerce-arg self) rangesForUserParagraphAttributeChange)))
(define (nstextview-ranges-for-user-text-change self)
  (wrap-objc-object
   (tell (coerce-arg self) rangesForUserTextChange)))
(define (nstextview-readable-pasteboard-types self)
  (wrap-objc-object
   (tell (coerce-arg self) readablePasteboardTypes)))
(define (nstextview-rect-preserved-during-live-resize self)
  (tell #:type _NSRect (coerce-arg self) rectPreservedDuringLiveResize))
(define (nstextview-registered-dragged-types self)
  (wrap-objc-object
   (tell (coerce-arg self) registeredDraggedTypes)))
(define (nstextview-requires-constraint-based-layout)
  (tell #:type _bool NSTextView requiresConstraintBasedLayout))
(define (nstextview-restorable-state-key-paths)
  (wrap-objc-object
   (tell NSTextView restorableStateKeyPaths)))
(define (nstextview-rich-text self)
  (tell #:type _bool (coerce-arg self) richText))
(define (nstextview-set-rich-text! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setRichText:") value))
(define (nstextview-right-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) rightAnchor)))
(define (nstextview-rotated-from-base self)
  (tell #:type _bool (coerce-arg self) rotatedFromBase))
(define (nstextview-rotated-or-scaled-from-base self)
  (tell #:type _bool (coerce-arg self) rotatedOrScaledFromBase))
(define (nstextview-ruler-visible self)
  (tell #:type _bool (coerce-arg self) rulerVisible))
(define (nstextview-set-ruler-visible! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setRulerVisible:") value))
(define (nstextview-safe-area-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) safeAreaInsets))
(define (nstextview-safe-area-layout-guide self)
  (wrap-objc-object
   (tell (coerce-arg self) safeAreaLayoutGuide)))
(define (nstextview-safe-area-rect self)
  (tell #:type _NSRect (coerce-arg self) safeAreaRect))
(define (nstextview-selectable self)
  (tell #:type _bool (coerce-arg self) selectable))
(define (nstextview-set-selectable! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setSelectable:") value))
(define (nstextview-selected-range self)
  (tell #:type _NSRange (coerce-arg self) selectedRange))
(define (nstextview-set-selected-range! self value)
  (_msg-17 (coerce-arg self) (sel_registerName "setSelectedRange:") value))
(define (nstextview-selected-ranges self)
  (wrap-objc-object
   (tell (coerce-arg self) selectedRanges)))
(define (nstextview-set-selected-ranges! self value)
  (tell #:type _void (coerce-arg self) setSelectedRanges: (coerce-arg value)))
(define (nstextview-selected-text-attributes self)
  (wrap-objc-object
   (tell (coerce-arg self) selectedTextAttributes)))
(define (nstextview-set-selected-text-attributes! self value)
  (tell #:type _void (coerce-arg self) setSelectedTextAttributes: (coerce-arg value)))
(define (nstextview-selection-affinity self)
  (tell #:type _uint64 (coerce-arg self) selectionAffinity))
(define (nstextview-selection-granularity self)
  (tell #:type _uint64 (coerce-arg self) selectionGranularity))
(define (nstextview-set-selection-granularity! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setSelectionGranularity:") value))
(define (nstextview-shadow self)
  (wrap-objc-object
   (tell (coerce-arg self) shadow)))
(define (nstextview-set-shadow! self value)
  (tell #:type _void (coerce-arg self) setShadow: (coerce-arg value)))
(define (nstextview-should-draw-insertion-point self)
  (tell #:type _bool (coerce-arg self) shouldDrawInsertionPoint))
(define (nstextview-smart-insert-delete-enabled self)
  (tell #:type _bool (coerce-arg self) smartInsertDeleteEnabled))
(define (nstextview-set-smart-insert-delete-enabled! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setSmartInsertDeleteEnabled:") value))
(define (nstextview-spell-checker-document-tag self)
  (tell #:type _int64 (coerce-arg self) spellCheckerDocumentTag))
(define (nstextview-string self)
  (wrap-objc-object
   (tell (coerce-arg self) string)))
(define (nstextview-set-string! self value)
  (tell #:type _void (coerce-arg self) setString: (coerce-arg value)))
(define (nstextview-strongly-references-text-storage)
  (tell #:type _bool NSTextView stronglyReferencesTextStorage))
(define (nstextview-subviews self)
  (wrap-objc-object
   (tell (coerce-arg self) subviews)))
(define (nstextview-set-subviews! self value)
  (tell #:type _void (coerce-arg self) setSubviews: (coerce-arg value)))
(define (nstextview-superview self)
  (wrap-objc-object
   (tell (coerce-arg self) superview)))
(define (nstextview-tag self)
  (tell #:type _int64 (coerce-arg self) tag))
(define (nstextview-text-color self)
  (wrap-objc-object
   (tell (coerce-arg self) textColor)))
(define (nstextview-set-text-color! self value)
  (tell #:type _void (coerce-arg self) setTextColor: (coerce-arg value)))
(define (nstextview-text-container self)
  (wrap-objc-object
   (tell (coerce-arg self) textContainer)))
(define (nstextview-set-text-container! self value)
  (tell #:type _void (coerce-arg self) setTextContainer: (coerce-arg value)))
(define (nstextview-text-container-inset self)
  (tell #:type _NSSize (coerce-arg self) textContainerInset))
(define (nstextview-set-text-container-inset! self value)
  (_msg-34 (coerce-arg self) (sel_registerName "setTextContainerInset:") value))
(define (nstextview-text-container-origin self)
  (tell #:type _NSPoint (coerce-arg self) textContainerOrigin))
(define (nstextview-text-content-storage self)
  (wrap-objc-object
   (tell (coerce-arg self) textContentStorage)))
(define (nstextview-text-highlight-attributes self)
  (wrap-objc-object
   (tell (coerce-arg self) textHighlightAttributes)))
(define (nstextview-set-text-highlight-attributes! self value)
  (tell #:type _void (coerce-arg self) setTextHighlightAttributes: (coerce-arg value)))
(define (nstextview-text-layout-manager self)
  (wrap-objc-object
   (tell (coerce-arg self) textLayoutManager)))
(define (nstextview-text-storage self)
  (wrap-objc-object
   (tell (coerce-arg self) textStorage)))
(define (nstextview-tool-tip self)
  (wrap-objc-object
   (tell (coerce-arg self) toolTip)))
(define (nstextview-set-tool-tip! self value)
  (tell #:type _void (coerce-arg self) setToolTip: (coerce-arg value)))
(define (nstextview-top-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) topAnchor)))
(define (nstextview-touch-bar self)
  (wrap-objc-object
   (tell (coerce-arg self) touchBar)))
(define (nstextview-set-touch-bar! self value)
  (tell #:type _void (coerce-arg self) setTouchBar: (coerce-arg value)))
(define (nstextview-tracking-areas self)
  (wrap-objc-object
   (tell (coerce-arg self) trackingAreas)))
(define (nstextview-trailing-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) trailingAnchor)))
(define (nstextview-translates-autoresizing-mask-into-constraints self)
  (tell #:type _bool (coerce-arg self) translatesAutoresizingMaskIntoConstraints))
(define (nstextview-set-translates-autoresizing-mask-into-constraints! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setTranslatesAutoresizingMaskIntoConstraints:") value))
(define (nstextview-typing-attributes self)
  (wrap-objc-object
   (tell (coerce-arg self) typingAttributes)))
(define (nstextview-set-typing-attributes! self value)
  (tell #:type _void (coerce-arg self) setTypingAttributes: (coerce-arg value)))
(define (nstextview-undo-manager self)
  (wrap-objc-object
   (tell (coerce-arg self) undoManager)))
(define (nstextview-user-activity self)
  (wrap-objc-object
   (tell (coerce-arg self) userActivity)))
(define (nstextview-set-user-activity! self value)
  (tell #:type _void (coerce-arg self) setUserActivity: (coerce-arg value)))
(define (nstextview-user-interface-layout-direction self)
  (tell #:type _uint64 (coerce-arg self) userInterfaceLayoutDirection))
(define (nstextview-set-user-interface-layout-direction! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setUserInterfaceLayoutDirection:") value))
(define (nstextview-uses-adaptive-color-mapping-for-dark-appearance self)
  (tell #:type _bool (coerce-arg self) usesAdaptiveColorMappingForDarkAppearance))
(define (nstextview-set-uses-adaptive-color-mapping-for-dark-appearance! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setUsesAdaptiveColorMappingForDarkAppearance:") value))
(define (nstextview-uses-find-bar self)
  (tell #:type _bool (coerce-arg self) usesFindBar))
(define (nstextview-set-uses-find-bar! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setUsesFindBar:") value))
(define (nstextview-uses-find-panel self)
  (tell #:type _bool (coerce-arg self) usesFindPanel))
(define (nstextview-set-uses-find-panel! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setUsesFindPanel:") value))
(define (nstextview-uses-font-panel self)
  (tell #:type _bool (coerce-arg self) usesFontPanel))
(define (nstextview-set-uses-font-panel! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setUsesFontPanel:") value))
(define (nstextview-uses-inspector-bar self)
  (tell #:type _bool (coerce-arg self) usesInspectorBar))
(define (nstextview-set-uses-inspector-bar! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setUsesInspectorBar:") value))
(define (nstextview-uses-rollover-button-for-selection self)
  (tell #:type _bool (coerce-arg self) usesRolloverButtonForSelection))
(define (nstextview-set-uses-rollover-button-for-selection! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setUsesRolloverButtonForSelection:") value))
(define (nstextview-uses-ruler self)
  (tell #:type _bool (coerce-arg self) usesRuler))
(define (nstextview-set-uses-ruler! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setUsesRuler:") value))
(define (nstextview-vertical-content-size-constraint-active self)
  (tell #:type _bool (coerce-arg self) verticalContentSizeConstraintActive))
(define (nstextview-set-vertical-content-size-constraint-active! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setVerticalContentSizeConstraintActive:") value))
(define (nstextview-vertically-resizable self)
  (tell #:type _bool (coerce-arg self) verticallyResizable))
(define (nstextview-set-vertically-resizable! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setVerticallyResizable:") value))
(define (nstextview-visible-rect self)
  (tell #:type _NSRect (coerce-arg self) visibleRect))
(define (nstextview-wants-best-resolution-open-gl-surface self)
  (tell #:type _bool (coerce-arg self) wantsBestResolutionOpenGLSurface))
(define (nstextview-set-wants-best-resolution-open-gl-surface! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setWantsBestResolutionOpenGLSurface:") value))
(define (nstextview-wants-default-clipping self)
  (tell #:type _bool (coerce-arg self) wantsDefaultClipping))
(define (nstextview-wants-extended-dynamic-range-open-gl-surface self)
  (tell #:type _bool (coerce-arg self) wantsExtendedDynamicRangeOpenGLSurface))
(define (nstextview-set-wants-extended-dynamic-range-open-gl-surface! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setWantsExtendedDynamicRangeOpenGLSurface:") value))
(define (nstextview-wants-layer self)
  (tell #:type _bool (coerce-arg self) wantsLayer))
(define (nstextview-set-wants-layer! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setWantsLayer:") value))
(define (nstextview-wants-resting-touches self)
  (tell #:type _bool (coerce-arg self) wantsRestingTouches))
(define (nstextview-set-wants-resting-touches! self value)
  (_msg-37 (coerce-arg self) (sel_registerName "setWantsRestingTouches:") value))
(define (nstextview-wants-update-layer self)
  (tell #:type _bool (coerce-arg self) wantsUpdateLayer))
(define (nstextview-width-adjust-limit self)
  (tell #:type _double (coerce-arg self) widthAdjustLimit))
(define (nstextview-width-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) widthAnchor)))
(define (nstextview-window self)
  (wrap-objc-object
   (tell (coerce-arg self) window)))
(define (nstextview-writable-pasteboard-types self)
  (wrap-objc-object
   (tell (coerce-arg self) writablePasteboardTypes)))
(define (nstextview-writing-tools-active self)
  (tell #:type _bool (coerce-arg self) writingToolsActive))
(define (nstextview-writing-tools-behavior self)
  (tell #:type _uint64 (coerce-arg self) writingToolsBehavior))
(define (nstextview-set-writing-tools-behavior! self value)
  (_msg-53 (coerce-arg self) (sel_registerName "setWritingToolsBehavior:") value))
(define (nstextview-writing-tools-coordinator self)
  (wrap-objc-object
   (tell (coerce-arg self) writingToolsCoordinator)))
(define (nstextview-set-writing-tools-coordinator! self value)
  (tell #:type _void (coerce-arg self) setWritingToolsCoordinator: (coerce-arg value)))

;; --- Instance methods ---
(define (nstextview-rtfd-from-range self range)
  (wrap-objc-object
   (_msg-16 (coerce-arg self) (sel_registerName "RTFDFromRange:") range)
   ))
(define (nstextview-rtf-from-range self range)
  (wrap-objc-object
   (_msg-16 (coerce-arg self) (sel_registerName "RTFFromRange:") range)
   ))
(define (nstextview-accepts-first-mouse self event)
  (_msg-39 (coerce-arg self) (sel_registerName "acceptsFirstMouse:") (coerce-arg event)))
(define (nstextview-add-subview! self view)
  (tell #:type _void (coerce-arg self) addSubview: (coerce-arg view)))
(define (nstextview-add-subview-positioned-relative-to! self view place other-view)
  (_msg-45 (coerce-arg self) (sel_registerName "addSubview:positioned:relativeTo:") (coerce-arg view) place (coerce-arg other-view)))
(define (nstextview-add-tool-tip-rect-owner-user-data! self rect owner data)
  (_msg-31 (coerce-arg self) (sel_registerName "addToolTipRect:owner:userData:") rect (coerce-arg owner) data))
(define (nstextview-adjust-scroll self new-visible)
  (_msg-21 (coerce-arg self) (sel_registerName "adjustScroll:") new-visible))
(define (nstextview-align-center self sender)
  (tell #:type _void (coerce-arg self) alignCenter: (coerce-arg sender)))
(define (nstextview-align-justified self sender)
  (tell #:type _void (coerce-arg self) alignJustified: (coerce-arg sender)))
(define (nstextview-align-left self sender)
  (tell #:type _void (coerce-arg self) alignLeft: (coerce-arg sender)))
(define (nstextview-align-right self sender)
  (tell #:type _void (coerce-arg self) alignRight: (coerce-arg sender)))
(define (nstextview-ancestor-shared-with-view self view)
  (wrap-objc-object
   (tell (coerce-arg self) ancestorSharedWithView: (coerce-arg view))))
(define (nstextview-autoscroll self event)
  (_msg-39 (coerce-arg self) (sel_registerName "autoscroll:") (coerce-arg event)))
(define (nstextview-backing-aligned-rect-options self rect options)
  (_msg-32 (coerce-arg self) (sel_registerName "backingAlignedRect:options:") rect options))
(define (nstextview-become-first-responder self)
  (_msg-4 (coerce-arg self) (sel_registerName "becomeFirstResponder")))
(define (nstextview-begin-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) beginGestureWithEvent: (coerce-arg event)))
(define (nstextview-bitmap-image-rep-for-caching-display-in-rect self rect)
  (wrap-objc-object
   (_msg-23 (coerce-arg self) (sel_registerName "bitmapImageRepForCachingDisplayInRect:") rect)
   ))
(define (nstextview-cache-display-in-rect-to-bitmap-image-rep self rect bitmap-image-rep)
  (_msg-29 (coerce-arg self) (sel_registerName "cacheDisplayInRect:toBitmapImageRep:") rect (coerce-arg bitmap-image-rep)))
(define (nstextview-center-scan-rect! self rect)
  (_msg-21 (coerce-arg self) (sel_registerName "centerScanRect:") rect))
(define (nstextview-change-attributes self sender)
  (tell #:type _void (coerce-arg self) changeAttributes: (coerce-arg sender)))
(define (nstextview-change-color self sender)
  (tell #:type _void (coerce-arg self) changeColor: (coerce-arg sender)))
(define (nstextview-change-document-background-color self sender)
  (tell #:type _void (coerce-arg self) changeDocumentBackgroundColor: (coerce-arg sender)))
(define (nstextview-change-font self sender)
  (tell #:type _void (coerce-arg self) changeFont: (coerce-arg sender)))
(define (nstextview-change-layout-orientation self sender)
  (tell #:type _void (coerce-arg self) changeLayoutOrientation: (coerce-arg sender)))
(define (nstextview-change-mode-with-event self event)
  (tell #:type _void (coerce-arg self) changeModeWithEvent: (coerce-arg event)))
(define (nstextview-character-index-for-insertion-at-point self point)
  (_msg-11 (coerce-arg self) (sel_registerName "characterIndexForInsertionAtPoint:") point))
(define (nstextview-check-spelling self sender)
  (tell #:type _void (coerce-arg self) checkSpelling: (coerce-arg sender)))
(define (nstextview-clicked-on-link-at-index self link char-index)
  (_msg-44 (coerce-arg self) (sel_registerName "clickedOnLink:atIndex:") (coerce-arg link) char-index))
(define (nstextview-context-menu-key-down self event)
  (tell #:type _void (coerce-arg self) contextMenuKeyDown: (coerce-arg event)))
(define (nstextview-convert-point-from-view self point view)
  (_msg-15 (coerce-arg self) (sel_registerName "convertPoint:fromView:") point (coerce-arg view)))
(define (nstextview-convert-point-to-view self point view)
  (_msg-15 (coerce-arg self) (sel_registerName "convertPoint:toView:") point (coerce-arg view)))
(define (nstextview-convert-point-from-backing self point)
  (_msg-9 (coerce-arg self) (sel_registerName "convertPointFromBacking:") point))
(define (nstextview-convert-point-from-layer self point)
  (_msg-9 (coerce-arg self) (sel_registerName "convertPointFromLayer:") point))
(define (nstextview-convert-point-to-backing self point)
  (_msg-9 (coerce-arg self) (sel_registerName "convertPointToBacking:") point))
(define (nstextview-convert-point-to-layer self point)
  (_msg-9 (coerce-arg self) (sel_registerName "convertPointToLayer:") point))
(define (nstextview-convert-rect-from-view self rect view)
  (_msg-27 (coerce-arg self) (sel_registerName "convertRect:fromView:") rect (coerce-arg view)))
(define (nstextview-convert-rect-to-view self rect view)
  (_msg-27 (coerce-arg self) (sel_registerName "convertRect:toView:") rect (coerce-arg view)))
(define (nstextview-convert-rect-from-backing self rect)
  (_msg-21 (coerce-arg self) (sel_registerName "convertRectFromBacking:") rect))
(define (nstextview-convert-rect-from-layer self rect)
  (_msg-21 (coerce-arg self) (sel_registerName "convertRectFromLayer:") rect))
(define (nstextview-convert-rect-to-backing self rect)
  (_msg-21 (coerce-arg self) (sel_registerName "convertRectToBacking:") rect))
(define (nstextview-convert-rect-to-layer self rect)
  (_msg-21 (coerce-arg self) (sel_registerName "convertRectToLayer:") rect))
(define (nstextview-convert-size-from-view self size view)
  (_msg-35 (coerce-arg self) (sel_registerName "convertSize:fromView:") size (coerce-arg view)))
(define (nstextview-convert-size-to-view self size view)
  (_msg-35 (coerce-arg self) (sel_registerName "convertSize:toView:") size (coerce-arg view)))
(define (nstextview-convert-size-from-backing self size)
  (_msg-33 (coerce-arg self) (sel_registerName "convertSizeFromBacking:") size))
(define (nstextview-convert-size-from-layer self size)
  (_msg-33 (coerce-arg self) (sel_registerName "convertSizeFromLayer:") size))
(define (nstextview-convert-size-to-backing self size)
  (_msg-33 (coerce-arg self) (sel_registerName "convertSizeToBacking:") size))
(define (nstextview-convert-size-to-layer self size)
  (_msg-33 (coerce-arg self) (sel_registerName "convertSizeToLayer:") size))
(define (nstextview-copy self sender)
  (tell #:type _void (coerce-arg self) copy: (coerce-arg sender)))
(define (nstextview-copy-font self sender)
  (tell #:type _void (coerce-arg self) copyFont: (coerce-arg sender)))
(define (nstextview-copy-ruler self sender)
  (tell #:type _void (coerce-arg self) copyRuler: (coerce-arg sender)))
(define (nstextview-cursor-update self event)
  (tell #:type _void (coerce-arg self) cursorUpdate: (coerce-arg event)))
(define (nstextview-cut self sender)
  (tell #:type _void (coerce-arg self) cut: (coerce-arg sender)))
(define (nstextview-delete self sender)
  (tell #:type _void (coerce-arg self) delete: (coerce-arg sender)))
(define (nstextview-did-add-subview self subview)
  (tell #:type _void (coerce-arg self) didAddSubview: (coerce-arg subview)))
(define (nstextview-did-close-menu-with-event self menu event)
  (tell #:type _void (coerce-arg self) didCloseMenu: (coerce-arg menu) withEvent: (coerce-arg event)))
(define (nstextview-display! self)
  (tell #:type _void (coerce-arg self) display))
(define (nstextview-display-if-needed! self)
  (tell #:type _void (coerce-arg self) displayIfNeeded))
(define (nstextview-display-if-needed-ignoring-opacity! self)
  (tell #:type _void (coerce-arg self) displayIfNeededIgnoringOpacity))
(define (nstextview-display-if-needed-in-rect! self rect)
  (_msg-24 (coerce-arg self) (sel_registerName "displayIfNeededInRect:") rect))
(define (nstextview-display-if-needed-in-rect-ignoring-opacity! self rect)
  (_msg-24 (coerce-arg self) (sel_registerName "displayIfNeededInRectIgnoringOpacity:") rect))
(define (nstextview-display-rect! self rect)
  (_msg-24 (coerce-arg self) (sel_registerName "displayRect:") rect))
(define (nstextview-display-rect-ignoring-opacity! self rect)
  (_msg-24 (coerce-arg self) (sel_registerName "displayRectIgnoringOpacity:") rect))
(define (nstextview-display-rect-ignoring-opacity-in-context! self rect context)
  (_msg-29 (coerce-arg self) (sel_registerName "displayRectIgnoringOpacity:inContext:") rect (coerce-arg context)))
(define (nstextview-draw-insertion-point-in-rect-color-turned-on self rect color flag)
  (_msg-30 (coerce-arg self) (sel_registerName "drawInsertionPointInRect:color:turnedOn:") rect (coerce-arg color) flag))
(define (nstextview-draw-rect self dirty-rect)
  (_msg-24 (coerce-arg self) (sel_registerName "drawRect:") dirty-rect))
(define (nstextview-draw-view-background-in-rect self rect)
  (_msg-24 (coerce-arg self) (sel_registerName "drawViewBackgroundInRect:") rect))
(define (nstextview-end-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) endGestureWithEvent: (coerce-arg event)))
(define (nstextview-flags-changed self event)
  (tell #:type _void (coerce-arg self) flagsChanged: (coerce-arg event)))
(define (nstextview-flush-buffered-key-events self)
  (tell #:type _void (coerce-arg self) flushBufferedKeyEvents))
(define (nstextview-get-rects-being-drawn-count self rects count)
  (_msg-51 (coerce-arg self) (sel_registerName "getRectsBeingDrawn:count:") rects count))
(define (nstextview-get-rects-exposed-during-live-resize-count self exposed-rects count)
  (_msg-51 (coerce-arg self) (sel_registerName "getRectsExposedDuringLiveResize:count:") exposed-rects count))
(define (nstextview-help-requested self event-ptr)
  (tell #:type _void (coerce-arg self) helpRequested: (coerce-arg event-ptr)))
(define (nstextview-hit-test self point)
  (wrap-objc-object
   (_msg-10 (coerce-arg self) (sel_registerName "hitTest:") point)
   ))
(define (nstextview-init-using-text-layout-manager self using-text-layout-manager)
  (wrap-objc-object
   (_msg-36 (coerce-arg self) (sel_registerName "initUsingTextLayoutManager:") using-text-layout-manager)
   #:retained #t))
(define (nstextview-interpret-key-events self event-array)
  (tell #:type _void (coerce-arg self) interpretKeyEvents: (coerce-arg event-array)))
(define (nstextview-invalidate-text-container-origin self)
  (tell #:type _void (coerce-arg self) invalidateTextContainerOrigin))
(define (nstextview-is-descendant-of self view)
  (_msg-39 (coerce-arg self) (sel_registerName "isDescendantOf:") (coerce-arg view)))
(define (nstextview-is-editable self)
  (_msg-4 (coerce-arg self) (sel_registerName "isEditable")))
(define (nstextview-is-field-editor self)
  (_msg-4 (coerce-arg self) (sel_registerName "isFieldEditor")))
(define (nstextview-is-flipped self)
  (_msg-4 (coerce-arg self) (sel_registerName "isFlipped")))
(define (nstextview-is-hidden self)
  (_msg-4 (coerce-arg self) (sel_registerName "isHidden")))
(define (nstextview-is-hidden-or-has-hidden-ancestor self)
  (_msg-4 (coerce-arg self) (sel_registerName "isHiddenOrHasHiddenAncestor")))
(define (nstextview-is-horizontally-resizable self)
  (_msg-4 (coerce-arg self) (sel_registerName "isHorizontallyResizable")))
(define (nstextview-is-opaque self)
  (_msg-4 (coerce-arg self) (sel_registerName "isOpaque")))
(define (nstextview-is-rich-text self)
  (_msg-4 (coerce-arg self) (sel_registerName "isRichText")))
(define (nstextview-is-rotated-from-base self)
  (_msg-4 (coerce-arg self) (sel_registerName "isRotatedFromBase")))
(define (nstextview-is-rotated-or-scaled-from-base self)
  (_msg-4 (coerce-arg self) (sel_registerName "isRotatedOrScaledFromBase")))
(define (nstextview-is-ruler-visible self)
  (_msg-4 (coerce-arg self) (sel_registerName "isRulerVisible")))
(define (nstextview-is-selectable self)
  (_msg-4 (coerce-arg self) (sel_registerName "isSelectable")))
(define (nstextview-is-vertically-resizable self)
  (_msg-4 (coerce-arg self) (sel_registerName "isVerticallyResizable")))
(define (nstextview-key-down self event)
  (tell #:type _void (coerce-arg self) keyDown: (coerce-arg event)))
(define (nstextview-key-up self event)
  (tell #:type _void (coerce-arg self) keyUp: (coerce-arg event)))
(define (nstextview-layout self)
  (tell #:type _void (coerce-arg self) layout))
(define (nstextview-layout-subtree-if-needed self)
  (tell #:type _void (coerce-arg self) layoutSubtreeIfNeeded))
(define (nstextview-loosen-kerning self sender)
  (tell #:type _void (coerce-arg self) loosenKerning: (coerce-arg sender)))
(define (nstextview-lower-baseline self sender)
  (tell #:type _void (coerce-arg self) lowerBaseline: (coerce-arg sender)))
(define (nstextview-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) magnifyWithEvent: (coerce-arg event)))
(define (nstextview-make-backing-layer self)
  (wrap-objc-object
   (tell (coerce-arg self) makeBackingLayer)))
(define (nstextview-menu-for-event self event)
  (wrap-objc-object
   (tell (coerce-arg self) menuForEvent: (coerce-arg event))))
(define (nstextview-mouse-in-rect self point rect)
  (_msg-14 (coerce-arg self) (sel_registerName "mouse:inRect:") point rect))
(define (nstextview-mouse-cancelled self event)
  (tell #:type _void (coerce-arg self) mouseCancelled: (coerce-arg event)))
(define (nstextview-mouse-down self event)
  (tell #:type _void (coerce-arg self) mouseDown: (coerce-arg event)))
(define (nstextview-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) mouseDragged: (coerce-arg event)))
(define (nstextview-mouse-entered self event)
  (tell #:type _void (coerce-arg self) mouseEntered: (coerce-arg event)))
(define (nstextview-mouse-exited self event)
  (tell #:type _void (coerce-arg self) mouseExited: (coerce-arg event)))
(define (nstextview-mouse-moved self event)
  (tell #:type _void (coerce-arg self) mouseMoved: (coerce-arg event)))
(define (nstextview-mouse-up self event)
  (tell #:type _void (coerce-arg self) mouseUp: (coerce-arg event)))
(define (nstextview-needs-to-draw-rect self rect)
  (_msg-22 (coerce-arg self) (sel_registerName "needsToDrawRect:") rect))
(define (nstextview-no-responder-for self event-selector)
  (_msg-48 (coerce-arg self) (sel_registerName "noResponderFor:") event-selector))
(define (nstextview-order-front-link-panel! self sender)
  (tell #:type _void (coerce-arg self) orderFrontLinkPanel: (coerce-arg sender)))
(define (nstextview-order-front-list-panel! self sender)
  (tell #:type _void (coerce-arg self) orderFrontListPanel: (coerce-arg sender)))
(define (nstextview-order-front-spacing-panel! self sender)
  (tell #:type _void (coerce-arg self) orderFrontSpacingPanel: (coerce-arg sender)))
(define (nstextview-order-front-table-panel! self sender)
  (tell #:type _void (coerce-arg self) orderFrontTablePanel: (coerce-arg sender)))
(define (nstextview-other-mouse-down self event)
  (tell #:type _void (coerce-arg self) otherMouseDown: (coerce-arg event)))
(define (nstextview-other-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) otherMouseDragged: (coerce-arg event)))
(define (nstextview-other-mouse-up self event)
  (tell #:type _void (coerce-arg self) otherMouseUp: (coerce-arg event)))
(define (nstextview-outline self sender)
  (tell #:type _void (coerce-arg self) outline: (coerce-arg sender)))
(define (nstextview-paste self sender)
  (tell #:type _void (coerce-arg self) paste: (coerce-arg sender)))
(define (nstextview-paste-font self sender)
  (tell #:type _void (coerce-arg self) pasteFont: (coerce-arg sender)))
(define (nstextview-paste-ruler self sender)
  (tell #:type _void (coerce-arg self) pasteRuler: (coerce-arg sender)))
(define (nstextview-perform-find-panel-action! self sender)
  (tell #:type _void (coerce-arg self) performFindPanelAction: (coerce-arg sender)))
(define (nstextview-perform-key-equivalent! self event)
  (_msg-39 (coerce-arg self) (sel_registerName "performKeyEquivalent:") (coerce-arg event)))
(define (nstextview-perform-validated-replacement-in-range-with-attributed-string! self range attributed-string)
  (_msg-18 (coerce-arg self) (sel_registerName "performValidatedReplacementInRange:withAttributedString:") range (coerce-arg attributed-string)))
(define (nstextview-prepare-content-in-rect self rect)
  (_msg-24 (coerce-arg self) (sel_registerName "prepareContentInRect:") rect))
(define (nstextview-prepare-for-reuse self)
  (tell #:type _void (coerce-arg self) prepareForReuse))
(define (nstextview-pressure-change-with-event self event)
  (tell #:type _void (coerce-arg self) pressureChangeWithEvent: (coerce-arg event)))
(define (nstextview-quick-look-with-event self event)
  (tell #:type _void (coerce-arg self) quickLookWithEvent: (coerce-arg event)))
(define (nstextview-raise-baseline self sender)
  (tell #:type _void (coerce-arg self) raiseBaseline: (coerce-arg sender)))
(define (nstextview-read-rtfd-from-file self path)
  (_msg-39 (coerce-arg self) (sel_registerName "readRTFDFromFile:") (coerce-arg path)))
(define (nstextview-rect-for-smart-magnification-at-point-in-rect self location visible-rect)
  (_msg-13 (coerce-arg self) (sel_registerName "rectForSmartMagnificationAtPoint:inRect:") location visible-rect))
(define (nstextview-remove-all-tool-tips! self)
  (tell #:type _void (coerce-arg self) removeAllToolTips))
(define (nstextview-remove-from-superview! self)
  (tell #:type _void (coerce-arg self) removeFromSuperview))
(define (nstextview-remove-from-superview-without-needing-display! self)
  (tell #:type _void (coerce-arg self) removeFromSuperviewWithoutNeedingDisplay))
(define (nstextview-remove-tool-tip! self tag)
  (_msg-47 (coerce-arg self) (sel_registerName "removeToolTip:") tag))
(define (nstextview-replace-characters-in-range-with-rtf! self range rtf-data)
  (_msg-19 (coerce-arg self) (sel_registerName "replaceCharactersInRange:withRTF:") range (coerce-arg rtf-data)))
(define (nstextview-replace-characters-in-range-with-rtfd! self range rtfd-data)
  (_msg-19 (coerce-arg self) (sel_registerName "replaceCharactersInRange:withRTFD:") range (coerce-arg rtfd-data)))
(define (nstextview-replace-characters-in-range-with-string! self range string)
  (_msg-19 (coerce-arg self) (sel_registerName "replaceCharactersInRange:withString:") range (coerce-arg string)))
(define (nstextview-replace-subview-with! self old-view new-view)
  (tell #:type _void (coerce-arg self) replaceSubview: (coerce-arg old-view) with: (coerce-arg new-view)))
(define (nstextview-replace-text-container! self new-container)
  (tell #:type _void (coerce-arg self) replaceTextContainer: (coerce-arg new-container)))
(define (nstextview-resign-first-responder self)
  (_msg-4 (coerce-arg self) (sel_registerName "resignFirstResponder")))
(define (nstextview-resize-subviews-with-old-size self old-size)
  (_msg-34 (coerce-arg self) (sel_registerName "resizeSubviewsWithOldSize:") old-size))
(define (nstextview-resize-with-old-superview-size self old-size)
  (_msg-34 (coerce-arg self) (sel_registerName "resizeWithOldSuperviewSize:") old-size))
(define (nstextview-right-mouse-down self event)
  (tell #:type _void (coerce-arg self) rightMouseDown: (coerce-arg event)))
(define (nstextview-right-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) rightMouseDragged: (coerce-arg event)))
(define (nstextview-right-mouse-up self event)
  (tell #:type _void (coerce-arg self) rightMouseUp: (coerce-arg event)))
(define (nstextview-rotate-by-angle self angle)
  (_msg-38 (coerce-arg self) (sel_registerName "rotateByAngle:") angle))
(define (nstextview-rotate-with-event self event)
  (tell #:type _void (coerce-arg self) rotateWithEvent: (coerce-arg event)))
(define (nstextview-ruler-view-did-add-marker self ruler marker)
  (tell #:type _void (coerce-arg self) rulerView: (coerce-arg ruler) didAddMarker: (coerce-arg marker)))
(define (nstextview-ruler-view-did-move-marker self ruler marker)
  (tell #:type _void (coerce-arg self) rulerView: (coerce-arg ruler) didMoveMarker: (coerce-arg marker)))
(define (nstextview-ruler-view-did-remove-marker self ruler marker)
  (tell #:type _void (coerce-arg self) rulerView: (coerce-arg ruler) didRemoveMarker: (coerce-arg marker)))
(define (nstextview-ruler-view-handle-mouse-down self ruler event)
  (tell #:type _void (coerce-arg self) rulerView: (coerce-arg ruler) handleMouseDown: (coerce-arg event)))
(define (nstextview-ruler-view-should-add-marker self ruler marker)
  (_msg-42 (coerce-arg self) (sel_registerName "rulerView:shouldAddMarker:") (coerce-arg ruler) (coerce-arg marker)))
(define (nstextview-ruler-view-should-move-marker self ruler marker)
  (_msg-42 (coerce-arg self) (sel_registerName "rulerView:shouldMoveMarker:") (coerce-arg ruler) (coerce-arg marker)))
(define (nstextview-ruler-view-should-remove-marker self ruler marker)
  (_msg-42 (coerce-arg self) (sel_registerName "rulerView:shouldRemoveMarker:") (coerce-arg ruler) (coerce-arg marker)))
(define (nstextview-ruler-view-will-add-marker-at-location self ruler marker location)
  (_msg-43 (coerce-arg self) (sel_registerName "rulerView:willAddMarker:atLocation:") (coerce-arg ruler) (coerce-arg marker) location))
(define (nstextview-ruler-view-will-move-marker-to-location self ruler marker location)
  (_msg-43 (coerce-arg self) (sel_registerName "rulerView:willMoveMarker:toLocation:") (coerce-arg ruler) (coerce-arg marker) location))
(define (nstextview-scale-unit-square-to-size self new-unit-size)
  (_msg-34 (coerce-arg self) (sel_registerName "scaleUnitSquareToSize:") new-unit-size))
(define (nstextview-scroll-point self point)
  (_msg-12 (coerce-arg self) (sel_registerName "scrollPoint:") point))
(define (nstextview-scroll-range-to-visible self range)
  (_msg-17 (coerce-arg self) (sel_registerName "scrollRangeToVisible:") range))
(define (nstextview-scroll-rect-to-visible self rect)
  (_msg-22 (coerce-arg self) (sel_registerName "scrollRectToVisible:") rect))
(define (nstextview-scroll-wheel self event)
  (tell #:type _void (coerce-arg self) scrollWheel: (coerce-arg event)))
(define (nstextview-select-all self sender)
  (tell #:type _void (coerce-arg self) selectAll: (coerce-arg sender)))
(define (nstextview-selection-range-for-proposed-range-granularity self proposed-char-range granularity)
  (_msg-20 (coerce-arg self) (sel_registerName "selectionRangeForProposedRange:granularity:") proposed-char-range granularity))
(define (nstextview-set-alignment-range! self alignment range)
  (_msg-54 (coerce-arg self) (sel_registerName "setAlignment:range:") alignment range))
(define (nstextview-set-base-writing-direction-range! self writing-direction range)
  (_msg-54 (coerce-arg self) (sel_registerName "setBaseWritingDirection:range:") writing-direction range))
(define (nstextview-set-bounds-origin! self new-origin)
  (_msg-12 (coerce-arg self) (sel_registerName "setBoundsOrigin:") new-origin))
(define (nstextview-set-bounds-size! self new-size)
  (_msg-34 (coerce-arg self) (sel_registerName "setBoundsSize:") new-size))
(define (nstextview-set-constrained-frame-size! self desired-size)
  (_msg-34 (coerce-arg self) (sel_registerName "setConstrainedFrameSize:") desired-size))
(define (nstextview-set-font-range! self font range)
  (_msg-40 (coerce-arg self) (sel_registerName "setFont:range:") (coerce-arg font) range))
(define (nstextview-set-frame-origin! self new-origin)
  (_msg-12 (coerce-arg self) (sel_registerName "setFrameOrigin:") new-origin))
(define (nstextview-set-frame-size! self new-size)
  (_msg-34 (coerce-arg self) (sel_registerName "setFrameSize:") new-size))
(define (nstextview-set-layout-orientation! self orientation)
  (_msg-53 (coerce-arg self) (sel_registerName "setLayoutOrientation:") orientation))
(define (nstextview-set-needs-display-in-rect! self invalid-rect)
  (_msg-24 (coerce-arg self) (sel_registerName "setNeedsDisplayInRect:") invalid-rect))
(define (nstextview-set-needs-display-in-rect-avoid-additional-layout! self rect flag)
  (_msg-26 (coerce-arg self) (sel_registerName "setNeedsDisplayInRect:avoidAdditionalLayout:") rect flag))
(define (nstextview-set-text-color-range! self color range)
  (_msg-40 (coerce-arg self) (sel_registerName "setTextColor:range:") (coerce-arg color) range))
(define (nstextview-should-be-treated-as-ink-event self event)
  (_msg-39 (coerce-arg self) (sel_registerName "shouldBeTreatedAsInkEvent:") (coerce-arg event)))
(define (nstextview-should-delay-window-ordering-for-event self event)
  (_msg-39 (coerce-arg self) (sel_registerName "shouldDelayWindowOrderingForEvent:") (coerce-arg event)))
(define (nstextview-show-context-help self sender)
  (tell #:type _void (coerce-arg self) showContextHelp: (coerce-arg sender)))
(define (nstextview-show-guess-panel self sender)
  (tell #:type _void (coerce-arg self) showGuessPanel: (coerce-arg sender)))
(define (nstextview-size-to-fit self)
  (tell #:type _void (coerce-arg self) sizeToFit))
(define (nstextview-smart-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) smartMagnifyWithEvent: (coerce-arg event)))
(define (nstextview-sort-subviews-using-function-context self compare context)
  (_msg-51 (coerce-arg self) (sel_registerName "sortSubviewsUsingFunction:context:") compare context))
(define (nstextview-start-speaking self sender)
  (tell #:type _void (coerce-arg self) startSpeaking: (coerce-arg sender)))
(define (nstextview-stop-speaking self sender)
  (tell #:type _void (coerce-arg self) stopSpeaking: (coerce-arg sender)))
(define (nstextview-subscript self sender)
  (tell #:type _void (coerce-arg self) subscript: (coerce-arg sender)))
(define (nstextview-superscript self sender)
  (tell #:type _void (coerce-arg self) superscript: (coerce-arg sender)))
(define (nstextview-supplemental-target-for-action-sender self action sender)
  (wrap-objc-object
   (_msg-50 (coerce-arg self) (sel_registerName "supplementalTargetForAction:sender:") action (coerce-arg sender))
   ))
(define (nstextview-swipe-with-event self event)
  (tell #:type _void (coerce-arg self) swipeWithEvent: (coerce-arg event)))
(define (nstextview-tablet-point self event)
  (tell #:type _void (coerce-arg self) tabletPoint: (coerce-arg event)))
(define (nstextview-tablet-proximity self event)
  (tell #:type _void (coerce-arg self) tabletProximity: (coerce-arg event)))
(define (nstextview-tighten-kerning self sender)
  (tell #:type _void (coerce-arg self) tightenKerning: (coerce-arg sender)))
(define (nstextview-toggle-ruler! self sender)
  (tell #:type _void (coerce-arg self) toggleRuler: (coerce-arg sender)))
(define (nstextview-touches-began-with-event self event)
  (tell #:type _void (coerce-arg self) touchesBeganWithEvent: (coerce-arg event)))
(define (nstextview-touches-cancelled-with-event self event)
  (tell #:type _void (coerce-arg self) touchesCancelledWithEvent: (coerce-arg event)))
(define (nstextview-touches-ended-with-event self event)
  (tell #:type _void (coerce-arg self) touchesEndedWithEvent: (coerce-arg event)))
(define (nstextview-touches-moved-with-event self event)
  (tell #:type _void (coerce-arg self) touchesMovedWithEvent: (coerce-arg event)))
(define (nstextview-translate-origin-to-point self translation)
  (_msg-12 (coerce-arg self) (sel_registerName "translateOriginToPoint:") translation))
(define (nstextview-translate-rects-needing-display-in-rect-by self clip-rect delta)
  (_msg-25 (coerce-arg self) (sel_registerName "translateRectsNeedingDisplayInRect:by:") clip-rect delta))
(define (nstextview-try-to-perform-with self action object)
  (_msg-49 (coerce-arg self) (sel_registerName "tryToPerform:with:") action (coerce-arg object)))
(define (nstextview-turn-off-kerning self sender)
  (tell #:type _void (coerce-arg self) turnOffKerning: (coerce-arg sender)))
(define (nstextview-turn-off-ligatures self sender)
  (tell #:type _void (coerce-arg self) turnOffLigatures: (coerce-arg sender)))
(define (nstextview-underline self sender)
  (tell #:type _void (coerce-arg self) underline: (coerce-arg sender)))
(define (nstextview-unscript self sender)
  (tell #:type _void (coerce-arg self) unscript: (coerce-arg sender)))
(define (nstextview-update-drag-type-registration self)
  (tell #:type _void (coerce-arg self) updateDragTypeRegistration))
(define (nstextview-update-font-panel self)
  (tell #:type _void (coerce-arg self) updateFontPanel))
(define (nstextview-update-layer self)
  (tell #:type _void (coerce-arg self) updateLayer))
(define (nstextview-update-ruler self)
  (tell #:type _void (coerce-arg self) updateRuler))
(define (nstextview-use-all-ligatures self sender)
  (tell #:type _void (coerce-arg self) useAllLigatures: (coerce-arg sender)))
(define (nstextview-use-standard-kerning self sender)
  (tell #:type _void (coerce-arg self) useStandardKerning: (coerce-arg sender)))
(define (nstextview-use-standard-ligatures self sender)
  (tell #:type _void (coerce-arg self) useStandardLigatures: (coerce-arg sender)))
(define (nstextview-valid-requestor-for-send-type-return-type self send-type return-type)
  (wrap-objc-object
   (tell (coerce-arg self) validRequestorForSendType: (coerce-arg send-type) returnType: (coerce-arg return-type))))
(define (nstextview-view-did-change-backing-properties self)
  (tell #:type _void (coerce-arg self) viewDidChangeBackingProperties))
(define (nstextview-view-did-change-effective-appearance self)
  (tell #:type _void (coerce-arg self) viewDidChangeEffectiveAppearance))
(define (nstextview-view-did-end-live-resize self)
  (tell #:type _void (coerce-arg self) viewDidEndLiveResize))
(define (nstextview-view-did-hide self)
  (tell #:type _void (coerce-arg self) viewDidHide))
(define (nstextview-view-did-move-to-superview self)
  (tell #:type _void (coerce-arg self) viewDidMoveToSuperview))
(define (nstextview-view-did-move-to-window self)
  (tell #:type _void (coerce-arg self) viewDidMoveToWindow))
(define (nstextview-view-did-unhide self)
  (tell #:type _void (coerce-arg self) viewDidUnhide))
(define (nstextview-view-will-draw self)
  (tell #:type _void (coerce-arg self) viewWillDraw))
(define (nstextview-view-will-move-to-superview self new-superview)
  (tell #:type _void (coerce-arg self) viewWillMoveToSuperview: (coerce-arg new-superview)))
(define (nstextview-view-will-move-to-window self new-window)
  (tell #:type _void (coerce-arg self) viewWillMoveToWindow: (coerce-arg new-window)))
(define (nstextview-view-will-start-live-resize self)
  (tell #:type _void (coerce-arg self) viewWillStartLiveResize))
(define (nstextview-view-with-tag self tag)
  (wrap-objc-object
   (_msg-46 (coerce-arg self) (sel_registerName "viewWithTag:") tag)
   ))
(define (nstextview-wants-forwarded-scroll-events-for-axis self axis)
  (_msg-52 (coerce-arg self) (sel_registerName "wantsForwardedScrollEventsForAxis:") axis))
(define (nstextview-wants-scroll-events-for-swipe-tracking-on-axis self axis)
  (_msg-52 (coerce-arg self) (sel_registerName "wantsScrollEventsForSwipeTrackingOnAxis:") axis))
(define (nstextview-will-open-menu-with-event self menu event)
  (tell #:type _void (coerce-arg self) willOpenMenu: (coerce-arg menu) withEvent: (coerce-arg event)))
(define (nstextview-will-remove-subview self subview)
  (tell #:type _void (coerce-arg self) willRemoveSubview: (coerce-arg subview)))
(define (nstextview-write-rtfd-to-file-atomically self path flag)
  (_msg-41 (coerce-arg self) (sel_registerName "writeRTFDToFile:atomically:") (coerce-arg path) flag))

;; --- Class methods ---
(define (nstextview-is-compatible-with-responsive-scrolling)
  (_msg-4 NSTextView (sel_registerName "isCompatibleWithResponsiveScrolling")))
(define (nstextview-text-view-using-text-layout-manager using-text-layout-manager)
  (wrap-objc-object
   (_msg-36 NSTextView (sel_registerName "textViewUsingTextLayoutManager:") using-text-layout-manager)
   ))
