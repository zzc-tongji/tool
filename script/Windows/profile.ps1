# %HOMEPATH%\Documents\WindowsPowerShell\profile.ps1

# Install-Module -Name posh-git
Import-Module posh-git

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
(& "C:\ProgramData\Anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion
