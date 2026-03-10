' MorningLauncher.vbs
' Opens all your daily apps and Chrome tabs in one double-click

Dim objShell
Set objShell = CreateObject("WScript.Shell")

' ============================================================
'  APP PATHS
' ============================================================
Dim vscodePath, slackPath, chromePath
vscodePath = "D:\New folder (4)\Microsoft VS Code\Code.exe"
slackPath  = "C:\Users\adeel\AppData\Local\Microsoft\WindowsApps\Slack.exe"
chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"

' ============================================================
'  CHROME TABS — add tab4, tab5 etc to extend
' ============================================================
Dim tab1, tab2, tab3
tab1 = "https://www.linkedin.com"
tab2 = "https://www.x.com"
tab3 = "https://www.youtube.com"

' ============================================================
'  STARTUP MESSAGE
' ============================================================
objShell.Popup "Good morning! Launching your workspace..." & Chr(13) & Chr(13) & "Apps:  VS Code, Slack, Chrome" & Chr(13) & "Tabs:  LinkedIn, X, YouTube" & Chr(13) & Chr(13) & "Auto-closes in 3 seconds.", 3, "Morning Launcher", 64

' ============================================================
'  LAUNCH VS CODE
' ============================================================
On Error Resume Next
objShell.Run """" & vscodePath & """", 1, False
If Err.Number <> 0 Then
    objShell.Popup "VS Code not found at: " & vscodePath, 6, "VS Code Not Found", 48
    Err.Clear
End If
On Error GoTo 0

WScript.Sleep 1500

' ============================================================
'  LAUNCH SLACK
' ============================================================
On Error Resume Next
objShell.Run """" & slackPath & """", 1, False
If Err.Number <> 0 Then
    objShell.Popup "Slack not found at: " & slackPath, 6, "Slack Not Found", 48
    Err.Clear
End If
On Error GoTo 0

WScript.Sleep 1500

' ============================================================
'  LAUNCH CHROME WITH ALL TABS
' ============================================================
Dim chromeCmd
chromeCmd = """" & chromePath & """ """ & tab1 & """ """ & tab2 & """ """ & tab3 & """"

On Error Resume Next
objShell.Run chromeCmd, 1, False
If Err.Number <> 0 Then
    Err.Clear
    chromePath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
    chromeCmd = """" & chromePath & """ """ & tab1 & """ """ & tab2 & """ """ & tab3 & """"
    objShell.Run chromeCmd, 1, False
    If Err.Number <> 0 Then
        objShell.Popup "Chrome not found. Check chromePath in the script.", 5, "Chrome Not Found", 48
        Err.Clear
    End If
End If
On Error GoTo 0

WScript.Sleep 500

objShell.Popup "All done! Your workspace is ready.", 3, "Morning Launcher", 64

Set objShell = Nothing
