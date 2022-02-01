#NoEnv
SendMode Input
#Persistent
#SingleInstance Force
SetWorkingDir, %A_ScriptDir_%

ViewType := "\cache\game\"
global FolderPath := A_WorkingDir . ViewType
global RFolderPath := A_WorkingDir . "\Resprites" . ViewType
interval := 0.1

SetFileMonitoring(FolderPath, interval)
SetFileMonitoring(FolderPath, interval)  {
	static winmgmts := ComObjGet("winmgmts:"), createSink
	SplitPath, FolderPath,,,,, Drive
	Folder := RegExReplace(FolderPath, "[A-Z]:\\|((?<!\\)\\(?!\\)|(?<!\\)$)", "\\")
	ComObjConnect(createSink := ComObjCreate("WbemScripting.SWbemSink"), "FileEvent_")
	winmgmts.ExecNotificationQueryAsync(createSink
		, "Select * From __InstanceOperationEvent"
		. " within " interval
		. " Where Targetinstance Isa 'CIM_DataFile'"
		. " And TargetInstance.Drive='" Drive "'"
		. " And TargetInstance.Path='" Folder "'")
}
   
FileEvent_OnObjectReady(objEvent)
{
	if (objEvent.Path_.Class = "__InstanceModificationEvent")
		Sleep, 1
		Loop, 10
		{
			FileCopyDir, %RFolderPath%, %FolderPath%, true
			Sleep, 100
		}
		Sleep, 10
		Reload
	}
Return