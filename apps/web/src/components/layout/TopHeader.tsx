/**
 * =========================================================================
 * ZEROMILE GO - TOP HEADER & COMMAND BAR (TopHeader.tsx)
 * =========================================================================
 */

import React from 'react';
import { useAuth } from '../../context/AuthContext';
import { useDomain } from '../../context/DomainContext';
import { Shield, Navigation, LogOut } from 'lucide-react';

interface TopHeaderProps {
  viewMode: 'COMMUTER' | 'SUPERADMIN';
  onToggleViewMode: (mode: 'COMMUTER' | 'SUPERADMIN') => void;
}

export const TopHeader: React.FC<TopHeaderProps> = ({ viewMode, onToggleViewMode }) => {
  const { phone, isAuthenticatedAdmin, openLoginModal, logout } = useAuth();
  const { currentDomain, switchDomain, domains } = useDomain();

  return (
    <header
      style={{
        position: 'absolute',
        top: '16px',
        left: '20px',
        right: '20px',
        zIndex: 50,
        height: '64px',
        padding: '0 20px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between'
      }}
      className="glass-panel"
    >
      {/* Brand & Emblem */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '14px' }}>
        <div style={{
          width: '38px',
          height: '38px',
          borderRadius: '10px',
          background: 'linear-gradient(135deg, #FFD700 0%, #FF9100 100%)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          boxShadow: '0 0 16px rgba(255, 215, 0, 0.4)'
        }}>
          <span style={{ fontSize: '20px' }}>⚡</span>
        </div>
        <div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <span style={{ fontSize: '15px', fontWeight: 900, color: '#fff', letterSpacing: '-0.3px' }}>
              ZeroMile <span style={{ color: '#FFD700' }}>Go</span>
            </span>
            <span style={{
              fontSize: '10px',
              fontWeight: 800,
              padding: '2px 6px',
              borderRadius: '99px',
              background: 'rgba(0, 242, 254, 0.15)',
              color: '#00F2FE',
              border: '1px solid rgba(0, 242, 254, 0.3)'
            }}>
              NAGPUR 3D
            </span>
          </div>
          <div style={{ fontSize: '11px', color: '#94A3B8' }}>Civic Corridor Command Studio</div>
        </div>
      </div>

      {/* Domain Switcher */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '8px', background: 'rgba(0,0,0,0.3)', padding: '6px 12px', borderRadius: '8px', border: '1px solid rgba(255,255,255,0.06)' }}>
        <span style={{ fontSize: '14px' }}>{currentDomain.icon}</span>
        <select
          value={currentDomain.id}
          onChange={e => switchDomain(e.target.value)}
          style={{
            background: 'transparent',
            border: 'none',
            color: '#fff',
            fontSize: '12px',
            fontWeight: 700,
            cursor: 'pointer',
            outline: 'none'
          }}
        >
          {domains.map(d => (
            <option key={d.id} value={d.id} style={{ background: '#0d1527', color: '#fff' }}>
              {d.title}
            </option>
          ))}
        </select>
      </div>

      {/* Right Controls: Mode Toggle & SuperAdmin Auth */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
        {/* Commuter vs Studio Toggle */}
        <div style={{ display: 'flex', background: 'rgba(0,0,0,0.4)', borderRadius: '8px', padding: '3px', border: '1px solid rgba(255,255,255,0.08)' }}>
          <button
            onClick={() => onToggleViewMode('COMMUTER')}
            style={{
              padding: '6px 12px',
              borderRadius: '6px',
              background: viewMode === 'COMMUTER' ? 'rgba(0, 242, 254, 0.2)' : 'transparent',
              color: viewMode === 'COMMUTER' ? '#00F2FE' : '#94A3B8',
              border: viewMode === 'COMMUTER' ? '1px solid rgba(0, 242, 254, 0.4)' : 'none',
              fontSize: '11px',
              fontWeight: 800,
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              gap: '6px'
            }}
          >
            <Navigation size={13} /> Commuter Transit
          </button>
          <button
            onClick={() => onToggleViewMode('SUPERADMIN')}
            style={{
              padding: '6px 12px',
              borderRadius: '6px',
              background: viewMode === 'SUPERADMIN' ? 'rgba(255, 215, 0, 0.2)' : 'transparent',
              color: viewMode === 'SUPERADMIN' ? '#FFD700' : '#94A3B8',
              border: viewMode === 'SUPERADMIN' ? '1px solid rgba(255, 215, 0, 0.4)' : 'none',
              fontSize: '11px',
              fontWeight: 800,
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              gap: '6px'
            }}
          >
            <Shield size={13} /> SuperAdmin Studio
          </button>
        </div>

        {/* SuperAdmin Authentication Button / Status */}
        {isAuthenticatedAdmin ? (
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <div style={{
              display: 'flex',
              alignItems: 'center',
              gap: '6px',
              background: 'rgba(255, 215, 0, 0.15)',
              border: '1px solid #FFD700',
              padding: '6px 12px',
              borderRadius: '8px',
              fontSize: '11px',
              fontWeight: 800,
              color: '#FFD700'
            }}>
              <Shield size={14} color="#FFD700" />
              <span>SUPERADMIN (+91 {phone})</span>
            </div>
            <button
              onClick={logout}
              title="Logout"
              style={{
                padding: '6px',
                background: 'rgba(255, 23, 68, 0.15)',
                border: '1px solid rgba(255, 23, 68, 0.3)',
                borderRadius: '8px',
                color: '#FF1744',
                cursor: 'pointer'
              }}
            >
              <LogOut size={14} />
            </button>
          </div>
        ) : (
          <button
            onClick={openLoginModal}
            style={{
              padding: '8px 14px',
              background: 'linear-gradient(135deg, #FFD700 0%, #FFA000 100%)',
              border: 'none',
              borderRadius: '8px',
              color: '#050811',
              fontSize: '11px',
              fontWeight: 900,
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              gap: '6px',
              boxShadow: '0 4px 12px rgba(255, 215, 0, 0.3)'
            }}
          >
            <Shield size={13} /> SuperAdmin Login
          </button>
        )}
      </div>
    </header>
  );
};
