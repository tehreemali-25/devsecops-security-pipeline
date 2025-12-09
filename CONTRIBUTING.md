# Contributing to DevSecOps Demo

Thank you for your interest in contributing to this DevSecOps demonstration project!

## 🤝 How to Contribute

### Reporting Issues

If you find a bug or have a suggestion:

1. Check if the issue already exists in the Issues tab
2. If not, create a new issue with:
   - Clear title
   - Detailed description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior

### Submitting Changes

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow existing code style
   - Add comments where necessary
   - Update documentation

4. **Run security scans locally**
   ```bash
   .\scripts\run-security-scans.ps1  # Windows
   ./scripts/run-security-scans.sh   # Linux/Mac
   ```

5. **Commit your changes**
   ```bash
   git commit -m "feat: add new feature"
   ```

   Use conventional commits:
   - `feat:` - New feature
   - `fix:` - Bug fix
   - `docs:` - Documentation
   - `security:` - Security improvement
   - `refactor:` - Code refactoring

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Describe your changes
   - Link related issues
   - Ensure all checks pass

## 🔐 Security Guidelines

When contributing, please:

- ✅ Never commit secrets or credentials
- ✅ Run all security scans before submitting
- ✅ Follow secure coding practices
- ✅ Update security documentation if relevant
- ✅ Report security vulnerabilities privately (see SECURITY.md)

## 📝 Code Style

- Use meaningful variable and function names
- Add JSDoc comments for functions
- Follow existing formatting
- Keep functions focused and small

## 🧪 Testing

- Test your changes locally
- Ensure the application runs without errors
- Verify security scans pass
- Test in a clean environment

## 📚 Documentation

If your change affects:
- **Setup**: Update README.md
- **Architecture**: Update docs/ARCHITECTURE.md
- **Security**: Update SECURITY.md
- **Usage**: Update docs/QUICKSTART.md

## ✅ Pull Request Checklist

Before submitting, ensure:

- [ ] Code follows project style
- [ ] Security scans pass
- [ ] Documentation updated
- [ ] Commit messages are clear
- [ ] No secrets in code
- [ ] Changes are tested

## 🎯 Good First Issues

Look for issues tagged with:
- `good-first-issue`
- `documentation`
- `enhancement`

## 💬 Questions?

Feel free to:
- Open a discussion
- Comment on issues
- Ask in pull requests

Thank you for contributing to better DevSecOps practices! 🚀
