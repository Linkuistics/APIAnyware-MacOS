# Text Editor — TestAnyware Validation

## Prerequisites
- App binary built and located in shared directory
- macOS VM booted and TestAnyware server running
- A sample `.txt` file available for testing open/save

## Validation Steps

### 1. Launch and Initial State
- [ ] Launch the app
- [ ] Verify window title contains "Untitled"
- [ ] Verify text area is empty and editable
- [ ] Verify status label shows "0 chars"
- [ ] Verify toolbar with Open and Save buttons is visible

### 2. Text Editing
- [ ] Click in text area and type "Hello World"
- [ ] Verify text appears in the text area
- [ ] Verify status label updates to show character count (e.g., "11 chars")
- [ ] Verify modified indicator appears in status label

### 3. Undo/Redo
- [ ] Press Cmd-Z — verify "Hello World" text is undone (partially or fully)
- [ ] Press Cmd-Shift-Z — verify redo restores text
- [ ] Verify undo/redo menu items are available in Edit menu

### 4. File Open
- [ ] Click "Open" button (or File > Open)
- [ ] Verify Open Panel appears
- [ ] Select a .txt file
- [ ] Verify file content appears in text area
- [ ] Verify window title updates to show filename
- [ ] Verify character count updates

### 5. File Save
- [ ] Modify the opened file's text
- [ ] Click "Save" button
- [ ] Verify file is saved (re-open to verify content matches)
- [ ] Verify modified indicator clears after save

### 6. Save As
- [ ] Use File > Save As (or Save on untitled document)
- [ ] Verify Save Panel appears
- [ ] Choose a filename and save
- [ ] Verify window title updates to new filename

### 7. Find
- [ ] Press Cmd-F
- [ ] Verify find bar appears (built-in NSTextFinder)
- [ ] Type a search term present in the text
- [ ] Verify matches are highlighted

### 8. Menu Bar
- [ ] Verify File menu has New, Open, Save, Save As
- [ ] Verify Edit menu has Undo, Redo, Cut, Copy, Paste, Select All, Find

### 9. Visual Quality
- [ ] Text is readable at default font size
- [ ] Toolbar and status bar are properly positioned
- [ ] Text area fills the remaining window space
- [ ] Window resizing works correctly
