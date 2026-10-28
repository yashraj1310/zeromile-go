/**
 * =========================================================================
 * ZEROMILE GO - MAP LIGHTING & 3D CAMERA TOOLBAR (MapLightingToolbar.tsx)
 * 4 Lighting Modes (Dawn, Day, Dusk, Night) • 3D Tilt • Orbit • Radar
 * =========================================================================
 */

import React from 'react';
import { LightPreset } from './useMapbox';

interface MapLightingToolbarProps {
  currentLightPreset: LightPreset;
  onSelectLightPreset: (preset: LightPreset) => void;
  onLocateMe: () => void;
  isRadarActive: boolean;
  onToggleRadar: () => void;
  is3DTiltActive: boolean;
  onToggle3DTilt: () => void;
  isOrbiting: boolean;
  onToggleOrbit: () => void;
}

export const MapLightingToolbar: React.FC<MapLightingToolbarProps> = ({
  currentLightPreset,
  onSelectLightPreset,
  onLocateMe,
  isRadarActive,
  onToggleRadar,
  is3DTiltActive,
  onToggle3DTilt,
  isOrbiting,
  onToggleOrbit
}) => {
  return (
    <div className="gmaps-top-right-controls" style={{ position: 'absolute', top: '24px', right: '24px', zIndex: 45, display: 'flex', alignItems: 'center', gap: '10px' }}>
      {/* 4 Time-of-Day Lighting Mode Switcher */}
      <div className="map-lighting-pill" style={{ display: 'flex', background: 'rgba(15, 23, 42, 0.85)', backdropFilter: 'blur(12px)', padding: '4px', borderRadius: '30px', border: '1px solid rgba(255, 255, 255, 0.12)' }}>
        <button
          className={`time-btn ${currentLightPreset === 'dawn' ? 'active' : ''}`}
          onClick={() => onSelectLightPreset('dawn')}
          title="Dawn / Sunrise"
          style={{ width: '36px', height: '36px', borderRadius: '50%', border: currentLightPreset === 'dawn' ? '2px solid #00F2FE' : 'none', background: currentLightPreset === 'dawn' ? 'rgba(0,242,254,0.2)' : 'transparent', fontSize: '18px', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}
        >
          🌅
        </button>
        <button
          className={`time-btn ${currentLightPreset === 'day' ? 'active' : ''}`}
          onClick={() => onSelectLightPreset('day')}
          title="Day / Sun"
          style={{ width: '36px', height: '36px', borderRadius: '50%', border: currentLightPreset === 'day' ? '2px solid #00F2FE' : 'none', background: currentLightPreset === 'day' ? 'rgba(0,242,254,0.2)' : 'transparent', fontSize: '18px', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}
        >
          ☀️
        </button>
        <button
          className={`time-btn ${currentLightPreset === 'dusk' ? 'active' : ''}`}
          onClick={() => onSelectLightPreset('dusk')}
          title="Dusk / Sunset"
          style={{ width: '36px', height: '36px', borderRadius: '50%', border: currentLightPreset === 'dusk' ? '2px solid #00F2FE' : 'none', background: currentLightPreset === 'dusk' ? 'rgba(0,242,254,0.2)' : 'transparent', fontSize: '18px', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}
        >
          🌇
        </button>
        <button
          className={`time-btn ${currentLightPreset === 'night' ? 'active' : ''}`}
          onClick={() => onSelectLightPreset('night')}
          title="Night / Dark Cyberpunk"
          style={{ width: '36px', height: '36px', borderRadius: '50%', border: currentLightPreset === 'night' ? '2px solid #00F2FE' : 'none', background: currentLightPreset === 'night' ? 'rgba(0,242,254,0.2)' : 'transparent', fontSize: '18px', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}
        >
          🌙
        </button>
      </div>

      {/* Locate Me */}
      <button
        className="gmaps-control-btn btn-locate-me"
        onClick={onLocateMe}
        title="Locate My Live GPS Position on Map"
        style={{ height: '42px', padding: '0 14px', borderRadius: '24px', background: 'rgba(15, 23, 42, 0.85)', backdropFilter: 'blur(12px)', border: '1px solid rgba(255, 255, 255, 0.12)', color: '#fff', fontSize: '13px', fontWeight: 600, display: 'flex', alignItems: 'center', gap: '6px', cursor: 'pointer' }}
      >
        <span>📍</span> <span className="locate-text">Locate Me</span>
      </button>

      {/* Radar Mode */}
      <button
        className={`gmaps-control-btn ${isRadarActive ? 'active' : ''}`}
        onClick={onToggleRadar}
        title="Toggle Live Participant Mobility Radar & Peloton Stream"
        style={{ height: '42px', padding: '0 14px', borderRadius: '24px', background: isRadarActive ? 'rgba(41, 121, 255, 0.25)' : 'rgba(15, 23, 42, 0.85)', border: isRadarActive ? '1px solid #2979FF' : '1px solid rgba(255, 255, 255, 0.12)', color: '#fff', fontSize: '13px', fontWeight: 600, display: 'flex', alignItems: 'center', gap: '6px', cursor: 'pointer' }}
      >
        <span>🚴</span> Radar: <b style={{ color: isRadarActive ? '#00F2FE' : '#94A3B8' }}>{isRadarActive ? 'ON' : 'OFF'}</b>
      </button>

      {/* 3D Tilt */}
      <button
        className={`gmaps-control-btn ${is3DTiltActive ? 'active' : ''}`}
        onClick={onToggle3DTilt}
        title="Toggle True 3D Isometric Buildings & Terrain"
        style={{ height: '42px', padding: '0 14px', borderRadius: '24px', background: is3DTiltActive ? 'rgba(41, 121, 255, 0.25)' : 'rgba(15, 23, 42, 0.85)', border: is3DTiltActive ? '1px solid #2979FF' : '1px solid rgba(255, 255, 255, 0.12)', color: '#fff', fontSize: '13px', fontWeight: 600, display: 'flex', alignItems: 'center', gap: '6px', cursor: 'pointer' }}
      >
        <span>🏙️</span> 3D Tilt: <b style={{ color: is3DTiltActive ? '#00F2FE' : '#94A3B8' }}>{is3DTiltActive ? 'ON' : 'OFF'}</b>
      </button>

      {/* 3D Orbit */}
      <button
        className={`gmaps-control-btn ${isOrbiting ? 'active' : ''}`}
        onClick={onToggleOrbit}
        title="360° Camera Auto-Orbit"
        style={{ height: '42px', padding: '0 14px', borderRadius: '24px', background: isOrbiting ? 'rgba(0, 230, 118, 0.25)' : 'rgba(15, 23, 42, 0.85)', border: isOrbiting ? '1px solid #00E676' : '1px solid rgba(255, 255, 255, 0.12)', color: '#fff', fontSize: '13px', fontWeight: 600, display: 'flex', alignItems: 'center', gap: '6px', cursor: 'pointer' }}
      >
        <span>🔄</span> 3D Orbit
      </button>
    </div>
  );
};
