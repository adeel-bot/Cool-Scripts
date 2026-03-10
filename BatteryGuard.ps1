# BatteryGuard.ps1
# Monitors battery and sends Windows toast notifications
# Notify to plug in at 40%, notify to unplug at 80%

$LOW_THRESHOLD = 40
$HIGH_THRESHOLD = 80

# Notification cooldown tracking (avoid spamming)
$lastLowNotif = [DateTime]::MinValue
$lastHighNotif = [DateTime]::MinValue
$COOLDOWN_MINUTES = 5

function Send-ToastNotification {
    param(
        [string]$Title,
        [string]$Message,
        [string]$Icon  # "warning" or "info"
    )

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $template = @"
<toast duration="long">
    <visual>
        <binding template="ToastGeneric">
            <text>$Title</text>
            <text>$Message</text>
        </binding>
    </visual>
    <audio src="ms-winsoundevent:Notification.Default"/>
</toast>
"@

    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml($template)

    $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
    $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("BatteryGuard")
    $notifier.Show($toast)
}

function Get-BatteryStatus {
    $battery = Get-WmiObject -Class Win32_Battery
    if ($battery) {
        return @{
            Percent     = $battery.EstimatedChargeRemaining
            IsCharging  = ($battery.BatteryStatus -eq 2)
            IsConnected = ($battery.BatteryStatus -ne 1)
        }
    }
    return $null
}

Write-Host "BatteryGuard is running..." -ForegroundColor Green
Write-Host "Low threshold:  $LOW_THRESHOLD% (plug in reminder)" -ForegroundColor Yellow
Write-Host "High threshold: $HIGH_THRESHOLD% (unplug reminder)" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop." -ForegroundColor Gray
Write-Host ""

while ($true) {
    $status = Get-BatteryStatus
    $now = Get-Date

    if ($status) {
        $pct = $status.Percent
        $charging = $status.IsCharging

        Write-Host "[$($now.ToString('HH:mm:ss'))] Battery: $pct% | Charging: $charging" -ForegroundColor DarkGray

        # LOW battery — not charging — remind to plug in
        if ($pct -le $LOW_THRESHOLD -and -not $charging) {
            $minutesSinceLast = ($now - $lastLowNotif).TotalMinutes
            if ($minutesSinceLast -ge $COOLDOWN_MINUTES) {
                Write-Host "  ⚡ LOW BATTERY — Sending plug-in reminder!" -ForegroundColor Red
                Send-ToastNotification `
                    -Title "🔋 Plug in your charger!" `
                    -Message "Battery is at $pct%. Connect your charger now before it dies."
                $lastLowNotif = $now
            }
        }

        # HIGH battery — currently charging — remind to unplug
        if ($pct -ge $HIGH_THRESHOLD -and $charging) {
            $minutesSinceLast = ($now - $lastHighNotif).TotalMinutes
            if ($minutesSinceLast -ge $COOLDOWN_MINUTES) {
                Write-Host "  🔌 HIGH BATTERY — Sending unplug reminder!" -ForegroundColor Cyan
                Send-ToastNotification `
                    -Title "🔌 Unplug your charger!" `
                    -Message "Battery is at $pct%. Unplug now to protect battery health!"
                $lastHighNotif = $now
            }
        }
    } else {
        Write-Host "No battery detected (desktop PC?)" -ForegroundColor DarkYellow
    }

    # Check every 60 seconds
    Start-Sleep -Seconds 60
}
