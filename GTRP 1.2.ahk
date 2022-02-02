#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\vCache\RunAsTask.ahk
#SingleInstance Off
DetectHiddenWindows, On
ver := "1.2"
global text := ["", "", ""]
global epoint := 3

RunAsTask()
Gosub, setgui

gtext("Growtopia Resprite Project Client", false)
gtext("Made by SadFaceMan", false)
gtext("Version " . ver . " | Initializing...", true)
Sleep, 2000
gblank("clear", 0)

ifWinExist, Growtopia ahk_class AppClass
{
	if FileExist(A_WorkingDir . "\Resprites\switch\*")
	{
		gtext("GTRP Client is already running!", true)
		gtext("Reloading cache...", true)
		Sleep, 1000
		Gosub, cleanvcache
		Gosub, cleancache
		Gosub, loadcache
		Gosub, loadresprite
		Gosub, loadvcache
		Gosub, fdelrun
		GuiControl,,GUI,Sprites reloaded! Closing...
		Sleep, 1500
		ExitApp
	}
	else
	{
		gtext("Growtopia is already running!", true)
		gtext("Closing Growtopia...", true)
		Sleep, 1000
		WinClose, Growtopia ahk_class AppClass
	}
	
}

if FileExist(A_WorkingDir . "\Resprites\switch\*")
{
	gtext("Cleaning leftover files...", true)
	Sleep, 1000
	Gosub, cleanvcache
	Gosub, cleancache
}

Gosub, loadcache
Gosub, loadresprite
Gosub, loadvcache
Gosub, fdelrun

gtext("Loading Growtopia...", true)
Sleep, 1000
Gui, Destroy
gblank("clear", 0)
RunWait, Growtopia.exe, %A_WorkingDir%

Gosub, setgui
Gosub, cleanvcache
Gosub, cleancache

gtext("Growtopia Resprites Project Client", false)
gtext("Made by SadFaceMan", false)
gtext("Version " . ver . " | Closing...", true)
Sleep, 2000
ExitApp

Return

loadresprite:
gtext("Loading resprites...", true)
Sleep, 600
Loop, Files, %A_WorkingDir%\Resprites\*.ahk, R
{
	RegExMatch(A_LoopFilePath, "(.+\\\K|^)[^\\]+(?=\\)" ,m)
	gtext("Loading " . m . "...", true)
	RunWait, run.ahk, %A_LoopFileDir%
	gedit("Loading " . m . "... Done!", true)
	Sleep, 300
}
Return

loadcache:
gtext("Loading cache...", true)
Sleep, 600
FileCreateDir, %A_WorkingDir%\Resprites\cache\ 
FileCreateDir, %A_WorkingDir%\Resprites\switch\
FileCopyDir, %A_WorkingDir%\cache\, %A_WorkingDir%\Resprites\cache\, true
Return

loadvcache:
gtext("Loading vCache...", true)
Sleep, 600
Loop, Files, %A_WorkingDir%\Resprites\switch\*, R
{
	FName := RegExReplace(A_LoopFileName, "-", "\")
	FileRead, Part1, %A_WorkingDir%\vCache\Part1
	FileRead, Part2, %A_WorkingDir%\vCache\Part2
	FullPart := Part1 . "cache\" . FName . Part2
	FileAppend, %FullPart%, %A_WorkingDir%\vCache_%A_LoopFileName%.ahk
	FRun := "vCache_" . A_LoopFileName . ".ahk"
	gtext("Loading " . FRun . "...", true)
	Run, %FRun%, %A_WorkingDir%
	gedit("Loading " . FRun . "... Done!", true)
	Sleep, 300
}
Return

cleancache:
gtext("Cleaning cache...", true)
Sleep, 600
FileRemoveDir, %A_WorkingDir%\Resprites\cache\, 1
FileRemoveDir, %A_WorkingDir%\Resprites\switch\, 1
FileCopy, %A_WorkingDir%\vCache\game_title.rttex, %A_WorkingDir%\interface\large\game_title.rttex, true
Return

cleanvcache:
gtext("Cleaning vCache...", true)
Sleep, 600
Loop, Files, %A_WorkingDir%\Resprites\switch\*, R
{
	FDel := "vCache_" . A_LoopFileName . ".ahk"
	gtext("Closing " . FDel . "...", true)
	WinClose, %A_WorkingDir%\%FDel% ahk_class AutoHotkey
	FileDelete, %A_WorkingDir%\%FDel%
	gedit("Closing " . FDel . "... Done!", true)
	Sleep, 300
}
return

fdelrun:
FileDelete, %A_WorkingDir%\run.ahk
FileDelete, %A_WorkingDir%\cache\run.ahk
Return

setgui:
Gui, Font, c00FF00 s12, Lucida Console
Gui, Color, 000000
Global tpad := ""
Loop, 6
{
	tpad := tpad . ".........."
}
Gui, Add, Text, vgtext3, %tpad%
Gui, Add, Text, vgtext2, %tpad%
Gui, Add, Text, vgtext1, %tpad%
GuiControl, +Center, gtext3
GuiControl, +Center, gtext2
GuiControl, +Center, gtext1
Gui, Show, Center, %gtrp%
return

guidisplay:
text3 := text[3]
text2 := text[2]
text1 := text[1]
GuiControl, , gtext3, %text3%
GuiControl, , gtext2, %text2%
GuiControl, , gtext1, %text1%
return

gtext(ntext, isdisplay)
{
	if (!ntext)
		ntext := " "
	pointer := 3
	loop, 4
	{
		if(!pointer) 
		{
			text[3] := text[2]
			text[2] := text[1]
			text[1] := ntext
			epoint := 1
			break
		}
		if(!text[pointer])
		{
			text[pointer] := ntext
			epoint := pointer
			break
		}
		pointer--
	}
	if (isdisplay)
	{
		Gosub, guidisplay
	}
}
return

gedit(ntext, isdisplay)
{
	text[epoint] := ntext
	if (isdisplay)
	{
		Gosub, guidisplay
	}
}
return

gblank(bmotion, bdelay)
{
	if(bmotion = "down")
	{	
		pointer := 3
		loop, 3
		{
			text[pointer] := ""
			Gosub, guidisplay
			Sleep, %bdelay%
			pointer--
		}
	}
	else if(bmotion = "down")
	{	
		pointer := 1
		loop, 3
		{
			text[pointer] := ""
			Gosub, guidisplay
			Sleep, %bdelay%
			pointer++
		}
	}
	else 
	{
		gblank("down", 0)
	}
	epoint := 3
}
return
