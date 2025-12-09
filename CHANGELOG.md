# Changelog

All notable changes to the DevSecOps Demo project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-05

### Added

#### Application
- Initial Express.js REST API application
- JWT-based authentication system
- User registration and login endpoints
- Protected API routes
- Input validation with Joi
- Security headers with Helmet.js
- Rate limiting middleware
- Health check endpoint
- API documentation endpoint

#### Security Tools Integration
- OWASP Dependency-Check for Software Composition Analysis (SCA)
- SonarQube integration for Static Application Security Testing (SAST)
- Trivy scanner for container and filesystem security
- Docker Compose setup for local SonarQube instance

#### CI/CD Pipeline
- Complete GitHub Actions workflow
- Automated dependency vulnerability scanning
- Automated code quality and security analysis
- Automated container security scanning
- Security gates and build failure on critical issues
- Comprehensive security reporting
- GitHub Security tab integration
- Pull request comment automation

#### Infrastructure
- Multi-stage Dockerfile with security best practices
- Non-root container user
- Docker health checks
- Minimal Alpine Linux base image
- .dockerignore for optimized builds

#### Documentation
- Comprehensive README with problem statement and solution
- SECURITY.md policy document
- Detailed ARCHITECTURE.md with Mermaid diagrams
- PRESENTATION.md for evaluation
- QUICKSTART.md for rapid setup
- Architecture diagram visualization
- Contributing guidelines
- MIT License

#### Scripts
- PowerShell script for Windows users (run-security-scans.ps1)
- Bash script for Linux/Mac users (run-security-scans.sh)
- Automated security scan execution
- Report generation

#### Configuration
- SonarQube project configuration (sonar-project.properties)
- Trivy scanner configuration (trivy.yaml)
- Environment variable templates (.env.example)
- Git ignore patterns
- Docker ignore patterns

### Security Features

#### Application Level
- Password hashing with bcrypt (salt rounds: 10)
- JWT token authentication (24h expiration)
- Input validation schemas
- Rate limiting (100 requests per 15 minutes)
- CORS configuration
- Security headers (Helmet.js)
- Error handling middleware

#### Container Level
- Non-root user (nodejs:1001)
- Multi-stage builds for minimal attack surface
- Alpine Linux base (reduced vulnerabilities)
- No hardcoded secrets
- Health check monitoring

#### Pipeline Level
- Three-layer security scanning
- CVSS threshold enforcement (≥7 fails build)
- Automated vulnerability reporting
- Secret detection
- Configuration scanning
- Quality gates

### Demonstration Features

- Intentionally outdated lodash dependency (4.17.19) for CVE demonstration
- Complete end-to-end security pipeline
- Multiple report formats (HTML, JSON, SARIF)
- GitHub Security integration
- Comprehensive documentation for evaluation

## [Unreleased]

### Planned Features
- Dynamic Application Security Testing (DAST) with OWASP ZAP
- Infrastructure as Code (IaC) scanning
- Runtime security monitoring
- Compliance automation (PCI-DSS, GDPR)
- Performance monitoring integration
- Multi-environment deployment (staging, production)

---

**Note**: This is an educational/demonstration project for Applied DevOps evaluation.
