Unicode true

; Define your application name
!define APPNAME "obs-virtualcam"
!ifndef APPVERSION
!define APPVERSION ${VERSION}
!define SHORTVERSION ${VERSION}
!endif
!define APPNAMEANDVERSION "OBS Virtualcam ${SHORTVERSION}"

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES64\obs-studio"
InstallDirRegKey HKLM "Software\OBS Studio" ""
OutFile "..\build-package\obs-virtualcam-${SHORTVERSION}-Windows-installer.exe"

; Use compression
SetCompressor LZMA

; Modern interface settings
!include "MUI.nsh"
!include nsDialogs.nsh

; Include library for dll stuff
!include Library.nsh


!define MUI_ICON "obs.ico"
;!define MUI_HEADERIMAGE
;!define MUI_HEADERIMAGE_BITMAP ""
;!define MUI_HEADERIMAGE_RIGHT
!define MUI_ABORTWARNING

!define MUI_PAGE_HEADER_TEXT "License Information"
!define MUI_PAGE_HEADER_SUBTEXT "Please review the license terms before installing OBS Virtualcam."
!define MUI_LICENSEPAGE_TEXT_TOP "Press Page Down or scroll to see the rest of the license."
!define MUI_LICENSEPAGE_TEXT_BOTTOM " "
!define MUI_LICENSEPAGE_BUTTON "&Next >"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "..\LICENSE"
!insertmacro MUI_PAGE_DIRECTORY
Page custom VirtualDeviceSelection VirtualDeviceSelectionPageLeave
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH



!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Set languages (first is default language)
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_RESERVEFILE_LANGDLL

Var Dialog
Var Label
Var VirtualDeviceNum
var Devices

Function VirtualDeviceSelection

	!insertmacro MUI_HEADER_TEXT "Device Selection" "Virtual devices to install"

	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		Abort
	${EndIf}

	${NSD_CreateLabel} 0 0 100% 12u "Select the number of virtual cameras to register. Typically, you will not need more than one."
	Pop $Label

	${NSD_CreateDropList} 15u 23u 40u 80u ""
		Pop $VirtualDeviceNum
  
		${NSD_CB_AddString} $VirtualDeviceNum "1"
		${NSD_CB_AddString} $VirtualDeviceNum "2"
		${NSD_CB_AddString} $VirtualDeviceNum "3"
		${NSD_CB_AddString} $VirtualDeviceNum "4"
		${NSD_CB_SelectString} $VirtualDeviceNum "1"

	nsDialogs::Show
	
FunctionEnd

Function VirtualDeviceSelectionPageLeave

        ${NSD_GetText} $VirtualDeviceNum $Devices
		
FunctionEnd

Section "obs-virtualcam" Section1

	; Set Section properties
	SetOverwrite on
	; Set Section Files and Shortcuts
	SetOutPath "$INSTDIR\data\obs-plugins\obs-virtualoutput\"
	File "..\build-package\bin\32bit\obs-virtualsource.dll"
	File "..\build-package\bin\32bit\obs-virtualsource.pdb"
	File "..\build-package\bin\32bit\avutil-56.dll"
	File "..\build-package\bin\32bit\swscale-5.dll"
	SetOutPath "$INSTDIR\data\obs-plugins\obs-virtualoutput\locale\"
	File /r "..\build-package\data\obs-plugins\obs-virtualoutput\locale\"
	SetOutPath "$INSTDIR\obs-plugins\64bit\"
	File "..\build-package\obs-plugins\64bit\obs-virtualoutput.dll"
	File "..\build-package\obs-plugins\64bit\obs-virtualoutput.pdb"
	SetOutPath "$INSTDIR\bin\64bit\"
	File "..\build-package\bin\64bit\obs-virtualsource.dll"
	File "..\build-package\bin\64bit\obs-virtualsource.pdb"
	
SectionEnd

Section -FinishSection

	WriteRegStr HKLM "Software\${APPNAME}" "" "$INSTDIR"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$INSTDIR\uninstall_obs-virtualcam.exe"
	WriteUninstaller "$INSTDIR\uninstall_obs-virtualcam.exe"
	Exec '$WinDir\Sysnative\regsvr32.exe /s /n /i:$Devices $\"$INSTDIR\data\obs-plugins\obs-virtualoutput\obs-virtualsource.dll$\"'
	Exec '$SYSDIR\regsvr32.exe /s /n /i:$Devices $\"$INSTDIR\bin\64bit\obs-virtualsource.dll$\"'
	
SectionEnd

;Uninstall section
Section Uninstall

	;Remove from registry...
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
	DeleteRegKey HKLM "SOFTWARE\${APPNAME}"

	; Delete self
	Delete "$INSTDIR\uninstall_obs-virtualcam.exe"

	; Unregister DLLs
	!insertmacro UnInstallLib REGDLL NOTSHARED NOREBOOT_PROTECTED "$INSTDIR\data\obs-plugins\obs-virtualoutput\obs-virtualsource.dll"
	!define LIBRARY_X64
	!insertmacro UnInstallLib REGDLL NOTSHARED NOREBOOT_PROTECTED "$INSTDIR\bin\64bit\obs-virtualsource.dll"

	; Clean up obs-virtualcam
	Delete "$INSTDIR\obs-plugins\64bit\obs-virtualoutput.dll"
	Delete "$INSTDIR\obs-plugins\64bit\obs-virtualoutput.pdb"
	Delete "$INSTDIR\bin\64bit\obs-virtualsource.dll"
	Delete "$INSTDIR\bin\64bit\obs-virtualsource.pdb"

	; Remove data directory
	RMDir /r "$INSTDIR\data\obs-plugins\obs-virtualoutput\"

SectionEnd

; eof