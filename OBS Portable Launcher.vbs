'*******************************************************************************
' Script Name:   OBS Portable Launcher.vbs
' Version:       1.2
' Author:        Solifice
'*******************************************************************************

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Drive letter you want to set (Configurable)
driveLetter = "O:"

' Path to your folder to mount as driveLetter (Configurable)
folderPath = "obs"

' Path to your OBS executable (Configurable)
obsAppPath = driveLetter & "\bin\64bit\obs64.exe"

' Arguments for your OBS executable (Configurable) (Advance) (-p is mandatory to start obs executable in portable mode)
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
