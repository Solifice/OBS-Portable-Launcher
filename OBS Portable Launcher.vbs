'*******************************************************************************
' Script Name:   OBS Portable Launcher.vbs
' Version:       2.0
' Author:        Solifice
'*******************************************************************************

Option Explicit

' Entry point
Sub Main()
    Dim driveLetter, folderPath, obsAppPath, arguments, vbsScripts ' Configurable
    driveLetter = "O:"
    folderPath = "obs"
    obsAppPath = driveLetter & "\bin\64bit\obs64.exe"
    arguments = "-p"
    vbsScripts = Array("O:\Kill_adb.vbs") ' Can be empty
    
    If Not ValidateDriveLetter(driveLetter) Then Exit Sub
    If Not ValidateFolderPath(folderPath) Then Exit Sub

    If ConfirmMount(driveLetter, folderPath) Then
        If MountDrive(driveLetter, folderPath) Then
            If ValidateObsAppPath(obsAppPath) Then
                LaunchObs obsAppPath, arguments
				ExecuteVBSScripts vbsScripts
                UnmountDrive driveLetter
            End If
        End If
    End If
End Sub

' Function to validate if the drive letter is available
Function ValidateDriveLetter(driveLetter)
    Dim objFSO, objShell, intAnswer, result
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Set objShell = CreateObject("WScript.Shell")
    
    result = True

    If objFSO.DriveExists(driveLetter) Then
        ' Check if the drive is mapped by subst
        If IsSubstDrive(driveLetter) Then
            intAnswer = MsgBox("Drive letter " & driveLetter & " is already in use by a subst mapping." & vbCrLf & "Do you want to override it?", vbYesNo, "OBS Portable Launcher")
            If intAnswer = vbYes Then
                objShell.Run "subst " & driveLetter & " /D", 0, True
            Else
                result = False
            End If
        Else
            MsgBox "Drive letter " & driveLetter & " is already in use." & vbCrLf & vbCrLf & "Please choose another drive letter or disconnect the existing mapping." & vbCrLf & vbCrLf & "Then run the script again.", vbOKOnly, "OBS Portable Launcher"
            result = False
        End If
    End If

    ValidateDriveLetter = result
    Set objFSO = Nothing
    Set objShell = Nothing
End Function

' Function to check if a drive is mapped by subst
Function IsSubstDrive(driveLetter)
    Dim objShell, substOutput, result
    Set objShell = CreateObject("WScript.Shell")
    
    substOutput = objShell.Exec("cmd /c subst").StdOut.ReadAll()
    
    result = (InStr(substOutput, driveLetter) > 0)
    
    IsSubstDrive = result
    Set objShell = Nothing
End Function

' Function to validate if the folder path exists
Function ValidateFolderPath(folderPath)
    Dim objFSO
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    
    If Not objFSO.FolderExists(folderPath) Then
        MsgBox "OBS folder path " & """" & folderPath & """" & " does not exist." & vbCrLf & vbCrLf & "Please make sure the folder exists and try again.", vbOKOnly, "OBS Portable Launcher"
        ValidateFolderPath = False
    Else
        ValidateFolderPath = True
    End If

    Set objFSO = Nothing
End Function

' Function to confirm mount
Function ConfirmMount(driveLetter, folderPath)
    Dim intAnswer
    intAnswer = MsgBox("Do you want to mount " & folderPath & " as drive " & driveLetter & " ?", vbYesNo, "OBS Portable Launcher")
    
    If intAnswer = vbYes Then
        ConfirmMount = True
    Else
        ConfirmMount = False
    End If
End Function

' Function to mount the drive
Function MountDrive(driveLetter, folderPath)
    Dim objShell
    Set objShell = CreateObject("WScript.Shell")
    
    objShell.Run "subst " & driveLetter & " """ & folderPath & """", 0, True
    MountDrive = True

    Set objShell = Nothing
End Function

' Function to validate OBS application path
Function ValidateObsAppPath(obsAppPath)
    Dim objFSO
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    
    If Not objFSO.FileExists(obsAppPath) Then
        MsgBox "OBS application path " & """" & obsAppPath & """" & " does not exist.", vbOKOnly, "OBS Portable Launcher"
        ValidateObsAppPath = False
    Else
        ValidateObsAppPath = True
    End If

    Set objFSO = Nothing
End Function

' Subroutine to launch OBS
Sub LaunchObs(obsAppPath, arguments)
    Dim objShell, obsExeDirectoryPath
    Set objShell = CreateObject("WScript.Shell")
    
    obsExeDirectoryPath = Left(obsAppPath, InStrRev(obsAppPath, "\") - 1)
    objShell.CurrentDirectory = obsExeDirectoryPath
    objShell.Run """" & obsAppPath & """ " & arguments, 1, True
    
    Set objShell = Nothing
End Sub

' Subroutine to unmount the drive
Sub UnmountDrive(driveLetter)
    Dim objShell
    Set objShell = CreateObject("WScript.Shell")
    
    objShell.Run "subst " & driveLetter & " /D", 0, True
    MsgBox "Unmounted " & driveLetter & " successfully.", vbOKOnly, "OBS Portable Launcher"
    
    Set objShell = Nothing
End Sub

' Subroutine to execute additional VBS scripts
Sub ExecuteVBSScripts(vbsScripts)
    Dim objShell, objFSO, script, i
    Set objShell = CreateObject("WScript.Shell")
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    
    If UBound(vbsScripts) >= 0 Then
        For i = LBound(vbsScripts) To UBound(vbsScripts)
            script = vbsScripts(i)
            If objFSO.FileExists(script) Then
                objShell.Run """" & script & """", 0, True
            Else
                MsgBox "Script path " & """" & script & """" & " does not exist.", vbOKOnly, "OBS Portable Launcher"
            End If
        Next
    End If
    
    Set objShell = Nothing
    Set objFSO = Nothing
End Sub

' Start Execution
Main
