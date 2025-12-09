# Quick Start Guide

## ⚡ Quick Setup (5 Minutes)

### Prerequisites Check

Before starting, ensure you have:
- ✅ Node.js 18+ installed
- ✅ Docker Desktop running
- ✅ Git installed

### Step 1: Install Dependencies

```bash
npm install
```

### Step 2: Run the Application

```bash
npm start
```

Visit: `http://localhost:3000`

### Step 3: Test the API

```bash
# Health check
curl http://localhost:3000/api/health

# API documentation
curl http://localhost:3000/api/docs
```

## 🔐 Run Security Scans

### Option 1: Automated Script (Recommended)

**Windows (PowerShell)**:
```powershell
.\scripts\run-security-scans.ps1
```

**Linux/Mac (Bash)**:
```bash
chmod +x scripts/run-security-scans.sh
./scripts/run-security-scans.sh
```

### Option 2: Manual Scans

#### OWASP Dependency-Check
```bash
docker run --rm -v "$(pwd):/src" -v "$(pwd)/reports:/report" owasp/dependency-check:latest --scan /src --format HTML --project "DevSecOps Demo" --out /report
```

#### Build and Scan with Trivy
```bash
# Build image
docker build -t devsecops-demo:local .

# Scan image
trivy image devsecops-demo:local
```

## 📊 View Reports

After running scans, check the `reports/` directory:
- `dependency-check-report.html` - OWASP scan results
- `trivy-fs-report.txt` - Filesystem scan
- `trivy-image-report.txt` - Container scan

## 🚀 Deploy with GitHub Actions

1. Fork this repository
2. Add secrets in GitHub:
   - `SONAR_TOKEN` (optional)
   - `SONAR_HOST_URL` (optional)
3. Push code - pipeline runs automatically!

## 🆘 Troubleshooting

### Issue: Port 3000 already in use
**Solution**: Change port in `.env` file:
```
PORT=3001
```

### Issue: Docker not running
**Solution**: Start Docker Desktop

### Issue: npm install fails
**Solution**: Delete `node_modules` and run:
```bash
rm -rf node_modules package-lock.json
npm install
```

## 📚 Next Steps

- Read [README.md](../README.md) for full documentation
- Check [ARCHITECTURE.md](ARCHITECTURE.md) for technical details
- Review [SECURITY.md](../SECURITY.md) for security policies

## 💡 Tips for Evaluation

1. **Show the pipeline** - Push code and demonstrate GitHub Actions
2. **Explain the tools** - Use the presentation slides
3. **Show reports** - Display generated security reports
4. **Discuss benefits** - Reference the Equifax case study

Good luck with your evaluation! 🎓
