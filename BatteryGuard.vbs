' BatteryGuard.vbs
' Standalone battery monitor - no PowerShell execution policy needed
' Checks battery every 60 seconds and shows popup notifications

Dim LOW_THRESHOLD, HIGH_THRESHOLD, COOLDOWN_MINUTES
LOW_THRESHOLD = 40
HIGH_THRESHOLD = 80
COOLDOWN_MINUTES = 5

Dim lastLowNotif, lastHighNotif
lastLowNotif = 0
lastHighNotif = 0

Dim objShell, objWMI, colBattery, objBattery
Set objShell = CreateObject("WScript.Shell")
Set objWMI = GetObject("winmgmts:\\.\root\cimv2")

' Show startup message
objShell.Popup "BatteryGuard is now running!" & Chr(13) & Chr(13) & _
    "You'll be notified when battery:" & Chr(13) & _
    "  - Drops to " & LOW_THRESHOLD & "% (plug in)" & Chr(13) & _
    "  - Reaches " & HIGH_THRESHOLD & "% (unplug)" & Chr(13) & Chr(13) & _
    "This dialog will auto-close in 5 seconds.", 5, "BatteryGuard Started", 64

Do While True
    Set colBattery = objWMI.ExecQuery("SELECT * FROM Win32_Battery")
    
    For Each objBattery In colBattery
        Dim pct, isCharging
        pct = objBattery.EstimatedChargeRemaining
        ' BatteryStatus 2 = charging
        isCharging = (objBattery.BatteryStatus = 2)
        
        Dim nowTime
        nowTime = Now()
        
        ' LOW battery and NOT charging
        If pct <= LOW_THRESHOLD And Not isCharging Then
            Dim minsSinceLow
            If lastLowNotif = 0 Then
                minsSinceLow = COOLDOWN_MINUTES + 1
            Else
                minsSinceLow = DateDiff("n", lastLowNotif, nowTime)
            End If
            
            If minsSinceLow >= COOLDOWN_MINUTES Then
                objShell.Popup "Battery is at " & pct & "%!" & Chr(13) & Chr(13) & _
                    "Plug in your charger now before it dies.", 10, _
                    "🔋 LOW BATTERY — Plug In!", 48
                lastLowNotif = nowTime
            End If
        End If
        
        ' HIGH battery and IS charging
        If pct >= HIGH_THRESHOLD And isCharging Then
            Dim minsSinceHigh
            If lastHighNotif = 0 Then
                minsSinceHigh = COOLDOWN_MINUTES + 1
            Else
                minsSinceHigh = DateDiff("n", lastHighNotif, nowTime)
            End If
            
            If minsSinceHigh >= COOLDOWN_MINUTES Then
                objShell.Popup "Battery is at " & pct & "%!" & Chr(13) & Chr(13) & _
                    "Unplug your charger to protect battery health!", 10, _
                    "🔌 BATTERY AT 80% — Unplug!", 64
                lastHighNotif = nowTime
            End If
        End If
    Next
    
    ' Wait 60 seconds before checking again
    WScript.Sleep 60000
Loop
