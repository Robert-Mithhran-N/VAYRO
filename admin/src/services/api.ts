export interface HealthResponse {
  status: 'ok' | 'error' | 'degraded';
  service: string;
  version: string;
  timestamp: string;
  database?: {
    status: string;
    latencyMs?: number;
    error?: string;
  };
  redis?: {
    status: string;
    latencyMs?: number;
    error?: string;
  };
  smokeTest?: {
    message: string;
    recordId?: number;
    client?: string;
  };
}

const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000/api/v1';

export async function fetchHealth(): Promise<HealthResponse> {
  const response = await fetch(`${API_BASE}/health`);
  if (!response.ok) {
    throw new Error(`HTTP ${response.status}: Failed to reach backend health endpoint`);
  }
  return response.json();
}

export async function runSmokeTest(): Promise<HealthResponse> {
  const response = await fetch(`${API_BASE}/health/smoke-test?client=admin-dashboard`);
  if (!response.ok) {
    throw new Error(`HTTP ${response.status}: Failed to execute integration smoke test`);
  }
  return response.json();
}
