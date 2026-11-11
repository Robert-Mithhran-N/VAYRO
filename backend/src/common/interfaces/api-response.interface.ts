export interface ApiResponse<T = any> {
  status: 'ok' | 'error' | 'degraded';
  service: string;
  version: string;
  timestamp: string;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: any;
  };
}

