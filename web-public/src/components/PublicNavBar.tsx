import React, { useState } from 'react';
import { Bike, Footprints, Flame, Sparkles } from 'lucide-react';

export const PublicNavBar: React.FC = () => {
  const [activeMode, setActiveMode] = useState<'cycling' | 'marathon' | 'walkathon' | 'parade'>('cycling');

  return (
    <header style={{
      height: '64px',
      backgroundColor: '#090D16',
      borderBottom: '1px solid rgba(255, 255, 255, 0.08)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: '0 24px',
      color: '#FFFFFF'
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
        <div style={{ width: '12px', height: '12px', borderRadius: '50%', backgroundColor: '#00F2FE', boxShadow: '0 0 10px #00F2FE' }} />
        <span style={{ fontFamily: 'Outfit, sans-serif', fontWeight: 700, fontSize: '18px', letterSpacing: '-0.3px' }}>
          VIKASIT NAGPUR <span style={{ color: '#00F2FE', fontSize: '12px', fontWeight: 600 }}>LIVE</span>
        </span>
      </div>

      <nav style={{ display: 'flex', gap: '8px' }}>
        <button
          onClick={() => setActiveMode('cycling')}
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '6px',
            padding: '8px 16px',
            borderRadius: '20px',
            backgroundColor: activeMode === 'cycling' ? 'rgba(0, 242, 254, 0.15)' : '#131B2E',
            color: activeMode === 'cycling' ? '#00F2FE' : '#94A3B8',
            border: `1px solid ${activeMode === 'cycling' ? '#00F2FE' : 'rgba(255, 255, 255, 0.08)'}`,
            cursor: 'pointer',
            fontWeight: 600,
            fontSize: '13px'
          }}
        >
          <Bike size={16} /> Cycling
        </button>

        <button
          onClick={() => setActiveMode('marathon')}
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '6px',
            padding: '8px 16px',
            borderRadius: '20px',
            backgroundColor: activeMode === 'marathon' ? 'rgba(0, 230, 118, 0.15)' : '#131B2E',
            color: activeMode === 'marathon' ? '#00E676' : '#94A3B8',
            border: `1px solid ${activeMode === 'marathon' ? '#00E676' : 'rgba(255, 255, 255, 0.08)'}`,
            cursor: 'pointer',
            fontWeight: 600,
            fontSize: '13px'
          }}
        >
          <Flame size={16} /> Marathon
        </button>

        <button
          onClick={() => setActiveMode('walkathon')}
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '6px',
            padding: '8px 16px',
            borderRadius: '20px',
            backgroundColor: activeMode === 'walkathon' ? 'rgba(255, 145, 0, 0.15)' : '#131B2E',
            color: activeMode === 'walkathon' ? '#FF9100' : '#94A3B8',
            border: `1px solid ${activeMode === 'walkathon' ? '#FF9100' : 'rgba(255, 255, 255, 0.08)'}`,
            cursor: 'pointer',
            fontWeight: 600,
            fontSize: '13px'
          }}
        >
          <Footprints size={16} /> Walkathon
        </button>
      </nav>
    </header>
  );
};
