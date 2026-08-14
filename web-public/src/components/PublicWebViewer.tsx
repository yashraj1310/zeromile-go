import React from 'react';
import { PublicNavBar } from './PublicNavBar';
import { BroadcastDrawer } from './BroadcastDrawer';
import { MapPin, Navigation } from 'lucide-react';

export const PublicWebViewer: React.FC = () => {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100vh', backgroundColor: '#090D16', color: '#FFFFFF' }}>
      <PublicNavBar />
      <div style={{ display: 'flex', flex: 1, overflow: 'hidden' }}>
        {/* Full Map Canvas Layer */}
        <main style={{
          flex: 1,
          position: 'relative',
          backgroundColor: '#0D1424',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center'
        }}>
          <div style={{ textAlign: 'center' }}>
            <Navigation size={48} color="#00F2FE" style={{ marginBottom: '12px' }} />
            <h2 style={{ margin: 0, fontFamily: 'Outfit, sans-serif' }}>Nagpur Public Live Vector Map</h2>
            <p style={{ color: '#94A3B8', fontSize: '14px' }}>Real-time route polylines & open-road traffic slowdown advisories</p>
          </div>

          {/* Commuter Alert Pill at Bottom of Map */}
          <div style={{
            position: 'absolute',
            bottom: '24px',
            left: '24px',
            right: '24px',
            backgroundColor: 'rgba(19, 27, 46, 0.9)',
            backdropFilter: 'blur(16px)',
            border: '1px solid rgba(255, 145, 0, 0.4)',
            borderRadius: '12px',
            padding: '14px 20px',
            display: 'flex',
            alignItems: 'center',
            gap: '12px'
          }}>
            <MapPin size={20} color="#FF9100" />
            <span style={{ fontSize: '13px', color: '#FFFFFF', fontWeight: 500 }}>
              Live Traffic Advisory: Roads remain open to public. Expect 10-15m slowdowns along Wardha Road corridor.
            </span>
          </div>
        </main>

        {/* Live Broadcast Feed Drawer */}
        <BroadcastDrawer />
      </div>
    </div>
  );
};
