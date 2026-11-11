import React, { useEffect, useState } from 'react';
import { RefreshCw, CheckCircle2, ShieldAlert } from 'lucide-react';
import { fetchHealth, runSmokeTest, HealthResponse } from '../services/api';
import { StatusCard } from '../components/StatusCard';

export const OverviewPage: React.FC = () => {
  const [health, setHealth] = useState<HealthResponse | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [testing, setTesting] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null);

  const loadHealthData = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await fetchHealth();
      setHealth(data);
    } catch (err: any) {
      setError(err.message || 'Failed to connect to VAYRO backend');
    } finally {
      setLoading(false);
    }
  };

  const executeSmokeTest = async () => {
    try {
      setTesting(true);
      setError(null);
      const data = await runSmokeTest();
      setHealth(data);
    } catch (err: any) {
      setError(err.message || 'Smoke test execution failed');
    } finally {
      setTesting(false);
    }
  };

  useEffect(() => {
    loadHealthData();
  }, []);

  return (
    <div className="space-y-8">
      {/* Hero Welcome */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 pb-6 border-b border-vayro-border">
        <div>
          <h2 className="text-2xl font-bold text-white tracking-tight">System Infrastructure Overview</h2>
          <p className="text-sm text-vayro-textSecondary mt-1">
            Real-time status of backend API, persistence stores, and development services.
          </p>
        </div>

        <div className="flex items-center gap-3">
          <button
            onClick={loadHealthData}
            disabled={loading || testing}
            className="flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium bg-surface hover:bg-surface-elevated text-vayro-textPrimary border border-vayro-border transition disabled:opacity-50"
          >
            <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />
            <span>Refresh</span>
          </button>

          <button
            onClick={executeSmokeTest}
            disabled={loading || testing}
            className="flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium bg-accent-primary hover:bg-accent-primary/90 text-white shadow-lg shadow-accent-primary/20 transition disabled:opacity-50"
          >
            <CheckCircle2 className={`w-4 h-4 ${testing ? 'animate-spin' : ''}`} />
            <span>Run Smoke Test</span>
          </button>
        </div>
      </div>

      {/* Error Banner */}
      {error && (
        <div className="bg-vayro-error/10 border border-vayro-error/30 rounded-xl p-4 flex items-start gap-3">
          <ShieldAlert className="w-5 h-5 text-vayro-error flex-shrink-0 mt-0.5" />
          <div className="text-sm">
            <h4 className="font-semibold text-vayro-error">Backend Connection Error</h4>
            <p className="text-vayro-textSecondary mt-1">{error}</p>
            <p className="text-xs text-vayro-textMuted mt-2">
              Ensure the NestJS service is running on <code className="text-accent-secondary">http://localhost:3000</code>.
            </p>
          </div>
        </div>
      )}

      {/* Grid of Status Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <StatusCard
          title="NestJS Backend API"
          status={health ? 'online' : error ? 'offline' : 'pending'}
          description="Modular Monolith API Service"
          details={health?.version ? `v${health.version}` : undefined}
          error={error || undefined}
        />

        <StatusCard
          title="PostgreSQL Primary DB"
          status={
            health?.database?.status === 'healthy'
              ? 'online'
              : health?.database?.status === 'unreachable'
              ? 'offline'
              : 'pending'
          }
          description="Prisma Schema & Migrations"
          latency={health?.database?.latencyMs}
          details={health?.database?.status ? health.database.status.toUpperCase() : 'PORT 5432'}
          error={health?.database?.error}
        />

        <StatusCard
          title="Redis Cache & State"
          status={
            health?.redis?.status === 'healthy'
              ? 'online'
              : health?.redis?.status === 'unreachable'
              ? 'degraded'
              : 'pending'
          }
          description="In-Memory Cache & Pub/Sub"
          latency={health?.redis?.latencyMs}
          details={health?.redis?.status ? health.redis.status.toUpperCase() : 'PORT 6379'}
          error={health?.redis?.error}
        />
      </div>

      {/* Smoke Test Banner */}
      {health?.smokeTest && (
        <div className="bg-surface rounded-xl border border-accent-primary/40 p-6 space-y-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2 text-white font-semibold">
              <CheckCircle2 className="w-5 h-5 text-vayro-success" />
              <span>Latest Integration Smoke Test Result</span>
            </div>
            <span className="text-xs text-vayro-textMuted font-mono">
              Timestamp: {health.timestamp}
            </span>
          </div>
          <p className="text-sm text-vayro-textSecondary">
            {health.smokeTest.message}
          </p>
          {health.smokeTest.recordId && (
            <div className="text-xs bg-background-primary px-3 py-2 rounded-lg border border-vayro-border font-mono text-accent-secondary">
              Prisma DevHealthRecord ID: #{health.smokeTest.recordId}
            </div>
          )}
        </div>
      )}

      {/* Phase Roadmap Overview */}
      <div className="bg-surface rounded-xl border border-vayro-border p-6 space-y-4">
        <h3 className="font-semibold text-white text-base flex items-center justify-between">
          <span>Architectural Phase Progress</span>
          <span className="text-xs text-accent-secondary font-mono">Phase 1 of 18 Complete</span>
        </h3>
        <p className="text-sm text-vayro-textSecondary">
          VAYRO is initialized in strict test-driven foundation mode. Features such as private travel communities, real-time GPS synchronization, and group audio rooms will unlock in sequence.
        </p>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 pt-2">
          <div className="bg-background-secondary p-4 rounded-lg border border-vayro-border">
            <div className="flex items-center justify-between text-xs font-semibold mb-1">
              <span className="text-vayro-success">Phase 1: Foundation</span>
              <span>100%</span>
            </div>
            <p className="text-xs text-vayro-textMuted">Monorepo, Flutter Client, NestJS API, PostgreSQL, Redis, Admin</p>
          </div>

          <div className="bg-background-secondary p-4 rounded-lg border border-vayro-border opacity-70">
            <div className="flex items-center justify-between text-xs font-semibold mb-1">
              <span className="text-accent-secondary">Phase 2: Servers</span>
              <span>Queued</span>
            </div>
            <p className="text-xs text-vayro-textMuted">Private travel communities, member invites, RBAC roles</p>
          </div>

          <div className="bg-background-secondary p-4 rounded-lg border border-vayro-border opacity-70">
            <div className="flex items-center justify-between text-xs font-semibold mb-1">
              <span className="text-accent-secondary">Phase 3: Trips</span>
              <span>Queued</span>
            </div>
            <p className="text-xs text-vayro-textMuted">Multi-participant journeys, shared destinations, routing</p>
          </div>
        </div>
      </div>
    </div>
  );
};
