# ANUBIS Windows PowerShell Launcher
# This script helps run ANUBIS on Windows

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    ANUBIS - Windows Launcher" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if PHP is installed
Write-Host "[*] Checking for PHP..." -ForegroundColor Yellow
try {
    $phpVersion = php --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[+] PHP is installed" -ForegroundColor Green
        Write-Host $phpVersion[0] -ForegroundColor Gray
    } else {
        throw "PHP not found"
    }
} catch {
    Write-Host "[!] PHP is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install PHP first:" -ForegroundColor Yellow
    Write-Host "1. Install via Chocolatey: choco install php -y" -ForegroundColor White
    Write-Host "2. OR download from: https://windows.php.net/download/" -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# Check for Git Bash or WSL
Write-Host ""
Write-Host "[*] Checking for Bash environment..." -ForegroundColor Yellow

$bashPath = $null
$useWSL = $false

# Check for WSL
try {
    $wslCheck = wsl --status 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[+] WSL detected" -ForegroundColor Green
        $useWSL = $true
    }
} catch {}

# Check for Git Bash
if (-not $useWSL) {
    $gitBashPaths = @(
        "C:\Program Files\Git\bin\bash.exe",
        "C:\Program Files (x86)\Git\bin\bash.exe",
        "$env:LOCALAPPDATA\Programs\Git\bin\bash.exe"
    )
    
    foreach ($path in $gitBashPaths) {
        if (Test-Path $path) {
            $bashPath = $path
            Write-Host "[+] Git Bash found at: $path" -ForegroundColor Green
            break
        }
    }
}

if (-not $useWSL -and -not $bashPath) {
    Write-Host "[!] Neither WSL nor Git Bash found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install one of the following:" -ForegroundColor Yellow
    Write-Host "1. Git Bash: https://git-scm.com/download/win" -ForegroundColor White
    Write-Host "2. WSL: Run 'wsl --install' in PowerShell as Administrator" -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# Run ANUBIS
Write-Host ""
Write-Host "[*] Starting ANUBIS..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Use the script's directory as the base path
$scriptPath = $PSScriptRoot
Set-Location $scriptPath
$currentDir = Get-Item $scriptPath

if ($useWSL) {
    # Convert Windows path to WSL path
    $fullPath = $currentDir.FullName
    $drive = $fullPath.Substring(0, 1).ToLower()
    $pathWithoutDrive = $fullPath.Substring(3).Replace('\', '/')
    $wslPath = "/mnt/$drive/$pathWithoutDrive"
    
    Write-Host "[*] Running via WSL in $wslPath..." -ForegroundColor Yellow
    
    # Run directly in WSL to ensure environment is preserved
    wsl -e bash -c "cd '$wslPath' && chmod +x anubis.sh && ./anubis.sh"
} else {
    Write-Host "[*] Running via Git Bash..." -ForegroundColor Yellow
    & $bashPath -c "cd '$($currentDir.Path -replace '\\', '/')' && bash anubis.sh"
}

Write-Host ""
Write-Host "[*] ANUBIS has exited" -ForegroundColor Yellow
Read-Host "Press Enter to close"
