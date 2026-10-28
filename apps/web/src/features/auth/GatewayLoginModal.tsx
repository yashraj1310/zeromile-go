/**
 * =========================================================================
 * ZEROMILE GO - GATEWAY & SUPERADMIN AUTHENTICATION MODAL (GatewayLoginModal.tsx)
 * Reconstructed from Video & Authoritative index.html
 * Supports User-Specified SuperAdmin Phone & 1-Click Guest Exploration Mode
 * =========================================================================
 */

import React, { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import { useDomain } from '../../context/DomainContext';
import { requestSupabaseOtp } from '../../services/supabaseAuth';

interface GatewayLoginModalProps {
  onExploreAsGuest?: () => void;
}

export const GatewayLoginModal: React.FC<GatewayLoginModalProps> = ({ onExploreAsGuest }) => {
  const { isLoginModalOpen, closeLoginModal, authenticateAsSuperAdmin, enableGuestMode } = useAuth();
  const { currentDomain, switchDomain, domains } = useDomain();

  const [step, setStep] = useState<'PHONE' | 'OTP'>('PHONE');
  const [phone, setPhone] = useState('');
  const [otp, setOtp] = useState(['1', '2', '3', '4', '5', '6']);
  const [loading, setLoading] = useState(false);
  const [statusMsg, setStatusMsg] = useState<{ text: string; isError: boolean } | null>(null);

  if (!isLoginModalOpen) return null;

  const handleGuestExplore = () => {
    enableGuestMode();
    if (onExploreAsGuest) {
      onExploreAsGuest();
    } else {
      closeLoginModal();
    }
  };

  const handleSendOtp = async () => {
    const clean = phone.replace(/^\+91/, '').replace(/\s+/g, '').trim();
    if (clean.length < 10) {
      setStatusMsg({ text: 'Please enter a valid 10-digit mobile number.', isError: true });
      return;
    }

    setLoading(true);
    setStatusMsg({ text: '📲 Sending verification OTP...', isError: false });

    // Request from live Supabase Auth / dev fallback
    const res = await requestSupabaseOtp(clean);
    setLoading(false);

    setStatusMsg({
      text: res.message || `📲 Verification code sent to +91 ${clean}. (Dev OTP: 123456)`,
      isError: false
    });
    setOtp(['1', '2', '3', '4', '5', '6']);
    setStep('OTP');
  };

  const handleVerifyOtp = async () => {
    const enteredOtp = otp.join('');
    if (enteredOtp.length < 6) {
      setStatusMsg({ text: 'Please enter the complete 6-digit OTP.', isError: true });
      return;
    }

    setLoading(true);
    setStatusMsg({ text: '🔐 Authorizing SuperAdmin session...', isError: false });

    // Verify SuperAdmin status against database records
    const res = await authenticateAsSuperAdmin(phone);
    setLoading(false);

    if (!res.success) {
      setStatusMsg({ text: `❌ ${res.message || 'Access Denied: Not authorized as SuperAdmin.'}`, isError: true });
    } else {
      closeLoginModal();
    }
  };

  const handleOtpInput = (index: number, val: string) => {
    if (val.length > 1) val = val[val.length - 1];
    const updated = [...otp];
    updated[index] = val;
    setOtp(updated);

    if (val && index < 5) {
      const next = document.getElementById(`gw-otp-${index + 1}`);
      next?.focus();
    }
  };

  const handleOtpKeyDown = (index: number, e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Backspace' && !otp[index] && index > 0) {
      const prev = document.getElementById(`gw-otp-${index - 1}`);
      prev?.focus();
    }
  };

  return (
    <div
      className="modal-overlay active"
      style={{
        position: 'fixed',
        inset: 0,
        zIndex: 9999,
        background: 'rgba(5, 8, 17, 0.88)',
        backdropFilter: 'blur(16px)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '20px'
      }}
    >
      <div
        className="gateway-dialog"
        style={{
          width: '100%',
          maxWidth: '960px',
          background: 'rgba(16, 24, 43, 0.95)',
          border: '1px solid rgba(255, 255, 255, 0.16)',
          borderRadius: '24px',
          boxShadow: '0 24px 60px rgba(0, 0, 0, 0.7)',
          padding: '36px',
          position: 'relative'
        }}
      >
        <button
          onClick={closeLoginModal}
          style={{
            position: 'absolute',
            top: '20px',
            right: '20px',
            background: 'none',
            border: 'none',
            color: '#94A3B8',
            fontSize: '22px',
            cursor: 'pointer'
          }}
        >
          ✕
        </button>

        <div style={{ textAlign: 'center', marginBottom: '28px' }}>
          <div style={{ fontSize: '32px', marginBottom: '8px' }}>🧭</div>
          <h2 style={{ fontSize: '26px', fontWeight: 900, letterSpacing: '-0.5px' }}>ZeroMile Go Civic Gateway</h2>
          <p style={{ fontSize: '14px', color: '#94A3B8', marginTop: '6px' }}>
            Choose your access mode. Explore everything as a <b>Guest</b> without any phone number, or log in with your <b>SuperAdmin phone number</b>.
          </p>
        </div>

        {/* Guest View Banner Strip */}
        <div
          onClick={handleGuestExplore}
          style={{
            marginBottom: '24px',
            background: 'linear-gradient(135deg, rgba(0, 242, 254, 0.12) 0%, rgba(79, 172, 254, 0.12) 100%)',
            border: '1px solid rgba(0, 242, 254, 0.35)',
            borderRadius: '16px',
            padding: '16px 20px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            cursor: 'pointer',
            transition: 'all 0.2s',
            boxShadow: '0 8px 24px rgba(0, 242, 254, 0.15)'
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', gap: '14px' }}>
            <div style={{ fontSize: '26px' }}>👁️</div>
            <div>
              <div style={{ fontSize: '15px', fontWeight: 800, color: '#00F2FE' }}>
                Guest View — Explore Everything Without Phone Number
              </div>
              <div style={{ fontSize: '12px', color: '#94A3B8', marginTop: '2px' }}>
                Full access to 3D Corridor Studio, Waypoint Dragging, Police Roadblocks, Checkpoints &amp; Command Center. No login required!
              </div>
            </div>
          </div>
          <button
            onClick={handleGuestExplore}
            style={{
              padding: '10px 18px',
              borderRadius: '10px',
              background: '#00F2FE',
              color: '#050811',
              border: 'none',
              fontWeight: 800,
              fontSize: '13px',
              cursor: 'pointer',
              whiteSpace: 'nowrap'
            }}
          >
            Launch Guest View ➔
          </button>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(380px, 1fr))', gap: '24px' }}>
          {/* 1. Everyday Commuter Card */}
          <div
            onClick={closeLoginModal}
            style={{
              background: 'rgba(255, 255, 255, 0.03)',
              border: '1px solid rgba(255, 255, 255, 0.1)',
              borderRadius: '18px',
              padding: '24px',
              cursor: 'pointer',
              display: 'flex',
              flexDirection: 'column',
              justifyContent: 'space-between',
              transition: 'border-color 0.2s'
            }}
          >
            <div>
              <div style={{ fontSize: '28px', marginBottom: '12px' }}>🚗</div>
              <h3 style={{ fontSize: '20px', fontWeight: 800, marginBottom: '6px' }}>Everyday Commuter</h3>
              <span style={{ display: 'inline-block', padding: '4px 10px', borderRadius: '12px', background: 'rgba(0, 230, 118, 0.15)', color: '#00E676', fontSize: '11px', fontWeight: 800, marginBottom: '14px' }}>
                COMMUTER TRANSIT • NO PHONE REQUIRED
              </span>
              <p style={{ fontSize: '13px', color: '#94A3B8', lineHeight: 1.5, marginBottom: '16px' }}>
                Discover fastest routes, auto-detect active rally delays, switch to recommended bypass corridors, and navigate with turn-by-turn guidance.
              </p>
              <ul style={{ listStyle: 'none', padding: 0, margin: 0, fontSize: '12px', color: '#CBD5E1', display: 'flex', flexDirection: 'column', gap: '6px' }}>
                <li>✓ Google Maps Style Navigation UI</li>
                <li>✓ Auto-Clash Detection with Cyclothon / Marathon / Rally</li>
                <li>✓ Multi-Color Traffic Levels (Green / Yellow / Orange / Red)</li>
              </ul>
            </div>
            <button
              onClick={closeLoginModal}
              style={{
                width: '100%',
                marginTop: '24px',
                padding: '12px',
                borderRadius: '12px',
                background: 'linear-gradient(135deg, #00C853 0%, #009624 100%)',
                color: '#fff',
                border: 'none',
                fontWeight: 700,
                fontSize: '14px',
                cursor: 'pointer'
              }}
            >
              Open Commuter Transit View ➔
            </button>
          </div>

          {/* 2. SuperAdmin Command Portal Card */}
          <div
            style={{
              background: 'rgba(255, 215, 0, 0.03)',
              border: '1px solid rgba(255, 215, 0, 0.3)',
              borderRadius: '18px',
              padding: '24px',
              display: 'flex',
              flexDirection: 'column'
            }}
          >
            <div style={{ fontSize: '28px', marginBottom: '12px' }}>🛡️</div>
            <h3 style={{ fontSize: '20px', fontWeight: 800, marginBottom: '6px' }}>SuperAdmin Command Studio</h3>
            <span style={{ display: 'inline-block', padding: '4px 10px', borderRadius: '12px', background: 'rgba(255, 215, 0, 0.15)', color: '#FFD700', fontSize: '11px', fontWeight: 800, marginBottom: '14px', width: 'fit-content' }}>
              SUPERADMIN PHONE VERIFICATION
            </span>
            <p style={{ fontSize: '13px', color: '#94A3B8', lineHeight: 1.5, marginBottom: '16px' }}>
              Authorized civic organizers &amp; police traffic marshals. Enter your mobile number to sign in as SuperAdmin.
            </p>

            {/* Domain Tabs */}
            <div style={{ marginBottom: '16px' }}>
              <div style={{ fontSize: '11px', fontWeight: 800, color: '#64748B', marginBottom: '8px' }}>SELECT EVENT DOMAIN:</div>
              <div style={{ display: 'flex', gap: '8px' }}>
                {domains.map(d => (
                  <button
                    key={d.id}
                    onClick={() => switchDomain(d.id)}
                    style={{
                      flex: 1,
                      padding: '8px 4px',
                      borderRadius: '8px',
                      background: currentDomain.id === d.id ? 'rgba(0, 242, 254, 0.2)' : 'rgba(255,255,255,0.05)',
                      border: currentDomain.id === d.id ? '1px solid #00F2FE' : '1px solid rgba(255,255,255,0.1)',
                      color: currentDomain.id === d.id ? '#00F2FE' : '#94A3B8',
                      fontSize: '12px',
                      fontWeight: 700,
                      cursor: 'pointer'
                    }}
                  >
                    {d.icon} {d.type}
                  </button>
                ))}
              </div>
              <div style={{ fontSize: '11px', color: '#94A3B8', marginTop: '6px' }}>
                Managing <b>{currentDomain.title}</b> corridor, waypoints &amp; civic alerts.
              </div>
            </div>

            {/* Phone & OTP Form */}
            {step === 'PHONE' ? (
              <div>
                <label style={{ fontSize: '11px', fontWeight: 800, color: '#64748B', display: 'block', marginBottom: '6px' }}>
                  YOUR MOBILE NUMBER (SUPERADMIN)
                </label>
                <div style={{ display: 'flex', alignItems: 'center', background: 'rgba(0,0,0,0.3)', border: '1px solid rgba(255,255,255,0.15)', borderRadius: '10px', overflow: 'hidden', marginBottom: '14px' }}>
                  <span style={{ padding: '10px 14px', background: 'rgba(255,255,255,0.06)', color: '#FFD700', fontWeight: 700, fontSize: '14px' }}>+91</span>
                  <input
                    type="tel"
                    value={phone}
                    maxLength={10}
                    onChange={(e) => setPhone(e.target.value)}
                    placeholder="Enter 10-digit mobile number"
                    style={{ flex: 1, background: 'transparent', border: 'none', padding: '10px 14px', color: '#fff', fontSize: '15px', fontWeight: 600, outline: 'none' }}
                  />
                </div>
                <button
                  onClick={handleSendOtp}
                  disabled={loading}
                  style={{
                    width: '100%',
                    padding: '12px',
                    borderRadius: '10px',
                    background: 'linear-gradient(135deg, #FFB800 0%, #FF8C00 100%)',
                    color: '#050811',
                    border: 'none',
                    fontWeight: 800,
                    fontSize: '14px',
                    cursor: 'pointer'
                  }}
                >
                  {loading ? 'Sending...' : '📲 Send Verification OTP'}
                </button>
              </div>
            ) : (
              <div>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '10px', fontSize: '12px', color: '#CBD5E1' }}>
                  <span>Enter 6-digit OTP sent to <b>+91 {phone}</b>:</span>
                  <button onClick={() => setStep('PHONE')} style={{ background: 'none', border: 'none', color: '#00F2FE', cursor: 'pointer', fontSize: '11px', fontWeight: 700 }}>Change</button>
                </div>
                <div style={{ display: 'flex', gap: '8px', justifyContent: 'center', marginBottom: '16px' }}>
                  {otp.map((digit, idx) => (
                    <input
                      key={idx}
                      id={`gw-otp-${idx}`}
                      type="text"
                      maxLength={1}
                      value={digit}
                      onChange={(e) => handleOtpInput(idx, e.target.value)}
                      onKeyDown={(e) => handleOtpKeyDown(idx, e)}
                      style={{
                        width: '42px',
                        height: '48px',
                        borderRadius: '8px',
                        background: 'rgba(0,0,0,0.4)',
                        border: '1px solid rgba(255, 215, 0, 0.4)',
                        color: '#FFD700',
                        fontSize: '20px',
                        fontWeight: 800,
                        textAlign: 'center',
                        outline: 'none'
                      }}
                    />
                  ))}
                </div>
                <button
                  onClick={handleVerifyOtp}
                  disabled={loading}
                  style={{
                    width: '100%',
                    padding: '12px',
                    borderRadius: '10px',
                    background: 'linear-gradient(135deg, #00E676 0%, #00C853 100%)',
                    color: '#050811',
                    border: 'none',
                    fontWeight: 800,
                    fontSize: '14px',
                    cursor: 'pointer'
                  }}
                >
                  {loading ? 'Verifying...' : '🔓 Verify OTP & Enter Studio'}
                </button>
              </div>
            )}

            {statusMsg && (
              <div style={{ marginTop: '14px', fontSize: '12px', color: statusMsg.isError ? '#FF1744' : '#00F2FE', lineHeight: 1.4 }}>
                {statusMsg.text}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};
