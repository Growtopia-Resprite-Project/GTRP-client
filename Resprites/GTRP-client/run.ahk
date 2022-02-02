#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%\..\..

FileCopyDir, %A_ScriptDir%, %A_WorkingDir%\, true
FileCopyDir, %A_ScriptDir%, %A_WorkingDir%\cache, true
FileCopyDir, %A_ScriptDir%, %A_WorkingDir%\Resprites\cache, true

FileAppend, , %A_WorkingDir%\Resprites\switch\interface-large