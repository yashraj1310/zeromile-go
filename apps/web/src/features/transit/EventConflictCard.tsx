/**
 * =========================================================================
 * ZEROMILE GO - EVENT CONFLICT CARD (EventConflictCard.tsx)
 * Reconstructed from Authoritative index.html (Lines 787 - 809)
 * =========================================================================
 */

import React from 'react';

interface EventConflictCardProps {
  isVisible: boolean;
  eventName: string;
  delayMins: number;
  corridorName: string;
  onSwitchToBypass: () => void;
  onDismiss: () => void;
}

export const EventConflictCard: React.FC<EventConflictCardProps> = ({
  isVisible,
  eventName,
  delayMins,
  corridorName,
  onSwitchToBypass,
  onDismiss
}) => {
  if (!isVisible) return null;

  return (
    <div
      style={{
        position: 'absolute',
        bottom: '30px',
        left: '50%',
        transform: 'translateX(-50%)',
        zIndex: 40,
        maxWidth: '520px',
        width: '90%',
        background: 'rgba(20, 15, 10, 0.94)',
        backdropFilter: 'blur(20px)',
        border: '1px solid rgba(255, 145, 0, 0.45)',
        borderRadius: '18px',
        boxShadow: '0 16px 40px rgba(255, 145, 0, 0.25)',
        padding: '16px',
        color: '#fff'
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '10px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <span style={{ fontSize: '18px' }}>⚠️</span>
          <span style={{ fontSize: '11px', fontWeight: 900, letterSpacing: '0.5px', color: '#FF9100' }}>
            ACTIVE EVENT DETECTED: {eventName.toUpperCase()}
          </span>
        </div>
        <button
          onClick={onDismiss}
          style={{ background: 'none', border: 'none', color: '#94A3B8', cursor: 'pointer', fontSize: '16px' }}
        >
          ✕
        </button>
      </div>

      <div style={{ display: 'flex', gap: '14px', alignItems: 'center', marginBottom: '14px' }}>
        <div style={{ padding: '8px 12px', borderRadius: '10px', background: 'rgba(255, 23, 68, 0.2)', border: '1px solid rgba(255, 23, 68, 0.4)', textAlign: 'center' }}>
          <div style={{ fontSize: '16px', fontWeight: 900, color: '#FF1744' }}>+{delayMins} min</div>
          <div style={{ fontSize: '9px', fontWeight: 800, color: '#94A3B8' }}>Event Congestion</div>
        </div>
        <div style={{ fontSize: '12px', color: '#CBD5E1', lineHeight: 1.4 }}>
          Your direct route passes through the active {eventName} corridor on {corridorName}. Rolling barricades are in effect.
        </div>
      </div>

      <button
        onClick={onSwitchToBypass}
        style={{
          width: '100%',
          padding: '12px',
          borderRadius: '10px',
          background: 'linear-gradient(135deg, #00E676 0%, #00C853 100%)',
          border: 'none',
          color: '#050811',
          fontWeight: 800,
          fontSize: '13px',
          cursor: 'pointer',
          boxShadow: '0 4px 16px rgba(0, 230, 118, 0.35)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          gap: '8px'
        }}
      >
        <span>✨ Switch to Alternate Bypass (Saves {delayMins} mins)</span> ➔
      </button>
    </div>
  );
};
