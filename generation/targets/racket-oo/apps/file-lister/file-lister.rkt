#lang racket/base
;; file-lister.rkt — File Lister sample app (OO style)
;;
;; Directory browser: three-column NSTableView driven by a Racket
;; NSTableViewDataSource delegate, NSOpenPanel for directory selection,
;; NSFileManager.contentsOfDirectoryAtPath:error: for listing, and
;; Racket built-ins for file size and mtime formatting (NSDictionary
;; attribute extraction through NSNumber/NSDate would need more helpers
;; than the current bindings expose ergonomically — that's out of scope
;; for this app's goal of exercising the data-source delegate pattern).
;;
;; Exercises: data source delegate protocol, table columns, scroll view,
;; NSArray/NSString extraction, NSOpenPanel modal dialog, cross-class
;; wiring, delegate return types for NSInteger (via 'long return kind)
;; and id (autoreleased NSString).
;;
;; Run with: racket file-lister.rkt

(require ffi/unsafe
         ffi/unsafe/objc
         racket/format
         racket/list
         "../../generated/oo/appkit/nsapplication.rkt"
         "../../generated/oo/appkit/nswindow.rkt"
         "../../generated/oo/appkit/nsview.rkt"
         "../../generated/oo/appkit/nsbutton.rkt"
         "../../generated/oo/appkit/nstextfield.rkt"
         "../../generated/oo/appkit/nsfont.rkt"
         "../../generated/oo/appkit/nsstackview.rkt"
         "../../generated/oo/appkit/nsscrollview.rkt"
         "../../generated/oo/appkit/nstableview.rkt"
         "../../generated/oo/appkit/nstablecolumn.rkt"
         "../../generated/oo/appkit/nsopenpanel.rkt"
         "../../generated/oo/foundation/nsarray.rkt"
         "../../generated/oo/foundation/nsfilemanager.rkt"
         "../../generated/oo/foundation/nsurl.rkt"
         "../../runtime/objc-base.rkt"
         "../../runtime/type-mapping.rkt"
         "../../runtime/coerce.rkt"
         "../../runtime/delegate.rkt"
         "../../runtime/app-menu.rkt")

;; --- Constants (not yet extracted by collector) ---
;; NSWindowStyleMask
(define NSWindowStyleMaskTitled         1)
(define NSWindowStyleMaskClosable       2)
(define NSWindowStyleMaskMiniaturizable 4)
(define NSWindowStyleMaskResizable      8)
;; NSBackingStoreType
(define NSBackingStoreBuffered 2)
;; NSTextAlignment
(define NSTextAlignmentLeft 0)
;; NSViewAutoresizingMask
(define NSViewNotSizable    0)
(define NSViewMinXMargin    1)
(define NSViewWidthSizable  2)
(define NSViewMaxXMargin    4)
(define NSViewMinYMargin    8)
(define NSViewHeightSizable 16)
(define NSViewMaxYMargin    32)
;; NSBezelStyle
(define NSBezelStyleRounded 1)
;; NSModalResponse
(define NSModalResponseOK 1)
;; NSTableViewColumnAutoresizingStyle
(define NSTableViewFirstColumnOnlyAutoresizingStyle 5)
;; NSUserInterfaceLayoutOrientation
(define NSUserInterfaceLayoutOrientationHorizontal 0)
;; NSLayoutAttribute (subset used here)
(define NSLayoutAttributeFirstBaseline 12)

;; --- Helpers ---

;; Unwrap an NSString-valued objc-object to a Racket string
(define (ns->str obj)
  (cond
    [(not obj) ""]
    [(objc-object? obj)
     (if (objc-null? obj) "" (nsstring->string (objc-object-ptr obj)))]
    [(cpointer? obj) (nsstring->string obj)]
    [else ""]))

;; Format a byte count as a short human-readable string
(define (format-bytes n)
  (cond
    [(< n 1024) (format "~a B" n)]
    [(< n (* 1024 1024))
     (format "~a KB" (~r (/ n 1024.0) #:precision 1))]
    [(< n (* 1024 1024 1024))
     (format "~a MB" (~r (/ n 1024.0 1024.0) #:precision 1))]
    [else
     (format "~a GB" (~r (/ n 1024.0 1024.0 1024.0) #:precision 1))]))

(define (pad2 n) (~r n #:min-width 2 #:pad-string "0"))

(define (format-date seconds)
  (define d (seconds->date seconds))
  (format "~a-~a-~a ~a:~a"
          (date-year d)
          (pad2 (date-month d))
          (pad2 (date-day d))
          (pad2 (date-hour d))
          (pad2 (date-minute d))))

;; --- Directory listing via NSFileManager ---

;; List directory contents via NSFileManager (exercises the FFI path
;; and the NSArray<NSString*> extraction). Returns a list of Racket
;; strings with hidden (dot-prefixed) entries filtered out.
(define (list-directory-objc path)
  (with-handlers ([exn:fail? (lambda _ '())])
    (define fm (nsfilemanager-default-manager))
    ;; error out-param: pass #f (NULL is legal per Cocoa docs)
    (define raw-names
      (nsfilemanager-contents-of-directory-at-path-error fm path #f))
    (cond
      [(or (not raw-names) (objc-null? raw-names)) '()]
      [else
       (define count (nsarray-count raw-names))
       (for/list ([i (in-range count)]
                  #:when #t
                  #:when (let ([name (ns->str (nsarray-object-at-index raw-names i))])
                           (and (not (equal? name ""))
                                (not (char=? (string-ref name 0) #\.)))))
         (ns->str (nsarray-object-at-index raw-names i)))])))

;; Build (vector name-display size-str modified-str) for each child.
;; File size and mtime come from Racket's built-ins — no NSNumber/NSDate
;; extraction required.
(define (build-entries path)
  (define names (sort (list-directory-objc path) string<?))
  (for/list ([name (in-list names)])
    (define full-path
      (with-handlers ([exn:fail? (lambda _ #f)])
        (build-path path name)))
    (define is-dir?
      (and full-path (directory-exists? full-path)))
    (define size-str
      (cond [is-dir? "-"]
            [(and full-path (file-exists? full-path))
             (with-handlers ([exn:fail? (lambda _ "?")])
               (format-bytes (file-size full-path)))]
            [else "-"]))
    (define mod-str
      (if full-path
          (with-handlers ([exn:fail? (lambda _ "?")])
            (format-date (file-or-directory-modify-seconds full-path)))
          "?"))
    (vector (if is-dir? (string-append name "/") name)
            size-str
            mod-str)))

;; --- Application setup ---
(define app (nsapplication-shared-application))
(nsapplication-set-activation-policy! app 0) ; Regular

;; Standard macOS app menu (About / Hide / Quit). Shared helper from the
;; runtime — every sample app installs the same menu skeleton. The bold
;; app-name slot in the menu bar still comes from `CFBundleName`
;; (Info.plist), so running the .rkt directly via `racket file-lister.rkt`
;; will show "racket" up there even with this menu installed; bundle via
;; `apianyware-macos-bundle-racket-oo` to get "File Lister".
(install-standard-app-menu! app "File Lister")

;; --- Starting directory: home via NSFileManager (returns NSURL) ---
(define current-dir
  (ns->str
   (nsurl-path
    (nsfilemanager-home-directory-for-current-user
     (nsfilemanager-default-manager)))))

;; --- Mutable table state ---
(define file-entries (build-entries current-dir))

;; --- Window ---
(define window
  (make-nswindow-init-with-content-rect-style-mask-backing-defer
   (make-nsrect 0 0 600 400)
   (bitwise-ior NSWindowStyleMaskTitled
                NSWindowStyleMaskClosable
                NSWindowStyleMaskMiniaturizable
                NSWindowStyleMaskResizable)
   NSBackingStoreBuffered
   #f))
(nswindow-set-title! window "File Lister")
(nswindow-center! window)
(nswindow-set-min-size! window (make-nssize 400 300))

(define content-view (nswindow-content-view window))

;; --- Top bar: Choose Folder button + path label ---
;; --- Toolbar (button + path label, baseline-aligned) ---
;;
;; Manual-frame attempts to baseline-align an NSButton title with an
;; NSTextField label kept landing a half-pixel off because the two
;; controls compute their text origin differently (button has a bezel
;; inset; field uses NSTextFieldCell vertical centering). NSStackView
;; with `NSLayoutAttributeFirstBaseline` alignment lets Auto Layout
;; pin the views' first-baseline anchors together — the canonical fix.
;;
;; The stack view itself uses springs-and-struts (its frame is fixed
;; in the parent content view; autoresizing mask pins it to the top
;; and stretches its width). Its arranged subviews use Auto Layout
;; internally, which is the supported mixed mode.

(define choose-button (make-nsbutton-init-with-frame (make-nsrect 0 0 140 28)))
(nsbutton-set-title! choose-button "Choose Folder…")
(nsbutton-set-bezel-style! choose-button NSBezelStyleRounded)

(define path-label (make-nstextfield-init-with-frame (make-nsrect 0 0 0 0)))
(nstextfield-set-string-value! path-label current-dir)
(nstextfield-set-font! path-label (nsfont-system-font-of-size 13.0))
(nstextfield-set-alignment! path-label NSTextAlignmentLeft)
(nstextfield-set-editable! path-label #f)
(nstextfield-set-selectable! path-label #t)
(nstextfield-set-bezeled! path-label #f)
(nstextfield-set-draws-background! path-label #f)

(define toolbar-stack
  (make-nsstackview-init-with-frame (make-nsrect 12 356 576 32)))
(nsstackview-set-orientation! toolbar-stack NSUserInterfaceLayoutOrientationHorizontal)
(nsstackview-set-alignment! toolbar-stack NSLayoutAttributeFirstBaseline)
(nsstackview-set-spacing! toolbar-stack 8.0)
(nsstackview-add-arranged-subview! toolbar-stack choose-button)
(nsstackview-add-arranged-subview! toolbar-stack path-label)
;; Pin toolbar to top, stretch width with the window.
(nsview-set-autoresizing-mask! toolbar-stack
  (bitwise-ior NSViewWidthSizable NSViewMinYMargin))
(nsview-add-subview! content-view toolbar-stack)

;; --- Scroll view + Table view ---
;; Table fills the bottom of the window edge-to-edge: no left/right or
;; bottom inset, no bezel border. A native Mac list view (Finder, Mail,
;; Music) lays out the same way — content meets the window frame
;; directly, and the scrollers appear inside that area. NSNoBorder on
;; the scroll view drops the 1pt outer bezel that would otherwise
;; bracket the table at the window edge.
(define NSNoBorder 0)
(define scroll-view
  (make-nsscrollview-init-with-frame (make-nsrect 0 0 600 348)))
(nsscrollview-set-border-type! scroll-view NSNoBorder)
(nsscrollview-set-has-vertical-scroller! scroll-view #t)
(nsscrollview-set-has-horizontal-scroller! scroll-view #f)
(nsscrollview-set-autoresizing-mask! scroll-view
  (bitwise-ior NSViewWidthSizable NSViewHeightSizable))

(define table-view
  (make-nstableview-init-with-frame (make-nsrect 0 0 600 348)))
(nstableview-set-uses-alternating-row-background-colors! table-view #t)
;; Row height 20pt + default intercell spacing gives NSTextFieldCell enough
;; vertical room to render its baseline cleanly under the system font. The
;; NSTableView default (17pt) lands text half a pixel off in cell-based
;; mode, which reads as "vertical misalignment" even though nothing is
;; actually clipped.
(nstableview-set-row-height! table-view 20.0)
;; Stretch the table with its enclosing scroll view so horizontal resize
;; widens the content instead of leaving a right-side gutter.
(nstableview-set-autoresizing-mask! table-view
  (bitwise-ior NSViewWidthSizable NSViewHeightSizable))
;; First-column-only autoresizing: as the table widens, the Name column
;; absorbs the extra width. Size and Modified stay at their declared
;; widths — those numeric/date columns don't benefit from stretching.
(nstableview-set-column-autoresizing-style! table-view
  NSTableViewFirstColumnOnlyAutoresizingStyle)

;; Read-only display columns: make each column non-editable so
;; double-clicking a row doesn't drop NSTextFieldCell into edit mode on
;; the displayed value. `setEditable: NO` on the column is how
;; cell-based NSTableView gates that interaction.
(define (add-display-column! ident title width)
  (let ([col (make-nstablecolumn-init-with-identifier ident)])
    (nstablecolumn-set-title! col title)
    (nstablecolumn-set-width! col width)
    (nstablecolumn-set-editable! col #f)
    (nstableview-add-table-column! table-view col)
    col))

(define name-column (add-display-column! "name"     "Name"     280.0))
(define size-column (add-display-column! "size"     "Size"      96.0))
(define mod-column  (add-display-column! "modified" "Modified" 180.0))

(nsscrollview-set-document-view! scroll-view table-view)
(nsview-add-subview! content-view scroll-view)

;; --- Data source delegate ---
;;
;; NSTableViewDataSource's two required methods:
;;
;; - numberOfRowsInTableView: returns NSInteger (Int64 on 64-bit Apple).
;;   Registered with return kind 'long, which maps to the "q" type
;;   encoding and the Int64 trampoline in DelegateBridge.swift.
;;
;; - tableView:objectValueForTableColumn:row: returns id. Declared 'id.
;;   We build an autoreleased NSString with string->nsstring + tell
;;   autorelease. The table view retains it for display, and the
;;   autorelease pool drains it at the next event-loop turn.
;;
;; Delegate callbacks receive all args as raw cpointers. To talk to a
;; raw NSTableColumn pointer we go through `tell` directly (the class
;; wrappers enforce `objc-object?` on self) and extract the column
;; identifier by selector.
;;
;; The global `data-source` reference must stay live for the window's
;; lifetime — Cocoa holds the delegate weakly.
(define (col->id-str col-ptr)
  (let ([id-ptr (tell (cast col-ptr _pointer _id) identifier)])
    (nsstring->string id-ptr)))

(define (col-index col-ptr)
  (case (col->id-str col-ptr)
    [("name") 0]
    [("size") 1]
    [("modified") 2]
    [else 0]))

(define data-source
  (make-delegate
   #:return-types (hash "numberOfRowsInTableView:" 'long
                        "tableView:objectValueForTableColumn:row:" 'id)
   "numberOfRowsInTableView:"
   (lambda (_tv)
     (length file-entries))
   "tableView:objectValueForTableColumn:row:"
   (lambda (_tv col-ptr row-ptr)
     (define row (cast row-ptr _pointer _int64))
     (cond
       [(and (>= row 0) (< row (length file-entries)))
        (define entry (list-ref file-entries row))
        (define idx (col-index col-ptr))
        (define text (vector-ref entry idx))
        (tell (string->nsstring text) autorelease)]
       [else #f]))))

(nstableview-set-data-source! table-view data-source)

;; --- Choose Folder action ---
;;
;; Runs an NSOpenPanel modally (simpler than the completion-handler
;; variant: no block bridging). On OK, extracts the selected URL's
;; path, rebuilds entries, updates the label, and reloads the table.
(define (refresh-to-path! path)
  (set! current-dir path)
  (set! file-entries (build-entries path))
  (nstextfield-set-string-value! path-label path)
  (nstableview-reload-data table-view))

(define choose-target
  (make-delegate
   #:return-types (hash "chooseFolder:" 'void)
   "chooseFolder:"
   (lambda (_sender)
     (define panel (nsopenpanel-open-panel))
     (nsopenpanel-set-can-choose-directories! panel #t)
     (nsopenpanel-set-can-choose-files! panel #f)
     (nsopenpanel-set-allows-multiple-selection! panel #f)
     (define response (nsopenpanel-run-modal panel))
     (when (= response NSModalResponseOK)
       (define url (nsopenpanel-url panel))
       (define picked (ns->str (nsurl-path url)))
       (unless (equal? picked "")
         (refresh-to-path! picked))))))

(nsbutton-set-target! choose-button choose-target)
(nsbutton-set-action! choose-button (sel_registerName "chooseFolder:"))

;; --- Show window and run ---
(nswindow-make-key-and-order-front window #f)
(nsapplication-activate-ignoring-other-apps app #t)

(displayln "File Lister running. Close window or Ctrl+C to exit.")
(nsapplication-run app)
