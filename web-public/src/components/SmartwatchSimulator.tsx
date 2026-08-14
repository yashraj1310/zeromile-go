import React, { useState } from 'react';
import { AlertCircle, Zap, Heart, CheckCircle2 } from 'lucide-react';

export const SmartwatchSimulator: React.FC = () => {
  const [sosTriggered, setSosTriggered] = useState(false);
  const [speed, setSpeed] = useState(24.5);

  const handleSosClick = () => {
    setSosTriggered(true);
    setTimeout(() => setSosTriggered(false), 4000);
  };

  return (
    <div style={{
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '40px 20px',
      color: '#FFFFFF'
    }}>
      <div style={{ marginBottom: '16px', textAlign: 'center' }}>
        <span style={{
          backgroundColor: 'rgba(0, 242, 254, 0.15)',
          color: '#00F2FE',
          padding: '4px 12px',
          borderRadius: '12px',
          fontSize: '11px',
          fontWeight: 700,
          letterSpacing: '0.8px'
        }}>
          WEAR OS / APPLE WATCH LIVE SIMULATOR
        </span>
        <h3 style={{ margin: '8px 0 4px', fontFamily: 'Outfit, sans-serif' }}>Rider Smartwatch Companion Face</h3>
        <p style={{ margin: 0, color: '#94A3B8', fontSize: '13px' }}>Stand-alone live telemetry HUD & instant emergency SOS trigger</p>
      </div>

      {/* Realistic Smartwatch Circular Chassis */}
      <div style={{
        width: '300px',
        height: '300px',
        borderRadius: '50%',
        backgroundColor: '#090D16',
        border: '10px solid #1E293B',
        boxShadow: '0 20px 50px rgba(0, 0, 0, 0.8), 0 0 30px rgba(0, 242, 254, 0.2)',
        position: 'relative',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '24px',
        boxSizing: 'border-box',
        overflow: 'hidden'
      }}>
        {/* Watch Crown button on right */}
        <div style={{
          position: 'absolute',
          right: '-16px',
          top: '50%',
          transform: 'translateY(-50%)',
          width: '8px',
          height: '40px',
          backgroundColor: '#334155',
          borderRadius: '4px'
        }} />

        {sosTriggered ? (
          <div style={{ textAlign: 'center', animation: 'fadeIn 0.3s ease-in-out' }}>
            <AlertCircle size={48} color="#FF1744" style={{ marginBottom: '8px' }} />
            <div style={{ color: '#FF1744', fontWeight: 900, fontSize: '16px', letterSpacing: '0.5px' }}>
              🚨 SOS SENT!
            </div>
            <div style={{ color: '#FFFFFF', fontSize: '11px', marginTop: '4px' }}>
              GPS: Futala Lake Chowk
            </div>
            <div style={{ color: '#00E676', fontSize: '10px', marginTop: '6px', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '4px' }}>
              <CheckCircle2 size={12} /> Police & Admin Alerted
            </div>
          </div>
        ) : (
          <>
            {/* Top Stat Bar */}
            <div style={{ display: 'flex', gap: '16px', fontSize: '11px', color: '#94A3B8', marginBottom: '4px' }}>
              <span style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                <Heart size={12} color="#FF1744" /> 148 BPM
              </span>
              <span style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                <Zap size={12} color="#00F2FE" /> 12.4 KM
              </span>
            </div>

            {/* Giant Speed Telemetry */}
            <div style={{
              fontSize: '48px',
              fontFamily: 'JetBrains Mono, monospace',
              fontWeight: 800,
              color: '#00F2FE',
              lineHeight: 1,
              margin: '6px 0 2px'
            }}>
              {speed}
            </div>
            <div style={{ fontSize: '10px', fontWeight: 700, letterSpacing: '1px', color: '#64748B' }}>
              KM / H
            </div>

            {/* Hold to SOS Button */}
            <button
              onClick={handleSosClick}
              style={{
                marginTop: '16px',
                backgroundColor: '#FF1744',
                color: '#FFFFFF',
                border: 'none',
                borderRadius: '20px',
                padding: '8px 24px',
                fontWeight: 900,
                fontSize: '12px',
                letterSpacing: '1px',
                cursor: 'pointer',
                boxShadow: '0 0 15px rgba(255, 23, 68, 0.5)',
                display: 'flex',
                alignItems: 'center',
                gap: '6px'
              }}
            >
              <AlertCircle size={14} /> TAP SOS
            </button>
          </>
        )}
      </div>

      <div style={{ marginTop: '20px', display: 'flex', gap: '10px' }}>
        <button
          onClick={() => setSpeed(prev => Number((prev + 2.1).toFixed(1)))}
          style={{
            padding: '6px 14px',
            backgroundColor: '#131B2E',
            border: '1px solid rgba(255, 255, 255, 0.08)',
            color: '#00F2FE',
            borderRadius: '8px',
            cursor: 'pointer',
            fontSize: '12px',
            fontWeight: 600
          }}
        >
          Accelerate 🚴
        </button>
        <button
          onClick={() => setSpeed(prev => Math.max(0, Number((prev - 2.5).toFixed(1))))}
          style={{
            padding: '6px 14px',
            backgroundColor: '#131B2E',
            border: '1px solid rgba(255, 255, 255, 0.08)',
            color: '#94A3B8',
            borderRadius: '8px',
            cursor: 'pointer',
            fontSize: '12px',
            fontWeight: 600
          }}
        >
          Brake 🛑
        </button>
      </div>
    </div>
  );
};
