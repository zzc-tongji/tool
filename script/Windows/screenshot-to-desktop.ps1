$ErrorActionPreference = "Stop"
#
Add-Type -AssemblyName System.Windows.Forms
$screen = [System.Windows.Forms.Screen]::PrimaryScreen
$bitmap = New-Object System.Drawing.Bitmap $screen.Bounds.Width, $screen.Bounds.Height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($screen.Bounds.X, $screen.Bounds.Y, 0, 0, $bitmap.Size)
$time = Get-Date -Format "yyyyMMdd_HHmmss_fff"
$bitmap.Save("$env:USERPROFILE\Desktop\$time.png")
$graphics.Dispose()
$bitmap.Dispose()
