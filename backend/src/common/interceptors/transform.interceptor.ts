import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { ApiResponse } from '../interfaces/api-response.interface';

@Injectable()
export class TransformInterceptor<T> implements NestInterceptor<T, ApiResponse<T>> {
  intercept(context: ExecutionContext, next: CallHandler): Observable<ApiResponse<T>> {
    return next.handle().pipe(
      map((data) => {
        // If the handler already returned an ApiResponse-like structure, pass it through
        if (data && typeof data === 'object' && 'service' in data && 'timestamp' in data) {
          return data;
        }

        return {
          status: 'ok',
          service: 'vayro-backend',
          version: '1.0.0',
          timestamp: new Date().toISOString(),
          data,
        };
      }),
    );
  }
}

