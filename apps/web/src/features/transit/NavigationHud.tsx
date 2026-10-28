/**
 * =========================================================================
 * ZEROMILE GO - NAVIGATION HUD & SPEEDOMETER (NavigationHud.tsx)
 * Reconstructed from Authoritative index.html (Lines 811 - 852)
 * =========================================================================
 */

import React, { useState, useEffect } from 'react';

interface NavigationHudProps {
  isNavigating: boolean;
  onExitNavigation: () => void;
  speedLimit?: number;
}

export const NavigationHud: React.FC<NavigationHudProps> = ({
  isNavigating,
  onExitNavigation,
  speedLimit = 50
}) => {
  const [currentSpeed, setCurrentSpeed] = useState(48);

  useEffect(() => {
    if (!isNavigating) return;
    const interval = setInterval(() => {
      // Simulate minor speed fluctuation
      setCurrentSpeed(prev => Math.max(38, Math.min(54, prev + (Math.random() > 0.5 ? 1 : -1))));
    }, 1500);
    return () => clearInterval(interval);
  }, [isNavigating]);

  if (!isNavigating) return null;

  return (
    <>
      {/* 1. Turn-by-Turn Navigation Header Banner */}
      <div
        style={{
          position: 'absolute',
          top: '24px',
          left: '50%',
          transform: 'translateX(-50%)',
          zIndex: 45,
          maxWidth: '560px',
          width: '90%',
          background: 'rgba(10, 15, 29, 0.94)',
          backdropFilter: 'blur(20px)',
          border: '1px solid rgba(0, 242, 254, 0.35)',
          borderRadius: '16px',
          boxShadow: '0 12px 36px rgba(0, 242, 254, 0.25)',
          padding: '12px 16px',
          display: 'flex',
          alignItems: 'center',
          gap: '14px',
          color: '#fff'
        }}
      >
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', background: 'rgba(0, 242, 254, 0.15)', padding: '8px 12px', borderRadius: '10px', minWidth: '60px' }}>
          <div style={{ fontSize: '20px', fontWeight: 900, color: '#00F2FE' }}>↱</div>
          <div style={{ fontSize: '11px', fontWeight: 800 }}>390 m</div>
        </div>

        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ fontSize: '14px', fontWeight: 800, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
            Wardha Road Expressway
          </div>
          <div style={{ fontSize: '11px', color: '#94A3B8', marginTop: '2px' }}>
            Turn right at Shankar Nagar Square towards Zero Mile
          </div>
        </div>

        <button
          onClick={onExitNavigation}
          title="Exit Navigation"
          style={{ width: '32px', height: '32px', borderRadius: '50%', background: 'rgba(255,255,255,0.08)', border: 'none', color: '#94A3B8', cursor: 'pointer', fontSize: '14px' }}
        >
          ✕
        </button>
      </div>

      {/* 2. Live Telemetry HUD Bar */}
      <div
        style={{
          position: 'absolute',
          bottom: '24px',
          left: '50%',
          transform: 'translateX(-50%)',
          zIndex: 45,
          background: 'rgba(10, 15, 29, 0.94)',
          backdropFilter: 'blur(20px)',
          border: '1px solid rgba(255, 255, 255, 0.12)',
          borderRadius: '20px',
          boxShadow: '0 16px 40px rgba(0, 0, 0, 0.6)',
          padding: '10px 24px',
          display: 'flex',
          alignItems: 'center',
          gap: '24px',
          color: '#fff'
        }}
      >
        {/* Speedometer Ring */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <div
            style={{
              width: '44px',
              height: '44px',
              borderRadius: '50%',
              border: `3px solid ${currentSpeed > speedLimit ? '#FF1744' : '#00E676'}`,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontWeight: 900,
              fontSize: '16px',
              color: currentSpeed > speedLimit ? '#FF1744' : '#00E676'
            }}
          >
            {currentSpeed}
          </div>
          <div style={{ fontSize: '10px', color: '#94A3B8', fontWeight: 700 }}>
            <div>KM/H</div>
            <div style={{ color: '#64748B' }}>LIMIT {speedLimit}</div>
          </div>
        </div>

        <div style={{ width: '1px', height: '30px', background: 'rgba(255,255,255,0.1)' }}></div>

        <div>
          <div style={{ fontSize: '15px', fontWeight: 900 }}>16:34</div>
          <div style={{ fontSize: '9px', fontWeight: 800, color: '#94A3B8' }}>Arrival Clock</div>
        </div>

        <div style={{ width: '1px', height: '30px', background: 'rgba(255,255,255,0.1)' }}></div>

        <div>
          <div style={{ fontSize: '15px', fontWeight: 900, color: '#00F2FE' }}>6.1 km</div>
          <div style={{ fontSize: '9px', fontWeight: 800, color: '#94A3B8' }}>Remaining</div>
        </div>

        <div style={{ width: '1px', height: '30px', background: 'rgba(255,255,255,0.1)' }}></div>

        <div>
          <div style={{ fontSize: '15px', fontWeight: 900, color: '#FFD700' }}>18 min</div>
          <div style={{ fontSize: '9px', fontWeight: 800, color: '#94A3B8' }}>Est. Time</div>
        </div>
      </div>
    </>
  );
};
