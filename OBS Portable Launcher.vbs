Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Drive letter you want to set (Configurable)
driveLetter = "O:"

' Path to your folder to mount as driveLetter (Configurable)
folderPath = "obs"

' Path to your OBS executable (Configurable)
obsAppPath = driveLetter & "\bin\64bit\obs64.exe"

' Arguments for your OBS executable
arguments = "-p"

' Check if drive letter is available
If objFSO.DriveExists(driveLetter) Then
    MsgBox "Drive letter " & driveLetter & " is already in use." & vbCrLf & vbCrLf & "Please choose another drive letter or disconnect the existing mapping." & vbCrLf & vbCrLf & "Then run the script again.", vbOKOnly, "OBS Portable Launcher"
	Cleanup()
    WScript.Quit
End If

' Check if folder path exists
If Not objFSO.FolderExists(folderPath) Then
    MsgBox "OBS folder path " & """" & folderPath & """" & " does not exist." & vbCrLf & vbCrLf & "Please make sure the folder exists and try again.", vbOKOnly, "OBS Portable Launcher"
	Cleanup()
    WScript.Quit
End If

intAnswer = MsgBox("Do you want to mount " & folderPath & " as drive " & driveLetter & " ?", vbYesNo, "OBS Portable Launcher")

If intAnswer = vbYes Then
    ' Execute the subst command
    objShell.Run "subst " & driveLetter & " """ & folderPath & """", 0, True
	
	If Not objFSO.FileExists(obsAppPath) Then
		MsgBox "OBS application path " & """" & obsAppPath & """" & " does not exist.", vbOKOnly, "OBS Portable Launcher"
		RemoveSubst()
		Cleanup()
		WScript.Quit
	End If
    
	' Path to your OBS executable directory
	obsExeDirectoryPath = Left(obsAppPath, InStrRev(obsAppPath, "\") - 1)
	
	' Change directory
	objShell.CurrentDirectory = obsExeDirectoryPath

	' Launch OBS
	objShell.Run """" & obsAppPath & """ " & arguments, 1, True
	
	' Wait for OBS to close using WMI event subscription
	WaitForProcessTermination Mid(obsAppPath, InStrRev(obsAppPath, "\") + 1)
	
	RemoveSubst()
	Cleanup()
End If

' Remove the substituted drive letter and notify after OBS is terminated
Sub RemoveSubst()
	objShell.Run "subst " & driveLetter & " /D", 0, True
	MsgBox "Unmounted " & driveLetter & " successfully.", vbOKOnly, "OBS Portable Launcher"
End Sub

' Clean up
Sub Cleanup()
    Set objShell = Nothing
    Set objFSO = Nothing
End Sub

' Function to wait for process termination using WMI event subscription
Sub WaitForProcessTermination(processName)
    Dim objWMIService, colEvents, objEvent
    Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
    Set colEvents = objWMIService.ExecNotificationQuery("SELECT * FROM __InstanceDeletionEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_Process' AND TargetInstance.Name = '" & processName & "'")

    ' Wait for process termination event
    Do
        On Error Resume Next
        Set objEvent = colEvents.NextEvent
        On Error GoTo 0

        If Not objEvent Is Nothing Then Exit Do
        WScript.Sleep 100  ' Wait for a short time before trying again
    Loop

    Set objWMIService = Nothing
    Set colEvents = Nothing
    Set objEvent = Nothing
End Sub

