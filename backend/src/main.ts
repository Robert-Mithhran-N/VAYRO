import { Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { AllExceptionsFilter } from './common/filters/all-exceptions.filter';
import { LoggingInterceptor } from './common/interceptors/logging.interceptor';
import { TransformInterceptor } from './common/interceptors/transform.interceptor';
import { globalValidationPipe } from './common/pipes/validation.pipe';

async function bootstrap() {
  const logger = new Logger('VayroBootstrap');
  const app = await NestFactory.create(AppModule);

  const configService = app.get(ConfigService);
  const port = configService.get<number>('port', 3000);
  const apiPrefix = configService.get<string>('apiPrefix', 'api/v1');
  const corsOrigins = configService.get<string[]>('cors.origins', ['http://localhost:5173']);
  const swaggerEnabled = configService.get<boolean>('swagger.enabled', true);

  // Global Prefix for REST API Versioning (/api/v1)
  app.setGlobalPrefix(apiPrefix);

  // CORS Configuration
  app.enableCors({
    origin: corsOrigins,
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    credentials: true,
  });

  // Global Exception Filter
  app.useGlobalFilters(new AllExceptionsFilter());

  // Global Interceptors
  app.useGlobalInterceptors(
    new LoggingInterceptor(),
    new TransformInterceptor(),
  );

  // Global Validation Pipe
  app.useGlobalPipes(globalValidationPipe);

  // Swagger OpenAPI Documentation
  if (swaggerEnabled) {
    const swaggerConfig = new DocumentBuilder()
      .setTitle('VAYRO API')
      .setDescription(
        'VAYRO — Connected Travel Platform Backend Services. Move as One.',
      )
      .setVersion('1.0.0')
      .addTag('Health & Diagnostics', 'Service vitality and integration checks')
      .addBearerAuth()
      .build();

    const document = SwaggerModule.createDocument(app, swaggerConfig);
    SwaggerModule.setup('api/docs', app, document);
    logger.log(`Swagger documentation available at /api/docs`);
  }

  await app.listen(port);
  logger.log(`VAYRO Backend running on http://localhost:${port}/${apiPrefix}`);
}

bootstrap();
