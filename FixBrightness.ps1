Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# exe のあるフォルダを取得
$exePath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
$baseDir = [System.IO.Path]::GetDirectoryName($exePath)
$batPath = Join-Path $baseDir "Restart.bat"

# Tray menu
$iconObj = [System.Drawing.Icon]::ExtractAssociatedIcon($exePath)
$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Icon = $iconObj
$notify.Text = "Fix Brightness"
$notify.Visible = $true

# Menu
$menu = New-Object System.Windows.Forms.ContextMenuStrip
$fixItem = $menu.Items.Add("Fix Brightness")
$exitItem = $menu.Items.Add("Exit")

# Fix Brightness 
$fixItem.Add_Click({
    if (-not (Test-Path $batPath)) {
        [System.Windows.Forms.MessageBox]::Show(
            "restart.bat が見つかりません:`n$batPath",
            "Error",
            "OK",
            "Error"
        )
        return
    }

    Start-Process -FilePath $batPath -Verb RunAs
})

# Exit
$exitItem.Add_Click({
    $notify.Visible = $false
    [System.Windows.Forms.Application]::Exit()
})

$notify.ContextMenuStrip = $menu

[System.Windows.Forms.Application]::Run()
