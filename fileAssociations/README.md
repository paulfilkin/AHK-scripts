# File Association and Extension Grouping Scripts

This repository contains two **AutoHotkey v2.0** scripts designed for managing and inspecting file associations on Windows:

1. **File Association Script**: Associates a given file extension with a user-selected application by modifying the Windows registry.
2. **File Extension Grouping Script**: Scans the registry for file extensions associated with specific applications and groups them by application.

## Prerequisites

- **AutoHotkey v2.0**: Ensure that [AutoHotkey v2.0](https://www.autohotkey.com/) is installed on your system.
- **Administrator Rights**: The File Association Script requires administrator privileges to modify the Windows registry.

## Scripts Overview

### 1. File Association Script

This script allows you to associate a specific file extension (e.g., `.mqxliff`) with a chosen application by modifying the Windows registry.

#### Features:
- Prompts the user to input a file extension (e.g., `.mqxliff`).
- Allows the user to select an application to associate with the file extension.
- Modifies the registry to set the chosen application as the default for the given file extension.
- Automatically restarts with admin privileges if not already running as an administrator.
- Logs all actions in `assoc_debug_log.txt` located in the script’s directory.

#### How It Works:
1. **Admin Check**: The script checks if it has admin rights, and if not, relaunches itself with elevated privileges.
2. **User Prompts**: The user is prompted to enter a file extension and then select the application to associate with that extension.
3. **Registry Modification**: The script modifies the registry under `HKEY_CURRENT_USER\Software\Classes` to set the chosen application as the default for the specified file extension.
4. **Logging**: Logs are written to `assoc_debug_log.txt`.

#### Usage:
1. **Run the Script**: Double-click the script or execute it from a terminal.
2. **Follow the Prompts**:
   - Enter the file extension (e.g., `.mqxliff`).
   - Select the application to associate with that extension.
3. **Check the Log**: The log file (`assoc_debug_log.txt`) will track any actions or errors.

#### Example Output:
```
20240906021825 - Script started
20240906021831 - Selected file extension: .mqxliff
20240906021835 - Selected application: C:\Program Files (x86)\Trados\Trados Studio\Studio18\SDLTradosStudio.exe
20240906021835 - Generated ProgID: mqxliff_auto_file
20240906021835 - Attempting to write file extension association for .mqxliff
20240906021835 - File extension association written successfully.
20240906021835 - Open command written successfully.
```

---

### 2. File Extension Grouping Script

This script scans the Windows registry to find file extensions associated with specific applications and groups them into a formatted table. The results are shown in a message box and copied to the clipboard.

#### Features:
- Scans `HKEY_CLASSES_ROOT` to find file extensions associated with specific applications.
- Groups file extensions into lists by application.
- Outputs the grouped file extensions in a formatted table.
- Copies the table to the clipboard for easy reference.

#### How It Works:
1. **Registry Scanning**: The script loops through `HKEY_CLASSES_ROOT`, checking file extensions and their associated applications.
2. **Application Matching**: For each file extension, it checks if the associated application matches one of the predefined applications (`SDLTradosStudio.exe`, `MemoQ.exe`, `MultiTerm.exe`).
3. **Grouping and Output**: File extensions are grouped by application and displayed in a message box. The formatted result is also copied to the clipboard.

#### Usage:
1. **Run the Script**: Double-click the script or execute it from a terminal.
2. **View Results**: The grouped file extensions will be displayed in a message box and copied to your clipboard for further use.

#### Example Output:
```
File Extensions Grouped by Application:

SDL Trados Studio:
.wsxz
.stppk
.sdlxliff
.sdltm
.sdlrpx
.sdlretrofit
.sdlproj
.sdlppx
.sdlalign

MultiTerm:
.sdltb
.sdlmttpl

MemoQ:
.mqxlz
.mqxliff
.mqout
.mqdf
.mqback
.mqarch
.MPRX
```

---

## Customisation

### Modify the Applications List:
In the **File Extension Grouping Script**, you can customise the list of applications being scanned by modifying the `appList` array in the script:

```ahk
appList := ["SDLTradosStudio.exe", "MemoQ.exe", "MultiTerm.exe"]
```

You can add or remove applications from this list as needed.

## Troubleshooting

If either script fails to modify the registry or does not produce the expected results:
- Ensure you are running the script with administrator privileges if required (especially for the File Association Script).
- Review the log files (`assoc_debug_log.txt` and other logs) for more details.
- Verify that the applications and file extensions exist on your system.
