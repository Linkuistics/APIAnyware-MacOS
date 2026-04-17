#lang racket/base
;; Generated binding for NSSplitView (AppKit)
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
(define (nsstring? v) (objc-instance-of? v "NSString"))
(define (nstextinputcontext? v) (objc-instance-of? v "NSTextInputContext"))
(define (nstouchbar? v) (objc-instance-of? v "NSTouchBar"))
(define (nsundomanager? v) (objc-instance-of? v "NSUndoManager"))
(define (nsuseractivity? v) (objc-instance-of? v "NSUserActivity"))
(define (nsview? v) (objc-instance-of? v "NSView"))
(define (nswindow? v) (objc-instance-of? v "NSWindow"))
(define (nswritingtoolscoordinator? v) (objc-instance-of? v "NSWritingToolsCoordinator"))
(provide NSSplitView)
(provide/contract
  [make-nssplitview-init-with-coder (c-> (or/c string? objc-object? #f) any/c)]
  [make-nssplitview-init-with-frame (c-> any/c any/c)]
  [nssplitview-accepts-first-responder (c-> objc-object? boolean?)]
  [nssplitview-accepts-touch-events (c-> objc-object? boolean?)]
  [nssplitview-set-accepts-touch-events! (c-> objc-object? boolean? void?)]
  [nssplitview-additional-safe-area-insets (c-> objc-object? any/c)]
  [nssplitview-set-additional-safe-area-insets! (c-> objc-object? any/c void?)]
  [nssplitview-alignment-rect-insets (c-> objc-object? any/c)]
  [nssplitview-allowed-touch-types (c-> objc-object? exact-nonnegative-integer?)]
  [nssplitview-set-allowed-touch-types! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nssplitview-allows-vibrancy (c-> objc-object? boolean?)]
  [nssplitview-alpha-value (c-> objc-object? real?)]
  [nssplitview-set-alpha-value! (c-> objc-object? real? void?)]
  [nssplitview-arranged-subviews (c-> objc-object? any/c)]
  [nssplitview-arranges-all-subviews (c-> objc-object? boolean?)]
  [nssplitview-set-arranges-all-subviews! (c-> objc-object? boolean? void?)]
  [nssplitview-autoresizes-subviews (c-> objc-object? boolean?)]
  [nssplitview-set-autoresizes-subviews! (c-> objc-object? boolean? void?)]
  [nssplitview-autoresizing-mask (c-> objc-object? exact-nonnegative-integer?)]
  [nssplitview-set-autoresizing-mask! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nssplitview-autosave-name (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nssplitview-set-autosave-name! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-background-filters (c-> objc-object? any/c)]
  [nssplitview-set-background-filters! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-baseline-offset-from-bottom (c-> objc-object? real?)]
  [nssplitview-bottom-anchor (c-> objc-object? (or/c nslayoutyaxisanchor? objc-nil?))]
  [nssplitview-bounds (c-> objc-object? any/c)]
  [nssplitview-set-bounds! (c-> objc-object? any/c void?)]
  [nssplitview-bounds-rotation (c-> objc-object? real?)]
  [nssplitview-set-bounds-rotation! (c-> objc-object? real? void?)]
  [nssplitview-can-become-key-view (c-> objc-object? boolean?)]
  [nssplitview-can-draw (c-> objc-object? boolean?)]
  [nssplitview-can-draw-concurrently (c-> objc-object? boolean?)]
  [nssplitview-set-can-draw-concurrently! (c-> objc-object? boolean? void?)]
  [nssplitview-can-draw-subviews-into-layer (c-> objc-object? boolean?)]
  [nssplitview-set-can-draw-subviews-into-layer! (c-> objc-object? boolean? void?)]
  [nssplitview-candidate-list-touch-bar-item (c-> objc-object? (or/c nscandidatelisttouchbaritem? objc-nil?))]
  [nssplitview-center-x-anchor (c-> objc-object? (or/c nslayoutxaxisanchor? objc-nil?))]
  [nssplitview-center-y-anchor (c-> objc-object? (or/c nslayoutyaxisanchor? objc-nil?))]
  [nssplitview-clips-to-bounds (c-> objc-object? boolean?)]
  [nssplitview-set-clips-to-bounds! (c-> objc-object? boolean? void?)]
  [nssplitview-compatible-with-responsive-scrolling (c-> boolean?)]
  [nssplitview-compositing-filter (c-> objc-object? (or/c cifilter? objc-nil?))]
  [nssplitview-set-compositing-filter! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-constraints (c-> objc-object? any/c)]
  [nssplitview-content-filters (c-> objc-object? any/c)]
  [nssplitview-set-content-filters! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-default-focus-ring-type (c-> exact-nonnegative-integer?)]
  [nssplitview-default-menu (c-> (or/c nsmenu? objc-nil?))]
  [nssplitview-delegate (c-> objc-object? any/c)]
  [nssplitview-set-delegate! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-divider-color (c-> objc-object? (or/c nscolor? objc-nil?))]
  [nssplitview-divider-style (c-> objc-object? exact-nonnegative-integer?)]
  [nssplitview-set-divider-style! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nssplitview-divider-thickness (c-> objc-object? real?)]
  [nssplitview-drawing-find-indicator (c-> objc-object? boolean?)]
  [nssplitview-enclosing-menu-item (c-> objc-object? (or/c nsmenuitem? objc-nil?))]
  [nssplitview-enclosing-scroll-view (c-> objc-object? (or/c nsscrollview? objc-nil?))]
  [nssplitview-first-baseline-anchor (c-> objc-object? (or/c nslayoutyaxisanchor? objc-nil?))]
  [nssplitview-first-baseline-offset-from-top (c-> objc-object? real?)]
  [nssplitview-fitting-size (c-> objc-object? any/c)]
  [nssplitview-flipped (c-> objc-object? boolean?)]
  [nssplitview-focus-ring-mask-bounds (c-> objc-object? any/c)]
  [nssplitview-focus-ring-type (c-> objc-object? exact-nonnegative-integer?)]
  [nssplitview-set-focus-ring-type! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nssplitview-focus-view (c-> (or/c nsview? objc-nil?))]
  [nssplitview-frame (c-> objc-object? any/c)]
  [nssplitview-set-frame! (c-> objc-object? any/c void?)]
  [nssplitview-frame-center-rotation (c-> objc-object? real?)]
  [nssplitview-set-frame-center-rotation! (c-> objc-object? real? void?)]
  [nssplitview-frame-rotation (c-> objc-object? real?)]
  [nssplitview-set-frame-rotation! (c-> objc-object? real? void?)]
  [nssplitview-gesture-recognizers (c-> objc-object? any/c)]
  [nssplitview-set-gesture-recognizers! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-has-ambiguous-layout (c-> objc-object? boolean?)]
  [nssplitview-height-adjust-limit (c-> objc-object? real?)]
  [nssplitview-height-anchor (c-> objc-object? (or/c nslayoutdimension? objc-nil?))]
  [nssplitview-hidden (c-> objc-object? boolean?)]
  [nssplitview-set-hidden! (c-> objc-object? boolean? void?)]
  [nssplitview-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nssplitview-horizontal-content-size-constraint-active (c-> objc-object? boolean?)]
  [nssplitview-set-horizontal-content-size-constraint-active! (c-> objc-object? boolean? void?)]
  [nssplitview-in-full-screen-mode (c-> objc-object? boolean?)]
  [nssplitview-in-live-resize (c-> objc-object? boolean?)]
  [nssplitview-input-context (c-> objc-object? (or/c nstextinputcontext? objc-nil?))]
  [nssplitview-intrinsic-content-size (c-> objc-object? any/c)]
  [nssplitview-last-baseline-anchor (c-> objc-object? (or/c nslayoutyaxisanchor? objc-nil?))]
  [nssplitview-last-baseline-offset-from-bottom (c-> objc-object? real?)]
  [nssplitview-layer (c-> objc-object? (or/c calayer? objc-nil?))]
  [nssplitview-set-layer! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-layer-contents-placement (c-> objc-object? exact-nonnegative-integer?)]
  [nssplitview-set-layer-contents-placement! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nssplitview-layer-contents-redraw-policy (c-> objc-object? exact-nonnegative-integer?)]
  [nssplitview-set-layer-contents-redraw-policy! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nssplitview-layer-uses-core-image-filters (c-> objc-object? boolean?)]
  [nssplitview-set-layer-uses-core-image-filters! (c-> objc-object? boolean? void?)]
  [nssplitview-layout-guides (c-> objc-object? any/c)]
  [nssplitview-layout-margins-guide (c-> objc-object? (or/c nslayoutguide? objc-nil?))]
  [nssplitview-leading-anchor (c-> objc-object? (or/c nslayoutxaxisanchor? objc-nil?))]
  [nssplitview-left-anchor (c-> objc-object? (or/c nslayoutxaxisanchor? objc-nil?))]
  [nssplitview-menu (c-> objc-object? (or/c nsmenu? objc-nil?))]
  [nssplitview-set-menu! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-mouse-down-can-move-window (c-> objc-object? boolean?)]
  [nssplitview-needs-display (c-> objc-object? boolean?)]
  [nssplitview-set-needs-display! (c-> objc-object? boolean? void?)]
  [nssplitview-needs-layout (c-> objc-object? boolean?)]
  [nssplitview-set-needs-layout! (c-> objc-object? boolean? void?)]
  [nssplitview-needs-panel-to-become-key (c-> objc-object? boolean?)]
  [nssplitview-needs-update-constraints (c-> objc-object? boolean?)]
  [nssplitview-set-needs-update-constraints! (c-> objc-object? boolean? void?)]
  [nssplitview-next-key-view (c-> objc-object? (or/c nsview? objc-nil?))]
  [nssplitview-set-next-key-view! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-next-responder (c-> objc-object? (or/c nsresponder? objc-nil?))]
  [nssplitview-set-next-responder! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-next-valid-key-view (c-> objc-object? (or/c nsview? objc-nil?))]
  [nssplitview-opaque (c-> objc-object? boolean?)]
  [nssplitview-opaque-ancestor (c-> objc-object? (or/c nsview? objc-nil?))]
  [nssplitview-page-footer (c-> objc-object? (or/c nsattributedstring? objc-nil?))]
  [nssplitview-page-header (c-> objc-object? (or/c nsattributedstring? objc-nil?))]
  [nssplitview-posts-bounds-changed-notifications (c-> objc-object? boolean?)]
  [nssplitview-set-posts-bounds-changed-notifications! (c-> objc-object? boolean? void?)]
  [nssplitview-posts-frame-changed-notifications (c-> objc-object? boolean?)]
  [nssplitview-set-posts-frame-changed-notifications! (c-> objc-object? boolean? void?)]
  [nssplitview-prefers-compact-control-size-metrics (c-> objc-object? boolean?)]
  [nssplitview-set-prefers-compact-control-size-metrics! (c-> objc-object? boolean? void?)]
  [nssplitview-prepared-content-rect (c-> objc-object? any/c)]
  [nssplitview-set-prepared-content-rect! (c-> objc-object? any/c void?)]
  [nssplitview-preserves-content-during-live-resize (c-> objc-object? boolean?)]
  [nssplitview-pressure-configuration (c-> objc-object? (or/c nspressureconfiguration? objc-nil?))]
  [nssplitview-set-pressure-configuration! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-previous-key-view (c-> objc-object? (or/c nsview? objc-nil?))]
  [nssplitview-previous-valid-key-view (c-> objc-object? (or/c nsview? objc-nil?))]
  [nssplitview-print-job-title (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nssplitview-rect-preserved-during-live-resize (c-> objc-object? any/c)]
  [nssplitview-registered-dragged-types (c-> objc-object? any/c)]
  [nssplitview-requires-constraint-based-layout (c-> boolean?)]
  [nssplitview-restorable-state-key-paths (c-> any/c)]
  [nssplitview-right-anchor (c-> objc-object? (or/c nslayoutxaxisanchor? objc-nil?))]
  [nssplitview-rotated-from-base (c-> objc-object? boolean?)]
  [nssplitview-rotated-or-scaled-from-base (c-> objc-object? boolean?)]
  [nssplitview-safe-area-insets (c-> objc-object? any/c)]
  [nssplitview-safe-area-layout-guide (c-> objc-object? (or/c nslayoutguide? objc-nil?))]
  [nssplitview-safe-area-rect (c-> objc-object? any/c)]
  [nssplitview-shadow (c-> objc-object? (or/c nsshadow? objc-nil?))]
  [nssplitview-set-shadow! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-subviews (c-> objc-object? any/c)]
  [nssplitview-set-subviews! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-superview (c-> objc-object? (or/c nsview? objc-nil?))]
  [nssplitview-tag (c-> objc-object? exact-integer?)]
  [nssplitview-tool-tip (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nssplitview-set-tool-tip! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-top-anchor (c-> objc-object? (or/c nslayoutyaxisanchor? objc-nil?))]
  [nssplitview-touch-bar (c-> objc-object? (or/c nstouchbar? objc-nil?))]
  [nssplitview-set-touch-bar! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-tracking-areas (c-> objc-object? any/c)]
  [nssplitview-trailing-anchor (c-> objc-object? (or/c nslayoutxaxisanchor? objc-nil?))]
  [nssplitview-translates-autoresizing-mask-into-constraints (c-> objc-object? boolean?)]
  [nssplitview-set-translates-autoresizing-mask-into-constraints! (c-> objc-object? boolean? void?)]
  [nssplitview-undo-manager (c-> objc-object? (or/c nsundomanager? objc-nil?))]
  [nssplitview-user-activity (c-> objc-object? (or/c nsuseractivity? objc-nil?))]
  [nssplitview-set-user-activity! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-user-interface-layout-direction (c-> objc-object? exact-nonnegative-integer?)]
  [nssplitview-set-user-interface-layout-direction! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nssplitview-vertical (c-> objc-object? boolean?)]
  [nssplitview-set-vertical! (c-> objc-object? boolean? void?)]
  [nssplitview-vertical-content-size-constraint-active (c-> objc-object? boolean?)]
  [nssplitview-set-vertical-content-size-constraint-active! (c-> objc-object? boolean? void?)]
  [nssplitview-visible-rect (c-> objc-object? any/c)]
  [nssplitview-wants-best-resolution-open-gl-surface (c-> objc-object? boolean?)]
  [nssplitview-set-wants-best-resolution-open-gl-surface! (c-> objc-object? boolean? void?)]
  [nssplitview-wants-default-clipping (c-> objc-object? boolean?)]
  [nssplitview-wants-extended-dynamic-range-open-gl-surface (c-> objc-object? boolean?)]
  [nssplitview-set-wants-extended-dynamic-range-open-gl-surface! (c-> objc-object? boolean? void?)]
  [nssplitview-wants-layer (c-> objc-object? boolean?)]
  [nssplitview-set-wants-layer! (c-> objc-object? boolean? void?)]
  [nssplitview-wants-resting-touches (c-> objc-object? boolean?)]
  [nssplitview-set-wants-resting-touches! (c-> objc-object? boolean? void?)]
  [nssplitview-wants-update-layer (c-> objc-object? boolean?)]
  [nssplitview-width-adjust-limit (c-> objc-object? real?)]
  [nssplitview-width-anchor (c-> objc-object? (or/c nslayoutdimension? objc-nil?))]
  [nssplitview-window (c-> objc-object? (or/c nswindow? objc-nil?))]
  [nssplitview-writing-tools-coordinator (c-> objc-object? (or/c nswritingtoolscoordinator? objc-nil?))]
  [nssplitview-set-writing-tools-coordinator! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-accepts-first-mouse (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nssplitview-add-subview! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-add-subview-positioned-relative-to! (c-> objc-object? (or/c string? objc-object? #f) exact-nonnegative-integer? (or/c string? objc-object? #f) void?)]
  [nssplitview-add-tool-tip-rect-owner-user-data! (c-> objc-object? any/c (or/c string? objc-object? #f) (or/c cpointer? #f) exact-integer?)]
  [nssplitview-adjust-scroll (c-> objc-object? any/c any/c)]
  [nssplitview-adjust-subviews (c-> objc-object? void?)]
  [nssplitview-ancestor-shared-with-view (c-> objc-object? (or/c string? objc-object? #f) (or/c nsview? objc-nil?))]
  [nssplitview-autoscroll (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nssplitview-backing-aligned-rect-options (c-> objc-object? any/c exact-nonnegative-integer? any/c)]
  [nssplitview-become-first-responder (c-> objc-object? boolean?)]
  [nssplitview-begin-gesture-with-event! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-bitmap-image-rep-for-caching-display-in-rect (c-> objc-object? any/c (or/c nsbitmapimagerep? objc-nil?))]
  [nssplitview-cache-display-in-rect-to-bitmap-image-rep (c-> objc-object? any/c (or/c string? objc-object? #f) void?)]
  [nssplitview-center-scan-rect! (c-> objc-object? any/c any/c)]
  [nssplitview-change-mode-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-context-menu-key-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-convert-point-from-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nssplitview-convert-point-to-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nssplitview-convert-point-from-backing (c-> objc-object? any/c any/c)]
  [nssplitview-convert-point-from-layer (c-> objc-object? any/c any/c)]
  [nssplitview-convert-point-to-backing (c-> objc-object? any/c any/c)]
  [nssplitview-convert-point-to-layer (c-> objc-object? any/c any/c)]
  [nssplitview-convert-rect-from-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nssplitview-convert-rect-to-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nssplitview-convert-rect-from-backing (c-> objc-object? any/c any/c)]
  [nssplitview-convert-rect-from-layer (c-> objc-object? any/c any/c)]
  [nssplitview-convert-rect-to-backing (c-> objc-object? any/c any/c)]
  [nssplitview-convert-rect-to-layer (c-> objc-object? any/c any/c)]
  [nssplitview-convert-size-from-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nssplitview-convert-size-to-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nssplitview-convert-size-from-backing (c-> objc-object? any/c any/c)]
  [nssplitview-convert-size-from-layer (c-> objc-object? any/c any/c)]
  [nssplitview-convert-size-to-backing (c-> objc-object? any/c any/c)]
  [nssplitview-convert-size-to-layer (c-> objc-object? any/c any/c)]
  [nssplitview-cursor-update (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-did-add-subview (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-did-close-menu-with-event (c-> objc-object? (or/c string? objc-object? #f) (or/c string? objc-object? #f) void?)]
  [nssplitview-display! (c-> objc-object? void?)]
  [nssplitview-display-if-needed! (c-> objc-object? void?)]
  [nssplitview-display-if-needed-ignoring-opacity! (c-> objc-object? void?)]
  [nssplitview-display-if-needed-in-rect! (c-> objc-object? any/c void?)]
  [nssplitview-display-if-needed-in-rect-ignoring-opacity! (c-> objc-object? any/c void?)]
  [nssplitview-display-rect! (c-> objc-object? any/c void?)]
  [nssplitview-display-rect-ignoring-opacity! (c-> objc-object? any/c void?)]
  [nssplitview-display-rect-ignoring-opacity-in-context! (c-> objc-object? any/c (or/c string? objc-object? #f) void?)]
  [nssplitview-draw-divider-in-rect (c-> objc-object? any/c void?)]
  [nssplitview-draw-rect (c-> objc-object? any/c void?)]
  [nssplitview-end-gesture-with-event! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-flags-changed (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-flush-buffered-key-events (c-> objc-object? void?)]
  [nssplitview-get-rects-being-drawn-count (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nssplitview-get-rects-exposed-during-live-resize-count (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nssplitview-help-requested (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-hit-test (c-> objc-object? any/c (or/c nsview? objc-nil?))]
  [nssplitview-holding-priority-for-subview-at-index (c-> objc-object? exact-integer? real?)]
  [nssplitview-interpret-key-events (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-is-descendant-of (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nssplitview-is-flipped (c-> objc-object? boolean?)]
  [nssplitview-is-hidden (c-> objc-object? boolean?)]
  [nssplitview-is-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nssplitview-is-opaque (c-> objc-object? boolean?)]
  [nssplitview-is-rotated-from-base (c-> objc-object? boolean?)]
  [nssplitview-is-rotated-or-scaled-from-base (c-> objc-object? boolean?)]
  [nssplitview-is-subview-collapsed (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nssplitview-is-vertical (c-> objc-object? boolean?)]
  [nssplitview-key-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-key-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-layout (c-> objc-object? void?)]
  [nssplitview-layout-subtree-if-needed (c-> objc-object? void?)]
  [nssplitview-magnify-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-make-backing-layer (c-> objc-object? (or/c calayer? objc-nil?))]
  [nssplitview-max-possible-position-of-divider-at-index (c-> objc-object? exact-integer? real?)]
  [nssplitview-menu-for-event (c-> objc-object? (or/c string? objc-object? #f) (or/c nsmenu? objc-nil?))]
  [nssplitview-min-possible-position-of-divider-at-index (c-> objc-object? exact-integer? real?)]
  [nssplitview-mouse-in-rect (c-> objc-object? any/c any/c boolean?)]
  [nssplitview-mouse-cancelled (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-mouse-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-mouse-dragged (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-mouse-entered (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-mouse-exited (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-mouse-moved (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-mouse-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-needs-to-draw-rect (c-> objc-object? any/c boolean?)]
  [nssplitview-no-responder-for (c-> objc-object? string? void?)]
  [nssplitview-other-mouse-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-other-mouse-dragged (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-other-mouse-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-perform-key-equivalent! (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nssplitview-prepare-content-in-rect (c-> objc-object? any/c void?)]
  [nssplitview-prepare-for-reuse (c-> objc-object? void?)]
  [nssplitview-pressure-change-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-quick-look-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-rect-for-smart-magnification-at-point-in-rect (c-> objc-object? any/c any/c any/c)]
  [nssplitview-remove-all-tool-tips! (c-> objc-object? void?)]
  [nssplitview-remove-from-superview! (c-> objc-object? void?)]
  [nssplitview-remove-from-superview-without-needing-display! (c-> objc-object? void?)]
  [nssplitview-remove-tool-tip! (c-> objc-object? exact-integer? void?)]
  [nssplitview-replace-subview-with! (c-> objc-object? (or/c string? objc-object? #f) (or/c string? objc-object? #f) void?)]
  [nssplitview-resign-first-responder (c-> objc-object? boolean?)]
  [nssplitview-resize-subviews-with-old-size (c-> objc-object? any/c void?)]
  [nssplitview-resize-with-old-superview-size (c-> objc-object? any/c void?)]
  [nssplitview-right-mouse-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-right-mouse-dragged (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-right-mouse-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-rotate-by-angle (c-> objc-object? real? void?)]
  [nssplitview-rotate-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-scale-unit-square-to-size (c-> objc-object? any/c void?)]
  [nssplitview-scroll-point (c-> objc-object? any/c void?)]
  [nssplitview-scroll-rect-to-visible (c-> objc-object? any/c boolean?)]
  [nssplitview-scroll-wheel (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-set-bounds-origin! (c-> objc-object? any/c void?)]
  [nssplitview-set-bounds-size! (c-> objc-object? any/c void?)]
  [nssplitview-set-frame-origin! (c-> objc-object? any/c void?)]
  [nssplitview-set-frame-size! (c-> objc-object? any/c void?)]
  [nssplitview-set-holding-priority-for-subview-at-index! (c-> objc-object? real? exact-integer? void?)]
  [nssplitview-set-needs-display-in-rect! (c-> objc-object? any/c void?)]
  [nssplitview-set-position-of-divider-at-index! (c-> objc-object? real? exact-integer? void?)]
  [nssplitview-should-be-treated-as-ink-event (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nssplitview-should-delay-window-ordering-for-event (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nssplitview-show-context-help (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-smart-magnify-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-sort-subviews-using-function-context (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nssplitview-supplemental-target-for-action-sender (c-> objc-object? string? (or/c string? objc-object? #f) any/c)]
  [nssplitview-swipe-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-tablet-point (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-tablet-proximity (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-touches-began-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-touches-cancelled-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-touches-ended-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-touches-moved-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-translate-origin-to-point (c-> objc-object? any/c void?)]
  [nssplitview-translate-rects-needing-display-in-rect-by (c-> objc-object? any/c any/c void?)]
  [nssplitview-try-to-perform-with (c-> objc-object? string? (or/c string? objc-object? #f) boolean?)]
  [nssplitview-update-layer (c-> objc-object? void?)]
  [nssplitview-valid-requestor-for-send-type-return-type (c-> objc-object? (or/c string? objc-object? #f) (or/c string? objc-object? #f) any/c)]
  [nssplitview-view-did-change-backing-properties (c-> objc-object? void?)]
  [nssplitview-view-did-change-effective-appearance (c-> objc-object? void?)]
  [nssplitview-view-did-end-live-resize (c-> objc-object? void?)]
  [nssplitview-view-did-hide (c-> objc-object? void?)]
  [nssplitview-view-did-move-to-superview (c-> objc-object? void?)]
  [nssplitview-view-did-move-to-window (c-> objc-object? void?)]
  [nssplitview-view-did-unhide (c-> objc-object? void?)]
  [nssplitview-view-will-draw (c-> objc-object? void?)]
  [nssplitview-view-will-move-to-superview (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-view-will-move-to-window (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-view-will-start-live-resize (c-> objc-object? void?)]
  [nssplitview-view-with-tag (c-> objc-object? exact-integer? any/c)]
  [nssplitview-wants-forwarded-scroll-events-for-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nssplitview-wants-scroll-events-for-swipe-tracking-on-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nssplitview-will-open-menu-with-event (c-> objc-object? (or/c string? objc-object? #f) (or/c string? objc-object? #f) void?)]
  [nssplitview-will-remove-subview (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nssplitview-is-compatible-with-responsive-scrolling (c-> boolean?)]
  )

;; --- Class reference ---
(import-class NSSplitView)

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
(define _msg-26  ; (_fun _pointer _pointer _double _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double _int64 -> _void)))
(define _msg-27  ; (_fun _pointer _pointer _float _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _float _int64 -> _void)))
(define _msg-28  ; (_fun _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _bool)))
(define _msg-29  ; (_fun _pointer _pointer _id _uint64 _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _uint64 _id -> _void)))
(define _msg-30  ; (_fun _pointer _pointer _int64 -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _double)))
(define _msg-31  ; (_fun _pointer _pointer _int64 -> _float)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _float)))
(define _msg-32  ; (_fun _pointer _pointer _int64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _id)))
(define _msg-33  ; (_fun _pointer _pointer _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _void)))
(define _msg-34  ; (_fun _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))
(define _msg-35  ; (_fun _pointer _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _bool)))
(define _msg-36  ; (_fun _pointer _pointer _pointer _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _id)))
(define _msg-37  ; (_fun _pointer _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _pointer -> _void)))
(define _msg-38  ; (_fun _pointer _pointer _uint64 -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _bool)))
(define _msg-39  ; (_fun _pointer _pointer _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _void)))

;; --- Constructors ---
(define (make-nssplitview-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSSplitView alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))

(define (make-nssplitview-init-with-frame frame-rect)
  (wrap-objc-object
   (_msg-14 (tell NSSplitView alloc)
       (sel_registerName "initWithFrame:")
       frame-rect)
   #:retained #t))


;; --- Properties ---
(define (nssplitview-accepts-first-responder self)
  (tell #:type _bool (coerce-arg self) acceptsFirstResponder))
(define (nssplitview-accepts-touch-events self)
  (tell #:type _bool (coerce-arg self) acceptsTouchEvents))
(define (nssplitview-set-accepts-touch-events! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setAcceptsTouchEvents:") value))
(define (nssplitview-additional-safe-area-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) additionalSafeAreaInsets))
(define (nssplitview-set-additional-safe-area-insets! self value)
  (_msg-5 (coerce-arg self) (sel_registerName "setAdditionalSafeAreaInsets:") value))
(define (nssplitview-alignment-rect-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) alignmentRectInsets))
(define (nssplitview-allowed-touch-types self)
  (tell #:type _uint64 (coerce-arg self) allowedTouchTypes))
(define (nssplitview-set-allowed-touch-types! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setAllowedTouchTypes:") value))
(define (nssplitview-allows-vibrancy self)
  (tell #:type _bool (coerce-arg self) allowsVibrancy))
(define (nssplitview-alpha-value self)
  (tell #:type _double (coerce-arg self) alphaValue))
(define (nssplitview-set-alpha-value! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setAlphaValue:") value))
(define (nssplitview-arranged-subviews self)
  (wrap-objc-object
   (tell (coerce-arg self) arrangedSubviews)))
(define (nssplitview-arranges-all-subviews self)
  (tell #:type _bool (coerce-arg self) arrangesAllSubviews))
(define (nssplitview-set-arranges-all-subviews! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setArrangesAllSubviews:") value))
(define (nssplitview-autoresizes-subviews self)
  (tell #:type _bool (coerce-arg self) autoresizesSubviews))
(define (nssplitview-set-autoresizes-subviews! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setAutoresizesSubviews:") value))
(define (nssplitview-autoresizing-mask self)
  (tell #:type _uint64 (coerce-arg self) autoresizingMask))
(define (nssplitview-set-autoresizing-mask! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setAutoresizingMask:") value))
(define (nssplitview-autosave-name self)
  (wrap-objc-object
   (tell (coerce-arg self) autosaveName)))
(define (nssplitview-set-autosave-name! self value)
  (tell #:type _void (coerce-arg self) setAutosaveName: (coerce-arg value)))
(define (nssplitview-background-filters self)
  (wrap-objc-object
   (tell (coerce-arg self) backgroundFilters)))
(define (nssplitview-set-background-filters! self value)
  (tell #:type _void (coerce-arg self) setBackgroundFilters: (coerce-arg value)))
(define (nssplitview-baseline-offset-from-bottom self)
  (tell #:type _double (coerce-arg self) baselineOffsetFromBottom))
(define (nssplitview-bottom-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) bottomAnchor)))
(define (nssplitview-bounds self)
  (tell #:type _NSRect (coerce-arg self) bounds))
(define (nssplitview-set-bounds! self value)
  (_msg-15 (coerce-arg self) (sel_registerName "setBounds:") value))
(define (nssplitview-bounds-rotation self)
  (tell #:type _double (coerce-arg self) boundsRotation))
(define (nssplitview-set-bounds-rotation! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setBoundsRotation:") value))
(define (nssplitview-can-become-key-view self)
  (tell #:type _bool (coerce-arg self) canBecomeKeyView))
(define (nssplitview-can-draw self)
  (tell #:type _bool (coerce-arg self) canDraw))
(define (nssplitview-can-draw-concurrently self)
  (tell #:type _bool (coerce-arg self) canDrawConcurrently))
(define (nssplitview-set-can-draw-concurrently! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setCanDrawConcurrently:") value))
(define (nssplitview-can-draw-subviews-into-layer self)
  (tell #:type _bool (coerce-arg self) canDrawSubviewsIntoLayer))
(define (nssplitview-set-can-draw-subviews-into-layer! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setCanDrawSubviewsIntoLayer:") value))
(define (nssplitview-candidate-list-touch-bar-item self)
  (wrap-objc-object
   (tell (coerce-arg self) candidateListTouchBarItem)))
(define (nssplitview-center-x-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) centerXAnchor)))
(define (nssplitview-center-y-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) centerYAnchor)))
(define (nssplitview-clips-to-bounds self)
  (tell #:type _bool (coerce-arg self) clipsToBounds))
(define (nssplitview-set-clips-to-bounds! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setClipsToBounds:") value))
(define (nssplitview-compatible-with-responsive-scrolling)
  (tell #:type _bool NSSplitView compatibleWithResponsiveScrolling))
(define (nssplitview-compositing-filter self)
  (wrap-objc-object
   (tell (coerce-arg self) compositingFilter)))
(define (nssplitview-set-compositing-filter! self value)
  (tell #:type _void (coerce-arg self) setCompositingFilter: (coerce-arg value)))
(define (nssplitview-constraints self)
  (wrap-objc-object
   (tell (coerce-arg self) constraints)))
(define (nssplitview-content-filters self)
  (wrap-objc-object
   (tell (coerce-arg self) contentFilters)))
(define (nssplitview-set-content-filters! self value)
  (tell #:type _void (coerce-arg self) setContentFilters: (coerce-arg value)))
(define (nssplitview-default-focus-ring-type)
  (tell #:type _uint64 NSSplitView defaultFocusRingType))
(define (nssplitview-default-menu)
  (wrap-objc-object
   (tell NSSplitView defaultMenu)))
(define (nssplitview-delegate self)
  (wrap-objc-object
   (tell (coerce-arg self) delegate)))
(define (nssplitview-set-delegate! self value)
  (tell #:type _void (coerce-arg self) setDelegate: (coerce-arg value)))
(define (nssplitview-divider-color self)
  (wrap-objc-object
   (tell (coerce-arg self) dividerColor)))
(define (nssplitview-divider-style self)
  (tell #:type _uint64 (coerce-arg self) dividerStyle))
(define (nssplitview-set-divider-style! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setDividerStyle:") value))
(define (nssplitview-divider-thickness self)
  (tell #:type _double (coerce-arg self) dividerThickness))
(define (nssplitview-drawing-find-indicator self)
  (tell #:type _bool (coerce-arg self) drawingFindIndicator))
(define (nssplitview-enclosing-menu-item self)
  (wrap-objc-object
   (tell (coerce-arg self) enclosingMenuItem)))
(define (nssplitview-enclosing-scroll-view self)
  (wrap-objc-object
   (tell (coerce-arg self) enclosingScrollView)))
(define (nssplitview-first-baseline-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) firstBaselineAnchor)))
(define (nssplitview-first-baseline-offset-from-top self)
  (tell #:type _double (coerce-arg self) firstBaselineOffsetFromTop))
(define (nssplitview-fitting-size self)
  (tell #:type _NSSize (coerce-arg self) fittingSize))
(define (nssplitview-flipped self)
  (tell #:type _bool (coerce-arg self) flipped))
(define (nssplitview-focus-ring-mask-bounds self)
  (tell #:type _NSRect (coerce-arg self) focusRingMaskBounds))
(define (nssplitview-focus-ring-type self)
  (tell #:type _uint64 (coerce-arg self) focusRingType))
(define (nssplitview-set-focus-ring-type! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setFocusRingType:") value))
(define (nssplitview-focus-view)
  (wrap-objc-object
   (tell NSSplitView focusView)))
(define (nssplitview-frame self)
  (tell #:type _NSRect (coerce-arg self) frame))
(define (nssplitview-set-frame! self value)
  (_msg-15 (coerce-arg self) (sel_registerName "setFrame:") value))
(define (nssplitview-frame-center-rotation self)
  (tell #:type _double (coerce-arg self) frameCenterRotation))
(define (nssplitview-set-frame-center-rotation! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setFrameCenterRotation:") value))
(define (nssplitview-frame-rotation self)
  (tell #:type _double (coerce-arg self) frameRotation))
(define (nssplitview-set-frame-rotation! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setFrameRotation:") value))
(define (nssplitview-gesture-recognizers self)
  (wrap-objc-object
   (tell (coerce-arg self) gestureRecognizers)))
(define (nssplitview-set-gesture-recognizers! self value)
  (tell #:type _void (coerce-arg self) setGestureRecognizers: (coerce-arg value)))
(define (nssplitview-has-ambiguous-layout self)
  (tell #:type _bool (coerce-arg self) hasAmbiguousLayout))
(define (nssplitview-height-adjust-limit self)
  (tell #:type _double (coerce-arg self) heightAdjustLimit))
(define (nssplitview-height-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) heightAnchor)))
(define (nssplitview-hidden self)
  (tell #:type _bool (coerce-arg self) hidden))
(define (nssplitview-set-hidden! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setHidden:") value))
(define (nssplitview-hidden-or-has-hidden-ancestor self)
  (tell #:type _bool (coerce-arg self) hiddenOrHasHiddenAncestor))
(define (nssplitview-horizontal-content-size-constraint-active self)
  (tell #:type _bool (coerce-arg self) horizontalContentSizeConstraintActive))
(define (nssplitview-set-horizontal-content-size-constraint-active! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setHorizontalContentSizeConstraintActive:") value))
(define (nssplitview-in-full-screen-mode self)
  (tell #:type _bool (coerce-arg self) inFullScreenMode))
(define (nssplitview-in-live-resize self)
  (tell #:type _bool (coerce-arg self) inLiveResize))
(define (nssplitview-input-context self)
  (wrap-objc-object
   (tell (coerce-arg self) inputContext)))
(define (nssplitview-intrinsic-content-size self)
  (tell #:type _NSSize (coerce-arg self) intrinsicContentSize))
(define (nssplitview-last-baseline-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) lastBaselineAnchor)))
(define (nssplitview-last-baseline-offset-from-bottom self)
  (tell #:type _double (coerce-arg self) lastBaselineOffsetFromBottom))
(define (nssplitview-layer self)
  (wrap-objc-object
   (tell (coerce-arg self) layer)))
(define (nssplitview-set-layer! self value)
  (tell #:type _void (coerce-arg self) setLayer: (coerce-arg value)))
(define (nssplitview-layer-contents-placement self)
  (tell #:type _uint64 (coerce-arg self) layerContentsPlacement))
(define (nssplitview-set-layer-contents-placement! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setLayerContentsPlacement:") value))
(define (nssplitview-layer-contents-redraw-policy self)
  (tell #:type _uint64 (coerce-arg self) layerContentsRedrawPolicy))
(define (nssplitview-set-layer-contents-redraw-policy! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setLayerContentsRedrawPolicy:") value))
(define (nssplitview-layer-uses-core-image-filters self)
  (tell #:type _bool (coerce-arg self) layerUsesCoreImageFilters))
(define (nssplitview-set-layer-uses-core-image-filters! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setLayerUsesCoreImageFilters:") value))
(define (nssplitview-layout-guides self)
  (wrap-objc-object
   (tell (coerce-arg self) layoutGuides)))
(define (nssplitview-layout-margins-guide self)
  (wrap-objc-object
   (tell (coerce-arg self) layoutMarginsGuide)))
(define (nssplitview-leading-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) leadingAnchor)))
(define (nssplitview-left-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) leftAnchor)))
(define (nssplitview-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) menu)))
(define (nssplitview-set-menu! self value)
  (tell #:type _void (coerce-arg self) setMenu: (coerce-arg value)))
(define (nssplitview-mouse-down-can-move-window self)
  (tell #:type _bool (coerce-arg self) mouseDownCanMoveWindow))
(define (nssplitview-needs-display self)
  (tell #:type _bool (coerce-arg self) needsDisplay))
(define (nssplitview-set-needs-display! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setNeedsDisplay:") value))
(define (nssplitview-needs-layout self)
  (tell #:type _bool (coerce-arg self) needsLayout))
(define (nssplitview-set-needs-layout! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setNeedsLayout:") value))
(define (nssplitview-needs-panel-to-become-key self)
  (tell #:type _bool (coerce-arg self) needsPanelToBecomeKey))
(define (nssplitview-needs-update-constraints self)
  (tell #:type _bool (coerce-arg self) needsUpdateConstraints))
(define (nssplitview-set-needs-update-constraints! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setNeedsUpdateConstraints:") value))
(define (nssplitview-next-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) nextKeyView)))
(define (nssplitview-set-next-key-view! self value)
  (tell #:type _void (coerce-arg self) setNextKeyView: (coerce-arg value)))
(define (nssplitview-next-responder self)
  (wrap-objc-object
   (tell (coerce-arg self) nextResponder)))
(define (nssplitview-set-next-responder! self value)
  (tell #:type _void (coerce-arg self) setNextResponder: (coerce-arg value)))
(define (nssplitview-next-valid-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) nextValidKeyView)))
(define (nssplitview-opaque self)
  (tell #:type _bool (coerce-arg self) opaque))
(define (nssplitview-opaque-ancestor self)
  (wrap-objc-object
   (tell (coerce-arg self) opaqueAncestor)))
(define (nssplitview-page-footer self)
  (wrap-objc-object
   (tell (coerce-arg self) pageFooter)))
(define (nssplitview-page-header self)
  (wrap-objc-object
   (tell (coerce-arg self) pageHeader)))
(define (nssplitview-posts-bounds-changed-notifications self)
  (tell #:type _bool (coerce-arg self) postsBoundsChangedNotifications))
(define (nssplitview-set-posts-bounds-changed-notifications! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setPostsBoundsChangedNotifications:") value))
(define (nssplitview-posts-frame-changed-notifications self)
  (tell #:type _bool (coerce-arg self) postsFrameChangedNotifications))
(define (nssplitview-set-posts-frame-changed-notifications! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setPostsFrameChangedNotifications:") value))
(define (nssplitview-prefers-compact-control-size-metrics self)
  (tell #:type _bool (coerce-arg self) prefersCompactControlSizeMetrics))
(define (nssplitview-set-prefers-compact-control-size-metrics! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setPrefersCompactControlSizeMetrics:") value))
(define (nssplitview-prepared-content-rect self)
  (tell #:type _NSRect (coerce-arg self) preparedContentRect))
(define (nssplitview-set-prepared-content-rect! self value)
  (_msg-15 (coerce-arg self) (sel_registerName "setPreparedContentRect:") value))
(define (nssplitview-preserves-content-during-live-resize self)
  (tell #:type _bool (coerce-arg self) preservesContentDuringLiveResize))
(define (nssplitview-pressure-configuration self)
  (wrap-objc-object
   (tell (coerce-arg self) pressureConfiguration)))
(define (nssplitview-set-pressure-configuration! self value)
  (tell #:type _void (coerce-arg self) setPressureConfiguration: (coerce-arg value)))
(define (nssplitview-previous-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) previousKeyView)))
(define (nssplitview-previous-valid-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) previousValidKeyView)))
(define (nssplitview-print-job-title self)
  (wrap-objc-object
   (tell (coerce-arg self) printJobTitle)))
(define (nssplitview-rect-preserved-during-live-resize self)
  (tell #:type _NSRect (coerce-arg self) rectPreservedDuringLiveResize))
(define (nssplitview-registered-dragged-types self)
  (wrap-objc-object
   (tell (coerce-arg self) registeredDraggedTypes)))
(define (nssplitview-requires-constraint-based-layout)
  (tell #:type _bool NSSplitView requiresConstraintBasedLayout))
(define (nssplitview-restorable-state-key-paths)
  (wrap-objc-object
   (tell NSSplitView restorableStateKeyPaths)))
(define (nssplitview-right-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) rightAnchor)))
(define (nssplitview-rotated-from-base self)
  (tell #:type _bool (coerce-arg self) rotatedFromBase))
(define (nssplitview-rotated-or-scaled-from-base self)
  (tell #:type _bool (coerce-arg self) rotatedOrScaledFromBase))
(define (nssplitview-safe-area-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) safeAreaInsets))
(define (nssplitview-safe-area-layout-guide self)
  (wrap-objc-object
   (tell (coerce-arg self) safeAreaLayoutGuide)))
(define (nssplitview-safe-area-rect self)
  (tell #:type _NSRect (coerce-arg self) safeAreaRect))
(define (nssplitview-shadow self)
  (wrap-objc-object
   (tell (coerce-arg self) shadow)))
(define (nssplitview-set-shadow! self value)
  (tell #:type _void (coerce-arg self) setShadow: (coerce-arg value)))
(define (nssplitview-subviews self)
  (wrap-objc-object
   (tell (coerce-arg self) subviews)))
(define (nssplitview-set-subviews! self value)
  (tell #:type _void (coerce-arg self) setSubviews: (coerce-arg value)))
(define (nssplitview-superview self)
  (wrap-objc-object
   (tell (coerce-arg self) superview)))
(define (nssplitview-tag self)
  (tell #:type _int64 (coerce-arg self) tag))
(define (nssplitview-tool-tip self)
  (wrap-objc-object
   (tell (coerce-arg self) toolTip)))
(define (nssplitview-set-tool-tip! self value)
  (tell #:type _void (coerce-arg self) setToolTip: (coerce-arg value)))
(define (nssplitview-top-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) topAnchor)))
(define (nssplitview-touch-bar self)
  (wrap-objc-object
   (tell (coerce-arg self) touchBar)))
(define (nssplitview-set-touch-bar! self value)
  (tell #:type _void (coerce-arg self) setTouchBar: (coerce-arg value)))
(define (nssplitview-tracking-areas self)
  (wrap-objc-object
   (tell (coerce-arg self) trackingAreas)))
(define (nssplitview-trailing-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) trailingAnchor)))
(define (nssplitview-translates-autoresizing-mask-into-constraints self)
  (tell #:type _bool (coerce-arg self) translatesAutoresizingMaskIntoConstraints))
(define (nssplitview-set-translates-autoresizing-mask-into-constraints! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setTranslatesAutoresizingMaskIntoConstraints:") value))
(define (nssplitview-undo-manager self)
  (wrap-objc-object
   (tell (coerce-arg self) undoManager)))
(define (nssplitview-user-activity self)
  (wrap-objc-object
   (tell (coerce-arg self) userActivity)))
(define (nssplitview-set-user-activity! self value)
  (tell #:type _void (coerce-arg self) setUserActivity: (coerce-arg value)))
(define (nssplitview-user-interface-layout-direction self)
  (tell #:type _uint64 (coerce-arg self) userInterfaceLayoutDirection))
(define (nssplitview-set-user-interface-layout-direction! self value)
  (_msg-39 (coerce-arg self) (sel_registerName "setUserInterfaceLayoutDirection:") value))
(define (nssplitview-vertical self)
  (tell #:type _bool (coerce-arg self) vertical))
(define (nssplitview-set-vertical! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setVertical:") value))
(define (nssplitview-vertical-content-size-constraint-active self)
  (tell #:type _bool (coerce-arg self) verticalContentSizeConstraintActive))
(define (nssplitview-set-vertical-content-size-constraint-active! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setVerticalContentSizeConstraintActive:") value))
(define (nssplitview-visible-rect self)
  (tell #:type _NSRect (coerce-arg self) visibleRect))
(define (nssplitview-wants-best-resolution-open-gl-surface self)
  (tell #:type _bool (coerce-arg self) wantsBestResolutionOpenGLSurface))
(define (nssplitview-set-wants-best-resolution-open-gl-surface! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setWantsBestResolutionOpenGLSurface:") value))
(define (nssplitview-wants-default-clipping self)
  (tell #:type _bool (coerce-arg self) wantsDefaultClipping))
(define (nssplitview-wants-extended-dynamic-range-open-gl-surface self)
  (tell #:type _bool (coerce-arg self) wantsExtendedDynamicRangeOpenGLSurface))
(define (nssplitview-set-wants-extended-dynamic-range-open-gl-surface! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setWantsExtendedDynamicRangeOpenGLSurface:") value))
(define (nssplitview-wants-layer self)
  (tell #:type _bool (coerce-arg self) wantsLayer))
(define (nssplitview-set-wants-layer! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setWantsLayer:") value))
(define (nssplitview-wants-resting-touches self)
  (tell #:type _bool (coerce-arg self) wantsRestingTouches))
(define (nssplitview-set-wants-resting-touches! self value)
  (_msg-24 (coerce-arg self) (sel_registerName "setWantsRestingTouches:") value))
(define (nssplitview-wants-update-layer self)
  (tell #:type _bool (coerce-arg self) wantsUpdateLayer))
(define (nssplitview-width-adjust-limit self)
  (tell #:type _double (coerce-arg self) widthAdjustLimit))
(define (nssplitview-width-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) widthAnchor)))
(define (nssplitview-window self)
  (wrap-objc-object
   (tell (coerce-arg self) window)))
(define (nssplitview-writing-tools-coordinator self)
  (wrap-objc-object
   (tell (coerce-arg self) writingToolsCoordinator)))
(define (nssplitview-set-writing-tools-coordinator! self value)
  (tell #:type _void (coerce-arg self) setWritingToolsCoordinator: (coerce-arg value)))

;; --- Instance methods ---
(define (nssplitview-accepts-first-mouse self event)
  (_msg-28 (coerce-arg self) (sel_registerName "acceptsFirstMouse:") (coerce-arg event)))
(define (nssplitview-add-subview! self view)
  (tell #:type _void (coerce-arg self) addSubview: (coerce-arg view)))
(define (nssplitview-add-subview-positioned-relative-to! self view place other-view)
  (_msg-29 (coerce-arg self) (sel_registerName "addSubview:positioned:relativeTo:") (coerce-arg view) place (coerce-arg other-view)))
(define (nssplitview-add-tool-tip-rect-owner-user-data! self rect owner data)
  (_msg-19 (coerce-arg self) (sel_registerName "addToolTipRect:owner:userData:") rect (coerce-arg owner) data))
(define (nssplitview-adjust-scroll self new-visible)
  (_msg-12 (coerce-arg self) (sel_registerName "adjustScroll:") new-visible))
(define (nssplitview-adjust-subviews self)
  (tell #:type _void (coerce-arg self) adjustSubviews))
(define (nssplitview-ancestor-shared-with-view self view)
  (wrap-objc-object
   (tell (coerce-arg self) ancestorSharedWithView: (coerce-arg view))))
(define (nssplitview-autoscroll self event)
  (_msg-28 (coerce-arg self) (sel_registerName "autoscroll:") (coerce-arg event)))
(define (nssplitview-backing-aligned-rect-options self rect options)
  (_msg-20 (coerce-arg self) (sel_registerName "backingAlignedRect:options:") rect options))
(define (nssplitview-become-first-responder self)
  (_msg-1 (coerce-arg self) (sel_registerName "becomeFirstResponder")))
(define (nssplitview-begin-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) beginGestureWithEvent: (coerce-arg event)))
(define (nssplitview-bitmap-image-rep-for-caching-display-in-rect self rect)
  (wrap-objc-object
   (_msg-14 (coerce-arg self) (sel_registerName "bitmapImageRepForCachingDisplayInRect:") rect)
   ))
(define (nssplitview-cache-display-in-rect-to-bitmap-image-rep self rect bitmap-image-rep)
  (_msg-18 (coerce-arg self) (sel_registerName "cacheDisplayInRect:toBitmapImageRep:") rect (coerce-arg bitmap-image-rep)))
(define (nssplitview-center-scan-rect! self rect)
  (_msg-12 (coerce-arg self) (sel_registerName "centerScanRect:") rect))
(define (nssplitview-change-mode-with-event self event)
  (tell #:type _void (coerce-arg self) changeModeWithEvent: (coerce-arg event)))
(define (nssplitview-context-menu-key-down self event)
  (tell #:type _void (coerce-arg self) contextMenuKeyDown: (coerce-arg event)))
(define (nssplitview-convert-point-from-view self point view)
  (_msg-11 (coerce-arg self) (sel_registerName "convertPoint:fromView:") point (coerce-arg view)))
(define (nssplitview-convert-point-to-view self point view)
  (_msg-11 (coerce-arg self) (sel_registerName "convertPoint:toView:") point (coerce-arg view)))
(define (nssplitview-convert-point-from-backing self point)
  (_msg-6 (coerce-arg self) (sel_registerName "convertPointFromBacking:") point))
(define (nssplitview-convert-point-from-layer self point)
  (_msg-6 (coerce-arg self) (sel_registerName "convertPointFromLayer:") point))
(define (nssplitview-convert-point-to-backing self point)
  (_msg-6 (coerce-arg self) (sel_registerName "convertPointToBacking:") point))
(define (nssplitview-convert-point-to-layer self point)
  (_msg-6 (coerce-arg self) (sel_registerName "convertPointToLayer:") point))
(define (nssplitview-convert-rect-from-view self rect view)
  (_msg-17 (coerce-arg self) (sel_registerName "convertRect:fromView:") rect (coerce-arg view)))
(define (nssplitview-convert-rect-to-view self rect view)
  (_msg-17 (coerce-arg self) (sel_registerName "convertRect:toView:") rect (coerce-arg view)))
(define (nssplitview-convert-rect-from-backing self rect)
  (_msg-12 (coerce-arg self) (sel_registerName "convertRectFromBacking:") rect))
(define (nssplitview-convert-rect-from-layer self rect)
  (_msg-12 (coerce-arg self) (sel_registerName "convertRectFromLayer:") rect))
(define (nssplitview-convert-rect-to-backing self rect)
  (_msg-12 (coerce-arg self) (sel_registerName "convertRectToBacking:") rect))
(define (nssplitview-convert-rect-to-layer self rect)
  (_msg-12 (coerce-arg self) (sel_registerName "convertRectToLayer:") rect))
(define (nssplitview-convert-size-from-view self size view)
  (_msg-23 (coerce-arg self) (sel_registerName "convertSize:fromView:") size (coerce-arg view)))
(define (nssplitview-convert-size-to-view self size view)
  (_msg-23 (coerce-arg self) (sel_registerName "convertSize:toView:") size (coerce-arg view)))
(define (nssplitview-convert-size-from-backing self size)
  (_msg-21 (coerce-arg self) (sel_registerName "convertSizeFromBacking:") size))
(define (nssplitview-convert-size-from-layer self size)
  (_msg-21 (coerce-arg self) (sel_registerName "convertSizeFromLayer:") size))
(define (nssplitview-convert-size-to-backing self size)
  (_msg-21 (coerce-arg self) (sel_registerName "convertSizeToBacking:") size))
(define (nssplitview-convert-size-to-layer self size)
  (_msg-21 (coerce-arg self) (sel_registerName "convertSizeToLayer:") size))
(define (nssplitview-cursor-update self event)
  (tell #:type _void (coerce-arg self) cursorUpdate: (coerce-arg event)))
(define (nssplitview-did-add-subview self subview)
  (tell #:type _void (coerce-arg self) didAddSubview: (coerce-arg subview)))
(define (nssplitview-did-close-menu-with-event self menu event)
  (tell #:type _void (coerce-arg self) didCloseMenu: (coerce-arg menu) withEvent: (coerce-arg event)))
(define (nssplitview-display! self)
  (tell #:type _void (coerce-arg self) display))
(define (nssplitview-display-if-needed! self)
  (tell #:type _void (coerce-arg self) displayIfNeeded))
(define (nssplitview-display-if-needed-ignoring-opacity! self)
  (tell #:type _void (coerce-arg self) displayIfNeededIgnoringOpacity))
(define (nssplitview-display-if-needed-in-rect! self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "displayIfNeededInRect:") rect))
(define (nssplitview-display-if-needed-in-rect-ignoring-opacity! self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "displayIfNeededInRectIgnoringOpacity:") rect))
(define (nssplitview-display-rect! self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "displayRect:") rect))
(define (nssplitview-display-rect-ignoring-opacity! self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "displayRectIgnoringOpacity:") rect))
(define (nssplitview-display-rect-ignoring-opacity-in-context! self rect context)
  (_msg-18 (coerce-arg self) (sel_registerName "displayRectIgnoringOpacity:inContext:") rect (coerce-arg context)))
(define (nssplitview-draw-divider-in-rect self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "drawDividerInRect:") rect))
(define (nssplitview-draw-rect self dirty-rect)
  (_msg-15 (coerce-arg self) (sel_registerName "drawRect:") dirty-rect))
(define (nssplitview-end-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) endGestureWithEvent: (coerce-arg event)))
(define (nssplitview-flags-changed self event)
  (tell #:type _void (coerce-arg self) flagsChanged: (coerce-arg event)))
(define (nssplitview-flush-buffered-key-events self)
  (tell #:type _void (coerce-arg self) flushBufferedKeyEvents))
(define (nssplitview-get-rects-being-drawn-count self rects count)
  (_msg-37 (coerce-arg self) (sel_registerName "getRectsBeingDrawn:count:") rects count))
(define (nssplitview-get-rects-exposed-during-live-resize-count self exposed-rects count)
  (_msg-37 (coerce-arg self) (sel_registerName "getRectsExposedDuringLiveResize:count:") exposed-rects count))
(define (nssplitview-help-requested self event-ptr)
  (tell #:type _void (coerce-arg self) helpRequested: (coerce-arg event-ptr)))
(define (nssplitview-hit-test self point)
  (wrap-objc-object
   (_msg-7 (coerce-arg self) (sel_registerName "hitTest:") point)
   ))
(define (nssplitview-holding-priority-for-subview-at-index self subview-index)
  (_msg-31 (coerce-arg self) (sel_registerName "holdingPriorityForSubviewAtIndex:") subview-index))
(define (nssplitview-interpret-key-events self event-array)
  (tell #:type _void (coerce-arg self) interpretKeyEvents: (coerce-arg event-array)))
(define (nssplitview-is-descendant-of self view)
  (_msg-28 (coerce-arg self) (sel_registerName "isDescendantOf:") (coerce-arg view)))
(define (nssplitview-is-flipped self)
  (_msg-1 (coerce-arg self) (sel_registerName "isFlipped")))
(define (nssplitview-is-hidden self)
  (_msg-1 (coerce-arg self) (sel_registerName "isHidden")))
(define (nssplitview-is-hidden-or-has-hidden-ancestor self)
  (_msg-1 (coerce-arg self) (sel_registerName "isHiddenOrHasHiddenAncestor")))
(define (nssplitview-is-opaque self)
  (_msg-1 (coerce-arg self) (sel_registerName "isOpaque")))
(define (nssplitview-is-rotated-from-base self)
  (_msg-1 (coerce-arg self) (sel_registerName "isRotatedFromBase")))
(define (nssplitview-is-rotated-or-scaled-from-base self)
  (_msg-1 (coerce-arg self) (sel_registerName "isRotatedOrScaledFromBase")))
(define (nssplitview-is-subview-collapsed self subview)
  (_msg-28 (coerce-arg self) (sel_registerName "isSubviewCollapsed:") (coerce-arg subview)))
(define (nssplitview-is-vertical self)
  (_msg-1 (coerce-arg self) (sel_registerName "isVertical")))
(define (nssplitview-key-down self event)
  (tell #:type _void (coerce-arg self) keyDown: (coerce-arg event)))
(define (nssplitview-key-up self event)
  (tell #:type _void (coerce-arg self) keyUp: (coerce-arg event)))
(define (nssplitview-layout self)
  (tell #:type _void (coerce-arg self) layout))
(define (nssplitview-layout-subtree-if-needed self)
  (tell #:type _void (coerce-arg self) layoutSubtreeIfNeeded))
(define (nssplitview-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) magnifyWithEvent: (coerce-arg event)))
(define (nssplitview-make-backing-layer self)
  (wrap-objc-object
   (tell (coerce-arg self) makeBackingLayer)))
(define (nssplitview-max-possible-position-of-divider-at-index self divider-index)
  (_msg-30 (coerce-arg self) (sel_registerName "maxPossiblePositionOfDividerAtIndex:") divider-index))
(define (nssplitview-menu-for-event self event)
  (wrap-objc-object
   (tell (coerce-arg self) menuForEvent: (coerce-arg event))))
(define (nssplitview-min-possible-position-of-divider-at-index self divider-index)
  (_msg-30 (coerce-arg self) (sel_registerName "minPossiblePositionOfDividerAtIndex:") divider-index))
(define (nssplitview-mouse-in-rect self point rect)
  (_msg-10 (coerce-arg self) (sel_registerName "mouse:inRect:") point rect))
(define (nssplitview-mouse-cancelled self event)
  (tell #:type _void (coerce-arg self) mouseCancelled: (coerce-arg event)))
(define (nssplitview-mouse-down self event)
  (tell #:type _void (coerce-arg self) mouseDown: (coerce-arg event)))
(define (nssplitview-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) mouseDragged: (coerce-arg event)))
(define (nssplitview-mouse-entered self event)
  (tell #:type _void (coerce-arg self) mouseEntered: (coerce-arg event)))
(define (nssplitview-mouse-exited self event)
  (tell #:type _void (coerce-arg self) mouseExited: (coerce-arg event)))
(define (nssplitview-mouse-moved self event)
  (tell #:type _void (coerce-arg self) mouseMoved: (coerce-arg event)))
(define (nssplitview-mouse-up self event)
  (tell #:type _void (coerce-arg self) mouseUp: (coerce-arg event)))
(define (nssplitview-needs-to-draw-rect self rect)
  (_msg-13 (coerce-arg self) (sel_registerName "needsToDrawRect:") rect))
(define (nssplitview-no-responder-for self event-selector)
  (_msg-34 (coerce-arg self) (sel_registerName "noResponderFor:") (sel_registerName event-selector)))
(define (nssplitview-other-mouse-down self event)
  (tell #:type _void (coerce-arg self) otherMouseDown: (coerce-arg event)))
(define (nssplitview-other-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) otherMouseDragged: (coerce-arg event)))
(define (nssplitview-other-mouse-up self event)
  (tell #:type _void (coerce-arg self) otherMouseUp: (coerce-arg event)))
(define (nssplitview-perform-key-equivalent! self event)
  (_msg-28 (coerce-arg self) (sel_registerName "performKeyEquivalent:") (coerce-arg event)))
(define (nssplitview-prepare-content-in-rect self rect)
  (_msg-15 (coerce-arg self) (sel_registerName "prepareContentInRect:") rect))
(define (nssplitview-prepare-for-reuse self)
  (tell #:type _void (coerce-arg self) prepareForReuse))
(define (nssplitview-pressure-change-with-event self event)
  (tell #:type _void (coerce-arg self) pressureChangeWithEvent: (coerce-arg event)))
(define (nssplitview-quick-look-with-event self event)
  (tell #:type _void (coerce-arg self) quickLookWithEvent: (coerce-arg event)))
(define (nssplitview-rect-for-smart-magnification-at-point-in-rect self location visible-rect)
  (_msg-9 (coerce-arg self) (sel_registerName "rectForSmartMagnificationAtPoint:inRect:") location visible-rect))
(define (nssplitview-remove-all-tool-tips! self)
  (tell #:type _void (coerce-arg self) removeAllToolTips))
(define (nssplitview-remove-from-superview! self)
  (tell #:type _void (coerce-arg self) removeFromSuperview))
(define (nssplitview-remove-from-superview-without-needing-display! self)
  (tell #:type _void (coerce-arg self) removeFromSuperviewWithoutNeedingDisplay))
(define (nssplitview-remove-tool-tip! self tag)
  (_msg-33 (coerce-arg self) (sel_registerName "removeToolTip:") tag))
(define (nssplitview-replace-subview-with! self old-view new-view)
  (tell #:type _void (coerce-arg self) replaceSubview: (coerce-arg old-view) with: (coerce-arg new-view)))
(define (nssplitview-resign-first-responder self)
  (_msg-1 (coerce-arg self) (sel_registerName "resignFirstResponder")))
(define (nssplitview-resize-subviews-with-old-size self old-size)
  (_msg-22 (coerce-arg self) (sel_registerName "resizeSubviewsWithOldSize:") old-size))
(define (nssplitview-resize-with-old-superview-size self old-size)
  (_msg-22 (coerce-arg self) (sel_registerName "resizeWithOldSuperviewSize:") old-size))
(define (nssplitview-right-mouse-down self event)
  (tell #:type _void (coerce-arg self) rightMouseDown: (coerce-arg event)))
(define (nssplitview-right-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) rightMouseDragged: (coerce-arg event)))
(define (nssplitview-right-mouse-up self event)
  (tell #:type _void (coerce-arg self) rightMouseUp: (coerce-arg event)))
(define (nssplitview-rotate-by-angle self angle)
  (_msg-25 (coerce-arg self) (sel_registerName "rotateByAngle:") angle))
(define (nssplitview-rotate-with-event self event)
  (tell #:type _void (coerce-arg self) rotateWithEvent: (coerce-arg event)))
(define (nssplitview-scale-unit-square-to-size self new-unit-size)
  (_msg-22 (coerce-arg self) (sel_registerName "scaleUnitSquareToSize:") new-unit-size))
(define (nssplitview-scroll-point self point)
  (_msg-8 (coerce-arg self) (sel_registerName "scrollPoint:") point))
(define (nssplitview-scroll-rect-to-visible self rect)
  (_msg-13 (coerce-arg self) (sel_registerName "scrollRectToVisible:") rect))
(define (nssplitview-scroll-wheel self event)
  (tell #:type _void (coerce-arg self) scrollWheel: (coerce-arg event)))
(define (nssplitview-set-bounds-origin! self new-origin)
  (_msg-8 (coerce-arg self) (sel_registerName "setBoundsOrigin:") new-origin))
(define (nssplitview-set-bounds-size! self new-size)
  (_msg-22 (coerce-arg self) (sel_registerName "setBoundsSize:") new-size))
(define (nssplitview-set-frame-origin! self new-origin)
  (_msg-8 (coerce-arg self) (sel_registerName "setFrameOrigin:") new-origin))
(define (nssplitview-set-frame-size! self new-size)
  (_msg-22 (coerce-arg self) (sel_registerName "setFrameSize:") new-size))
(define (nssplitview-set-holding-priority-for-subview-at-index! self priority subview-index)
  (_msg-27 (coerce-arg self) (sel_registerName "setHoldingPriority:forSubviewAtIndex:") priority subview-index))
(define (nssplitview-set-needs-display-in-rect! self invalid-rect)
  (_msg-15 (coerce-arg self) (sel_registerName "setNeedsDisplayInRect:") invalid-rect))
(define (nssplitview-set-position-of-divider-at-index! self position divider-index)
  (_msg-26 (coerce-arg self) (sel_registerName "setPosition:ofDividerAtIndex:") position divider-index))
(define (nssplitview-should-be-treated-as-ink-event self event)
  (_msg-28 (coerce-arg self) (sel_registerName "shouldBeTreatedAsInkEvent:") (coerce-arg event)))
(define (nssplitview-should-delay-window-ordering-for-event self event)
  (_msg-28 (coerce-arg self) (sel_registerName "shouldDelayWindowOrderingForEvent:") (coerce-arg event)))
(define (nssplitview-show-context-help self sender)
  (tell #:type _void (coerce-arg self) showContextHelp: (coerce-arg sender)))
(define (nssplitview-smart-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) smartMagnifyWithEvent: (coerce-arg event)))
(define (nssplitview-sort-subviews-using-function-context self compare context)
  (_msg-37 (coerce-arg self) (sel_registerName "sortSubviewsUsingFunction:context:") compare context))
(define (nssplitview-supplemental-target-for-action-sender self action sender)
  (wrap-objc-object
   (_msg-36 (coerce-arg self) (sel_registerName "supplementalTargetForAction:sender:") (sel_registerName action) (coerce-arg sender))
   ))
(define (nssplitview-swipe-with-event self event)
  (tell #:type _void (coerce-arg self) swipeWithEvent: (coerce-arg event)))
(define (nssplitview-tablet-point self event)
  (tell #:type _void (coerce-arg self) tabletPoint: (coerce-arg event)))
(define (nssplitview-tablet-proximity self event)
  (tell #:type _void (coerce-arg self) tabletProximity: (coerce-arg event)))
(define (nssplitview-touches-began-with-event self event)
  (tell #:type _void (coerce-arg self) touchesBeganWithEvent: (coerce-arg event)))
(define (nssplitview-touches-cancelled-with-event self event)
  (tell #:type _void (coerce-arg self) touchesCancelledWithEvent: (coerce-arg event)))
(define (nssplitview-touches-ended-with-event self event)
  (tell #:type _void (coerce-arg self) touchesEndedWithEvent: (coerce-arg event)))
(define (nssplitview-touches-moved-with-event self event)
  (tell #:type _void (coerce-arg self) touchesMovedWithEvent: (coerce-arg event)))
(define (nssplitview-translate-origin-to-point self translation)
  (_msg-8 (coerce-arg self) (sel_registerName "translateOriginToPoint:") translation))
(define (nssplitview-translate-rects-needing-display-in-rect-by self clip-rect delta)
  (_msg-16 (coerce-arg self) (sel_registerName "translateRectsNeedingDisplayInRect:by:") clip-rect delta))
(define (nssplitview-try-to-perform-with self action object)
  (_msg-35 (coerce-arg self) (sel_registerName "tryToPerform:with:") (sel_registerName action) (coerce-arg object)))
(define (nssplitview-update-layer self)
  (tell #:type _void (coerce-arg self) updateLayer))
(define (nssplitview-valid-requestor-for-send-type-return-type self send-type return-type)
  (wrap-objc-object
   (tell (coerce-arg self) validRequestorForSendType: (coerce-arg send-type) returnType: (coerce-arg return-type))))
(define (nssplitview-view-did-change-backing-properties self)
  (tell #:type _void (coerce-arg self) viewDidChangeBackingProperties))
(define (nssplitview-view-did-change-effective-appearance self)
  (tell #:type _void (coerce-arg self) viewDidChangeEffectiveAppearance))
(define (nssplitview-view-did-end-live-resize self)
  (tell #:type _void (coerce-arg self) viewDidEndLiveResize))
(define (nssplitview-view-did-hide self)
  (tell #:type _void (coerce-arg self) viewDidHide))
(define (nssplitview-view-did-move-to-superview self)
  (tell #:type _void (coerce-arg self) viewDidMoveToSuperview))
(define (nssplitview-view-did-move-to-window self)
  (tell #:type _void (coerce-arg self) viewDidMoveToWindow))
(define (nssplitview-view-did-unhide self)
  (tell #:type _void (coerce-arg self) viewDidUnhide))
(define (nssplitview-view-will-draw self)
  (tell #:type _void (coerce-arg self) viewWillDraw))
(define (nssplitview-view-will-move-to-superview self new-superview)
  (tell #:type _void (coerce-arg self) viewWillMoveToSuperview: (coerce-arg new-superview)))
(define (nssplitview-view-will-move-to-window self new-window)
  (tell #:type _void (coerce-arg self) viewWillMoveToWindow: (coerce-arg new-window)))
(define (nssplitview-view-will-start-live-resize self)
  (tell #:type _void (coerce-arg self) viewWillStartLiveResize))
(define (nssplitview-view-with-tag self tag)
  (wrap-objc-object
   (_msg-32 (coerce-arg self) (sel_registerName "viewWithTag:") tag)
   ))
(define (nssplitview-wants-forwarded-scroll-events-for-axis self axis)
  (_msg-38 (coerce-arg self) (sel_registerName "wantsForwardedScrollEventsForAxis:") axis))
(define (nssplitview-wants-scroll-events-for-swipe-tracking-on-axis self axis)
  (_msg-38 (coerce-arg self) (sel_registerName "wantsScrollEventsForSwipeTrackingOnAxis:") axis))
(define (nssplitview-will-open-menu-with-event self menu event)
  (tell #:type _void (coerce-arg self) willOpenMenu: (coerce-arg menu) withEvent: (coerce-arg event)))
(define (nssplitview-will-remove-subview self subview)
  (tell #:type _void (coerce-arg self) willRemoveSubview: (coerce-arg subview)))

;; --- Class methods ---
(define (nssplitview-is-compatible-with-responsive-scrolling)
  (_msg-1 NSSplitView (sel_registerName "isCompatibleWithResponsiveScrolling")))
