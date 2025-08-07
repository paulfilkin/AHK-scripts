;------------------------------------------------------------------------------
; Enhanced Window Spy - Capture info at mouse position
; Press Win+Shift+Z to capture information at current mouse position
; Press Win+Shift+X to show last captured information
; Press Win+Shift+C to copy last captured info to clipboard
;------------------------------------------------------------------------------

#Requires AutoHotkey v2.0

; Global variable to store captured info
global capturedInfo := ""

; Win+Shift+Z - Capture information at mouse position
#+z:: CaptureWindowInfo()

; Win+Shift+X - Show last captured information
#+x:: ShowCapturedInfo()

; Win+Shift+C - Copy to clipboard
#+c:: CopyToClipboard()

CaptureWindowInfo() {
    ; Get mouse position
    MouseGetPos(&mouseX, &mouseY, &winID, &controlClassNN, 2)

    ; Start building the info string
    info := "========== WINDOW SPY CAPTURE ==========`n"
    info .= "Capture Time: " . A_Now . "`n"
    info .= "`n--- MOUSE POSITION ---`n"
    info .= "Screen: X: " . mouseX . " Y: " . mouseY . "`n"

    ; Get window information
    if (winID) {
        ; Basic window info
        winTitle := WinGetTitle(winID)
        winClass := WinGetClass(winID)
        processName := WinGetProcessName(winID)
        pid := WinGetPID(winID)

        info .= "`n--- WINDOW INFORMATION ---`n"
        info .= "Title: " . winTitle . "`n"
        info .= "Class: " . winClass . "`n"
        info .= "Process: " . processName . "`n"
        info .= "PID: " . pid . "`n"
        info .= "ID: " . winID . "`n"

        ; Window position and size
        WinGetPos(&winX, &winY, &winWidth, &winHeight, winID)
        info .= "`nWindow Position: X: " . winX . " Y: " . winY . "`n"
        info .= "Window Size: W: " . winWidth . " H: " . winHeight . "`n"

        ; Control under mouse
        if (controlClassNN) {
            info .= "`n--- CONTROL UNDER MOUSE ---`n"
            info .= "ClassNN: " . controlClassNN . "`n"

            ; Try to get control text
            try {
                controlText := ControlGetText(controlClassNN, winID)
                if (controlText)
                    info .= "Text: " . controlText . "`n"
            }

            ; Try to get control position
            try {
                ControlGetPos(&ctrlX, &ctrlY, &ctrlW, &ctrlH, controlClassNN, winID)
                info .= "Control Pos (relative): X: " . ctrlX . " Y: " . ctrlY . "`n"
                info .= "Control Size: W: " . ctrlW . " H: " . ctrlH . "`n"
            }

            ; Check if it's enabled
            try {
                isEnabled := ControlGetEnabled(controlClassNN, winID)
                info .= "Enabled: " . (isEnabled ? "Yes" : "No") . "`n"
            }

            ; Check if it's visible
            try {
                isVisible := ControlGetVisible(controlClassNN, winID)
                info .= "Visible: " . (isVisible ? "Yes" : "No") . "`n"
            }

            ; Try to get checkbox state if applicable
            try {
                isChecked := ControlGetChecked(controlClassNN, winID)
                info .= "Checked: " . (isChecked ? "Yes" : "No") . "`n"
            }

            ; Try to get control style
            try {
                controlStyle := ControlGetStyle(controlClassNN, winID)
                info .= "Style: 0x" . Format("{:X}", controlStyle) . "`n"
            }
        }

        ; Get pixel color at mouse position
        CoordMode("Pixel", "Screen")
        pixelColor := PixelGetColor(mouseX, mouseY)
        info .= "`n--- PIXEL INFORMATION ---`n"
        info .= "Color at cursor: " . pixelColor . " (Hex: 0x" . Format("{:X}", pixelColor) . ")`n"

        ; List all controls in the window
        info .= "`n--- ALL CONTROLS IN WINDOW ---`n"
        try {
            controls := WinGetControls(winID)
            info .= "Total Controls: " . controls.Length . "`n"

            ; List first 20 controls
            for index, ctrl in controls {
                if (index <= 20) {
                    ctrlText := ""
                    try {
                        ctrlText := ControlGetText(ctrl, winID)
                    }

                    if (ctrlText)
                        info .= index . ": " . ctrl . " - Text: " . SubStr(ctrlText, 1, 50) . "`n"
                    else
                        info .= index . ": " . ctrl . "`n"
                }
            }

            if (controls.Length > 20)
                info .= "... and " . (controls.Length - 20) . " more controls`n"
        }

        ; Get window text
        try {
            winText := WinGetText(winID)
            if (winText) {
                info .= "`n--- WINDOW TEXT (first 500 chars) ---`n"
                info .= SubStr(winText, 1, 500) . "`n"
            }
        }

        ; Check for specific window types
        info .= "`n--- SPECIAL DETECTIONS ---`n"

        ; Check for Chrome/Electron rendered content
        chromeLike := false
        for index, ctrl in controls {
            if (InStr(ctrl, "Chrome_RenderWidgetHostHWND")) {
                chromeLike := true
                break
            }
        }

        if (chromeLike)
            info .= "⚠ Chrome/Electron rendered window detected - standard control commands may not work`n"

        ; Check for WPF
        if (InStr(winClass, "HwndWrapper"))
            info .= "⚠ WPF application detected`n"

        ; Check for Windows Forms - check both control under mouse and all controls
        windowsFormsDetected := false
        if (InStr(controlClassNN, "WindowsForms10"))
            windowsFormsDetected := true
        else {
            for index, ctrl in controls {
                if (InStr(ctrl, "WindowsForms10")) {
                    windowsFormsDetected := true
                    break
                }
            }
        }
        if (windowsFormsDetected)
            info .= "⚠ .NET Windows Forms detected`n"

        ; Java Swing applications
        if (InStr(winClass, "SunAwt"))
            info .= "⚠ Java Swing application detected`n"

        ; Qt applications
        if (InStr(winClass, "Qt5") || InStr(winClass, "Qt6"))
            info .= "⚠ Qt framework detected`n"

        ; UWP/Modern Windows apps
        if (InStr(winClass, "ApplicationFrame"))
            info .= "⚠ UWP/Modern Windows app detected`n"

        ; Delphi applications
        if (InStr(winClass, "TForm") || InStr(winClass, "TButton"))
            info .= "⚠ Delphi application detected`n"

        ; Custom rendering detection
        if (controls.Length < 5 && WinGetText(winID) != "")
            info .= "⚠ Possible custom-rendered UI (few controls but has text)`n"

        ; Accessibility warnings
        if (controlClassNN && controlClassNN != "") {
            try {
                ctrlText := ControlGetText(controlClassNN, winID)
                if (!ctrlText || ctrlText = "")
                    info .= "⚠ Control doesn't expose text - accessibility may be limited`n"
            }
        }

        ; Check for unusual ClassNN (like the numeric one we saw)
        if (controlClassNN && RegExMatch(controlClassNN, "^\d+$"))
            info .= "⚠ Unusual numeric ClassNN detected - control may not be properly accessible`n"

        ; Check for control state mismatches
        if (InStr(controlClassNN, "BUTTON")) {
            try {
                ; Try to detect if it's a checkbox/radio button based on style
                controlStyle := ControlGetStyle(controlClassNN, winID)
                ; BS_CHECKBOX = 0x2, BS_AUTOCHECKBOX = 0x3, BS_RADIOBUTTON = 0x4, BS_3STATE = 0x5, BS_AUTO3STATE = 0x6, BS_AUTORADIOBUTTON = 0x9
                buttonType := controlStyle & 0xF
                if (buttonType >= 2 && buttonType <= 6 || buttonType = 9) {
                    info .= "ℹ Checkbox/Radio button detected - check if state reporting is accurate`n"
                }
            }
        }
    }

    ; Store the captured info
    global capturedInfo := info

    ; Show preview in tooltip
    ToolTip("Window info captured! Press Win+Shift+X to view`nWin+Shift+C to copy to clipboard")
    SetTimer(() => ToolTip(), -2000)  ; Remove tooltip after 2 seconds
}

ShowCapturedInfo() {
    global capturedInfo

    if (!capturedInfo) {
        MsgBox("No information captured yet. Press Win+Shift+Z to capture.", "Window Spy")
        return
    }

    ; Create a GUI to display the information
    infoGui := Gui("+Resize", "Window Spy Capture")
    infoGui.SetFont("s9", "Consolas")

    ; Add edit control with captured info
    editCtrl := infoGui.Add("Edit", "w800 h600 ReadOnly VScroll HScroll", capturedInfo)

    ; Add buttons
    infoGui.Add("Button", "w100", "&Copy to Clipboard").OnEvent("Click", (*) => CopyToClipboard())
    infoGui.Add("Button", "w100 x+10", "&Save to File").OnEvent("Click", (*) => SaveToFile())
    infoGui.Add("Button", "w100 x+10", "&Close").OnEvent("Click", (*) => infoGui.Close())

    infoGui.Show()
}

CopyToClipboard() {
    global capturedInfo

    if (!capturedInfo) {
        MsgBox("No information captured yet.", "Window Spy")
        return
    }

    A_Clipboard := capturedInfo
    ToolTip("Copied to clipboard!")
    SetTimer(() => ToolTip(), -1500)
}

SaveToFile() {
    global capturedInfo

    if (!capturedInfo) {
        MsgBox("No information captured yet.", "Window Spy")
        return
    }

    ; Ask where to save
    selectedFile := FileSelect("S", A_Desktop . "\WindowSpy_" . A_Now . ".txt", "Save Window Spy Capture", "Text Files (*.txt)")

    if (selectedFile) {
        FileAppend(capturedInfo, selectedFile)
        MsgBox("Saved to: " . selectedFile, "Window Spy")
    }
}

; Optional: Add hotkey to continuously update info under mouse
; Win+Shift+A to toggle continuous mode
#+a:: ToggleContinuousMode()

global continuousMode := false
global continuousTimer := ""

ToggleContinuousMode() {
    global continuousMode, continuousTimer

    continuousMode := !continuousMode

    if (continuousMode) {
        ; Update every 100ms
        continuousTimer := SetTimer(UpdateMouseInfo, 100)
        ToolTip("Continuous mode ON - Press Win+Shift+A to stop")
    } else {
        SetTimer(continuousTimer, 0)
        ToolTip()
    }
}

UpdateMouseInfo() {
    MouseGetPos(&mouseX, &mouseY, &winID, &controlClassNN, 2)

    info := "=== LIVE MOUSE INFO ===`n"
    info .= "Pos: " . mouseX . ", " . mouseY . "`n"

    if (winID) {
        info .= "Window: " . WinGetTitle(winID) . "`n"
        info .= "Class: " . WinGetClass(winID) . "`n"
    }

    if (controlClassNN) {
        info .= "Control: " . controlClassNN . "`n"
        try {
            controlText := ControlGetText(controlClassNN, winID)
            if (controlText)
                info .= "Text: " . SubStr(controlText, 1, 50) . "`n"
        }
    }

    ; Get pixel color
    pixelColor := PixelGetColor(mouseX, mouseY)
    info .= "Color: 0x" . Format("{:X}", pixelColor) . "`n"

    info .= "`nWin+Shift+A to stop"

    ToolTip(info, mouseX + 15, mouseY + 15)
}
