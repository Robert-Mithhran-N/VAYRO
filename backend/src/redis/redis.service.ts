import {
  Injectable,
  Logger,
  OnModuleDestroy,
  OnModuleInit,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Redis from 'ioredis';

@Injectable()
export class RedisService implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(RedisService.name);
  private client: Redis | null = null;
  private isConnected = false;

  constructor(private readonly configService: ConfigService) {}

  onModuleInit() {
    const host = this.configService.get<string>('redis.host', 'localhost');
    const port = this.configService.get<number>('redis.port', 6379);
    const password = this.configService.get<string>('redis.password');

    try {
      this.client = new Redis({
        host,
        port,
        password: password || undefined,
        lazyConnect: true,
        connectTimeout: 3000,
        maxRetriesPerRequest: 1,
        retryStrategy: () => null, // Do not spam retries on local dev if redis container is down
      });

      this.client.on('connect', () => {
        this.isConnected = true;
        this.logger.log('Redis client connected successfully.');
      });

      this.client.on('error', (err) => {
        this.isConnected = false;
        this.logger.warn(`Redis connection error: ${err.message}`);
      });

      this.client.connect().catch((err) => {
        this.logger.warn(`Redis initial connect failed: ${err.message}. Running in decoupled mode.`);
      });
    } catch (err: any) {
      this.logger.warn(`Redis initialization exception: ${err.message}`);
    }
  }

  async onModuleDestroy() {
    if (this.client) {
      try {
        await this.client.quit();
      } catch {
        this.client.disconnect();
      }
      this.logger.log('Redis client disconnected.');
    }
  }

  getClient(): Redis | null {
    return this.client;
  }

  async isHealthy(): Promise<{ healthy: boolean; latencyMs?: number; error?: string }> {
    if (!this.client) {
      return { healthy: false, error: 'Redis client not initialized' };
    }

    const start = Date.now();
    try {
      const pingRes = await this.client.ping();
      const healthy = pingRes === 'PONG';
      return {
        healthy,
        latencyMs: Date.now() - start,
      };
    } catch (err: any) {
      return {
        healthy: false,
        error: err.message || 'Redis ping failed',
      };
    }
  }
}

