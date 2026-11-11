import React, { useEffect, useState } from 'react';
import { fetchHealth, HealthResponse } from '../services/api';
import { StatusCard } from '../components/StatusCard';
import { RefreshCw } from 'lucide-react';

export const SystemHealthPage: React.FC = () => {
  const [health, setHealth] = useState<HealthResponse | null>(null);
  const [loading, setLoading] = useState<boolean>(true);

  const loadData = () => {
    setLoading(true);
    fetchHealth()
      .then(setHealth)
      .catch(() => setHealth(null))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    loadData();
  }, []);

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold text-white tracking-tight">System Health & Telemetry</h2>
          <p className="text-sm text-vayro-textSecondary mt-1">
            Detailed diagnostics of low-level networking, database connectivity, and runtime metrics.
          </p>
        </div>
        <button
          onClick={loadData}
          disabled={loading}
          className="flex items-center gap-2 px-3 py-1.5 rounded-lg text-xs font-medium bg-surface hover:bg-surface-elevated text-vayro-textPrimary border border-vayro-border transition disabled:opacity-50"
        >
          <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin' : ''}`} />
          <span>Refresh</span>
        </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <StatusCard
          title="PostgreSQL Connectivity"
          status={health?.database?.status === 'healthy' ? 'online' : 'offline'}
          description="Driver: Prisma Client | Engine: Library"
          latency={health?.database?.latencyMs}
          details="Port 5432"
          error={health?.database?.error}
        />

        <StatusCard
          title="Redis State Store"
          status={health?.redis?.status === 'healthy' ? 'online' : 'degraded'}
          description="Driver: ioredis | Role: Primary Standalone"
          latency={health?.redis?.latencyMs}
          details="Port 6379"
          error={health?.redis?.error}
        />
      </div>

      <div className="bg-surface rounded-xl border border-vayro-border p-6 space-y-4">
        <h3 className="font-semibold text-white text-base">Service Environment Details</h3>
        <dl className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
          <div className="bg-background-secondary p-3 rounded-lg border border-vayro-border">
            <dt className="text-xs text-vayro-textMuted uppercase font-semibold">Service Name</dt>
            <dd className="font-mono text-white mt-1">{health?.service || 'vayro-backend'}</dd>
          </div>
          <div className="bg-background-secondary p-3 rounded-lg border border-vayro-border">
            <dt className="text-xs text-vayro-textMuted uppercase font-semibold">API Version</dt>
            <dd className="font-mono text-white mt-1">{health?.version || '1.0.0'}</dd>
          </div>
          <div className="bg-background-secondary p-3 rounded-lg border border-vayro-border">
            <dt className="text-xs text-vayro-textMuted uppercase font-semibold">API Base Path</dt>
            <dd className="font-mono text-white mt-1">/api/v1</dd>
          </div>
          <div className="bg-background-secondary p-3 rounded-lg border border-vayro-border">
            <dt className="text-xs text-vayro-textMuted uppercase font-semibold">Health Status</dt>
            <dd className="font-mono text-vayro-success mt-1">{health?.status || 'Active'}</dd>
          </div>
        </dl>
      </div>
    </div>
  );
};
