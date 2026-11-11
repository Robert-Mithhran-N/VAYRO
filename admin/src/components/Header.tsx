import React from 'react';
import { Compass, ShieldCheck } from 'lucide-react';

export const Header: React.FC = () => {
  return (
    <header className="h-16 border-b border-vayro-border bg-background-secondary/80 backdrop-blur-md px-6 flex items-center justify-between sticky top-0 z-10">
      <div className="flex items-center gap-3">
        <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-accent-primary to-accent-secondary flex items-center justify-center shadow-lg shadow-accent-primary/20">
          <Compass className="w-5 h-5 text-white" />
        </div>
        <div>
          <h1 className="font-bold text-lg leading-tight tracking-tight text-white flex items-center gap-2">
            VAYRO <span className="text-xs uppercase font-semibold text-accent-secondary bg-accent-secondary/10 px-2 py-0.5 rounded border border-accent-secondary/30">Admin Console</span>
          </h1>
          <p className="text-xs text-vayro-textMuted">Connected Travel Platform Infrastructure</p>
        </div>
      </div>

      <div className="flex items-center gap-4">
        <div className="flex items-center gap-2 text-xs text-vayro-textSecondary bg-surface px-3 py-1.5 rounded-full border border-vayro-border">
          <ShieldCheck className="w-4 h-4 text-vayro-success" />
          <span>Foundation Mode</span>
        </div>
        <div className="w-8 h-8 rounded-full bg-surface-elevated border border-vayro-border flex items-center justify-center text-xs font-semibold text-white">
          AD
        </div>
      </div>
    </header>
  );
};

