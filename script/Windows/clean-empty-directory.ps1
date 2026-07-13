$path = "."

function Get-RelativePath {
    param([string]$FullPath, [string]$BasePath)
    $base = (Resolve-Path $BasePath).Path.TrimEnd('\')
    $FullPath.TrimStart("$base\").Replace('\', '/')
}

function Test-IsEmptyFolder {
    param([System.IO.DirectoryInfo]$Dir)
    try {
        return $Dir.GetFileSystemInfos().Count -eq 0
    } catch {
        return $false
    }
}

# ============ Single-pass scan ============

$allDirs = Get-ChildItem $path -Directory -Recurse -Force -ErrorAction SilentlyContinue
$emptyFolders = @()

foreach ($d in $allDirs) {
    if (Test-IsEmptyFolder $d) {
        $rel = Get-RelativePath $d.FullName $path
        $depth = ($rel -split '/').Count
        $emptyFolders += [PSCustomObject]@{ Path = $d.FullName; Depth = $depth; Display = $rel }
    }
}

# ============ Preview ============

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Previewing empty folders to delete..." -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

if ($emptyFolders) {
    Write-Host "--- Empty Folders (sorted deep-to-shallow) ---" -ForegroundColor Yellow
    $emptyFolders | ForEach-Object { Write-Host "  $($_.Display)" }
    Write-Host ""
} else {
    Write-Host "No empty folders found." -ForegroundColor Green
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Total empty folders: $($emptyFolders.Count)" -ForegroundColor Yellow
Write-Host "========================================`n" -ForegroundColor Cyan

$response = Read-Host "Delete all folders above? (Y/N)"

if ($response -ne "Y" -and $response -ne "y") {
    Write-Host "Cancelled." -ForegroundColor Red
    exit
}

# ============ Delete (deep-to-shallow) ============

$emptyFolders | Sort-Object Depth -Descending | ForEach-Object {
    try { Remove-Item $_.Path -Force -Recurse -ErrorAction Stop; Write-Host "Deleted: $($_.Display)" -ForegroundColor Green } catch {}
}

Write-Host "`nDone." -ForegroundColor Cyan
