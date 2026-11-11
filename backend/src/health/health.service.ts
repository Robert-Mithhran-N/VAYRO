import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import { RedisService } from '../redis/redis.service';
import { SmokeTestQueryDto } from './dto/smoke-test.dto';

@Injectable()
export class HealthService {
  private readonly logger = new Logger(HealthService.name);
  private readonly serviceName = 'vayro-backend';
  private readonly version = '1.0.0';

  constructor(
    private readonly prisma: PrismaService,
    private readonly redis: RedisService,
  ) {}

  getOverallHealth() {
    return {
      status: 'ok',
      service: this.serviceName,
      version: this.version,
      timestamp: new Date().toISOString(),
    };
  }

  async getDatabaseHealth() {
    const dbCheck = await this.prisma.isHealthy();
    return {
      status: dbCheck.healthy ? 'ok' : 'error',
      service: this.serviceName,
      version: this.version,
      timestamp: new Date().toISOString(),
      database: {
        status: dbCheck.healthy ? 'healthy' : 'unreachable',
        latencyMs: dbCheck.latencyMs,
        error: dbCheck.error,
      },
    };
  }

  async getRedisHealth() {
    const redisCheck = await this.redis.isHealthy();
    return {
      status: redisCheck.healthy ? 'ok' : 'degraded',
      service: this.serviceName,
      version: this.version,
      timestamp: new Date().toISOString(),
      redis: {
        status: redisCheck.healthy ? 'healthy' : 'unreachable',
        latencyMs: redisCheck.latencyMs,
        error: redisCheck.error,
      },
    };
  }

  async runSmokeTest(query: SmokeTestQueryDto) {
    const timestamp = new Date().toISOString();
    const dbCheck = await this.prisma.isHealthy();
    const redisCheck = await this.redis.isHealthy();

    let smokeRecord: any = null;
    let dbStatus = 'unreachable';

    if (dbCheck.healthy) {
      try {
        smokeRecord = await this.prisma.devHealthRecord.create({
          data: {
            service: this.serviceName,
            checkType: 'integration_smoke_test',
            status: 'SUCCESS',
            details: `Caller: ${query.client || 'generic-client'}${query.note ? ` | Note: ${query.note}` : ''}`,
          },
        });
        dbStatus = 'healthy';
      } catch (err: any) {
        this.logger.error(`Failed to insert smoke test record in DB: ${err.message}`);
        dbStatus = 'query_error';
      }
    }

    const isSystemHealthy = dbCheck.healthy;

    return {
      status: isSystemHealthy ? 'ok' : 'degraded',
      service: this.serviceName,
      version: this.version,
      timestamp,
      database: {
        status: dbStatus,
        latencyMs: dbCheck.latencyMs,
        error: dbCheck.error,
      },
      redis: {
        status: redisCheck.healthy ? 'healthy' : 'unreachable',
        latencyMs: redisCheck.latencyMs,
        error: redisCheck.error,
      },
      smokeTest: {
        message: dbCheck.healthy
          ? 'End-to-end integration verified: Flutter -> NestJS -> PostgreSQL record created'
          : 'Backend reached, but PostgreSQL database is currently unreachable. Start Docker Compose or verify DATABASE_URL.',
        recordId: smokeRecord?.id ?? null,
        client: query.client ?? 'anonymous',
      },
    };
  }
}

