#Requires AutoHotkey v2.0
#Warn

; Check if the script is running as admin, if not, relaunch it as admin
if !A_IsAdmin {
    Run("*RunAs " A_ScriptFullPath)  ; Relaunch the script with admin privileges
    ExitApp()
}

; Define the log file path (same directory as the script)
logFilePath := A_ScriptDir "\assoc_debug_log.txt"

Log("Script started")

; Step 1: Prompt for the file extension
inputResult := InputBox("Enter the file extension you want to associate (e.g., .mqxliff):", "File Extension")

; Extract the input value from the InputBox result (inputResult.Value)
fileExtension := inputResult.Value

; Ensure the file extension starts with a dot and is not empty
if !fileExtension || (SubStr(fileExtension, 1, 1) != ".") {
    MsgBox("Invalid file extension! Please start with a dot (e.g., .mqxliff).")
    ExitApp()
}

; Log the selected file extension
Log("Selected file extension: " fileExtension)

; Step 2: Prompt for the application to associate with the file extension
appPath := FileSelect("", "", "Select the application to associate with " fileExtension, "*.exe")
if !appPath {
    MsgBox("No application selected. The association process was canceled.")
    ExitApp()
}

; Log the selected application
Log("Selected application: " appPath)

; Step 3: Modify the registry to change the file association

; Step 3.1: Create a unique ProgID based on the file extension
progId := SubStr(fileExtension, 2) "_auto_file" ; e.g., mqxliff_auto_file
Log("Generated ProgID: " progId)

; Step 3.2: Set the file association in the registry
try {
    ; Write the ProgID for the file extension
    Log("Attempting to write file extension association for " fileExtension)
    RegWrite(progId, "REG_SZ", "HKEY_CURRENT_USER\Software\Classes\" fileExtension, "")  ; Writing to the (Default) value
    Log("File extension association written successfully.")

    ; Write the command to open the application
    Log("Attempting to write open command for " progId)
    RegWrite('"' appPath '" "%1"', "REG_SZ", "HKEY_CURRENT_USER\Software\Classes\" progId "\shell\open\command", "")  ; Writing to the (Default) value
    Log("Open command written successfully.")

    ; Notify the user that the association has been changed successfully
    MsgBox("The file extension " fileExtension " has been successfully associated with " appPath ".")
} catch {
    ; Log failure
    Log("Failed to write registry for " fileExtension ". An error occurred.")
    MsgBox("Failed to change the file association for " fileExtension ". An error occurred.")
}

ExitApp()

; Function to log messages
Log(message) {
    FileAppend(A_Now " - " message "`n", logFilePath)
}
