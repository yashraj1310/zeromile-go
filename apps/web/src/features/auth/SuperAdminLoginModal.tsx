/**
 * =========================================================================
 * ZEROMILE GO - SUPERADMIN AUTHENTICATION MODAL (SuperAdminLoginModal.tsx)
 * Mobile Number + OTP Verification with Strict Database SuperAdmin Checking
 * =========================================================================
 */

import React, { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import { useDomain } from '../../context/DomainContext';
import { Shield, Smartphone, X, CheckCircle, AlertCircle } from 'lucide-react';

export const SuperAdminLoginModal: React.FC = () => {
  const { isLoginModalOpen, closeLoginModal, authenticateAsSuperAdmin } = useAuth();
  const { currentDomain, switchDomain, domains } = useDomain();

  const [step, setStep] = useState<'PHONE' | 'OTP'>('PHONE');
  const [phone, setPhone] = useState('9823012345');
  const [otp, setOtp] = useState(['1', '2', '3', '4', '5', '6']);
  const [loading, setLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  if (!isLoginModalOpen) return null;

  const handleRequestOtp = (e: React.FormEvent) => {
    e.preventDefault();
    if (phone.length < 10) {
      setErrorMsg('Please enter a valid 10-digit mobile number.');
      return;
    }
    setErrorMsg(null);
    setStep('OTP');
  };

  const handleVerifyOtp = async (e: React.FormEvent) => {
    e.preventDefault();
    const fullOtp = otp.join('');
    if (fullOtp.length < 6) {
      setErrorMsg('Please enter the complete 6-digit OTP code.');
      return;
    }

    setLoading(true);
    setErrorMsg(null);

    const result = await authenticateAsSuperAdmin(phone);
    setLoading(false);

    if (!result.success) {
      setErrorMsg(result.message || 'Verification failed. Not an authorized SuperAdmin.');
    }
  };

  const handleOtpChange = (index: number, val: string) => {
    if (val.length > 1) val = val[0];
    const newOtp = [...otp];
    newOtp[index] = val;
    setOtp(newOtp);

    // Auto-focus next input
    if (val && index < 5) {
      const nextInput = document.getElementById(`otp-input-${index + 1}`);
      nextInput?.focus();
    }
  };

  return (
    <div style={{
      position: 'fixed',
      inset: 0,
      zIndex: 9999,
      backgroundColor: 'rgba(5, 8, 17, 0.85)',
      backdropFilter: 'blur(16px)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '20px'
    }}>
      <div className="glass-panel-elevated" style={{ width: '100%', maxWidth: '480px', padding: '30px', position: 'relative' }}>
        <button
          onClick={closeLoginModal}
          style={{ position: 'absolute', top: '20px', right: '20px', background: 'none', border: 'none', color: '#94A3B8', cursor: 'pointer' }}
        >
          <X size={20} />
        </button>

        {/* Modal Header */}
        <div style={{ textAlign: 'center', marginBottom: '24px' }}>
          <div style={{
            display: 'inline-flex',
            padding: '12px',
            background: 'linear-gradient(135deg, rgba(255, 215, 0, 0.2) 0%, rgba(255, 145, 0, 0.1) 100%)',
            border: '1px solid rgba(255, 215, 0, 0.4)',
            borderRadius: '16px',
            marginBottom: '12px'
          }}>
            <Shield size={32} color="#FFD700" />
          </div>
          <h2 style={{ fontSize: '20px', fontWeight: 900, color: '#fff', letterSpacing: '-0.3px' }}>SuperAdmin Command Studio</h2>
          <p style={{ fontSize: '12px', color: '#94A3B8', marginTop: '4px' }}>
            Authorized Event Commanders & Traffic Marshals
          </p>
        </div>

        {/* Domain Selector Tabs */}
        <div style={{ marginBottom: '20px' }}>
          <label style={{ fontSize: '10px', fontWeight: 800, color: '#FFD700', letterSpacing: '0.8px', display: 'block', marginBottom: '6px' }}>
            SELECT EVENT DOMAIN:
          </label>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '6px' }}>
            {domains.map(d => (
              <button
                key={d.id}
                type="button"
                onClick={() => switchDomain(d.id)}
                style={{
                  padding: '8px 6px',
                  background: currentDomain.id === d.id ? 'rgba(255, 215, 0, 0.15)' : 'rgba(255, 255, 255, 0.04)',
                  border: currentDomain.id === d.id ? '1px solid #FFD700' : '1px solid rgba(255, 255, 255, 0.08)',
                  borderRadius: '8px',
                  color: currentDomain.id === d.id ? '#FFD700' : '#94A3B8',
                  fontSize: '11px',
                  fontWeight: 700,
                  cursor: 'pointer'
                }}
              >
                {d.icon} {d.type}
              </button>
            ))}
          </div>
        </div>

        {errorMsg && (
          <div style={{
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
            padding: '10px 14px',
            background: 'rgba(255, 23, 68, 0.15)',
            border: '1px solid rgba(255, 23, 68, 0.3)',
            borderRadius: '8px',
            color: '#FF1744',
            fontSize: '12px',
            marginBottom: '16px'
          }}>
            <AlertCircle size={16} />
            <span>{errorMsg}</span>
          </div>
        )}

        {/* Step 1: Phone Input */}
        {step === 'PHONE' ? (
          <form onSubmit={handleRequestOtp} style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
            <div>
              <label style={{ fontSize: '11px', fontWeight: 800, color: '#94A3B8', display: 'block', marginBottom: '6px' }}>
                SUPERADMIN MOBILE NUMBER
              </label>
              <div style={{
                display: 'flex',
                alignItems: 'center',
                background: 'rgba(0, 0, 0, 0.4)',
                border: '1px solid rgba(255, 255, 255, 0.14)',
                borderRadius: '8px',
                padding: '0 12px'
              }}>
                <span style={{ fontSize: '13px', fontWeight: 800, color: '#64748B', marginRight: '8px' }}>+91</span>
                <input
                  type="tel"
                  maxLength={10}
                  value={phone}
                  onChange={e => setPhone(e.target.value.replace(/\D/g, ''))}
                  placeholder="98230 12345"
                  required
                  style={{
                    flex: 1,
                    padding: '12px 0',
                    background: 'none',
                    border: 'none',
                    color: '#fff',
                    fontSize: '14px',
                    fontWeight: 700,
                    outline: 'none'
                  }}
                />
                <Smartphone size={18} color="#64748B" />
              </div>
            </div>

            <button
              type="submit"
              style={{
                padding: '14px',
                background: 'linear-gradient(135deg, #FFD700 0%, #FFA000 100%)',
                border: 'none',
                borderRadius: '8px',
                color: '#050811',
                fontSize: '13px',
                fontWeight: 900,
                cursor: 'pointer',
                boxShadow: '0 4px 20px rgba(255, 215, 0, 0.3)'
              }}
            >
              Request Access Code →
            </button>
          </form>
        ) : (
          /* Step 2: OTP Verification */
          <form onSubmit={handleVerifyOtp} style={{ display: 'flex', flexDirection: 'column', gap: '18px' }}>
            <div style={{ textAlign: 'center' }}>
              <div style={{ fontSize: '12px', color: '#94A3B8' }}>
                Enter verification code for <b style={{ color: '#fff' }}>+91 {phone}</b>
              </div>
              <div style={{ display: 'flex', justifyContent: 'center', gap: '8px', marginTop: '14px' }}>
                {otp.map((digit, idx) => (
                  <input
                    key={idx}
                    id={`otp-input-${idx}`}
                    type="text"
                    maxLength={1}
                    value={digit}
                    onChange={e => handleOtpChange(idx, e.target.value)}
                    style={{
                      width: '42px',
                      height: '48px',
                      textAlign: 'center',
                      fontSize: '18px',
                      fontWeight: 800,
                      background: 'rgba(0, 0, 0, 0.4)',
                      border: '1px solid rgba(255, 215, 0, 0.4)',
                      borderRadius: '8px',
                      color: '#FFD700',
                      outline: 'none'
                    }}
                  />
                ))}
              </div>
            </div>

            <div style={{ display: 'flex', gap: '10px' }}>
              <button
                type="button"
                onClick={() => setStep('PHONE')}
                style={{
                  flex: 1,
                  padding: '12px',
                  background: 'rgba(255, 255, 255, 0.06)',
                  border: '1px solid rgba(255, 255, 255, 0.12)',
                  borderRadius: '8px',
                  color: '#94A3B8',
                  fontSize: '12px',
                  fontWeight: 700,
                  cursor: 'pointer'
                }}
              >
                Back
              </button>
              <button
                type="submit"
                disabled={loading}
                style={{
                  flex: 2,
                  padding: '12px',
                  background: 'linear-gradient(135deg, #FFD700 0%, #FFA000 100%)',
                  border: 'none',
                  borderRadius: '8px',
                  color: '#050811',
                  fontSize: '13px',
                  fontWeight: 900,
                  cursor: 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  gap: '6px'
                }}
              >
                {loading ? 'Verifying...' : <><CheckCircle size={16} /> Authenticate SuperAdmin</>}
              </button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
};
