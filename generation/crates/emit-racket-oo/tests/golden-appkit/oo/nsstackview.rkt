#lang racket/base
;; Generated binding for NSStackView (AppKit)
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
(provide NSStackView)
(provide/contract
  [make-nsstackview-init-with-coder (c-> (or/c string? objc-object? #f) any/c)]
  [make-nsstackview-init-with-frame (c-> any/c any/c)]
  [nsstackview-accepts-first-responder (c-> objc-object? boolean?)]
  [nsstackview-accepts-touch-events (c-> objc-object? boolean?)]
  [nsstackview-set-accepts-touch-events! (c-> objc-object? boolean? void?)]
  [nsstackview-additional-safe-area-insets (c-> objc-object? any/c)]
  [nsstackview-set-additional-safe-area-insets! (c-> objc-object? any/c void?)]
  [nsstackview-alignment (c-> objc-object? exact-nonnegative-integer?)]
  [nsstackview-set-alignment! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsstackview-alignment-rect-insets (c-> objc-object? any/c)]
  [nsstackview-allowed-touch-types (c-> objc-object? exact-nonnegative-integer?)]
  [nsstackview-set-allowed-touch-types! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsstackview-allows-vibrancy (c-> objc-object? boolean?)]
  [nsstackview-alpha-value (c-> objc-object? real?)]
  [nsstackview-set-alpha-value! (c-> objc-object? real? void?)]
  [nsstackview-arranged-subviews (c-> objc-object? any/c)]
  [nsstackview-autoresizes-subviews (c-> objc-object? boolean?)]
  [nsstackview-set-autoresizes-subviews! (c-> objc-object? boolean? void?)]
  [nsstackview-autoresizing-mask (c-> objc-object? exact-nonnegative-integer?)]
  [nsstackview-set-autoresizing-mask! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsstackview-background-filters (c-> objc-object? any/c)]
  [nsstackview-set-background-filters! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-baseline-offset-from-bottom (c-> objc-object? real?)]
  [nsstackview-bottom-anchor (c-> objc-object? (or/c nslayoutyaxisanchor? objc-nil?))]
  [nsstackview-bounds (c-> objc-object? any/c)]
  [nsstackview-set-bounds! (c-> objc-object? any/c void?)]
  [nsstackview-bounds-rotation (c-> objc-object? real?)]
  [nsstackview-set-bounds-rotation! (c-> objc-object? real? void?)]
  [nsstackview-can-become-key-view (c-> objc-object? boolean?)]
  [nsstackview-can-draw (c-> objc-object? boolean?)]
  [nsstackview-can-draw-concurrently (c-> objc-object? boolean?)]
  [nsstackview-set-can-draw-concurrently! (c-> objc-object? boolean? void?)]
  [nsstackview-can-draw-subviews-into-layer (c-> objc-object? boolean?)]
  [nsstackview-set-can-draw-subviews-into-layer! (c-> objc-object? boolean? void?)]
  [nsstackview-candidate-list-touch-bar-item (c-> objc-object? (or/c nscandidatelisttouchbaritem? objc-nil?))]
  [nsstackview-center-x-anchor (c-> objc-object? (or/c nslayoutxaxisanchor? objc-nil?))]
  [nsstackview-center-y-anchor (c-> objc-object? (or/c nslayoutyaxisanchor? objc-nil?))]
  [nsstackview-clips-to-bounds (c-> objc-object? boolean?)]
  [nsstackview-set-clips-to-bounds! (c-> objc-object? boolean? void?)]
  [nsstackview-compatible-with-responsive-scrolling (c-> boolean?)]
  [nsstackview-compositing-filter (c-> objc-object? (or/c cifilter? objc-nil?))]
  [nsstackview-set-compositing-filter! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-constraints (c-> objc-object? any/c)]
  [nsstackview-content-filters (c-> objc-object? any/c)]
  [nsstackview-set-content-filters! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-default-focus-ring-type (c-> exact-nonnegative-integer?)]
  [nsstackview-default-menu (c-> (or/c nsmenu? objc-nil?))]
  [nsstackview-delegate (c-> objc-object? any/c)]
  [nsstackview-set-delegate! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-detached-views (c-> objc-object? any/c)]
  [nsstackview-detaches-hidden-views (c-> objc-object? boolean?)]
  [nsstackview-set-detaches-hidden-views! (c-> objc-object? boolean? void?)]
  [nsstackview-distribution (c-> objc-object? exact-nonnegative-integer?)]
  [nsstackview-set-distribution! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsstackview-drawing-find-indicator (c-> objc-object? boolean?)]
  [nsstackview-edge-insets (c-> objc-object? any/c)]
  [nsstackview-set-edge-insets! (c-> objc-object? any/c void?)]
  [nsstackview-enclosing-menu-item (c-> objc-object? (or/c nsmenuitem? objc-nil?))]
  [nsstackview-enclosing-scroll-view (c-> objc-object? (or/c nsscrollview? objc-nil?))]
  [nsstackview-first-baseline-anchor (c-> objc-object? (or/c nslayoutyaxisanchor? objc-nil?))]
  [nsstackview-first-baseline-offset-from-top (c-> objc-object? real?)]
  [nsstackview-fitting-size (c-> objc-object? any/c)]
  [nsstackview-flipped (c-> objc-object? boolean?)]
  [nsstackview-focus-ring-mask-bounds (c-> objc-object? any/c)]
  [nsstackview-focus-ring-type (c-> objc-object? exact-nonnegative-integer?)]
  [nsstackview-set-focus-ring-type! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsstackview-focus-view (c-> (or/c nsview? objc-nil?))]
  [nsstackview-frame (c-> objc-object? any/c)]
  [nsstackview-set-frame! (c-> objc-object? any/c void?)]
  [nsstackview-frame-center-rotation (c-> objc-object? real?)]
  [nsstackview-set-frame-center-rotation! (c-> objc-object? real? void?)]
  [nsstackview-frame-rotation (c-> objc-object? real?)]
  [nsstackview-set-frame-rotation! (c-> objc-object? real? void?)]
  [nsstackview-gesture-recognizers (c-> objc-object? any/c)]
  [nsstackview-set-gesture-recognizers! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-has-ambiguous-layout (c-> objc-object? boolean?)]
  [nsstackview-has-equal-spacing (c-> objc-object? boolean?)]
  [nsstackview-set-has-equal-spacing! (c-> objc-object? boolean? void?)]
  [nsstackview-height-adjust-limit (c-> objc-object? real?)]
  [nsstackview-height-anchor (c-> objc-object? (or/c nslayoutdimension? objc-nil?))]
  [nsstackview-hidden (c-> objc-object? boolean?)]
  [nsstackview-set-hidden! (c-> objc-object? boolean? void?)]
  [nsstackview-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nsstackview-horizontal-content-size-constraint-active (c-> objc-object? boolean?)]
  [nsstackview-set-horizontal-content-size-constraint-active! (c-> objc-object? boolean? void?)]
  [nsstackview-in-full-screen-mode (c-> objc-object? boolean?)]
  [nsstackview-in-live-resize (c-> objc-object? boolean?)]
  [nsstackview-input-context (c-> objc-object? (or/c nstextinputcontext? objc-nil?))]
  [nsstackview-intrinsic-content-size (c-> objc-object? any/c)]
  [nsstackview-last-baseline-anchor (c-> objc-object? (or/c nslayoutyaxisanchor? objc-nil?))]
  [nsstackview-last-baseline-offset-from-bottom (c-> objc-object? real?)]
  [nsstackview-layer (c-> objc-object? (or/c calayer? objc-nil?))]
  [nsstackview-set-layer! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-layer-contents-placement (c-> objc-object? exact-nonnegative-integer?)]
  [nsstackview-set-layer-contents-placement! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsstackview-layer-contents-redraw-policy (c-> objc-object? exact-nonnegative-integer?)]
  [nsstackview-set-layer-contents-redraw-policy! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsstackview-layer-uses-core-image-filters (c-> objc-object? boolean?)]
  [nsstackview-set-layer-uses-core-image-filters! (c-> objc-object? boolean? void?)]
  [nsstackview-layout-guides (c-> objc-object? any/c)]
  [nsstackview-layout-margins-guide (c-> objc-object? (or/c nslayoutguide? objc-nil?))]
  [nsstackview-leading-anchor (c-> objc-object? (or/c nslayoutxaxisanchor? objc-nil?))]
  [nsstackview-left-anchor (c-> objc-object? (or/c nslayoutxaxisanchor? objc-nil?))]
  [nsstackview-menu (c-> objc-object? (or/c nsmenu? objc-nil?))]
  [nsstackview-set-menu! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-mouse-down-can-move-window (c-> objc-object? boolean?)]
  [nsstackview-needs-display (c-> objc-object? boolean?)]
  [nsstackview-set-needs-display! (c-> objc-object? boolean? void?)]
  [nsstackview-needs-layout (c-> objc-object? boolean?)]
  [nsstackview-set-needs-layout! (c-> objc-object? boolean? void?)]
  [nsstackview-needs-panel-to-become-key (c-> objc-object? boolean?)]
  [nsstackview-needs-update-constraints (c-> objc-object? boolean?)]
  [nsstackview-set-needs-update-constraints! (c-> objc-object? boolean? void?)]
  [nsstackview-next-key-view (c-> objc-object? (or/c nsview? objc-nil?))]
  [nsstackview-set-next-key-view! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-next-responder (c-> objc-object? (or/c nsresponder? objc-nil?))]
  [nsstackview-set-next-responder! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-next-valid-key-view (c-> objc-object? (or/c nsview? objc-nil?))]
  [nsstackview-opaque (c-> objc-object? boolean?)]
  [nsstackview-opaque-ancestor (c-> objc-object? (or/c nsview? objc-nil?))]
  [nsstackview-orientation (c-> objc-object? exact-nonnegative-integer?)]
  [nsstackview-set-orientation! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsstackview-page-footer (c-> objc-object? (or/c nsattributedstring? objc-nil?))]
  [nsstackview-page-header (c-> objc-object? (or/c nsattributedstring? objc-nil?))]
  [nsstackview-posts-bounds-changed-notifications (c-> objc-object? boolean?)]
  [nsstackview-set-posts-bounds-changed-notifications! (c-> objc-object? boolean? void?)]
  [nsstackview-posts-frame-changed-notifications (c-> objc-object? boolean?)]
  [nsstackview-set-posts-frame-changed-notifications! (c-> objc-object? boolean? void?)]
  [nsstackview-prefers-compact-control-size-metrics (c-> objc-object? boolean?)]
  [nsstackview-set-prefers-compact-control-size-metrics! (c-> objc-object? boolean? void?)]
  [nsstackview-prepared-content-rect (c-> objc-object? any/c)]
  [nsstackview-set-prepared-content-rect! (c-> objc-object? any/c void?)]
  [nsstackview-preserves-content-during-live-resize (c-> objc-object? boolean?)]
  [nsstackview-pressure-configuration (c-> objc-object? (or/c nspressureconfiguration? objc-nil?))]
  [nsstackview-set-pressure-configuration! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-previous-key-view (c-> objc-object? (or/c nsview? objc-nil?))]
  [nsstackview-previous-valid-key-view (c-> objc-object? (or/c nsview? objc-nil?))]
  [nsstackview-print-job-title (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nsstackview-rect-preserved-during-live-resize (c-> objc-object? any/c)]
  [nsstackview-registered-dragged-types (c-> objc-object? any/c)]
  [nsstackview-requires-constraint-based-layout (c-> boolean?)]
  [nsstackview-restorable-state-key-paths (c-> any/c)]
  [nsstackview-right-anchor (c-> objc-object? (or/c nslayoutxaxisanchor? objc-nil?))]
  [nsstackview-rotated-from-base (c-> objc-object? boolean?)]
  [nsstackview-rotated-or-scaled-from-base (c-> objc-object? boolean?)]
  [nsstackview-safe-area-insets (c-> objc-object? any/c)]
  [nsstackview-safe-area-layout-guide (c-> objc-object? (or/c nslayoutguide? objc-nil?))]
  [nsstackview-safe-area-rect (c-> objc-object? any/c)]
  [nsstackview-shadow (c-> objc-object? (or/c nsshadow? objc-nil?))]
  [nsstackview-set-shadow! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-spacing (c-> objc-object? real?)]
  [nsstackview-set-spacing! (c-> objc-object? real? void?)]
  [nsstackview-subviews (c-> objc-object? any/c)]
  [nsstackview-set-subviews! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-superview (c-> objc-object? (or/c nsview? objc-nil?))]
  [nsstackview-tag (c-> objc-object? exact-integer?)]
  [nsstackview-tool-tip (c-> objc-object? (or/c nsstring? objc-nil?))]
  [nsstackview-set-tool-tip! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-top-anchor (c-> objc-object? (or/c nslayoutyaxisanchor? objc-nil?))]
  [nsstackview-touch-bar (c-> objc-object? (or/c nstouchbar? objc-nil?))]
  [nsstackview-set-touch-bar! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-tracking-areas (c-> objc-object? any/c)]
  [nsstackview-trailing-anchor (c-> objc-object? (or/c nslayoutxaxisanchor? objc-nil?))]
  [nsstackview-translates-autoresizing-mask-into-constraints (c-> objc-object? boolean?)]
  [nsstackview-set-translates-autoresizing-mask-into-constraints! (c-> objc-object? boolean? void?)]
  [nsstackview-undo-manager (c-> objc-object? (or/c nsundomanager? objc-nil?))]
  [nsstackview-user-activity (c-> objc-object? (or/c nsuseractivity? objc-nil?))]
  [nsstackview-set-user-activity! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-user-interface-layout-direction (c-> objc-object? exact-nonnegative-integer?)]
  [nsstackview-set-user-interface-layout-direction! (c-> objc-object? exact-nonnegative-integer? void?)]
  [nsstackview-vertical-content-size-constraint-active (c-> objc-object? boolean?)]
  [nsstackview-set-vertical-content-size-constraint-active! (c-> objc-object? boolean? void?)]
  [nsstackview-views (c-> objc-object? any/c)]
  [nsstackview-visible-rect (c-> objc-object? any/c)]
  [nsstackview-wants-best-resolution-open-gl-surface (c-> objc-object? boolean?)]
  [nsstackview-set-wants-best-resolution-open-gl-surface! (c-> objc-object? boolean? void?)]
  [nsstackview-wants-default-clipping (c-> objc-object? boolean?)]
  [nsstackview-wants-extended-dynamic-range-open-gl-surface (c-> objc-object? boolean?)]
  [nsstackview-set-wants-extended-dynamic-range-open-gl-surface! (c-> objc-object? boolean? void?)]
  [nsstackview-wants-layer (c-> objc-object? boolean?)]
  [nsstackview-set-wants-layer! (c-> objc-object? boolean? void?)]
  [nsstackview-wants-resting-touches (c-> objc-object? boolean?)]
  [nsstackview-set-wants-resting-touches! (c-> objc-object? boolean? void?)]
  [nsstackview-wants-update-layer (c-> objc-object? boolean?)]
  [nsstackview-width-adjust-limit (c-> objc-object? real?)]
  [nsstackview-width-anchor (c-> objc-object? (or/c nslayoutdimension? objc-nil?))]
  [nsstackview-window (c-> objc-object? (or/c nswindow? objc-nil?))]
  [nsstackview-writing-tools-coordinator (c-> objc-object? (or/c nswritingtoolscoordinator? objc-nil?))]
  [nsstackview-set-writing-tools-coordinator! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-accepts-first-mouse (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nsstackview-add-arranged-subview! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-add-subview! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-add-subview-positioned-relative-to! (c-> objc-object? (or/c string? objc-object? #f) exact-nonnegative-integer? (or/c string? objc-object? #f) void?)]
  [nsstackview-add-tool-tip-rect-owner-user-data! (c-> objc-object? any/c (or/c string? objc-object? #f) (or/c cpointer? #f) exact-integer?)]
  [nsstackview-adjust-scroll (c-> objc-object? any/c any/c)]
  [nsstackview-ancestor-shared-with-view (c-> objc-object? (or/c string? objc-object? #f) (or/c nsview? objc-nil?))]
  [nsstackview-autoscroll (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nsstackview-backing-aligned-rect-options (c-> objc-object? any/c exact-nonnegative-integer? any/c)]
  [nsstackview-become-first-responder (c-> objc-object? boolean?)]
  [nsstackview-begin-gesture-with-event! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-bitmap-image-rep-for-caching-display-in-rect (c-> objc-object? any/c (or/c nsbitmapimagerep? objc-nil?))]
  [nsstackview-cache-display-in-rect-to-bitmap-image-rep (c-> objc-object? any/c (or/c string? objc-object? #f) void?)]
  [nsstackview-center-scan-rect! (c-> objc-object? any/c any/c)]
  [nsstackview-change-mode-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-clipping-resistance-priority-for-orientation (c-> objc-object? exact-nonnegative-integer? real?)]
  [nsstackview-context-menu-key-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-convert-point-from-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nsstackview-convert-point-to-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nsstackview-convert-point-from-backing (c-> objc-object? any/c any/c)]
  [nsstackview-convert-point-from-layer (c-> objc-object? any/c any/c)]
  [nsstackview-convert-point-to-backing (c-> objc-object? any/c any/c)]
  [nsstackview-convert-point-to-layer (c-> objc-object? any/c any/c)]
  [nsstackview-convert-rect-from-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nsstackview-convert-rect-to-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nsstackview-convert-rect-from-backing (c-> objc-object? any/c any/c)]
  [nsstackview-convert-rect-from-layer (c-> objc-object? any/c any/c)]
  [nsstackview-convert-rect-to-backing (c-> objc-object? any/c any/c)]
  [nsstackview-convert-rect-to-layer (c-> objc-object? any/c any/c)]
  [nsstackview-convert-size-from-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nsstackview-convert-size-to-view (c-> objc-object? any/c (or/c string? objc-object? #f) any/c)]
  [nsstackview-convert-size-from-backing (c-> objc-object? any/c any/c)]
  [nsstackview-convert-size-from-layer (c-> objc-object? any/c any/c)]
  [nsstackview-convert-size-to-backing (c-> objc-object? any/c any/c)]
  [nsstackview-convert-size-to-layer (c-> objc-object? any/c any/c)]
  [nsstackview-cursor-update (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-custom-spacing-after-view (c-> objc-object? (or/c string? objc-object? #f) real?)]
  [nsstackview-did-add-subview (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-did-close-menu-with-event (c-> objc-object? (or/c string? objc-object? #f) (or/c string? objc-object? #f) void?)]
  [nsstackview-display! (c-> objc-object? void?)]
  [nsstackview-display-if-needed! (c-> objc-object? void?)]
  [nsstackview-display-if-needed-ignoring-opacity! (c-> objc-object? void?)]
  [nsstackview-display-if-needed-in-rect! (c-> objc-object? any/c void?)]
  [nsstackview-display-if-needed-in-rect-ignoring-opacity! (c-> objc-object? any/c void?)]
  [nsstackview-display-rect! (c-> objc-object? any/c void?)]
  [nsstackview-display-rect-ignoring-opacity! (c-> objc-object? any/c void?)]
  [nsstackview-display-rect-ignoring-opacity-in-context! (c-> objc-object? any/c (or/c string? objc-object? #f) void?)]
  [nsstackview-draw-rect (c-> objc-object? any/c void?)]
  [nsstackview-end-gesture-with-event! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-flags-changed (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-flush-buffered-key-events (c-> objc-object? void?)]
  [nsstackview-get-rects-being-drawn-count (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nsstackview-get-rects-exposed-during-live-resize-count (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nsstackview-help-requested (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-hit-test (c-> objc-object? any/c (or/c nsview? objc-nil?))]
  [nsstackview-hugging-priority-for-orientation (c-> objc-object? exact-nonnegative-integer? real?)]
  [nsstackview-insert-arranged-subview-at-index! (c-> objc-object? (or/c string? objc-object? #f) exact-integer? void?)]
  [nsstackview-interpret-key-events (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-is-descendant-of (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nsstackview-is-flipped (c-> objc-object? boolean?)]
  [nsstackview-is-hidden (c-> objc-object? boolean?)]
  [nsstackview-is-hidden-or-has-hidden-ancestor (c-> objc-object? boolean?)]
  [nsstackview-is-opaque (c-> objc-object? boolean?)]
  [nsstackview-is-rotated-from-base (c-> objc-object? boolean?)]
  [nsstackview-is-rotated-or-scaled-from-base (c-> objc-object? boolean?)]
  [nsstackview-key-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-key-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-layout (c-> objc-object? void?)]
  [nsstackview-layout-subtree-if-needed (c-> objc-object? void?)]
  [nsstackview-magnify-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-make-backing-layer (c-> objc-object? (or/c calayer? objc-nil?))]
  [nsstackview-menu-for-event (c-> objc-object? (or/c string? objc-object? #f) (or/c nsmenu? objc-nil?))]
  [nsstackview-mouse-in-rect (c-> objc-object? any/c any/c boolean?)]
  [nsstackview-mouse-cancelled (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-mouse-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-mouse-dragged (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-mouse-entered (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-mouse-exited (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-mouse-moved (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-mouse-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-needs-to-draw-rect (c-> objc-object? any/c boolean?)]
  [nsstackview-no-responder-for (c-> objc-object? string? void?)]
  [nsstackview-other-mouse-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-other-mouse-dragged (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-other-mouse-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-perform-key-equivalent! (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nsstackview-prepare-content-in-rect (c-> objc-object? any/c void?)]
  [nsstackview-prepare-for-reuse (c-> objc-object? void?)]
  [nsstackview-pressure-change-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-quick-look-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-rect-for-smart-magnification-at-point-in-rect (c-> objc-object? any/c any/c any/c)]
  [nsstackview-remove-all-tool-tips! (c-> objc-object? void?)]
  [nsstackview-remove-arranged-subview! (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-remove-from-superview! (c-> objc-object? void?)]
  [nsstackview-remove-from-superview-without-needing-display! (c-> objc-object? void?)]
  [nsstackview-remove-tool-tip! (c-> objc-object? exact-integer? void?)]
  [nsstackview-replace-subview-with! (c-> objc-object? (or/c string? objc-object? #f) (or/c string? objc-object? #f) void?)]
  [nsstackview-resign-first-responder (c-> objc-object? boolean?)]
  [nsstackview-resize-subviews-with-old-size (c-> objc-object? any/c void?)]
  [nsstackview-resize-with-old-superview-size (c-> objc-object? any/c void?)]
  [nsstackview-right-mouse-down (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-right-mouse-dragged (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-right-mouse-up (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-rotate-by-angle (c-> objc-object? real? void?)]
  [nsstackview-rotate-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-scale-unit-square-to-size (c-> objc-object? any/c void?)]
  [nsstackview-scroll-point (c-> objc-object? any/c void?)]
  [nsstackview-scroll-rect-to-visible (c-> objc-object? any/c boolean?)]
  [nsstackview-scroll-wheel (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-set-bounds-origin! (c-> objc-object? any/c void?)]
  [nsstackview-set-bounds-size! (c-> objc-object? any/c void?)]
  [nsstackview-set-clipping-resistance-priority-for-orientation! (c-> objc-object? real? exact-nonnegative-integer? void?)]
  [nsstackview-set-custom-spacing-after-view! (c-> objc-object? real? (or/c string? objc-object? #f) void?)]
  [nsstackview-set-frame-origin! (c-> objc-object? any/c void?)]
  [nsstackview-set-frame-size! (c-> objc-object? any/c void?)]
  [nsstackview-set-hugging-priority-for-orientation! (c-> objc-object? real? exact-nonnegative-integer? void?)]
  [nsstackview-set-needs-display-in-rect! (c-> objc-object? any/c void?)]
  [nsstackview-set-visibility-priority-for-view! (c-> objc-object? real? (or/c string? objc-object? #f) void?)]
  [nsstackview-should-be-treated-as-ink-event (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nsstackview-should-delay-window-ordering-for-event (c-> objc-object? (or/c string? objc-object? #f) boolean?)]
  [nsstackview-show-context-help (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-smart-magnify-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-sort-subviews-using-function-context (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nsstackview-supplemental-target-for-action-sender (c-> objc-object? string? (or/c string? objc-object? #f) any/c)]
  [nsstackview-swipe-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-tablet-point (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-tablet-proximity (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-touches-began-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-touches-cancelled-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-touches-ended-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-touches-moved-with-event (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-translate-origin-to-point (c-> objc-object? any/c void?)]
  [nsstackview-translate-rects-needing-display-in-rect-by (c-> objc-object? any/c any/c void?)]
  [nsstackview-try-to-perform-with (c-> objc-object? string? (or/c string? objc-object? #f) boolean?)]
  [nsstackview-update-layer (c-> objc-object? void?)]
  [nsstackview-valid-requestor-for-send-type-return-type (c-> objc-object? (or/c string? objc-object? #f) (or/c string? objc-object? #f) any/c)]
  [nsstackview-view-did-change-backing-properties (c-> objc-object? void?)]
  [nsstackview-view-did-change-effective-appearance (c-> objc-object? void?)]
  [nsstackview-view-did-end-live-resize (c-> objc-object? void?)]
  [nsstackview-view-did-hide (c-> objc-object? void?)]
  [nsstackview-view-did-move-to-superview (c-> objc-object? void?)]
  [nsstackview-view-did-move-to-window (c-> objc-object? void?)]
  [nsstackview-view-did-unhide (c-> objc-object? void?)]
  [nsstackview-view-will-draw (c-> objc-object? void?)]
  [nsstackview-view-will-move-to-superview (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-view-will-move-to-window (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-view-will-start-live-resize (c-> objc-object? void?)]
  [nsstackview-view-with-tag (c-> objc-object? exact-integer? any/c)]
  [nsstackview-visibility-priority-for-view (c-> objc-object? (or/c string? objc-object? #f) real?)]
  [nsstackview-wants-forwarded-scroll-events-for-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nsstackview-wants-scroll-events-for-swipe-tracking-on-axis (c-> objc-object? exact-nonnegative-integer? boolean?)]
  [nsstackview-will-open-menu-with-event (c-> objc-object? (or/c string? objc-object? #f) (or/c string? objc-object? #f) void?)]
  [nsstackview-will-remove-subview (c-> objc-object? (or/c string? objc-object? #f) void?)]
  [nsstackview-is-compatible-with-responsive-scrolling (c-> boolean?)]
  [nsstackview-stack-view-with-views (c-> (or/c string? objc-object? #f) any/c)]
  )

;; --- Class reference ---
(import-class NSStackView)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _NSEdgeInsets)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _NSEdgeInsets)))
(define _msg-1  ; (_fun _pointer _pointer -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _NSRect)))
(define _msg-2  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-3  ; (_fun _pointer _pointer -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _double)))
(define _msg-4  ; (_fun _pointer _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _int64)))
(define _msg-5  ; (_fun _pointer _pointer -> _uint64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _uint64)))
(define _msg-6  ; (_fun _pointer _pointer _NSEdgeInsets -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSEdgeInsets -> _void)))
(define _msg-7  ; (_fun _pointer _pointer _NSPoint -> _NSPoint)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _NSPoint)))
(define _msg-8  ; (_fun _pointer _pointer _NSPoint -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _id)))
(define _msg-9  ; (_fun _pointer _pointer _NSPoint -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint -> _void)))
(define _msg-10  ; (_fun _pointer _pointer _NSPoint _NSRect -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _NSRect -> _NSRect)))
(define _msg-11  ; (_fun _pointer _pointer _NSPoint _NSRect -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _NSRect -> _bool)))
(define _msg-12  ; (_fun _pointer _pointer _NSPoint _id -> _NSPoint)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSPoint _id -> _NSPoint)))
(define _msg-13  ; (_fun _pointer _pointer _NSRect -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _NSRect)))
(define _msg-14  ; (_fun _pointer _pointer _NSRect -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _bool)))
(define _msg-15  ; (_fun _pointer _pointer _NSRect -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _id)))
(define _msg-16  ; (_fun _pointer _pointer _NSRect -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _void)))
(define _msg-17  ; (_fun _pointer _pointer _NSRect _NSSize -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _NSSize -> _void)))
(define _msg-18  ; (_fun _pointer _pointer _NSRect _id -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id -> _NSRect)))
(define _msg-19  ; (_fun _pointer _pointer _NSRect _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id -> _void)))
(define _msg-20  ; (_fun _pointer _pointer _NSRect _id _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _id _pointer -> _int64)))
(define _msg-21  ; (_fun _pointer _pointer _NSRect _uint64 -> _NSRect)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect _uint64 -> _NSRect)))
(define _msg-22  ; (_fun _pointer _pointer _NSSize -> _NSSize)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize -> _NSSize)))
(define _msg-23  ; (_fun _pointer _pointer _NSSize -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize -> _void)))
(define _msg-24  ; (_fun _pointer _pointer _NSSize _id -> _NSSize)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSSize _id -> _NSSize)))
(define _msg-25  ; (_fun _pointer _pointer _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool -> _void)))
(define _msg-26  ; (_fun _pointer _pointer _double -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double -> _void)))
(define _msg-27  ; (_fun _pointer _pointer _double _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double _id -> _void)))
(define _msg-28  ; (_fun _pointer _pointer _float _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _float _id -> _void)))
(define _msg-29  ; (_fun _pointer _pointer _float _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _float _int64 -> _void)))
(define _msg-30  ; (_fun _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _bool)))
(define _msg-31  ; (_fun _pointer _pointer _id -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _double)))
(define _msg-32  ; (_fun _pointer _pointer _id -> _float)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id -> _float)))
(define _msg-33  ; (_fun _pointer _pointer _id _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _int64 -> _void)))
(define _msg-34  ; (_fun _pointer _pointer _id _int64 _id -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _int64 _id -> _void)))
(define _msg-35  ; (_fun _pointer _pointer _int64 -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _bool)))
(define _msg-36  ; (_fun _pointer _pointer _int64 -> _float)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _float)))
(define _msg-37  ; (_fun _pointer _pointer _int64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _id)))
(define _msg-38  ; (_fun _pointer _pointer _int64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _int64 -> _void)))
(define _msg-39  ; (_fun _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))
(define _msg-40  ; (_fun _pointer _pointer _pointer _id -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _bool)))
(define _msg-41  ; (_fun _pointer _pointer _pointer _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _id -> _id)))
(define _msg-42  ; (_fun _pointer _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _pointer -> _void)))
(define _msg-43  ; (_fun _pointer _pointer _uint64 -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _void)))

;; --- Constructors ---
(define (make-nsstackview-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSStackView alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))

(define (make-nsstackview-init-with-frame frame-rect)
  (wrap-objc-object
   (_msg-15 (tell NSStackView alloc)
       (sel_registerName "initWithFrame:")
       frame-rect)
   #:retained #t))


;; --- Properties ---
(define (nsstackview-accepts-first-responder self)
  (tell #:type _bool (coerce-arg self) acceptsFirstResponder))
(define (nsstackview-accepts-touch-events self)
  (tell #:type _bool (coerce-arg self) acceptsTouchEvents))
(define (nsstackview-set-accepts-touch-events! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setAcceptsTouchEvents:") value))
(define (nsstackview-additional-safe-area-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) additionalSafeAreaInsets))
(define (nsstackview-set-additional-safe-area-insets! self value)
  (_msg-6 (coerce-arg self) (sel_registerName "setAdditionalSafeAreaInsets:") value))
(define (nsstackview-alignment self)
  (tell #:type _int64 (coerce-arg self) alignment))
(define (nsstackview-set-alignment! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setAlignment:") value))
(define (nsstackview-alignment-rect-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) alignmentRectInsets))
(define (nsstackview-allowed-touch-types self)
  (tell #:type _uint64 (coerce-arg self) allowedTouchTypes))
(define (nsstackview-set-allowed-touch-types! self value)
  (_msg-43 (coerce-arg self) (sel_registerName "setAllowedTouchTypes:") value))
(define (nsstackview-allows-vibrancy self)
  (tell #:type _bool (coerce-arg self) allowsVibrancy))
(define (nsstackview-alpha-value self)
  (tell #:type _double (coerce-arg self) alphaValue))
(define (nsstackview-set-alpha-value! self value)
  (_msg-26 (coerce-arg self) (sel_registerName "setAlphaValue:") value))
(define (nsstackview-arranged-subviews self)
  (wrap-objc-object
   (tell (coerce-arg self) arrangedSubviews)))
(define (nsstackview-autoresizes-subviews self)
  (tell #:type _bool (coerce-arg self) autoresizesSubviews))
(define (nsstackview-set-autoresizes-subviews! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setAutoresizesSubviews:") value))
(define (nsstackview-autoresizing-mask self)
  (tell #:type _uint64 (coerce-arg self) autoresizingMask))
(define (nsstackview-set-autoresizing-mask! self value)
  (_msg-43 (coerce-arg self) (sel_registerName "setAutoresizingMask:") value))
(define (nsstackview-background-filters self)
  (wrap-objc-object
   (tell (coerce-arg self) backgroundFilters)))
(define (nsstackview-set-background-filters! self value)
  (tell #:type _void (coerce-arg self) setBackgroundFilters: (coerce-arg value)))
(define (nsstackview-baseline-offset-from-bottom self)
  (tell #:type _double (coerce-arg self) baselineOffsetFromBottom))
(define (nsstackview-bottom-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) bottomAnchor)))
(define (nsstackview-bounds self)
  (tell #:type _NSRect (coerce-arg self) bounds))
(define (nsstackview-set-bounds! self value)
  (_msg-16 (coerce-arg self) (sel_registerName "setBounds:") value))
(define (nsstackview-bounds-rotation self)
  (tell #:type _double (coerce-arg self) boundsRotation))
(define (nsstackview-set-bounds-rotation! self value)
  (_msg-26 (coerce-arg self) (sel_registerName "setBoundsRotation:") value))
(define (nsstackview-can-become-key-view self)
  (tell #:type _bool (coerce-arg self) canBecomeKeyView))
(define (nsstackview-can-draw self)
  (tell #:type _bool (coerce-arg self) canDraw))
(define (nsstackview-can-draw-concurrently self)
  (tell #:type _bool (coerce-arg self) canDrawConcurrently))
(define (nsstackview-set-can-draw-concurrently! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setCanDrawConcurrently:") value))
(define (nsstackview-can-draw-subviews-into-layer self)
  (tell #:type _bool (coerce-arg self) canDrawSubviewsIntoLayer))
(define (nsstackview-set-can-draw-subviews-into-layer! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setCanDrawSubviewsIntoLayer:") value))
(define (nsstackview-candidate-list-touch-bar-item self)
  (wrap-objc-object
   (tell (coerce-arg self) candidateListTouchBarItem)))
(define (nsstackview-center-x-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) centerXAnchor)))
(define (nsstackview-center-y-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) centerYAnchor)))
(define (nsstackview-clips-to-bounds self)
  (tell #:type _bool (coerce-arg self) clipsToBounds))
(define (nsstackview-set-clips-to-bounds! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setClipsToBounds:") value))
(define (nsstackview-compatible-with-responsive-scrolling)
  (tell #:type _bool NSStackView compatibleWithResponsiveScrolling))
(define (nsstackview-compositing-filter self)
  (wrap-objc-object
   (tell (coerce-arg self) compositingFilter)))
(define (nsstackview-set-compositing-filter! self value)
  (tell #:type _void (coerce-arg self) setCompositingFilter: (coerce-arg value)))
(define (nsstackview-constraints self)
  (wrap-objc-object
   (tell (coerce-arg self) constraints)))
(define (nsstackview-content-filters self)
  (wrap-objc-object
   (tell (coerce-arg self) contentFilters)))
(define (nsstackview-set-content-filters! self value)
  (tell #:type _void (coerce-arg self) setContentFilters: (coerce-arg value)))
(define (nsstackview-default-focus-ring-type)
  (tell #:type _uint64 NSStackView defaultFocusRingType))
(define (nsstackview-default-menu)
  (wrap-objc-object
   (tell NSStackView defaultMenu)))
(define (nsstackview-delegate self)
  (wrap-objc-object
   (tell (coerce-arg self) delegate)))
(define (nsstackview-set-delegate! self value)
  (tell #:type _void (coerce-arg self) setDelegate: (coerce-arg value)))
(define (nsstackview-detached-views self)
  (wrap-objc-object
   (tell (coerce-arg self) detachedViews)))
(define (nsstackview-detaches-hidden-views self)
  (tell #:type _bool (coerce-arg self) detachesHiddenViews))
(define (nsstackview-set-detaches-hidden-views! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setDetachesHiddenViews:") value))
(define (nsstackview-distribution self)
  (tell #:type _int64 (coerce-arg self) distribution))
(define (nsstackview-set-distribution! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setDistribution:") value))
(define (nsstackview-drawing-find-indicator self)
  (tell #:type _bool (coerce-arg self) drawingFindIndicator))
(define (nsstackview-edge-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) edgeInsets))
(define (nsstackview-set-edge-insets! self value)
  (_msg-6 (coerce-arg self) (sel_registerName "setEdgeInsets:") value))
(define (nsstackview-enclosing-menu-item self)
  (wrap-objc-object
   (tell (coerce-arg self) enclosingMenuItem)))
(define (nsstackview-enclosing-scroll-view self)
  (wrap-objc-object
   (tell (coerce-arg self) enclosingScrollView)))
(define (nsstackview-first-baseline-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) firstBaselineAnchor)))
(define (nsstackview-first-baseline-offset-from-top self)
  (tell #:type _double (coerce-arg self) firstBaselineOffsetFromTop))
(define (nsstackview-fitting-size self)
  (tell #:type _NSSize (coerce-arg self) fittingSize))
(define (nsstackview-flipped self)
  (tell #:type _bool (coerce-arg self) flipped))
(define (nsstackview-focus-ring-mask-bounds self)
  (tell #:type _NSRect (coerce-arg self) focusRingMaskBounds))
(define (nsstackview-focus-ring-type self)
  (tell #:type _uint64 (coerce-arg self) focusRingType))
(define (nsstackview-set-focus-ring-type! self value)
  (_msg-43 (coerce-arg self) (sel_registerName "setFocusRingType:") value))
(define (nsstackview-focus-view)
  (wrap-objc-object
   (tell NSStackView focusView)))
(define (nsstackview-frame self)
  (tell #:type _NSRect (coerce-arg self) frame))
(define (nsstackview-set-frame! self value)
  (_msg-16 (coerce-arg self) (sel_registerName "setFrame:") value))
(define (nsstackview-frame-center-rotation self)
  (tell #:type _double (coerce-arg self) frameCenterRotation))
(define (nsstackview-set-frame-center-rotation! self value)
  (_msg-26 (coerce-arg self) (sel_registerName "setFrameCenterRotation:") value))
(define (nsstackview-frame-rotation self)
  (tell #:type _double (coerce-arg self) frameRotation))
(define (nsstackview-set-frame-rotation! self value)
  (_msg-26 (coerce-arg self) (sel_registerName "setFrameRotation:") value))
(define (nsstackview-gesture-recognizers self)
  (wrap-objc-object
   (tell (coerce-arg self) gestureRecognizers)))
(define (nsstackview-set-gesture-recognizers! self value)
  (tell #:type _void (coerce-arg self) setGestureRecognizers: (coerce-arg value)))
(define (nsstackview-has-ambiguous-layout self)
  (tell #:type _bool (coerce-arg self) hasAmbiguousLayout))
(define (nsstackview-has-equal-spacing self)
  (tell #:type _bool (coerce-arg self) hasEqualSpacing))
(define (nsstackview-set-has-equal-spacing! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setHasEqualSpacing:") value))
(define (nsstackview-height-adjust-limit self)
  (tell #:type _double (coerce-arg self) heightAdjustLimit))
(define (nsstackview-height-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) heightAnchor)))
(define (nsstackview-hidden self)
  (tell #:type _bool (coerce-arg self) hidden))
(define (nsstackview-set-hidden! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setHidden:") value))
(define (nsstackview-hidden-or-has-hidden-ancestor self)
  (tell #:type _bool (coerce-arg self) hiddenOrHasHiddenAncestor))
(define (nsstackview-horizontal-content-size-constraint-active self)
  (tell #:type _bool (coerce-arg self) horizontalContentSizeConstraintActive))
(define (nsstackview-set-horizontal-content-size-constraint-active! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setHorizontalContentSizeConstraintActive:") value))
(define (nsstackview-in-full-screen-mode self)
  (tell #:type _bool (coerce-arg self) inFullScreenMode))
(define (nsstackview-in-live-resize self)
  (tell #:type _bool (coerce-arg self) inLiveResize))
(define (nsstackview-input-context self)
  (wrap-objc-object
   (tell (coerce-arg self) inputContext)))
(define (nsstackview-intrinsic-content-size self)
  (tell #:type _NSSize (coerce-arg self) intrinsicContentSize))
(define (nsstackview-last-baseline-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) lastBaselineAnchor)))
(define (nsstackview-last-baseline-offset-from-bottom self)
  (tell #:type _double (coerce-arg self) lastBaselineOffsetFromBottom))
(define (nsstackview-layer self)
  (wrap-objc-object
   (tell (coerce-arg self) layer)))
(define (nsstackview-set-layer! self value)
  (tell #:type _void (coerce-arg self) setLayer: (coerce-arg value)))
(define (nsstackview-layer-contents-placement self)
  (tell #:type _int64 (coerce-arg self) layerContentsPlacement))
(define (nsstackview-set-layer-contents-placement! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setLayerContentsPlacement:") value))
(define (nsstackview-layer-contents-redraw-policy self)
  (tell #:type _int64 (coerce-arg self) layerContentsRedrawPolicy))
(define (nsstackview-set-layer-contents-redraw-policy! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setLayerContentsRedrawPolicy:") value))
(define (nsstackview-layer-uses-core-image-filters self)
  (tell #:type _bool (coerce-arg self) layerUsesCoreImageFilters))
(define (nsstackview-set-layer-uses-core-image-filters! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setLayerUsesCoreImageFilters:") value))
(define (nsstackview-layout-guides self)
  (wrap-objc-object
   (tell (coerce-arg self) layoutGuides)))
(define (nsstackview-layout-margins-guide self)
  (wrap-objc-object
   (tell (coerce-arg self) layoutMarginsGuide)))
(define (nsstackview-leading-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) leadingAnchor)))
(define (nsstackview-left-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) leftAnchor)))
(define (nsstackview-menu self)
  (wrap-objc-object
   (tell (coerce-arg self) menu)))
(define (nsstackview-set-menu! self value)
  (tell #:type _void (coerce-arg self) setMenu: (coerce-arg value)))
(define (nsstackview-mouse-down-can-move-window self)
  (tell #:type _bool (coerce-arg self) mouseDownCanMoveWindow))
(define (nsstackview-needs-display self)
  (tell #:type _bool (coerce-arg self) needsDisplay))
(define (nsstackview-set-needs-display! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setNeedsDisplay:") value))
(define (nsstackview-needs-layout self)
  (tell #:type _bool (coerce-arg self) needsLayout))
(define (nsstackview-set-needs-layout! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setNeedsLayout:") value))
(define (nsstackview-needs-panel-to-become-key self)
  (tell #:type _bool (coerce-arg self) needsPanelToBecomeKey))
(define (nsstackview-needs-update-constraints self)
  (tell #:type _bool (coerce-arg self) needsUpdateConstraints))
(define (nsstackview-set-needs-update-constraints! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setNeedsUpdateConstraints:") value))
(define (nsstackview-next-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) nextKeyView)))
(define (nsstackview-set-next-key-view! self value)
  (tell #:type _void (coerce-arg self) setNextKeyView: (coerce-arg value)))
(define (nsstackview-next-responder self)
  (wrap-objc-object
   (tell (coerce-arg self) nextResponder)))
(define (nsstackview-set-next-responder! self value)
  (tell #:type _void (coerce-arg self) setNextResponder: (coerce-arg value)))
(define (nsstackview-next-valid-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) nextValidKeyView)))
(define (nsstackview-opaque self)
  (tell #:type _bool (coerce-arg self) opaque))
(define (nsstackview-opaque-ancestor self)
  (wrap-objc-object
   (tell (coerce-arg self) opaqueAncestor)))
(define (nsstackview-orientation self)
  (tell #:type _int64 (coerce-arg self) orientation))
(define (nsstackview-set-orientation! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setOrientation:") value))
(define (nsstackview-page-footer self)
  (wrap-objc-object
   (tell (coerce-arg self) pageFooter)))
(define (nsstackview-page-header self)
  (wrap-objc-object
   (tell (coerce-arg self) pageHeader)))
(define (nsstackview-posts-bounds-changed-notifications self)
  (tell #:type _bool (coerce-arg self) postsBoundsChangedNotifications))
(define (nsstackview-set-posts-bounds-changed-notifications! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setPostsBoundsChangedNotifications:") value))
(define (nsstackview-posts-frame-changed-notifications self)
  (tell #:type _bool (coerce-arg self) postsFrameChangedNotifications))
(define (nsstackview-set-posts-frame-changed-notifications! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setPostsFrameChangedNotifications:") value))
(define (nsstackview-prefers-compact-control-size-metrics self)
  (tell #:type _bool (coerce-arg self) prefersCompactControlSizeMetrics))
(define (nsstackview-set-prefers-compact-control-size-metrics! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setPrefersCompactControlSizeMetrics:") value))
(define (nsstackview-prepared-content-rect self)
  (tell #:type _NSRect (coerce-arg self) preparedContentRect))
(define (nsstackview-set-prepared-content-rect! self value)
  (_msg-16 (coerce-arg self) (sel_registerName "setPreparedContentRect:") value))
(define (nsstackview-preserves-content-during-live-resize self)
  (tell #:type _bool (coerce-arg self) preservesContentDuringLiveResize))
(define (nsstackview-pressure-configuration self)
  (wrap-objc-object
   (tell (coerce-arg self) pressureConfiguration)))
(define (nsstackview-set-pressure-configuration! self value)
  (tell #:type _void (coerce-arg self) setPressureConfiguration: (coerce-arg value)))
(define (nsstackview-previous-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) previousKeyView)))
(define (nsstackview-previous-valid-key-view self)
  (wrap-objc-object
   (tell (coerce-arg self) previousValidKeyView)))
(define (nsstackview-print-job-title self)
  (wrap-objc-object
   (tell (coerce-arg self) printJobTitle)))
(define (nsstackview-rect-preserved-during-live-resize self)
  (tell #:type _NSRect (coerce-arg self) rectPreservedDuringLiveResize))
(define (nsstackview-registered-dragged-types self)
  (wrap-objc-object
   (tell (coerce-arg self) registeredDraggedTypes)))
(define (nsstackview-requires-constraint-based-layout)
  (tell #:type _bool NSStackView requiresConstraintBasedLayout))
(define (nsstackview-restorable-state-key-paths)
  (wrap-objc-object
   (tell NSStackView restorableStateKeyPaths)))
(define (nsstackview-right-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) rightAnchor)))
(define (nsstackview-rotated-from-base self)
  (tell #:type _bool (coerce-arg self) rotatedFromBase))
(define (nsstackview-rotated-or-scaled-from-base self)
  (tell #:type _bool (coerce-arg self) rotatedOrScaledFromBase))
(define (nsstackview-safe-area-insets self)
  (tell #:type _NSEdgeInsets (coerce-arg self) safeAreaInsets))
(define (nsstackview-safe-area-layout-guide self)
  (wrap-objc-object
   (tell (coerce-arg self) safeAreaLayoutGuide)))
(define (nsstackview-safe-area-rect self)
  (tell #:type _NSRect (coerce-arg self) safeAreaRect))
(define (nsstackview-shadow self)
  (wrap-objc-object
   (tell (coerce-arg self) shadow)))
(define (nsstackview-set-shadow! self value)
  (tell #:type _void (coerce-arg self) setShadow: (coerce-arg value)))
(define (nsstackview-spacing self)
  (tell #:type _double (coerce-arg self) spacing))
(define (nsstackview-set-spacing! self value)
  (_msg-26 (coerce-arg self) (sel_registerName "setSpacing:") value))
(define (nsstackview-subviews self)
  (wrap-objc-object
   (tell (coerce-arg self) subviews)))
(define (nsstackview-set-subviews! self value)
  (tell #:type _void (coerce-arg self) setSubviews: (coerce-arg value)))
(define (nsstackview-superview self)
  (wrap-objc-object
   (tell (coerce-arg self) superview)))
(define (nsstackview-tag self)
  (tell #:type _int64 (coerce-arg self) tag))
(define (nsstackview-tool-tip self)
  (wrap-objc-object
   (tell (coerce-arg self) toolTip)))
(define (nsstackview-set-tool-tip! self value)
  (tell #:type _void (coerce-arg self) setToolTip: (coerce-arg value)))
(define (nsstackview-top-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) topAnchor)))
(define (nsstackview-touch-bar self)
  (wrap-objc-object
   (tell (coerce-arg self) touchBar)))
(define (nsstackview-set-touch-bar! self value)
  (tell #:type _void (coerce-arg self) setTouchBar: (coerce-arg value)))
(define (nsstackview-tracking-areas self)
  (wrap-objc-object
   (tell (coerce-arg self) trackingAreas)))
(define (nsstackview-trailing-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) trailingAnchor)))
(define (nsstackview-translates-autoresizing-mask-into-constraints self)
  (tell #:type _bool (coerce-arg self) translatesAutoresizingMaskIntoConstraints))
(define (nsstackview-set-translates-autoresizing-mask-into-constraints! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setTranslatesAutoresizingMaskIntoConstraints:") value))
(define (nsstackview-undo-manager self)
  (wrap-objc-object
   (tell (coerce-arg self) undoManager)))
(define (nsstackview-user-activity self)
  (wrap-objc-object
   (tell (coerce-arg self) userActivity)))
(define (nsstackview-set-user-activity! self value)
  (tell #:type _void (coerce-arg self) setUserActivity: (coerce-arg value)))
(define (nsstackview-user-interface-layout-direction self)
  (tell #:type _int64 (coerce-arg self) userInterfaceLayoutDirection))
(define (nsstackview-set-user-interface-layout-direction! self value)
  (_msg-38 (coerce-arg self) (sel_registerName "setUserInterfaceLayoutDirection:") value))
(define (nsstackview-vertical-content-size-constraint-active self)
  (tell #:type _bool (coerce-arg self) verticalContentSizeConstraintActive))
(define (nsstackview-set-vertical-content-size-constraint-active! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setVerticalContentSizeConstraintActive:") value))
(define (nsstackview-views self)
  (wrap-objc-object
   (tell (coerce-arg self) views)))
(define (nsstackview-visible-rect self)
  (tell #:type _NSRect (coerce-arg self) visibleRect))
(define (nsstackview-wants-best-resolution-open-gl-surface self)
  (tell #:type _bool (coerce-arg self) wantsBestResolutionOpenGLSurface))
(define (nsstackview-set-wants-best-resolution-open-gl-surface! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setWantsBestResolutionOpenGLSurface:") value))
(define (nsstackview-wants-default-clipping self)
  (tell #:type _bool (coerce-arg self) wantsDefaultClipping))
(define (nsstackview-wants-extended-dynamic-range-open-gl-surface self)
  (tell #:type _bool (coerce-arg self) wantsExtendedDynamicRangeOpenGLSurface))
(define (nsstackview-set-wants-extended-dynamic-range-open-gl-surface! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setWantsExtendedDynamicRangeOpenGLSurface:") value))
(define (nsstackview-wants-layer self)
  (tell #:type _bool (coerce-arg self) wantsLayer))
(define (nsstackview-set-wants-layer! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setWantsLayer:") value))
(define (nsstackview-wants-resting-touches self)
  (tell #:type _bool (coerce-arg self) wantsRestingTouches))
(define (nsstackview-set-wants-resting-touches! self value)
  (_msg-25 (coerce-arg self) (sel_registerName "setWantsRestingTouches:") value))
(define (nsstackview-wants-update-layer self)
  (tell #:type _bool (coerce-arg self) wantsUpdateLayer))
(define (nsstackview-width-adjust-limit self)
  (tell #:type _double (coerce-arg self) widthAdjustLimit))
(define (nsstackview-width-anchor self)
  (wrap-objc-object
   (tell (coerce-arg self) widthAnchor)))
(define (nsstackview-window self)
  (wrap-objc-object
   (tell (coerce-arg self) window)))
(define (nsstackview-writing-tools-coordinator self)
  (wrap-objc-object
   (tell (coerce-arg self) writingToolsCoordinator)))
(define (nsstackview-set-writing-tools-coordinator! self value)
  (tell #:type _void (coerce-arg self) setWritingToolsCoordinator: (coerce-arg value)))

;; --- Instance methods ---
(define (nsstackview-accepts-first-mouse self event)
  (_msg-30 (coerce-arg self) (sel_registerName "acceptsFirstMouse:") (coerce-arg event)))
(define (nsstackview-add-arranged-subview! self view)
  (tell #:type _void (coerce-arg self) addArrangedSubview: (coerce-arg view)))
(define (nsstackview-add-subview! self view)
  (tell #:type _void (coerce-arg self) addSubview: (coerce-arg view)))
(define (nsstackview-add-subview-positioned-relative-to! self view place other-view)
  (_msg-34 (coerce-arg self) (sel_registerName "addSubview:positioned:relativeTo:") (coerce-arg view) place (coerce-arg other-view)))
(define (nsstackview-add-tool-tip-rect-owner-user-data! self rect owner data)
  (_msg-20 (coerce-arg self) (sel_registerName "addToolTipRect:owner:userData:") rect (coerce-arg owner) data))
(define (nsstackview-adjust-scroll self new-visible)
  (_msg-13 (coerce-arg self) (sel_registerName "adjustScroll:") new-visible))
(define (nsstackview-ancestor-shared-with-view self view)
  (wrap-objc-object
   (tell (coerce-arg self) ancestorSharedWithView: (coerce-arg view))))
(define (nsstackview-autoscroll self event)
  (_msg-30 (coerce-arg self) (sel_registerName "autoscroll:") (coerce-arg event)))
(define (nsstackview-backing-aligned-rect-options self rect options)
  (_msg-21 (coerce-arg self) (sel_registerName "backingAlignedRect:options:") rect options))
(define (nsstackview-become-first-responder self)
  (_msg-2 (coerce-arg self) (sel_registerName "becomeFirstResponder")))
(define (nsstackview-begin-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) beginGestureWithEvent: (coerce-arg event)))
(define (nsstackview-bitmap-image-rep-for-caching-display-in-rect self rect)
  (wrap-objc-object
   (_msg-15 (coerce-arg self) (sel_registerName "bitmapImageRepForCachingDisplayInRect:") rect)
   ))
(define (nsstackview-cache-display-in-rect-to-bitmap-image-rep self rect bitmap-image-rep)
  (_msg-19 (coerce-arg self) (sel_registerName "cacheDisplayInRect:toBitmapImageRep:") rect (coerce-arg bitmap-image-rep)))
(define (nsstackview-center-scan-rect! self rect)
  (_msg-13 (coerce-arg self) (sel_registerName "centerScanRect:") rect))
(define (nsstackview-change-mode-with-event self event)
  (tell #:type _void (coerce-arg self) changeModeWithEvent: (coerce-arg event)))
(define (nsstackview-clipping-resistance-priority-for-orientation self orientation)
  (_msg-36 (coerce-arg self) (sel_registerName "clippingResistancePriorityForOrientation:") orientation))
(define (nsstackview-context-menu-key-down self event)
  (tell #:type _void (coerce-arg self) contextMenuKeyDown: (coerce-arg event)))
(define (nsstackview-convert-point-from-view self point view)
  (_msg-12 (coerce-arg self) (sel_registerName "convertPoint:fromView:") point (coerce-arg view)))
(define (nsstackview-convert-point-to-view self point view)
  (_msg-12 (coerce-arg self) (sel_registerName "convertPoint:toView:") point (coerce-arg view)))
(define (nsstackview-convert-point-from-backing self point)
  (_msg-7 (coerce-arg self) (sel_registerName "convertPointFromBacking:") point))
(define (nsstackview-convert-point-from-layer self point)
  (_msg-7 (coerce-arg self) (sel_registerName "convertPointFromLayer:") point))
(define (nsstackview-convert-point-to-backing self point)
  (_msg-7 (coerce-arg self) (sel_registerName "convertPointToBacking:") point))
(define (nsstackview-convert-point-to-layer self point)
  (_msg-7 (coerce-arg self) (sel_registerName "convertPointToLayer:") point))
(define (nsstackview-convert-rect-from-view self rect view)
  (_msg-18 (coerce-arg self) (sel_registerName "convertRect:fromView:") rect (coerce-arg view)))
(define (nsstackview-convert-rect-to-view self rect view)
  (_msg-18 (coerce-arg self) (sel_registerName "convertRect:toView:") rect (coerce-arg view)))
(define (nsstackview-convert-rect-from-backing self rect)
  (_msg-13 (coerce-arg self) (sel_registerName "convertRectFromBacking:") rect))
(define (nsstackview-convert-rect-from-layer self rect)
  (_msg-13 (coerce-arg self) (sel_registerName "convertRectFromLayer:") rect))
(define (nsstackview-convert-rect-to-backing self rect)
  (_msg-13 (coerce-arg self) (sel_registerName "convertRectToBacking:") rect))
(define (nsstackview-convert-rect-to-layer self rect)
  (_msg-13 (coerce-arg self) (sel_registerName "convertRectToLayer:") rect))
(define (nsstackview-convert-size-from-view self size view)
  (_msg-24 (coerce-arg self) (sel_registerName "convertSize:fromView:") size (coerce-arg view)))
(define (nsstackview-convert-size-to-view self size view)
  (_msg-24 (coerce-arg self) (sel_registerName "convertSize:toView:") size (coerce-arg view)))
(define (nsstackview-convert-size-from-backing self size)
  (_msg-22 (coerce-arg self) (sel_registerName "convertSizeFromBacking:") size))
(define (nsstackview-convert-size-from-layer self size)
  (_msg-22 (coerce-arg self) (sel_registerName "convertSizeFromLayer:") size))
(define (nsstackview-convert-size-to-backing self size)
  (_msg-22 (coerce-arg self) (sel_registerName "convertSizeToBacking:") size))
(define (nsstackview-convert-size-to-layer self size)
  (_msg-22 (coerce-arg self) (sel_registerName "convertSizeToLayer:") size))
(define (nsstackview-cursor-update self event)
  (tell #:type _void (coerce-arg self) cursorUpdate: (coerce-arg event)))
(define (nsstackview-custom-spacing-after-view self view)
  (_msg-31 (coerce-arg self) (sel_registerName "customSpacingAfterView:") (coerce-arg view)))
(define (nsstackview-did-add-subview self subview)
  (tell #:type _void (coerce-arg self) didAddSubview: (coerce-arg subview)))
(define (nsstackview-did-close-menu-with-event self menu event)
  (tell #:type _void (coerce-arg self) didCloseMenu: (coerce-arg menu) withEvent: (coerce-arg event)))
(define (nsstackview-display! self)
  (tell #:type _void (coerce-arg self) display))
(define (nsstackview-display-if-needed! self)
  (tell #:type _void (coerce-arg self) displayIfNeeded))
(define (nsstackview-display-if-needed-ignoring-opacity! self)
  (tell #:type _void (coerce-arg self) displayIfNeededIgnoringOpacity))
(define (nsstackview-display-if-needed-in-rect! self rect)
  (_msg-16 (coerce-arg self) (sel_registerName "displayIfNeededInRect:") rect))
(define (nsstackview-display-if-needed-in-rect-ignoring-opacity! self rect)
  (_msg-16 (coerce-arg self) (sel_registerName "displayIfNeededInRectIgnoringOpacity:") rect))
(define (nsstackview-display-rect! self rect)
  (_msg-16 (coerce-arg self) (sel_registerName "displayRect:") rect))
(define (nsstackview-display-rect-ignoring-opacity! self rect)
  (_msg-16 (coerce-arg self) (sel_registerName "displayRectIgnoringOpacity:") rect))
(define (nsstackview-display-rect-ignoring-opacity-in-context! self rect context)
  (_msg-19 (coerce-arg self) (sel_registerName "displayRectIgnoringOpacity:inContext:") rect (coerce-arg context)))
(define (nsstackview-draw-rect self dirty-rect)
  (_msg-16 (coerce-arg self) (sel_registerName "drawRect:") dirty-rect))
(define (nsstackview-end-gesture-with-event! self event)
  (tell #:type _void (coerce-arg self) endGestureWithEvent: (coerce-arg event)))
(define (nsstackview-flags-changed self event)
  (tell #:type _void (coerce-arg self) flagsChanged: (coerce-arg event)))
(define (nsstackview-flush-buffered-key-events self)
  (tell #:type _void (coerce-arg self) flushBufferedKeyEvents))
(define (nsstackview-get-rects-being-drawn-count self rects count)
  (_msg-42 (coerce-arg self) (sel_registerName "getRectsBeingDrawn:count:") rects count))
(define (nsstackview-get-rects-exposed-during-live-resize-count self exposed-rects count)
  (_msg-42 (coerce-arg self) (sel_registerName "getRectsExposedDuringLiveResize:count:") exposed-rects count))
(define (nsstackview-help-requested self event-ptr)
  (tell #:type _void (coerce-arg self) helpRequested: (coerce-arg event-ptr)))
(define (nsstackview-hit-test self point)
  (wrap-objc-object
   (_msg-8 (coerce-arg self) (sel_registerName "hitTest:") point)
   ))
(define (nsstackview-hugging-priority-for-orientation self orientation)
  (_msg-36 (coerce-arg self) (sel_registerName "huggingPriorityForOrientation:") orientation))
(define (nsstackview-insert-arranged-subview-at-index! self view index)
  (_msg-33 (coerce-arg self) (sel_registerName "insertArrangedSubview:atIndex:") (coerce-arg view) index))
(define (nsstackview-interpret-key-events self event-array)
  (tell #:type _void (coerce-arg self) interpretKeyEvents: (coerce-arg event-array)))
(define (nsstackview-is-descendant-of self view)
  (_msg-30 (coerce-arg self) (sel_registerName "isDescendantOf:") (coerce-arg view)))
(define (nsstackview-is-flipped self)
  (_msg-2 (coerce-arg self) (sel_registerName "isFlipped")))
(define (nsstackview-is-hidden self)
  (_msg-2 (coerce-arg self) (sel_registerName "isHidden")))
(define (nsstackview-is-hidden-or-has-hidden-ancestor self)
  (_msg-2 (coerce-arg self) (sel_registerName "isHiddenOrHasHiddenAncestor")))
(define (nsstackview-is-opaque self)
  (_msg-2 (coerce-arg self) (sel_registerName "isOpaque")))
(define (nsstackview-is-rotated-from-base self)
  (_msg-2 (coerce-arg self) (sel_registerName "isRotatedFromBase")))
(define (nsstackview-is-rotated-or-scaled-from-base self)
  (_msg-2 (coerce-arg self) (sel_registerName "isRotatedOrScaledFromBase")))
(define (nsstackview-key-down self event)
  (tell #:type _void (coerce-arg self) keyDown: (coerce-arg event)))
(define (nsstackview-key-up self event)
  (tell #:type _void (coerce-arg self) keyUp: (coerce-arg event)))
(define (nsstackview-layout self)
  (tell #:type _void (coerce-arg self) layout))
(define (nsstackview-layout-subtree-if-needed self)
  (tell #:type _void (coerce-arg self) layoutSubtreeIfNeeded))
(define (nsstackview-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) magnifyWithEvent: (coerce-arg event)))
(define (nsstackview-make-backing-layer self)
  (wrap-objc-object
   (tell (coerce-arg self) makeBackingLayer)))
(define (nsstackview-menu-for-event self event)
  (wrap-objc-object
   (tell (coerce-arg self) menuForEvent: (coerce-arg event))))
(define (nsstackview-mouse-in-rect self point rect)
  (_msg-11 (coerce-arg self) (sel_registerName "mouse:inRect:") point rect))
(define (nsstackview-mouse-cancelled self event)
  (tell #:type _void (coerce-arg self) mouseCancelled: (coerce-arg event)))
(define (nsstackview-mouse-down self event)
  (tell #:type _void (coerce-arg self) mouseDown: (coerce-arg event)))
(define (nsstackview-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) mouseDragged: (coerce-arg event)))
(define (nsstackview-mouse-entered self event)
  (tell #:type _void (coerce-arg self) mouseEntered: (coerce-arg event)))
(define (nsstackview-mouse-exited self event)
  (tell #:type _void (coerce-arg self) mouseExited: (coerce-arg event)))
(define (nsstackview-mouse-moved self event)
  (tell #:type _void (coerce-arg self) mouseMoved: (coerce-arg event)))
(define (nsstackview-mouse-up self event)
  (tell #:type _void (coerce-arg self) mouseUp: (coerce-arg event)))
(define (nsstackview-needs-to-draw-rect self rect)
  (_msg-14 (coerce-arg self) (sel_registerName "needsToDrawRect:") rect))
(define (nsstackview-no-responder-for self event-selector)
  (_msg-39 (coerce-arg self) (sel_registerName "noResponderFor:") (sel_registerName event-selector)))
(define (nsstackview-other-mouse-down self event)
  (tell #:type _void (coerce-arg self) otherMouseDown: (coerce-arg event)))
(define (nsstackview-other-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) otherMouseDragged: (coerce-arg event)))
(define (nsstackview-other-mouse-up self event)
  (tell #:type _void (coerce-arg self) otherMouseUp: (coerce-arg event)))
(define (nsstackview-perform-key-equivalent! self event)
  (_msg-30 (coerce-arg self) (sel_registerName "performKeyEquivalent:") (coerce-arg event)))
(define (nsstackview-prepare-content-in-rect self rect)
  (_msg-16 (coerce-arg self) (sel_registerName "prepareContentInRect:") rect))
(define (nsstackview-prepare-for-reuse self)
  (tell #:type _void (coerce-arg self) prepareForReuse))
(define (nsstackview-pressure-change-with-event self event)
  (tell #:type _void (coerce-arg self) pressureChangeWithEvent: (coerce-arg event)))
(define (nsstackview-quick-look-with-event self event)
  (tell #:type _void (coerce-arg self) quickLookWithEvent: (coerce-arg event)))
(define (nsstackview-rect-for-smart-magnification-at-point-in-rect self location visible-rect)
  (_msg-10 (coerce-arg self) (sel_registerName "rectForSmartMagnificationAtPoint:inRect:") location visible-rect))
(define (nsstackview-remove-all-tool-tips! self)
  (tell #:type _void (coerce-arg self) removeAllToolTips))
(define (nsstackview-remove-arranged-subview! self view)
  (tell #:type _void (coerce-arg self) removeArrangedSubview: (coerce-arg view)))
(define (nsstackview-remove-from-superview! self)
  (tell #:type _void (coerce-arg self) removeFromSuperview))
(define (nsstackview-remove-from-superview-without-needing-display! self)
  (tell #:type _void (coerce-arg self) removeFromSuperviewWithoutNeedingDisplay))
(define (nsstackview-remove-tool-tip! self tag)
  (_msg-38 (coerce-arg self) (sel_registerName "removeToolTip:") tag))
(define (nsstackview-replace-subview-with! self old-view new-view)
  (tell #:type _void (coerce-arg self) replaceSubview: (coerce-arg old-view) with: (coerce-arg new-view)))
(define (nsstackview-resign-first-responder self)
  (_msg-2 (coerce-arg self) (sel_registerName "resignFirstResponder")))
(define (nsstackview-resize-subviews-with-old-size self old-size)
  (_msg-23 (coerce-arg self) (sel_registerName "resizeSubviewsWithOldSize:") old-size))
(define (nsstackview-resize-with-old-superview-size self old-size)
  (_msg-23 (coerce-arg self) (sel_registerName "resizeWithOldSuperviewSize:") old-size))
(define (nsstackview-right-mouse-down self event)
  (tell #:type _void (coerce-arg self) rightMouseDown: (coerce-arg event)))
(define (nsstackview-right-mouse-dragged self event)
  (tell #:type _void (coerce-arg self) rightMouseDragged: (coerce-arg event)))
(define (nsstackview-right-mouse-up self event)
  (tell #:type _void (coerce-arg self) rightMouseUp: (coerce-arg event)))
(define (nsstackview-rotate-by-angle self angle)
  (_msg-26 (coerce-arg self) (sel_registerName "rotateByAngle:") angle))
(define (nsstackview-rotate-with-event self event)
  (tell #:type _void (coerce-arg self) rotateWithEvent: (coerce-arg event)))
(define (nsstackview-scale-unit-square-to-size self new-unit-size)
  (_msg-23 (coerce-arg self) (sel_registerName "scaleUnitSquareToSize:") new-unit-size))
(define (nsstackview-scroll-point self point)
  (_msg-9 (coerce-arg self) (sel_registerName "scrollPoint:") point))
(define (nsstackview-scroll-rect-to-visible self rect)
  (_msg-14 (coerce-arg self) (sel_registerName "scrollRectToVisible:") rect))
(define (nsstackview-scroll-wheel self event)
  (tell #:type _void (coerce-arg self) scrollWheel: (coerce-arg event)))
(define (nsstackview-set-bounds-origin! self new-origin)
  (_msg-9 (coerce-arg self) (sel_registerName "setBoundsOrigin:") new-origin))
(define (nsstackview-set-bounds-size! self new-size)
  (_msg-23 (coerce-arg self) (sel_registerName "setBoundsSize:") new-size))
(define (nsstackview-set-clipping-resistance-priority-for-orientation! self clipping-resistance-priority orientation)
  (_msg-29 (coerce-arg self) (sel_registerName "setClippingResistancePriority:forOrientation:") clipping-resistance-priority orientation))
(define (nsstackview-set-custom-spacing-after-view! self spacing view)
  (_msg-27 (coerce-arg self) (sel_registerName "setCustomSpacing:afterView:") spacing (coerce-arg view)))
(define (nsstackview-set-frame-origin! self new-origin)
  (_msg-9 (coerce-arg self) (sel_registerName "setFrameOrigin:") new-origin))
(define (nsstackview-set-frame-size! self new-size)
  (_msg-23 (coerce-arg self) (sel_registerName "setFrameSize:") new-size))
(define (nsstackview-set-hugging-priority-for-orientation! self hugging-priority orientation)
  (_msg-29 (coerce-arg self) (sel_registerName "setHuggingPriority:forOrientation:") hugging-priority orientation))
(define (nsstackview-set-needs-display-in-rect! self invalid-rect)
  (_msg-16 (coerce-arg self) (sel_registerName "setNeedsDisplayInRect:") invalid-rect))
(define (nsstackview-set-visibility-priority-for-view! self priority view)
  (_msg-28 (coerce-arg self) (sel_registerName "setVisibilityPriority:forView:") priority (coerce-arg view)))
(define (nsstackview-should-be-treated-as-ink-event self event)
  (_msg-30 (coerce-arg self) (sel_registerName "shouldBeTreatedAsInkEvent:") (coerce-arg event)))
(define (nsstackview-should-delay-window-ordering-for-event self event)
  (_msg-30 (coerce-arg self) (sel_registerName "shouldDelayWindowOrderingForEvent:") (coerce-arg event)))
(define (nsstackview-show-context-help self sender)
  (tell #:type _void (coerce-arg self) showContextHelp: (coerce-arg sender)))
(define (nsstackview-smart-magnify-with-event self event)
  (tell #:type _void (coerce-arg self) smartMagnifyWithEvent: (coerce-arg event)))
(define (nsstackview-sort-subviews-using-function-context self compare context)
  (_msg-42 (coerce-arg self) (sel_registerName "sortSubviewsUsingFunction:context:") compare context))
(define (nsstackview-supplemental-target-for-action-sender self action sender)
  (wrap-objc-object
   (_msg-41 (coerce-arg self) (sel_registerName "supplementalTargetForAction:sender:") (sel_registerName action) (coerce-arg sender))
   ))
(define (nsstackview-swipe-with-event self event)
  (tell #:type _void (coerce-arg self) swipeWithEvent: (coerce-arg event)))
(define (nsstackview-tablet-point self event)
  (tell #:type _void (coerce-arg self) tabletPoint: (coerce-arg event)))
(define (nsstackview-tablet-proximity self event)
  (tell #:type _void (coerce-arg self) tabletProximity: (coerce-arg event)))
(define (nsstackview-touches-began-with-event self event)
  (tell #:type _void (coerce-arg self) touchesBeganWithEvent: (coerce-arg event)))
(define (nsstackview-touches-cancelled-with-event self event)
  (tell #:type _void (coerce-arg self) touchesCancelledWithEvent: (coerce-arg event)))
(define (nsstackview-touches-ended-with-event self event)
  (tell #:type _void (coerce-arg self) touchesEndedWithEvent: (coerce-arg event)))
(define (nsstackview-touches-moved-with-event self event)
  (tell #:type _void (coerce-arg self) touchesMovedWithEvent: (coerce-arg event)))
(define (nsstackview-translate-origin-to-point self translation)
  (_msg-9 (coerce-arg self) (sel_registerName "translateOriginToPoint:") translation))
(define (nsstackview-translate-rects-needing-display-in-rect-by self clip-rect delta)
  (_msg-17 (coerce-arg self) (sel_registerName "translateRectsNeedingDisplayInRect:by:") clip-rect delta))
(define (nsstackview-try-to-perform-with self action object)
  (_msg-40 (coerce-arg self) (sel_registerName "tryToPerform:with:") (sel_registerName action) (coerce-arg object)))
(define (nsstackview-update-layer self)
  (tell #:type _void (coerce-arg self) updateLayer))
(define (nsstackview-valid-requestor-for-send-type-return-type self send-type return-type)
  (wrap-objc-object
   (tell (coerce-arg self) validRequestorForSendType: (coerce-arg send-type) returnType: (coerce-arg return-type))))
(define (nsstackview-view-did-change-backing-properties self)
  (tell #:type _void (coerce-arg self) viewDidChangeBackingProperties))
(define (nsstackview-view-did-change-effective-appearance self)
  (tell #:type _void (coerce-arg self) viewDidChangeEffectiveAppearance))
(define (nsstackview-view-did-end-live-resize self)
  (tell #:type _void (coerce-arg self) viewDidEndLiveResize))
(define (nsstackview-view-did-hide self)
  (tell #:type _void (coerce-arg self) viewDidHide))
(define (nsstackview-view-did-move-to-superview self)
  (tell #:type _void (coerce-arg self) viewDidMoveToSuperview))
(define (nsstackview-view-did-move-to-window self)
  (tell #:type _void (coerce-arg self) viewDidMoveToWindow))
(define (nsstackview-view-did-unhide self)
  (tell #:type _void (coerce-arg self) viewDidUnhide))
(define (nsstackview-view-will-draw self)
  (tell #:type _void (coerce-arg self) viewWillDraw))
(define (nsstackview-view-will-move-to-superview self new-superview)
  (tell #:type _void (coerce-arg self) viewWillMoveToSuperview: (coerce-arg new-superview)))
(define (nsstackview-view-will-move-to-window self new-window)
  (tell #:type _void (coerce-arg self) viewWillMoveToWindow: (coerce-arg new-window)))
(define (nsstackview-view-will-start-live-resize self)
  (tell #:type _void (coerce-arg self) viewWillStartLiveResize))
(define (nsstackview-view-with-tag self tag)
  (wrap-objc-object
   (_msg-37 (coerce-arg self) (sel_registerName "viewWithTag:") tag)
   ))
(define (nsstackview-visibility-priority-for-view self view)
  (_msg-32 (coerce-arg self) (sel_registerName "visibilityPriorityForView:") (coerce-arg view)))
(define (nsstackview-wants-forwarded-scroll-events-for-axis self axis)
  (_msg-35 (coerce-arg self) (sel_registerName "wantsForwardedScrollEventsForAxis:") axis))
(define (nsstackview-wants-scroll-events-for-swipe-tracking-on-axis self axis)
  (_msg-35 (coerce-arg self) (sel_registerName "wantsScrollEventsForSwipeTrackingOnAxis:") axis))
(define (nsstackview-will-open-menu-with-event self menu event)
  (tell #:type _void (coerce-arg self) willOpenMenu: (coerce-arg menu) withEvent: (coerce-arg event)))
(define (nsstackview-will-remove-subview self subview)
  (tell #:type _void (coerce-arg self) willRemoveSubview: (coerce-arg subview)))

;; --- Class methods ---
(define (nsstackview-is-compatible-with-responsive-scrolling)
  (_msg-2 NSStackView (sel_registerName "isCompatibleWithResponsiveScrolling")))
(define (nsstackview-stack-view-with-views views)
  (wrap-objc-object
   (tell NSStackView stackViewWithViews: (coerce-arg views))))
