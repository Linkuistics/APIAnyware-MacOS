#lang racket/base
;; Generated binding for NSButton (AppKit)
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


;; --- Class predicates ---
(define (calayer? v) (objc-instance-of? v "CALayer"))
(define (cgrect? v) (objc-instance-of? v "CGRect"))
(define (cifilter? v) (objc-instance-of? v "CIFilter"))
(define (nsattributedstring? v) (objc-instance-of? v "NSAttributedString"))
(define (nsbitmapimagerep? v) (objc-instance-of? v "NSBitmapImageRep"))
(define (nscandidatelisttouchbaritem? v) (objc-instance-of? v "NSCandidateListTouchBarItem"))
(define (nscolor? v) (objc-instance-of? v "NSColor"))
(define (nsedgeinsets? v) (objc-instance-of? v "NSEdgeInsets"))
(define (nsfont? v) (objc-instance-of? v "NSFont"))
(define (nsimage? v) (objc-instance-of? v "NSImage"))
(define (nsimagesymbolconfiguration? v) (objc-instance-of? v "NSImageSymbolConfiguration"))
(define (nslayoutdimension? v) (objc-instance-of? v "NSLayoutDimension"))
(define (nslayoutguide? v) (objc-instance-of? v "NSLayoutGuide"))
(define (nslayoutxaxisanchor? v) (objc-instance-of? v "NSLayoutXAxisAnchor"))
(define (nslayoutyaxisanchor? v) (objc-instance-of? v "NSLayoutYAxisAnchor"))
(define (nsmenu? v) (objc-instance-of? v "NSMenu"))
(define (nsmenuitem? v) (objc-instance-of? v "NSMenuItem"))
(define (nspressureconfiguration? v) (objc-instance-of? v "NSPressureConfiguration"))
(define (nsresponder? v) (objc-instance-of? v "NSResponder"))
(define (nsscrollview? v) (objc-instance-of? v "NSScrollView"))
(define (nsshadow? v) (objc-instance-of? v "NSShadow"))
(define (nssound? v) (objc-instance-of? v "NSSound"))
(define (nsstring? v) (objc-instance-of? v "NSString"))
(define (nstextinputcontext? v) (objc-instance-of? v "NSTextInputContext"))
(define (nstouchbar? v) (objc-instance-of? v "NSTouchBar"))
(define (nsundomanager? v) (objc-instance-of? v "NSUndoManager"))
(define (nsuseractivity? v) (objc-instance-of? v "NSUserActivity"))
(define (nsuserinterfacecompressionoptions? v) (objc-instance-of? v "NSUserInterfaceCompressionOptions"))
(define (nsview? v) (objc-instance-of? v "NSView"))
(define (nswindow? v) (objc-instance-of? v "NSWindow"))
(define (nswritingtoolscoordinator? v) (objc-instance-of? v "NSWritingToolsCoordinator"))
(provide NSButton)
(provide/contract
  [make-nsbutton-init-with-coder (c-> (or/c string? objc-object? #f) any/c)]
  [make-nsbutton-init-with-frame (c-> any/c any/c)]
  [nsbutton-accepts-first-responder (c-> objc-object? boolean?)]
  [nsbutton-accepts-touch-events (c-> objc-object? boolean?)]
  [nsbutton-set-accepts-touch-events! (c-> objc-object? boolean? void?)]
  [nsbutton-action (c-> objc-object? cpointer?)]
  [nsbutton-set-action! (c-> objc-object? string? void?)]
  [nsbutton-active-compression-options (c-> objc-object? (or/c nsuserinterfacecompressionoptions? objc-nil?))]
  [nsbutton-additional-safe-area-insets (c-> objc-object? any/c)]
  [nsbutton-set-additional-safe-area-insets! (c-> objc-object? any/c void?)]
  [nsbutton-alignment (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-alignment! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-alignment-rect-insets (c-> objc-object? any/c)]
  [nsbutton-allowed-touch-types (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-allowed-touch-types! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-allows-expansion-tool-tips (c-> objc-object? boolean?)]
  [nsbutton-set-allows-expansion-tool-tips! (c-> objc-object? boolean? void?)]
  [nsbutton-allows-mixed-state (c-> objc-object? boolean?)]
  [nsbutton-set-allows-mixed-state! (c-> objc-object? boolean? void?)]
  [nsbutton-allows-vibrancy (c-> objc-object? boolean?)]
  [nsbutton-alpha-value (c-> objc-object? real?)]
  [nsbutton-set-alpha-value! (c-> objc-object? real? void?)]
  [nsbutton-alternate-image (c-> objc-object? (or/c nsimage? objc-nil?))]
  [nsbutton-set-alternate-image! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-alternate-title (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nsbutton-set-alternate-title! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-attributed-alternate-title (c-> objc-object? (or/c nsattributedstring? objc-nil?))]
  [nsbutton-set-attributed-alternate-title! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-attributed-string-value (c-> objc-object? (or/c nsattributedstring? objc-nil?))]
  [nsbutton-set-attributed-string-value! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-attributed-title (c-> objc-object? (or/c nsattributedstring? objc-nil?))]
  [nsbutton-set-attributed-title! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-autoresizes-subviews (c-> objc-object? boolean?)]
  [nsbutton-set-autoresizes-subviews! (c-> objc-object? boolean? void?)]
  [nsbutton-autoresizing-mask (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-autoresizing-mask! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-background-filters (c-> objc-object? any/c)]
  [nsbutton-set-background-filters! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-base-writing-direction (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-base-writing-direction! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-baseline-offset-from-bottom (c-> objc-object? real?)]
  [nsbutton-bezel-color (c-> objc-object? (or/c nscolor? objc-nil?))]
  [nsbutton-set-bezel-color! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-bezel-style (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-bezel-style! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-border-shape (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-border-shape! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-bordered (c-> objc-object? boolean?)]
  [nsbutton-set-bordered! (c-> objc-object? boolean? void?)]
  [nsbutton-bottom-anchor (c-> objc-object? (or/c nslayoutyaxisanchor? objc-nil?))]
  [nsbutton-bounds (c-> objc-object? any/c)]
  [nsbutton-set-bounds! (c-> objc-object? any/c void?)]
  [nsbutton-bounds-rotation (c-> objc-object? real?)]
  [nsbutton-set-bounds-rotation! (c-> objc-object? real? void?)]
  [nsbutton-can-become-key-view (c-> objc-object? boolean?)]
  [nsbutton-can-draw (c-> objc-object? boolean?)]
  [nsbutton-can-draw-concurrently (c-> objc-object? boolean?)]
  [nsbutton-set-can-draw-concurrently! (c-> objc-object? boolean? void?)]
  [nsbutton-can-draw-subviews-into-layer (c-> objc-object? boolean?)]
  [nsbutton-set-can-draw-subviews-into-layer! (c-> objc-object? boolean? void?)]
  [nsbutton-candidate-list-touch-bar-item (c-> objc-object? (or/c nscandidatelisttouchbaritem? objc-nil?))]
  [nsbutton-cell (c-> objc-object? any/c)]
  [nsbutton-set-cell! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-cell-class (c-> cpointer?)]
  [nsbutton-set-cell-class! (c-> cpointer? void?)]
  [nsbutton-center-x-anchor (c-> objc-object? (or/c nslayoutxaxisanchor? objc-nil?))]
  [nsbutton-center-y-anchor (c-> objc-object? (or/c nslayoutyaxisanchor? objc-nil?))]
  [nsbutton-clips-to-bounds (c-> objc-object? boolean?)]
  [nsbutton-set-clips-to-bounds! (c-> objc-object? boolean? void?)]
  [nsbutton-compatible-with-responsive-scrolling (c-> boolean?)]
  [nsbutton-compositing-filter (c-> objc-object? (or/c cifilter? objc-nil?))]
  [nsbutton-set-compositing-filter! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-constraints (c-> objc-object? any/c)]
  [nsbutton-content-filters (c-> objc-object? any/c)]
  [nsbutton-set-content-filters! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-content-tint-color (c-> objc-object? (or/c nscolor? objc-nil?))]
  [nsbutton-set-content-tint-color! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-continuous (c-> objc-object? boolean?)]
  [nsbutton-set-continuous! (c-> objc-object? boolean? void?)]
  [nsbutton-control-size (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-control-size! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-default-focus-ring-type (c-> exact-nonnegative-integer?)]
  [nsbutton-default-menu (c-> (or/c nsmenu? objc-nil?))]
  [nsbutton-double-value (c-> objc-object? real?)]
  [nsbutton-set-double-value! (c-> objc-object? real? void?)]
  [nsbutton-drawing-find-indicator (c-> objc-object? boolean?)]
  [nsbutton-enabled (c-> objc-object? boolean?)]
  [nsbutton-set-enabled! (c-> objc-object? boolean? void?)]
  [nsbutton-enclosing-menu-item (c-> objc-object? (or/c nsmenuitem? objc-nil?))]
  [nsbutton-enclosing-scroll-view (c-> objc-object? (or/c nsscrollview? objc-nil?))]
  [nsbutton-first-baseline-anchor (c-> objc-object? (or/c nslayoutyaxisanchor? objc-nil?))]
  [nsbutton-first-baseline-offset-from-top (c-> objc-object? real?)]
  [nsbutton-fitting-size (c-> objc-object? any/c)]
  [nsbutton-flipped (c-> objc-object? boolean?)]
  [nsbutton-float-value (c-> objc-object? real?)]
  [nsbutton-set-float-value! (c-> objc-object? real? void?)]
  [nsbutton-focus-ring-mask-bounds (c-> objc-object? any/c)]
  [nsbutton-focus-ring-type (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-focus-ring-type! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-focus-view (c-> (or/c nsview? objc-nil?))]
  [nsbutton-font (c-> objc-object? (or/c nsfont? objc-nil?))]
  [nsbutton-set-font! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-formatter (c-> objc-object? any/c)]
  [nsbutton-set-formatter! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-frame (c-> objc-object? any/c)]
  [nsbutton-set-frame! (c-> objc-object? any/c void?)]
  [nsbutton-frame-center-rotation (c-> objc-object? real?)]
  [nsbutton-set-frame-center-rotation! (c-> objc-object? real? void?)]
  [nsbutton-frame-rotation (c-> objc-object? real?)]
  [nsbutton-set-frame-rotation! (c-> objc-object? real? void?)]
  [nsbutton-gesture-recognizers (c-> objc-object? any/c)]
  [nsbutton-set-gesture-recognizers! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-has-ambiguous-layout (c-> objc-object? boolean?)]
  [nsbutton-has-destructive-action (c-> objc-object? boolean?)]
  [nsbutton-set-has-destructive-action! (c-> objc-object? boolean? void?)]
  [nsbutton-height-adjust-limit (c-> objc-object? real?)]
  [nsbutton-height-anchor (c-> objc-object? (or/c nslayoutdimension? objc-nil?))]
  [nsbutton-hidden (c-> objc-object? boolean?)]
  [nsbutton-set-hidden! (c-> objc-object? boolean? void?)]
  [nsbutton-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nsbutton-highlighted (c-> objc-object? boolean?)]
  [nsbutton-set-highlighted! (c-> objc-object? boolean? void?)]
  [nsbutton-horizontal-content-size-constraint-active (c-> objc-object? boolean?)]
  [nsbutton-set-horizontal-content-size-constraint-active! (c-> objc-object? boolean? void?)]
  [nsbutton-ignores-multi-click (c-> objc-object? boolean?)]
  [nsbutton-set-ignores-multi-click! (c-> objc-object? boolean? void?)]
  [nsbutton-image (c-> objc-object? (or/c nsimage? objc-nil?))]
  [nsbutton-set-image! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-image-hugs-title (c-> objc-object? boolean?)]
  [nsbutton-set-image-hugs-title! (c-> objc-object? boolean? void?)]
  [nsbutton-image-position (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-image-position! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-image-scaling (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-image-scaling! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-in-full-screen-mode (c-> objc-object? boolean?)]
  [nsbutton-in-live-resize (c-> objc-object? boolean?)]
  [nsbutton-input-context (c-> objc-object? (or/c nstextinputcontext? objc-nil?))]
  [nsbutton-int-value (c-> objc-object? exact-integer?)]
  [nsbutton-set-int-value! (c-> objc-object? exact-integer? void?)]
  [nsbutton-integer-value (c-> objc-object? exact-integer?)]
  [nsbutton-set-integer-value! (c-> objc-object? exact-integer? void?)]
  [nsbutton-intrinsic-content-size (c-> objc-object? any/c)]
  [nsbutton-key-equivalent (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nsbutton-set-key-equivalent! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-key-equivalent-modifier-mask (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-key-equivalent-modifier-mask! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-last-baseline-anchor (c-> objc-object? (or/c nslayoutyaxisanchor? objc-nil?))]
  [nsbutton-last-baseline-offset-from-bottom (c-> objc-object? real?)]
  [nsbutton-layer (c-> objc-object? (or/c calayer? objc-nil?))]
  [nsbutton-set-layer! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-layer-contents-placement (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-layer-contents-placement! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-layer-contents-redraw-policy (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-layer-contents-redraw-policy! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-layer-uses-core-image-filters (c-> objc-object? boolean?)]
  [nsbutton-set-layer-uses-core-image-filters! (c-> objc-object? boolean? void?)]
  [nsbutton-layout-guides (c-> objc-object? any/c)]
  [nsbutton-layout-margins-guide (c-> objc-object? (or/c nslayoutguide? objc-nil?))]
  [nsbutton-leading-anchor (c-> objc-object? (or/c nslayoutxaxisanchor? objc-nil?))]
  [nsbutton-left-anchor (c-> objc-object? (or/c nslayoutxaxisanchor? objc-nil?))]
  [nsbutton-line-break-mode (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-line-break-mode! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-max-accelerator-level (c-> objc-object? exact-integer?)]
  [nsbutton-set-max-accelerator-level! (c-> objc-object? exact-integer? void?)]
  [nsbutton-menu (c-> objc-object? (or/c nsmenu? objc-nil?))]
  [nsbutton-set-menu! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-mouse-down-can-move-window (c-> objc-object? boolean?)]
  [nsbutton-needs-display (c-> objc-object? boolean?)]
  [nsbutton-set-needs-display! (c-> objc-object? boolean? void?)]
  [nsbutton-needs-layout (c-> objc-object? boolean?)]
  [nsbutton-set-needs-layout! (c-> objc-object? boolean? void?)]
  [nsbutton-needs-panel-to-become-key (c-> objc-object? boolean?)]
  [nsbutton-needs-update-constraints (c-> objc-object? boolean?)]
  [nsbutton-set-needs-update-constraints! (c-> objc-object? boolean? void?)]
  [nsbutton-next-key-view (c-> objc-object? (or/c nsview? objc-nil?))]
  [nsbutton-set-next-key-view! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-next-responder (c-> objc-object? (or/c nsresponder? objc-nil?))]
  [nsbutton-set-next-responder! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-next-valid-key-view (c-> objc-object? (or/c nsview? objc-nil?))]
  [nsbutton-object-value (c-> objc-object? any/c)]
  [nsbutton-set-object-value! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-opaque (c-> objc-object? boolean?)]
  [nsbutton-opaque-ancestor (c-> objc-object? (or/c nsview? objc-nil?))]
  [nsbutton-page-footer (c-> objc-object? (or/c nsattributedstring? objc-nil?))]
  [nsbutton-page-header (c-> objc-object? (or/c nsattributedstring? objc-nil?))]
  [nsbutton-posts-bounds-changed-notifications (c-> objc-object? boolean?)]
  [nsbutton-set-posts-bounds-changed-notifications! (c-> objc-object? boolean? void?)]
  [nsbutton-posts-frame-changed-notifications (c-> objc-object? boolean?)]
  [nsbutton-set-posts-frame-changed-notifications! (c-> objc-object? boolean? void?)]
  [nsbutton-prefers-compact-control-size-metrics (c-> objc-object? boolean?)]
  [nsbutton-set-prefers-compact-control-size-metrics! (c-> objc-object? boolean? void?)]
  [nsbutton-prepared-content-rect (c-> objc-object? any/c)]
  [nsbutton-set-prepared-content-rect! (c-> objc-object? any/c void?)]
  [nsbutton-preserves-content-during-live-resize (c-> objc-object? boolean?)]
  [nsbutton-pressure-configuration (c-> objc-object? (or/c nspressureconfiguration? objc-nil?))]
  [nsbutton-set-pressure-configuration! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-previous-key-view (c-> objc-object? (or/c nsview? objc-nil?))]
  [nsbutton-previous-valid-key-view (c-> objc-object? (or/c nsview? objc-nil?))]
  [nsbutton-print-job-title (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nsbutton-rect-preserved-during-live-resize (c-> objc-object? any/c)]
  [nsbutton-refuses-first-responder (c-> objc-object? boolean?)]
  [nsbutton-set-refuses-first-responder! (c-> objc-object? boolean? void?)]
  [nsbutton-registered-dragged-types (c-> objc-object? any/c)]
  [nsbutton-requires-constraint-based-layout (c-> boolean?)]
  [nsbutton-restorable-state-key-paths (c-> any/c)]
  [nsbutton-right-anchor (c-> objc-object? (or/c nslayoutxaxisanchor? objc-nil?))]
  [nsbutton-rotated-from-base (c-> objc-object? boolean?)]
  [nsbutton-rotated-or-scaled-from-base (c-> objc-object? boolean?)]
  [nsbutton-safe-area-insets (c-> objc-object? any/c)]
  [nsbutton-safe-area-layout-guide (c-> objc-object? (or/c nslayoutguide? objc-nil?))]
  [nsbutton-safe-area-rect (c-> objc-object? any/c)]
  [nsbutton-shadow (c-> objc-object? (or/c nsshadow? objc-nil?))]
  [nsbutton-set-shadow! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-shows-border-only-while-mouse-inside (c-> objc-object? boolean?)]
  [nsbutton-set-shows-border-only-while-mouse-inside! (c-> objc-object? boolean? void?)]
  [nsbutton-sound (c-> objc-object? (or/c nssound? objc-nil?))]
  [nsbutton-set-sound! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-spring-loaded (c-> objc-object? boolean?)]
  [nsbutton-set-spring-loaded! (c-> objc-object? boolean? void?)]
  [nsbutton-state (c-> objc-object? exact-integer?)]
  [nsbutton-set-state! (c-> objc-object? exact-integer? void?)]
  [nsbutton-string-value (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nsbutton-set-string-value! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-subviews (c-> objc-object? any/c)]
  [nsbutton-set-subviews! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-superview (c-> objc-object? (or/c nsview? objc-nil?))]
  [nsbutton-symbol-configuration (c-> objc-object? (or/c nsimagesymbolconfiguration? objc-nil?))]
  [nsbutton-set-symbol-configuration! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-tag (c-> objc-object? exact-integer?)]
  [nsbutton-set-tag! (c-> objc-object? exact-integer? void?)]
  [nsbutton-target (c-> objc-object? any/c)]
  [nsbutton-set-target! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-tint-prominence (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-tint-prominence! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-title (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nsbutton-set-title! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-tool-tip (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nsbutton-set-tool-tip! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-top-anchor (c-> objc-object? (or/c nslayoutyaxisanchor? objc-nil?))]
  [nsbutton-touch-bar (c-> objc-object? (or/c nstouchbar? objc-nil?))]
  [nsbutton-set-touch-bar! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-tracking-areas (c-> objc-object? any/c)]
  [nsbutton-trailing-anchor (c-> objc-object? (or/c nslayoutxaxisanchor? objc-nil?))]
  [nsbutton-translates-autoresizing-mask-into-constraints (c-> objc-object? boolean?)]
  [nsbutton-set-translates-autoresizing-mask-into-constraints! (c-> objc-object? boolean? void?)]
  [nsbutton-transparent (c-> objc-object? boolean?)]
  [nsbutton-set-transparent! (c-> objc-object? boolean? void?)]
  [nsbutton-undo-manager (c-> objc-object? (or/c nsundomanager? objc-nil?))]
  [nsbutton-user-activity (c-> objc-object? (or/c nsuseractivity? objc-nil?))]
  [nsbutton-set-user-activity! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-user-interface-layout-direction (c-> objc-object? exact-nonnegative-integer?)]
  [nsbutton-set-user-interface-layout-direction! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-uses-single-line-mode (c-> objc-object? boolean?)]
  [nsbutton-set-uses-single-line-mode! (c-> objc-object? boolean? void?)]
  [nsbutton-vertical-content-size-constraint-active (c-> objc-object? boolean?)]
  [nsbutton-set-vertical-content-size-constraint-active! (c-> objc-object? boolean? void?)]
  [nsbutton-visible-rect (c-> objc-object? any/c)]
  [nsbutton-wants-best-resolution-open-gl-surface (c-> objc-object? boolean?)]
  [nsbutton-set-wants-best-resolution-open-gl-surface! (c-> objc-object? boolean? void?)]
  [nsbutton-wants-default-clipping (c-> objc-object? boolean?)]
  [nsbutton-wants-extended-dynamic-range-open-gl-surface (c-> objc-object? boolean?)]
  [nsbutton-set-wants-extended-dynamic-range-open-gl-surface! (c-> objc-object? boolean? void?)]
  [nsbutton-wants-layer (c-> objc-object? boolean?)]
  [nsbutton-set-wants-layer! (c-> objc-object? boolean? void?)]
  [nsbutton-wants-resting-touches (c-> objc-object? boolean?)]
  [nsbutton-set-wants-resting-touches! (c-> objc-object? boolean? void?)]
  [nsbutton-wants-update-layer (c-> objc-object? boolean?)]
  [nsbutton-width-adjust-limit (c-> objc-object? real?)]
  [nsbutton-width-anchor (c-> objc-object? (or/c nslayoutdimension? objc-nil?))]
  [nsbutton-window (c-> objc-object? (or/c nswindow? objc-nil?))]
  [nsbutton-writing-tools-coordinator (c-> objc-object? (or/c nswritingtoolscoordinator? objc-nil?))]
  [nsbutton-set-writing-tools-coordinator! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-accepts-first-mouse (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nsbutton-add-subview! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-add-subview-positioned-relative-to! (c-> objc-object? (or/c string? objc-object? #f) exact-nonnegative-integer? (or/c string? objc-object? #f) void?)]
  [nsbutton-add-tool-tip-rect-owner-user-data! (c-> objc-object? any/c (or/c string? objc-object? #f) (or/c cpointer? #f) exact-integer?)]
  [nsbutton-adjust-scroll (c-> objc-object? any/c any/c)]
  [nsbutton-ancestor-shared-with-view (c-> objc-object? (or/c string? objc-object? #f) (or/c nsview? objc-nil?))]
  [nsbutton-autoscroll (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nsbutton-backing-aligned-rect-options (c-> objc-object? any/c exact-nonnegative-integer? any/c)]
  [nsbutton-become-first-responder (c-> objc-object? boolean?)]
  [nsbutton-begin-gesture-with-event! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-bitmap-image-rep-for-caching-display-in-rect (c-> objc-object? any/c (or/c nsbitmapimagerep? objc-nil?))]
  [nsbutton-cache-display-in-rect-to-bitmap-image-rep (c-> objc-object? any/c (or/c string? objc-object? #f) void?)]
  [nsbutton-center-scan-rect! (c-> objc-object? any/c any/c)]
  [nsbutton-change-mode-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-compress-with-prioritized-compression-options (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-context-menu-key-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-convert-point-from-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nsbutton-convert-point-to-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nsbutton-convert-point-from-backing (c-> objc-object? any/c any/c)]
  [nsbutton-convert-point-from-layer (c-> objc-object? any/c any/c)]
  [nsbutton-convert-point-to-backing (c-> objc-object? any/c any/c)]
  [nsbutton-convert-point-to-layer (c-> objc-object? any/c any/c)]
  [nsbutton-convert-rect-from-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nsbutton-convert-rect-to-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nsbutton-convert-rect-from-backing (c-> objc-object? any/c any/c)]
  [nsbutton-convert-rect-from-layer (c-> objc-object? any/c any/c)]
  [nsbutton-convert-rect-to-backing (c-> objc-object? any/c any/c)]
  [nsbutton-convert-rect-to-layer (c-> objc-object? any/c any/c)]
  [nsbutton-convert-size-from-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nsbutton-convert-size-to-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nsbutton-convert-size-from-backing (c-> objc-object? any/c any/c)]
  [nsbutton-convert-size-from-layer (c-> objc-object? any/c any/c)]
  [nsbutton-convert-size-to-backing (c-> objc-object? any/c any/c)]
  [nsbutton-convert-size-to-layer (c-> objc-object? any/c any/c)]
  [nsbutton-cursor-update (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-did-add-subview (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-did-close-menu-with-event (c-> objc-object? (or/c string? objc-object? #f) (or/c string? objc-object? #f) void?)]
  [nsbutton-display! (c-> objc-object? void?)]
  [nsbutton-display-if-needed! (c-> objc-object? void?)]
  [nsbutton-display-if-needed-ignoring-opacity! (c-> objc-object? void?)]
  [nsbutton-display-if-needed-in-rect! (c-> objc-object? any/c void?)]
  [nsbutton-display-if-needed-in-rect-ignoring-opacity! (c-> objc-object? any/c void?)]
  [nsbutton-display-rect! (c-> objc-object? any/c void?)]
  [nsbutton-display-rect-ignoring-opacity! (c-> objc-object? any/c void?)]
  [nsbutton-display-rect-ignoring-opacity-in-context! (c-> objc-object? any/c (or/c string? objc-object? #f) void?)]
  [nsbutton-draw-rect (c-> objc-object? any/c void?)]
  [nsbutton-draw-with-expansion-frame-in-view (c-> objc-object? any/c (or/c string? objc-object? #f) void?)]
  [nsbutton-end-gesture-with-event! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-expansion-frame-with-frame (c-> objc-object? any/c any/c)]
  [nsbutton-flags-changed (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-flush-buffered-key-events (c-> objc-object? void?)]
  [nsbutton-get-periodic-delay-interval (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nsbutton-get-rects-being-drawn-count (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nsbutton-get-rects-exposed-during-live-resize-count (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nsbutton-help-requested (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-highlight (c-> objc-object? boolean? void?)]
  [nsbutton-hit-test (c-> objc-object? any/c (or/c nsview? objc-nil?))]
  [nsbutton-interpret-key-events (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-is-bordered (c-> objc-object? boolean?)]
  [nsbutton-is-continuous (c-> objc-object? boolean?)]
  [nsbutton-is-descendant-of (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nsbutton-is-enabled (c-> objc-object? boolean?)]
  [nsbutton-is-flipped (c-> objc-object? boolean?)]
  [nsbutton-is-hidden (c-> objc-object? boolean?)]
  [nsbutton-is-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nsbutton-is-highlighted (c-> objc-object? boolean?)]
  [nsbutton-is-opaque (c-> objc-object? boolean?)]
  [nsbutton-is-rotated-from-base (c-> objc-object? boolean?)]
  [nsbutton-is-rotated-or-scaled-from-base (c-> objc-object? boolean?)]
  [nsbutton-is-spring-loaded (c-> objc-object? boolean?)]
  [nsbutton-is-transparent (c-> objc-object? boolean?)]
  [nsbutton-key-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-key-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-layout (c-> objc-object? void?)]
  [nsbutton-layout-subtree-if-needed (c-> objc-object? void?)]
  [nsbutton-magnify-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-make-backing-layer (c-> objc-object? (or/c calayer? objc-nil?))]
  [nsbutton-menu-for-event (c-> objc-object? (or/c string? objc-object? #f) (or/c nsmenu? objc-nil?))]
  [nsbutton-minimum-size-with-prioritized-compression-options (c-> objc-object? (or/c string? objc-object? #f) any/c)]
  [nsbutton-mouse-in-rect (c-> objc-object? any/c any/c boolean?)]
  [nsbutton-mouse-cancelled (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-mouse-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-mouse-dragged (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-mouse-entered (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-mouse-exited (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-mouse-moved (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-mouse-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-needs-to-draw-rect (c-> objc-object? any/c boolean?)]
  [nsbutton-no-responder-for (c-> objc-object? string? void?)]
  [nsbutton-other-mouse-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-other-mouse-dragged (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-other-mouse-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-perform-click! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-perform-key-equivalent! (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nsbutton-prepare-content-in-rect (c-> objc-object? any/c void?)]
  [nsbutton-prepare-for-reuse (c-> objc-object? void?)]
  [nsbutton-pressure-change-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-quick-look-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-rect-for-smart-magnification-at-point-in-rect (c-> objc-object? any/c any/c any/c)]
  [nsbutton-remove-all-tool-tips! (c-> objc-object? void?)]
  [nsbutton-remove-from-superview! (c-> objc-object? void?)]
  [nsbutton-remove-from-superview-without-needing-display! (c-> objc-object? void?)]
  [nsbutton-remove-tool-tip! (c-> objc-object? exact-integer? void?)]
  [nsbutton-replace-subview-with! (c-> objc-object? (or/c string? objc-object? #f) (or/c string? objc-object? #f) void?)]
  [nsbutton-resign-first-responder (c-> objc-object? boolean?)]
  [nsbutton-resize-subviews-with-old-size (c-> objc-object? any/c void?)]
  [nsbutton-resize-with-old-superview-size (c-> objc-object? any/c void?)]
  [nsbutton-right-mouse-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-right-mouse-dragged (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-right-mouse-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-rotate-by-angle (c-> objc-object? real? void?)]
  [nsbutton-rotate-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-scale-unit-square-to-size (c-> objc-object? any/c void?)]
  [nsbutton-scroll-point (c-> objc-object? any/c void?)]
  [nsbutton-scroll-rect-to-visible (c-> objc-object? any/c boolean?)]
  [nsbutton-scroll-wheel (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-send-action-to (c-> objc-object? string? (or/c string? objc-object? #f) boolean?)]
  [nsbutton-send-action-on (c-> objc-object? exact-nonnegative-integer? exact-integer?)]
  [nsbutton-set-bounds-origin! (c-> objc-object? any/c void?)]
  [nsbutton-set-bounds-size! (c-> objc-object? any/c void?)]
  [nsbutton-set-button-type! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsbutton-set-frame-origin! (c-> objc-object? any/c void?)]
  [nsbutton-set-frame-size! (c-> objc-object? any/c void?)]
  [nsbutton-set-needs-display-in-rect! (c-> objc-object? any/c void?)]
  [nsbutton-set-next-state! (c-> objc-object? void?)]
  [nsbutton-set-periodic-delay-interval! (c-> objc-object? real? real? void?)]
  [nsbutton-should-be-treated-as-ink-event (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nsbutton-should-delay-window-ordering-for-event (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nsbutton-show-context-help (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-size-that-fits (c-> objc-object? any/c any/c)]
  [nsbutton-size-to-fit (c-> objc-object? void?)]
  [nsbutton-smart-magnify-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-sort-subviews-using-function-context (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nsbutton-supplemental-target-for-action-sender (c-> objc-object? string? (or/c string? objc-object? #f) any/c)]
  [nsbutton-swipe-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-tablet-point (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-tablet-proximity (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-take-double-value-from (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-take-float-value-from (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-take-int-value-from (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-take-integer-value-from (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-take-object-value-from (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-take-string-value-from (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-touches-began-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-touches-cancelled-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-touches-ended-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-touches-moved-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-translate-origin-to-point (c-> objc-object? any/c void?)]
  [nsbutton-translate-rects-needing-display-in-rect-by (c-> objc-object? any/c any/c void?)]
  [nsbutton-try-to-perform-with (c-> objc-object? string? (or/c string? objc-object? #f) boolean?)]
  [nsbutton-update-layer (c-> objc-object? void?)]
  [nsbutton-valid-requestor-for-send-type-return-type (c-> objc-object? (or/c string? objc-object? #f) (or/c string? objc-object? #f) any/c)]
  [nsbutton-view-did-change-backing-properties (c-> objc-object? void?)]
  [nsbutton-view-did-change-effective-appearance (c-> objc-object? void?)]
  [nsbutton-view-did-end-live-resize (c-> objc-object? void?)]
  [nsbutton-view-did-hide (c-> objc-object? void?)]
  [nsbutton-view-did-move-to-superview (c-> objc-object? void?)]
  [nsbutton-view-did-move-to-window (c-> objc-object? void?)]
  [nsbutton-view-did-unhide (c-> objc-object? void?)]
  [nsbutton-view-will-draw (c-> objc-object? void?)]
  [nsbutton-view-will-move-to-superview (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-view-will-move-to-window (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-view-will-start-live-resize (c-> objc-object? void?)]
  [nsbutton-view-with-tag (c-> objc-object? exact-integer? any/c)]
  [nsbutton-wants-forwarded-scroll-events-for-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nsbutton-wants-scroll-events-for-swipe-tracking-on-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nsbutton-will-open-menu-with-event (c-> objc-object? (or/c string? objc-object? #f) (or/c string? objc-object? #f) void?)]
  [nsbutton-will-remove-subview (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsbutton-button-with-image-target-action (c-> (or/c string? objc-object? #f) (or/c string? objc-object? #f) string? any/c)]
  [nsbutton-button-with-title-image-target-action (c-> (or/c string? objc-object? #f) (or/c string? objc-object? #f) (or/c string? objc-object? #f) string? any/c)]
  [nsbutton-button-with-title-target-action (c-> (or/c string? objc-object? #f) (or/c string? objc-object? #f) string? any/c)]
  [nsbutton-checkbox-with-title-target-action (c-> (or/c string? objc-object? #f) (or/c string? objc-object? #f) string? any/c)]
  [nsbutton-is-compatible-with-responsive-scrolling (c-> boolean?)]
  [nsbutton-radio-button-with-title-target-action (c-> (or/c string? objc-object? #f) (or/c string? objc-object? #f) string? any/c)]
  )

;; --- Class reference ---
(import-class NSButton)

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
(define _msg-30  ; (_fun _pointer _pointer _float _float -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _float _float -> _void)))
(define _msg-31  ; (_fun _pointer _pointer _id -> _NSSize)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _NSSize)))
(define _msg-32  ; (_fun _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _bool)))
(define _msg-33  ; (_fun _pointer _pointer _id _id _id _pointer -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _id _id _pointer -> _id)))
(define _msg-34  ; (_fun _pointer _pointer _id _id _pointer -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _id _pointer -> _id)))
(define _msg-35  ; (_fun _pointer _pointer _id _int64 _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _int64 _id -> _void)))
(define _msg-36  ; (_fun _pointer _pointer _int32 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int32 -> _void)))
(define _msg-37  ; (_fun _pointer _pointer _int64 -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _bool)))
(define _msg-38  ; (_fun _pointer _pointer _int64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _id)))
(define _msg-39  ; (_fun _pointer _pointer _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _void)))
(define _msg-40  ; (_fun _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))
(define _msg-41  ; (_fun _pointer _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _bool)))
(define _msg-42  ; (_fun _pointer _pointer _pointer _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _id)))
(define _msg-43  ; (_fun _pointer _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _pointer -> _void)))
(define _msg-44  ; (_fun _pointer _pointer _uint64 -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _int64)))
(define _msg-45  ; (_fun _pointer _pointer _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _void)))

;; --- Constructors ---
(define (make-nsbutton-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSButton alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))

(define (make-nsbutton-init-with-frame frame-rect)
  (wrap-objc-object
   (_msg-17 (tell NSButton alloc)
       (sel_registerName "initWithFrame:")
       frame-rect)
   #:retained #t))


;; --- Properties ---
(define (nsbutton-accepts-first-responder self)
  (tell #:type _bool (coerce-arg self) acceptsFirstResponder))
(define (nsbutton-accepts-touch-events self)
  (tell #:type _bool (coerce-arg self) acceptsTouchEvents))
(define (nsbutton-set-accepts-touch-events! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setAcceptsTouchEvents:") value))
(define (nsbutton-action self)
  (tell #:type _pointer (coerce-arg self) action))
(define (nsbutton-set-action! self value)
  (_msg-40 (coerce-arg self) (sel_registerName "setAction:") (sel_registerName value)))
(define (nsbutton-active-compression-options self)
  (wrap-objc-object
   (tell (coerce-arg self) activeCompressionOptions)))
(define (nsbutton-additional-safe-area-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) additionalSafeAreaInsets))
(define (nsbutton-set-additional-safe-area-insets! self value)
  (_msg-8 (coerce-arg self) (sel_registerName "setAdditionalSafeAreaInsets:") value))
(define (nsbutton-alignment self)
  (tell #:type _int64 (coerce-arg self) alignment))
(define (nsbutton-set-alignment! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setAlignment:") value))
(define (nsbutton-alignment-rect-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) alignmentRectInsets))
(define (nsbutton-allowed-touch-types self)
  (tell #:type _uint64 (coerce-arg self) allowedTouchTypes))
(define (nsbutton-set-allowed-touch-types! self value)
  (_msg-45 (coerce-arg self) (sel_registerName "setAllowedTouchTypes:") value))
(define (nsbutton-allows-expansion-tool-tips self)
  (tell #:type _bool (coerce-arg self) allowsExpansionToolTips))
(define (nsbutton-set-allows-expansion-tool-tips! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setAllowsExpansionToolTips:") value))
(define (nsbutton-allows-mixed-state self)
  (tell #:type _bool (coerce-arg self) allowsMixedState))
(define (nsbutton-set-allows-mixed-state! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setAllowsMixedState:") value))
(define (nsbutton-allows-vibrancy self)
  (tell #:type _bool (coerce-arg self) allowsVibrancy))
(define (nsbutton-alpha-value self)
  (tell #:type _double (coerce-arg self) alphaValue))
(define (nsbutton-set-alpha-value! self value)
  (_msg-28 (coerce-arg self) (sel_registerName "setAlphaValue:") value))
(define (nsbutton-alternate-image self)
  (wrap-objc-object
   (tell (coerce-arg self) alternateImage)))
(define (nsbutton-set-alternate-image! self value)
  (tell #:type _void (coerce-arg self) setAlternateImage: (coerce-arg value)))
(define (nsbutton-alternate-title self)
  (wrap-objc-object
   (tell (coerce-arg self) alternateTitle)))
(define (nsbutton-set-alternate-title! self value)
  (tell #:type _void (coerce-arg self) setAlternateTitle: (coerce-arg value)))
(define (nsbutton-attributed-alternate-title self)
  (wrap-objc-object
   (tell (coerce-arg self) attributedAlternateTitle)))
(define (nsbutton-set-attributed-alternate-title! self value)
  (tell #:type _void (coerce-arg self) setAttributedAlternateTitle: (coerce-arg value)))
(define (nsbutton-attributed-string-value self)
  (wrap-objc-object
   (tell (coerce-arg self) attributedStringValue)))
(define (nsbutton-set-attributed-string-value! self value)
  (tell #:type _void (coerce-arg self) setAttributedStringValue: (coerce-arg value)))
(define (nsbutton-attributed-title self)
  (wrap-objc-object
   (tell (coerce-arg self) attributedTitle)))
(define (nsbutton-set-attributed-title! self value)
  (tell #:type _void (coerce-arg self) setAttributedTitle: (coerce-arg value)))
(define (nsbutton-autoresizes-subviews self)
  (tell #:type _bool (coerce-arg self) autoresizesSubviews))
(define (nsbutton-set-autoresizes-subviews! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setAutoresizesSubviews:") value))
(define (nsbutton-autoresizing-mask self)
  (tell #:type _uint64 (coerce-arg self) autoresizingMask))
(define (nsbutton-set-autoresizing-mask! self value)
  (_msg-45 (coerce-arg self) (sel_registerName "setAutoresizingMask:") value))
(define (nsbutton-background-filters self)
  (wrap-objc-object
   (tell (coerce-arg self) backgroundFilters)))
(define (nsbutton-set-background-filters! self value)
  (tell #:type _void (coerce-arg self) setBackgroundFilters: (coerce-arg value)))
(define (nsbutton-base-writing-direction self)
  (tell #:type _int64 (coerce-arg self) baseWritingDirection))
(define (nsbutton-set-base-writing-direction! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setBaseWritingDirection:") value))
(define (nsbutton-baseline-offset-from-bottom self)
  (tell #:type _double (coerce-arg self) baselineOffsetFromBottom))
(define (nsbutton-bezel-color self)
  (wrap-objc-object
   (tell (coerce-arg self) bezelColor)))
(define (nsbutton-set-bezel-color! self value)
  (tell #:type _void (coerce-arg self) setBezelColor: (coerce-arg value)))
(define (nsbutton-bezel-style self)
  (tell #:type _uint64 (coerce-arg self) bezelStyle))
(define (nsbutton-set-bezel-style! self value)
  (_msg-45 (coerce-arg self) (sel_registerName "setBezelStyle:") value))
(define (nsbutton-border-shape self)
  (tell #:type _int64 (coerce-arg self) borderShape))
(define (nsbutton-set-border-shape! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setBorderShape:") value))
(define (nsbutton-bordered self)
  (tell #:type _bool (coerce-arg self) bordered))
(define (nsbutton-set-bordered! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setBordered:") value))
(define (nsbutton-bottom-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) bottomAnchor)))
(define (nsbutton-bounds self)
  (tell #:type _NSRect (coerce-arg self) bounds))
(define (nsbutton-set-bounds! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setBounds:") value))
(define (nsbutton-bounds-rotation self)
  (tell #:type _double (coerce-arg self) boundsRotation))
(define (nsbutton-set-bounds-rotation! self value)
  (_msg-28 (coerce-arg self) (sel_registerName "setBoundsRotation:") value))
(define (nsbutton-can-become-key-view self)
  (tell #:type _bool (coerce-arg self) canBecomeKeyView))
(define (nsbutton-can-draw self)
  (tell #:type _bool (coerce-arg self) canDraw))
(define (nsbutton-can-draw-concurrently self)
  (tell #:type _bool (coerce-arg self) canDrawConcurrently))
(define (nsbutton-set-can-draw-concurrently! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setCanDrawConcurrently:") value))
(define (nsbutton-can-draw-subviews-into-layer self)
  (tell #:type _bool (coerce-arg self) canDrawSubviewsIntoLayer))
(define (nsbutton-set-can-draw-subviews-into-layer! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setCanDrawSubviewsIntoLayer:") value))
(define (nsbutton-candidate-list-touch-bar-item self)
  (wrap-objc-object
   (tell (coerce-arg self) candidateListTouchBarItem)))
(define (nsbutton-cell self)
  (wrap-objc-object
   (tell (coerce-arg self) cell)))
(define (nsbutton-set-cell! self value)
  (tell #:type _void (coerce-arg self) setCell: (coerce-arg value)))
(define (nsbutton-cell-class)
  (tell #:type _pointer NSButton cellClass))
(define (nsbutton-set-cell-class! value)
  (_msg-40 NSButton (sel_registerName "setCellClass:") value))
(define (nsbutton-center-x-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) centerXAnchor)))
(define (nsbutton-center-y-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) centerYAnchor)))
(define (nsbutton-clips-to-bounds self)
  (tell #:type _bool (coerce-arg self) clipsToBounds))
(define (nsbutton-set-clips-to-bounds! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setClipsToBounds:") value))
(define (nsbutton-compatible-with-responsive-scrolling)
  (tell #:type _bool NSButton compatibleWithResponsiveScrolling))
(define (nsbutton-compositing-filter self)
  (wrap-objc-object
   (tell (coerce-arg self) compositingFilter)))
(define (nsbutton-set-compositing-filter! self value)
  (tell #:type _void (coerce-arg self) setCompositingFilter: (coerce-arg value)))
(define (nsbutton-constraints self)
  (wrap-objc-object
   (tell (coerce-arg self) constraints)))
(define (nsbutton-content-filters self)
  (wrap-objc-object
   (tell (coerce-arg self) contentFilters)))
(define (nsbutton-set-content-filters! self value)
  (tell #:type _void (coerce-arg self) setContentFilters: (coerce-arg value)))
(define (nsbutton-content-tint-color self)
  (wrap-objc-object
   (tell (coerce-arg self) contentTintColor)))
(define (nsbutton-set-content-tint-color! self value)
  (tell #:type _void (coerce-arg self) setContentTintColor: (coerce-arg value)))
(define (nsbutton-continuous self)
  (tell #:type _bool (coerce-arg self) continuous))
(define (nsbutton-set-continuous! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setContinuous:") value))
(define (nsbutton-control-size self)
  (tell #:type _uint64 (coerce-arg self) controlSize))
(define (nsbutton-set-control-size! self value)
  (_msg-45 (coerce-arg self) (sel_registerName "setControlSize:") value))
(define (nsbutton-default-focus-ring-type)
  (tell #:type _uint64 NSButton defaultFocusRingType))
(define (nsbutton-default-menu)
  (wrap-objc-object
   (tell NSButton defaultMenu)))
(define (nsbutton-double-value self)
  (tell #:type _double (coerce-arg self) doubleValue))
(define (nsbutton-set-double-value! self value)
  (_msg-28 (coerce-arg self) (sel_registerName "setDoubleValue:") value))
(define (nsbutton-drawing-find-indicator self)
  (tell #:type _bool (coerce-arg self) drawingFindIndicator))
(define (nsbutton-enabled self)
  (tell #:type _bool (coerce-arg self) enabled))
(define (nsbutton-set-enabled! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setEnabled:") value))
(define (nsbutton-enclosing-menu-item self)
  (wrap-objc-object
   (tell (coerce-arg self) enclosingMenuItem)))
(define (nsbutton-enclosing-scroll-view self)
  (wrap-objc-object
   (tell (coerce-arg self) enclosingScrollView)))
(define (nsbutton-first-baseline-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) firstBaselineAnchor)))
(define (nsbutton-first-baseline-offset-from-top self)
  (tell #:type _double (coerce-arg self) firstBaselineOffsetFromTop))
(define (nsbutton-fitting-size self)
  (tell #:type _NSSize (coerce-arg self) fittingSize))
(define (nsbutton-flipped self)
  (tell #:type _bool (coerce-arg self) flipped))
(define (nsbutton-float-value self)
  (tell #:type _float (coerce-arg self) floatValue))
(define (nsbutton-set-float-value! self value)
  (_msg-29 (coerce-arg self) (sel_registerName "setFloatValue:") value))
(define (nsbutton-focus-ring-mask-bounds self)
  (tell #:type _NSRect (coerce-arg self) focusRingMaskBounds))
(define (nsbutton-focus-ring-type self)
  (tell #:type _uint64 (coerce-arg self) focusRingType))
(define (nsbutton-set-focus-ring-type! self value)
  (_msg-45 (coerce-arg self) (sel_registerName "setFocusRingType:") value))
(define (nsbutton-focus-view)
  (wrap-objc-object
   (tell NSButton focusView)))
(define (nsbutton-font self)
  (wrap-objc-object
   (tell (coerce-arg self) font)))
(define (nsbutton-set-font! self value)
  (tell #:type _void (coerce-arg self) setFont: (coerce-arg value)))
(define (nsbutton-formatter self)
  (wrap-objc-object
   (tell (coerce-arg self) formatter)))
(define (nsbutton-set-formatter! self value)
  (tell #:type _void (coerce-arg self) setFormatter: (coerce-arg value)))
(define (nsbutton-frame self)
  (tell #:type _NSRect (coerce-arg self) frame))
(define (nsbutton-set-frame! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setFrame:") value))
(define (nsbutton-frame-center-rotation self)
  (tell #:type _double (coerce-arg self) frameCenterRotation))
(define (nsbutton-set-frame-center-rotation! self value)
  (_msg-28 (coerce-arg self) (sel_registerName "setFrameCenterRotation:") value))
(define (nsbutton-frame-rotation self)
  (tell #:type _double (coerce-arg self) frameRotation))
(define (nsbutton-set-frame-rotation! self value)
  (_msg-28 (coerce-arg self) (sel_registerName "setFrameRotation:") value))
(define (nsbutton-gesture-recognizers self)
  (wrap-objc-object
   (tell (coerce-arg self) gestureRecognizers)))
(define (nsbutton-set-gesture-recognizers! self value)
  (tell #:type _void (coerce-arg self) setGestureRecognizers: (coerce-arg value)))
(define (nsbutton-has-ambiguous-layout self)
  (tell #:type _bool (coerce-arg self) hasAmbiguousLayout))
(define (nsbutton-has-destructive-action self)
  (tell #:type _bool (coerce-arg self) hasDestructiveAction))
(define (nsbutton-set-has-destructive-action! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setHasDestructiveAction:") value))
(define (nsbutton-height-adjust-limit self)
  (tell #:type _double (coerce-arg self) heightAdjustLimit))
(define (nsbutton-height-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) heightAnchor)))
(define (nsbutton-hidden self)
  (tell #:type _bool (coerce-arg self) hidden))
(define (nsbutton-set-hidden! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setHidden:") value))
(define (nsbutton-hidden-or-has-hidden-ancestor self)
  (tell #:type _bool (coerce-arg self) hiddenOrHasHiddenAncestor))
(define (nsbutton-highlighted self)
  (tell #:type _bool (coerce-arg self) highlighted))
(define (nsbutton-set-highlighted! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setHighlighted:") value))
(define (nsbutton-horizontal-content-size-constraint-active self)
  (tell #:type _bool (coerce-arg self) horizontalContentSizeConstraintActive))
(define (nsbutton-set-horizontal-content-size-constraint-active! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setHorizontalContentSizeConstraintActive:") value))
(define (nsbutton-ignores-multi-click self)
  (tell #:type _bool (coerce-arg self) ignoresMultiClick))
(define (nsbutton-set-ignores-multi-click! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setIgnoresMultiClick:") value))
(define (nsbutton-image self)
  (wrap-objc-object
   (tell (coerce-arg self) image)))
(define (nsbutton-set-image! self value)
  (tell #:type _void (coerce-arg self) setImage: (coerce-arg value)))
(define (nsbutton-image-hugs-title self)
  (tell #:type _bool (coerce-arg self) imageHugsTitle))
(define (nsbutton-set-image-hugs-title! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setImageHugsTitle:") value))
(define (nsbutton-image-position self)
  (tell #:type _uint64 (coerce-arg self) imagePosition))
(define (nsbutton-set-image-position! self value)
  (_msg-45 (coerce-arg self) (sel_registerName "setImagePosition:") value))
(define (nsbutton-image-scaling self)
  (tell #:type _uint64 (coerce-arg self) imageScaling))
(define (nsbutton-set-image-scaling! self value)
  (_msg-45 (coerce-arg self) (sel_registerName "setImageScaling:") value))
(define (nsbutton-in-full-screen-mode self)
  (tell #:type _bool (coerce-arg self) inFullScreenMode))
(define (nsbutton-in-live-resize self)
  (tell #:type _bool (coerce-arg self) inLiveResize))
(define (nsbutton-input-context self)
  (wrap-objc-object
   (tell (coerce-arg self) inputContext)))
(define (nsbutton-int-value self)
  (tell #:type _int32 (coerce-arg self) intValue))
(define (nsbutton-set-int-value! self value)
  (_msg-36 (coerce-arg self) (sel_registerName "setIntValue:") value))
(define (nsbutton-integer-value self)
  (tell #:type _int64 (coerce-arg self) integerValue))
(define (nsbutton-set-integer-value! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setIntegerValue:") value))
(define (nsbutton-intrinsic-content-size self)
  (tell #:type _NSSize (coerce-arg self) intrinsicContentSize))
(define (nsbutton-key-equivalent self)
  (wrap-objc-object
   (tell (coerce-arg self) keyEquivalent)))
(define (nsbutton-set-key-equivalent! self value)
  (tell #:type _void (coerce-arg self) setKeyEquivalent: (coerce-arg value)))
(define (nsbutton-key-equivalent-modifier-mask self)
  (tell #:type _uint64 (coerce-arg self) keyEquivalentModifierMask))
(define (nsbutton-set-key-equivalent-modifier-mask! self value)
  (_msg-45 (coerce-arg self) (sel_registerName "setKeyEquivalentModifierMask:") value))
(define (nsbutton-last-baseline-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) lastBaselineAnchor)))
(define (nsbutton-last-baseline-offset-from-bottom self)
  (tell #:type _double (coerce-arg self) lastBaselineOffsetFromBottom))
(define (nsbutton-layer self)
  (wrap-objc-object
   (tell (coerce-arg self) layer)))
(define (nsbutton-set-layer! self value)
  (tell #:type _void (coerce-arg self) setLayer: (coerce-arg value)))
(define (nsbutton-layer-contents-placement self)
  (tell #:type _int64 (coerce-arg self) layerContentsPlacement))
(define (nsbutton-set-layer-contents-placement! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setLayerContentsPlacement:") value))
(define (nsbutton-layer-contents-redraw-policy self)
  (tell #:type _int64 (coerce-arg self) layerContentsRedrawPolicy))
(define (nsbutton-set-layer-contents-redraw-policy! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setLayerContentsRedrawPolicy:") value))
(define (nsbutton-layer-uses-core-image-filters self)
  (tell #:type _bool (coerce-arg self) layerUsesCoreImageFilters))
(define (nsbutton-set-layer-uses-core-image-filters! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setLayerUsesCoreImageFilters:") value))
(define (nsbutton-layout-guides self)
  (wrap-objc-object
   (tell (coerce-arg self) layoutGuides)))
(define (nsbutton-layout-margins-guide self)
  (wrap-objc-object
   (tell (coerce-arg self) layoutMarginsGuide)))
(define (nsbutton-leading-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) leadingAnchor)))
(define (nsbutton-left-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) leftAnchor)))
(define (nsbutton-line-break-mode self)
  (tell #:type _uint64 (coerce-arg self) lineBreakMode))
(define (nsbutton-set-line-break-mode! self value)
  (_msg-45 (coerce-arg self) (sel_registerName "setLineBreakMode:") value))
(define (nsbutton-max-accelerator-level self)
  (tell #:type _int64 (coerce-arg self) maxAcceleratorLevel))
(define (nsbutton-set-max-accelerator-level! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setMaxAcceleratorLevel:") value))
(define (nsbutton-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) menu)))
(define (nsbutton-set-menu! self value)
  (tell #:type _void (coerce-arg self) setMenu: (coerce-arg value)))
(define (nsbutton-mouse-down-can-move-window self)
  (tell #:type _bool (coerce-arg self) mouseDownCanMoveWindow))
(define (nsbutton-needs-display self)
  (tell #:type _bool (coerce-arg self) needsDisplay))
(define (nsbutton-set-needs-display! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setNeedsDisplay:") value))
(define (nsbutton-needs-layout self)
  (tell #:type _bool (coerce-arg self) needsLayout))
(define (nsbutton-set-needs-layout! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setNeedsLayout:") value))
(define (nsbutton-needs-panel-to-become-key self)
  (tell #:type _bool (coerce-arg self) needsPanelToBecomeKey))
(define (nsbutton-needs-update-constraints self)
  (tell #:type _bool (coerce-arg self) needsUpdateConstraints))
(define (nsbutton-set-needs-update-constraints! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setNeedsUpdateConstraints:") value))
(define (nsbutton-next-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) nextKeyView)))
(define (nsbutton-set-next-key-view! self value)
  (tell #:type _void (coerce-arg self) setNextKeyView: (coerce-arg value)))
(define (nsbutton-next-responder self)
  (wrap-objc-object
   (tell (coerce-arg self) nextResponder)))
(define (nsbutton-set-next-responder! self value)
  (tell #:type _void (coerce-arg self) setNextResponder: (coerce-arg value)))
(define (nsbutton-next-valid-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) nextValidKeyView)))
(define (nsbutton-object-value self)
  (wrap-objc-object
   (tell (coerce-arg self) objectValue)))
(define (nsbutton-set-object-value! self value)
  (tell #:type _void (coerce-arg self) setObjectValue: (coerce-arg value)))
(define (nsbutton-opaque self)
  (tell #:type _bool (coerce-arg self) opaque))
(define (nsbutton-opaque-ancestor self)
  (wrap-objc-object
   (tell (coerce-arg self) opaqueAncestor)))
(define (nsbutton-page-footer self)
  (wrap-objc-object
   (tell (coerce-arg self) pageFooter)))
(define (nsbutton-page-header self)
  (wrap-objc-object
   (tell (coerce-arg self) pageHeader)))
(define (nsbutton-posts-bounds-changed-notifications self)
  (tell #:type _bool (coerce-arg self) postsBoundsChangedNotifications))
(define (nsbutton-set-posts-bounds-changed-notifications! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setPostsBoundsChangedNotifications:") value))
(define (nsbutton-posts-frame-changed-notifications self)
  (tell #:type _bool (coerce-arg self) postsFrameChangedNotifications))
(define (nsbutton-set-posts-frame-changed-notifications! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setPostsFrameChangedNotifications:") value))
(define (nsbutton-prefers-compact-control-size-metrics self)
  (tell #:type _bool (coerce-arg self) prefersCompactControlSizeMetrics))
(define (nsbutton-set-prefers-compact-control-size-metrics! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setPrefersCompactControlSizeMetrics:") value))
(define (nsbutton-prepared-content-rect self)
  (tell #:type _NSRect (coerce-arg self) preparedContentRect))
(define (nsbutton-set-prepared-content-rect! self value)
  (_msg-18 (coerce-arg self) (sel_registerName "setPreparedContentRect:") value))
(define (nsbutton-preserves-content-during-live-resize self)
  (tell #:type _bool (coerce-arg self) preservesContentDuringLiveResize))
(define (nsbutton-pressure-configuration self)
  (wrap-objc-object
   (tell (coerce-arg self) pressureConfiguration)))
(define (nsbutton-set-pressure-configuration! self value)
  (tell #:type _void (coerce-arg self) setPressureConfiguration: (coerce-arg value)))
(define (nsbutton-previous-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) previousKeyView)))
(define (nsbutton-previous-valid-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) previousValidKeyView)))
(define (nsbutton-print-job-title self)
  (wrap-objc-object
   (tell (coerce-arg self) printJobTitle)))
(define (nsbutton-rect-preserved-during-live-resize self)
  (tell #:type _NSRect (coerce-arg self) rectPreservedDuringLiveResize))
(define (nsbutton-refuses-first-responder self)
  (tell #:type _bool (coerce-arg self) refusesFirstResponder))
(define (nsbutton-set-refuses-first-responder! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setRefusesFirstResponder:") value))
(define (nsbutton-registered-dragged-types self)
  (wrap-objc-object
   (tell (coerce-arg self) registeredDraggedTypes)))
(define (nsbutton-requires-constraint-based-layout)
  (tell #:type _bool NSButton requiresConstraintBasedLayout))
(define (nsbutton-restorable-state-key-paths)
  (wrap-objc-object
   (tell NSButton restorableStateKeyPaths)))
(define (nsbutton-right-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) rightAnchor)))
(define (nsbutton-rotated-from-base self)
  (tell #:type _bool (coerce-arg self) rotatedFromBase))
(define (nsbutton-rotated-or-scaled-from-base self)
  (tell #:type _bool (coerce-arg self) rotatedOrScaledFromBase))
(define (nsbutton-safe-area-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) safeAreaInsets))
(define (nsbutton-safe-area-layout-guide self)
  (wrap-objc-object
   (tell (coerce-arg self) safeAreaLayoutGuide)))
(define (nsbutton-safe-area-rect self)
  (tell #:type _NSRect (coerce-arg self) safeAreaRect))
(define (nsbutton-shadow self)
  (wrap-objc-object
   (tell (coerce-arg self) shadow)))
(define (nsbutton-set-shadow! self value)
  (tell #:type _void (coerce-arg self) setShadow: (coerce-arg value)))
(define (nsbutton-shows-border-only-while-mouse-inside self)
  (tell #:type _bool (coerce-arg self) showsBorderOnlyWhileMouseInside))
(define (nsbutton-set-shows-border-only-while-mouse-inside! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setShowsBorderOnlyWhileMouseInside:") value))
(define (nsbutton-sound self)
  (wrap-objc-object
   (tell (coerce-arg self) sound)))
(define (nsbutton-set-sound! self value)
  (tell #:type _void (coerce-arg self) setSound: (coerce-arg value)))
(define (nsbutton-spring-loaded self)
  (tell #:type _bool (coerce-arg self) springLoaded))
(define (nsbutton-set-spring-loaded! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setSpringLoaded:") value))
(define (nsbutton-state self)
  (tell #:type _int64 (coerce-arg self) state))
(define (nsbutton-set-state! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setState:") value))
(define (nsbutton-string-value self)
  (wrap-objc-object
   (tell (coerce-arg self) stringValue)))
(define (nsbutton-set-string-value! self value)
  (tell #:type _void (coerce-arg self) setStringValue: (coerce-arg value)))
(define (nsbutton-subviews self)
  (wrap-objc-object
   (tell (coerce-arg self) subviews)))
(define (nsbutton-set-subviews! self value)
  (tell #:type _void (coerce-arg self) setSubviews: (coerce-arg value)))
(define (nsbutton-superview self)
  (wrap-objc-object
   (tell (coerce-arg self) superview)))
(define (nsbutton-symbol-configuration self)
  (wrap-objc-object
   (tell (coerce-arg self) symbolConfiguration)))
(define (nsbutton-set-symbol-configuration! self value)
  (tell #:type _void (coerce-arg self) setSymbolConfiguration: (coerce-arg value)))
(define (nsbutton-tag self)
  (tell #:type _int64 (coerce-arg self) tag))
(define (nsbutton-set-tag! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setTag:") value))
(define (nsbutton-target self)
  (wrap-objc-object
   (tell (coerce-arg self) target)))
(define (nsbutton-set-target! self value)
  (tell #:type _void (coerce-arg self) setTarget: (coerce-arg value)))
(define (nsbutton-tint-prominence self)
  (tell #:type _int64 (coerce-arg self) tintProminence))
(define (nsbutton-set-tint-prominence! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setTintProminence:") value))
(define (nsbutton-title self)
  (wrap-objc-object
   (tell (coerce-arg self) title)))
(define (nsbutton-set-title! self value)
  (tell #:type _void (coerce-arg self) setTitle: (coerce-arg value)))
(define (nsbutton-tool-tip self)
  (wrap-objc-object
   (tell (coerce-arg self) toolTip)))
(define (nsbutton-set-tool-tip! self value)
  (tell #:type _void (coerce-arg self) setToolTip: (coerce-arg value)))
(define (nsbutton-top-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) topAnchor)))
(define (nsbutton-touch-bar self)
  (wrap-objc-object
   (tell (coerce-arg self) touchBar)))
(define (nsbutton-set-touch-bar! self value)
  (tell #:type _void (coerce-arg self) setTouchBar: (coerce-arg value)))
(define (nsbutton-tracking-areas self)
  (wrap-objc-object
   (tell (coerce-arg self) trackingAreas)))
(define (nsbutton-trailing-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) trailingAnchor)))
(define (nsbutton-translates-autoresizing-mask-into-constraints self)
  (tell #:type _bool (coerce-arg self) translatesAutoresizingMaskIntoConstraints))
(define (nsbutton-set-translates-autoresizing-mask-into-constraints! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setTranslatesAutoresizingMaskIntoConstraints:") value))
(define (nsbutton-transparent self)
  (tell #:type _bool (coerce-arg self) transparent))
(define (nsbutton-set-transparent! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setTransparent:") value))
(define (nsbutton-undo-manager self)
  (wrap-objc-object
   (tell (coerce-arg self) undoManager)))
(define (nsbutton-user-activity self)
  (wrap-objc-object
   (tell (coerce-arg self) userActivity)))
(define (nsbutton-set-user-activity! self value)
  (tell #:type _void (coerce-arg self) setUserActivity: (coerce-arg value)))
(define (nsbutton-user-interface-layout-direction self)
  (tell #:type _int64 (coerce-arg self) userInterfaceLayoutDirection))
(define (nsbutton-set-user-interface-layout-direction! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setUserInterfaceLayoutDirection:") value))
(define (nsbutton-uses-single-line-mode self)
  (tell #:type _bool (coerce-arg self) usesSingleLineMode))
(define (nsbutton-set-uses-single-line-mode! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setUsesSingleLineMode:") value))
(define (nsbutton-vertical-content-size-constraint-active self)
  (tell #:type _bool (coerce-arg self) verticalContentSizeConstraintActive))
(define (nsbutton-set-vertical-content-size-constraint-active! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setVerticalContentSizeConstraintActive:") value))
(define (nsbutton-visible-rect self)
  (tell #:type _NSRect (coerce-arg self) visibleRect))
(define (nsbutton-wants-best-resolution-open-gl-surface self)
  (tell #:type _bool (coerce-arg self) wantsBestResolutionOpenGLSurface))
(define (nsbutton-set-wants-best-resolution-open-gl-surface! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setWantsBestResolutionOpenGLSurface:") value))
(define (nsbutton-wants-default-clipping self)
  (tell #:type _bool (coerce-arg self) wantsDefaultClipping))
(define (nsbutton-wants-extended-dynamic-range-open-gl-surface self)
  (tell #:type _bool (coerce-arg self) wantsExtendedDynamicRangeOpenGLSurface))
(define (nsbutton-set-wants-extended-dynamic-range-open-gl-surface! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setWantsExtendedDynamicRangeOpenGLSurface:") value))
(define (nsbutton-wants-layer self)
  (tell #:type _bool (coerce-arg self) wantsLayer))
(define (nsbutton-set-wants-layer! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setWantsLayer:") value))
(define (nsbutton-wants-resting-touches self)
  (tell #:type _bool (coerce-arg self) wantsRestingTouches))
(define (nsbutton-set-wants-resting-touches! self value)
  (_msg-27 (coerce-arg self) (sel_registerName "setWantsRestingTouches:") value))
(define (nsbutton-wants-update-layer self)
  (tell #:type _bool (coerce-arg self) wantsUpdateLayer))
(define (nsbutton-width-adjust-limit self)
  (tell #:type _double (coerce-arg self) widthAdjustLimit))
(define (nsbutton-width-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) widthAnchor)))
(define (nsbutton-window self)
  (wrap-objc-object
   (tell (coerce-arg self) window)))
(define (nsbutton-writing-tools-coordinator self)
  (wrap-objc-object
   (tell (coerce-arg self) writingToolsCoordinator)))
(define (nsbutton-set-writing-tools-coordinator! self value)
  (tell #:type _void (coerce-arg self) setWritingToolsCoordinator: (coerce-arg value)))

;; --- Instance methods ---
(define (nsbutton-accepts-first-mouse self event)
  (_msg-32 (coerce-arg self) (sel_registerName "acceptsFirstMouse:") (coerce-arg event)))
(define (nsbutton-add-subview! self view)
  (tell #:type _void (coerce-arg self) addSubview: (coerce-arg view)))
(define (nsbutton-add-subview-positioned-relative-to! self view place other-view)
  (_msg-35 (coerce-arg self) (sel_registerName "addSubview:positioned:relativeTo:") (coerce-arg view) place (coerce-arg other-view)))
(define (nsbutton-add-tool-tip-rect-owner-user-data! self rect owner data)
  (_msg-22 (coerce-arg self) (sel_registerName "addToolTipRect:owner:userData:") rect (coerce-arg owner) data))
(define (nsbutton-adjust-scroll self new-visible)
  (_msg-15 (coerce-arg self) (sel_registerName "adjustScroll:") new-visible))
(define (nsbutton-ancestor-shared-with-view self view)
  (wrap-objc-object
   (tell (coerce-arg self) ancestorSharedWithView: (coerce-arg view))))
(define (nsbutton-autoscroll self event)
  (_msg-32 (coerce-arg self) (sel_registerName "autoscroll:") (coerce-arg event)))
(define (nsbutton-backing-aligned-rect-options self rect options)
  (_msg-23 (coerce-arg self) (sel_registerName "backingAlignedRect:options:") rect options))
(define (nsbutton-become-first-responder self)
  (_msg-1 (coerce-arg self) (sel_registerName "becomeFirstResponder")))
(define (nsbutton-begin-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) beginGestureWithEvent: (coerce-arg event)))
(define (nsbutton-bitmap-image-rep-for-caching-display-in-rect self rect)
  (wrap-objc-object
   (_msg-17 (coerce-arg self) (sel_registerName "bitmapImageRepForCachingDisplayInRect:") rect)
   ))
(define (nsbutton-cache-display-in-rect-to-bitmap-image-rep self rect bitmap-image-rep)
  (_msg-21 (coerce-arg self) (sel_registerName "cacheDisplayInRect:toBitmapImageRep:") rect (coerce-arg bitmap-image-rep)))
(define (nsbutton-center-scan-rect! self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "centerScanRect:") rect))
(define (nsbutton-change-mode-with-event self event)
  (tell #:type _void (coerce-arg self) changeModeWithEvent: (coerce-arg event)))
(define (nsbutton-compress-with-prioritized-compression-options self prioritized-options)
  (tell #:type _void (coerce-arg self) compressWithPrioritizedCompressionOptions: (coerce-arg prioritized-options)))
(define (nsbutton-context-menu-key-down self event)
  (tell #:type _void (coerce-arg self) contextMenuKeyDown: (coerce-arg event)))
(define (nsbutton-convert-point-from-view self point view)
  (_msg-14 (coerce-arg self) (sel_registerName "convertPoint:fromView:") point (coerce-arg view)))
(define (nsbutton-convert-point-to-view self point view)
  (_msg-14 (coerce-arg self) (sel_registerName "convertPoint:toView:") point (coerce-arg view)))
(define (nsbutton-convert-point-from-backing self point)
  (_msg-9 (coerce-arg self) (sel_registerName "convertPointFromBacking:") point))
(define (nsbutton-convert-point-from-layer self point)
  (_msg-9 (coerce-arg self) (sel_registerName "convertPointFromLayer:") point))
(define (nsbutton-convert-point-to-backing self point)
  (_msg-9 (coerce-arg self) (sel_registerName "convertPointToBacking:") point))
(define (nsbutton-convert-point-to-layer self point)
  (_msg-9 (coerce-arg self) (sel_registerName "convertPointToLayer:") point))
(define (nsbutton-convert-rect-from-view self rect view)
  (_msg-20 (coerce-arg self) (sel_registerName "convertRect:fromView:") rect (coerce-arg view)))
(define (nsbutton-convert-rect-to-view self rect view)
  (_msg-20 (coerce-arg self) (sel_registerName "convertRect:toView:") rect (coerce-arg view)))
(define (nsbutton-convert-rect-from-backing self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "convertRectFromBacking:") rect))
(define (nsbutton-convert-rect-from-layer self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "convertRectFromLayer:") rect))
(define (nsbutton-convert-rect-to-backing self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "convertRectToBacking:") rect))
(define (nsbutton-convert-rect-to-layer self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "convertRectToLayer:") rect))
(define (nsbutton-convert-size-from-view self size view)
  (_msg-26 (coerce-arg self) (sel_registerName "convertSize:fromView:") size (coerce-arg view)))
(define (nsbutton-convert-size-to-view self size view)
  (_msg-26 (coerce-arg self) (sel_registerName "convertSize:toView:") size (coerce-arg view)))
(define (nsbutton-convert-size-from-backing self size)
  (_msg-24 (coerce-arg self) (sel_registerName "convertSizeFromBacking:") size))
(define (nsbutton-convert-size-from-layer self size)
  (_msg-24 (coerce-arg self) (sel_registerName "convertSizeFromLayer:") size))
(define (nsbutton-convert-size-to-backing self size)
  (_msg-24 (coerce-arg self) (sel_registerName "convertSizeToBacking:") size))
(define (nsbutton-convert-size-to-layer self size)
  (_msg-24 (coerce-arg self) (sel_registerName "convertSizeToLayer:") size))
(define (nsbutton-cursor-update self event)
  (tell #:type _void (coerce-arg self) cursorUpdate: (coerce-arg event)))
(define (nsbutton-did-add-subview self subview)
  (tell #:type _void (coerce-arg self) didAddSubview: (coerce-arg subview)))
(define (nsbutton-did-close-menu-with-event self menu event)
  (tell #:type _void (coerce-arg self) didCloseMenu: (coerce-arg menu) withEvent: (coerce-arg event)))
(define (nsbutton-display! self)
  (tell #:type _void (coerce-arg self) display))
(define (nsbutton-display-if-needed! self)
  (tell #:type _void (coerce-arg self) displayIfNeeded))
(define (nsbutton-display-if-needed-ignoring-opacity! self)
  (tell #:type _void (coerce-arg self) displayIfNeededIgnoringOpacity))
(define (nsbutton-display-if-needed-in-rect! self rect)
  (_msg-18 (coerce-arg self) (sel_registerName "displayIfNeededInRect:") rect))
(define (nsbutton-display-if-needed-in-rect-ignoring-opacity! self rect)
  (_msg-18 (coerce-arg self) (sel_registerName "displayIfNeededInRectIgnoringOpacity:") rect))
(define (nsbutton-display-rect! self rect)
  (_msg-18 (coerce-arg self) (sel_registerName "displayRect:") rect))
(define (nsbutton-display-rect-ignoring-opacity! self rect)
  (_msg-18 (coerce-arg self) (sel_registerName "displayRectIgnoringOpacity:") rect))
(define (nsbutton-display-rect-ignoring-opacity-in-context! self rect context)
  (_msg-21 (coerce-arg self) (sel_registerName "displayRectIgnoringOpacity:inContext:") rect (coerce-arg context)))
(define (nsbutton-draw-rect self dirty-rect)
  (_msg-18 (coerce-arg self) (sel_registerName "drawRect:") dirty-rect))
(define (nsbutton-draw-with-expansion-frame-in-view self content-frame view)
  (_msg-21 (coerce-arg self) (sel_registerName "drawWithExpansionFrame:inView:") content-frame (coerce-arg view)))
(define (nsbutton-end-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) endGestureWithEvent: (coerce-arg event)))
(define (nsbutton-expansion-frame-with-frame self content-frame)
  (_msg-15 (coerce-arg self) (sel_registerName "expansionFrameWithFrame:") content-frame))
(define (nsbutton-flags-changed self event)
  (tell #:type _void (coerce-arg self) flagsChanged: (coerce-arg event)))
(define (nsbutton-flush-buffered-key-events self)
  (tell #:type _void (coerce-arg self) flushBufferedKeyEvents))
(define (nsbutton-get-periodic-delay-interval self delay interval)
  (_msg-43 (coerce-arg self) (sel_registerName "getPeriodicDelay:interval:") delay interval))
(define (nsbutton-get-rects-being-drawn-count self rects count)
  (_msg-43 (coerce-arg self) (sel_registerName "getRectsBeingDrawn:count:") rects count))
(define (nsbutton-get-rects-exposed-during-live-resize-count self exposed-rects count)
  (_msg-43 (coerce-arg self) (sel_registerName "getRectsExposedDuringLiveResize:count:") exposed-rects count))
(define (nsbutton-help-requested self event-ptr)
  (tell #:type _void (coerce-arg self) helpRequested: (coerce-arg event-ptr)))
(define (nsbutton-highlight self flag)
  (_msg-27 (coerce-arg self) (sel_registerName "highlight:") flag))
(define (nsbutton-hit-test self point)
  (wrap-objc-object
   (_msg-10 (coerce-arg self) (sel_registerName "hitTest:") point)
   ))
(define (nsbutton-interpret-key-events self event-array)
  (tell #:type _void (coerce-arg self) interpretKeyEvents: (coerce-arg event-array)))
(define (nsbutton-is-bordered self)
  (_msg-1 (coerce-arg self) (sel_registerName "isBordered")))
(define (nsbutton-is-continuous self)
  (_msg-1 (coerce-arg self) (sel_registerName "isContinuous")))
(define (nsbutton-is-descendant-of self view)
  (_msg-32 (coerce-arg self) (sel_registerName "isDescendantOf:") (coerce-arg view)))
(define (nsbutton-is-enabled self)
  (_msg-1 (coerce-arg self) (sel_registerName "isEnabled")))
(define (nsbutton-is-flipped self)
  (_msg-1 (coerce-arg self) (sel_registerName "isFlipped")))
(define (nsbutton-is-hidden self)
  (_msg-1 (coerce-arg self) (sel_registerName "isHidden")))
(define (nsbutton-is-hidden-or-has-hidden-ancestor self)
  (_msg-1 (coerce-arg self) (sel_registerName "isHiddenOrHasHiddenAncestor")))
(define (nsbutton-is-highlighted self)
  (_msg-1 (coerce-arg self) (sel_registerName "isHighlighted")))
(define (nsbutton-is-opaque self)
  (_msg-1 (coerce-arg self) (sel_registerName "isOpaque")))
(define (nsbutton-is-rotated-from-base self)
  (_msg-1 (coerce-arg self) (sel_registerName "isRotatedFromBase")))
(define (nsbutton-is-rotated-or-scaled-from-base self)
  (_msg-1 (coerce-arg self) (sel_registerName "isRotatedOrScaledFromBase")))
(define (nsbutton-is-spring-loaded self)
  (_msg-1 (coerce-arg self) (sel_registerName "isSpringLoaded")))
(define (nsbutton-is-transparent self)
  (_msg-1 (coerce-arg self) (sel_registerName "isTransparent")))
(define (nsbutton-key-down self event)
  (tell #:type _void (coerce-arg self) keyDown: (coerce-arg event)))
(define (nsbutton-key-up self event)
  (tell #:type _void (coerce-arg self) keyUp: (coerce-arg event)))
(define (nsbutton-layout self)
  (tell #:type _void (coerce-arg self) layout))
(define (nsbutton-layout-subtree-if-needed self)
  (tell #:type _void (coerce-arg self) layoutSubtreeIfNeeded))
(define (nsbutton-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) magnifyWithEvent: (coerce-arg event)))
(define (nsbutton-make-backing-layer self)
  (wrap-objc-object
   (tell (coerce-arg self) makeBackingLayer)))
(define (nsbutton-menu-for-event self event)
  (wrap-objc-object
   (tell (coerce-arg self) menuForEvent: (coerce-arg event))))
(define (nsbutton-minimum-size-with-prioritized-compression-options self prioritized-options)
  (_msg-31 (coerce-arg self) (sel_registerName "minimumSizeWithPrioritizedCompressionOptions:") (coerce-arg prioritized-options)))
(define (nsbutton-mouse-in-rect self point rect)
  (_msg-13 (coerce-arg self) (sel_registerName "mouse:inRect:") point rect))
(define (nsbutton-mouse-cancelled self event)
  (tell #:type _void (coerce-arg self) mouseCancelled: (coerce-arg event)))
(define (nsbutton-mouse-down self event)
  (tell #:type _void (coerce-arg self) mouseDown: (coerce-arg event)))
(define (nsbutton-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) mouseDragged: (coerce-arg event)))
(define (nsbutton-mouse-entered self event)
  (tell #:type _void (coerce-arg self) mouseEntered: (coerce-arg event)))
(define (nsbutton-mouse-exited self event)
  (tell #:type _void (coerce-arg self) mouseExited: (coerce-arg event)))
(define (nsbutton-mouse-moved self event)
  (tell #:type _void (coerce-arg self) mouseMoved: (coerce-arg event)))
(define (nsbutton-mouse-up self event)
  (tell #:type _void (coerce-arg self) mouseUp: (coerce-arg event)))
(define (nsbutton-needs-to-draw-rect self rect)
  (_msg-16 (coerce-arg self) (sel_registerName "needsToDrawRect:") rect))
(define (nsbutton-no-responder-for self event-selector)
  (_msg-40 (coerce-arg self) (sel_registerName "noResponderFor:") (sel_registerName event-selector)))
(define (nsbutton-other-mouse-down self event)
  (tell #:type _void (coerce-arg self) otherMouseDown: (coerce-arg event)))
(define (nsbutton-other-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) otherMouseDragged: (coerce-arg event)))
(define (nsbutton-other-mouse-up self event)
  (tell #:type _void (coerce-arg self) otherMouseUp: (coerce-arg event)))
(define (nsbutton-perform-click! self sender)
  (tell #:type _void (coerce-arg self) performClick: (coerce-arg sender)))
(define (nsbutton-perform-key-equivalent! self key)
  (_msg-32 (coerce-arg self) (sel_registerName "performKeyEquivalent:") (coerce-arg key)))
(define (nsbutton-prepare-content-in-rect self rect)
  (_msg-18 (coerce-arg self) (sel_registerName "prepareContentInRect:") rect))
(define (nsbutton-prepare-for-reuse self)
  (tell #:type _void (coerce-arg self) prepareForReuse))
(define (nsbutton-pressure-change-with-event self event)
  (tell #:type _void (coerce-arg self) pressureChangeWithEvent: (coerce-arg event)))
(define (nsbutton-quick-look-with-event self event)
  (tell #:type _void (coerce-arg self) quickLookWithEvent: (coerce-arg event)))
(define (nsbutton-rect-for-smart-magnification-at-point-in-rect self location visible-rect)
  (_msg-12 (coerce-arg self) (sel_registerName "rectForSmartMagnificationAtPoint:inRect:") location visible-rect))
(define (nsbutton-remove-all-tool-tips! self)
  (tell #:type _void (coerce-arg self) removeAllToolTips))
(define (nsbutton-remove-from-superview! self)
  (tell #:type _void (coerce-arg self) removeFromSuperview))
(define (nsbutton-remove-from-superview-without-needing-display! self)
  (tell #:type _void (coerce-arg self) removeFromSuperviewWithoutNeedingDisplay))
(define (nsbutton-remove-tool-tip! self tag)
  (_msg-39 (coerce-arg self) (sel_registerName "removeToolTip:") tag))
(define (nsbutton-replace-subview-with! self old-view new-view)
  (tell #:type _void (coerce-arg self) replaceSubview: (coerce-arg old-view) with: (coerce-arg new-view)))
(define (nsbutton-resign-first-responder self)
  (_msg-1 (coerce-arg self) (sel_registerName "resignFirstResponder")))
(define (nsbutton-resize-subviews-with-old-size self old-size)
  (_msg-25 (coerce-arg self) (sel_registerName "resizeSubviewsWithOldSize:") old-size))
(define (nsbutton-resize-with-old-superview-size self old-size)
  (_msg-25 (coerce-arg self) (sel_registerName "resizeWithOldSuperviewSize:") old-size))
(define (nsbutton-right-mouse-down self event)
  (tell #:type _void (coerce-arg self) rightMouseDown: (coerce-arg event)))
(define (nsbutton-right-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) rightMouseDragged: (coerce-arg event)))
(define (nsbutton-right-mouse-up self event)
  (tell #:type _void (coerce-arg self) rightMouseUp: (coerce-arg event)))
(define (nsbutton-rotate-by-angle self angle)
  (_msg-28 (coerce-arg self) (sel_registerName "rotateByAngle:") angle))
(define (nsbutton-rotate-with-event self event)
  (tell #:type _void (coerce-arg self) rotateWithEvent: (coerce-arg event)))
(define (nsbutton-scale-unit-square-to-size self new-unit-size)
  (_msg-25 (coerce-arg self) (sel_registerName "scaleUnitSquareToSize:") new-unit-size))
(define (nsbutton-scroll-point self point)
  (_msg-11 (coerce-arg self) (sel_registerName "scrollPoint:") point))
(define (nsbutton-scroll-rect-to-visible self rect)
  (_msg-16 (coerce-arg self) (sel_registerName "scrollRectToVisible:") rect))
(define (nsbutton-scroll-wheel self event)
  (tell #:type _void (coerce-arg self) scrollWheel: (coerce-arg event)))
(define (nsbutton-send-action-to self action target)
  (_msg-41 (coerce-arg self) (sel_registerName "sendAction:to:") (sel_registerName action) (coerce-arg target)))
(define (nsbutton-send-action-on self mask)
  (_msg-44 (coerce-arg self) (sel_registerName "sendActionOn:") mask))
(define (nsbutton-set-bounds-origin! self new-origin)
  (_msg-11 (coerce-arg self) (sel_registerName "setBoundsOrigin:") new-origin))
(define (nsbutton-set-bounds-size! self new-size)
  (_msg-25 (coerce-arg self) (sel_registerName "setBoundsSize:") new-size))
(define (nsbutton-set-button-type! self type)
  (_msg-45 (coerce-arg self) (sel_registerName "setButtonType:") type))
(define (nsbutton-set-frame-origin! self new-origin)
  (_msg-11 (coerce-arg self) (sel_registerName "setFrameOrigin:") new-origin))
(define (nsbutton-set-frame-size! self new-size)
  (_msg-25 (coerce-arg self) (sel_registerName "setFrameSize:") new-size))
(define (nsbutton-set-needs-display-in-rect! self invalid-rect)
  (_msg-18 (coerce-arg self) (sel_registerName "setNeedsDisplayInRect:") invalid-rect))
(define (nsbutton-set-next-state! self)
  (tell #:type _void (coerce-arg self) setNextState))
(define (nsbutton-set-periodic-delay-interval! self delay interval)
  (_msg-30 (coerce-arg self) (sel_registerName "setPeriodicDelay:interval:") delay interval))
(define (nsbutton-should-be-treated-as-ink-event self event)
  (_msg-32 (coerce-arg self) (sel_registerName "shouldBeTreatedAsInkEvent:") (coerce-arg event)))
(define (nsbutton-should-delay-window-ordering-for-event self event)
  (_msg-32 (coerce-arg self) (sel_registerName "shouldDelayWindowOrderingForEvent:") (coerce-arg event)))
(define (nsbutton-show-context-help self sender)
  (tell #:type _void (coerce-arg self) showContextHelp: (coerce-arg sender)))
(define (nsbutton-size-that-fits self size)
  (_msg-24 (coerce-arg self) (sel_registerName "sizeThatFits:") size))
(define (nsbutton-size-to-fit self)
  (tell #:type _void (coerce-arg self) sizeToFit))
(define (nsbutton-smart-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) smartMagnifyWithEvent: (coerce-arg event)))
(define (nsbutton-sort-subviews-using-function-context self compare context)
  (_msg-43 (coerce-arg self) (sel_registerName "sortSubviewsUsingFunction:context:") compare context))
(define (nsbutton-supplemental-target-for-action-sender self action sender)
  (wrap-objc-object
   (_msg-42 (coerce-arg self) (sel_registerName "supplementalTargetForAction:sender:") (sel_registerName action) (coerce-arg sender))
   ))
(define (nsbutton-swipe-with-event self event)
  (tell #:type _void (coerce-arg self) swipeWithEvent: (coerce-arg event)))
(define (nsbutton-tablet-point self event)
  (tell #:type _void (coerce-arg self) tabletPoint: (coerce-arg event)))
(define (nsbutton-tablet-proximity self event)
  (tell #:type _void (coerce-arg self) tabletProximity: (coerce-arg event)))
(define (nsbutton-take-double-value-from self sender)
  (tell #:type _void (coerce-arg self) takeDoubleValueFrom: (coerce-arg sender)))
(define (nsbutton-take-float-value-from self sender)
  (tell #:type _void (coerce-arg self) takeFloatValueFrom: (coerce-arg sender)))
(define (nsbutton-take-int-value-from self sender)
  (tell #:type _void (coerce-arg self) takeIntValueFrom: (coerce-arg sender)))
(define (nsbutton-take-integer-value-from self sender)
  (tell #:type _void (coerce-arg self) takeIntegerValueFrom: (coerce-arg sender)))
(define (nsbutton-take-object-value-from self sender)
  (tell #:type _void (coerce-arg self) takeObjectValueFrom: (coerce-arg sender)))
(define (nsbutton-take-string-value-from self sender)
  (tell #:type _void (coerce-arg self) takeStringValueFrom: (coerce-arg sender)))
(define (nsbutton-touches-began-with-event self event)
  (tell #:type _void (coerce-arg self) touchesBeganWithEvent: (coerce-arg event)))
(define (nsbutton-touches-cancelled-with-event self event)
  (tell #:type _void (coerce-arg self) touchesCancelledWithEvent: (coerce-arg event)))
(define (nsbutton-touches-ended-with-event self event)
  (tell #:type _void (coerce-arg self) touchesEndedWithEvent: (coerce-arg event)))
(define (nsbutton-touches-moved-with-event self event)
  (tell #:type _void (coerce-arg self) touchesMovedWithEvent: (coerce-arg event)))
(define (nsbutton-translate-origin-to-point self translation)
  (_msg-11 (coerce-arg self) (sel_registerName "translateOriginToPoint:") translation))
(define (nsbutton-translate-rects-needing-display-in-rect-by self clip-rect delta)
  (_msg-19 (coerce-arg self) (sel_registerName "translateRectsNeedingDisplayInRect:by:") clip-rect delta))
(define (nsbutton-try-to-perform-with self action object)
  (_msg-41 (coerce-arg self) (sel_registerName "tryToPerform:with:") (sel_registerName action) (coerce-arg object)))
(define (nsbutton-update-layer self)
  (tell #:type _void (coerce-arg self) updateLayer))
(define (nsbutton-valid-requestor-for-send-type-return-type self send-type return-type)
  (wrap-objc-object
   (tell (coerce-arg self) validRequestorForSendType: (coerce-arg send-type) returnType: (coerce-arg return-type))))
(define (nsbutton-view-did-change-backing-properties self)
  (tell #:type _void (coerce-arg self) viewDidChangeBackingProperties))
(define (nsbutton-view-did-change-effective-appearance self)
  (tell #:type _void (coerce-arg self) viewDidChangeEffectiveAppearance))
(define (nsbutton-view-did-end-live-resize self)
  (tell #:type _void (coerce-arg self) viewDidEndLiveResize))
(define (nsbutton-view-did-hide self)
  (tell #:type _void (coerce-arg self) viewDidHide))
(define (nsbutton-view-did-move-to-superview self)
  (tell #:type _void (coerce-arg self) viewDidMoveToSuperview))
(define (nsbutton-view-did-move-to-window self)
  (tell #:type _void (coerce-arg self) viewDidMoveToWindow))
(define (nsbutton-view-did-unhide self)
  (tell #:type _void (coerce-arg self) viewDidUnhide))
(define (nsbutton-view-will-draw self)
  (tell #:type _void (coerce-arg self) viewWillDraw))
(define (nsbutton-view-will-move-to-superview self new-superview)
  (tell #:type _void (coerce-arg self) viewWillMoveToSuperview: (coerce-arg new-superview)))
(define (nsbutton-view-will-move-to-window self new-window)
  (tell #:type _void (coerce-arg self) viewWillMoveToWindow: (coerce-arg new-window)))
(define (nsbutton-view-will-start-live-resize self)
  (tell #:type _void (coerce-arg self) viewWillStartLiveResize))
(define (nsbutton-view-with-tag self tag)
  (wrap-objc-object
   (_msg-38 (coerce-arg self) (sel_registerName "viewWithTag:") tag)
   ))
(define (nsbutton-wants-forwarded-scroll-events-for-axis self axis)
  (_msg-37 (coerce-arg self) (sel_registerName "wantsForwardedScrollEventsForAxis:") axis))
(define (nsbutton-wants-scroll-events-for-swipe-tracking-on-axis self axis)
  (_msg-37 (coerce-arg self) (sel_registerName "wantsScrollEventsForSwipeTrackingOnAxis:") axis))
(define (nsbutton-will-open-menu-with-event self menu event)
  (tell #:type _void (coerce-arg self) willOpenMenu: (coerce-arg menu) withEvent: (coerce-arg event)))
(define (nsbutton-will-remove-subview self subview)
  (tell #:type _void (coerce-arg self) willRemoveSubview: (coerce-arg subview)))

;; --- Class methods ---
(define (nsbutton-button-with-image-target-action image target action)
  (wrap-objc-object
   (_msg-34 NSButton (sel_registerName "buttonWithImage:target:action:") (coerce-arg image) (coerce-arg target) (sel_registerName action))
   ))
(define (nsbutton-button-with-title-image-target-action title image target action)
  (wrap-objc-object
   (_msg-33 NSButton (sel_registerName "buttonWithTitle:image:target:action:") (coerce-arg title) (coerce-arg image) (coerce-arg target) (sel_registerName action))
   ))
(define (nsbutton-button-with-title-target-action title target action)
  (wrap-objc-object
   (_msg-34 NSButton (sel_registerName "buttonWithTitle:target:action:") (coerce-arg title) (coerce-arg target) (sel_registerName action))
   ))
(define (nsbutton-checkbox-with-title-target-action title target action)
  (wrap-objc-object
   (_msg-34 NSButton (sel_registerName "checkboxWithTitle:target:action:") (coerce-arg title) (coerce-arg target) (sel_registerName action))
   ))
(define (nsbutton-is-compatible-with-responsive-scrolling)
  (_msg-1 NSButton (sel_registerName "isCompatibleWithResponsiveScrolling")))
(define (nsbutton-radio-button-with-title-target-action title target action)
  (wrap-objc-object
   (_msg-34 NSButton (sel_registerName "radioButtonWithTitle:target:action:") (coerce-arg title) (coerce-arg target) (sel_registerName action))
   ))
