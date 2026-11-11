import React from 'react';
import { CheckCircle2, AlertTriangle, XCircle, Clock } from 'lucide-react';

export interface StatusCardProps {
  title: string;
  status: 'online' | 'degraded' | 'offline' | 'pending';
  description?: string;
  latency?: number;
  error?: string;
  details?: string;
}

export const StatusCard: React.FC<StatusCardProps> = ({
  title,
  status,
  description,
  latency,
  error,
  details,
}) => {
  const getBadge = () => {
    switch (status) {
      case 'online':
        return (
          <span className="flex items-center gap-1.5 text-xs font-semibold text-vayro-success bg-vayro-success/10 px-2.5 py-1 rounded-full border border-vayro-success/30">
            <CheckCircle2 className="w-3.5 h-3.5" /> ONLINE
          </span>
        );
      case 'degraded':
        return (
          <span className="flex items-center gap-1.5 text-xs font-semibold text-vayro-warning bg-vayro-warning/10 px-2.5 py-1 rounded-full border border-vayro-warning/30">
            <AlertTriangle className="w-3.5 h-3.5" /> DEGRADED
          </span>
        );
      case 'offline':
        return (
          <span className="flex items-center gap-1.5 text-xs font-semibold text-vayro-error bg-vayro-error/10 px-2.5 py-1 rounded-full border border-vayro-error/30">
            <XCircle className="w-3.5 h-3.5" /> UNREACHABLE
          </span>
        );
      case 'pending':
        return (
          <span className="flex items-center gap-1.5 text-xs font-semibold text-vayro-textMuted bg-surface-elevated px-2.5 py-1 rounded-full border border-vayro-border">
            <Clock className="w-3.5 h-3.5" /> PENDING
          </span>
        );
    }
  };

  return (
    <div className="bg-surface rounded-xl border border-vayro-border p-5 flex flex-col justify-between hover:border-vayro-border/80 transition-all">
      <div className="flex items-start justify-between">
        <div>
          <h3 className="font-semibold text-vayro-textPrimary text-base">{title}</h3>
          {description && <p className="text-xs text-vayro-textSecondary mt-1">{description}</p>}
        </div>
        {getBadge()}
      </div>

      <div className="mt-4 pt-3 border-t border-vayro-border/50 text-xs flex items-center justify-between">
        {latency !== undefined ? (
          <span className="text-vayro-textMuted">Latency: <span className="text-vayro-textPrimary font-mono">{latency}ms</span></span>
        ) : (
          <span className="text-vayro-textMuted">Network: <span className="text-vayro-textPrimary">Internal Loopback</span></span>
        )}

        {details && <span className="text-accent-secondary font-mono">{details}</span>}
      </div>

      {error && (
        <div className="mt-2 text-xs bg-vayro-error/10 border border-vayro-error/30 text-vayro-error rounded p-2 font-mono">
          {error}
        </div>
      )}
    </div>
  );
};

