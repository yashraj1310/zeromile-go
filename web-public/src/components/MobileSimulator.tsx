import React, { useState } from 'react';
import { AlertCircle, Radio, Navigation, Shield, Check, Phone, Timer, Users, Flame, Bike, Footprints } from 'lucide-react';

export const MobileSimulator: React.FC = () => {
  const [activeRole, setActiveRole] = useState<'participant' | 'admin' | 'police' | 'guest'>('participant');
  const [sosModalOpen, setSosModalOpen] = useState(false);
  const [sosResolved, setSosResolved] = useState(false);

  return (
    <div style={{
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      padding: '24px 20px',
      color: '#FFFFFF'
    }}>
      {/* Role Switcher Toolbar */}
      <div style={{
        display: 'flex',
        gap: '8px',
        marginBottom: '20px',
        backgroundColor: '#131B2E',
        padding: '6px',
        borderRadius: '16px',
        border: '1px solid rgba(255, 255, 255, 0.08)',
        flexWrap: 'wrap',
        justifyContent: 'center'
      }}>
        <button
          onClick={() => setActiveRole('participant')}
          style={{
            padding: '8px 16px',
            borderRadius: '12px',
            backgroundColor: activeRole === 'participant' ? '#00F2FE' : 'transparent',
            color: activeRole === 'participant' ? '#000000' : '#94A3B8',
            border: 'none',
            fontWeight: 700,
            fontSize: '12px',
            cursor: 'pointer'
          }}
        >
          🚴 1. Participant HUD
        </button>

        <button
          onClick={() => setActiveRole('admin')}
          style={{
            padding: '8px 16px',
            borderRadius: '12px',
            backgroundColor: activeRole === 'admin' ? '#00E676' : 'transparent',
            color: activeRole === 'admin' ? '#000000' : '#94A3B8',
            border: 'none',
            fontWeight: 700,
            fontSize: '12px',
            cursor: 'pointer'
          }}
        >
          🛡️ 2. Admin Studio
        </button>

        <button
          onClick={() => setActiveRole('police')}
          style={{
            padding: '8px 16px',
            borderRadius: '12px',
            backgroundColor: activeRole === 'police' ? '#2979FF' : 'transparent',
            color: activeRole === 'police' ? '#FFFFFF' : '#94A3B8',
            border: 'none',
            fontWeight: 700,
            fontSize: '12px',
            cursor: 'pointer'
          }}
        >
          👮 3. Police Command
        </button>

        <button
          onClick={() => setActiveRole('guest')}
          style={{
            padding: '8px 16px',
            borderRadius: '12px',
            backgroundColor: activeRole === 'guest' ? '#FF9100' : 'transparent',
            color: activeRole === 'guest' ? '#000000' : '#94A3B8',
            border: 'none',
            fontWeight: 700,
            fontSize: '12px',
            cursor: 'pointer'
          }}
        >
          🏙️ 4. Guest Home
        </button>
      </div>

      {/* Realistic Mobile Device Frame */}
      <div style={{
        width: '360px',
        height: '700px',
        backgroundColor: '#090D16',
        borderRadius: '40px',
        border: '10px solid #1E293B',
        boxShadow: '0 25px 60px rgba(0, 0, 0, 0.9), 0 0 30px rgba(0, 242, 254, 0.15)',
        position: 'relative',
        overflow: 'hidden',
        display: 'flex',
        flexDirection: 'column'
      }}>
        {/* Dynamic Island / Speaker Notch */}
        <div style={{
          position: 'absolute',
          top: '12px',
          left: '50%',
          transform: 'translateX(-50%)',
          width: '110px',
          height: '24px',
          backgroundColor: '#000000',
          borderRadius: '12px',
          zIndex: 100,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          padding: '0 10px',
          boxSizing: 'border-box'
        }}>
          <div style={{ width: '8px', height: '8px', borderRadius: '50%', backgroundColor: '#00F2FE' }} />
          <div style={{ width: '10px', height: '10px', borderRadius: '50%', backgroundColor: '#1E293B' }} />
        </div>

        {/* ===================== ROLE 1: PARTICIPANT HUD ===================== */}
        {activeRole === 'participant' && (
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', position: 'relative', paddingTop: '44px' }}>
            {/* Top Telemetry HUD */}
            <div style={{
              margin: '12px 16px',
              padding: '12px 16px',
              backgroundColor: 'rgba(19, 27, 46, 0.85)',
              backdropFilter: 'blur(16px)',
              borderRadius: '16px',
              border: '1px solid rgba(255, 255, 255, 0.08)',
              display: 'flex',
              justifyContent: 'space-around',
              alignItems: 'center'
            }}>
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '9px', color: '#64748B', fontWeight: 700 }}>SPEED</div>
                <div style={{ fontSize: '20px', fontFamily: 'JetBrains Mono', color: '#00F2FE', fontWeight: 800 }}>24.5</div>
                <div style={{ fontSize: '9px', color: '#64748B' }}>km/h</div>
              </div>
              <div style={{ width: '1px', height: '30px', backgroundColor: 'rgba(255, 255, 255, 0.08)' }} />
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '9px', color: '#64748B', fontWeight: 700 }}>DISTANCE</div>
                <div style={{ fontSize: '20px', fontFamily: 'JetBrains Mono', color: '#FFFFFF', fontWeight: 800 }}>12.4</div>
                <div style={{ fontSize: '9px', color: '#64748B' }}>km</div>
              </div>
              <div style={{ width: '1px', height: '30px', backgroundColor: 'rgba(255, 255, 255, 0.08)' }} />
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '9px', color: '#64748B', fontWeight: 700 }}>PACE</div>
                <div style={{ fontSize: '20px', fontFamily: 'JetBrains Mono', color: '#00E676', fontWeight: 800 }}>2:15</div>
                <div style={{ fontSize: '9px', color: '#64748B' }}>/km</div>
              </div>
            </div>

            {/* Broadcast Ticker */}
            <div style={{
              margin: '0 16px',
              padding: '10px 14px',
              backgroundColor: 'rgba(19, 27, 46, 0.75)',
              borderRadius: '12px',
              border: '1px solid rgba(0, 242, 254, 0.2)',
              display: 'flex',
              alignItems: 'center',
              gap: '10px'
            }}>
              <Radio size={16} color="#00F2FE" />
              <span style={{ fontSize: '11px', color: '#FFFFFF', fontWeight: 500 }}>
                Hydration Stop 2 open at Law College Chowk!
              </span>
            </div>

            {/* Map Canvas Background with simulated route */}
            <div style={{
              flex: 1,
              backgroundColor: '#0D1424',
              margin: '12px 16px',
              borderRadius: '20px',
              position: 'relative',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              border: '1px solid rgba(255, 255, 255, 0.08)'
            }}>
              <Navigation size={32} color="#00F2FE" />
              <div style={{
                position: 'absolute',
                top: '16px',
                left: '16px',
                backgroundColor: 'rgba(9, 13, 22, 0.8)',
                padding: '4px 10px',
                borderRadius: '8px',
                fontSize: '11px',
                color: '#94A3B8'
              }}>
                📍 Futala → Seminary Hills
              </div>
            </div>

            {/* Floating SOS Action Button */}
            <button
              onClick={() => alert('🚨 Emergency SOS Triggered! Streaming GPS location to Admin & Police.')}
              style={{
                position: 'absolute',
                bottom: '30px',
                right: '28px',
                width: '60px',
                height: '60px',
                borderRadius: '50%',
                backgroundColor: '#FF1744',
                color: '#FFFFFF',
                border: 'none',
                boxShadow: '0 0 20px rgba(255, 23, 68, 0.6)',
                cursor: 'pointer',
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                fontWeight: 900,
                fontSize: '10px'
              }}
            >
              <AlertCircle size={22} />
              SOS
            </button>
          </div>
        )}

        {/* ===================== ROLE 2: ADMIN STUDIO ===================== */}
        {activeRole === 'admin' && (
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', paddingTop: '44px', padding: '44px 16px 16px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '12px' }}>
              <h4 style={{ margin: 0, fontFamily: 'Outfit', fontSize: '16px' }}>Event Admin Studio</h4>
              <span style={{ backgroundColor: 'rgba(0, 230, 118, 0.2)', color: '#00E676', padding: '2px 8px', borderRadius: '8px', fontSize: '10px', fontWeight: 700 }}>
                250 Active
              </span>
            </div>

            <div style={{
              flex: 1,
              backgroundColor: '#0D1424',
              borderRadius: '16px',
              border: '1px solid rgba(255, 255, 255, 0.08)',
              display: 'flex',
              flexDirection: 'column',
              justifyContent: 'center',
              alignItems: 'center',
              padding: '16px',
              textAlign: 'center'
            }}>
              <Shield size={36} color="#00E676" style={{ marginBottom: '8px' }} />
              <div style={{ fontSize: '13px', fontWeight: 600 }}>Route Canvas & Telemetry</div>
              <div style={{ fontSize: '11px', color: '#64748B', marginTop: '4px' }}>Tap map points to modify checkpoints</div>
            </div>

            {/* Active SOS Triage Card */}
            {!sosResolved && (
              <div style={{
                marginTop: '12px',
                padding: '12px',
                backgroundColor: 'rgba(19, 27, 46, 0.95)',
                borderRadius: '14px',
                border: '1.5px solid #FF1744'
              }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
                  <span style={{ color: '#FF1744', fontWeight: 800, fontSize: '11px' }}>🚨 ACTIVE SOS ALERT</span>
                  <span style={{ color: '#64748B', fontSize: '10px' }}>2m ago</span>
                </div>
                <div style={{ fontSize: '12px', fontWeight: 700, color: '#FFFFFF' }}>Rahul Sharma (Bib #142)</div>
                <div style={{ fontSize: '11px', color: '#94A3B8', marginBottom: '10px' }}>📍 Near High Court Chowk</div>
                <div style={{ display: 'flex', gap: '8px' }}>
                  <button style={{
                    flex: 1,
                    padding: '6px',
                    backgroundColor: '#1E293B',
                    color: '#00F2FE',
                    border: '1px solid rgba(255, 255, 255, 0.08)',
                    borderRadius: '8px',
                    fontSize: '11px',
                    fontWeight: 600,
                    cursor: 'pointer',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    gap: '4px'
                  }}>
                    <Phone size={12} /> Call
                  </button>
                  <button
                    onClick={() => setSosResolved(true)}
                    style={{
                      flex: 1,
                      padding: '6px',
                      backgroundColor: '#00E676',
                      color: '#000000',
                      border: 'none',
                      borderRadius: '8px',
                      fontSize: '11px',
                      fontWeight: 700,
                      cursor: 'pointer',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      gap: '4px'
                    }}
                  >
                    <Check size={12} /> Resolve
                  </button>
                </div>
              </div>
            )}
          </div>
        )}

        {/* ===================== ROLE 3: POLICE DASHBOARD ===================== */}
        {activeRole === 'police' && (
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', paddingTop: '44px', padding: '44px 16px 16px' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '12px' }}>
              <Shield size={18} color="#2979FF" />
              <h4 style={{ margin: 0, fontFamily: 'Outfit', fontSize: '15px' }}>Nagpur Traffic Police</h4>
            </div>

            {/* Junction Arrival Prediction Card */}
            <div style={{
              padding: '12px',
              backgroundColor: '#131B2E',
              borderRadius: '14px',
              border: '1px solid rgba(255, 255, 255, 0.08)',
              marginBottom: '12px'
            }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '6px', color: '#FF9100', fontSize: '11px', fontWeight: 700, marginBottom: '4px' }}>
                <Timer size={14} /> JUNCTION ARRIVAL ETA
              </div>
              <div style={{ fontSize: '13px', fontWeight: 700, color: '#FFFFFF' }}>Variety Square Chowk</div>
              <div style={{ fontSize: '11px', color: '#94A3B8', marginTop: '2px' }}>Rally head arriving in 8 mins • Congestion: HIGH</div>
            </div>

            <div style={{
              flex: 1,
              backgroundColor: '#0D1424',
              borderRadius: '16px',
              border: '1px solid rgba(255, 255, 255, 0.08)',
              padding: '14px'
            }}>
              <div style={{ fontSize: '11px', color: '#64748B', fontWeight: 700, marginBottom: '8px' }}>CITY-WIDE EVENT MONITOR</div>
              <div style={{ fontSize: '12px', color: '#FFFFFF', padding: '8px 0', borderBottom: '1px solid rgba(255, 255, 255, 0.05)' }}>
                🚴 1. Cyclothon (Wardha Rd) - LIVE
              </div>
              <div style={{ fontSize: '12px', color: '#94A3B8', padding: '8px 0' }}>
                🚶 2. Heritage Walk (Civil Lines) - 7:00 AM
              </div>
            </div>

            <button
              onClick={() => alert('📢 Police Traffic Advisory Broadcasted to all citizen screens!')}
              style={{
                marginTop: '12px',
                padding: '10px',
                backgroundColor: '#2979FF',
                color: '#FFFFFF',
                border: 'none',
                borderRadius: '12px',
                fontSize: '12px',
                fontWeight: 700,
                cursor: 'pointer'
              }}
            >
              📢 Broadcast Detour Advisory
            </button>
          </div>
        )}

        {/* ===================== ROLE 4: GUEST HOME ===================== */}
        {activeRole === 'guest' && (
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', paddingTop: '44px', padding: '44px 16px 16px' }}>
            <div style={{ fontSize: '10px', color: '#00F2FE', fontWeight: 800, letterSpacing: '0.8px' }}>VIKASIT NAGPUR</div>
            <h3 style={{ margin: '2px 0 12px', fontFamily: 'Outfit', fontSize: '18px' }}>Live City Events</h3>

            {/* Event Modes */}
            <div style={{ display: 'flex', gap: '6px', marginBottom: '14px', overflowX: 'auto' }}>
              <span style={{ padding: '4px 10px', backgroundColor: 'rgba(0, 242, 254, 0.2)', color: '#00F2FE', borderRadius: '12px', fontSize: '11px', fontWeight: 600, border: '1px solid #00F2FE' }}>
                🚴 Cycling
              </span>
              <span style={{ padding: '4px 10px', backgroundColor: '#131B2E', color: '#94A3B8', borderRadius: '12px', fontSize: '11px' }}>
                🏃 Marathon
              </span>
              <span style={{ padding: '4px 10px', backgroundColor: '#131B2E', color: '#94A3B8', borderRadius: '12px', fontSize: '11px' }}>
                🚶 Walk
              </span>
            </div>

            {/* Event Card */}
            <div style={{
              padding: '14px',
              backgroundColor: 'rgba(19, 27, 46, 0.85)',
              borderRadius: '16px',
              border: '1px solid rgba(255, 255, 255, 0.08)'
            }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
                <span style={{ color: '#FF1744', fontSize: '10px', fontWeight: 800, display: 'flex', alignItems: 'center', gap: '4px' }}>
                  <span style={{ width: '6px', height: '6px', borderRadius: '50%', backgroundColor: '#FF1744' }} /> LIVE NOW
                </span>
                <span style={{ color: '#00F2FE', fontSize: '10px', fontWeight: 700 }}>250 Active</span>
              </div>
              <div style={{ fontSize: '13px', fontWeight: 700, color: '#FFFFFF' }}>Miles N Milers Cyclothon</div>
              <div style={{ fontSize: '11px', color: '#94A3B8', margin: '4px 0 12px' }}>Route: Futala → Seminary Hills</div>
              <button
                onClick={() => setActiveRole('participant')}
                style={{
                  width: '100%',
                  padding: '8px',
                  backgroundColor: '#00F2FE',
                  color: '#000000',
                  border: 'none',
                  borderRadius: '10px',
                  fontSize: '11px',
                  fontWeight: 700,
                  cursor: 'pointer'
                }}
              >
                Launch Participant View →
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
