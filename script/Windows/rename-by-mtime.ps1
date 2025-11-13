param(
  [string]$TZ
)

if ($TZ) {
  if ($TZ -eq "-h" -or $TZ -eq "--help") {
    Write-Host "Usage: rename-by-mtime.ps1 [-h|--help] => Show help info."
    Write-Host "   or: rename-by-mtime.ps1             => Rename all file(s) in current directory as 'yyyyMMdd_HHmmss_fff' with UTC time zone"
    Write-Host "   or: rename-by-mtime.ps1 <TZ>        => Rename all file(s) in current directory as 'yyyyMMdd_UTCzzz_HHmmss_fff' with time zone <TZ> (https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)."
    Write-Host ""
    exit
  }
  $prompt = "Rename all file(s) in current directory as 'yyyyMMdd_UTCzzz_HHmmss_fff' (TZ=$TZ). Continue? <y/n>"
}
else {
  $prompt = "Rename all file(s) in current directory as 'yyyyMMdd_HHmmss_fff' (TZ=UTC). Continue? <y/n>"
}

Write-Host $prompt
$answer = Read-Host
if ($answer -notin @("y", "Y", "yes", "YES")) {
  exit 1
}

$files = Get-ChildItem
foreach ($f in $files) {
  $extension = $f.Extension
  if ($TZ) {
    # Set timezone context for the date conversion
    $targetTZ = [System.TimeZoneInfo]::FindSystemTimeZoneById($TZ)
    $utcTime = $f.LastWriteTime.ToUniversalTime()
    $localTime = [System.TimeZoneInfo]::ConvertTimeFromUtc($utcTime, $targetTZ)
    #
    $offset = $targetTZ.GetUtcOffset($localTime)
    $offsetString = if ($offset -ge [TimeSpan]::Zero) { 
      "+{0:hhmm}" -f $offset 
    }
    else { 
      "-{0:hhmm}" -f $offset.Negate() 
    }
    #
    $n = "{0:yyyyMMdd}_UTC{1}_{0:HHmmss_fff}" -f $localTime, $offsetString
  }
  else {
    # Use UTC timezone
    $utcTime = $f.LastWriteTime.ToUniversalTime()
    $n = "{0:yyyyMMdd}_{0:HHmmss}_{0:fff}" -f $utcTime
  }
  if ($extension) {
    $n = $n + $extension
  }     
  Rename-Item -Path $f.Name -NewName $n -Force
  Write-Host "$($f.Name) => $n"
}
Write-Host "Done."
