# ⚡ Windows Productivity Scripts

Two lightweight Windows automation scripts to make your daily workflow smoother — no installs, no dependencies, just double-click and go.

---

## 📁 Scripts Overview

| Script | What It Does |
|---|---|
| `BatteryGuard.vbs` | Monitors battery and notifies you to plug in / unplug at custom thresholds |
| `MorningLauncher.vbs` | Opens all your daily apps and Chrome tabs in one click |

---

<br>

## 🔋 BatteryGuard

### What It Does
Runs silently in the background and sends popup notifications when:
- Battery drops to **40% or below** — reminds you to plug in
- Battery reaches **80% or above** — reminds you to unplug

This protects your battery health over time. Keeping lithium batteries between 40–80% significantly extends their lifespan.

### How to Run
1. Double-click `BatteryGuard.vbs`
2. A startup popup confirms it's running — auto-closes in 5 seconds
3. It runs silently in the background from that point on
4. Notifications appear as popup dialogs that stay for 10 seconds

### Auto-Start on Boot (Recommended)
To make BatteryGuard launch automatically every time you log in:

1. Press `Win + R`
2. Type `shell:startup` and hit **Enter**
3. A folder opens — copy a **shortcut** to `BatteryGuard.vbs` into that folder
4. Done — it will now start automatically on every login

### Customize Thresholds
Open `BatteryGuard.vbs` in Notepad and edit these lines near the top:

```vbs
LOW_THRESHOLD = 40     ' notify to plug in at this % or below
HIGH_THRESHOLD = 80    ' notify to unplug at this % or above
COOLDOWN_MINUTES = 5   ' minimum minutes between repeat notifications
```

### Stop the Script
Open **Task Manager** (`Ctrl + Shift + Esc`) and find `wscript.exe` and click **End Task**

### Troubleshooting

| Problem | Fix |
|---|---|
| No popup on startup | Make sure you're double-clicking the `.vbs` file, not opening it in an editor |
| Notifications not appearing | Check `Settings → System → Notifications` and make sure popups aren't blocked |
| Script stops after closing lid | Add a shortcut to `shell:startup` so it relaunches on login |
| Running on a desktop PC | The script will silently do nothing — it requires a battery to be present |

---

<br>

## 🚀 MorningLauncher

### What It Does
Opens your entire workspace in one double-click:
- **VS Code** — your code editor
- **Slack** — team communication
- **Google Chrome** — with LinkedIn, X, and YouTube pre-loaded as tabs

### How to Run
1. Double-click `MorningLauncher.vbs`
2. A startup popup lists what's about to open — auto-closes in 3 seconds
3. Apps launch one by one with a short delay between each
4. A "workspace ready" popup confirms everything launched

### App Paths (Pre-configured)
The script is already set up with these paths:

```
VS Code  →  D:\New folder (4)\Microsoft VS Code\Code.exe
Slack    →  C:\Users\adeel\AppData\Local\Microsoft\WindowsApps\Slack.exe
Chrome   →  C:\Program Files\Google\Chrome\Application\chrome.exe
```

If you ever reinstall an app, update the matching line in the script.

### Add More Chrome Tabs
Open `MorningLauncher.vbs` in Notepad and add new tab variables:

```vbs
Dim tab4, tab5
tab4 = "https://www.github.com"
tab5 = "https://www.gmail.com"
```

Then extend the `chromeCmd` line:

```vbs
chromeCmd = """" & chromePath & """ """ & tab1 & """ """ & tab2 & """ """ & tab3 & """ """ & tab4 & """ """ & tab5 & """"
```

### Add More Apps
To launch an additional app, add this block after the Slack section:

```vbs
Dim newAppPath
newAppPath = "C:\Path\To\YourApp.exe"

On Error Resume Next
objShell.Run """" & newAppPath & """", 1, False
If Err.Number <> 0 Then
    objShell.Popup "App not found at: " & newAppPath, 6, "App Not Found", 48
    Err.Clear
End If
On Error GoTo 0

WScript.Sleep 1500
```

### Finding an App's Exact Path
If an app isn't launching, find its exact path by:
1. Right-clicking the app's **desktop or taskbar icon**
2. Clicking **Properties**
3. Copying the **Target** field — that's the full path to use

Or run this in PowerShell to search automatically:
```powershell
Get-ChildItem "C:\Users\$env:USERNAME\AppData\Local" -Recurse -Filter "AppName.exe" -ErrorAction SilentlyContinue | Select-Object FullName
```

### Troubleshooting

| Problem | Fix |
|---|---|
| App shows "Not Found" popup | Update the path for that app in the script |
| Chrome opens but no tabs | Check that tab URLs start with `https://` |
| VS Code opens a terminal instead | Make sure path points to `Code.exe` not `code.cmd` |
| Want more delay between apps | Increase `WScript.Sleep 1500` (value is in milliseconds) |

---

<br>

## 🛠️ General Notes

- Both scripts are plain `.vbs` files — open and edit in any text editor (Notepad, VS Code, etc.)
- No installation required — uses built-in Windows scripting
- No internet connection needed
- No admin rights required
- To stop any running script: **Task Manager → wscript.exe → End Task**

---

## 📬 Ideas to Extend Further

- **BatteryGuard** — add a system tray icon using AutoHotkey for a more polished experience
- **MorningLauncher** — add a weekday check so it only opens certain apps Monday to Friday
- **Combine both** — one master launcher that starts BatteryGuard AND opens your workspace in a single double-click