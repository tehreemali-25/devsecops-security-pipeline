module.exports = {
    testEnvironment: 'node',
    coverageDirectory: 'coverage',
    collectCoverageFrom: [
        'app.js',
        '!node_modules/**',
        '!coverage/**',
        '!tests/**'
    ],
    testMatch: [
        '**/tests/**/*.test.js'
    ],
    verbose: true,
    testTimeout: 10000
};
