# DevSecOps Security Scans Runner Script (PowerShell)
# This script runs all security scans locally for testing on Windows

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "🔒 DevSecOps Security Scans" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Create reports directory
New-Item -ItemType Directory -Force -Path "reports" | Out-Null

Write-Host "📋 Checking prerequisites..." -ForegroundColor Yellow
Write-Host ""

# Check for Node.js
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js $nodeVersion found" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found. Please install Node.js" -ForegroundColor Red
    exit 1
}

# Check for Docker
try {
    $dockerVersion = docker --version
    Write-Host "✅ Docker found: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker not found. Please install Docker Desktop" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "1️⃣  Installing dependencies..." -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Cyan
npm install
Write-Host ""

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "2️⃣  Running OWASP Dependency-Check (SCA)..." -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Scanning for vulnerable dependencies..." -ForegroundColor White

# Run OWASP Dependency-Check using Docker
docker run --rm `
    -v "${PWD}:/src" `
    -v "${PWD}/reports:/report" `
    owasp/dependency-check:latest `
    --scan /src `
    --format HTML `
    --format JSON `
    --project "DevSecOps Demo" `
    --out /report

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Dependency-Check completed" -ForegroundColor Green
    Write-Host "📊 Report: reports/dependency-check-report.html" -ForegroundColor Cyan
} else {
    Write-Host "❌ Dependency-Check failed" -ForegroundColor Red
}
Write-Host ""

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "3️⃣  Building Docker image..." -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Cyan
docker build -t devsecops-demo:local .

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Docker build successful" -ForegroundColor Green
} else {
    Write-Host "❌ Docker build failed" -ForegroundColor Red
    exit 1
}
Write-Host ""

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "4️⃣  Running Trivy Security Scan..." -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Scanning filesystem and container for vulnerabilities..." -ForegroundColor White

# Check if Trivy is installed
try {
    trivy --version | Out-Null
    Write-Host "✅ Trivy found" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Trivy not found. Installing via Chocolatey..." -ForegroundColor Yellow
    Write-Host "If you don't have Chocolatey, install it from: https://chocolatey.org/" -ForegroundColor Yellow
    Write-Host "Or download Trivy manually from: https://github.com/aquasecurity/trivy/releases" -ForegroundColor Yellow
    
    try {
        choco install trivy -y
    } catch {
        Write-Host "❌ Could not install Trivy automatically. Please install manually." -ForegroundColor Red
        Write-Host "Skipping Trivy scan..." -ForegroundColor Yellow
        Start-Sleep -Seconds 2
    }
}

# Run Trivy scans if available
try {
    # Filesystem scan
    Write-Host "Scanning filesystem..." -ForegroundColor White
    trivy fs --severity HIGH,CRITICAL --format table --output reports/trivy-fs-report.txt .
    Write-Host "✅ Filesystem scan completed" -ForegroundColor Green
    Write-Host "📊 Report: reports/trivy-fs-report.txt" -ForegroundColor Cyan
    Write-Host ""

    # Container image scan
    Write-Host "Scanning container image..." -ForegroundColor White
    trivy image --severity HIGH,CRITICAL --format table --output reports/trivy-image-report.txt devsecops-demo:local
    trivy image --severity HIGH,CRITICAL --format json --output reports/trivy-image-report.json devsecops-demo:local
    
    Write-Host "✅ Container scan completed" -ForegroundColor Green
    Write-Host "📊 Report: reports/trivy-image-report.txt" -ForegroundColor Cyan
} catch {
    Write-Host "⚠️  Trivy scan skipped" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "5️⃣  SonarQube Analysis (Optional)" -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Note: SonarQube requires a running server instance." -ForegroundColor White
Write-Host "To start SonarQube locally, run: docker-compose up -d" -ForegroundColor White
Write-Host ""
Write-Host "Once SonarQube is running at http://localhost:9000:" -ForegroundColor White
Write-Host "1. Login with admin/admin" -ForegroundColor White
Write-Host "2. Create a project and token" -ForegroundColor White
Write-Host "3. Run: npx sonar-scanner -Dsonar.login=YOUR_TOKEN -Dsonar.host.url=http://localhost:9000" -ForegroundColor White
Write-Host ""

Write-Host "==================================================" -ForegroundColor Green
Write-Host "✅ Security Scans Complete!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Reports generated in ./reports/ directory:" -ForegroundColor Cyan
Write-Host "  - dependency-check-report.html (OWASP Dependency-Check)" -ForegroundColor White
Write-Host "  - trivy-fs-report.txt (Trivy Filesystem Scan)" -ForegroundColor White
Write-Host "  - trivy-image-report.txt (Trivy Container Scan)" -ForegroundColor White
Write-Host ""
Write-Host "🔍 Review the reports for security findings" -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Cyan

# Open reports folder
Start-Process explorer.exe -ArgumentList "reports"
