import { Test, TestingModule } from '@nestjs/testing';
import { PrismaService } from '../database/prisma.service';
import { RedisService } from '../redis/redis.service';
import { HealthService } from './health.service';

describe('HealthService Tests', () => {
  let service: HealthService;
  let mockPrisma: any;
  let mockRedis: any;

  beforeEach(async () => {
    mockPrisma = {
      isHealthy: jest.fn().mockResolvedValue({ healthy: true, latencyMs: 2 }),
      devHealthRecord: {
        create: jest.fn().mockResolvedValue({
          id: 42,
          service: 'vayro-backend',
          checkType: 'integration_smoke_test',
          status: 'SUCCESS',
          details: 'Caller: test-client',
          createdAt: new Date(),
        }),
      },
    };

    mockRedis = {
      isHealthy: jest.fn().mockResolvedValue({ healthy: true, latencyMs: 1 }),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        HealthService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: RedisService, useValue: mockRedis },
      ],
    }).compile();

    service = module.get<HealthService>(HealthService);
  });

  it('should return overall service health format', () => {
    const health = service.getOverallHealth();
    expect(health.status).toBe('ok');
    expect(health.service).toBe('vayro-backend');
    expect(health.version).toBe('1.0.0');
    expect(health.timestamp).toBeDefined();
  });

  it('should test PostgreSQL connectivity and return database health status', async () => {
    const dbHealth = await service.getDatabaseHealth();
    expect(dbHealth.status).toBe('ok');
    expect(dbHealth.database.status).toBe('healthy');
    expect(mockPrisma.isHealthy).toHaveBeenCalled();
  });

  it('should return error status when PostgreSQL is unreachable', async () => {
    mockPrisma.isHealthy.mockResolvedValueOnce({
      healthy: false,
      error: 'Connection refused',
    });

    const dbHealth = await service.getDatabaseHealth();
    expect(dbHealth.status).toBe('error');
    expect(dbHealth.database.status).toBe('unreachable');
  });

  it('should test Redis connectivity and return redis health status', async () => {
    const redisHealth = await service.getRedisHealth();
    expect(redisHealth.status).toBe('ok');
    expect(redisHealth.redis.status).toBe('healthy');
    expect(mockRedis.isHealthy).toHaveBeenCalled();
  });

  it('should execute integration smoke test and create development health-check record', async () => {
    const result = await service.runSmokeTest({ client: 'test-runner' });
    expect(result.status).toBe('ok');
    expect(result.database.status).toBe('healthy');
    expect(result.smokeTest.recordId).toBe(42);
    expect(mockPrisma.devHealthRecord.create).toHaveBeenCalled();
  });
});
