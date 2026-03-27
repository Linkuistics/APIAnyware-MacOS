# Menu Bar Tool — TestAnyware Validation

## Prerequisites
- App binary built and located in shared directory
- macOS VM booted and TestAnyware server running

## Validation Steps

### 1. Launch and Status Bar
- [ ] Launch the app
- [ ] Verify NO dock icon appears
- [ ] Verify NO main window appears
- [ ] Verify a new status item appears in the menu bar area
- [ ] Verify the status item displays a time (e.g., "15:45" or "3:45 PM")

### 2. Dropdown Menu
- [ ] Click the status item in the menu bar
- [ ] Verify dropdown menu appears
- [ ] Verify "Menu Bar Tool" header is present (disabled/bold)
- [ ] Verify current date is shown in readable format
- [ ] Verify "System Info" submenu exists
- [ ] Verify separator lines between sections
- [ ] Verify "Copy Timestamp", "Toggle Format", "About", "Quit" items present

### 3. System Info Submenu
- [ ] Hover over "System Info" to reveal submenu
- [ ] Verify macOS version string is shown (e.g., "macOS 15.4")
- [ ] Verify CPU information is shown
- [ ] Verify memory information is shown

### 4. Copy Timestamp
- [ ] Click "Copy Timestamp"
- [ ] Open a text editor or text field in the VM
- [ ] Paste (Cmd-V) and verify an ISO 8601 timestamp was pasted
- [ ] Verify timestamp is recent (within the last minute)

### 5. Toggle Format
- [ ] Note current time format (12h or 24h)
- [ ] Click status item to open menu
- [ ] Click "Toggle Format"
- [ ] Verify time display switches format (e.g., "3:45 PM" -> "15:45")
- [ ] Toggle again to verify it switches back

### 6. Timer Updates
- [ ] Note the current displayed time
- [ ] Wait approximately 1 minute
- [ ] Verify the time display has updated

### 7. About Dialog
- [ ] Click "About" in the menu
- [ ] Verify an alert/dialog appears with app name
- [ ] Dismiss the dialog

### 8. Quit
- [ ] Click "Quit" in the menu
- [ ] Verify the app terminates
- [ ] Verify the status item disappears from the menu bar
