import React, { useState } from 'react';
import { PublicWebViewer } from './PublicWebViewer';
import { MobileSimulator } from './MobileSimulator';
import { SmartwatchSimulator } from './SmartwatchSimulator';
import { Monitor, Smartphone, Watch } from 'lucide-react';

export const DeviceSimulator: React.FC = () => {
  const [deviceMode, setDeviceMode] = useState<'web' | 'mobile' | 'watch'>('web');

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100vh', backgroundColor: '#090D16', overflow: 'hidden' }}>
      {/* Top Universal Device Switcher Bar */}
      <div style={{
        height: '48px',
        backgroundColor: '#060910',
        borderBottom: '1px solid rgba(255, 255, 255, 0.08)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: '0 20px',
        zIndex: 1000
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <span style={{ fontSize: '11px', fontWeight: 800, color: '#00F2FE', letterSpacing: '0.8px' }}>
            VIKASIT NAGPUR
          </span>
          <span style={{ fontSize: '11px', color: '#64748B' }}>| Multi-Platform Live Preview</span>
        </div>

        {/* Device Switcher Pills */}
        <div style={{ display: 'flex', gap: '6px' }}>
          <button
            onClick={() => setDeviceMode('web')}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '6px',
              padding: '5px 12px',
              borderRadius: '8px',
              backgroundColor: deviceMode === 'web' ? '#131B2E' : 'transparent',
              color: deviceMode === 'web' ? '#00F2FE' : '#94A3B8',
              border: `1px solid ${deviceMode === 'web' ? '#00F2FE' : 'transparent'}`,
              fontSize: '11px',
              fontWeight: 700,
              cursor: 'pointer'
            }}
          >
            <Monitor size={14} /> 🖥️ Desktop Web View
          </button>

          <button
            onClick={() => setDeviceMode('mobile')}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '6px',
              padding: '5px 12px',
              borderRadius: '8px',
              backgroundColor: deviceMode === 'mobile' ? '#131B2E' : 'transparent',
              color: deviceMode === 'mobile' ? '#00E676' : '#94A3B8',
              border: `1px solid ${deviceMode === 'mobile' ? '#00E676' : 'transparent'}`,
              fontSize: '11px',
              fontWeight: 700,
              cursor: 'pointer'
            }}
          >
            <Smartphone size={14} /> 📱 Mobile App (4 Roles)
          </button>

          <button
            onClick={() => setDeviceMode('watch')}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '6px',
              padding: '5px 12px',
              borderRadius: '8px',
              backgroundColor: deviceMode === 'watch' ? '#131B2E' : 'transparent',
              color: deviceMode === 'watch' ? '#FF9100' : '#94A3B8',
              border: `1px solid ${deviceMode === 'watch' ? '#FF9100' : 'transparent'}`,
              fontSize: '11px',
              fontWeight: 700,
              cursor: 'pointer'
            }}
          >
            <Watch size={14} /> ⌚ Smartwatch HUD
          </button>
        </div>

        <div style={{ fontSize: '11px', color: '#00E676', fontWeight: 600, display: 'flex', alignItems: 'center', gap: '6px' }}>
          <span style={{ width: '6px', height: '6px', borderRadius: '50%', backgroundColor: '#00E676' }} />
          Localhost Live
        </div>
      </div>

      {/* Active Device Viewport */}
      <div style={{ flex: 1, overflowY: 'auto' }}>
        {deviceMode === 'web' && <PublicWebViewer />}
        {deviceMode === 'mobile' && <MobileSimulator />}
        {deviceMode === 'watch' && <SmartwatchSimulator />}
      </div>
    </div>
  );
};
