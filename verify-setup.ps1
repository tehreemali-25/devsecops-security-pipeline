# Setup Verification Script
# Run this to verify everything is set up correctly

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "🔍 DevSecOps Project Setup Verification" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

$allChecks = @()

# Check 1: Node.js
Write-Host "1. Checking Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "   ✅ Node.js $nodeVersion installed" -ForegroundColor Green
    $allChecks += $true
}
catch {
    Write-Host "   ❌ Node.js not found" -ForegroundColor Red
    $allChecks += $false
}

# Check 2: npm
Write-Host "2. Checking npm..." -ForegroundColor Yellow
try {
    $npmVersion = npm --version
    Write-Host "   ✅ npm $npmVersion installed" -ForegroundColor Green
    $allChecks += $true
}
catch {
    Write-Host "   ❌ npm not found" -ForegroundColor Red
    $allChecks += $false
}

# Check 3: Docker
Write-Host "3. Checking Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "   ✅ Docker installed: $dockerVersion" -ForegroundColor Green
    $allChecks += $true
}
catch {
    Write-Host "   ❌ Docker not found" -ForegroundColor Red
    $allChecks += $false
}

# Check 4: Git
Write-Host "4. Checking Git..." -ForegroundColor Yellow
try {
    $gitVersion = git --version
    Write-Host "   ✅ Git installed: $gitVersion" -ForegroundColor Green
    $allChecks += $true
}
catch {
    Write-Host "   ❌ Git not found" -ForegroundColor Red
    $allChecks += $false
}

# Check 5: Project files
Write-Host "5. Checking project files..." -ForegroundColor Yellow
$requiredFiles = @(
    "package.json",
    "app.js",
    "Dockerfile",
    "docker-compose.yml",
    "README.md",
    ".github\workflows\devsecops-pipeline.yml"
)

$filesOk = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "   ✅ $file" -ForegroundColor Green
    }
    else {
        Write-Host "   ❌ $file missing" -ForegroundColor Red
        $filesOk = $false
    }
}
$allChecks += $filesOk

# Check 6: node_modules
Write-Host "6. Checking dependencies..." -ForegroundColor Yellow
if (Test-Path "node_modules") {
    Write-Host "   ✅ Dependencies installed" -ForegroundColor Green
    $allChecks += $true
}
else {
    Write-Host "   ⚠️  Dependencies not installed. Run: npm install" -ForegroundColor Yellow
    $allChecks += $false
}

# Check 7: .env file
Write-Host "7. Checking environment configuration..." -ForegroundColor Yellow
if (Test-Path ".env") {
    Write-Host "   ✅ .env file exists" -ForegroundColor Green
    $allChecks += $true
}
else {
    Write-Host "   ⚠️  .env file not found. Copy .env.example to .env" -ForegroundColor Yellow
    $allChecks += $false
}

# Check 8: Docker running
Write-Host "8. Checking Docker daemon..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "   ✅ Docker daemon is running" -ForegroundColor Green
    $allChecks += $true
}
catch {
    Write-Host "   ⚠️  Docker daemon not running. Start Docker Desktop" -ForegroundColor Yellow
    $allChecks += $false
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan

# Summary
$passedChecks = ($allChecks | Where-Object { $_ -eq $true }).Count
$totalChecks = $allChecks.Count

Write-Host "📊 Verification Results: $passedChecks/$totalChecks checks passed" -ForegroundColor Cyan

if ($passedChecks -eq $totalChecks) {
    Write-Host "✅ All checks passed! You're ready to go!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Run: npm start" -ForegroundColor White
    Write-Host "  2. Visit: http://localhost:3000" -ForegroundColor White
    Write-Host "  3. Run security scans: .\scripts\run-security-scans.ps1" -ForegroundColor White
}
elseif ($passedChecks -ge ($totalChecks * 0.7)) {
    Write-Host "⚠️  Most checks passed, but some issues need attention" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Fix the warnings above and run this script again" -ForegroundColor White
}
else {
    Write-Host "❌ Several checks failed. Please address the issues above" -ForegroundColor Red
    Write-Host ""
    Write-Host "Common fixes:" -ForegroundColor Yellow
    Write-Host "  - Install Node.js from: https://nodejs.org/" -ForegroundColor White
    Write-Host "  - Install Docker Desktop from: https://www.docker.com/" -ForegroundColor White
    Write-Host "  - Run: npm install" -ForegroundColor White
    Write-Host "  - Copy .env.example to .env" -ForegroundColor White
}

Write-Host "==================================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "📚 For more help, check:" -ForegroundColor Cyan
Write-Host "  - README.md - Full documentation" -ForegroundColor White
Write-Host "  - docs/QUICKSTART.md - Quick setup guide" -ForegroundColor White
Write-Host "  - EVALUATION_CHECKLIST.md - Preparation checklist" -ForegroundColor White
Write-Host ""
