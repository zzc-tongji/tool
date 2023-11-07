cd /d %userprofile%\AppData\Local
del IconCache.db /a
pause
taskkill /f /im explorer.exe
start explorer.exe
pause
exit
