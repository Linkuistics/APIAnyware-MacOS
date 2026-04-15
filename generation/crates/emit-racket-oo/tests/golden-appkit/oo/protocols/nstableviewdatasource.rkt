#lang racket/base
;; Generated protocol definition for NSTableViewDataSource (AppKit)
;; Do not edit — regenerate from enriched IR
;;
;; NSTableViewDataSource defines 12 methods:
;;   void-returning (7):
;;     numberOfRowsInTableView:  (tableView:NSTableView)
;;     tableView:setObjectValue:forTableColumn:row:  (tableView:NSTableView, object:id, tableColumn:NSTableColumn, row:int64)
;;     tableView:sortDescriptorsDidChange:  (tableView:NSTableView, oldDescriptors:id)
;;     tableView:draggingSession:willBeginAtPoint:forRowIndexes:  (tableView:NSTableView, session:NSDraggingSession, screenPoint:NSPoint, rowIndexes:NSIndexSet)
;;     tableView:draggingSession:endedAtPoint:operation:  (tableView:NSTableView, session:NSDraggingSession, screenPoint:NSPoint, operation:NSDragOperation)
;;     tableView:updateDraggingItemsForDrag:  (tableView:NSTableView, draggingInfo:id)
;;     tableView:validateDrop:proposedRow:proposedDropOperation:  (tableView:NSTableView, info:id, row:int64, dropOperation:NSTableViewDropOperation)
;;   bool-returning (2):
;;     tableView:writeRowsWithIndexes:toPasteboard:  (tableView:NSTableView, rowIndexes:NSIndexSet, pboard:NSPasteboard)
;;     tableView:acceptDrop:row:dropOperation:  (tableView:NSTableView, info:id, row:int64, dropOperation:NSTableViewDropOperation)
;;   id-returning (3):
;;     tableView:objectValueForTableColumn:row:  (tableView:NSTableView, tableColumn:NSTableColumn, row:int64)
;;     tableView:pasteboardWriterForRow:  (tableView:NSTableView, row:int64)
;;     tableView:namesOfPromisedFilesDroppedAtDestination:forDraggedRowsWithIndexes:  (tableView:NSTableView, dropDestination:NSURL, indexSet:NSIndexSet)

(require racket/contract
         "../../../../runtime/delegate.rkt")

(provide/contract
  [make-nstableviewdatasource (->* () () #:rest (listof (or/c string? procedure?)) any/c)]
  [nstableviewdatasource-selectors (listof string?)])

;; All selectors in this protocol
(define nstableviewdatasource-selectors
  '("numberOfRowsInTableView:"
    "tableView:objectValueForTableColumn:row:"
    "tableView:setObjectValue:forTableColumn:row:"
    "tableView:sortDescriptorsDidChange:"
    "tableView:pasteboardWriterForRow:"
    "tableView:draggingSession:willBeginAtPoint:forRowIndexes:"
    "tableView:draggingSession:endedAtPoint:operation:"
    "tableView:updateDraggingItemsForDrag:"
    "tableView:writeRowsWithIndexes:toPasteboard:"
    "tableView:validateDrop:proposedRow:proposedDropOperation:"
    "tableView:acceptDrop:row:dropOperation:"
    "tableView:namesOfPromisedFilesDroppedAtDestination:forDraggedRowsWithIndexes:"))

;; Create a NSTableViewDataSource delegate.
;; Pass selector string → handler procedure pairs.
;; Example:
;;   (make-nstableviewdatasource
;;     "numberOfRowsInTableView:" (lambda (table-view) ...)
;;     "tableView:writeRowsWithIndexes:toPasteboard:" (lambda (table-view row-indexes pboard) ... #t)
;;   )
(define (make-nstableviewdatasource . selector+handler-pairs)
  (apply make-delegate
    #:return-types
    (hash "tableView:writeRowsWithIndexes:toPasteboard:" 'bool "tableView:acceptDrop:row:dropOperation:" 'bool "tableView:objectValueForTableColumn:row:" 'id "tableView:pasteboardWriterForRow:" 'id "tableView:namesOfPromisedFilesDroppedAtDestination:forDraggedRowsWithIndexes:" 'id)
    selector+handler-pairs))
