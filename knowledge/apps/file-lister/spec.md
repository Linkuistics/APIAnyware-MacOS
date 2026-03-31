# File Lister

**Complexity:** 4/7
**Key features exercised:** Collections, NSTableView, data source delegate protocol, NSFileManager, NSOpenPanel

## Purpose

A file browser that lists directory contents in a table view. The user can select a directory (via Open Panel) and see its files with name, size, and modification date columns. Demonstrates delegate/data source protocols, collections, and file system APIs.

## Window Layout

- **Window:**
  - Title: "File Lister"
  - Size: 600 x 400 points
  - Position: centered on screen
  - Style: titled, closable, miniaturizable, resizable
  - Minimum size: 400 x 300

- **Toolbar area** (top of content view):
  - **"Choose Folder..." button:** Opens NSOpenPanel to select a directory
  - **Path label:** Shows the currently selected directory path (initially "~")

- **Table view** (fills remaining space):
  - Columns: "Name", "Size", "Modified"
  - Header row with column titles
  - Sortable by clicking column headers (optional)
  - Alternating row colors
  - Scroll support for long listings

## Behavior

1. App launches showing home directory contents
2. Table displays files and subdirectories with:
   - **Name:** File/directory name (directories indicated with "/" suffix or icon)
   - **Size:** Human-readable size (e.g., "4.2 KB", "1.3 MB") — directories show "-"
   - **Modified:** Date in "YYYY-MM-DD HH:MM" format
3. Clicking "Choose Folder..." opens an NSOpenPanel configured for directory selection
4. After selecting a directory, table refreshes with new contents
5. Path label updates to show the selected directory
6. Hidden files (dot-prefixed) are excluded

## API Surface

| API | Usage |
|-----|-------|
| `NSTableView` | Display file listing |
| `NSTableColumn` | Define name/size/modified columns |
| `NSScrollView` | Scrollable table container |
| `NSTableViewDataSource` | Provide row count and cell values |
| `NSTableViewDelegate` | Configure cell views |
| `NSFileManager.defaultManager` | Access file system |
| `NSFileManager.contentsOfDirectoryAtPath:error:` | List directory |
| `NSFileManager.attributesOfItemAtPath:error:` | Get file size/date |
| `NSOpenPanel` | Directory selection dialog |
| `NSOpenPanel.setCanChooseDirectories:` | Allow directory selection |
| `NSOpenPanel.setCanChooseFiles:` | Disallow file selection |
| `NSOpenPanel.beginWithCompletionHandler:` | Show panel (block callback) |
| `NSDateFormatter` | Format modification dates |
| `NSByteCountFormatter` | Format file sizes |
| `NSArray` | Store directory listing |

## Patterns Exercised

- **Data source delegate:** Implementing `NSTableViewDataSource` protocol methods (`numberOfRowsInTableView:`, `tableView:objectValueForTableColumn:row:`)
- **Collections:** NSArray of file entries, NSDictionary of file attributes
- **Error-out pattern:** `contentsOfDirectoryAtPath:error:` with NSError out-param
- **Block callbacks:** NSOpenPanel completion handler
- **String formatting:** File sizes, dates
- **View hierarchy:** ScrollView containing TableView with columns

## Success Criteria

- Table shows home directory contents on launch
- All three columns populate correctly
- "Choose Folder..." opens a directory picker
- Table refreshes after selecting a new directory
- Path label updates correctly
- Large directories scroll smoothly
- Hidden files are excluded
