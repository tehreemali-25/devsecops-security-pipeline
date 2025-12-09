// Simple interactivity for the DevSecOps demo page

document.addEventListener('DOMContentLoaded', function () {
    // Animate tool cards on scroll
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -100px 0px'
    };

    const observer = new IntersectionObserver(function (entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Observe all tool cards
    document.querySelectorAll('.tool-card, .benefit, .pipeline-step').forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'all 0.6s ease';
        observer.observe(el);
    });

    // Add click handlers to API endpoints
    const endpoints = document.querySelectorAll('.endpoint a');
    endpoints.forEach(link => {
        link.addEventListener('click', function (e) {
            // Let the link work normally, but add visual feedback
            this.style.fontWeight = 'bold';
            setTimeout(() => {
                this.style.fontWeight = '600';
            }, 200);
        });
    });

    // Console message
    console.log('%c🔒 DevSecOps Demo Application', 'color: #667eea; font-size: 20px; font-weight: bold;');
    console.log('%cAutomated Security Testing Pipeline', 'color: #764ba2; font-size: 14px;');
    console.log('%c\nSecurity Tools:', 'font-weight: bold; margin-top: 10px;');
    console.log('  ✅ OWASP Dependency-Check (SCA)');
    console.log('  ✅ SonarQube (SAST)');
    console.log('  ✅ Trivy (Container Scanner)');
});
