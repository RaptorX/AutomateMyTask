#Requires Autohotkey v1.1.33+
{ ; global variables
	global WM_MOUSEMOVE     := 0x0200
	global WM_LBUTTONDOWN   := 0x0201
	global WM_LBUTTONUP     := 0x0202
	global WM_LBUTTONDBLCLK := 0x0203
	global WM_RBUTTONDOWN   := 0x0204
	global WM_RBUTTONUP     := 0x0205
	global WM_RBUTTONDBLCLK := 0x0206
	global WM_MBUTTONDOWN   := 0x0207
	global WM_MBUTTONUP     := 0x0208
	global WM_MBUTTONDBLCLK := 0x0209
	global WM_MOUSEWHEEL    := 0x020A
	global WM_MOUSEHWHEEL   := 0x020E
}
captured := {}

Gui, Main:New,, % "Automate My Task"

Gui, add, text, section, % "Name:"
Gui, add, edit, HWNDhName vvName xm w155
Gui, add, dropdownlist, HWNDhDDL vvDDL xm w155, % "Mouse||Set Text|Wait for Window"
Gui, add, button, HWNDhCapture vvCapture x+m w75, % "Capture"

Gui, add, groupbox, xm w240 h90, % "Location info"
Gui, add, text, xm+10 yp+25 w50 right, % "Current X:"
Gui, add, edit, HWNDhCurrX vvCurrX x+5 yp-3 w50 center disabled, 0
Gui, add, text, x+10 yp+3 w50 right, % "Current Y:"
Gui, add, edit, HWNDhCurrY vvCurrY x+5 yp-3 w50 center disabled, 0
Gui, add, text, xm+10 y+15 w50 right, % "Offset X:"
Gui, add, edit, HWNDhOffX vvOffX x+5 yp-3 w50 center, 0
Gui, add, updown
Gui, add, text, x+10 yp+3 w50 right, % "Offset Y:"
Gui, add, edit, HWNDhOffY vvOffY x+5 yp-3 w50 center, 0
Gui, add, updown

Gui, add, groupbox, xm y+20 w240 h180, % "Window info"
Gui, add, dropdownlist, HWNDhTitleType vvTitleType xm+10 yp+25 w140, % "Full Title||Before Delimiter|After Delimiter"
Gui, add, text, x+m yp+3, % "Delimiter:"
Gui, add, edit, HWNDhDelimiter vvDelimiter x+5 yp-3 w20 center, % "-"
Gui, add, text, xm+10 y+15, % "Window Title:"
Gui, add, checkbox, HWNDhWTStatus vvWTStatus xm+10 y+15 checked
Gui, add, edit, HWNDhTitle vvTitle x+5 yp-3 w185
Gui, add, text, xm+10 y+15, % "Window Class:"
Gui, add, checkbox, HWNDhWCStatus vvWCStatus xm+10 y+15 checked
Gui, add, edit, HWNDhClass vvClass x+5 yp-3 w185

Gui, add, activex, x+30 ym w165 h165 vwb section +0x800000, mshtml
Gui, add, button, HWNDhReCapture vvReCapture x+m ym w110, % "Re-Capture Pixels"
Gui, add, button, HWNDhDisplay vvDisplay xp y+m w110, % "Display Matches"
Gui, add, button, HWNDhTestCapture vvTestCapture xp y+m w110, % "Test"
Gui, add, text, xp y+43, % "Match Selection:"
Gui, add, edit, HWNDhMatchSel vvMatchSel xp y+m w110, 1
Gui, add, updown

Gui, add, groupbox, xs y+m w285 h180, % "Exporting options"
Gui, add, text, xs+15 yp+25, % "Function Name:"
Gui, add, edit, HWNDhFuncName vvFuncName xs+15 y+m w140
Gui, add, checkbox, HWNDhNotify vvNotify xs+15 y+m checked, % "Notify on Error"
Gui, add, checkbox, HWNDhExportFunctionOnly vvExportFunctionOnly xs+15 y+m checked, % "Export only function call"
Gui, add, checkbox, HWNDhNewlines vvNewlines xs+15 y+m checked, % "Add new lines (``n) to export"
Gui, add, text, xs+15 y+m, % "Wait for pixels to be found (0 for infinite):"
Gui, add, edit, HWNDhWait vvWait x+5 yp-3, 2
Gui, add, button, HWNDhExport vvExport xs+15 y+m w75, Export

Gui, Main:Show
return

MainButtonCapture(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="")
{
	global capturing, captured
	GuiControlGet, vDDL
	switch (vDDL)
	{
	case "Mouse":
		capturing := true
		Clipboard := captured := ""
		; ; thread priority, 2
		; ; critical, on
		; while (capturing)
		; {
		; 	MouseGetPos, mX, mY
		; 	if !InStr(captured, command := "MouseMove, " mX ", " mY "`n")
		; 		captured .= command
		; 	sleep -1
		; }
		; ; critical, off
	}
}

MainButtonTest(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="")
{
	tmpFile := A_Temp "\test.ahk"
	FileAppend, % Clipboard, % A_Temp "\test.ahk"
	RunWait, % tmpFile
	FileDelete, % tmpFile
}

~LButton Up::
~RButton Up::
~MButton Up::
; thread priority, 1
if !capturing
	return

MouseGetPos, mX, mY, mWindow, mControl
WinGetTitle, mWindow, ahk_id %mWindow%

outputdebug % mx "," my " " mWindow " " mControl
if !InStr(captured, mWindow)
	captured .= "WinActivate," A_Space mWindow "`nWinWait" A_Space mWindow "`n"

captured .= "Click " mX " " mY " " SubStr(A_ThisHotkey, 2, 1) "`n"
return

f12::
capturing := false
Clipboard .= "SetBatchLines 25`n" captured "SetBatchLines 0"
captured := ""
MsgBox, Recorded steps and saved to clipboard
return

