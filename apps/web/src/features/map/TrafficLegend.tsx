/**
 * =========================================================================
 * ZEROMILE GO - LIVE TRAFFIC FLOW LEGEND (TrafficLegend.tsx)
 * =========================================================================
 */

import React from 'react';

export const TrafficLegend: React.FC = () => {
  return (
    <div
      className="gmaps-traffic-legend"
      style={{
        position: 'absolute',
        bottom: '24px',
        right: '24px',
        zIndex: 40,
        background: 'rgba(10, 15, 29, 0.88)',
        backdropFilter: 'blur(16px)',
        border: '1px solid rgba(255, 255, 255, 0.12)',
        borderRadius: '12px',
        padding: '10px 14px',
        color: '#fff',
        fontSize: '11px',
        boxShadow: '0 8px 24px rgba(0, 0, 0, 0.5)'
      }}
    >
      <div style={{ fontWeight: 800, letterSpacing: '0.5px', marginBottom: '6px', color: '#94A3B8', fontSize: '10px' }}>
        LIVE TRAFFIC FLOW:
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <span style={{ width: '16px', height: '4px', borderRadius: '2px', background: '#00F2FE' }}></span>
          <span>Fast (&gt;40 km/h)</span>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <span style={{ width: '16px', height: '4px', borderRadius: '2px', background: '#FFD700' }}></span>
          <span>Moderate (25–40)</span>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <span style={{ width: '16px', height: '4px', borderRadius: '2px', background: '#FF9100' }}></span>
          <span>Slow (15–25)</span>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <span style={{ width: '16px', height: '4px', borderRadius: '2px', background: '#FF1744' }}></span>
          <span>Roadblock (&lt;15)</span>
        </div>
      </div>
    </div>
  );
};
