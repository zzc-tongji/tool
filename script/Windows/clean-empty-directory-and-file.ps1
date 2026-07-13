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

$emptyFiles = Get-ChildItem $path -File -Recurse -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.Length -eq 0 }

# ============ Preview ============

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Previewing items to be deleted..." -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

if ($emptyFiles) {
    Write-Host "--- Empty Files (0 bytes) ---" -ForegroundColor Yellow
    $emptyFiles | ForEach-Object { Write-Host "  $(Get-RelativePath $_.FullName $path)" }
    Write-Host ""
} else {
    Write-Host "No empty files found." -ForegroundColor Green
    Write-Host ""
}

if ($emptyFolders) {
    Write-Host "--- Empty Folders (sorted deep-to-shallow) ---" -ForegroundColor Yellow
    $emptyFolders | ForEach-Object { Write-Host "  $($_.Display)" }
    Write-Host ""
} else {
    Write-Host "No empty folders found." -ForegroundColor Green
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Empty files:   $($emptyFiles.Count)" -ForegroundColor Yellow
Write-Host "  Empty folders: $($emptyFolders.Count)" -ForegroundColor Yellow
Write-Host "========================================`n" -ForegroundColor Cyan

$response = Read-Host "Delete all items above? (Y/N)"

if ($response -ne "Y" -and $response -ne "y") {
    Write-Host "Cancelled." -ForegroundColor Red
    exit
}

# ============ Delete ============

$emptyFiles | ForEach-Object {
    try { Remove-Item $_.FullName -Force -ErrorAction Stop; Write-Host "Deleted file: $(Get-RelativePath $_.FullName $path)" -ForegroundColor Green } catch {}
}

$emptyFolders | Sort-Object Depth -Descending | ForEach-Object {
    try { Remove-Item $_.Path -Force -Recurse -ErrorAction Stop; Write-Host "Deleted folder: $($_.Display)" -ForegroundColor Green } catch {}
}

Write-Host "`nDone." -ForegroundColor Cyan
