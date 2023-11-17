# The file is located at "$Env:Home\Documents\Powershell\Microsoft.PowerShell_profile.ps1".
#
# Execute `Set-ExecutionPolicy RemoteSigned` in "Windows PowerShell (Admin)" if permission denied.

function prompt {
  $Prefix = "PS " + ($Env:UserName.ToUpper()) + "@" + $Env:ComputerName
  $Prefix + " " + $Pwd + "> "
}

$Env:PATH = "$Env:UserProfile\tool\bin\Windows;$Env:UserProfile\tool\script\Windows;" + $Env:Path
