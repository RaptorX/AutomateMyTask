;******************************************************************************
; Want a clear path for learning AutoHotkey?                                  *
; Take a look at our AutoHotkey courses.                                *
; They're structured in a way to make learning AHK EASY                       *
; Discover how easy AutoHotkey is here: https://the-Automator.com/Discover  *
;******************************************************************************

#SingleInstance,Force
#Include <ScriptObj\scriptobj>
DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr") ; Per-Monitor DPI aware
if !InStr(A_OSVersion, "10.")
	appdata := A_ScriptDir
else
	appdata := A_AppData "\" regexreplace(A_ScriptName, "\.\w+"), isWin10 := true

global script := {base         : script
                 ,name         : regexreplace(A_ScriptName, "\.\w+")
                 ,version      : "0.6.2"
                 ,author       : "Joe Glines"
                 ,email        : "joe@the-automator.com"
                 ,homepagetext : "https://www.the-automator.com/AmT"
                 ,homepagelink : "https://www.the-automator.com/AmT?src=AmT"
                 ,donateLink   : "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6"
                 ,resfolder    : appdata "\res"
                 ,iconfile     : appdata "\res\main.ico"
                 ,configfolder : appdata
                 ,config       : appdata "\settings.ini"}

if !fileExist(script.resfolder)
{
	FileCreateDir, % script.resfolder
	FileInstall, res\main.ico, % script.iconfile
}

;@Ahk2Exe-SetMainIcon res\main.ico
Menu, Tray, NoStandard
Menu, Tray, Icon, % script.iconfile
Menu, Tray, Add
Menu, Tray, Add, Check for Updates, Update
Menu, Tray, Add, About, AboutGUI

If(SubStr(A_AhkVersion,1,3)<1.1)
{
	MsgBox Please upgrade to the most recent version of AutoHotkey.`n`nYou're running version: %A_AhkVersion%
	return
}

global GuiFontSize:= A_ScreenHeight>2159?5:A_ScreenHeight>1199?8:10 ;Adjusting font sizes for resolution of monitors

/*
	having the function in a local variable fixes the issue on compiled versions
	the previous method relied on reading the file on a_linefile to memory
	and then performing some regexmatches.

	when reading a compiled script regex would fail as the variable would
	contain binary information
*/
Info =
(%
;~ Do Not Change From Here
Perform_Action(Actions*){
	static Ptr:=A_PtrSize?"UPtr":"UInt",PtrP:=Ptr "*",MyFunc
	static x32:="5589E557565383EC348B7D388B47048945CC8B47088945C88B470C8945EC8B47108945E48B45EC8945D43B45E47D068B45E48945D431C03B453C0F8D910000008B1C878B4C8704C745D000000000C745D800000000895DF08B5C8708894DE08B4DF0895DC4894DE8894DDC8B75C43975D87D568B75DC03752C31C98975C03B4DE07D2F8B75D08B5DC001CE803C0B3175118B55F08B5D3089349389D343895DF0EB0D8B55E88B5D34893493428955E841EBCC8B4DE085C9790231C98B5D20014DDCFF45D8015DD0EBA283C007E966FFFFFF8B45088B5D2040C1E0078945E085DB790231DB8D049D00000000C745E80000000031FF8945DCC745F0000000008B45E83B45247D4A8B45288B55F031C903551401F88945D83B4D207D280FB642026BF0260FB642016BC04B01F00FB6326BF60F01F03B45E08B45D80F9204084183C204EBD38B4DDC01DF014DF0FF45E8EBAE8B45202B45CCC745DC000000008945D88B55188B452403550CC745F0000000002B45C88955CC8945D08B451C034510C1E0108945E031C08B4DD0394DF00F8F9200000031C93B4DD87F748B7DDC8D14398955E831D28B75E80375283B55D47D273B55EC7D0D8B5D308B3C9301F7803F0175493B55E47D0D8B5D348B3C9301F7803F00753742EBD48B7DCC8D50018D340F8B7D400B75E08934873B55447D358B5DE831C0035D283B45EC7D0E8B7D308B34874001DEC60600EBED89D041EB878B4D20FF45F08145E000000100014DDCE964FFFFFF89D083C4345B5E5F5DC2400090"
	static x64:="4157415641554154555756534883EC28488B8424D00000008B5804895424788B780C894C2470895C24108B5808897C2408895C24148B581039DF89DF895C240C0F4D7C240831D2897C2418399424D80000000F8E8E000000448B14904531E431DB8B7C90088B6C90044489D6897C241C4489D73B5C241C7D644C63EE4C03AC24B80000004531DB4439DD7E3643807C1D0031478D341C7514488B8C24C00000004D63FA41FFC2468934B9EB11488B8C24C80000004C63FFFFC7468934B949FFC3EBC585ED41BB00000000440F49DDFFC34403A424A00000004401DEEB964883C207E965FFFFFF8B44247041BB000000008D4801C1E10783BC24A000000000440F499C24A000000031ED31F631FF468D2C9D000000003BAC24A80000007D554863DE48039C24B00000004863C74531D24C01C844399424A00000007E2D0FB65002446BE2260FB650016BD24B4401E2440FB620456BE40F4401E239CA420F92041349FFC24883C004EBC94401EF4401DEFFC5EBA244038424980000004531DB31C04531D28BBC24A00000008BAC24A80000008B9424900000002B7C241041C1E0102B6C2414035424784139EA0F8FDB0000004531C94139F90F8FB6000000438D1C1931C9394C24184189CC7E52394C24087E204C8BB424C00000004C8BBC24B0000000418B348E01DE4863F641803C37017579443964240C7E204C8BB424C80000004C8BBC24B0000000418B348E01DE4863F641803C3700755248FFC1EBA5428D340A4C8BB424E00000008D48014409C63B8C24E8000000418934867D4D31C0394424087E234C8BBC24C00000004C8BB424B0000000418B348748FFC001DE4863F641C6043600EBD74863C141FFC1E941FFFFFF41FFC24181C00000010044039C24A0000000E91EFFFFFF89C84883C4285B5E5F5D415C415D415E415FC3909090"
	;~ Do Not Remove This Line
	BCH:=A_BatchLines,Mode:=A_TitleMatchMode,CoordMode:=A_CoordModeMouse
	SetTitleMatchMode,2
	Setbatchlines,-1
	CoordMode,Mouse,Screen
	for a,b in Actions{
		Bits:=b.Bits
		for c,d in StrSplit("0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
			i:=c-1,Bits:=RegExReplace(Bits,"\Q" d "\E",(i>>5&1)(i>>4&1)(i>>3&1)(i>>2&1)(i>>1&1)(i&1))
		Bits:=RegExReplace(SubStr(Bits,1,InStr(s,"1",0,0)-1),"[^01]+"),Info:=[b.W,b.H,b.Threshold,b.Ones,b.Zeros,b.Match+0?b.Match:"100"],All:=[]
		if(b.Type="Window"){
			End:=(Start:=A_TickCount)+(b.WindowWait*1000)
			while(A_TickCount<End){
				if(WinExist(b.Area))
					Continue,2
				Sleep,100
			}Error:="Unable to find Window " """" b.Area """"
			Goto,PA_Exit
		}End:=(Start:=A_TickCount)+(b.WindowWait*1000)
		while(A_TickCount<End){
			if(WinExist(b.Area)){
				WinGet,List,List,% b.Area
				Loop,% List{
					WinGetPos,X,Y,W,H,% "ahk_id" HWND:=List%A_Index%
					All.Push({X:X,Y:Y,W:W,H:H,HWND:HWND})
				}if(!All.1){
					Error:="Unable To Find Window:``n``n``t" Area
					Goto,PA_Exit
				}Goto,PA_NextStep
			}Sleep,100
		}if(!All.Count()){
			Error:="Unable to find Window " b.Area
			Goto,PA_Exit
		}
		PA_NextStep:
		End:=(Start:=A_TickCount)+(b.Wait*1000)
		while(A_TickCount<End){
			Arr:=[]
			for c,d in All{
				K:=StrLen(Bits)*4,VarSetCapacity(In,28),VarSetCapacity(SS,d.W*d.H),VarSetCapacity(S1,K),VarSetCapacity(S0,K),VarSetCapacity(AllPos,Info.6*4)
				for e,f in [0,Info.1,Info.2,Info.4,Info.5,0,0]
					NumPut(f,&In,4*(A_Index-1),"Int")
				Cap:=VarSetCapacity(Scan,d.W*d.H*4),Stride:=((d.W*32+31)//32)*4,Win:=DllCall("GetDesktopWindow",Ptr),HDC:=DllCall("GetWindowDC",Ptr,Win,Ptr),MDC:=DllCall("CreateCompatibleDC",Ptr,HDC,Ptr),VarSetCapacity(BI,40,0),NumPut(40,BI,0,Int),NumPut(d.W,BI,4,Int),NumPut(-d.H,BI,8,Int),NumPut(1,BI,12,"Short"),NumPut(32,BI,14,"Short")
				if(hBM:=DllCall("CreateDIBSection",Ptr,MDC,Ptr,&BI,Int,0,PtrP,PPVBits,Ptr,0,Int,0,Ptr))
					OBM:=DllCall("SelectObject",Ptr,MDC,Ptr,hBM,Ptr),DllCall("BitBlt",Ptr,MDC,Int,0,Int,0,Int,d.W,Int,d.H,Ptr,HDC,Int,X,Int,Y,UInt,0x00CC0020|0x40000000),DllCall("RtlMoveMemory",Ptr,&Scan,Ptr,PPVBits,Ptr,Stride*d.H),DllCall("SelectObject",Ptr,MDC,Ptr,OBM),DllCall("DeleteObject",Ptr,hBM)
				DllCall("DeleteDC",Ptr,MDC),DllCall("ReleaseDC",Ptr,Win,Ptr,HDC)
				if(!MyFunc){
					;CodeHere
					VarSetCapacity(MyFunc,Len:=StrLen(Hex:=A_PtrSize=8?x64:x32)//2)
					Loop,%Len%
						NumPut((Value:="0x" SubStr(Hex,2*A_Index-1,2)),MyFunc,A_Index-1,"UChar")
					DllCall("VirtualProtect",Ptr,&MyFunc,Ptr,Len,"Uint",0x40,PtrP,0)
				}OK:=DllCall(&MyFunc,"UInt",Info.3,"UInt",d.X,"UInt",d.Y,Ptr,&Scan,"Int",0,"Int",0,"Int",d.W,"Int",d.H,Ptr,&SS,"AStr",Bits,Ptr,&S1,Ptr,&S0,Ptr,&In,"Int",7,Ptr,&AllPos,"Int",Info.6),Arr:=[]
				Loop,%OK%{
					if(Arr.Count()>=b.Match)
						Break,3
					Arr.Push({X:(Pos:=NumGet(AllPos,4*(A_Index-1),"Int"))&0xFFFF,Y:Pos>>16,W:Info.1,H:Info.2,HWND:HWND,Action:Action})
				}Sleep,100
			}if(Arr.1)
				Break
			Sleep,100
		}if(b.Match="Return")
			return Arr
		if(!Arr.1){
			Error:="Unable to find the Pixel Group"
			Goto,PA_Exit
		}if(!Obj:=Arr[b.Match]){
			Error:="Unable to find the " b.Match " occurrence."
			Goto,PA_Exit
		}WinGetPos,X,Y,,,% "ahk_id" Obj.HWND
		if(b.Type="InsertText"){
			Pos:="x" Obj.X+Round(b.OffSetX)-X " y" Obj.Y+Round(b.OffSetY)-Y,CB:=ClipboardAll
			while(Clipboard!=b.Text){
				Clipboard:=b.Text
				Sleep,10
			}BlockInput,On
			ControlClick,%Pos%,% "ahk_id" Obj.HWND
			if(b.SelectAll){
				Sleep,50
				Send,^a
			}Sleep,50
			Send,^v
			BlockInput,Off
			Clipboard:=CB
			Sleep,100
		}else if(b.Type="Mouse"&&b.Action!="Move"){
					;********************restore mouse position***********************************
			if(b.RestorePOS)
				MouseGetPos,RestoreX,RestoreY
			if(b.Actual){
				MouseClick,Left,% Obj.X+Round(b.OffSetX),% Obj.Y+Round(b.OffSetY),% b.ClickCount ;Added b.clickcount by Joe as it was missing
				if(b.RestorePOS)
					MouseMove,% RestoreX,RestoreY ;change this to an if the thing was selected
			}else{
				Pos:="x" Obj.X+Round(b.OffSetX)-X " y" Obj.Y+Round(b.OffSetY)-Y
				ControlClick,%Pos%,% "ahk_id" Obj.HWND,,% b.Action,% b.ClickCount
			}
		}else if(b.Type="Mouse"&&b.Action="Move")
			MouseMove,% Obj.X+Round(b.OffSetX),% Obj.Y+Round(b.OffSetY)
	}
	PA_Exit:
	CoordMode,Mouse,%CoordMode%
	SetTitleMatchMode,%Mode%
	SetBatchLines,%BCH%
	if(A_ThisLabel="PA_Exit"){
		MsgBox,262144,Error,%Error%
		Exit
	}
	return "ahk_id" Obj.HWND
}
;~ To Here
)

SetBatchLines,-1
ListLines,Off
CoordMode,Mouse,Screen
CoordMode,ToolTip,Screen
if()
	GI:=New Grabbie("11|11","AutomateMyTask - the-Automator.com") ;Joe Changed from Grabbie
else
	GI:=New Grabbie("20|20","AutomateMyTask - the-Automator.com") ;Joe Changed from Grabbie

GI.AddCode:=Info
return
GrabbieGuiEscape:
if(!GetKeyState("Shift"))
	return
GrabbieGuiClose:
IniWrite,% GI.GetChecked("JustFunction"),Settings.ini,Settings,Just_Function
IniWrite,% GI.FunctionName,Settings.ini,Settings,Function
WinGetPos,X,Y,W,H,% IG.ID
;~ IniWrite,x%X% y%Y% w%W% h%H%,Settings.ini,Setting,GUI
IniWrite,x%X% y%Y%,Settings.ini,Setting,GUI
ExitApp
return

AboutGUI:
	script.about()
return

Update:
	try
		script.update("https://raw.githubusercontent.com/RaptorX/AutomateMyTask/latest/ver"
		             ,"https://github.com/RaptorX/AutomateMyTask/releases/download/latest/AutomateMyTask.zip")
	catch e
	{
		if (e.code == 6)
			msgbox % e.msg
	}
return

Class Grabbie{
	_Testing(){
		return
	}_Event(Name,Event){
		local
		static Last:=[]
		ONode:=Node:=Event.srcElement
		if(!Node.GetAttribute("Valid")||this.Toggle.1)
			return
		/*
			if(!this.GetObj("List").1||this.Toggle.1)
				return
		*/
		if(Name="MouseOver")
			Pixel:=StrSplit(Node.ID,"|"),this.PixelX:=X:=Pixel.1,this.PixelY:=Y:=Pixel.2,this.Pixels[X,Y].Style.BackgroundColor:="Red"
		else if(Name="MouseOut"){
			MouseGetPos,,,,Control,2
			if(Control!=this.HWND.IE)
				this.PixelX:=this.PixelY:=0
			this.SetTimer(this.Bound.Redraw,-1)
		}
	}__New(Pos:="25|20",Title:="Find and Act"){ ; Joe Changed from Grabbie
		static
		this.Win:="Grabbie"
		Gui,% this.Win ":Destroy"
		Gui,% this.Win ":Default"
		;~ Gui,-DPIScale
		;~ Gui,+AlwaysOnTop +HWNDMain
		;~ Gui,Color,0,0
		;~ Gui,Font,c0xAAAAAA s10
		Gui,+AlwaysOnTop +HWNDMain ;Changed 6/21
		Gui,Color,0,0 ;Changed 6/21
		;~ Gui,Font,c0xAAAAAA s8 ;Changed 6/21
		Gui,Font,c0xAAAAAA s%GuiFontSize% ;Changed 6/21

		Gui,Margin,0,0
		Grid:=StrSplit(Pos,"|"),this.Title:=Title,this.Width:=Grid.1,this.Height:=Grid.2,this.CTRL:=[],this.AllCTRL:=[],this.HWND:=[],this.Last:=[],this.Types:=[],this.Able:=[],this.Titles:=[],this.Order:=["Type","Action","Text","Match","Comment","ClickCount","Wait","WindowWait","Area","Offset","Threshold","Ones","Zeros","Bits"],this.W:=10,this.H:=10,CTRLHeight:=this.Height*10
		Gui,Add,Text, x5 HWNDSteps,&Steps:
		Gui,Add,Text, x230 yp,Pixels:
		Gui,Add,TreeView,% "x5 w175 h" CTRLHeight " Checked HWNDHWND"
		this.HWND.TV:=HWND
		this.HWND.Steps:=Steps
		Gui,Add,StatusBar
		this.ID:="ahk_id" Main
		Ver:=this.FixIE(11)
		Gui,Add,ActiveX,% "x+45 w" this.Width*10 " h" CTRLHeight " HWNDIE vwb +0x800000",mshtml
		this.FixIE(Ver),wb.Navigate("about:blank"),this.IE:=IE
		while(wb.ReadyState!=4)
			Sleep,10
		this.Doc:=wb.Doc,Y:=0
		this.TypeValue:={Mouse:["Type","Action","Actual","ClickCount","RestorePOS","Wait","WindowWait","Comment","Match","OffX","OffY","Area","Bits","Ones","Zeros","Threshold","W","H"]
					 ,MouseWithOffset:["Type","Action","ClickCount","Wait","WindowWait","Comment","Match","OffX","OffY","Area","Bits","Ones","Zeros","Threshold","W","H"]
					 ,InsertText:["Type","Text","Wait","WindowWait","SelectAll","Comment","Match","OffX","OffY","Area","Bits","Ones","Zeros","Threshold","W","H"]
					 ,Window:["Type","Area","WindowWait"]}
		this.GUI:=[{Group:"Clear",G:"Delete",Type:"Button",X:"5",Y:Y,Title:"Delete Step"}
				,{Group:"Clear",G:"Clear",Type:"Button",X:"+5",Y:Y,Title:"Clear Steps"}
				,{Group:"Show",G:"CapturePixels",Type:"Button",X:"200",Y:Y,Title:"Re-Capture Pixels (F5)"}
				,{Group:"Show",G:"DisplayMatches",Type:"Button",X:"+0",Y:Y,Title:"&Display Matches"}
				,{Group:"Show",G:"Test",Type:"Button",X:"+0",Y:Y,Title:"&Test"}]

		this.GUI.Push({Group:"Threshold",Type:"Text",X:"m+5",Y:(Y+=40),Title:"Color Threshold:"}
				   ,{Group:"Threshold",HWND:"Threshold",G:"Threshold",Type:"Slider",X:"+m",Y:Y,Title:"",Extra:"Range1-255"} ;Slider for Setting Color Threshold
				   ,{Group:"Title",Type:"Text",X:"m+260",Y:Y,W:40,Title:"Action:"}
				   ,{Group:"Title",HWND:"Comment",Type:"Edit",X:"+5",Y:(Y-4),W:200}) ;
				   ;new gui row

		this.GUI.Push({Group:"Title",Type:"Text",X:"2",Y:(Y+=35),W:506,Extra:"0x10"} ; Horizontal Line
				   ;new gui row
				   ,{Group:"Title",Type:"Text",X:"m+5",Y:(Y+=15),W:110,Title:"&Window Title:"}
				   ,{Group:"Title",G:"UpdateWindowTitle",HWND:"Title",Type:"Edit",X:"+10",Y:Y-4,W:380,Extra:"Section"}
				   ;new gui row
				   ,{Group:"Title",G:"ChangeTitle",HWND:"FullTitle",Type:"Radio",X:"s",Y:(Y+=30),Title:"Full Title"}
				   ,{Group:"Title",G:"ChangeTitle",HWND:"BeforeFirst",Type:"Radio",X:"+5",Y:Y,Title:"Use Before First"}
				   ,{Group:"Title",G:"ChangeTitle",HWND:"AfterLast",Type:"Radio",X:"+5",Y:Y,Title:"Use After Last"}
				   ,{Group:"Title",G:"ChangeTitle",HWND:"Delimiter",Type:"Edit",X:"+5",Y:Y-4,W:50,Title:"-"}
				   ;new gui row
				   ,{Group:"Title",Type:"Text",X:"m+5",Y:(Y+=30),W:110,Title:"Window &Class:"}
				   ,{Group:"Title",G:"ChangeTitle",HWND:"Class",Type:"Edit",X:"s",Y:Y-4,W:380}
				   ;new gui row
				   ,{Group:"Title",Type:"Text",X:"m+5",Y:(Y+=30),W:110,Title:"Wait For Window:"}
				   ,{Group:"Title",G:"WindowWait",HWND:"WindowWait",Type:"Edit",X:"s",Y:Y-4,W:50,Extra:"Number"}
				   ,{Group:"Title",Type:"UpDown",Y:Y}
				   ,{Group:"Show",G:"CaptureTitle",Type:"Button",X:"+5",Y:(Y-4),H:24,Title:"Capture Window (F4)"}) ;Capture

		this.GUI.Push({Group:"Title",Type:"Text",X:"m+350",Y:(Y),Title:"Choose Match:"} ; Choose matching index
				   ,{Group:"Title",G:"Match",HWND:"Match",Type:"Edit",X:"+5",Y:Y-4,W:50,Extra:"Number"} ; Choose matching index
				   ,{Group:"Title",Type:"UpDown",Y:Y} ;Choose matching index
				   ;new gui row
				   ,{Group:"Title",Type:"Text",X:"2",Y:(Y+=30),W:506,Extra:"0x10"}) ; Horizontal Line
				   ;new gui row
		this.GUI.Push({Group:"Offset",HWND:"OffsetXText",Type:"Text",X:"m+5",Y:(Y+=15),Title:"Offset X:"} ;offestX
				   ,{Group:"Offset",G:"OffX",HWND:"OffX",Type:"Edit",X:"+5",Y:(Y-4),W:50,Extra:"Number"} ;offestX
				   ,{Group:"Offset",G:"OffX",Type:"UpDown",X:"+0",Y:"+0",Extra:"Range-100000-100000"} ;offestX
				   ,{Group:"Offset",HWND:"OffsetYText",Type:"Text",X:"+5",Y:(Y),Title:"Offset Y:"} ;OffsetY
				   ,{Group:"Offset",G:"OffY",HWND:"OffY",Type:"Edit",X:"+5",Y:(Y-4),W:50,Extra:"Number"} ;OffsetY
				   ,{Group:"Offset",G:"OffX",Type:"UpDown",X:"+0",Y:"+0",Extra:"Range-100000-100000"} ;OffsetY
				   ,{Group:"Offset",G:"CaptureOffset",HWND:"SetOffset",Type:"Button",X:"+5",Y:(Y-4),H:24,Title:"Set Offset (F3)"}
				   ,{Group:"Offset",G:"ShowOffset",HWND:"ShowOffset",Type:"Button",X:"+5",Y:(Y-4),H:24,Title:"Show Offset (F6)"}
				   ;new gui row
				   ,{Group:"Title",Type:"Text",X:"2",Y:(Y+=30),W:506,Extra:"0x10"} ; Horizontal Line
				   ;new gui row
				   ,{Group:"Title",Type:"Text",X:"m+5",Y:(Y+=15),Title:"Wait For Pixel Patern (Seconds 0 For Indefinite):"} ;Wait for Pixel match patter
				   ,{Group:"Title",G:"Wait",HWND:"Wait",Type:"Edit",X:"+5",Y:(Y-4),W:50,Extra:"Number"} ;Wait for Pixel match pattern
				   ,{Group:"Title",Type:"UpDown",Y:Y} ;Wait for Pixel match pattern

				   ,{Group:"Initial",G:"ChangeSize",Type:"Button",X:"m+360",Y:(Y-4),H:24,Title:"&Change Capture Size"})

		this.GUI.Push({Group:"Mouse",Type:"GroupBox",X:"15",Y:(GroupY:=Y+=25),W:223,H:105,Title:"Mouse",Extra:"Section"}
				   ,{Group:"Mouse",G:"MouseAction",HWND:"Left",Type:"Radio",X:"s+10",Y:(ButtonY:=Y+=20),Title:"Left"}
				   ,{Group:"Mouse",G:"MouseAction",HWND:"Middle",Type:"Radio",X:"s+10",Y:(Y+=15),Title:"Middle"}
				   ,{Group:"Mouse",G:"MouseAction",HWND:"Right",Type:"Radio",X:"s+10",Y:(Y+=15),Title:"Right"}
				   ,{Group:"Mouse",G:"MouseAction",HWND:"Move",Type:"Radio",X:"s+10",Y:(Y+=16),Title:"Move"}
				   ,{Group:"Click",Type:"Text",X:"s+10",Y:(Y+=15),Title:"Click Count:"}
				   ,{Group:"Click",G:"ClickCount",HWND:"ClickCount",Type:"Edit",X:"+5",Y:Y-4,W:40,Extra:"Number"}
				   ,{Group:"Mouse",HWND:"LastUpDown",Type:"UpDown",Y:Y-4}
				   ,{Group:"Mouse",G:"Actual",HWND:"Actual",X:"p",Y:(ButtonY-7),Type:"Checkbox",Title:"Actual Click"} ;moved
				   ,{Group:"Mouse",G:"RestorePOS",HWND:"RestorePOS",X:"p",Y:(ButtonY+10),Type:"Checkbox",Title:"Restore Position"} ;Need to ad functionality
				   ,{Group:"Initial",G:"CaptureMouse",Type:"Button",X:"s+130",Y:(ButtonY:=Y-20),H:24,Title:"Capture (F1)"})

		this.GUI.Push({Group:"SetText",Type:"GroupBox",X:"250",Y:(Y:=GroupY),W:238,H:105,Title:"Set Te&xt",Extra:"Section"}
				   ,{Group:"SetText",HWND:"Text",G:"Text",Type:"Edit",X:"s+10",Y:(Y+=18),W:218,Extra:"Multi R2"}
				   ,{Group:"SetText",G:"SelectAll",HWND:"SelectAll",Type:"Checkbox",X:"s+10",Y:(Y+=50),Title:"Select All",Extra:"Checked"}
				   ,{Group:"Initial",G:"CaptureInsertText",Type:"Button",X:"s+130",Y:(Y:=ButtonY),H:24,Title:"Capture (F2)"})

		this.GUI.Push({Group:"Initial",Type:"Checkbox",HWND:"JustFunction",X:"m+5",Y:(Y+=60),Title:"&Just Function Call"}
				   ,{Group:"Initial",Type:"Text",X:"m+140",Y:Y,Title:"Function Name:"}
				   ,{Group:"Initial",G:"Function",HWND:"Function",Type:"Edit",X:"+5",Y:(Y-4),W:120} ;REduced width
				   ,{Group:"Initial",G:"LineBreakonExport",HWND:"LineBreakonExport",X:"+10",Y:Y,Type:"Checkbox",Title:"``n in Export"} ;Need to ad functionality
				   ,{Group:"Show",Type:"Button",G:"Export",X:"+2",Y:(Y-4),H:24,Title:"&Export"})
		this.BuildGUI(),this.AllStepInfo:=[]
		this.AllCTRL.Delete("JustFunction")
		IniRead,Function,Settings.ini,Settings,Function,Perform_Action
		this.FunctionName:=Function
		this.AllCTRL.Delete("Function")
		this.SetState("Initial")
		this.SetText(this.HWND.Function,Function)
		IniRead,State,Settings.ini,Settings,Just_Function,0
		this.SetText(this.HWND.JustFunction,State)
		if(1)
			this.DrawPixels(this.Width,this.Height)
		else
			this.Doc.Body.OuterHtml:="<body style='Background-Color:Black;Color:Grey'>Know Pyxls</br>;)</body>"
		Gui,% this.Win ":Default"
		this.InsertTextControls:=["Title","Threshold","SetText","Initial","Clear","Show","Offset"]
		this.CaptureMouseControls:=["Title","Threshold","Mouse","Initial","Clear","Click","Show","Offset"]
		this.NoMouseClick:=["Title","Threshold","Mouse","Initial","Clear","Show","Offset"]
		this.CaptureTitleControls:=["Title","Window","Initial","Clear","Show","Offset"]
		this.Associate:={InsertText:this.InsertTextControls,Mouse:this.CaptureMouseControls,Window:this.CaptureTitleControls,NoMouse:this.NoMouseClick}
		this.Bound.Capture:=this.Capture.Bind(this)
		this.Bound.CaptureOffset:=this.CaptureOffset.Bind(this)
		this.Bound.ShowOffset:=this.ShowOffset.Bind(this)
		this.Able[HWND]:=this.TV.Bind(this)
		this.Doc.ParentWindow.AHK_Event:=this._Event.Bind(this)
		this.Bound.GetMouse:=this.GetMouse.Bind(this)
		this.Bound.ProcessAction:=this.ProcessAction.Bind(this)
		this.Bound.Redraw:=this.Redraw.Bind(this)
		this.Bound.Flash:=this.Flash.Bind(this)
		this.Bound.SetNewOffset:=this.SetNewOffset.Bind(this)
		this.ShowToolTip:=1
		this.SetDefaultHotkeys()
		Delete:=this.Delete.Bind(this)
		Select:=this.Select.Bind(this)
		this.FinishOffset:=this.ResetOffset.Bind(this)
		Hotkey,IfWinActive,% this.ID
		for a,b in {Delete:Delete,Backspace:Delete}
			Hotkey,%a%,%b%,On
		SB_SetText("Function: " A_ThisFunc " Line Number: " A_LineNumber " Tick: " A_TickCount-Tick)
		IniRead,Pos,Settings.ini,Setting,GUI,xCenter yCenter
		Gui,Show,%Pos% w510,% this.Title
		OnMessage(0x201,Select)
		ControlGet,HH,HWND,,Internet Explorer_Server1,% this.ID
		this.HWND.IE:=HH,this.HWND.IE2:=IE
	}Actual(){
		this.SetObj({Actual:this.GetChecked("Actual")})
	}AddStep(Type){
		this.StopFlash()
		this.Default()
		this.AllStepInfo[TV:=TV_Add(Type,,"Select Vis Focus " this.GetTV())]:=[]
		this.ClearAll()
		this.SetObj({List:[],ListRange:[]})
		return TV
	}Base2Bits(s){
		for a,b in StrSplit("0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
			s:=RegExReplace(s,"\Q" b "\E",((i:=a-1)>>5&1)(i>>4&1)(i>>3&1)(i>>2&1)(i>>1&1)(i&1))
		return,RegExReplace(SubStr(s,1,InStr(s,"1",0,0)-1),"[^01]+")
	}Bit2Base(s){
		static Keep:=[]
		s:=RegExReplace(s.=SubStr("100000",1,6-Mod(StrLen(s),6)),".{6}","|$0")
		for a,b in StrSplit("0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
			s:=StrReplace(s,"|" ((i:=a-1)>>5&1)(i>>4&1)(i>>3&1)(i>>2&1)(i>>1&1)(i&1),b)
		return,s
	}BuildGUI(){
		ControlGetPos,X,Y,W,H,,% "ahk_id" this.IE
		SysGet,Caption,31
		SysGet,Border,8
		Start:=Y+H-Caption-Border-1
		for a,b in this.GUI{
			Gui,Add,% b.Type,% "HWNDHWND" (b.X!=""?" x" b.X:"") " y" Start+b.Y (b.W?" w" b.W:"")(b.H?" h" b.H:"")(b.Extra?" " b.Extra:""),% b.Title
			this.AllCTRL[b.HWND]:=HWND
			if(b.Group){
				if(!IsObject(Obj:=this.Exclude[b.Group]))
					Obj:=this.Exclude[b.Group]:=[]
				Obj[HWND]:=1
			}if(b.G){
				this.Able[HWND]:=this.Bound[b.G]:=Bind:=this[b.G].Bind(this),this.CTRL[b.G]:=HWND
				GuiControl,+g,%HWND%,%Bind%
			}if(b.HWND)
				this.HWND[b.HWND]:=HWND
			this.Types[HWND]:=b.Type
			b.ControlHWND:=HWND
		}
	}Capture(Info*){
		static Steps,State,Timers:=[]
		if(IsObject(Info.1))
			this.SetHotkey({(Info.1.1):this.Bound.Capture}),State:=Info.1.2,Info.RemoveAt(1),Steps:=Info
		Step:=Steps.1.1,this.SetSB(this.ToolTipText:=Steps.1.2)
		if(Step="Start"){
			this.SetTimers([[this.Bound.ProcessAction,100]])
			Gui,+Disabled
		}
		if(Step="Area"){
			MouseGetPos,X,Y,Win
			this.GetWinInfo(Win)
			this.Last.X:=this.Last.Y:=0
			this.SetObj({X:X,Y:Y,W:this.Width,Width:this.Width,H:this.Height,Height:this.Height})
			this.SetObj({BaseX:X-Round(this.Width/2),BaseY:Y-Round(this.Height/2)})
			this.Move:=2
			this.SetObj({OffX:Round(this.Width/2),OffY:Round(this.Height/2)})
			if(!Steps.1.2)
				Step:="Done"
		}else if(Step="Window"){
			MouseGetPos,X,Y,Win
			Steps.RemoveAt(1),Step:=Steps.1.1
			this.GetWinInfo(Win)
		}else if(Step="TextOffset"){
			this.Move:=2
			this.Last.X:=this.Last.Y:=0
			this.MousePos:={X:"TextOffX",Y:"TextOffY",XC:this.HWND.TextOffX,YC:this.HWND.TextOffY}
			this.SetTimers([[this.Bound.GetMouse,100],[this.Bound.ProcessAction,100]])
			Timers.Push(this.Bound.GetMouse)
		}else if(Step="Offset"){
			this.Last.X:=this.Last.Y:=0
			this.Action:=Step
			this.MousePos:={X:"OffX",Y:"OffY",XC:this.HWND.OffX,YC:this.HWND.OffY}
			this.SetTimers([[this.Bound.GetMouse,100],[this.Bound.ProcessAction,100]])
			Timers.Push(this.Bound.GetMouse)
		}if(Step="Done"){
			this.Move:=0,this.Default(),SB_SetText("Capture Complete"),this.GetThreshold()
			this.SetObj(Set:=this.Titles[this.GetObj("Title")])
			if(this.Action~="(InsertText|Mouse)")
				Obj:=this.GetObj()
			if(this.Action="Offset")
				this.StopFlash()
			this.SetFocus(Steps.1.2),this.SetValues(),State:="",this.Action:=""
			Gui,-Disabled
			if(Set)
				this.ChangeTitle()
			this.SetFocus(Steps.1.2),this.SetTimers(),this.Offsets:="",this.Last.X:=this.Last.Y:=0
			ToolTip
			return this.SetDefaultHotkeys()
		}Steps.RemoveAt(1)
	}CaptureInsertText(){
		this.Move:=1
		this.Action:="InsertText"
		TV:=this.AddStep("Set Text")
		this.SetState()
		this.SetFocus(this.CTRL.CaptureInsertText)
		this.SetObj({Comment:"Insert Text",SelectAll:1,Type:"InsertText",Wait:2,WindowWait:2,Match:1})
		Key:="F2"
		this.Capture([Key,this.InsertTextControls],["Start","Press " Key " To Lock In The Area"],["Area","Move Away And Press " Key " To Set The Pixels"],["Offset","Press " Key " To Set The Offset Of Where The`nControl Is That You Wish To Set The Text"],["Done",this.HWND.Text])
	}CaptureMouse(){
		this.Move:=1
		TV:=this.AddStep("Mouse")
		this.Action:="Mouse"
		this.SetState()
		this.SetFocus(this.CTRL.CaptureMouse)
		this.SetObj({Comment:"Mouse Click",ClickCount:1,Left:1,Type:"Mouse",Wait:2,WindowWait:2,Match:1,OffX:0,OffY:0})
		Key:="F1"
		this.Capture([Key,this.CaptureMouseWithOffsetControls],["Start","Press " Key " To Lock In The Area"],["Area","Move Away And Press " Key " To Set The Pixels"],["Done",this.HWND.Left])
	}CaptureOffset(){
		if(!this.GetTV())
			return
		Key:="F3",this.Action:="Offset",this.ShowOriginalPosition(),this.SetTimer(this.Bound.Flash,500)
		this.Capture([Key],["Start","Press " Key " To Set The Offset"],["Done"])
	}
	ShowOffset(){ ;Displaying offset  JOE
		this.StopFlash()
		Key:="F6"
		Gui,Offset_Marker:Destroy
		Gui,Offset_Marker:Default
		Gui,Offset_Marker:-Caption +AlwaysOnTop
		Gui,Offset_Marker:Margin,0,0
		Gui,Offset_Marker:Color,Blue
		Obj:=this.GetObj()
		Gui,Offset_Marker:Show,% "x" Obj.BaseX+Round(obj.OffX)-(3) " y" Obj.BaseY+Round(obj.OffY)-(3) " w6 h6 NA"

		this.LastShown:={1:"Offset_Marker"},this.Count:=0
		this.SetTimer(this.Bound.Flash,500)
	}
	CapturePixels(){
		if(!this.GetTV())
			return
		this.StopFlash(),this.SetObj({Range:{W:this.Width,H:this.Height},Selection:[]})
		this.Move:=1
		Key:="F5"
		this.Capture([Key,this.Associate[this.GetObj("Type")]],["Start","Press " Key " To Lock In The Area"],["Area","Move Away And Press " Key " To Set The Pixels"],["Done"])
	}CaptureTitle(){
		TV:=this.AddStep("Wait For Window")
		this.SetObj({Comment:"Wait For Window"})
		this.SetState()
		Key:="F4"
		this.StopFlash()
		this.Capture([Key,this.CaptureTitleControls],["Start","Press " Key " To Capture The Title Information"],["Window"],["Done",this.HWND.Title])
		this.SetObj({WindowWait:2,Type:"Window"})
		this.SetFocus(this.CTRL.CaptureTitle)
	}ChangeSize(){
		static
		Max:=[]
		for a,b in this.AllStepInfo
			Max["W",b.W]:=1,Max["H",b.H]:=1
		MinW:=(MW:=Max.W.MaxIndex())?MW:11,MinH:=(MH:=Max.H.MaxIndex())?MH:11
		Gui,_ChangeSize:Destroy
		Gui,_ChangeSize:Default
		Gui,+ToolWindow +HWNDNew +AlwaysOnTop
		Gui,Color,0,0
		Gui,Font,c0xAAAAAA
		Gui,Add,Text,,New Capture Size (In Pixels):
		Gui,Add,Text,,Width:
		Gui,Add,Edit,x+7 yp-3 w50 vWidth ReadOnly
		Gui,Add,UpDown,Range%MinW%-100,% this.Width
		Gui,Add,Text,xm,Height:
		Gui,Add,Edit,x+4 yp-3 w50 vHeight ReadOnly
		Gui,Add,UpDown,Range%MinH%-40,% this.Height
		Gui,Add,Button,xm gCSG Default,Update Size
		Gui,Show,,% this.Win
		Main:=this
		return
		_ChangeSizeGuiEscape:
		_ChangeSizeGuiClose:
		Gui,_ChangeSize:Destroy
		return
		CSG:
		Gui,_ChangeSize:Submit,Nohide
		Gui,_ChangeSize:Destroy
		Start:=Height*10,Main.Width:=Width,Main.Height:=Height,Main.DrawPixels(Width,Height)
		ControlGetPos,,,,H,,% "ahk_id" Main.HWND.Steps
		GuiControl,% Main.Win ":MoveDraw",% Main.HWND.TV,% "h" Start
		GuiControl,% Main.Win ":MoveDraw",% Main.IE,% "w" Width*10 " h" Start
		Start+=H
		for a,b in Main.GUI
			GuiControl,% Main.Win ":MoveDraw",% b.ControlHWND,% "y" Start+b.Y-(b.Type="UpDown"&&b.ControlHWND!=Main.HWND.LastUpDown?4:0)
		Gui,% Main.Win ":Show",AutoSize
		WinActivate,ahk_id%New%
		Main.Redraw()
		return
	}ChangeTitle(){
		TV:=this.GetTV()
		for a,b in ["FullTitle","BeforeFirst","AfterLast"]
			this.SetObj({(b):this.GetChecked(b)})
		this.SetObj({Delimiter:this.GetText("Delimiter")})
		this.Disable(),Obj:=this.GetObj()
		if(this.GetChecked("FullTitle"))
			this.SetText(this.HWND.Title,Text:=Obj.Title)
		else if(this.GetChecked("BeforeFirst"))
			this.SetText(this.HWND.Title,Text:=Trim(SubStr(Obj.Title,1,InStr(Obj.Title,Obj.Delimiter)-1)))
		else if(this.GetChecked("AfterLast"))
			this.SetText(this.HWND.Title,Text:=Trim(SubStr(Obj.Title,InStr(Obj.Title,Obj.Delimiter,,0)+1)))
		this.SetObj({UseTitle:Text,Class:this.GetText("Class")})
		this.Enable()
		this.Titles[Obj.Title]:={FullTitle:Obj.FullTitle,BeforeFirst:Obj.BeforeFirst,AfterLast:Obj.AfterLast,Delimiter:Obj.Delimiter,Class:Obj.Class}
	}Clear(){
		if(this.m("Are You Sure?","Can NOT Be Un-Done",{Btn:"ync",Def:2})="YES")
			this.SetState("Initial"),this.ClearAll(),this.AllStepInfo:=[],this.Default(),TV_Delete(),this.Redraw()
	}ClearAll(){
		this.Disable()
		for a,b in this.AllCTRL{
			if(this.Types[b]~="(Button|Text)"=0)
				GuiControl,,%b%,% this.Types[b]~="(Checkbox|Radio)"?0:""
		}
		this.Enable()
	}ClickCount(){
		this.SetObj({ClickCount:this.GetText("ClickCount")})
	}CompileSteps(){
		this.Out:=[],Next:=0,this.StopFlash()
		if(!TV_GetNext()){
			this.m("Please Capture An Area First")
			Exit
		}while(Next:=TV_GetNext(Next,"F")){
			Obj:=this.GetObj(,Next),Bits:=""
			for a,b in Obj.ListRange
				Bits.=Bit:=b.Value>=Obj.Threshold?0:1
			RegExReplace(Bits,1,,Ones)
			RegExReplace(Bits,0,,Zeros)
			Title:=Obj.UseTitle?Obj.UseTitle:Obj.Title
			this.SetObj({Area:(Title?Title " ":"")(Obj.Class?"ahk_class " Obj.Class:""),Bits:(Obj.Type="Window"?"":this.Bit2Base(Bits)),Ones:Ones,Zeros:Zeros,Threshold:Obj.Threshold,W:Obj.Range.3.W,H:Obj.Range.3.H,Threshold:Obj.Threshold},Next)
			if(Action:=(SubStr(Obj.Type,1,5)="Mouse"?(Obj.Left?"Left":Obj.Middle?"Middle":Obj.Right?"Right":"Move"):""))
				Obj.Action:=Action
			if(Obj.OffX!=""){
				Obj.OffsetX:=Obj.OffX,Obj.OffsetY:=Obj.OffY
			}
		}if(Stop=1)
			return
	}Default(){
		Gui,% this.Win ":Default"
	}Delete(){
		if(Focus:=this.GetFocus()~="(SysTreeView321|Button1)"){
			List:=[],this.Default()
			while(Next:=TV_GetNext(Next,"Checked"))
				List.Push(Next)
			if(List.Count()){
				if(this.m({Btn:"yn",Def:2},"Delete " (List.Count()>1?"These " List.Count():"This")  " Step" (List.Count()=1?"":"s") "?")!="YES")
					return
				for a,b in List
					this.Default(),TV_Delete(b),this.AllStepInfo.Delete(b)
				return
			}
			this.Default(),TV_Delete(TV:=this.GetTV()),this.AllStepInfo.Delete(TV)
		}else
			Send,{%A_ThisHotkey%}
	}Disable(){
		for a,b in this.Able
			GuiControl,+g,%a%
	}DisplayMatches(){
		this.CompileSteps()
		Obj:=this.GetObj().Clone()
		if(Obj.Type="Window"){
			this.m("Window " (WinExist(Obj.Area)?"Exists":"Does Not Exist"))
			return
		}
		Match:=Obj.Match
		Obj.Match:="Return"
		Arr:=Perform_Action(Obj)
		Obj:=""
		if(!Arr.1)
			return SB_SetText("None Found, Please Adjust Your Threshold or Search Area")
		SB_SetText("Found: " Arr.MaxIndex())
		this.LastShown:=[],this.Count:=0
		for a,b in Arr{
			Gui,GUI%A_Index%:Default
			Gui,Margin,1,1
			Gui,-Caption +Border +HWNDMain +AlwaysOnTop +ToolWindow
			Gui,Color,Blue,Blue
			Gui,Font,c0xFFFFFF
			Gui,Add,Text,,%A_Index%
			Gui,Show,% "x" b.X " y" b.Y " w" (b.W<15?15:b.W) " h" (b.H<15?15:b.H) " NA"
			this.LastShown.Push("Gui" A_Index)
		}this.SetTimer(this.Bound.Flash,500)
	}DisplaySelection(Box){
		this.SetObj({Selection:Selection:=[]})
		if(Box.Y1<Box.Y2&&Box.X1<Box.X2)
			for X,a in this.Pixels{
				for Y,b in a{
					if(Y=Box.Y1&&X>=Box.X1&&X<=Box.X2)
						Selection[X,Y]:=1
					else if(Y=Box.Y2&&X>=Box.X1&&X<=Box.X2)
						Selection[X,Y]:=1
					else if(X=Box.X1&&Y>=Box.Y1&&Y<=Box.Y2)
						Selection[X,Y]:=1
					else if(X=Box.X2&&Y>=Box.Y1&&Y<=Box.Y2)
						Selection[X,Y]:=1
				}
			}this.Redraw()
	}DrawPixels(W,H){
		Y:=1,this.Pixels:=[],All:=(Main:=this.Doc.GetElementById("Main")).GetElementsByTagName("Div")
		while(aa:=All.Item[0])
			aa.ParentNode.RemoveChild(aa)
		Loop,% W*H{
			Info:=""
			X:=Mod(A_Index-1,W)+1
			for a,b in {Left:((X-1)*this.W),Top:((Y-1)*this.H),Width:this.W,Height:this.H,"Background-Color":"Black",Position:"Absolute"}
				Info.=a ":" b ";"
			Total.="<div style='" Info "' ID='" X "|" Y "' onmouseover='MouseOver(Event)' onmouseout='MouseOut(Event)'></div>"
			if(!Mod(A_Index,W))
				Y++
		}for a,b in {MouseOver:"MouseOver",MouseOut:"MouseOut"}
			Functions.=a "=function(" a "){AHK_Event('" b "',event)};"
		this.Doc.Body.OuterHtml:="<body style='Background-Color:Black'><div id='Main'>" Total "</div></body>"
		htmldoc:=this.Doc.CreateElement("Script")
		htmldoc.InnerText:=Functions
		this.Doc.Body.AppendChild(htmldoc)
		All:=this.Doc.GetElementById("Main").GetElementsByTagName("Div")
		while(aa:=All.Item[A_Index-1]){
			Obj:=StrSplit(aa.ID,"|")
			this.Pixels[Obj.1,Obj.2]:=aa
		}
	}Duplicate(){ ;Dropped Duplicate button
		Obj:=this.GetObj().Clone()
		this.AllStepInfo[TV_Add(Obj.Type,,"Select Vis Focus")]:=Obj,this.SetValues()
	}Enable(){
		for a,b in this.Able
			GuiControl,+g,%a%,%b%
	}Export(){
		this.CompileSteps(),this.Default(),this.FunctionName:=this.FunctionName?RegExReplace(this.FunctionName,"\s","_"):"AmT"

		; this loop goes over each step
		while(Next:=TV_GetNext(Next,"F")){
			Obj:=this.GetObj(,Next)
			;m(obj)
			;~ MsgBox pause
			Row:=this.FunctionName "({"

			; type value has a list of information that we need for a specific action
			; you can add or remove values that you think you need on line ~101
			for a,b in this.TypeValue[Obj.Type]{
				if(b="OffX"||b="OffY")
					Row.=(Need:="Offset" SubStr(b,4)) ":" Obj[Need] ","
				else if(b="Comment")
					Row.=b ":" Chr(34) this.GetText("Comment") Chr(34) ","
				else if(((Value:=Obj[b]+1?Obj[b]:Chr(34) RegExReplace(RegExReplace((SubStr(Obj[b],1,5)="Mouse"?"Mouse":Obj[b]),"\x22",Chr(34) Chr(34)),"\R","``r``n") Chr(34)))!="")
					Row.=b ":" Value "," ;`n`t Tweaked per Jackie Sztuk idea.
			}
			If (obj.LineBreakonExport)
				row:=RegExReplace(Row,",","`n`t,")
			Row:=Trim(Row,",`n`t") "})`r`n"

			Total.=Row
				; remove last linebreak before
		}Function:=Total
		Fun:=this.GetChecked("JustFunction")
		Clipboard:=Fun?Function:"WinGetActiveTitle,Title`r`n" Function "`r`nWinActivate,%Title%`r`n" RegExReplace(this.AddCode,"Perform_Action\(",this.FunctionName "(")
		if (!Notify)
			Notify:=Notify() ;instantiate the object
		Notify.AddWindow(Clipboard,{Icon:300,Title:"Copied to Clipboard:",TitleSize:16,size:14,Time:4000,Background:"0x1100AA"})
		;~ Notify:="" ;Clear Notify
		;~ this.m("Copied " (Fun?"Function":"Code") " to the Clipboard")
	}GetChecked(Control){
		ControlGet,Checked,Checked,,,% "ahk_id" this.HWND[Control]
		return Checked
	}GetFocus(){
		ControlGetFocus,Focus,% this.ID
		return Focus
	}FixIE(Version=0){ ;Thanks GeekDude
		static Key:="Software\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_BROWSER_EMULATION",Versions:={7:7000,8:8888,9:9999,10:10001,11:11001}
		Version:=Versions[Version]?Versions[Version]:Version
		if(A_IsCompiled)
			ExeName:=A_ScriptName
		else
			SplitPath,A_AhkPath,ExeName
		RegRead,PreviousValue,HKCU,%Key%,%ExeName%
		if(!Version)
			RegDelete,HKCU,%Key%,%ExeName%
		else
			RegWrite,REG_DWORD,HKCU,%Key%,%ExeName%,%Version%
		return PreviousValue
	}Flash(){ ;ahhhhhhh!

		if(this.Count++=19)
			this.StopFlash()
		for a,b in this.LastShown
			Gui,%b%:Color,% Mod(this.Count,2)?"0xFF0000":"0x0000FF"

	}Function(){
		this.FunctionName:=RegExReplace(RegExReplace(this.GetText("Function"),"\s","_"),"\W")
	}GetBitsFromScreen(X,Y,W,H,ByRef Scan,ByRef Stride){
		static Ptr:=A_PtrSize?"UPtr":"UInt",PtrP:=Ptr "*",Bits
		VarSetCapacity(Bits,W*H*4),Scan:=&Bits,Stride:=((W*32+31)//32)*4,Win:=DllCall("GetDesktopWindow",Ptr),HDC:=DllCall("GetWindowDC",Ptr,Win,Ptr),MDC:=DllCall("CreateCompatibleDC",Ptr,HDC,Ptr),VarSetCapacity(BI,40,0),NumPut(40,BI,0,Int),NumPut(W,BI,4,Int),NumPut(-H,BI,8,Int),NumPut(1,BI,12,"Short"),NumPut(32,BI,14,"Short")
		if(hBM:=DllCall("CreateDIBSection",Ptr,MDC,Ptr,&BI,Int,0,PtrP,PPVBits,Ptr,0,Int,0,Ptr))
			OBM:=DllCall("SelectObject",Ptr,MDC,Ptr,hBM,Ptr),DllCall("BitBlt",Ptr,MDC,Int,0,Int,0,Int,W,Int,H,Ptr,HDC,Int,X,Int,Y,UInt,0x00CC0020|0x40000000),DllCall("RtlMoveMemory",Ptr,Scan,Ptr,PPVBits,Ptr,Stride*H),DllCall("SelectObject",Ptr,MDC,Ptr,OBM),DllCall("DeleteObject",Ptr,hBM)
		DllCall("DeleteDC",Ptr,MDC),DllCall("ReleaseDC",Ptr,Win,Ptr,HDC)
	}GetListRange(){
		this.SetObj({ListRange:ListRange:=[]}),Obj:=this.GetObj(),Range:=Obj.Range,List:=Obj.List
		for a,b in List{
			X:=b.X,Y:=b.Y
			if(X>Range.1.X&&X<Range.2.X&&Y>Range.1.Y&&Y<Range.2.Y&&Range.1.X!="")
				ListRange.Push(List[A_Index])
			else if(Range.1.X="")
				ListRange.Push(List[A_Index])
		}
	}GetMouse(){
		MouseGetPos,X,Y,Win
		TV:=this.GetTV(),Obj:=this.GetObj()
		this.SetObj({(this.MousePos.X):(NewX:=X-Round(Obj.X))
				  ,(this.MousePos.Y):(NewY:=Y-Round(Obj.Y))})
		this.SetText(this.MousePos.XC,NewX) ;this.GetObj(TV,this.MousePos.X))
		this.SetText(this.MousePos.YC,NewY) ;this.GetObj(TV,this.MousePos.Y))
		this.X:=X
		this.Y:=Y
	}GetMouseAction(){
		static Actions:=["Left","Middle","Right","Move"]
		for a,b in Actions
			if(this.GetChecked(b)){
				Value:=b
				Break
			}
		return Value
	}GetObj(ObjName:="",TV:=""){
		TV:=TV?TV:this.GetTV()
		if(!ObjName)
			return this.AllStepInfo[TV]
		Obj:=this.AllStepInfo[TV,ObjName]
		return Obj
	}GetText(Control){
		ControlGetText,Text,,% "ahk_id" this.HWND[Control]
		return Text
	}GetThreshold(){
		IP:=IS:=0,Av:=[],Obj:=this.GetObj()
		for a,b in Obj.ListRange
			Av[b.Value]:=Round(Av[b.Value])+1
		for a,b in Av
			IP+=a*b,IS+=b
		NewThreshold:=Floor(IP/IS)
		Loop,20{
			Threshold:=NewThreshold,IP1:=IS1:=0
			Loop,% Threshold+1
				k:=A_Index-1,IP1+=k*Round(Av[k]),IS1+=Round(Av[k])
			IP2:=IP-IP1,IS2:=IS-IS1
			if(IS1!=0&&IS2!=0)
				NewThreshold:=Floor((IP1/IS1+IP2/IS2)/2)
			if(NewThreshold=Threshold)
				Break
		}if(!Obj.Range.3)
			this.SetObj({Range:{3:{W:this.Width,H:this.Height}}})
		this.SetObj({Threshold:NewThreshold})
		this.SetValues()
		return NewThreshold
	}GetTV(){
		this.Default()
		return TV_GetSelection()
	}GetWinInfo(HWND){
		WinGetTitle,Title,% "ahk_id" HWND
		WinGetClass,Class,% "ahk_id" HWND
		this.SetObj({Title:Title,Class:Class})
	}LineBreakonExport(){
		this.SetObj({LineBreakonExport:this.GetChecked("LineBreakonExport")}) ;Trying to add this checkbox for Line break on export
	}m(x*){
		static Codes:={oc:1,ari:2,ync:3,yn:4,rc:5,ctc:6,2:256,3:512,4:768}
		Btn:=0,Def:=0
		for a,b in x{
			if(Code:=Codes[b.Btn])
				Btn+=Code
			if(Code:=Codes[b.Def])
				Def+=Code
			else
				Msg.=b "`n"
		}
		MsgBox,% 262144+Btn+Def,% this.Title,%Msg%
		for a,b in ["YES","NO","CANCEL","OK"]
			IfMsgBox,%b%
				return,b
	}Match(){
		if(TV:=this.GetTV())
			this.SetObj({Match:this.GetText("Match")})
	}MouseAction(){
		for a,b in ["Left","Middle","Right","Move"]{
			this.SetObj({(b):this.GetChecked(b)})
			if(this.GetChecked(b)){
				if(b="Move"){
					Move:=1
				}
			}
		}if(Move)
			this.SetState(this.Associate.NoMouse*)
		else
			this.SetState(this.Associate[this.GetObj("Type")]*)
	}OffX(){
		this.SetObj({OffX:this.GetText("OffX")})
	}OffY(){
		this.SetObj({OffY:this.GetText("OffY")})
	}ProcessAction(){
		MouseGetPos,X,Y
		if(this.Last.X!=X||this.Last.Y!=Y){
			if(this.Action="Offset"){
				Obj:=this.GetObj()
				this.SetObj({OffX:X-Obj.BaseX,OffY:Y-Obj.BaseY})
				this.SetText(this.HWND.OffX,Obj.OffX)
				this.SetText(this.HWND.OffY,Obj.OffY)
			}
			ToolTip,% this.ToolTipText,% X+Round(this.Width/2),% Y+Round(this.Height/2)
			if(this.Move=1){
				this.SetObj({X:X,Y:Y})
			}if(this.Move)
				this.ShowPixels((Obj:=this.GetObj()).X-Round(this.Width/2),Obj.Y-Round(this.Height/2))
			else
				X:=this.GetObj("X"),Y:=this.GetObj("Y")
		}this.Last.X:=X,this.Last.Y:=Y
	}Redraw(){
		Obj:=this.GetObj(),Pixels:=Obj.Pixels,Selection:=Obj.Selection
		for X,a in this.Pixels{
			for Y,b in a{
				Style:=b.Style
				Pixel:=Pixels[X,Y]
				Color:=Pixel.Color?"#" SubStr(Pixel.Color,3):"000"
				b.SetAttribute("Valid",Color="000"?0:1)
				Color:=Selection[X,Y]||X=this.PixelX&&Y=this.PixelY?"Red":Color?Color:"000"
				Style.BackgroundColor:=Color
			}
		}
	}ResetOffset(){
		this.SetTimers()
		ToolTip
		Gui,Original_Marker:Destroy
		this.SetDefaultHotkeys()
	}RestorePOS(){
		this.SetObj({RestorePOS:this.GetChecked("RestorePOS")})
	}Select(){
		MouseGetPos,,,,Control,2
		if(Control!=this.HWND.IE)
			return
		Start:={X:this.PixelX,Y:this.PixelY}
		this.Redraw()
		this.SetObj({Range:Range:=[]})
		Range.Push(Start),Obj:=this.GetObj()
		while(GetKeyState("LButton","P")){
			PX:=this.PixelX,PY:=this.PixelY
			if(PX!=LastX||PY!=LastY)
				this.DisplaySelection({X1:Start.X,Y1:Start.Y,X2:PX,Y2:PY})
			LastX:=PX,LastY:=PY
			Sleep,100
		}Range.Push({X:PX,Y:PY})
		if(!(Range.2.X-Range.1.X-1>0&&Range.2.Y-Range.1.Y-1>0)){
			this.SetObj({Range:{3:{W:Obj.Width,H:Obj.Height}},ListRange:this.GetObj("List"),Selection:[]}),this.Redraw()
		}else
			Range.Push({W:Range.2.X-Range.1.X-1,H:Range.2.Y-Range.1.Y-1})
		/*
			m(this.GetObj("Range"))
		*/
		this.GetListRange(),this.GetThreshold()
	}SelectAll(){
		this.SetObj({SelectAll:this.GetChecked("SelectAll")})
	}SetDefaultHotkeys(){
		this.SetHotkey({F1:this.Bound.CaptureMouse,F2:this.Bound.CaptureInsertText,F3:this.Bound.CaptureOffset,F4:this.Bound.CaptureTitle,F5:this.Bound.CapturePixels,F6:this.Bound.ShowOffset},this.ID)
	}SetFocus(Control){
		ControlFocus,,% "ahk_id" Control
	}SetHotkey(Keys,Window:=""){
		static Last:=[]
		while(Key:=Last.Pop()){
			Hotkey,IfWinActive,% Key.Window
			Hotkey,% Key.Key,% Key.Bound,Off
		}Hotkey,IfWinActive,%Window%
		for a,b in Keys{
			Hotkey,%a%,%b%,On
			Last.Push({Key:a,Bound:Bound,Window:Window})
		}
	}SetMouseOffset(){
		this.StopFlash(),this.ShowOriginalPosition()
		this.SetControls:={X:this.HWND.OffX,Y:this.HWND.OffY,Text:"Press F1 To Set The New Offset"}
		this.LastX:=this.LastY:=""
		this.SetTimers([[this.Bound.SetNewOffset,100],[this.Bound.Flash,500]])
		this.SetHotkey({F1:this.FinishOffset})
	}SetNewOffset(){
		Obj:=this.GetObj()
		MouseGetPos,X,Y
		if(X!=this.LastX||Y!=this.LastY){
			ToolTip,% this.SetControls.Text
			this.SetText(this.SetControls.X,X-Obj.X)
			this.SetText(this.SetControls.Y,Y-Obj.Y)
			this.LastX:=X,this.LastY:=Y
		}
	}SetObj(Obj,TV:=""){
		if(!IsObject(OO:=this.AllStepInfo[TV?TV:this.GetTV()]))
			OO:=this.AllStepInfo[TV?TV:this.GetTV()]:=[]
		for a,b in Obj
			OO[a]:=b
		return OO
	}SetSB(Text){
		this.Default(),SB_SetText(Text)
	}SetState(Exclude*){
		for a,b in this.AllCTRL{
			for c,d in Exclude
				if(this.Exclude[d,b])
					Continue,2
			if(a="JustFunction")
				this.m("Function: " A_ThisFunc,"Line: " A_LineNumber,"Well poop")
			GuiControl,+Disabled,%b%
		}for a,b in Exclude{
			for c,d in this.Exclude[b]
				GuiControl,-Disabled,%c%
		}
	}SetText(Control,Value){
		GuiControl,,%Control%,%Value%
	}SetTextOffset(){
		this.StopFlash(),this.ShowOriginalPosition()
		this.SetControls:={X:this.HWND.TextOffX,Y:this.HWND.TextOffY,Text:"Press F1 To Set The New Offset"}
		this.LastX:=this.LastY:=""
		this.SetTimers([[this.Bound.SetNewOffset,100],[this.Bound.Flash,500]])
		this.SetHotkey({F1:this.FinishOffset})
	}SetTimer(Timer,Duration){
		SetTimer,%Timer%,%Duration%
	}SetTimers(Timer:=""){
		static Timers:=[]
		while(b:=Timers.Pop())
			SetTimer,%b%,Off
		for a,b in Timer{
			Action:=b.1
			SetTimer,%Action%,% b.2
			Timers.Push(b.1)
		}
	}SetValues(){
		this.ClearAll(),Obj:=this.GetObj(),this.SetState(this.Associate[Obj.Type]*),this.Disable()
		for a,b in Obj{
			if(CTRL:=this.HWND[a])
				GuiControl,,%CTRL%,% (a="Title"&&Obj.UseTitle?Obj.UseTitle:b)
		}this.Enable()
	}ShowOriginalPosition(){
		Gui,Original_Marker:Destroy
		Gui,Original_Marker:Default
		Gui,Original_Marker:-Caption +AlwaysOnTop
		Gui,Original_Marker:Margin,0,0
		Gui,Original_Marker:Color,Blue
		Gui,Original_Marker:Font,c0xFFFFFF
		Gui,Original_Marker:Add,Text,,OP
		Obj:=this.GetObj()
		Gui,Original_Marker:Show,% "x" Obj.BaseX+Round(Obj.Range.1.X) " y" Obj.BaseY+Round(Obj.Range.1.Y) " w" (Obj.Range.3.W<20?20:Obj.Range.3.W) " h" (Obj.Range.3.H<15?15:Obj.Range.3.H) " NA"
		this.LastShown:={1:"Original_Marker"},this.Count:=0
	}ShowPixels(X,Y){
		this.AreaX:=X
		this.AreaY:=Y
		this.GetBitsFromScreen(X,Y,this.Width,this.Height,Scan,Stride)
		Y:=1
		this.Default()
		this.SetObj({List:List:=[]})
		this.SetObj({Pixels:Pixels:=[]})
		Loop,% this.Width*this.Height{
			X:=Mod(A_Index-1,this.Width)+1
			c:=NumGet(Scan+0,4*(A_Index-1),"UInt")
			List.Push(Pixel:={X:X,Y:Y,Color:CC:="0x" SubStr(Format("{:0x}",(Co:=0x1000000|c)),-5),Value:VV:=((((c>>16)&0xFF)*38+((c>>8)&0xFF)*75+(c&0xFF)*15)>>7)})
			Pixels[X,Y]:={Color:CC,Value:VV}
			Style:=this.Pixels[X,Y].Style
			this.Pixels[X,Y].SetAttribute("Color","#" SubStr(Pixel.Color,3))
			this.Pixels[X,Y].SetAttribute("Valid",1)
			Style.BackgroundColor:="#" SubStr(Pixel.Color,3)
			(!Mod(A_Index,this.Width))?Y++:""
		}
		this.SetObj({ListRange:List.Clone()})
	}StopFlash(){
		this.SetTimer(this.Bound.Flash,"Off")
		for a,b in this.LastShown
			Gui,%b%:Destroy
	}Test(){
		this.StopFlash(),this.CompileSteps(),this.Default(),Send:=[]
		while(Next:=TV_GetNext(Next,"F")){
			Obj:=this.GetObj(,Next).Clone()
			Obj.Type:=SubStr(Obj.Type,1,5)="Mouse"?"Mouse":Obj.Type
			Send.Push(Obj)
		}
		Tick:=A_TickCount,Perform_Action(Send*),this.Default(),SB_SetText("All Steps Completed In " A_TickCount-Tick "ms")
		WinActivate,% this.ID
	}Text(){
		if(TV:=this.GetTV())
			this.SetObj({Text:this.GetText("Text")})
	}TextOffX(){
		this.SetObj({TextOffX:this.GetText("TextOffX")})
	}TextOffY(){
		this.SetObj({TextOffY:this.GetText("TextOffY")})
	}Threshold(a,b,c){
		GuiControlGet,Value,,%a%
		this.SetObj({Threshold:Value})
	}TV(a,b,c){
		if(b="S")
			this.SetValues(),this.UpdatePixels(),this.Redraw(),this.ChangeTitle()
	}UpdatePixels(){
		Obj:=this.GetObj(),Y:=1
		for a,b in Obj.List
			X:=Mod(A_Index-1,this.Width)+1,(Pixel:=this.Pixels[X,Y]).SetAttribute("Color","#" SubStr(b.Color,3)),Pixel.Style.BackgroundColor:="#" SubStr(b.Color,3),(!Mod(A_Index,this.Width))?Y++:""
	}UpdateWindowTitle(){
		this.SetObj({Title:this.GetText("Title")})
	}Wait(){
		if(TV:=this.GetTV())
			this.SetObj({Wait:this.GetText("Wait")})
	}WindowWait(){
		if(TV:=this.GetTV())
			this.SetObj({WindowWait:this.GetText("WindowWait")})
	}
}
/*
	Up::
	Down::
	Left::
	Right::
	MouseGetPos,X,Y
	MouseMove,% X+(A_ThisLabel~="(Left|Right)"?(A_ThisLabel="Left"?-1:1):0),% Y+(A_ThisLabel~="(Up|Down)"?(A_ThisLabel="Up"?-1:1):0)
*/
;~ Do Not Change From Here
Perform_Action(Actions*){
	static Ptr:=A_PtrSize?"UPtr":"UInt",PtrP:=Ptr "*",MyFunc
	static x32:="5589E557565383EC348B7D388B47048945CC8B47088945C88B470C8945EC8B47108945E48B45EC8945D43B45E47D068B45E48945D431C03B453C0F8D910000008B1C878B4C8704C745D000000000C745D800000000895DF08B5C8708894DE08B4DF0895DC4894DE8894DDC8B75C43975D87D568B75DC03752C31C98975C03B4DE07D2F8B75D08B5DC001CE803C0B3175118B55F08B5D3089349389D343895DF0EB0D8B55E88B5D34893493428955E841EBCC8B4DE085C9790231C98B5D20014DDCFF45D8015DD0EBA283C007E966FFFFFF8B45088B5D2040C1E0078945E085DB790231DB8D049D00000000C745E80000000031FF8945DCC745F0000000008B45E83B45247D4A8B45288B55F031C903551401F88945D83B4D207D280FB642026BF0260FB642016BC04B01F00FB6326BF60F01F03B45E08B45D80F9204084183C204EBD38B4DDC01DF014DF0FF45E8EBAE8B45202B45CCC745DC000000008945D88B55188B452403550CC745F0000000002B45C88955CC8945D08B451C034510C1E0108945E031C08B4DD0394DF00F8F9200000031C93B4DD87F748B7DDC8D14398955E831D28B75E80375283B55D47D273B55EC7D0D8B5D308B3C9301F7803F0175493B55E47D0D8B5D348B3C9301F7803F00753742EBD48B7DCC8D50018D340F8B7D400B75E08934873B55447D358B5DE831C0035D283B45EC7D0E8B7D308B34874001DEC60600EBED89D041EB878B4D20FF45F08145E000000100014DDCE964FFFFFF89D083C4345B5E5F5DC2400090"
	static x64:="4157415641554154555756534883EC28488B8424D00000008B5804895424788B780C894C2470895C24108B5808897C2408895C24148B581039DF89DF895C240C0F4D7C240831D2897C2418399424D80000000F8E8E000000448B14904531E431DB8B7C90088B6C90044489D6897C241C4489D73B5C241C7D644C63EE4C03AC24B80000004531DB4439DD7E3643807C1D0031478D341C7514488B8C24C00000004D63FA41FFC2468934B9EB11488B8C24C80000004C63FFFFC7468934B949FFC3EBC585ED41BB00000000440F49DDFFC34403A424A00000004401DEEB964883C207E965FFFFFF8B44247041BB000000008D4801C1E10783BC24A000000000440F499C24A000000031ED31F631FF468D2C9D000000003BAC24A80000007D554863DE48039C24B00000004863C74531D24C01C844399424A00000007E2D0FB65002446BE2260FB650016BD24B4401E2440FB620456BE40F4401E239CA420F92041349FFC24883C004EBC94401EF4401DEFFC5EBA244038424980000004531DB31C04531D28BBC24A00000008BAC24A80000008B9424900000002B7C241041C1E0102B6C2414035424784139EA0F8FDB0000004531C94139F90F8FB6000000438D1C1931C9394C24184189CC7E52394C24087E204C8BB424C00000004C8BBC24B0000000418B348E01DE4863F641803C37017579443964240C7E204C8BB424C80000004C8BBC24B0000000418B348E01DE4863F641803C3700755248FFC1EBA5428D340A4C8BB424E00000008D48014409C63B8C24E8000000418934867D4D31C0394424087E234C8BBC24C00000004C8BB424B0000000418B348748FFC001DE4863F641C6043600EBD74863C141FFC1E941FFFFFF41FFC24181C00000010044039C24A0000000E91EFFFFFF89C84883C4285B5E5F5D415C415D415E415FC3909090"
	;~ Do Not Remove This Line
	BCH:=A_BatchLines,Mode:=A_TitleMatchMode,CoordMode:=A_CoordModeMouse
	SetTitleMatchMode,2
	Setbatchlines,-1
	CoordMode,Mouse,Screen
	for a,b in Actions{
		Bits:=b.Bits
		for c,d in StrSplit("0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
			i:=c-1,Bits:=RegExReplace(Bits,"\Q" d "\E",(i>>5&1)(i>>4&1)(i>>3&1)(i>>2&1)(i>>1&1)(i&1))
		Bits:=RegExReplace(SubStr(Bits,1,InStr(s,"1",0,0)-1),"[^01]+"),Info:=[b.W,b.H,b.Threshold,b.Ones,b.Zeros,b.Match+0?b.Match:"100"],All:=[]
		if(b.Type="Window"){
			End:=(Start:=A_TickCount)+(b.WindowWait*1000)
			while(A_TickCount<End){
				if(WinExist(b.Area))
					Continue,2
				Sleep,100
			}Error:="Unable to find Window " """" b.Area """"
			Goto,PA_Exit
		}End:=(Start:=A_TickCount)+(b.WindowWait*1000)
		while(A_TickCount<End){
			if(WinExist(b.Area)){
				WinGet,List,List,% b.Area
				Loop,% List{
					WinGetPos,X,Y,W,H,% "ahk_id" HWND:=List%A_Index%
					All.Push({X:X,Y:Y,W:W,H:H,HWND:HWND})
				}if(!All.1){
					Error:="Unable To Find Window:`n`n`t" Area
					Goto,PA_Exit
				}Goto,PA_NextStep
			}Sleep,100
		}if(!All.Count()){
			Error:="Unable to find Window " b.Area
			Goto,PA_Exit
		}
		PA_NextStep:
		End:=(Start:=A_TickCount)+(b.Wait*1000)
		while(A_TickCount<End){
			Arr:=[]
			for c,d in All{
				K:=StrLen(Bits)*4,VarSetCapacity(In,28),VarSetCapacity(SS,d.W*d.H),VarSetCapacity(S1,K),VarSetCapacity(S0,K),VarSetCapacity(AllPos,Info.6*4)
				for e,f in [0,Info.1,Info.2,Info.4,Info.5,0,0]
					NumPut(f,&In,4*(A_Index-1),"Int")
				Cap:=VarSetCapacity(Scan,d.W*d.H*4),Stride:=((d.W*32+31)//32)*4,Win:=DllCall("GetDesktopWindow",Ptr),HDC:=DllCall("GetWindowDC",Ptr,Win,Ptr),MDC:=DllCall("CreateCompatibleDC",Ptr,HDC,Ptr),VarSetCapacity(BI,40,0),NumPut(40,BI,0,Int),NumPut(d.W,BI,4,Int),NumPut(-d.H,BI,8,Int),NumPut(1,BI,12,"Short"),NumPut(32,BI,14,"Short")
				if(hBM:=DllCall("CreateDIBSection",Ptr,MDC,Ptr,&BI,Int,0,PtrP,PPVBits,Ptr,0,Int,0,Ptr))
					OBM:=DllCall("SelectObject",Ptr,MDC,Ptr,hBM,Ptr),DllCall("BitBlt",Ptr,MDC,Int,0,Int,0,Int,d.W,Int,d.H,Ptr,HDC,Int,X,Int,Y,UInt,0x00CC0020|0x40000000),DllCall("RtlMoveMemory",Ptr,&Scan,Ptr,PPVBits,Ptr,Stride*d.H),DllCall("SelectObject",Ptr,MDC,Ptr,OBM),DllCall("DeleteObject",Ptr,hBM)
				DllCall("DeleteDC",Ptr,MDC),DllCall("ReleaseDC",Ptr,Win,Ptr,HDC)
				if(!MyFunc){
					;CodeHere
					VarSetCapacity(MyFunc,Len:=StrLen(Hex:=A_PtrSize=8?x64:x32)//2)
					Loop,%Len%
						NumPut((Value:="0x" SubStr(Hex,2*A_Index-1,2)),MyFunc,A_Index-1,"UChar")
					DllCall("VirtualProtect",Ptr,&MyFunc,Ptr,Len,"Uint",0x40,PtrP,0)
				}OK:=DllCall(&MyFunc,"UInt",Info.3,"UInt",d.X,"UInt",d.Y,Ptr,&Scan,"Int",0,"Int",0,"Int",d.W,"Int",d.H,Ptr,&SS,"AStr",Bits,Ptr,&S1,Ptr,&S0,Ptr,&In,"Int",7,Ptr,&AllPos,"Int",Info.6),Arr:=[]
				Loop,%OK%{
					if(Arr.Count()>=b.Match)
						Break,3
					Arr.Push({X:(Pos:=NumGet(AllPos,4*(A_Index-1),"Int"))&0xFFFF,Y:Pos>>16,W:Info.1,H:Info.2,HWND:HWND,Action:Action})
				}Sleep,100
			}if(Arr.1)
				Break
			Sleep,100
		}if(b.Match="Return")
			return Arr
		if(!Arr.1){
			Error:="Unable to find the Pixel Group"
			Goto,PA_Exit
		}if(!Obj:=Arr[b.Match]){
			Error:="Unable to find the " b.Match " occurrence."
			Goto,PA_Exit
		}WinGetPos,X,Y,,,% "ahk_id" Obj.HWND
		if(b.Type="InsertText"){
			Pos:="x" Obj.X+Round(b.OffSetX)-X " y" Obj.Y+Round(b.OffSetY)-Y,CB:=ClipboardAll
			while(Clipboard!=b.Text){
				Clipboard:=b.Text
				Sleep,10
			}BlockInput,On
			ControlClick,%Pos%,% "ahk_id" Obj.HWND
			if(b.SelectAll){
				Sleep,50
				Send,^a
			}Sleep,50
			Send,^v
			BlockInput,Off
			Clipboard:=CB
			Sleep,100
		}else if(b.Type="Mouse"&&b.Action!="Move"){
					;********************restore mouse position***********************************
			if(b.RestorePOS)
				MouseGetPos,RestoreX,RestoreY
			if(b.Actual){
				MouseClick,Left,% Obj.X+Round(b.OffSetX),% Obj.Y+Round(b.OffSetY),% b.ClickCount ;Added b.clickcount by Joe as it was missing
				if(b.RestorePOS)
					MouseMove,% RestoreX,RestoreY ;change this to an if the thing was selected
			}else{
				Pos:="x" Obj.X+Round(b.OffSetX)-X " y" Obj.Y+Round(b.OffSetY)-Y
				ControlClick,%Pos%,% "ahk_id" Obj.HWND,,% b.Action,% b.ClickCount
			}
		}else if(b.Type="Mouse"&&b.Action="Move")
			MouseMove,% Obj.X+Round(b.OffSetX),% Obj.Y+Round(b.OffSetY)
	}
	PA_Exit:
	CoordMode,Mouse,%CoordMode%
	SetTitleMatchMode,%Mode%
	SetBatchLines,%BCH%
	if(A_ThisLabel="PA_Exit"){
		MsgBox,262144,Error,%Error%
		Exit
	}
	return "ahk_id" Obj.HWND
}
;~ To Here

Notify(Margin:=5){
	static Notify:=New NotifyClass()
	Notify.Margin:=Margin
	return Notify
}
Class NotifyClass{
	__New(Margin:=10){
		this.ShowDelay:=40,this.ID:=0,this.Margin:=Margin,this.Animation:={Bottom:0x00000008,Top:0x00000004,Left:0x00000001,Right:0x00000002,Slide:0x00040000,Center:0x00000010,Blend:0x00080000}
		if(!this.Init)
			OnMessage(0x201,NotifyClass.Click.Bind(this)),this.Init:=1
	}AddWindow(Text,Info:=""){
		(Info?Info:Info:=[])
		for a,b in {Background:0,Color:"0xAAAAAA",TitleColor:"0xAAAAAA",Font:"Consolas",TitleSize:12,TitleFont:"Consolas",Size:20,Font:"Consolas",IconSize:20}
			if(Info[a]="")
				Info[a]:=b
		if(!IsObject(Win:=NotifyClass.Windows))
			Win:=NotifyClass.Windows:=[]
		Hide:=0
		for a,b in StrSplit(Info.Hide,",")
			if(Val:=this.Animation[b])
				Hide|=Val
		Info.Hide:=Hide
		DetectHiddenWindows,On
		this.Hidden:=Hidden:=A_DetectHiddenWindows,this.Current:=ID:=++this.ID,Owner:=WinActive("A")
		Gui,Win%ID%:Default
		if(Info.Radius)
			Gui,Margin,% Floor(Info.Radius/3),% Floor(Info.Radius/3)
		Gui,-Caption +HWNDMain +AlwaysOnTop +Owner%Owner%
		Gui,Color,% Info.Background,% Info.Background
		NotifyClass.Windows[ID]:={ID:"ahk_id" Main,HWND:Main,Win:"Win" ID,Text:Text,Background:Info.Background,FlashColor:Info.FlashColor,Title:Info.Title,ShowDelay:Info.ShowDelay,Destroy:Info.Destroy}
		for a,b in Info
			NotifyClass.Windows[ID,a]:=b
		if((Ico:=StrSplit(Info.Icon,",")).1)
			Gui,Add,Picture,% (Info.IconSize?"w" Info.IconSize " h" Info.IconSize:""),% "HBITMAP:" LoadPicture(Foo:=(Ico.1+0?"Shell32.dll":Ico.1),Foo1:="Icon" (Ico.2!=""?Ico.2:Info.Icon),2)
		if(Info.Title){
			Gui,Font,% "s" Info.TitleSize " c" Info.TitleColor,% Info.TitleFont
			Gui,Add,Text,x+m,% Info.Title
		}Gui,Font,% "s" Info.Size " c" Info.Color,% Info.Font
		Gui,Add,Text,HWNDText,%Text%
		SysGet,Mon,MonitorWorkArea
		if(Info.Sound+0)
			SoundBeep,% Info.Sound
		if(FileExist(Info.Sound))
			SoundPlay,% Info.Sound
		this.MonBottom:=MonBottom,this.MonTop:=MonTop,this.MonLeft:=MonLeft,this.MonRight:=MonRight
		if(Info.Time){
			TT:=this.Dismiss.Bind({this:this,ID:ID})
			SetTimer,%TT%,% "-" Info.Time
		}if(Info.Flash){
			TT:=this.Flash.Bind({this:this,ID:ID})
			SetTimer,%TT%,% Info.Flash
			NotifyClass.Windows[ID].Timer:=TT
		}
		for a,b in StrSplit(Info.Buttons,","){
			Gui,Margin,% Info.Radius?Info.Radius/2:5,5
			Gui,Font,s10
			Gui,Add,Button,% (a=1?"xm":"x+m"),%b%
		}
		if(Info.Progress!=""){
			Gui,Win%ID%:Font,s4
			ControlGetPos,x,y,w,h,,ahk_id%Text%
			Gui,Add,Progress,w%w% HWNDProgress,% Info.Progress
			NotifyClass.Windows[ID].Progress:=Progress
		}Gui,Win%ID%:Show,Hide
		WinGetPos,x,y,w,h,ahk_id%Main%
		if(Info.Radius)
			WinSet, Region, % "0-0 w" W " h" H " R" Info.Radius "-" Info.Radius,ahk_id%Main%
		Obj:=this.SetPos(),Flags:=0
		for a,b in StrSplit(Info.Animate,",")
			Flags|=Round(this.Animation[b])
		DllCall("AnimateWindow","UInt",Main,"Int",(Info.ShowDelay?Info.ShowDelay:this.ShowDelay),"UInt",(Flags?Flags:0x00000008|0x00000004|0x00040000|0x00000002))
		for a,b in StrSplit((Obj.Destroy?Obj.Destroy:"Top,Left,Slide"),",")
			Flags|=Round(this.Animation[b])
		Flags|=0x00010000,NotifyClass.Windows[ID].Flags:=Flags
		DetectHiddenWindows,%Hidden%
		return ID
	}Click(){
		Obj:=NotifyClass.Windows[RegExReplace(A_Gui,"\D")],Obj.Button:=A_GuiControl,(Fun:=Func("Click"))?Fun.Call(Obj):"",this.Delete(A_Gui)
	}Delete(Win){
		Win:=RegExReplace(Win,"\D"),Obj:=NotifyClass.Windows[Win],NotifyClass.Windows.Delete(Win)
		if(WinExist("ahk_id" Obj.HWND)){
			DllCall("AnimateWindow","UInt",Obj.HWND,"Int",Obj.ShowDelay,"UInt",Obj.Flags)
			Gui,% Obj.Win ":Destroy"
		}if(TT:=Obj.Timer)
			SetTimer,%TT%,Off
		this.SetPos()
	}Dismiss(){
		this.this.Delete(this.ID)
	}Flash(){
		Obj:=NotifyClass.Windows[this.ID]
		Obj.Bright:=!Obj.Bright
		Color:=Obj.Bright?(Obj.FlashColor!=""?Obj.FlashColor:Format("{:06x}",Obj.Background+800)):Obj.Background
		if(WinExist(Obj.ID))
			Gui,% Obj.Win ":Color",%Color%,%Color%
	}SetPos(){
		Width:=this.MonRight-this.MonLeft,MH:=this.MonBottom-this.MonTop,MinX:=[],MinY:=[],Obj:=[],Height:=0,Sub:=0,MY:=MH,MaxW:={0:1},Delay:=A_WinDelay,Hidden:=A_DetectHiddenWindows
		DetectHiddenWindows,On
		SetWinDelay,-1
		for a,b in NotifyClass.Windows{
			WinGetPos,x,y,w,h,% b.ID
			Height+=h+this.Margin
			if(MH<=Height)
				Sub:=Width-MinX.MinIndex()+this.Margin,MY:=MH,MinY:=[],MinX:=[],Height:=h,MaxW:={0:1},Reset:=1
			MaxW[w]:=1,MinX[Width-w-Sub]:=1,MinY[MY:=MY-h-this.Margin]:=y,XPos:=MinX.MinIndex()+(Reset?0:MaxW.MaxIndex()-w)
			WinMove,% b.ID,,%XPos%,MinY.MinIndex()
			Obj[a]:={x:x,y:y,w:w,h:h},Reset:=0
		}DetectHiddenWindows,%Hidden%
		SetWinDelay,%Delay%
	}SetProgress(ID,Progress){
		GuiControl,,% NotifyClass.Windows[ID].Progress,%Progress%
	}
}