# Menu Bar Tool

**Complexity:** 7/7 (most complex)
**Key features exercised:** NSStatusBar/NSStatusItem, NSMenu, global events, app without main window, timer-based updates

## Purpose

A menu bar (status bar) application with no main window. Shows a clock and system info in the menu bar, with a dropdown menu for actions. Demonstrates apps that live in the status bar area, global event monitoring, timer-based updates, and NSMenu construction. Inspired by utilities like Modaliser, iStat Menus, and Bartender.

## Menu Bar Layout

- **Status item:**
  - Displays current time in HH:MM format (updates every minute)
  - Clicking reveals the dropdown menu

- **Dropdown menu:**
  1. **Header:** "Menu Bar Tool" (disabled, bold)
  2. **Separator**
  3. **Current Date:** "Friday, March 27, 2026" (disabled, updates daily)
  4. **System Info submenu:**
     - "macOS {version}" (e.g., "macOS 15.4")
     - "CPU: {model}" (e.g., "CPU: Apple M1 Pro")
     - "Memory: {used}/{total}" (e.g., "Memory: 12.3 GB / 16.0 GB")
  5. **Separator**
  6. **"Copy Timestamp":** Copies ISO 8601 timestamp to clipboard
  7. **"Toggle Format":** Switches between 12h/24h time display
  8. **Separator**
  9. **"About":** Shows an about dialog (NSAlert)
  10. **"Quit":** Terminates the application

## Behavior

1. App launches with no dock icon and no main window
2. Status item appears in the menu bar showing current time
3. Time updates every minute via NSTimer
4. Clicking the status item shows the dropdown menu
5. "Copy Timestamp" copies current ISO 8601 time to NSPasteboard
6. "Toggle Format" switches between "3:45 PM" and "15:45"
7. "System Info" submenu shows live system information
8. "About" shows an NSAlert with app name and version
9. "Quit" calls `NSApplication.terminate:`

## API Surface

| API | Usage |
|-----|-------|
| `NSApplication.setActivationPolicy:` | Set to `.accessory` (no dock icon) |
| `NSStatusBar.systemStatusBar` | Access menu bar |
| `NSStatusBar.statusItemWithLength:` | Create status item |
| `NSStatusItem.button` | Get the status item's button |
| `NSStatusBarButton.setTitle:` | Set displayed text |
| `NSStatusItem.setMenu:` | Attach dropdown menu |
| `NSMenu` | Build dropdown menu |
| `NSMenu.addItem:` | Add menu items |
| `NSMenuItem.initWithTitle:action:keyEquivalent:` | Create menu item |
| `NSMenuItem.setSubmenu:` | Attach submenu |
| `NSMenuItem.setEnabled:` | Enable/disable items |
| `NSTimer.scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:` | Periodic updates |
| `NSDateFormatter` | Format time display |
| `NSPasteboard.generalPasteboard` | Clipboard access |
| `NSPasteboard.setString:forType:` | Copy to clipboard |
| `NSProcessInfo.processInfo` | Get OS version |
| `NSAlert` | About dialog |
| `NSHost.currentHost` | System info |

## Patterns Exercised

- **App without main window:** `activationPolicy = .accessory`, no `NSWindow` created
- **NSStatusBar / NSStatusItem:** Status bar presence, custom title
- **NSMenu construction:** Hierarchical menus with submenus, separators, key equivalents
- **Timer-based updates:** NSTimer firing periodically to refresh the clock
- **Clipboard interaction:** NSPasteboard read/write
- **Global app lifecycle:** Running without a window, quit from menu item
- **Target-action on menu items:** Each menu item triggers a different callback
- **System information APIs:** NSProcessInfo for OS version

## Success Criteria

- No dock icon visible; app lives entirely in the menu bar
- Status item shows current time
- Time updates automatically (verify by waiting > 1 minute)
- Dropdown menu appears on click with all items
- "Copy Timestamp" puts valid ISO 8601 in clipboard
- "Toggle Format" switches display between 12h/24h
- System Info submenu shows real system data
- "About" shows an alert dialog
- "Quit" terminates the app cleanly
