# Counter — TestAnyware Validation

## Prerequisites
- App binary built and located in shared directory
- macOS VM booted and TestAnyware server running

## Validation Steps

### 1. Launch and Initial State
- [ ] Launch the app
- [ ] Verify window title is "Counter"
- [ ] Verify counter display shows "0"
- [ ] Verify three buttons are visible: "-", "Reset", "+"

### 2. Increment
- [ ] Click "+" button
- [ ] Verify counter shows "1"
- [ ] Click "+" button four more times
- [ ] Verify counter shows "5"

### 3. Decrement
- [ ] Click "-" button
- [ ] Verify counter shows "4"
- [ ] Click "-" button five more times
- [ ] Verify counter shows "-1" (negative values work)

### 4. Reset
- [ ] Click "Reset" button
- [ ] Verify counter shows "0"

### 5. Rapid Interaction
- [ ] Click "+" rapidly 10 times
- [ ] Verify counter shows "10" (no missed clicks)
- [ ] Click "Reset"
- [ ] Verify counter shows "0"

### 6. Visual Quality
- [ ] Counter text is large and readable
- [ ] Buttons are evenly spaced and correctly labeled
- [ ] No UI flicker during rapid updates
- [ ] Window is not resizable (per spec)
