/**
 * =========================================================================
 * ZEROMILE GO - COMMUTER ROUTE PANEL (CommuterRoutePanel.tsx)
 * Reconstructed from Authoritative index.html (Lines 421 - 500)
 * =========================================================================
 */

import React, { useState } from 'react';
import { NamedLocation } from '../../types';
import { NAGPUR_REGISTRY, findNagpurPlace } from '../../services/nagpurRegistry';
import { LocationSearchInput } from '../../components/common/LocationSearchInput';

interface CommuterRoutePanelProps {
  origin: NamedLocation;
  destination: NamedLocation;
  onOriginChange: (loc: NamedLocation) => void;
  onDestinationChange: (loc: NamedLocation) => void;
  onSelectRoute: (coords: [number, number][]) => void;
  onReturnToLanding: () => void;
  onOpenSuperAdminPortal: () => void;
  onSwitchToStudio?: () => void;
}

export const CommuterRoutePanel: React.FC<CommuterRoutePanelProps> = ({
  origin,
  destination,
  onOriginChange,
  onDestinationChange,
  onSelectRoute,
  onReturnToLanding,
  onOpenSuperAdminPortal,
  onSwitchToStudio
}) => {
  const [transitMode, setTransitMode] = useState<'driving' | 'cycling' | 'walking'>('driving');
  const [selectedRouteKey, setSelectedRouteKey] = useState<'alt2' | 'direct'>('alt2');

  const handleQuickRoute = (oId: string, dId: string) => {
    const o = findNagpurPlace(oId) || NAGPUR_REGISTRY.find(p => p.id === oId);
    const d = findNagpurPlace(dId) || NAGPUR_REGISTRY.find(p => p.id === dId);
    if (o) onOriginChange(o);
    if (d) onDestinationChange(d);
  };

  return (
    <div
      style={{
        width: '380px',
        maxHeight: 'calc(100vh - 48px)',
        overflowY: 'auto',
        background: 'rgba(10, 15, 29, 0.94)',
        backdropFilter: 'blur(20px)',
        border: '1px solid rgba(255, 255, 255, 0.12)',
        borderRadius: '20px',
        boxShadow: '0 20px 50px rgba(0, 0, 0, 0.6)',
        padding: '16px',
        display: 'flex',
        flexDirection: 'column',
        gap: '12px',
        color: '#fff'
      }}
    >
      {/* Header Bar */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <button
          onClick={onReturnToLanding}
          title="Return to Landing Page"
          style={{
            padding: '6px 12px',
            borderRadius: '16px',
            background: 'rgba(255, 255, 255, 0.08)',
            border: '1px solid rgba(255, 255, 255, 0.1)',
            color: '#fff',
            fontSize: '12px',
            fontWeight: 700,
            cursor: 'pointer',
            display: 'flex',
            alignItems: 'center',
            gap: '6px'
          }}
        >
          <span>←</span> Home
        </button>

        {/* Transit Mode Switcher */}
        <div style={{ display: 'flex', gap: '4px', background: 'rgba(0,0,0,0.3)', padding: '3px', borderRadius: '14px' }}>
          <button
            onClick={() => setTransitMode('driving')}
            style={{ width: '32px', height: '32px', borderRadius: '10px', background: transitMode === 'driving' ? '#2979FF' : 'transparent', border: 'none', color: '#fff', cursor: 'pointer', fontSize: '15px' }}
            title="Driving Mode"
          >
            🚗
          </button>
          <button
            onClick={() => setTransitMode('cycling')}
            style={{ width: '32px', height: '32px', borderRadius: '10px', background: transitMode === 'cycling' ? '#2979FF' : 'transparent', border: 'none', color: '#fff', cursor: 'pointer', fontSize: '15px' }}
            title="Cycling Mode"
          >
            🚴
          </button>
          <button
            onClick={() => setTransitMode('walking')}
            style={{ width: '32px', height: '32px', borderRadius: '10px', background: transitMode === 'walking' ? '#2979FF' : 'transparent', border: 'none', color: '#fff', cursor: 'pointer', fontSize: '15px' }}
            title="Walking Mode"
          >
            🚶
          </button>
        </div>

        <div style={{ display: 'flex', gap: '6px' }}>
          {onSwitchToStudio && (
            <button
              onClick={onSwitchToStudio}
              title="Switch to Corridor Studio & Command Center (Guest View)"
              style={{ padding: '6px 10px', borderRadius: '12px', background: 'rgba(0, 242, 254, 0.15)', border: '1px solid rgba(0, 242, 254, 0.35)', color: '#00F2FE', fontSize: '11px', fontWeight: 800, cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '4px' }}
            >
              <span>🛡️</span> Studio
            </button>
          )}
          <button
            onClick={onOpenSuperAdminPortal}
            style={{ padding: '6px 10px', borderRadius: '12px', background: 'rgba(255, 215, 0, 0.12)', border: '1px solid rgba(255, 215, 0, 0.3)', color: '#FFD700', fontSize: '11px', fontWeight: 800, cursor: 'pointer' }}
          >
            Admin
          </button>
        </div>
      </div>

      {/* Dual Search Fields with Geocoding */}
      <div style={{ background: 'rgba(0,0,0,0.3)', border: '1px solid rgba(255,255,255,0.08)', borderRadius: '14px', padding: '12px', display: 'flex', flexDirection: 'column', gap: '10px' }}>
        <LocationSearchInput
          label="START LOCATION"
          placeholder="Search start location in Nagpur..."
          value={origin}
          onSelect={onOriginChange}
          accentColor="#00E676"
        />

        <div style={{ height: '1px', background: 'rgba(255,255,255,0.06)' }}></div>

        <LocationSearchInput
          label="DESTINATION"
          placeholder="Search destination in Nagpur..."
          value={destination}
          onSelect={onDestinationChange}
          accentColor="#FF1744"
        />
      </div>

      {/* Quick Route Chips */}
      <div style={{ display: 'flex', gap: '4px', flexWrap: 'wrap' }}>
        <button onClick={() => handleQuickRoute('vnit', 'zeromile')} style={{ padding: '4px 8px', borderRadius: '6px', background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.08)', color: '#CBD5E1', fontSize: '10px', cursor: 'pointer' }}>VNIT → Zero Mile</button>
        <button onClick={() => handleQuickRoute('aiims', 'sitabuldi')} style={{ padding: '4px 8px', borderRadius: '6px', background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.08)', color: '#CBD5E1', fontSize: '10px', cursor: 'pointer' }}>AIIMS → Sitabuldi</button>
        <button onClick={() => handleQuickRoute('futala', 'seminary')} style={{ padding: '4px 8px', borderRadius: '6px', background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.08)', color: '#CBD5E1', fontSize: '10px', cursor: 'pointer' }}>Futala → Seminary</button>
      </div>

      {/* Route Options Summary */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
        {/* Option 1: Fastest Clean Bypass (Recommended) */}
        <div
          onClick={() => setSelectedRouteKey('alt2')}
          style={{
            padding: '12px',
            borderRadius: '12px',
            background: selectedRouteKey === 'alt2' ? 'rgba(0, 230, 118, 0.12)' : 'rgba(255,255,255,0.03)',
            border: selectedRouteKey === 'alt2' ? '1px solid #00E676' : '1px solid rgba(255,255,255,0.08)',
            cursor: 'pointer'
          }}
        >
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '4px' }}>
            <span style={{ fontSize: '14px', fontWeight: 800, color: '#00E676' }}>14 min (5.8 km)</span>
            <span style={{ fontSize: '9px', fontWeight: 900, padding: '2px 6px', borderRadius: '4px', background: 'rgba(0, 230, 118, 0.25)', color: '#00E676' }}>
              FASTEST • ZERO EVENT CONFLICTS
            </span>
          </div>
          <div style={{ fontSize: '11px', color: '#CBD5E1' }}>via Ambazari &amp; North Ambazari Rd Bypass</div>
        </div>

        {/* Option 2: Direct Corridor (Event Delay) */}
        <div
          onClick={() => setSelectedRouteKey('direct')}
          style={{
            padding: '12px',
            borderRadius: '12px',
            background: selectedRouteKey === 'direct' ? 'rgba(255, 23, 68, 0.12)' : 'rgba(255,255,255,0.03)',
            border: selectedRouteKey === 'direct' ? '1px solid #FF1744' : '1px solid rgba(255,255,255,0.08)',
            cursor: 'pointer'
          }}
        >
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '4px' }}>
            <span style={{ fontSize: '14px', fontWeight: 800, color: '#FF1744' }}>34 min (6.4 km)</span>
            <span style={{ fontSize: '9px', fontWeight: 900, padding: '2px 6px', borderRadius: '4px', background: 'rgba(255, 23, 68, 0.25)', color: '#FF1744' }}>
              +20 MIN EVENT DELAY
            </span>
          </div>
          <div style={{ fontSize: '11px', color: '#94A3B8' }}>via Wardha Road (Active Cyclothon Corridor)</div>
        </div>
      </div>
    </div>
  );
};
