; Set a custom tray icon
TraySetIcon("c:\Users\pfilkin\Documents\WindowsPowerShell\Scripts\Images\powershell_toolkit_icon.ico", 1, true)

; Define the hotkey (e.g., Ctrl+Shift+R)
^+r:: 
{
    ; Open a file selection dialog to choose the PowerShell script
    filePath := FileSelect("File3", "Select a PowerShell script to run", "", "*.ps1")

    ; If the user cancels the dialog, filePath will be empty, so we check for that
    if !filePath
        return  ; Exit the hotkey action

    ; Run the PowerShell command as an administrator
    Run('*RunAs C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -NoExit -File "' . filePath . '"')
;    Run('*RunAs powershell.exe -ExecutionPolicy Bypass -NoExit -File "' . filePath . '"')
    
    return
}