# Anubis Installation Test Script
# Tests all prerequisites and reports status

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Anubis Installation Test" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$allGood = $true

# Test 1: PHP
Write-Host "[Test 1] Checking PHP..." -ForegroundColor Yellow
try {
    $phpVersion = php --version 2>$null | Select-Object -First 1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [PASS] PHP installed: $phpVersion" -ForegroundColor Green
    } else {
        throw "Not found"
    }
} catch {
    Write-Host "  [FAIL] PHP not found" -ForegroundColor Red
    Write-Host "         Install: choco install php -y" -ForegroundColor Yellow
    $allGood = $false
}

# Test 2: Git Bash
Write-Host ""
Write-Host "[Test 2] Checking Git Bash..." -ForegroundColor Yellow
$gitBashPaths = @(
    "C:\Program Files\Git\bin\bash.exe",
    "C:\Program Files (x86)\Git\bin\bash.exe",
    "$env:LOCALAPPDATA\Programs\Git\bin\bash.exe"
)

$gitBashFound = $false
foreach ($path in $gitBashPaths) {
    if (Test-Path $path) {
        Write-Host "  [PASS] Git Bash found: $path" -ForegroundColor Green
        $gitBashFound = $true
        break
    }
}

if (-not $gitBashFound) {
    Write-Host "  [WARN] Git Bash not found (optional if WSL is available)" -ForegroundColor Yellow
}

# Test 3: WSL
Write-Host ""
Write-Host "[Test 3] Checking WSL..." -ForegroundColor Yellow
try {
    $wslCheck = wsl --status 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [PASS] WSL installed and running" -ForegroundColor Green
    } else {
        throw "Not found"
    }
} catch {
    Write-Host "  [WARN] WSL not found (optional if Git Bash is available)" -ForegroundColor Yellow
}

if (-not $gitBashFound) {
    try {
        $wslCheck = wsl --status 2>$null
        if ($LASTEXITCODE -ne 0) {
            throw "Not found"
        }
    } catch {
        Write-Host ""
        Write-Host "  [FAIL] Need either Git Bash OR WSL!" -ForegroundColor Red
        $allGood = $false
    }
}

# Test 4: Internet connection
Write-Host ""
Write-Host "[Test 4] Checking Internet connection..." -ForegroundColor Yellow
try {
    $ping = Test-Connection -ComputerName google.com -Count 1 -Quiet
    if ($ping) {
        Write-Host "  [PASS] Internet connection available" -ForegroundColor Green
    } else {
        throw "Failed"
    }
} catch {
    Write-Host "  [WARN] Internet connection test failed" -ForegroundColor Yellow
    Write-Host "         You'll need internet for tunneling services" -ForegroundColor Yellow
}

# Test 5: Required files
Write-Host ""
Write-Host "[Test 5] Checking required files..." -ForegroundColor Yellow
$requiredFiles = @(
    "anubis.sh",
    "template.php",
    "post.php",
    "ip.php",
    "location.php",
    "LiveYTTV.html",
    "Zoom Meeting Web.html",
    "pdf_viewer.html",
    "pdf_template.php"
)

$missingFiles = @()
foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        $missingFiles += $file
    }
}

if ($missingFiles.Count -eq 0) {
    Write-Host "  [PASS] All required files present" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Missing files:" -ForegroundColor Red
    foreach ($file in $missingFiles) {
        Write-Host "         - $file" -ForegroundColor Red
    }
    $allGood = $false
}

# Test 6: curl (for ngrok API)
Write-Host ""
Write-Host "[Test 6] Checking curl..." -ForegroundColor Yellow
try {
    $curlVersion = curl --version 2>$null | Select-Object -First 1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [PASS] curl available" -ForegroundColor Green
    } else {
        throw "Not found"
    }
} catch {
    Write-Host "  [WARN] curl not found (needed for Ngrok)" -ForegroundColor Yellow
    Write-Host "         CloudFlare Tunnel will work without it" -ForegroundColor Yellow
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Test Summary" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

if ($allGood) {
    Write-Host ""
    Write-Host "[SUCCESS] All critical tests passed!" -ForegroundColor Green
    Write-Host "You can run Anubis with:" -ForegroundColor White
    Write-Host "  .\run_anubis.ps1" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "[FAILURE] Some critical tests failed" -ForegroundColor Red
    Write-Host "Please install missing dependencies" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "For detailed setup instructions, see:" -ForegroundColor White
Write-Host "  SETUP_GUIDE.md" -ForegroundColor Cyan
Write-Host ""
