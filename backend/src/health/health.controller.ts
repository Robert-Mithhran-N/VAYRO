import { Controller, Get, Query } from '@nestjs/common';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { SmokeTestQueryDto } from './dto/smoke-test.dto';
import { HealthService } from './health.service';

@ApiTags('Health & Diagnostics')
@Controller('health')
export class HealthController {
  constructor(private readonly healthService: HealthService) {}

  @Get()
  @ApiOperation({ summary: 'Basic service health check' })
  @ApiResponse({ status: 200, description: 'Service is responding' })
  getHealth() {
    return this.healthService.getOverallHealth();
  }

  @Get('database')
  @ApiOperation({ summary: 'PostgreSQL database connectivity check' })
  @ApiResponse({ status: 200, description: 'PostgreSQL connection status' })
  getDatabaseHealth() {
    return this.healthService.getDatabaseHealth();
  }

  @Get('redis')
  @ApiOperation({ summary: 'Redis in-memory cache connectivity check' })
  @ApiResponse({ status: 200, description: 'Redis connection status' })
  getRedisHealth() {
    return this.healthService.getRedisHealth();
  }

  @Get('smoke-test')
  @ApiOperation({ summary: 'End-to-end integration smoke test' })
  @ApiResponse({
    status: 200,
    description: 'Returns live connectivity matrix across backend, database, and cache',
  })
  runSmokeTest(@Query() query: SmokeTestQueryDto) {
    return this.healthService.runSmokeTest(query);
  }
}

