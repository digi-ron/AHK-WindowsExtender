#InstallKeybdHook
#InstallMouseHook
#Persistent
#Singleinstance force
#UseHook On
#keyhistory 100

;for the display of the traytip on the system icon area, regardless of the name of the file executed
menu,tray,tip,digi-rons Hotkey Script

;for the windows media player hotkeys (mainly just so it ONLY activates on the WMP window)
SetTitleMatchMode, 3

;for the multiple states of Windows Media Player (for hotkeys specific to WMP)
GroupAdd WMPlayer, Windows Media Player
GroupAdd WMPlayer, ahk_class WMPTransition
GroupAdd WMPlayer, ahk_class WMP Skin Host
GroupAdd WMPlayer, ahk_class CWmpControlCntr
GroupAdd WMPlayer, FullScreenTopLayout


;collection of the user environment variable path for the current user
envget,UPath,USERPROFILE

;boundaries for control right click power menu (change first variable to change size of corner square)
bounds := 40
ylimit := A_ScreenHeight - bounds

;to change icon and add items to the tray menu icon and tray menu respecively
;letters used = e,h,p,r
;to get the index number for shell32, use Nirsoft IconsExtract (index is actual number from pulled resources, not number in bracket, e.g. icon below is labelled as 224 in Win10)
menu,tray,Icon,shell32.DLL, 116
menu,tray,add,Script &Help,HelpMe
menu,tray,add,&Elevate,Elevation
menu,tray,add,&Power Menu 2.0, pwrmenu
menu,tray,add,&Run Box 2.0, RunDialogue
;add option to edit script with Notepad++ if still a script
if A_IsCompiled != 1
{
menu, tray, add, Edit With &Notepad++, nedit
}

;for creation of power menu
;shortcut letters used= a,c,d,e,f,h,i,k,m,n,o,r,s,t,w
Menu,power,add,&Command Prompt,cmd
menu,power,add,Command Prompt (&Admin),cmd_admin
menu,power,add,Registry &Editor,regedit
menu,power,add,View &Services,services
Menu,power,add,C&hange Startup Items,autoruns
menu,power,add,&Device Manager,devmgmt
menu,power,add,&Notepad,notepad
menu,power,add,&Runbox 2.0,RunDialogue
menu,power,add
menu,power,add,Con&trol Panel,control
menu,power,add,System &Information,msinfo
menu,power,add,Networ&k Adapters,ncpa
menu,power,add,Po&wer Options,powercfg
menu,power,add,Programs And &Features,appwiz
menu,power,add,Internet &Options,inetcpl
menu,power,add,Performance &Monitor,perfmon




;reload key (if required)
#s::Reload

;media buttons (for keyboards without media buttons)
#Up::Volume_Up
#Down::Volume_Down
#Left::Media_Prev
#Right::Media_Next 
#space::Media_Play_Pause

;for the purposes of the alternate right click ` menu (currently set to bottom left 40px X 40px corner of screen)
~$^RButton::
coordmode,mouse,screen
mousegetpos,MX,MY
if MX < %bounds%
{
	if MY > %ylimit%
	{
	goto pwrmenu
	}
}
return


;to show improved task manager (if it exists)
!+Esc::
ifexist procexp.exe
run procexp.exe
else
run %A_Windir%\System32\taskmgr.exe
return

;for the purpose of a help messagebox for those who haven't used this hotkey script before
#F1:: goto HelpMe

;for new power menu (for explorer failure, customizability, and/or older versions of windows (<Win8)
^!x::goto pwrmenu

HelpMe:
msgbox,0,Digiron242 Help,
(
HELP:
=====
LEGEND ---> Ctrl = Control, Alt = Alternate, Esc = Escape, Win = Windows
**UNIVERSAL HOTKEYS**
Win + S = Reload this script
Win + F1 = Show This Help Box (can also be accessed from tray icon)
Ctrl + Alt + X OR Ctrl + Rmouse = Power Menu 2.0 (mouse hotkey = %bounds%X%bounds%px bottom left)
Alt + Shift + Esc = Process Explorer (if Process Explorer [procexp.exe] exists)
Win + Up Arrow = Volume Up
Win + Down Arrow = Volume Down
Ctrl + Shift + R = Runbox 2.0
Win + Space = Play/Pause
Win + Left Arrow = Previous Track
Win + Right Arrow = Next Track
====================================
**WINDOWS MEDIA PLAYER**
		Space = Play/Pause
		Up Arrow = Volume Up
		Down Arrow = Volume Down
		Left Arrow = Previous Track
		Right Arrow = Next Track
====================================
**ALTERNATE RUNBOX**
cmda = administrator command prompt
pd = ProgramData (%ProgramData%)
temp = Temporary folder selection (see below)
ltemp = Local Temporary folder (%tmp%)
wtemp = Windows Temporary folder (%windir%\Temp)
startup = windows startup folder (shell:startup)
home = script folder
tb = taskbar shortcuts location
)
return



;for a run dialogue box
^+r::goto RunDialogue

RunDialogue:
gui,destroy
coordmode,menu
gui,+AlwaysOnTop -MaximizeBox -MinimizeBox
GUI,add,text,,Welcome %A_Username%.`nType your command
gui,add,edit,limit vRunThis
gui,add,button,default gRunbox,&Run...
gui,add,button,gCancelRunBox xp+60,&Cancel
gui,show,autosize,Run...
return

RunBox:
gui,submit
if RunThis = cmda
{
goto cmd_admin
}
else
if RunThis = ps
{
run powershell_ise.exe
}
else
if RunThis = psa
{
goto ps_admin
}
else
if RunThis = pd
{
run %ProgramData%
}
else
if RunThis = ltemp
{
goto Ltemp
}
else
if RunThis = wtemp
{
goto wtemp
}
;for temp folder selection (windows temp folder or user temp folder)
else
if RunThis = temp
{
gui,destroy
gui,add,button,Default gLTemp,Local Temp
gui,add,button,gWTemp,Win. Temp
gui,show,autosize,Temp Select
}
else
if RunThis = startup
{
	;open the login startup folder
	run shell:startup
}
else
if RunThis = home
{
	;open the folder that this script is being run from
	run explorer.exe %A_ScriptDir%
}
else
if RunThis = tb
{
	run %UPath%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar
}
else
{
;attempt to run anything else input, but give a error message box if failed
run,%RunThis%,%UPath%,UseErrorLevel
	if errorlevel = ERROR
	msgbox,4096,Invalid Parameter - %RunThis%,The command you have entered is invalid. Try again
}
return

;taken from online forums for script self-elevation
Elevation:
if !A_IsAdmin
{
run *runas %A_ScriptFullPath%
ExitApp
}
else
{
msgbox,,Failed elevation, Execution Failed`nError Code = ALREADY_ELEV_||_REJECTED
}
return

CancelRunBox:
gui,destroy
return

;for temp selector
;for local temp (usually found @ UName\appdata\local\temp)
LTemp:
{
gui,submit
run %tmp%
}
return

;for windows temp (usually found @ windir\Temp)
WTemp:
{
gui,submit
run %A_Windir%\Temp
}
return

;for displaying the power menu on specific key combinations or right clicking on the bottom right corner of the host screen
pwrmenu:
coordmode,menu
menu,power,show,0,%A_ScreenHeight%
return

;section for the sub-commands associated with the "power" menu
cmd:
run,%A_Windir%\System32\cmd.exe, %UPath%
return

regedit:
run,%A_windir%\regedit.exe,,UseErrorLevel
if errorlevel 
{
goto failure
}
return

;show system configuration information
msinfo:
run,%A_windir%\System32\msinfo32.exe
return

cmd_admin:
run *runas cmd.exe, %A_Windir%\System32
return

ps_admin:
run *runas powershell_ise.exe
return

ncpa:
run,%A_Windir%\System32\ncpa.cpl,,UseErrorLevel
if errorlevel 
{
goto failure
}
return

powercfg:
run,%A_Windir%\System32\powercfg.cpl,,UseErrorLevel
if errorlevel 
{
goto failure
}
return

appwiz:
run,%A_Windir%\System32\appwiz.cpl,,UseErrorLevel
if errorlevel 
{
goto failure
}
return

services:
run,%A_Windir%\System32\services.msc,,UseErrorLevel
if errorlevel 
{
goto failure
}
return

perfmon:
run,%A_Windir%\System32\Perfmon.msc,,UseErrorLevel
if errorlevel 
{
goto failure
}
return

notepad:
run,%A_Windir%\notepad.exe,,UseErrorLevel
if errorlevel 
{
goto failure
}
return

inetcpl:
run,%A_Windir%\System32\inetcpl.cpl,,UseErrorLevel
if errorlevel 
{
goto failure
}
return

devmgmt:
run,%A_Windir%\System32\devmgmt.msc,,UseErrorLevel
if errorlevel 
{
goto failure
}
return

control:
run,%A_Windir%\System32\control.exe,,UseErrorLevel
if errorlevel 
{
goto failure
}
return

;for easy editing from script itself
nedit:
ifexist %A_ProgramFiles%\Notepad++\notepad++.exe
{
	run %A_ProgramFiles%\Notepad++\notepad++.exe %A_ScriptFullPath%
}
else
ifexist %A_ProgramFiles% (x86)\Notepad++\notepad++.exe
{
	run %A_ProgramFiles% (x86)\Notepad++\notepad++.exe %A_ScriptFullPath%
}
else
{
	run notepad.exe %A_ScriptFullPath%
}
return

autoruns:
ifexist autoruns.exe
run,autoruns.exe
else
run,%A_Windir%\System32\msconfig.exe
return

;error handler for any events that require administrator access
failure:
msgbox,,Failed run of power menu program, Execution Failed`nError Code = RESTRICTED-E17
return

;for hotkey allocation on ONLY windows media player (LEAVE AT BOTTOM OF SCRIPT AT ALL TIMES!!!!)
#IfWinActive ahk_group WMPlayer
Space::send {Media_Play_Pause}
Up::send {Volume_Up}
Down::send {Volume_Down}
Left::send {Media_Prev}
Right::send {Media_Next}
#IfWinActive