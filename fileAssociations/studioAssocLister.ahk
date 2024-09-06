#Requires AutoHotkey v2.0

appList := ["SDLTradosStudio.exe", "MemoQ.exe", "MultiTerm.exe"] ; List of applications to search for
appGroups := Map() ; Initialize as an empty object (Map)

; Define application groups with valid property names
appGroups["SDLTradosStudio.exe"] := []
appGroups["MemoQ.exe"] := []
appGroups["MultiTerm.exe"] := []

DebugLog := [] ; Array to store successful debug information

; Loop through all file extensions (keys starting with a dot) in HKEY_CLASSES_ROOT
Loop Reg, "HKEY_CLASSES_ROOT", "K" ; Include subkeys
{
    keyName := A_LoopRegName
    ; Only consider extensions (keys that start with a dot)
    if (SubStr(keyName, 1, 1) = ".") {
        try {
            associatedClass := RegRead("HKEY_CLASSES_ROOT\" keyName) ; Get the file class associated with the extension

            ; Now look for the 'shell\open\command' under the associated class to find if the class uses an app from appList
            commandKey := "HKEY_CLASSES_ROOT\" associatedClass "\shell\open\command"
            try {
                commandValue := RegRead(commandKey)

                ; Check if the command contains any application in the appList
                for _, app in appList {
                    if InStr(commandValue, app) {
                        ; Log the extension and app match
                        DebugLog.Push("MATCH: " keyName " -> " app)
                        appGroups[app].Push(keyName) ; Add to the corresponding application group
                        break ; No need to check further apps once we find a match
                    }
                }
            } catch {
                ; Suppress error logs for missing commands
            }
        } catch {
            ; Suppress error logs for missing classes
        }
    }
}

; Create the formatted table
formattedTable := "File Extensions Grouped by Application:`n`n"

; Group SDL Trados Studio extensions first
formattedTable .= "SDL Trados Studio:`n" . JoinArray(appGroups["SDLTradosStudio.exe"], "`n") . "`n`n"

; Group MultiTerm extensions second
formattedTable .= "MultiTerm:`n" . JoinArray(appGroups["MultiTerm.exe"], "`n") . "`n`n"

; Group MemoQ extensions last
formattedTable .= "MemoQ:`n" . JoinArray(appGroups["MemoQ.exe"], "`n") . "`n`n"

; Output the formatted table and copy to clipboard
MsgBox(formattedTable)
A_Clipboard := formattedTable

; Custom function to join array elements into a string with a separator
JoinArray(arr, sep := "") {
    result := ""
    for index, element in arr {
        if index > 1
            result .= sep
        result .= element
    }
    return result
}

