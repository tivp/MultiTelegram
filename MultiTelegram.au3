#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resources\icon.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=Open Telegram Desktop with different profiles
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_ProductVersion=2.0.0.0
#AutoIt3Wrapper_Res_CompanyName=© TiVP
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_File_Add=\Resources\01.bmp
#AutoIt3Wrapper_Res_File_Add=\Resources\02.bmp
#AutoIt3Wrapper_Res_File_Add=\Resources\03.bmp
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
#include <FileConstants.au3>
#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>

Local $sTelegram = @ScriptDir & "\Telegram\telegram.exe"
Local $sTeleData = @ScriptDir & "\Telegram\tdata"
Local $sTeleFile = @ScriptDir & "\Telegram\"
Local $sProfiles = @ScriptDir & "\profiles.ini"
Local $Profiles[99], $Picture[99]
_VerfFiles()
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("MultiTelegram", 608, 336, 249, -1)
$Group1 = GUICtrlCreateGroup("", 8, 0, 473, 289)

$ButtonLoad = GUICtrlCreateButton("Load Data", 8, 296, 113, 33)
GUICtrlSetCursor (-1, 0)
_GUICtrlSetImage(-1, @ScriptDir & "\Resources\01.ico", 0, 0)

$ButtonSave = GUICtrlCreateButton("Save Profile", 128, 296, 113, 33)
GUICtrlSetCursor (-1, 0)
_GUICtrlSetImage(-1, @ScriptDir & "\Resources\05.ico", 0, 0)

$ButtonRestore = GUICtrlCreateButton("Restore Last", 248, 296, 113, 33)
GUICtrlSetCursor (-1, 0)
_GUICtrlSetImage(-1, @ScriptDir & "\Resources\02.ico", 0, 0)

$ButtonDelete = GUICtrlCreateButton("Delete", 368, 296, 113, 33)
GUICtrlSetCursor (-1, 0)
_GUICtrlSetImage(-1, @ScriptDir & "\Resources\04.ico", 0, 0)

$ButtonStart = GUICtrlCreateButton("Start Telegram", 488, 8 , 113, 33)
GUICtrlSetCursor (-1, 0)
_GUICtrlSetImage(-1, @ScriptDir & "\Resources\07.ico", 0, 0)

$ButtonSession = GUICtrlCreateButton("New Session", 488, 48, 113, 33)
GUICtrlSetCursor (-1, 0)
_GUICtrlSetImage(-1, @ScriptDir & "\Resources\06.ico", 0, 0)

GUICtrlCreateGroup("", -99, -99, 1, 1)
$Pic1 =	GUICtrlCreatePic(@ScriptDir & "\Resources\03.bmp", 488, 88, 113, 241, BitOR($GUI_SS_DEFAULT_PIC,$WS_BORDER))
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;Inicio Nucleo
$k = 1
For $i = 1 to 4
	For $j = 1 to 8
		$Profiles[$k]  = GUICtrlCreateRadio("Profiles " & StringFormat("%02d", $k), 22+120*($i - 1), 16+35*($j - 1), 67, 17)
		GUICtrlSetCursor (-1, 0)
		$Picture[$k] = GUICtrlCreatePic(@ScriptDir & "\Resources\02.bmp", 99+120*($i - 1), 23+35*($j - 1), 4, 4)
		GUICtrlSetCursor (-1, 14)
		$k += 1
	Next
Next
_IniRead()
;/Inicio Nucleo

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $ButtonStart
			_SelectStart()
		Case $ButtonSession
			_SelectSession()
		Case $ButtonSave
			For $i = 1 to 32
				$Select = GUICtrlRead($Profiles[$i])
				If $Select = 1 Then
					_SelectSave($i)
				EndIf
			Next
		Case $ButtonLoad
			For $i = 1 to 32
				$Select = GUICtrlRead($Profiles[$i])
				If $Select = 1 Then
					_SelectLoad($i)
				EndIf
			Next
		Case $ButtonRestore
				_SelectRestore()
		Case $ButtonDelete
			For $i = 1 to 32
				$Select = GUICtrlRead($Profiles[$i])
				If $Select = 1 Then
					_SelectDelete($i)
				EndIf
			Next
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

Func _SelectRestore()
	If ProcessExists("telegram.exe") Then
		GUISetState(@SW_LOCK, $Form1)
		$mBox = MsgBox($MB_YESNO+$MB_ICONQUESTION+$MB_TOPMOST, "","Para restaurar es necesario reiniciar..." & @CR & @CR & "¿Desea reiniciarlo?")
		If $mBox = 6 Then
			ProcessClose("telegram.exe")
			Sleep(5)
			DirCopy($sTeleFile & "temp", $sTeleData, $FC_OVERWRITE)
			ShellExecute($sTelegram)
		EndIf
		GUISetState(@SW_UNLOCK, $Form1)
		GUISetState(@SW_RESTORE, $Form1)
	Else
		DirCopy($sTeleFile & "temp", $sTeleData, $FC_OVERWRITE)
		MsgBox($MB_OK+$MB_TOPMOST, "","Se ha restaurado correctamente")
	EndIf
EndFunc

Func _SelectStart()
	If ProcessExists("telegram.exe") Then
		GUISetState(@SW_LOCK, $Form1)
		$mBox = MsgBox($MB_YESNO+$MB_ICONQUESTION+$MB_TOPMOST, "","Telegram ya se esta ejecutando..." & @CR & @CR & "¿Desea reiniciarlo?")
		If $mBox = 6 Then
			ProcessClose("telegram.exe")
			Sleep(5)
			ShellExecute($sTelegram)
		EndIf
		GUISetState(@SW_UNLOCK, $Form1)
		GUISetState(@SW_RESTORE, $Form1)
	Else
		ShellExecute($sTelegram)
	EndIf
EndFunc

Func _IniRead()
	For $i = 1 to 32
		$iP = StringFormat("%02d", $i)
		If FileExists($sTeleFile & $iP) Then
			IniWrite("profiles.ini", "values", $iP, "true")
		Else
			IniWrite("profiles.ini", "values", $iP, "false")
		EndIf
		$IniResult = IniRead("profiles.ini", "values", $iP, "")
		If $IniResult = "true" Then
			GUICtrlSetImage($Picture[$i], @ScriptDir & "\Resources\01.bmp")
		Else
			GUICtrlSetImage($Picture[$i], @ScriptDir & "\Resources\02.bmp")
		EndIf
	Next
EndFunc

Func _SelectSession()
	GUISetState(@SW_LOCK, $Form1)
	$mBox = MsgBox($MB_YESNO+$MB_ICONQUESTION+$MB_TOPMOST, "","Para crear una nueva sesión se tiene que borrar" & @CR & "la sesión actual" & @CR & @CR & "¿Seguro que desea continuar?")
	If $mBox = 6 Then
		If ProcessExists("telegram.exe") Then
			ProcessClose("telegram.exe")
			Sleep(10)
			DirCopy($sTeleData, $sTeleFile & "temp", $FC_OVERWRITE)
			DirRemove($sTeleData, $DIR_REMOVE)
			ShellExecute($sTelegram)
		Else
			DirCopy($sTeleData, $sTeleFile & "temp", $FC_OVERWRITE)
			DirRemove($sTeleData, $DIR_REMOVE)
			ShellExecute($sTelegram)
		EndIf
	EndIf
	GUISetState(@SW_UNLOCK, $Form1)
	GUISetState(@SW_RESTORE, $Form1)
EndFunc

Func _SelectSave($number)
	$iP = StringFormat("%02d", $number)
	If FileExists($sTeleData) Then
		If FileExists($sTeleFile & $iP) Then
			GUISetState(@SW_LOCK, $Form1)
			$mBox = MsgBox($MB_YESNO+$MB_ICONQUESTION+$MB_TOPMOST, "", "Este bloque ya esta utilizado" & @CR & @CR & "¿Desea Sobrescribirlo?")
			If $mBox = 6 Then
				If ProcessExists("telegram.exe") Then
					ProcessClose("telegram.exe")
					DirRemove($sTeleFile & $iP, $DIR_REMOVE)
					DirCopy($sTeleData, $sTeleFile & "temp", $FC_OVERWRITE)
					DirCopy($sTeleData, $sTeleFile & $iP, $FC_OVERWRITE)
					IniWrite("profiles.ini", "values", $iP, "true")
					ShellExecute($sTelegram)
				Else
					DirRemove($sTeleFile & $iP, $DIR_REMOVE)
					;DirCopy($sTeleData, $sTeleFile & "temp", $FC_OVERWRITE)
					DirCopy($sTeleData, $sTeleFile & $iP, $FC_OVERWRITE)
					IniWrite("profiles.ini", "values", $iP, "true")
				EndIf
			EndIf
			GUISetState(@SW_UNLOCK, $Form1)
			GUISetState(@SW_RESTORE, $Form1)
		Else
			If ProcessExists("telegram.exe") Then
				ProcessClose("telegram.exe")
				DirCopy($sTeleData, $sTeleFile & $iP, $FC_OVERWRITE)
				IniWrite("profiles.ini", "values", $iP, "true")
				ShellExecute($sTelegram)
			Else
				DirCopy($sTeleData, $sTeleFile & $iP, $FC_OVERWRITE)
				IniWrite("profiles.ini", "values", $iP, "true")
			EndIf
		EndIf
	Else
		GUISetState(@SW_LOCK, $Form1)
		$mBox = MsgBox($MB_YESNO+$MB_ICONQUESTION+$MB_TOPMOST, "","No se a encontrado la carpeta tdata (゜o゜ )" & @CR & @CR & "¿Desea abrir Telegram para generarla?")
		If $mBox = 6 Then
			ShellExecute($sTelegram)
			MsgBox($MB_OK+$MB_TOPMOST, "", "Ahora puedes guardar tus cuentas ヽ(^o^)丿")
		EndIf
		GUISetState(@SW_UNLOCK, $Form1)
		GUISetState(@SW_RESTORE, $Form1)
	EndIf
	_IniRead()
EndFunc

Func _SelectLoad($number)
	$iP = StringFormat("%02d", $number)
	$sRead = IniRead("profiles.ini", "values", $iP, "")
	If $sRead = "true" then
		If ProcessExists("telegram.exe") Then
			GUISetState(@SW_LOCK, $Form1)
			$mBox = MsgBox($MB_YESNO+$MB_ICONQUESTION+$MB_TOPMOST, "","Telegram ya se esta ejecutando..." & @CR & @CR & "¿Desea reiniciarlo para aplicar los cambios?")
			If $mBox = 6 Then
				ProcessClose("telegram.exe")
				Sleep(5)
				Beep(500, 90)
				DirCopy($sTeleData, $sTeleFile & "temp", $FC_OVERWRITE)
				DirRemove($sTeleData, $DIR_REMOVE)
				DirCopy($sTeleFile & $iP, $sTeleData)
				ShellExecute($sTelegram)
			EndIf
			GUISetState(@SW_UNLOCK, $Form1)
			GUISetState(@SW_RESTORE, $Form1)
		Else
			Beep(500, 90)
			DirCopy($sTeleData, $sTeleFile & "temp", $FC_OVERWRITE)
			DirRemove($sTeleData, $DIR_REMOVE)
			DirCopy($sTeleFile & $iP, $sTeleData)
		EndIf
	Else
		MsgBox($MB_OK+$MB_ICONQUESTION+$MB_TOPMOST, "","Selecciona un bloque que este guardado...")
	EndIf
	_IniRead()
EndFunc

Func _SelectDelete($number)
	GUISetState(@SW_LOCK, $Form1)
	$iP = StringFormat("%02d", $number)
	$mBox = MsgBox($MB_YESNO+$MB_ICONWARNING+$MB_TOPMOST, "","¿Estas seguro de querer borrar este bloque?")
	If $mBox = 6 Then
		Sleep(10)
		DirRemove($sTeleFile & $iP, $DIR_REMOVE)
	EndIf
	GUISetState(@SW_UNLOCK, $Form1)
	GUISetState(@SW_RESTORE, $Form1)
	_IniRead()
EndFunc

Func _VerfFiles()
    $iFileExists = FileExists($sTelegram)
    If Not $iFileExists Then
        MsgBox($MB_OK+$MB_ICONERROR, "", "Telegram no se encuentra ʕ•ᴥ•ʔ")
		Exit
    EndIf
EndFunc

Func _GUICtrlSetImage($hButton, $sFileIco, $iIndIco = 0, $iSize = 0)
    Switch $iSize
        Case 0
            $iSize = 16
        Case 1
            $iSize = 32
        Case Else
            $iSize = 16
    EndSwitch
    Local $hImage = _GUIImageList_Create($iSize, $iSize, 5, 3, 6)
    _GUIImageList_AddIcon($hImage, $sFileIco, $iIndIco)
    _GUICtrlButton_SetImageList($hButton, $hImage, 0, 9)
    Return $hImage
EndFunc   ;==>_GUICtrlSetImage