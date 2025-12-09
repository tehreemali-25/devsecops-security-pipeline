#!/bin/bash

# DevSecOps Security Scans Runner Script
# This script runs all security scans locally for testing

echo "=================================================="
echo "🔒 DevSecOps Security Scans"
echo "=================================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Create reports directory
mkdir -p reports

echo "📋 Checking prerequisites..."
echo ""

# Check for Node.js
if command_exists node; then
    echo "✅ Node.js $(node --version) found"
else
    echo "❌ Node.js not found. Please install Node.js"
    exit 1
fi

# Check for Docker
if command_exists docker; then
    echo "✅ Docker $(docker --version | cut -d' ' -f3 | tr -d ',') found"
else
    echo "❌ Docker not found. Please install Docker"
    exit 1
fi

echo ""
echo "=================================================="
echo "1️⃣  Installing dependencies..."
echo "=================================================="
npm install
echo ""

echo "=================================================="
echo "2️⃣  Running OWASP Dependency-Check (SCA)..."
echo "=================================================="
echo "Scanning for vulnerable dependencies..."

# Run OWASP Dependency-Check using Docker
docker run --rm \
    -v "$(pwd)":/src \
    -v "$(pwd)/reports":/report \
    owasp/dependency-check:latest \
    --scan /src \
    --format HTML \
    --format JSON \
    --project "DevSecOps Demo" \
    --out /report

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dependency-Check completed${NC}"
    echo "📊 Report: reports/dependency-check-report.html"
else
    echo -e "${RED}❌ Dependency-Check failed${NC}"
fi
echo ""

echo "=================================================="
echo "3️⃣  Building Docker image..."
echo "=================================================="
docker build -t devsecops-demo:local .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Docker build successful${NC}"
else
    echo -e "${RED}❌ Docker build failed${NC}"
    exit 1
fi
echo ""

echo "=================================================="
echo "4️⃣  Running Trivy Security Scan..."
echo "=================================================="
echo "Scanning filesystem for vulnerabilities..."

# Check if Trivy is installed
if ! command_exists trivy; then
    echo "⚠️  Trivy not found, installing..."
    # Install Trivy (Linux)
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
    echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
    sudo apt-get update
    sudo apt-get install trivy -y
fi

# Filesystem scan
trivy fs --severity HIGH,CRITICAL --format table --output reports/trivy-fs-report.txt .
echo -e "${GREEN}✅ Filesystem scan completed${NC}"
echo "📊 Report: reports/trivy-fs-report.txt"
echo ""

# Container image scan
echo "Scanning container image for vulnerabilities..."
trivy image --severity HIGH,CRITICAL --format table --output reports/trivy-image-report.txt devsecops-demo:local
trivy image --severity HIGH,CRITICAL --format json --output reports/trivy-image-report.json devsecops-demo:local

echo -e "${GREEN}✅ Container scan completed${NC}"
echo "📊 Report: reports/trivy-image-report.txt"
echo ""

echo "=================================================="
echo "5️⃣  SonarQube Analysis (Optional)"
echo "=================================================="
echo "Note: SonarQube requires a running server instance."
echo "To start SonarQube locally, run: docker-compose up -d"
echo ""
echo "Once SonarQube is running at http://localhost:9000:"
echo "1. Login with admin/admin"
echo "2. Create a token"
echo "3. Run: npx sonar-scanner -Dsonar.login=YOUR_TOKEN"
echo ""

echo "=================================================="
echo "✅ Security Scans Complete!"
echo "=================================================="
echo ""
echo "📊 Reports generated in ./reports/ directory:"
echo "  - dependency-check-report.html (OWASP Dependency-Check)"
echo "  - trivy-fs-report.txt (Trivy Filesystem Scan)"
echo "  - trivy-image-report.txt (Trivy Container Scan)"
echo ""
echo "🔍 Review the reports for security findings"
echo "=================================================="
