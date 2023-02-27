# AHK-WindowsExtender
AutoHotKey script with the following functionality. Originally made to extend functionality of Windows 7 and to partially replace reliance on explorer.exe for common troubleshooting (if compiled to exe). Functionality still works on Windows 10 and allows for customizing of the features to the technicians needs.

Also a reasonable example of the more extreme end of what a power user can do with automation tools such as AutoHotKey

## Features

| Feature | Notes |
|---|---|
| Power Menu | activated by Ctrl+Alt+X or Ctrl+RMouse (in the bottom-left 40x40px of the main monitor) |
| Process Explorer Shortcut | Requires [Process Explorer](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer), activated by Alt+Shift+Esc (runs windows task manager if procexp.exe is not present in script directory) |
| Custom media buttons | minor feature, allows for Win+Arrows for volume (up/down) and next/previous (left/right) functionality. Also allows for using keys without modifiers to control Windows Media Player (for the 5 people left who use it) |
| Runbox 2.0 | replacement for the "Run..." functionality in Windows, with handy commands (below) | 
| Autoruns support | Accessible through Power Menu, will run msconfig.exe by default or [Autoruns](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns) if the autoruns.exe file is present in the same directory as the script |

### RunBox commands
\* = requires Windows Explorer to be running and functional on host machine
| Command | Notes |
| --- | --- |
| cmda | administrator command prompt |
| pd | open explorer to C:\ProgramData* |
| temp | simple GUI selector between ltemp command and wtemp command (see below) |
| ltemp | opens local temp folder at %USERPROFILE%\AppData\Local\Temp* | 
| wtemp | opens Windows temp folder at C:\Windows\Temp* |
| startup | opens startup folder for current user*. Same as running shell:startup |
| home | opens folder that the script (compiled or not) is stored*
| tb | opens the folder with the taskbar shortcuts for the current user

## Prerequisites
- Windows 7+ machine
- AutoHotKey v1.1.33.10+ (if running as a script)

## Usage
- run the script either via the AHK file or as a compiled EXE, and press Windows+F1 for a basic outline of functionality

*NOTE: this script is a little dated, but has served me well in the years I have used it, just for replacement functionality such as process explorer and autoruns support at least. No plans to update this past v1 as this is actually a small part of a much larger script I run regularly which hasn't changed significantly since 2015*