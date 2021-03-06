ipconfig
Write-Host
Invoke-WebRequest 'https://ifconfig.co/json' | Select-Object -Expand Content
