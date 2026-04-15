#lang racket/base
;; Generated binding for NSColor (AppKit)
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

(provide NSColor)
(provide/contract
  [make-nscolor-init-with-coder (c-> any/c any/c)]
  [nscolor-cg-color (c-> objc-object? (or/c cpointer? #f))]
  [nscolor-alpha-component (c-> objc-object? real?)]
  [nscolor-alternate-selected-control-color (c-> any/c)]
  [nscolor-alternate-selected-control-text-color (c-> any/c)]
  [nscolor-alternating-content-background-colors (c-> any/c)]
  [nscolor-black-color (c-> any/c)]
  [nscolor-black-component (c-> objc-object? real?)]
  [nscolor-blue-color (c-> any/c)]
  [nscolor-blue-component (c-> objc-object? real?)]
  [nscolor-brightness-component (c-> objc-object? real?)]
  [nscolor-brown-color (c-> any/c)]
  [nscolor-catalog-name-component (c-> objc-object? any/c)]
  [nscolor-clear-color (c-> any/c)]
  [nscolor-color-name-component (c-> objc-object? any/c)]
  [nscolor-color-space (c-> objc-object? any/c)]
  [nscolor-color-space-name (c-> objc-object? any/c)]
  [nscolor-control-accent-color (c-> any/c)]
  [nscolor-control-alternating-row-background-colors (c-> any/c)]
  [nscolor-control-background-color (c-> any/c)]
  [nscolor-control-color (c-> any/c)]
  [nscolor-control-dark-shadow-color (c-> any/c)]
  [nscolor-control-highlight-color (c-> any/c)]
  [nscolor-control-light-highlight-color (c-> any/c)]
  [nscolor-control-shadow-color (c-> any/c)]
  [nscolor-control-text-color (c-> any/c)]
  [nscolor-current-control-tint (c-> exact-nonnegative-integer?)]
  [nscolor-cyan-color (c-> any/c)]
  [nscolor-cyan-component (c-> objc-object? real?)]
  [nscolor-dark-gray-color (c-> any/c)]
  [nscolor-disabled-control-text-color (c-> any/c)]
  [nscolor-find-highlight-color (c-> any/c)]
  [nscolor-gray-color (c-> any/c)]
  [nscolor-green-color (c-> any/c)]
  [nscolor-green-component (c-> objc-object? real?)]
  [nscolor-grid-color (c-> any/c)]
  [nscolor-header-color (c-> any/c)]
  [nscolor-header-text-color (c-> any/c)]
  [nscolor-highlight-color (c-> any/c)]
  [nscolor-hue-component (c-> objc-object? real?)]
  [nscolor-ignores-alpha (c-> boolean?)]
  [nscolor-set-ignores-alpha! (c-> boolean? void?)]
  [nscolor-keyboard-focus-indicator-color (c-> any/c)]
  [nscolor-knob-color (c-> any/c)]
  [nscolor-label-color (c-> any/c)]
  [nscolor-light-gray-color (c-> any/c)]
  [nscolor-linear-exposure (c-> objc-object? real?)]
  [nscolor-link-color (c-> any/c)]
  [nscolor-localized-catalog-name-component (c-> objc-object? any/c)]
  [nscolor-localized-color-name-component (c-> objc-object? any/c)]
  [nscolor-magenta-color (c-> any/c)]
  [nscolor-magenta-component (c-> objc-object? real?)]
  [nscolor-number-of-components (c-> objc-object? exact-integer?)]
  [nscolor-orange-color (c-> any/c)]
  [nscolor-pattern-image (c-> objc-object? any/c)]
  [nscolor-placeholder-text-color (c-> any/c)]
  [nscolor-purple-color (c-> any/c)]
  [nscolor-quaternary-label-color (c-> any/c)]
  [nscolor-quaternary-system-fill-color (c-> any/c)]
  [nscolor-quinary-label-color (c-> any/c)]
  [nscolor-quinary-system-fill-color (c-> any/c)]
  [nscolor-red-color (c-> any/c)]
  [nscolor-red-component (c-> objc-object? real?)]
  [nscolor-saturation-component (c-> objc-object? real?)]
  [nscolor-scroll-bar-color (c-> any/c)]
  [nscolor-scrubber-textured-background-color (c-> any/c)]
  [nscolor-secondary-label-color (c-> any/c)]
  [nscolor-secondary-selected-control-color (c-> any/c)]
  [nscolor-secondary-system-fill-color (c-> any/c)]
  [nscolor-selected-content-background-color (c-> any/c)]
  [nscolor-selected-control-color (c-> any/c)]
  [nscolor-selected-control-text-color (c-> any/c)]
  [nscolor-selected-knob-color (c-> any/c)]
  [nscolor-selected-menu-item-color (c-> any/c)]
  [nscolor-selected-menu-item-text-color (c-> any/c)]
  [nscolor-selected-text-background-color (c-> any/c)]
  [nscolor-selected-text-color (c-> any/c)]
  [nscolor-separator-color (c-> any/c)]
  [nscolor-shadow-color (c-> any/c)]
  [nscolor-standard-dynamic-range-color (c-> objc-object? any/c)]
  [nscolor-system-blue-color (c-> any/c)]
  [nscolor-system-brown-color (c-> any/c)]
  [nscolor-system-cyan-color (c-> any/c)]
  [nscolor-system-fill-color (c-> any/c)]
  [nscolor-system-gray-color (c-> any/c)]
  [nscolor-system-green-color (c-> any/c)]
  [nscolor-system-indigo-color (c-> any/c)]
  [nscolor-system-mint-color (c-> any/c)]
  [nscolor-system-orange-color (c-> any/c)]
  [nscolor-system-pink-color (c-> any/c)]
  [nscolor-system-purple-color (c-> any/c)]
  [nscolor-system-red-color (c-> any/c)]
  [nscolor-system-teal-color (c-> any/c)]
  [nscolor-system-yellow-color (c-> any/c)]
  [nscolor-tertiary-label-color (c-> any/c)]
  [nscolor-tertiary-system-fill-color (c-> any/c)]
  [nscolor-text-background-color (c-> any/c)]
  [nscolor-text-color (c-> any/c)]
  [nscolor-text-insertion-point-color (c-> any/c)]
  [nscolor-transfer-representation (c-> any/c)]
  [nscolor-type (c-> objc-object? exact-nonnegative-integer?)]
  [nscolor-under-page-background-color (c-> any/c)]
  [nscolor-unemphasized-selected-content-background-color (c-> any/c)]
  [nscolor-unemphasized-selected-text-background-color (c-> any/c)]
  [nscolor-unemphasized-selected-text-color (c-> any/c)]
  [nscolor-white-color (c-> any/c)]
  [nscolor-white-component (c-> objc-object? real?)]
  [nscolor-window-background-color (c-> any/c)]
  [nscolor-window-frame-color (c-> any/c)]
  [nscolor-window-frame-text-color (c-> any/c)]
  [nscolor-yellow-color (c-> any/c)]
  [nscolor-yellow-component (c-> objc-object? real?)]
  [nscolor-blended-color-with-fraction-of-color (c-> objc-object? real? any/c any/c)]
  [nscolor-color-by-applying-content-headroom (c-> objc-object? real? any/c)]
  [nscolor-color-using-color-space (c-> objc-object? any/c any/c)]
  [nscolor-color-using-type (c-> objc-object? exact-nonnegative-integer? any/c)]
  [nscolor-color-with-alpha-component (c-> objc-object? real? any/c)]
  [nscolor-color-with-system-effect (c-> objc-object? exact-nonnegative-integer? any/c)]
  [nscolor-draw-swatch-in-rect (c-> objc-object? any/c void?)]
  [nscolor-get-components (c-> objc-object? (or/c cpointer? #f) void?)]
  [nscolor-get-cyan-magenta-yellow-black-alpha (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) (or/c cpointer? #f) (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nscolor-get-hue-saturation-brightness-alpha (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nscolor-get-red-green-blue-alpha (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nscolor-get-white-alpha (c-> objc-object? (or/c cpointer? #f) (or/c cpointer? #f) void?)]
  [nscolor-highlight-with-level (c-> objc-object? real? any/c)]
  [nscolor-set! (c-> objc-object? void?)]
  [nscolor-set-fill! (c-> objc-object? void?)]
  [nscolor-set-stroke! (c-> objc-object? void?)]
  [nscolor-shadow-with-level (c-> objc-object? real? any/c)]
  [nscolor-write-to-pasteboard (c-> objc-object? any/c void?)]
  [nscolor-color-for-control-tint (c-> exact-nonnegative-integer? any/c)]
  [nscolor-color-from-pasteboard (c-> any/c any/c)]
  [nscolor-color-named (c-> any/c any/c)]
  [nscolor-color-named-bundle (c-> any/c any/c any/c)]
  [nscolor-color-with-cg-color (c-> (or/c cpointer? #f) any/c)]
  [nscolor-color-with-calibrated-hue-saturation-brightness-alpha (c-> real? real? real? real? any/c)]
  [nscolor-color-with-calibrated-red-green-blue-alpha (c-> real? real? real? real? any/c)]
  [nscolor-color-with-calibrated-white-alpha (c-> real? real? any/c)]
  [nscolor-color-with-catalog-name-color-name (c-> any/c any/c any/c)]
  [nscolor-color-with-color-space-components-count (c-> any/c (or/c cpointer? #f) exact-integer? any/c)]
  [nscolor-color-with-color-space-hue-saturation-brightness-alpha (c-> any/c real? real? real? real? any/c)]
  [nscolor-color-with-device-cyan-magenta-yellow-black-alpha (c-> real? real? real? real? real? any/c)]
  [nscolor-color-with-device-hue-saturation-brightness-alpha (c-> real? real? real? real? any/c)]
  [nscolor-color-with-device-red-green-blue-alpha (c-> real? real? real? real? any/c)]
  [nscolor-color-with-device-white-alpha (c-> real? real? any/c)]
  [nscolor-color-with-display-p3-red-green-blue-alpha (c-> real? real? real? real? any/c)]
  [nscolor-color-with-generic-gamma22-white-alpha (c-> real? real? any/c)]
  [nscolor-color-with-hue-saturation-brightness-alpha (c-> real? real? real? real? any/c)]
  [nscolor-color-with-name-dynamic-provider (c-> any/c (or/c procedure? #f) any/c)]
  [nscolor-color-with-pattern-image (c-> any/c any/c)]
  [nscolor-color-with-red-green-blue-alpha (c-> real? real? real? real? any/c)]
  [nscolor-color-with-red-green-blue-alpha-exposure (c-> real? real? real? real? real? any/c)]
  [nscolor-color-with-red-green-blue-alpha-linear-exposure (c-> real? real? real? real? real? any/c)]
  [nscolor-color-with-srgb-red-green-blue-alpha (c-> real? real? real? real? any/c)]
  [nscolor-color-with-white-alpha (c-> real? real? any/c)]
  )

;; --- Class reference ---
(import-class NSColor)

;; --- Shared typed objc_msgSend bindings ---
(define _msg-0  ; (_fun _pointer _pointer -> _bool)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _bool)))
(define _msg-1  ; (_fun _pointer _pointer -> _double)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _double)))
(define _msg-2  ; (_fun _pointer _pointer -> _int64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _int64)))
(define _msg-3  ; (_fun _pointer _pointer -> _pointer)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _pointer)))
(define _msg-4  ; (_fun _pointer _pointer -> _uint64)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer -> _uint64)))
(define _msg-5  ; (_fun _pointer _pointer _NSRect -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _NSRect -> _void)))
(define _msg-6  ; (_fun _pointer _pointer _bool -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _bool -> _void)))
(define _msg-7  ; (_fun _pointer _pointer _double -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double -> _id)))
(define _msg-8  ; (_fun _pointer _pointer _double _double -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double _double -> _id)))
(define _msg-9  ; (_fun _pointer _pointer _double _double _double _double -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double _double _double _double -> _id)))
(define _msg-10  ; (_fun _pointer _pointer _double _double _double _double _double -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double _double _double _double _double -> _id)))
(define _msg-11  ; (_fun _pointer _pointer _double _id -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _double _id -> _id)))
(define _msg-12  ; (_fun _pointer _pointer _id _double _double _double _double -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _double _double _double _double -> _id)))
(define _msg-13  ; (_fun _pointer _pointer _id _pointer -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _pointer -> _id)))
(define _msg-14  ; (_fun _pointer _pointer _id _pointer _int64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _id _pointer _int64 -> _id)))
(define _msg-15  ; (_fun _pointer _pointer _pointer -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _id)))
(define _msg-16  ; (_fun _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer -> _void)))
(define _msg-17  ; (_fun _pointer _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _pointer -> _void)))
(define _msg-18  ; (_fun _pointer _pointer _pointer _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _pointer _pointer _pointer -> _void)))
(define _msg-19  ; (_fun _pointer _pointer _pointer _pointer _pointer _pointer _pointer -> _void)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _pointer _pointer _pointer _pointer _pointer -> _void)))
(define _msg-20  ; (_fun _pointer _pointer _uint64 -> _id)
  (get-ffi-obj "objc_msgSend" _objc-lib (_fun _pointer _pointer _uint64 -> _id)))

;; --- Constructors ---
(define (make-nscolor-init-with-coder coder)
  (wrap-objc-object
   (tell (tell NSColor alloc)
         initWithCoder: (coerce-arg coder))
   #:retained #t))


;; --- Properties ---
(define (nscolor-cg-color self)
  (tell #:type _pointer (coerce-arg self) CGColor))
(define (nscolor-alpha-component self)
  (tell #:type _double (coerce-arg self) alphaComponent))
(define (nscolor-alternate-selected-control-color)
  (wrap-objc-object
   (tell NSColor alternateSelectedControlColor)))
(define (nscolor-alternate-selected-control-text-color)
  (wrap-objc-object
   (tell NSColor alternateSelectedControlTextColor)))
(define (nscolor-alternating-content-background-colors)
  (wrap-objc-object
   (tell NSColor alternatingContentBackgroundColors)))
(define (nscolor-black-color)
  (wrap-objc-object
   (tell NSColor blackColor)))
(define (nscolor-black-component self)
  (tell #:type _double (coerce-arg self) blackComponent))
(define (nscolor-blue-color)
  (wrap-objc-object
   (tell NSColor blueColor)))
(define (nscolor-blue-component self)
  (tell #:type _double (coerce-arg self) blueComponent))
(define (nscolor-brightness-component self)
  (tell #:type _double (coerce-arg self) brightnessComponent))
(define (nscolor-brown-color)
  (wrap-objc-object
   (tell NSColor brownColor)))
(define (nscolor-catalog-name-component self)
  (wrap-objc-object
   (tell (coerce-arg self) catalogNameComponent)))
(define (nscolor-clear-color)
  (wrap-objc-object
   (tell NSColor clearColor)))
(define (nscolor-color-name-component self)
  (wrap-objc-object
   (tell (coerce-arg self) colorNameComponent)))
(define (nscolor-color-space self)
  (wrap-objc-object
   (tell (coerce-arg self) colorSpace)))
(define (nscolor-color-space-name self)
  (wrap-objc-object
   (tell (coerce-arg self) colorSpaceName)))
(define (nscolor-control-accent-color)
  (wrap-objc-object
   (tell NSColor controlAccentColor)))
(define (nscolor-control-alternating-row-background-colors)
  (wrap-objc-object
   (tell NSColor controlAlternatingRowBackgroundColors)))
(define (nscolor-control-background-color)
  (wrap-objc-object
   (tell NSColor controlBackgroundColor)))
(define (nscolor-control-color)
  (wrap-objc-object
   (tell NSColor controlColor)))
(define (nscolor-control-dark-shadow-color)
  (wrap-objc-object
   (tell NSColor controlDarkShadowColor)))
(define (nscolor-control-highlight-color)
  (wrap-objc-object
   (tell NSColor controlHighlightColor)))
(define (nscolor-control-light-highlight-color)
  (wrap-objc-object
   (tell NSColor controlLightHighlightColor)))
(define (nscolor-control-shadow-color)
  (wrap-objc-object
   (tell NSColor controlShadowColor)))
(define (nscolor-control-text-color)
  (wrap-objc-object
   (tell NSColor controlTextColor)))
(define (nscolor-current-control-tint)
  (tell #:type _uint64 NSColor currentControlTint))
(define (nscolor-cyan-color)
  (wrap-objc-object
   (tell NSColor cyanColor)))
(define (nscolor-cyan-component self)
  (tell #:type _double (coerce-arg self) cyanComponent))
(define (nscolor-dark-gray-color)
  (wrap-objc-object
   (tell NSColor darkGrayColor)))
(define (nscolor-disabled-control-text-color)
  (wrap-objc-object
   (tell NSColor disabledControlTextColor)))
(define (nscolor-find-highlight-color)
  (wrap-objc-object
   (tell NSColor findHighlightColor)))
(define (nscolor-gray-color)
  (wrap-objc-object
   (tell NSColor grayColor)))
(define (nscolor-green-color)
  (wrap-objc-object
   (tell NSColor greenColor)))
(define (nscolor-green-component self)
  (tell #:type _double (coerce-arg self) greenComponent))
(define (nscolor-grid-color)
  (wrap-objc-object
   (tell NSColor gridColor)))
(define (nscolor-header-color)
  (wrap-objc-object
   (tell NSColor headerColor)))
(define (nscolor-header-text-color)
  (wrap-objc-object
   (tell NSColor headerTextColor)))
(define (nscolor-highlight-color)
  (wrap-objc-object
   (tell NSColor highlightColor)))
(define (nscolor-hue-component self)
  (tell #:type _double (coerce-arg self) hueComponent))
(define (nscolor-ignores-alpha)
  (tell #:type _bool NSColor ignoresAlpha))
(define (nscolor-set-ignores-alpha! value)
  (_msg-6 NSColor (sel_registerName "setIgnoresAlpha:") value))
(define (nscolor-keyboard-focus-indicator-color)
  (wrap-objc-object
   (tell NSColor keyboardFocusIndicatorColor)))
(define (nscolor-knob-color)
  (wrap-objc-object
   (tell NSColor knobColor)))
(define (nscolor-label-color)
  (wrap-objc-object
   (tell NSColor labelColor)))
(define (nscolor-light-gray-color)
  (wrap-objc-object
   (tell NSColor lightGrayColor)))
(define (nscolor-linear-exposure self)
  (tell #:type _double (coerce-arg self) linearExposure))
(define (nscolor-link-color)
  (wrap-objc-object
   (tell NSColor linkColor)))
(define (nscolor-localized-catalog-name-component self)
  (wrap-objc-object
   (tell (coerce-arg self) localizedCatalogNameComponent)))
(define (nscolor-localized-color-name-component self)
  (wrap-objc-object
   (tell (coerce-arg self) localizedColorNameComponent)))
(define (nscolor-magenta-color)
  (wrap-objc-object
   (tell NSColor magentaColor)))
(define (nscolor-magenta-component self)
  (tell #:type _double (coerce-arg self) magentaComponent))
(define (nscolor-number-of-components self)
  (tell #:type _int64 (coerce-arg self) numberOfComponents))
(define (nscolor-orange-color)
  (wrap-objc-object
   (tell NSColor orangeColor)))
(define (nscolor-pattern-image self)
  (wrap-objc-object
   (tell (coerce-arg self) patternImage)))
(define (nscolor-placeholder-text-color)
  (wrap-objc-object
   (tell NSColor placeholderTextColor)))
(define (nscolor-purple-color)
  (wrap-objc-object
   (tell NSColor purpleColor)))
(define (nscolor-quaternary-label-color)
  (wrap-objc-object
   (tell NSColor quaternaryLabelColor)))
(define (nscolor-quaternary-system-fill-color)
  (wrap-objc-object
   (tell NSColor quaternarySystemFillColor)))
(define (nscolor-quinary-label-color)
  (wrap-objc-object
   (tell NSColor quinaryLabelColor)))
(define (nscolor-quinary-system-fill-color)
  (wrap-objc-object
   (tell NSColor quinarySystemFillColor)))
(define (nscolor-red-color)
  (wrap-objc-object
   (tell NSColor redColor)))
(define (nscolor-red-component self)
  (tell #:type _double (coerce-arg self) redComponent))
(define (nscolor-saturation-component self)
  (tell #:type _double (coerce-arg self) saturationComponent))
(define (nscolor-scroll-bar-color)
  (wrap-objc-object
   (tell NSColor scrollBarColor)))
(define (nscolor-scrubber-textured-background-color)
  (wrap-objc-object
   (tell NSColor scrubberTexturedBackgroundColor)))
(define (nscolor-secondary-label-color)
  (wrap-objc-object
   (tell NSColor secondaryLabelColor)))
(define (nscolor-secondary-selected-control-color)
  (wrap-objc-object
   (tell NSColor secondarySelectedControlColor)))
(define (nscolor-secondary-system-fill-color)
  (wrap-objc-object
   (tell NSColor secondarySystemFillColor)))
(define (nscolor-selected-content-background-color)
  (wrap-objc-object
   (tell NSColor selectedContentBackgroundColor)))
(define (nscolor-selected-control-color)
  (wrap-objc-object
   (tell NSColor selectedControlColor)))
(define (nscolor-selected-control-text-color)
  (wrap-objc-object
   (tell NSColor selectedControlTextColor)))
(define (nscolor-selected-knob-color)
  (wrap-objc-object
   (tell NSColor selectedKnobColor)))
(define (nscolor-selected-menu-item-color)
  (wrap-objc-object
   (tell NSColor selectedMenuItemColor)))
(define (nscolor-selected-menu-item-text-color)
  (wrap-objc-object
   (tell NSColor selectedMenuItemTextColor)))
(define (nscolor-selected-text-background-color)
  (wrap-objc-object
   (tell NSColor selectedTextBackgroundColor)))
(define (nscolor-selected-text-color)
  (wrap-objc-object
   (tell NSColor selectedTextColor)))
(define (nscolor-separator-color)
  (wrap-objc-object
   (tell NSColor separatorColor)))
(define (nscolor-shadow-color)
  (wrap-objc-object
   (tell NSColor shadowColor)))
(define (nscolor-standard-dynamic-range-color self)
  (wrap-objc-object
   (tell (coerce-arg self) standardDynamicRangeColor)))
(define (nscolor-system-blue-color)
  (wrap-objc-object
   (tell NSColor systemBlueColor)))
(define (nscolor-system-brown-color)
  (wrap-objc-object
   (tell NSColor systemBrownColor)))
(define (nscolor-system-cyan-color)
  (wrap-objc-object
   (tell NSColor systemCyanColor)))
(define (nscolor-system-fill-color)
  (wrap-objc-object
   (tell NSColor systemFillColor)))
(define (nscolor-system-gray-color)
  (wrap-objc-object
   (tell NSColor systemGrayColor)))
(define (nscolor-system-green-color)
  (wrap-objc-object
   (tell NSColor systemGreenColor)))
(define (nscolor-system-indigo-color)
  (wrap-objc-object
   (tell NSColor systemIndigoColor)))
(define (nscolor-system-mint-color)
  (wrap-objc-object
   (tell NSColor systemMintColor)))
(define (nscolor-system-orange-color)
  (wrap-objc-object
   (tell NSColor systemOrangeColor)))
(define (nscolor-system-pink-color)
  (wrap-objc-object
   (tell NSColor systemPinkColor)))
(define (nscolor-system-purple-color)
  (wrap-objc-object
   (tell NSColor systemPurpleColor)))
(define (nscolor-system-red-color)
  (wrap-objc-object
   (tell NSColor systemRedColor)))
(define (nscolor-system-teal-color)
  (wrap-objc-object
   (tell NSColor systemTealColor)))
(define (nscolor-system-yellow-color)
  (wrap-objc-object
   (tell NSColor systemYellowColor)))
(define (nscolor-tertiary-label-color)
  (wrap-objc-object
   (tell NSColor tertiaryLabelColor)))
(define (nscolor-tertiary-system-fill-color)
  (wrap-objc-object
   (tell NSColor tertiarySystemFillColor)))
(define (nscolor-text-background-color)
  (wrap-objc-object
   (tell NSColor textBackgroundColor)))
(define (nscolor-text-color)
  (wrap-objc-object
   (tell NSColor textColor)))
(define (nscolor-text-insertion-point-color)
  (wrap-objc-object
   (tell NSColor textInsertionPointColor)))
(define (nscolor-transfer-representation)
  (wrap-objc-object
   (tell NSColor transferRepresentation)))
(define (nscolor-type self)
  (tell #:type _uint64 (coerce-arg self) type))
(define (nscolor-under-page-background-color)
  (wrap-objc-object
   (tell NSColor underPageBackgroundColor)))
(define (nscolor-unemphasized-selected-content-background-color)
  (wrap-objc-object
   (tell NSColor unemphasizedSelectedContentBackgroundColor)))
(define (nscolor-unemphasized-selected-text-background-color)
  (wrap-objc-object
   (tell NSColor unemphasizedSelectedTextBackgroundColor)))
(define (nscolor-unemphasized-selected-text-color)
  (wrap-objc-object
   (tell NSColor unemphasizedSelectedTextColor)))
(define (nscolor-white-color)
  (wrap-objc-object
   (tell NSColor whiteColor)))
(define (nscolor-white-component self)
  (tell #:type _double (coerce-arg self) whiteComponent))
(define (nscolor-window-background-color)
  (wrap-objc-object
   (tell NSColor windowBackgroundColor)))
(define (nscolor-window-frame-color)
  (wrap-objc-object
   (tell NSColor windowFrameColor)))
(define (nscolor-window-frame-text-color)
  (wrap-objc-object
   (tell NSColor windowFrameTextColor)))
(define (nscolor-yellow-color)
  (wrap-objc-object
   (tell NSColor yellowColor)))
(define (nscolor-yellow-component self)
  (tell #:type _double (coerce-arg self) yellowComponent))

;; --- Instance methods ---
(define (nscolor-blended-color-with-fraction-of-color self fraction color)
  (wrap-objc-object
   (_msg-11 (coerce-arg self) (sel_registerName "blendedColorWithFraction:ofColor:") fraction (coerce-arg color))
   ))
(define (nscolor-color-by-applying-content-headroom self content-headroom)
  (wrap-objc-object
   (_msg-7 (coerce-arg self) (sel_registerName "colorByApplyingContentHeadroom:") content-headroom)
   ))
(define (nscolor-color-using-color-space self space)
  (wrap-objc-object
   (tell (coerce-arg self) colorUsingColorSpace: (coerce-arg space))))
(define (nscolor-color-using-type self type)
  (wrap-objc-object
   (_msg-20 (coerce-arg self) (sel_registerName "colorUsingType:") type)
   ))
(define (nscolor-color-with-alpha-component self alpha)
  (wrap-objc-object
   (_msg-7 (coerce-arg self) (sel_registerName "colorWithAlphaComponent:") alpha)
   ))
(define (nscolor-color-with-system-effect self system-effect)
  (wrap-objc-object
   (_msg-20 (coerce-arg self) (sel_registerName "colorWithSystemEffect:") system-effect)
   ))
(define (nscolor-draw-swatch-in-rect self rect)
  (_msg-5 (coerce-arg self) (sel_registerName "drawSwatchInRect:") rect))
(define (nscolor-get-components self components)
  (_msg-16 (coerce-arg self) (sel_registerName "getComponents:") components))
(define (nscolor-get-cyan-magenta-yellow-black-alpha self cyan magenta yellow black alpha)
  (_msg-19 (coerce-arg self) (sel_registerName "getCyan:magenta:yellow:black:alpha:") cyan magenta yellow black alpha))
(define (nscolor-get-hue-saturation-brightness-alpha self hue saturation brightness alpha)
  (_msg-18 (coerce-arg self) (sel_registerName "getHue:saturation:brightness:alpha:") hue saturation brightness alpha))
(define (nscolor-get-red-green-blue-alpha self red green blue alpha)
  (_msg-18 (coerce-arg self) (sel_registerName "getRed:green:blue:alpha:") red green blue alpha))
(define (nscolor-get-white-alpha self white alpha)
  (_msg-17 (coerce-arg self) (sel_registerName "getWhite:alpha:") white alpha))
(define (nscolor-highlight-with-level self val)
  (wrap-objc-object
   (_msg-7 (coerce-arg self) (sel_registerName "highlightWithLevel:") val)
   ))
(define (nscolor-set! self)
  (tell #:type _void (coerce-arg self) set))
(define (nscolor-set-fill! self)
  (tell #:type _void (coerce-arg self) setFill))
(define (nscolor-set-stroke! self)
  (tell #:type _void (coerce-arg self) setStroke))
(define (nscolor-shadow-with-level self val)
  (wrap-objc-object
   (_msg-7 (coerce-arg self) (sel_registerName "shadowWithLevel:") val)
   ))
(define (nscolor-write-to-pasteboard self paste-board)
  (tell #:type _void (coerce-arg self) writeToPasteboard: (coerce-arg paste-board)))

;; --- Class methods ---
(define (nscolor-color-for-control-tint control-tint)
  (wrap-objc-object
   (_msg-20 NSColor (sel_registerName "colorForControlTint:") control-tint)
   ))
(define (nscolor-color-from-pasteboard paste-board)
  (wrap-objc-object
   (tell NSColor colorFromPasteboard: (coerce-arg paste-board))))
(define (nscolor-color-named name)
  (wrap-objc-object
   (tell NSColor colorNamed: (coerce-arg name))))
(define (nscolor-color-named-bundle name bundle)
  (wrap-objc-object
   (tell NSColor colorNamed: (coerce-arg name) bundle: (coerce-arg bundle))))
(define (nscolor-color-with-cg-color cg-color)
  (wrap-objc-object
   (_msg-15 NSColor (sel_registerName "colorWithCGColor:") cg-color)
   ))
(define (nscolor-color-with-calibrated-hue-saturation-brightness-alpha hue saturation brightness alpha)
  (wrap-objc-object
   (_msg-9 NSColor (sel_registerName "colorWithCalibratedHue:saturation:brightness:alpha:") hue saturation brightness alpha)
   ))
(define (nscolor-color-with-calibrated-red-green-blue-alpha red green blue alpha)
  (wrap-objc-object
   (_msg-9 NSColor (sel_registerName "colorWithCalibratedRed:green:blue:alpha:") red green blue alpha)
   ))
(define (nscolor-color-with-calibrated-white-alpha white alpha)
  (wrap-objc-object
   (_msg-8 NSColor (sel_registerName "colorWithCalibratedWhite:alpha:") white alpha)
   ))
(define (nscolor-color-with-catalog-name-color-name list-name color-name)
  (wrap-objc-object
   (tell NSColor colorWithCatalogName: (coerce-arg list-name) colorName: (coerce-arg color-name))))
(define (nscolor-color-with-color-space-components-count space components number-of-components)
  (wrap-objc-object
   (_msg-14 NSColor (sel_registerName "colorWithColorSpace:components:count:") (coerce-arg space) components number-of-components)
   ))
(define (nscolor-color-with-color-space-hue-saturation-brightness-alpha space hue saturation brightness alpha)
  (wrap-objc-object
   (_msg-12 NSColor (sel_registerName "colorWithColorSpace:hue:saturation:brightness:alpha:") (coerce-arg space) hue saturation brightness alpha)
   ))
(define (nscolor-color-with-device-cyan-magenta-yellow-black-alpha cyan magenta yellow black alpha)
  (wrap-objc-object
   (_msg-10 NSColor (sel_registerName "colorWithDeviceCyan:magenta:yellow:black:alpha:") cyan magenta yellow black alpha)
   ))
(define (nscolor-color-with-device-hue-saturation-brightness-alpha hue saturation brightness alpha)
  (wrap-objc-object
   (_msg-9 NSColor (sel_registerName "colorWithDeviceHue:saturation:brightness:alpha:") hue saturation brightness alpha)
   ))
(define (nscolor-color-with-device-red-green-blue-alpha red green blue alpha)
  (wrap-objc-object
   (_msg-9 NSColor (sel_registerName "colorWithDeviceRed:green:blue:alpha:") red green blue alpha)
   ))
(define (nscolor-color-with-device-white-alpha white alpha)
  (wrap-objc-object
   (_msg-8 NSColor (sel_registerName "colorWithDeviceWhite:alpha:") white alpha)
   ))
(define (nscolor-color-with-display-p3-red-green-blue-alpha red green blue alpha)
  (wrap-objc-object
   (_msg-9 NSColor (sel_registerName "colorWithDisplayP3Red:green:blue:alpha:") red green blue alpha)
   ))
(define (nscolor-color-with-generic-gamma22-white-alpha white alpha)
  (wrap-objc-object
   (_msg-8 NSColor (sel_registerName "colorWithGenericGamma22White:alpha:") white alpha)
   ))
(define (nscolor-color-with-hue-saturation-brightness-alpha hue saturation brightness alpha)
  (wrap-objc-object
   (_msg-9 NSColor (sel_registerName "colorWithHue:saturation:brightness:alpha:") hue saturation brightness alpha)
   ))
(define (nscolor-color-with-name-dynamic-provider color-name dynamic-provider)
  (define-values (_blk1 _blk1-id)
    (make-objc-block dynamic-provider (list _id) _id))
  (wrap-objc-object
   (_msg-13 NSColor (sel_registerName "colorWithName:dynamicProvider:") (coerce-arg color-name) _blk1)
   ))
(define (nscolor-color-with-pattern-image image)
  (wrap-objc-object
   (tell NSColor colorWithPatternImage: (coerce-arg image))))
(define (nscolor-color-with-red-green-blue-alpha red green blue alpha)
  (wrap-objc-object
   (_msg-9 NSColor (sel_registerName "colorWithRed:green:blue:alpha:") red green blue alpha)
   ))
(define (nscolor-color-with-red-green-blue-alpha-exposure red green blue alpha exposure)
  (wrap-objc-object
   (_msg-10 NSColor (sel_registerName "colorWithRed:green:blue:alpha:exposure:") red green blue alpha exposure)
   ))
(define (nscolor-color-with-red-green-blue-alpha-linear-exposure red green blue alpha linear-exposure)
  (wrap-objc-object
   (_msg-10 NSColor (sel_registerName "colorWithRed:green:blue:alpha:linearExposure:") red green blue alpha linear-exposure)
   ))
(define (nscolor-color-with-srgb-red-green-blue-alpha red green blue alpha)
  (wrap-objc-object
   (_msg-9 NSColor (sel_registerName "colorWithSRGBRed:green:blue:alpha:") red green blue alpha)
   ))
(define (nscolor-color-with-white-alpha white alpha)
  (wrap-objc-object
   (_msg-8 NSColor (sel_registerName "colorWithWhite:alpha:") white alpha)
   ))
