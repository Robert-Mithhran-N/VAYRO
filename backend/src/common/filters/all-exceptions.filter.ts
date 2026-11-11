import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger(AllExceptionsFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let message = 'Internal server error occurred.';
    let errorCode = 'INTERNAL_ERROR';
    let details: any = undefined;

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const res = exception.getResponse();
      if (typeof res === 'string') {
        message = res;
      } else if (typeof res === 'object' && res !== null) {
        message = (res as any).message || exception.message;
        errorCode = (res as any).error || 'HTTP_EXCEPTION';
        details = (res as any).details;
      }
    } else if (exception instanceof Error) {
      message = process.env.NODE_ENV === 'production' ? 'An unexpected error occurred.' : exception.message;
      errorCode = exception.name || 'UNKNOWN_ERROR';
    }

    this.logger.error(
      `[${request.method}] ${request.url} - Status: ${status} - Error: ${message}`,
      exception instanceof Error ? exception.stack : undefined,
    );

    response.status(status).json({
      status: 'error',
      service: 'vayro-backend',
      version: '1.0.0',
      timestamp: new Date().toISOString(),
      path: request.url,
      error: {
        code: errorCode,
        message,
        details,
      },
    });
  }
}

