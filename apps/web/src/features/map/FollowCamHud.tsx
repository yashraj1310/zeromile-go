/**
 * =========================================================================
 * ZEROMILE GO - FOLLOW-CAM HUD (FollowCamHud.tsx)
 * Reconstructed from Authoritative index.html (Lines 762 - 770)
 * =========================================================================
 */

import React from 'react';

interface FollowCamHudProps {
  isFollowing: boolean;
  riderName?: string;
  speed?: number;
  distanceKm?: number;
  onReleaseCamera: () => void;
}

export const FollowCamHud: React.FC<FollowCamHudProps> = ({
  isFollowing,
  riderName = 'Lead Peloton (Rider #101)',
  speed = 28.4,
  distanceKm = 4.2,
  onReleaseCamera
}) => {
  if (!isFollowing) return null;

  return (
    <div
      style={{
        position: 'absolute',
        top: '90px',
        right: '24px',
        zIndex: 40,
        background: 'rgba(10, 15, 29, 0.94)',
        backdropFilter: 'blur(16px)',
        border: '1px solid rgba(0, 242, 254, 0.4)',
        borderRadius: '16px',
        boxShadow: '0 12px 36px rgba(0, 242, 254, 0.25)',
        padding: '12px 18px',
        display: 'flex',
        alignItems: 'center',
        gap: '14px',
        color: '#fff'
      }}
    >
      <div style={{ fontSize: '22px', animation: 'pulse 1.2s infinite' }}>🎥</div>
      <div>
        <div style={{ fontSize: '12px', fontWeight: 900, color: '#00F2FE' }}>
          TRACKING: {riderName.toUpperCase()}
        </div>
        <div style={{ fontSize: '11px', color: '#94A3B8', marginTop: '2px' }}>
          Speed: {speed} km/h • {distanceKm} km completed
        </div>
      </div>
      <button
        onClick={onReleaseCamera}
        style={{
          padding: '6px 12px',
          borderRadius: '8px',
          background: 'rgba(255, 255, 255, 0.08)',
          border: '1px solid rgba(255, 255, 255, 0.15)',
          color: '#fff',
          fontSize: '11px',
          fontWeight: 700,
          cursor: 'pointer'
        }}
      >
        ✕ Release Camera
      </button>
    </div>
  );
};
