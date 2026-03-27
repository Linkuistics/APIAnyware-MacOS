# Text Editor

**Complexity:** 5/7
**Key features exercised:** Block callbacks, error-out pattern, scoped resources, notifications, undo/redo, file save/open

## Purpose

A basic text editor with file open/save, undo/redo, and find. Demonstrates more complex patterns: scoped resource management (undo grouping), notification observation (text change tracking), block-based APIs, and error handling.

## Window Layout

- **Window:**
  - Title: "Untitled - Text Editor" (updates to filename when a file is opened/saved)
  - Size: 700 x 500 points
  - Position: centered on screen
  - Style: titled, closable, miniaturizable, resizable
  - Minimum size: 400 x 300

- **Menu bar additions** (beyond default app menu):
  - **File menu:** New, Open..., Save, Save As...
  - **Edit menu:** Undo, Redo, Cut, Copy, Paste, Select All, Find...

- **Toolbar** (top of content view):
  - **"Open" button:** Opens file via NSOpenPanel
  - **"Save" button:** Saves current file (or Save As if untitled)
  - **Status label:** Shows character count and modified indicator ("42 chars | Modified")

- **Text area** (fills remaining space):
  - `NSTextView` inside `NSScrollView`
  - Editable, allows undo/redo
  - Default system font, 13pt
  - Line wrapping enabled

## Behavior

1. App launches with empty text area, title "Untitled - Text Editor"
2. Typing in the text area:
   - Character count updates in status label
   - Modified indicator appears ("Modified")
   - Changes are registered with the undo manager
3. **Open:** NSOpenPanel for `.txt` files, loads content into text view, updates title
4. **Save:** If file exists, writes to same path; otherwise prompts with NSSavePanel
5. **Save As:** Always prompts with NSSavePanel
6. **Undo/Redo:** Standard undo/redo via NSUndoManager (Cmd-Z / Cmd-Shift-Z)
7. **Find:** Cmd-F activates the text view's built-in find bar (NSTextFinder)
8. After saving, modified indicator clears

## API Surface

| API | Usage |
|-----|-------|
| `NSTextView` | Main text editing area |
| `NSScrollView` | Scrollable text container |
| `NSTextView.string` | Get/set text content |
| `NSTextView.undoManager` | Access undo manager |
| `NSTextView.setUsesFindBar:` | Enable find bar |
| `NSUndoManager` | Undo/redo support |
| `NSUndoManager.beginUndoGrouping` | Scoped undo (paired state) |
| `NSUndoManager.endUndoGrouping` | End undo grouping |
| `NSNotificationCenter` | Observe text changes |
| `NSText.DidChangeNotification` | Text modification event |
| `NSOpenPanel` | File open dialog |
| `NSSavePanel` | File save dialog |
| `NSString.stringWithContentsOfFile:encoding:error:` | Read file (error-out) |
| `NSString.writeToFile:atomically:encoding:error:` | Write file (error-out) |
| `NSMenuItem` | Menu items for File/Edit menus |
| `NSMenu` | Menu construction |

## Patterns Exercised

- **Block callbacks:** Open/save panel completion handlers
- **Error-out pattern:** File read/write with `NSError **` out-parameter
- **Scoped resources / paired state:** `beginUndoGrouping` / `endUndoGrouping`
- **Notification observation:** Observing `NSText.DidChangeNotification` for text changes
- **Observer pair:** `addObserver:` / `removeObserver:` lifecycle
- **Menu construction:** Building File/Edit menus with key equivalents

## Success Criteria

- Empty editor on launch with correct title
- Text input works with character count updating
- Open loads a text file and updates title
- Save writes file correctly (verified by re-opening)
- Undo reverses typing; Redo restores it
- Find bar activates with Cmd-F
- Modified indicator appears on edit, clears on save
- Error dialog shown if file operations fail (e.g., permission denied)
