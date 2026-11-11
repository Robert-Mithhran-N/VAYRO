import React from 'react';
import { NavLink } from 'react-router-dom';
import { Activity, LayoutDashboard, Server, Navigation, Shield, Radio, Lock } from 'lucide-react';

export const Sidebar: React.FC = () => {
  return (
    <aside className="w-64 border-r border-vayro-border bg-background-secondary p-4 flex flex-col justify-between">
      <div className="space-y-6">
        <div>
          <p className="px-3 text-xs font-semibold text-vayro-textMuted uppercase tracking-wider mb-2">
            Control Center
          </p>
          <nav className="space-y-1">
            <NavLink
              to="/"
              className={({ isActive }) =>
                `flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-medium transition-colors ${
                  isActive
                    ? 'bg-accent-primary text-white shadow-md shadow-accent-primary/20'
                    : 'text-vayro-textSecondary hover:bg-surface hover:text-white'
                }`
              }
            >
              <LayoutDashboard className="w-4 h-4" />
              <span>Overview</span>
            </NavLink>

            <NavLink
              to="/health"
              className={({ isActive }) =>
                `flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-medium transition-colors ${
                  isActive
                    ? 'bg-accent-primary text-white shadow-md shadow-accent-primary/20'
                    : 'text-vayro-textSecondary hover:bg-surface hover:text-white'
                }`
              }
            >
              <Activity className="w-4 h-4" />
              <span>System Health</span>
            </NavLink>
          </nav>
        </div>

        <div>
          <p className="px-3 text-xs font-semibold text-vayro-textMuted uppercase tracking-wider mb-2">
            Planned Modules
          </p>
          <nav className="space-y-1">
            <div className="flex items-center justify-between px-3 py-2 rounded-lg text-sm text-vayro-textMuted cursor-not-allowed">
              <span className="flex items-center gap-3">
                <Server className="w-4 h-4 opacity-50" />
                <span>Servers</span>
              </span>
              <span className="text-[10px] bg-surface-elevated text-vayro-textMuted px-1.5 py-0.5 rounded border border-vayro-border flex items-center gap-1">
                <Lock className="w-2.5 h-2.5" /> Phase 2
              </span>
            </div>

            <div className="flex items-center justify-between px-3 py-2 rounded-lg text-sm text-vayro-textMuted cursor-not-allowed">
              <span className="flex items-center gap-3">
                <Navigation className="w-4 h-4 opacity-50" />
                <span>Trips & Routes</span>
              </span>
              <span className="text-[10px] bg-surface-elevated text-vayro-textMuted px-1.5 py-0.5 rounded border border-vayro-border flex items-center gap-1">
                <Lock className="w-2.5 h-2.5" /> Phase 3
              </span>
            </div>

            <div className="flex items-center justify-between px-3 py-2 rounded-lg text-sm text-vayro-textMuted cursor-not-allowed">
              <span className="flex items-center gap-3">
                <Radio className="w-4 h-4 opacity-50" />
                <span>Voice Channels</span>
              </span>
              <span className="text-[10px] bg-surface-elevated text-vayro-textMuted px-1.5 py-0.5 rounded border border-vayro-border flex items-center gap-1">
                <Lock className="w-2.5 h-2.5" /> Phase 5
              </span>
            </div>

            <div className="flex items-center justify-between px-3 py-2 rounded-lg text-sm text-vayro-textMuted cursor-not-allowed">
              <span className="flex items-center gap-3">
                <Shield className="w-4 h-4 opacity-50" />
                <span>Emergency Alerts</span>
              </span>
              <span className="text-[10px] bg-surface-elevated text-vayro-textMuted px-1.5 py-0.5 rounded border border-vayro-border flex items-center gap-1">
                <Lock className="w-2.5 h-2.5" /> Phase 7
              </span>
            </div>
          </nav>
        </div>
      </div>

      <div className="p-3 bg-surface rounded-lg border border-vayro-border text-xs text-vayro-textMuted">
        <p className="font-semibold text-vayro-textSecondary">VAYRO Foundation v1.0.0</p>
        <p className="mt-1">Monorepo initial development release.</p>
      </div>
    </aside>
  );
};

