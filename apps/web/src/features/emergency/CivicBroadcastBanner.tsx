/**
 * =========================================================================
 * ZEROMILE GO - TOP CIVIC BROADCAST BANNER (CivicBroadcastBanner.tsx)
 * Reconstructed from Video (00:30 - 00:50)
 * =========================================================================
 */

import React from 'react';

interface CivicBroadcastBannerProps {
  bannerData: {
    domainTitle: string;
    corridor: string;
    text: string;
  } | null;
  onDismiss: () => void;
}

export const CivicBroadcastBanner: React.FC<CivicBroadcastBannerProps> = ({
  bannerData,
  onDismiss
}) => {
  if (!bannerData) return null;

  return (
    <div
      style={{
        position: 'absolute',
        top: '20px',
        left: '50%',
        transform: 'translateX(-50%)',
        zIndex: 50,
        maxWidth: '560px',
        width: '90%',
        background: 'rgba(20, 10, 15, 0.94)',
        backdropFilter: 'blur(16px)',
        border: '1px solid rgba(255, 23, 68, 0.45)',
        borderRadius: '16px',
        boxShadow: '0 12px 36px rgba(255, 23, 68, 0.28)',
        padding: '12px 16px',
        display: 'flex',
        alignItems: 'center',
        gap: '14px',
        animation: 'slideDownFade 0.3s cubic-bezier(0.16, 1, 0.3, 1)'
      }}
    >
      <div style={{ fontSize: '26px', animation: 'pulse 1.5s infinite' }}>🚨</div>

      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '3px' }}>
          <span style={{ fontSize: '9px', fontWeight: 900, letterSpacing: '0.6px', padding: '2px 6px', borderRadius: '4px', background: 'rgba(255, 23, 68, 0.25)', color: '#FF1744' }}>
            EMERGENCY CIVIC BROADCAST ({bannerData.domainTitle.toUpperCase()})
          </span>
          <span style={{ fontSize: '10px', color: '#64748B' }}>Just Now</span>
        </div>
        <div style={{ fontSize: '13px', fontWeight: 800, color: '#fff', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
          Alert at {bannerData.corridor}
        </div>
        <div style={{ fontSize: '11px', color: '#CBD5E1', lineHeight: 1.3, marginTop: '2px' }}>
          {bannerData.text}
        </div>
      </div>

      <button
        onClick={onDismiss}
        style={{
          padding: '6px 12px',
          borderRadius: '8px',
          background: 'rgba(255, 255, 255, 0.08)',
          border: '1px solid rgba(255, 255, 255, 0.12)',
          color: '#fff',
          fontSize: '11px',
          fontWeight: 700,
          cursor: 'pointer'
        }}
      >
        Dismiss
      </button>
    </div>
  );
};
