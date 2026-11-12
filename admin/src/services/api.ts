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

export interface UserProfile {
  id: string;
  email: string;
  displayName: string;
  role: string;
  avatarUrl?: string;
}

export interface AuthTokens {
  accessToken: string;
  refreshToken: string;
  tokenType: string;
  expiresIn: string;
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

export async function loginAdmin(email: string, password: string): Promise<{ user: UserProfile; tokens: AuthTokens }> {
  const response = await fetch(`${API_BASE}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password }),
  });

  if (!response.ok) {
    const errorData = await response.json().catch(() => ({}));
    throw new Error(errorData.error?.message || 'Authentication failed');
  }

  const envelope = await response.json();
  return envelope.data || envelope;
}
