/**
 * =========================================================================
 * ZEROMILE GO - SUPERADMIN CORRIDOR STUDIO & OPERATIONS (RouteStudioPanel.tsx)
 * Reconstructed from Video (00:00 - 00:98)
 * =========================================================================
 */

import React, { useState } from 'react';
import { NamedLocation, RouteStats, BroadcastMessage, SosEvent } from '../../types';
import { SuperAdminCommandCenter } from '../admin/SuperAdminCommandCenter';
import { saveDomainRouteGeojson } from '../../services/supabaseClient';
import { useToast } from '../../context/ToastContext';
import { NAGPUR_REGISTRY, findNagpurPlace } from '../../services/nagpurRegistry';
import { LocationSearchInput } from '../../components/common/LocationSearchInput';

interface RouteStudioPanelProps {
  domainId: string;
  domainTitle: string;
  adminPhone: string;
  origin: NamedLocation;
  destination: NamedLocation;
  waypoints: NamedLocation[];
  routeStats: RouteStats;
  checkpointsCount: number;
  canUndo: boolean;
  canRedo: boolean;
  onUndo: () => void;
  onRedo: () => void;
  onNorthAlign: () => void;
  onReturnToLanding: () => void;
  onLogout: () => void;
  onEndpointsChange: (origin: NamedLocation, destination: NamedLocation) => void;
  isLiveMotionActive: boolean;
  onToggleLiveMotion: () => void;
  isAdjustingWaypoints: boolean;
  onToggleAdjustWaypoints: () => void;
  isBarricadeModeActive: boolean;
  onToggleBarricadeMode: () => void;
  onOpenAddCheckpoint: () => void;
  onOpenBroadcastModal: () => void;
  broadcasts: BroadcastMessage[];
  sosEvents: SosEvent[];
  onRefreshData: () => void;
  currentRouteCoords: [number, number][];
  onSwitchToCommuter?: () => void;
  isGuestView?: boolean;
}

export const RouteStudioPanel: React.FC<RouteStudioPanelProps> = ({
  domainId,
  domainTitle,
  adminPhone,
  origin,
  destination,
  waypoints,
  routeStats,
  checkpointsCount,
  canUndo,
  canRedo,
  onUndo,
  onRedo,
  onNorthAlign,
  onReturnToLanding,
  onLogout,
  onEndpointsChange,
  isLiveMotionActive,
  onToggleLiveMotion,
  isAdjustingWaypoints,
  onToggleAdjustWaypoints,
  isBarricadeModeActive,
  onToggleBarricadeMode,
  onOpenAddCheckpoint,
  onOpenBroadcastModal,
  broadcasts,
  sosEvents,
  onRefreshData,
  currentRouteCoords,
  onSwitchToCommuter,
  isGuestView = false
}) => {
  const { showToast } = useToast();
  const [activeTab, setActiveTab] = useState<'STUDIO' | 'COMMAND'>('STUDIO');
  const [isSaving, setIsSaving] = useState(false);
  const [isEditingEndpoints, setIsEditingEndpoints] = useState(false);

  const handleSwap = () => {
    onEndpointsChange(destination, origin);
  };

  const handleQuickChip = (originId: string, destId: string) => {
    const o = findNagpurPlace(originId) || NAGPUR_REGISTRY.find(p => p.id === originId) || origin;
    const d = findNagpurPlace(destId) || NAGPUR_REGISTRY.find(p => p.id === destId) || destination;
    onEndpointsChange(o, d);
  };

  const handleSaveRoute = async () => {
    if (currentRouteCoords.length === 0) return;
    setIsSaving(true);

    const geojson = {
      type: 'FeatureCollection',
      features: [
        {
          type: 'Feature',
          properties: {
            name: `Official ${domainTitle} Corridor`,
            distance_km: routeStats.distanceKm,
            duration_min: routeStats.durationMin,
            updated_at: new Date().toISOString()
          },
          geometry: {
            type: 'LineString',
            coordinates: currentRouteCoords
          }
        }
      ]
    };

    const success = await saveDomainRouteGeojson(domainId, geojson);
    setIsSaving(false);

    if (success) {
      showToast('⚡ <b>Official Route Published & Locked!</b> Saved to live Supabase database.', 'success');
    } else {
      showToast('❌ Failed to publish route to database.', 'error');
    }
  };

  return (
    <div
      style={{
        width: '380px',
        maxHeight: 'calc(100vh - 120px)',
        overflowY: 'auto',
        background: 'rgba(10, 15, 29, 0.94)',
        backdropFilter: 'blur(20px)',
        border: '1px solid rgba(255, 255, 255, 0.12)',
        borderRadius: '20px',
        boxShadow: '0 20px 50px rgba(0, 0, 0, 0.6)',
        padding: '18px',
        display: 'flex',
        flexDirection: 'column',
        gap: '14px',
        color: '#fff'
      }}
    >
      {/* 1. Top Bar: Back Arrow, Commuter Switch & Identity Chip */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
          <button
            onClick={onReturnToLanding}
            title="Return to Public Landing Page"
            style={{
              width: '32px',
              height: '32px',
              borderRadius: '50%',
              background: 'rgba(255, 255, 255, 0.08)',
              border: '1px solid rgba(255, 255, 255, 0.1)',
              color: '#fff',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              cursor: 'pointer',
              fontSize: '14px'
            }}
          >
            ←
          </button>
          {onSwitchToCommuter && (
            <button
              onClick={onSwitchToCommuter}
              title="Switch to Commuter Transit Navigation"
              style={{
                padding: '6px 10px',
                borderRadius: '12px',
                background: 'rgba(0, 242, 254, 0.15)',
                border: '1px solid rgba(0, 242, 254, 0.35)',
                color: '#00F2FE',
                fontSize: '11px',
                fontWeight: 800,
                cursor: 'pointer'
              }}
            >
              🚗 Commuter
            </button>
          )}
        </div>

        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '6px',
            padding: '4px 10px',
            borderRadius: '20px',
            background: isGuestView ? 'rgba(0, 242, 254, 0.15)' : 'rgba(255, 215, 0, 0.15)',
            border: isGuestView ? '1px solid rgba(0, 242, 254, 0.4)' : '1px solid rgba(255, 215, 0, 0.4)',
            fontSize: '10px',
            fontWeight: 800,
            color: isGuestView ? '#00F2FE' : '#FFD700'
          }}
        >
          <span style={{ width: '6px', height: '6px', borderRadius: '50%', background: isGuestView ? '#00F2FE' : '#00E676' }}></span>
          <span>
            {isGuestView
              ? '👁️ GUEST VIEW (ALL UNLOCKED)'
              : `SUPERADMIN • +91 ${adminPhone}`}
          </span>
          <button
            onClick={onLogout}
            title={isGuestView ? 'Exit Guest View' : 'Log Out'}
            style={{ background: 'none', border: 'none', color: '#94A3B8', cursor: 'pointer', marginLeft: '4px', fontSize: '11px' }}
          >
            ✕
          </button>
        </div>
      </div>

      {/* 2. Mode Tabs: Route Studio vs Command Center */}
      <div style={{ display: 'flex', gap: '8px', background: 'rgba(0, 0, 0, 0.3)', padding: '4px', borderRadius: '12px' }}>
        <button
          onClick={() => setActiveTab('STUDIO')}
          style={{
            flex: 1,
            padding: '8px 12px',
            borderRadius: '8px',
            background: activeTab === 'STUDIO' ? '#2979FF' : 'transparent',
            border: 'none',
            color: '#fff',
            fontSize: '12px',
            fontWeight: 800,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '6px',
            cursor: 'pointer'
          }}
        >
          <span>🗺️</span> Route Studio
        </button>
        <button
          onClick={() => setActiveTab('COMMAND')}
          style={{
            flex: 1,
            padding: '8px 12px',
            borderRadius: '8px',
            background: activeTab === 'COMMAND' ? '#2979FF' : 'transparent',
            border: 'none',
            color: '#fff',
            fontSize: '12px',
            fontWeight: 800,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '6px',
            cursor: 'pointer'
          }}
        >
          <span>📊</span> Command Center
        </button>
      </div>

      {/* TAB CONTENT */}
      {activeTab === 'STUDIO' ? (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
          {/* Header & Subtitle */}
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <div>
              <h2 style={{ fontSize: '16px', fontWeight: 900, letterSpacing: '-0.3px', margin: 0 }}>
                {domainTitle.toUpperCase()} STUDIO
              </h2>
              <p style={{ fontSize: '11px', color: '#94A3B8', marginTop: '2px', lineHeight: 1.3 }}>
                Design, Reroute &amp; Manage High-Visibility Official Corridors
              </p>
            </div>
            <span style={{ fontSize: '9px', fontWeight: 900, padding: '2px 6px', borderRadius: '4px', background: 'rgba(255, 215, 0, 0.15)', color: '#FFD700', border: '1px solid rgba(255, 215, 0, 0.3)' }}>
              OFFICIAL PATH
            </span>
          </div>

          {/* Action Row: Undo, Redo, North Align */}
          <div style={{ display: 'flex', gap: '8px' }}>
            <button
              onClick={onUndo}
              disabled={!canUndo}
              style={{
                flex: 1,
                padding: '6px 10px',
                borderRadius: '8px',
                background: canUndo ? 'rgba(255,255,255,0.08)' : 'rgba(255,255,255,0.02)',
                border: '1px solid rgba(255,255,255,0.08)',
                color: canUndo ? '#fff' : '#475569',
                fontSize: '11px',
                fontWeight: 700,
                cursor: canUndo ? 'pointer' : 'default'
              }}
            >
              ↩ Undo
            </button>
            <button
              onClick={onRedo}
              disabled={!canRedo}
              style={{
                flex: 1,
                padding: '6px 10px',
                borderRadius: '8px',
                background: canRedo ? 'rgba(255,255,255,0.08)' : 'rgba(255,255,255,0.02)',
                border: '1px solid rgba(255,255,255,0.08)',
                color: canRedo ? '#fff' : '#475569',
                fontSize: '11px',
                fontWeight: 700,
                cursor: canRedo ? 'pointer' : 'default'
              }}
            >
              ↪ Redo
            </button>
            <button
              onClick={onNorthAlign}
              style={{
                flex: 1.2,
                padding: '6px 10px',
                borderRadius: '8px',
                background: 'rgba(255,255,255,0.08)',
                border: '1px solid rgba(255,255,255,0.08)',
                color: '#fff',
                fontSize: '11px',
                fontWeight: 700,
                cursor: 'pointer'
              }}
            >
              🧭 North Align
            </button>
          </div>

          {/* Official Route Endpoints Box with Geocoding */}
          <div style={{ background: 'rgba(0,0,0,0.3)', border: '1px solid rgba(255,255,255,0.08)', borderRadius: '12px', padding: '12px' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '8px' }}>
              <div style={{ fontSize: '10px', fontWeight: 800, color: '#64748B', letterSpacing: '0.5px' }}>
                ↑ OFFICIAL EVENT ROUTE ENDPOINTS
              </div>
              <button
                type="button"
                onClick={() => setIsEditingEndpoints(prev => !prev)}
                style={{
                  padding: '3px 8px',
                  borderRadius: '6px',
                  background: isEditingEndpoints ? 'rgba(0, 242, 254, 0.2)' : 'rgba(255, 255, 255, 0.08)',
                  border: isEditingEndpoints ? '1px solid #00F2FE' : '1px solid rgba(255, 255, 255, 0.1)',
                  color: isEditingEndpoints ? '#00F2FE' : '#94A3B8',
                  fontSize: '10px',
                  fontWeight: 800,
                  cursor: 'pointer'
                }}
              >
                {isEditingEndpoints ? 'Done' : '🔍 Search & Change'}
              </button>
            </div>

            {isEditingEndpoints ? (
              <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', marginBottom: '10px' }}>
                <LocationSearchInput
                  label="START / ASSEMBLY POINT"
                  placeholder="Search start location..."
                  value={origin}
                  onSelect={(loc) => onEndpointsChange(loc, destination)}
                  accentColor="#00E676"
                />
                <LocationSearchInput
                  label="FINISH LINE"
                  placeholder="Search finish location..."
                  value={destination}
                  onSelect={(loc) => onEndpointsChange(origin, loc)}
                  accentColor="#FF1744"
                />
              </div>
            ) : (
              <>
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '8px' }}>
                  <div style={{ flex: 1 }}>
                    <div style={{ fontSize: '9px', fontWeight: 800, color: '#00E676' }}>START / ASSEMBLY POINT</div>
                    <div style={{ fontSize: '12px', fontWeight: 700, color: '#fff', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                      {origin.name}
                    </div>
                  </div>
                  <button
                    onClick={handleSwap}
                    style={{ width: '28px', height: '28px', borderRadius: '50%', background: 'rgba(255,255,255,0.08)', border: 'none', color: '#fff', cursor: 'pointer', fontSize: '14px' }}
                    title="Swap Start & Finish"
                  >
                    ⇅
                  </button>
                </div>

                <div style={{ marginBottom: '10px' }}>
                  <div style={{ fontSize: '9px', fontWeight: 800, color: '#FF1744' }}>FINISH / DESTINATION LINE</div>
                  <div style={{ fontSize: '12px', fontWeight: 700, color: '#fff', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                    {destination.name}
                  </div>
                </div>
              </>
            )}

            {/* Quick Chips Row */}
            <div style={{ display: 'flex', gap: '4px', flexWrap: 'wrap' }}>
              <button onClick={() => handleQuickChip('vnit', 'zeromile')} style={{ padding: '4px 8px', borderRadius: '6px', background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.08)', color: '#CBD5E1', fontSize: '10px', cursor: 'pointer' }}>VNIT → Zero Mile</button>
              <button onClick={() => handleQuickChip('zeromile', 'kasturchand')} style={{ padding: '4px 8px', borderRadius: '6px', background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.08)', color: '#CBD5E1', fontSize: '10px', cursor: 'pointer' }}>Zero Mile → Kasturchand</button>
              <button onClick={() => handleQuickChip('aiims', 'sitabuldi')} style={{ padding: '4px 8px', borderRadius: '6px', background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.08)', color: '#CBD5E1', fontSize: '10px', cursor: 'pointer' }}>AIIMS → Sitabuldi</button>
              <button onClick={() => handleQuickChip('futala', 'seminary')} style={{ padding: '4px 8px', borderRadius: '6px', background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.08)', color: '#CBD5E1', fontSize: '10px', cursor: 'pointer' }}>Futala → Seminary</button>
            </div>
          </div>

          {/* Metric Cards Row */}
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '8px' }}>
            <div style={{ background: 'rgba(255, 215, 0, 0.06)', border: '1px solid rgba(255, 215, 0, 0.2)', borderRadius: '10px', padding: '10px 8px', textAlign: 'center' }}>
              <div style={{ fontSize: '16px', fontWeight: 900, color: '#FFD700' }}>{routeStats.distanceKm.toFixed(1)} km</div>
              <div style={{ fontSize: '9px', fontWeight: 800, color: '#94A3B8', marginTop: '2px' }}>TOTAL CORRIDOR</div>
            </div>
            <div style={{ background: 'rgba(0, 242, 254, 0.06)', border: '1px solid rgba(0, 242, 254, 0.2)', borderRadius: '10px', padding: '10px 8px', textAlign: 'center' }}>
              <div style={{ fontSize: '16px', fontWeight: 900, color: '#00F2FE' }}>{routeStats.durationMin} min</div>
              <div style={{ fontSize: '9px', fontWeight: 800, color: '#94A3B8', marginTop: '2px' }}>EST. RACE TIME</div>
            </div>
            <div style={{ background: 'rgba(255, 255, 255, 0.04)', border: '1px solid rgba(255, 255, 255, 0.1)', borderRadius: '10px', padding: '10px 8px', textAlign: 'center' }}>
              <div style={{ fontSize: '16px', fontWeight: 900, color: '#fff' }}>{checkpointsCount}</div>
              <div style={{ fontSize: '9px', fontWeight: 800, color: '#94A3B8', marginTop: '2px' }}>CHECKPOINTS</div>
            </div>
          </div>

          {/* Action Buttons Stack */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
            {/* Live Motion Button */}
            <button
              onClick={onToggleLiveMotion}
              style={{
                padding: '11px 14px',
                borderRadius: '10px',
                background: isLiveMotionActive ? '#00E676' : 'rgba(255,255,255,0.06)',
                border: isLiveMotionActive ? 'none' : '1px solid rgba(255,255,255,0.12)',
                color: isLiveMotionActive ? '#050811' : '#fff',
                fontWeight: 800,
                fontSize: '12px',
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                cursor: 'pointer',
                boxShadow: isLiveMotionActive ? '0 4px 16px rgba(0, 230, 118, 0.35)' : 'none'
              }}
            >
              <span>🚴</span> Live Motion &amp; Participant Stream ({isLiveMotionActive ? 'ON' : 'OFF'})
            </button>

            {/* Drag & Adjust Waypoints */}
            <button
              onClick={onToggleAdjustWaypoints}
              style={{
                padding: '11px 14px',
                borderRadius: '10px',
                background: isAdjustingWaypoints ? '#00F2FE' : 'rgba(255,255,255,0.06)',
                border: isAdjustingWaypoints ? 'none' : '1px solid rgba(255,255,255,0.12)',
                color: isAdjustingWaypoints ? '#050811' : '#fff',
                fontWeight: 800,
                fontSize: '12px',
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                cursor: 'pointer',
                boxShadow: isAdjustingWaypoints ? '0 4px 16px rgba(0, 242, 254, 0.35)' : 'none'
              }}
            >
              <span>✏️</span> {isAdjustingWaypoints ? 'Done Adjusting' : 'Drag & Adjust Route Waypoints'}
            </button>

            {/* Drop Police Barricade & Detour */}
            <button
              onClick={onToggleBarricadeMode}
              style={{
                padding: '11px 14px',
                borderRadius: '10px',
                background: isBarricadeModeActive ? '#00F2FE' : 'rgba(255,255,255,0.06)',
                border: isBarricadeModeActive ? 'none' : '1px solid rgba(255,255,255,0.12)',
                color: isBarricadeModeActive ? '#050811' : '#fff',
                fontWeight: 800,
                fontSize: '12px',
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                cursor: 'pointer',
                boxShadow: isBarricadeModeActive ? '0 4px 16px rgba(0, 242, 254, 0.35)' : 'none'
              }}
            >
              <span>🚧</span> {isBarricadeModeActive ? 'Click Road to Block' : 'Drop Police Barricade & Detour'}
            </button>

            {/* Add Snapped Checkpoint */}
            <button
              onClick={onOpenAddCheckpoint}
              style={{
                padding: '11px 14px',
                borderRadius: '10px',
                background: 'rgba(255,255,255,0.06)',
                border: '1px solid rgba(255,255,255,0.12)',
                color: '#fff',
                fontWeight: 800,
                fontSize: '12px',
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                cursor: 'pointer'
              }}
            >
              <span>➕</span> Add Snapped Checkpoint
            </button>

            {/* Broadcast Alert */}
            <button
              onClick={onOpenBroadcastModal}
              style={{
                padding: '11px 14px',
                borderRadius: '10px',
                background: 'rgba(255, 23, 68, 0.1)',
                border: '1px solid rgba(255, 23, 68, 0.3)',
                color: '#FF1744',
                fontWeight: 800,
                fontSize: '12px',
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                cursor: 'pointer'
              }}
            >
              <span>🚨</span> Broadcast Alert to Citizens
            </button>

            {/* Save & Lock Official Route */}
            <button
              onClick={handleSaveRoute}
              disabled={isSaving}
              style={{
                marginTop: '4px',
                padding: '13px 14px',
                borderRadius: '10px',
                background: 'linear-gradient(135deg, #00E676 0%, #00C853 100%)',
                border: 'none',
                color: '#050811',
                fontWeight: 900,
                fontSize: '13px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                gap: '8px',
                cursor: 'pointer',
                boxShadow: '0 4px 18px rgba(0, 230, 118, 0.4)'
              }}
            >
              <span>💾</span> {isSaving ? 'Publishing...' : 'Save & Lock Official Route'}
            </button>
          </div>
        </div>
      ) : (
        <SuperAdminCommandCenter
          domainId={domainId}
          domainTitle={domainTitle}
          adminPhone={adminPhone}
          broadcasts={broadcasts}
          sosEvents={sosEvents}
          onRefresh={onRefreshData}
        />
      )}
    </div>
  );
};
