import { INestApplication } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';
import { PrismaService } from '../src/database/prisma.service';
import { RedisService } from '../src/redis/redis.service';
import * as bcrypt from 'bcryptjs';

describe('VAYRO Backend Application Bootstrap & E2E Tests', () => {
  let app: INestApplication;

  const mockUsers: any[] = [];
  const mockTokens: any[] = [];

  const mockPrisma = {
    $connect: jest.fn().mockResolvedValue(undefined),
    $disconnect: jest.fn().mockResolvedValue(undefined),
    isHealthy: jest.fn().mockResolvedValue({ healthy: true, latencyMs: 5 }),
    devHealthRecord: {
      create: jest.fn().mockResolvedValue({
        id: 1,
        service: 'vayro-backend',
        checkType: 'integration_smoke_test',
        status: 'SUCCESS',
        createdAt: new Date(),
      }),
    },
    user: {
      create: jest.fn().mockImplementation((args) => {
        const user = {
          id: `usr_${Date.now()}`,
          ...args.data,
          isActive: true,
          createdAt: new Date(),
          updatedAt: new Date(),
        };
        mockUsers.push(user);
        return Promise.resolve(user);
      }),
      findUnique: jest.fn().mockImplementation((args) => {
        if (args.where.email) {
          return Promise.resolve(mockUsers.find((u) => u.email === args.where.email) || null);
        }
        if (args.where.id) {
          return Promise.resolve(mockUsers.find((u) => u.id === args.where.id) || null);
        }
        return Promise.resolve(null);
      }),
    },
    refreshToken: {
      create: jest.fn().mockImplementation((args) => {
        const record = { id: `rt_${Date.now()}`, ...args.data, isRevoked: false };
        mockTokens.push(record);
        return Promise.resolve(record);
      }),
      findFirst: jest.fn().mockImplementation((args) => {
        const found = mockTokens.find(
          (t) => t.userId === args.where.userId && t.tokenHash === args.where.tokenHash && !t.isRevoked,
        );
        return Promise.resolve(found || null);
      }),
      update: jest.fn().mockImplementation((args) => {
        const token = mockTokens.find((t) => t.id === args.where.id);
        if (token) Object.assign(token, args.data);
        return Promise.resolve(token);
      }),
      updateMany: jest.fn().mockResolvedValue({ count: 1 }),
    },
  };

  const mockRedis = {
    isHealthy: jest.fn().mockResolvedValue({ healthy: true, latencyMs: 2 }),
  };

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    })
      .overrideProvider(PrismaService)
      .useValue(mockPrisma)
      .overrideProvider(RedisService)
      .useValue(mockRedis)
      .compile();

    app = moduleFixture.createNestApplication();
    app.setGlobalPrefix('api/v1');
    await app.init();
  });

  afterAll(async () => {
    if (app) {
      await app.close();
    }
  });

  describe('Health Endpoints', () => {
    it('GET /api/v1/health (Bootstrap & Health Check)', () => {
      return request(app.getHttpServer())
        .get('/api/v1/health')
        .expect(200)
        .expect((res) => {
          expect(res.body.status).toBe('ok');
          expect(res.body.service).toBe('vayro-backend');
          expect(res.body.version).toBe('1.0.0');
        });
    });

    it('GET /api/v1/health/smoke-test (End-to-End Integration Contract)', () => {
      return request(app.getHttpServer())
        .get('/api/v1/health/smoke-test?client=e2e-test-runner')
        .expect(200)
        .expect((res) => {
          expect(res.body.status).toBe('ok');
          expect(res.body.database.status).toBe('healthy');
          expect(res.body.smokeTest.recordId).toBe(1);
        });
    });
  });

  describe('Authentication Endpoints (Phase 2)', () => {
    let accessToken: string;
    let refreshToken: string;

    it('POST /api/v1/auth/register (Registers new user)', () => {
      return request(app.getHttpServer())
        .post('/api/v1/auth/register')
        .send({
          email: 'explorer@vayro.app',
          password: 'Password123!',
          displayName: 'Voyager Alex',
        })
        .expect(201)
        .expect((res) => {
          expect(res.body.user.email).toBe('explorer@vayro.app');
          expect(res.body.user.displayName).toBe('Voyager Alex');
          expect(res.body.tokens.accessToken).toBeDefined();
          expect(res.body.tokens.refreshToken).toBeDefined();
          accessToken = res.body.tokens.accessToken;
          refreshToken = res.body.tokens.refreshToken;
        });
    });

    it('POST /api/v1/auth/login (Authenticates existing user)', () => {
      return request(app.getHttpServer())
        .post('/api/v1/auth/login')
        .send({
          email: 'explorer@vayro.app',
          password: 'Password123!',
        })
        .expect(200)
        .expect((res) => {
          expect(res.body.user.email).toBe('explorer@vayro.app');
          expect(res.body.tokens.accessToken).toBeDefined();
        });
    });

    it('GET /api/v1/auth/me (Protected Route with Bearer Token)', () => {
      return request(app.getHttpServer())
        .get('/api/v1/auth/me')
        .set('Authorization', `Bearer ${accessToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body.email).toBe('explorer@vayro.app');
          expect(res.body.displayName).toBe('Voyager Alex');
        });
    });

    it('GET /api/v1/auth/me (Rejects unauthorized request without token)', () => {
      return request(app.getHttpServer())
        .get('/api/v1/auth/me')
        .expect(401);
    });

    it('POST /api/v1/auth/refresh (Rotates refresh token)', () => {
      return request(app.getHttpServer())
        .post('/api/v1/auth/refresh')
        .send({ refreshToken })
        .expect(200)
        .expect((res) => {
          expect(res.body.accessToken).toBeDefined();
          expect(res.body.refreshToken).toBeDefined();
        });
    });
  });
});
