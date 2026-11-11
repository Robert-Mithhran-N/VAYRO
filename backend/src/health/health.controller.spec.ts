import { Test, TestingModule } from '@nestjs/testing';
import { HealthController } from './health.controller';
import { HealthService } from './health.service';

describe('HealthController Tests', () => {
  let controller: HealthController;
  let mockHealthService: any;

  beforeEach(async () => {
    mockHealthService = {
      getOverallHealth: jest.fn().mockReturnValue({
        status: 'ok',
        service: 'vayro-backend',
        version: '1.0.0',
        timestamp: '2026-11-11T00:00:00.000Z',
      }),
      getDatabaseHealth: jest.fn().mockResolvedValue({
        status: 'ok',
        database: { status: 'healthy' },
      }),
      getRedisHealth: jest.fn().mockResolvedValue({
        status: 'ok',
        redis: { status: 'healthy' },
      }),
      runSmokeTest: jest.fn().mockResolvedValue({
        status: 'ok',
        smokeTest: { message: 'Integration verified', recordId: 1 },
      }),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [HealthController],
      providers: [{ provide: HealthService, useValue: mockHealthService }],
    }).compile();

    controller = module.get<HealthController>(HealthController);
  });

  it('should return health check from controller', () => {
    const res = controller.getHealth();
    expect(res.status).toBe('ok');
    expect(mockHealthService.getOverallHealth).toHaveBeenCalled();
  });

  it('should call getDatabaseHealth', async () => {
    const res = await controller.getDatabaseHealth();
    expect(res.status).toBe('ok');
    expect(mockHealthService.getDatabaseHealth).toHaveBeenCalled();
  });

  it('should call getRedisHealth', async () => {
    const res = await controller.getRedisHealth();
    expect(res.status).toBe('ok');
    expect(mockHealthService.getRedisHealth).toHaveBeenCalled();
  });

  it('should call runSmokeTest', async () => {
    const res = await controller.runSmokeTest({ client: 'jest-test' });
    expect(res.status).toBe('ok');
    expect(mockHealthService.runSmokeTest).toHaveBeenCalledWith({ client: 'jest-test' });
  });
});
