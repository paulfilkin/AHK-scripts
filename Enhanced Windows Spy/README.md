# Enhanced Window Spy for AutoHotkey v2

A diagnostic tool for AutoHotkey v2 courtesy of Claude AI that captures detailed window and control information at the mouse position, helping identify why automation might fail and suggesting alternative approaches.

## 🚀 Quick Start

1. **Requirements**: AutoHotkey v2.0 or later
2. Save the script as `EnhancedWindowSpy.ahk`
3. Run the script
4. Use the hotkeys below to capture window information

## ⌨️ Hotkeys

| Hotkey          | Action                                                 |
| --------------- | ------------------------------------------------------ |
| **Win+Shift+Z** | Capture detailed information at current mouse position |
| **Win+Shift+X** | Display last captured information in a GUI window      |
| **Win+Shift+C** | Copy last captured information to clipboard            |
| **Win+Shift+A** | Toggle continuous mode (live tooltip following mouse)  |

## 📊 Captured Information

The script captures comprehensive data about windows and controls:

### Window Information

- Window title, class, process name, and PID
- Window position and dimensions
- Full window text content

### Control Details

- ClassNN identifier
- Control text and position
- Enabled/Visible status
- Checkbox state (if applicable)
- Control style flags

### Pixel Data

- Color at cursor position (decimal and hex)
- Useful for pixel-based detection methods

### All Window Controls

- Complete list of controls in the window
- First 20 controls shown with their text content
- Helpful for finding the correct control identifiers

## 🔍 Special Detections

The script automatically detects various UI frameworks and potential issues:

### Framework Detection

- **Chrome/Electron** - Modern web-based applications (VS Code, Discord, Teams)
- **WPF** - Windows Presentation Foundation apps
- **.NET Windows Forms** - Classic .NET applications
- **Java Swing** - Java-based applications
- **Qt Framework** - Cross-platform Qt applications
- **UWP/Modern Apps** - Windows Store applications
- **Delphi** - Delphi/C++ Builder applications

### Issue Warnings

- **Custom-rendered UI** - Few controls but visible text (may need OCR/image recognition)
- **Accessibility limitations** - Controls not exposing text properly
- **Unusual ClassNN** - Numeric-only identifiers indicating inaccessible controls
- **Button type detection** - Identifies checkboxes/radio buttons with potential state issues

## 💡 Use Cases

### Debugging Automation Scripts

When `ControlClick` or `ControlSetText` commands fail, use this tool to:

- Verify correct ClassNN identifiers
- Check if controls are actually accessible
- Identify framework-specific limitations

### Example: Trados Studio Issue

```
Problem: ControlSetChecked toggles instead of setting state
Window Spy reveals:
- .NET Windows Forms detected ✓
- Unusual numeric ClassNN (7475458) ⚠️
- Checkbox state not properly reported ⚠️
Solution: Use Tab navigation instead of control commands
```

### Finding Alternative Automation Methods

Based on the framework detected, consider:

- **Chrome/Electron**: Use Tab/keyboard navigation or accessibility APIs
- **Custom-rendered**: Implement pixel/image detection
- **WPF**: Try UI Automation COM interfaces
- **.NET Forms**: Check for inconsistent state reporting

## 📁 Output Options

### GUI Display (Win+Shift+X)

- Scrollable text view
- Copy to clipboard button
- Save to file option

### Clipboard (Win+Shift+C)

- Quick copy for sharing or documentation
- Formatted text output

### File Export

- Save captures with timestamp
- Default location: Desktop
- Format: Plain text (.txt)

### Continuous Mode (Win+Shift+A)

- Real-time tooltip at mouse position
- Updates every 100ms
- Shows position, window, control, and pixel color

## 🛠️ Customization

### Adding New Detections

Add framework detection in the "Special Detections" section:

```autohotkey
; Example: Detect custom framework
if (InStr(winClass, "MyFramework"))
    info .= "⚠ MyFramework detected - use specific approach`n"
```

### Adjusting Continuous Mode

Change update frequency (default 100ms):

```autohotkey
continuousTimer := SetTimer(UpdateMouseInfo, 50)  ; 50ms for faster updates
```

### Modifying Capture Scope

Limit control listing to specific number:

```autohotkey
for index, ctrl in controls {
    if (index <= 50) {  ; Show 50 controls instead of 20
```

## ⚠️ Known Limitations

1. **Chrome/Electron Apps**: Controls may not be individually accessible
2. **State Detection**: Some frameworks don't properly report checkbox/radio states
3. **Dynamic ClassNN**: Some applications generate new ClassNN identifiers each session
4. **Protected Windows**: Cannot capture from elevated/admin windows unless script is also elevated

## 🔧 Troubleshooting

### "No information captured"

- Ensure you pressed Win+Shift+Z while hovering over a window
- Check if the target window is elevated (run script as admin)

### Controls show as numbers only

- Indicates rendering layer interference
- Use the "All Controls" list to find actual ClassNN

### Empty control text

- Control may not expose text through standard APIs
- Check "Special Detections" for framework-specific warnings

## 📝 Example Output

```
========== WINDOW SPY CAPTURE ==========
Capture Time: 20250807105616

--- MOUSE POSITION ---
Screen: X: 25 Y: 178

--- WINDOW INFORMATION ---
Title: Find and Replace
Class: WindowsForms10.Window.8.app.0.ea119_r8_ad1
Process: SDLTradosStudio.exe

--- CONTROL UNDER MOUSE ---
ClassNN: WindowsForms10.BUTTON.app.0.ea119_r8_ad11
Text: &Match case
Checked: No

--- SPECIAL DETECTIONS ---
⚠ .NET Windows Forms detected
⚠ Unusual numeric ClassNN detected
ℹ Checkbox/Radio button detected
```

## 🤝 Contributing

Feel free to enhance this script with:

- Additional framework detections
- More detailed control analysis
- Export to different formats (JSON, CSV)
- Integration with other AutoHotkey tools

## 📄 License

Free to use and modify for any purpose. Created for the AutoHotkey community.

## 🙏 Acknowledgments

Inspired by the built-in AutoHotkey Window Spy tool, enhanced with modern framework detection and diagnostic capabilities for troubleshooting automation challenges.