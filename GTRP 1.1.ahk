#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
#Include %A_ScriptDir%\vCache\RunAsTask.ahk
gtrp := "GTRP Client 1.1"

RunAsTask()

Gui, Add, Text, vGUI, ......................................................................................................................................................
GuiControl,,GUI, Growtopia Resprites Project Client - by SadFaceMan | Initializing...
Gui, Show, Center W400, %gtrp%
Sleep, 2000

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
	; A_LoopFileName = interface-large-store_buttons
	FName := RegExReplace(A_LoopFileName, "-", "\")
	; A_LoopFileName = interface\large\store_buttons
	FileRead, Part1, %A_WorkingDir%\vCache\Part1
	FileRead, Part2, %A_WorkingDir%\vCache\Part2
	FullPart := Part1 . "cache\" . FName . Part2
	FileAppend, %FullPart%, %A_WorkingDir%\vCache_%A_LoopFileName%.ahk
	FRun := "vCache_" . A_LoopFileName . ".ahk"
	Run, %FRun%, %A_WorkingDir%
}

FileDelete, %A_WorkingDir%\run.ahk
FileDelete, %A_WorkingDir%\cache\run.ahk

GuiControl,,GUI,Loading Growtopia...
Gui, Destroy
RunWait, Growtopia.exe, %A_WorkingDir%

Gui, Add, Text, vGUI, ......................................................................................................................................................
GuiControl,,GUI, Closing vCache...
Gui, Show, Center W400, %gtrp%

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

GuiControl,,GUI, Growtopia Resprites Project Client - by SadFaceMan... | Closing...
Sleep, 1500
ExitApp