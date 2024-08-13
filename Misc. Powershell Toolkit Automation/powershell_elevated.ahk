; Set a custom tray icon
TraySetIcon("c:\Users\pfilkin\Documents\WindowsPowerShell\Scripts\Images\powershell_toolkit_icon.ico", 1, true)

^+r:: 
{
    ; Define the default folder for the scripts
    defaultFolder := "c:\Users\pfilkin\Documents\windowspowershell\Scripts\"

    ; Open a file selection dialog to choose the PowerShell script from the default folder
    filePath := FileSelect("File3", "Select a PowerShell script to run", defaultFolder, "*.ps1")

    ; If the user cancels the dialog, filePath will be empty, so we check for that
    if !filePath
        return  ; Exit the hotkey action

    ; Extract the file name without extension
    fileNameWithoutExt := RegExReplace(filePath, "^.*\\|\..*$", "")

    ; Define the scheduled task name based on the script name (without extension)
    taskName := fileNameWithoutExt

    ; Check if the scheduled task exists
    result := RunWait('schtasks /query /tn "' taskName '"', , 'Hide UseErrorLevel')
    
    if (result == 0)
    {
        ; If the task exists, run it
        Run('schtasks /run /tn "' taskName '"', , 'Hide')
    }
    else
    {
        ; If the task does not exist, run the script with UAC
        Run('*RunAs C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -NoExit -File "' filePath '"')
    }
    
    return
}
