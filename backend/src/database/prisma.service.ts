import {
  Injectable,
  Logger,
  OnModuleDestroy,
  OnModuleInit,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  private readonly logger = new Logger(PrismaService.name);

  constructor(private readonly configService: ConfigService) {
    super({
      datasources: {
        db: {
          url: configService.get<string>('database.url'),
        },
      },
      log:
        configService.get<string>('nodeEnv') === 'development'
          ? ['error', 'warn']
          : ['error'],
    });
  }

  async onModuleInit() {
    try {
      await this.$connect();
      this.logger.log('Prisma connected to PostgreSQL successfully.');
    } catch (error) {
      this.logger.warn(
        `Prisma could not connect to PostgreSQL on startup: ${
          error instanceof Error ? error.message : error
        }. Running in decoupled mode.`,
      );
    }
  }

  async onModuleDestroy() {
    await this.$disconnect();
    this.logger.log('Prisma disconnected.');
  }

  async isHealthy(): Promise<{ healthy: boolean; latencyMs?: number; error?: string }> {
    const start = Date.now();
    try {
      await this.$queryRaw`SELECT 1`;
      return {
        healthy: true,
        latencyMs: Date.now() - start,
      };
    } catch (error: any) {
      return {
        healthy: false,
        error: error?.message || 'Database ping query failed',
      };
    }
  }
}

