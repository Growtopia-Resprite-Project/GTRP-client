#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
gtrp := "GTRP Client 1.0"

Gui, Add, Text, vGUI, ......................................................................................................................................................
GuiControl,,GUI, Growtopia Resprites Project Client - by SadFaceMan
Gui, Show, Center W600, %gtrp%
Sleep,2000

GuiControl,,GUI,Writing cache...
FileCreateDir, %A_WorkingDir%\Resprites\cache\ 
FileCreateDir, %A_WorkingDir%\Resprites\switch\
FileCopyDir, %A_WorkingDir%\cache\, %A_WorkingDir%\Resprites\cache\, true

GuiControl,,GUI,Loading:Reprites
Loop, Files, %A_WorkingDir%\Resprites\*.ahk, R
{
	Run, run.ahk, %A_LoopFileDir%
	RegExMatch(A_LoopFilePath, "(.+\\\K|^)[^\\]+(?=\\)" ,m)
	GuiControl,,GUI,Loading:%m%
	Sleep, 1000
}

GuiControl,,GUI,Loading vCache...
Loop, Files, %A_WorkingDir%\Resprites\switch\*, R
{
	FRun := "vCache_" . A_LoopFileName . ".ahk"
	FileCopy, %A_WorkingDir%\vCache\%FRun%, %A_WorkingDir%\%FRun%, true
	Run, %FRun%, %A_WorkingDir%
}

GuiControl,,GUI,Loading Growtopia...
Gui, Destroy
RunWait, Growtopia.exe, %A_WorkingDir%

Gui, Add, Text, vGUI, ......................................................................................................................................................
GuiControl,,GUI, Closing vCache...
Gui, Show, Center W600, %gtrp%

DetectHiddenWindows, On
Loop, Files, %A_WorkingDir%\Resprites\switch\*, R
{
	FDel := "vCache_" . A_LoopFileName . ".ahk"
	FileCopy, %A_WorkingDir%\vCache\%FRun%, %A_WorkingDir%\%FRun%, true
	WinClose, %A_WorkingDir%\%FRun% ahk_class AutoHotkey
	FileDelete, %A_WorkingDir%\%FRun%
}

GuiControl,,GUI, Cleaning cache...
FileRemoveDir, %A_WorkingDir%\Resprites\cache\, 1
FileRemoveDir, %A_WorkingDir%\Resprites\switch\, 1
FileDelete, %A_WorkingDir%\run.ahk
FileDelete, %A_WorkingDir%\cache\run.ahk

GuiControl,,GUI, Growtopia Resprites Project Client - by SadFaceMan...
Sleep, 1500
ExitApp