# File Lister — TestAnyware Validation

## Prerequisites
- App binary built and located in shared directory
- macOS VM booted and TestAnyware server running
- Home directory has at least a few files/directories

## Validation Steps

### 1. Launch and Initial State
- [ ] Launch the app
- [ ] Verify window title is "File Lister"
- [ ] Verify table view is visible with three columns: Name, Size, Modified
- [ ] Verify home directory contents are listed
- [ ] Verify path label shows home directory path

### 2. Table Content
- [ ] Verify file names are listed (at least Desktop, Documents, Downloads visible)
- [ ] Verify size column shows readable sizes (e.g., "4.2 KB") or "-" for directories
- [ ] Verify modified column shows dates in readable format
- [ ] Verify hidden files (starting with ".") are NOT shown

### 3. Directory Navigation
- [ ] Click "Choose Folder..." button
- [ ] Verify an Open Panel appears for directory selection
- [ ] Select a directory with known contents
- [ ] Verify table refreshes with new directory contents
- [ ] Verify path label updates to the selected directory

### 4. Table Interaction
- [ ] Verify rows are selectable (click to highlight)
- [ ] If directory has many files, verify scrolling works
- [ ] Verify column headers are visible
- [ ] Verify alternating row colors (if applicable)

### 5. Edge Cases
- [ ] Navigate to an empty directory — verify empty table (no crash)
- [ ] Navigate to a directory with many files (e.g., /usr/bin) — verify it loads

### 6. Visual Quality
- [ ] Table columns are properly aligned
- [ ] No text truncation in visible columns (resize window if needed)
- [ ] Button and path label are positioned correctly above table
