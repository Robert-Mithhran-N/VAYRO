import { render, screen } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import { App } from './App';

// Mock global fetch to isolate dashboard rendering test
vi.stubGlobal(
  'fetch',
  vi.fn().mockImplementation(() =>
    Promise.resolve({
      ok: true,
      json: () =>
        Promise.resolve({
          status: 'ok',
          service: 'vayro-backend',
          version: '1.0.0',
          timestamp: '2026-11-11T00:00:00.000Z',
          database: { status: 'healthy', latencyMs: 2 },
          redis: { status: 'healthy', latencyMs: 1 },
        }),
    }),
  ),
);

describe('VAYRO Admin Dashboard Rendering Tests', () => {
  it('renders application header and branding', () => {
    render(<App />);
    expect(screen.getByText('VAYRO')).toBeInTheDocument();
    expect(screen.getByText('Admin Console')).toBeInTheDocument();
  });

  it('renders navigation sidebar and planned roadmap modules', () => {
    render(<App />);
    expect(screen.getByText('Overview')).toBeInTheDocument();
    expect(screen.getByText('System Health')).toBeInTheDocument();
    expect(screen.getByText('Planned Modules')).toBeInTheDocument();
    expect(screen.getByText('Servers')).toBeInTheDocument();
    expect(screen.getByText('Trips & Routes')).toBeInTheDocument();
  });

  it('renders system infrastructure overview page and action buttons', () => {
    render(<App />);
    expect(screen.getByText('System Infrastructure Overview')).toBeInTheDocument();
    expect(screen.getByText('Refresh')).toBeInTheDocument();
    expect(screen.getByText('Run Smoke Test')).toBeInTheDocument();
  });
});
