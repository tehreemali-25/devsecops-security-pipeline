const request = require('supertest');
const app = require('../app');

describe('DevSecOps Demo API Tests', () => {

    describe('GET /', () => {
        it('should return API information', async () => {
            const res = await request(app).get('/');
            expect(res.statusCode).toBe(200);
            expect(res.body).toHaveProperty('message');
            expect(res.body).toHaveProperty('security_tools');
            expect(res.body.security_tools).toHaveLength(3);
        });
    });

    describe('GET /api/health', () => {
        it('should return healthy status', async () => {
            const res = await request(app).get('/api/health');
            expect(res.statusCode).toBe(200);
            expect(res.body.status).toBe('healthy');
            expect(res.body).toHaveProperty('timestamp');
            expect(res.body).toHaveProperty('uptime');
        });
    });

    describe('GET /api/docs', () => {
        it('should return API documentation', async () => {
            const res = await request(app).get('/api/docs');
            expect(res.statusCode).toBe(200);
            expect(res.body).toHaveProperty('endpoints');
            expect(Array.isArray(res.body.endpoints)).toBe(true);
        });
    });

    describe('POST /api/auth/register', () => {
        it('should register a new user', async () => {
            const userData = {
                username: 'testuser',
                email: 'test@example.com',
                password: 'TestPassword123!'
            };

            const res = await request(app)
                .post('/api/auth/register')
                .send(userData);

            expect(res.statusCode).toBe(201);
            expect(res.body).toHaveProperty('message');
            expect(res.body.user.username).toBe(userData.username);
            expect(res.body.user).not.toHaveProperty('password');
        });

        it('should reject invalid registration data', async () => {
            const invalidData = {
                username: 'ab', // too short
                email: 'invalid-email',
                password: '123' // too short
            };

            const res = await request(app)
                .post('/api/auth/register')
                .send(invalidData);

            expect(res.statusCode).toBe(400);
            expect(res.body).toHaveProperty('error');
        });
    });

    describe('POST /api/auth/login', () => {
        beforeAll(async () => {
            // Register a user for login tests
            await request(app)
                .post('/api/auth/register')
                .send({
                    username: 'logintest',
                    email: 'logintest@example.com',
                    password: 'LoginTest123!'
                });
        });

        it('should login with valid credentials', async () => {
            const res = await request(app)
                .post('/api/auth/login')
                .send({
                    username: 'logintest',
                    password: 'LoginTest123!'
                });

            expect(res.statusCode).toBe(200);
            expect(res.body).toHaveProperty('token');
            expect(res.body).toHaveProperty('expiresIn');
        });

        it('should reject invalid credentials', async () => {
            const res = await request(app)
                .post('/api/auth/login')
                .send({
                    username: 'logintest',
                    password: 'WrongPassword'
                });

            expect(res.statusCode).toBe(401);
            expect(res.body).toHaveProperty('error');
        });
    });

    describe('GET /api/profile', () => {
        let authToken;

        beforeAll(async () => {
            // Register and login to get token
            await request(app)
                .post('/api/auth/register')
                .send({
                    username: 'profiletest',
                    email: 'profiletest@example.com',
                    password: 'ProfileTest123!'
                });

            const loginRes = await request(app)
                .post('/api/auth/login')
                .send({
                    username: 'profiletest',
                    password: 'ProfileTest123!'
                });

            authToken = loginRes.body.token;
        });

        it('should return profile with valid token', async () => {
            const res = await request(app)
                .get('/api/profile')
                .set('Authorization', `Bearer ${authToken}`);

            expect(res.statusCode).toBe(200);
            expect(res.body.user.username).toBe('profiletest');
            expect(res.body.user).not.toHaveProperty('password');
        });

        it('should reject request without token', async () => {
            const res = await request(app).get('/api/profile');

            expect(res.statusCode).toBe(401);
            expect(res.body).toHaveProperty('error');
        });

        it('should reject request with invalid token', async () => {
            const res = await request(app)
                .get('/api/profile')
                .set('Authorization', 'Bearer invalid-token');

            expect(res.statusCode).toBe(403);
            expect(res.body).toHaveProperty('error');
        });
    });

    describe('404 Handler', () => {
        it('should return 404 for unknown routes', async () => {
            const res = await request(app).get('/unknown-route');
            expect(res.statusCode).toBe(404);
            expect(res.body).toHaveProperty('error');
        });
    });
});
