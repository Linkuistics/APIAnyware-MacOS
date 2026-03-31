# Counter

**Complexity:** 2/7
**Key features exercised:** Target-action pattern, labels, buttons, number formatting, mutable state

## Purpose

A window with a numeric counter, increment/decrement buttons, and a reset button. Demonstrates the target-action pattern (button clicks triggering callbacks) and mutable application state.

## Window Layout

- **Window:**
  - Title: "Counter"
  - Size: 300 x 180 points
  - Position: centered on screen
  - Style: titled, closable, miniaturizable
  - Not resizable

- **Counter label:**
  - Position: centered horizontally, upper third of window
  - Font: system font, 48pt, bold
  - Alignment: centered
  - Initial text: "0"

- **Button row** (centered horizontally, lower third of window, evenly spaced):
  - **"-" button:** Decrements counter by 1
  - **"Reset" button:** Sets counter to 0
  - **"+" button:** Increments counter by 1

## Behavior

1. App launches showing counter at 0
2. Clicking "+" increments the display (0 -> 1 -> 2 -> ...)
3. Clicking "-" decrements the display (0 -> -1 -> -2 -> ...)
4. Clicking "Reset" returns display to 0
5. Counter allows negative values
6. Counter label updates immediately on each click

## API Surface

| API | Usage |
|-----|-------|
| `NSButton.initWithFrame:` | Create buttons |
| `NSButton.setTitle:` | Set button labels |
| `NSButton.setTarget:` | Set callback target |
| `NSButton.setAction:` | Set callback selector |
| `NSButton.setBezelStyle:` | Set rounded button appearance |
| `NSTextField` (label mode) | Display counter value |
| `NSTextField.setStringValue:` | Update displayed number |
| `NSFont.boldSystemFontOfSize:` | Large bold font for counter |
| `NSNumberFormatter` | Format integer display (optional) |

## Patterns Exercised

- **Target-action:** Button's `setTarget:action:` connecting UI events to handler methods
- **Mutable state:** Maintaining a counter integer and updating the UI on change
- **Delegate bridging:** Creating an ObjC-compatible target object from the language's callback mechanism
- **String conversion:** Converting integers to strings for display

## Success Criteria

- Counter starts at 0
- "+" button increments correctly
- "-" button decrements correctly (including into negatives)
- "Reset" returns to 0
- UI updates immediately on each button press
- All three buttons are visible and correctly labeled
