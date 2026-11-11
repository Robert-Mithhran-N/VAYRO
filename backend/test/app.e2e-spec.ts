import { INestApplication } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';
import { PrismaService } from '../src/database/prisma.service';
import { RedisService } from '../src/redis/redis.service';

describe('VAYRO Backend Application Bootstrap & E2E Tests', () => {
  let app: INestApplication;

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

