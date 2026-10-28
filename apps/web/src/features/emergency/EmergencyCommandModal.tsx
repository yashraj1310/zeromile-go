/**
 * =========================================================================
 * ZEROMILE GO - EMERGENCY SOS & BROADCAST CONSOLE (EmergencyCommandModal.tsx)
 * Real-Time Triage for Medical/Police Incidents & High-Priority Alerts
 * =========================================================================
 */

import React, { useState } from 'react';
import { SosEvent, BroadcastMessage } from '../../types';
import { Radio, AlertTriangle, Send, CheckCircle, ShieldAlert, X } from 'lucide-react';
import { dispatchBroadcastMessage, resolveSosIncident } from '../../services/supabaseClient';
import { useToast } from '../../context/ToastContext';

interface EmergencyCommandModalProps {
  isOpen: boolean;
  onClose: () => void;
  domainId: string;
  adminPhone?: string;
  sosEvents: SosEvent[];
  broadcasts: BroadcastMessage[];
  onRefresh: () => void;
}

export const EmergencyCommandModal: React.FC<EmergencyCommandModalProps> = ({
  isOpen,
  onClose,
  domainId,
  sosEvents,
  broadcasts,
  onRefresh
}) => {
  const { showToast } = useToast();
  const [activeTab, setActiveTab] = useState<'SOS' | 'BROADCAST'>('SOS');
  const [broadcastText, setBroadcastText] = useState('');
  const [isSending, setIsSending] = useState(false);
  const [resolutionNotes, setResolutionNotes] = useState('');

  if (!isOpen) return null;

  const handleSendBroadcast = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!broadcastText.trim()) return;

    setIsSending(true);
    const success = await dispatchBroadcastMessage({
      domainId,
      senderRole: 'SUPERADMIN',
      targetType: 'GENERAL',
      messageText: broadcastText.trim()
    });

    setIsSending(false);
    if (success) {
      showToast('📢 Official Event Broadcast dispatched to all riders & marshals!', 'success');
      setBroadcastText('');
      onRefresh();
    } else {
      showToast('❌ Failed to dispatch broadcast.', 'error');
    }
  };

  const handleResolveSos = async (id: string) => {
    const success = await resolveSosIncident(id, resolutionNotes || 'Resolved by SuperAdmin');
    if (success) {
      showToast('✅ SOS Incident resolved and closed.', 'success');
      setResolutionNotes('');
      onRefresh();
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
      <div className="glass-panel-elevated" style={{ width: '100%', maxWidth: '680px', padding: '24px' }}>
        {/* Header */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '18px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            <div style={{ padding: '8px', background: 'rgba(255, 23, 68, 0.2)', borderRadius: '8px' }}>
              <ShieldAlert size={22} color="#FF1744" />
            </div>
            <div>
              <h3 style={{ fontSize: '18px', fontWeight: 800, color: '#fff' }}>Emergency SOS & Broadcast Control</h3>
              <p style={{ fontSize: '12px', color: '#94A3B8' }}>Live Incident Triage & High-Priority Dispatch</p>
            </div>
          </div>
          <button onClick={onClose} style={{ background: 'none', border: 'none', color: '#94A3B8', cursor: 'pointer' }}>
            <X size={20} />
          </button>
        </div>

        {/* Tab Switcher */}
        <div style={{ display: 'flex', gap: '8px', marginBottom: '20px', borderBottom: '1px solid rgba(255,255,255,0.08)', paddingBottom: '10px' }}>
          <button
            onClick={() => setActiveTab('SOS')}
            style={{
              padding: '8px 16px',
              borderRadius: '6px',
              background: activeTab === 'SOS' ? 'rgba(255, 23, 68, 0.2)' : 'transparent',
              border: activeTab === 'SOS' ? '1px solid #FF1744' : 'none',
              color: activeTab === 'SOS' ? '#FF1744' : '#94A3B8',
              fontWeight: 800,
              fontSize: '12px',
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              gap: '6px'
            }}
          >
            <AlertTriangle size={14} /> Active SOS Alerts ({sosEvents.filter(s => s.status !== 'RESOLVED').length})
          </button>
          <button
            onClick={() => setActiveTab('BROADCAST')}
            style={{
              padding: '8px 16px',
              borderRadius: '6px',
              background: activeTab === 'BROADCAST' ? 'rgba(0, 242, 254, 0.2)' : 'transparent',
              border: activeTab === 'BROADCAST' ? '1px solid #00F2FE' : 'none',
              color: activeTab === 'BROADCAST' ? '#00F2FE' : '#94A3B8',
              fontWeight: 800,
              fontSize: '12px',
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              gap: '6px'
            }}
          >
            <Radio size={14} /> Send Broadcast ({broadcasts.length})
          </button>
        </div>

        {/* SOS Incidents Tab */}
        {activeTab === 'SOS' && (
          <div style={{ display: 'flex', flexDirection: 'column', gap: '10px', maxHeight: '300px', overflowY: 'auto' }}>
            {sosEvents.length === 0 ? (
              <div style={{ textAlign: 'center', padding: '30px', color: '#64748B', fontSize: '13px' }}>
                <CheckCircle size={32} color="#00E676" style={{ margin: '0 auto 8px auto', display: 'block' }} />
                No active SOS emergencies. Corridor safe and clear.
              </div>
            ) : (
              sosEvents.map(ev => (
                <div
                  key={ev.id}
                  style={{
                    padding: '12px 16px',
                    borderRadius: '8px',
                    background: ev.status === 'RESOLVED' ? 'rgba(255, 255, 255, 0.03)' : 'rgba(255, 23, 68, 0.12)',
                    border: `1px solid ${ev.status === 'RESOLVED' ? 'rgba(255,255,255,0.06)' : 'rgba(255,23,68,0.4)'}`,
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between'
                  }}
                >
                  <div>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                      <span style={{
                        padding: '2px 8px',
                        borderRadius: '4px',
                        background: '#FF1744',
                        color: '#fff',
                        fontSize: '10px',
                        fontWeight: 900
                      }}>
                        {ev.emergencyType}
                      </span>
                      <span style={{ fontSize: '13px', fontWeight: 700, color: '#fff' }}>
                        {ev.leaderNotes || 'SOS Alert Triggered'}
                      </span>
                    </div>
                    <div style={{ fontSize: '11px', color: '#94A3B8', marginTop: '4px' }}>
                      Status: {ev.status} • GPS: {ev.latitude?.toFixed(4)}, {ev.longitude?.toFixed(4)}
                    </div>
                  </div>

                  {ev.status !== 'RESOLVED' && (
                    <button
                      onClick={() => handleResolveSos(ev.id)}
                      style={{
                        padding: '6px 12px',
                        background: '#00E676',
                        border: 'none',
                        borderRadius: '6px',
                        color: '#050811',
                        fontSize: '11px',
                        fontWeight: 800,
                        cursor: 'pointer'
                      }}
                    >
                      Resolve Incident
                    </button>
                  )}
                </div>
              ))
            )}
          </div>
        )}

        {/* Broadcast Tab */}
        {activeTab === 'BROADCAST' && (
          <form onSubmit={handleSendBroadcast} style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
            <div>
              <label style={{ fontSize: '11px', fontWeight: 800, color: '#94A3B8', display: 'block', marginBottom: '6px' }}>
                BROADCAST ANNOUNCEMENT (Sent to all participants & marshals)
              </label>
              <textarea
                rows={3}
                value={broadcastText}
                onChange={e => setBroadcastText(e.target.value)}
                placeholder="e.g. Traffic Alert: Shankar Nagar Flyover closed for Cyclothon. Diversion active via Ambazari Rd."
                required
                style={{
                  width: '100%',
                  padding: '12px',
                  background: 'rgba(0, 0, 0, 0.4)',
                  border: '1px solid rgba(0, 242, 254, 0.3)',
                  borderRadius: '8px',
                  color: '#fff',
                  fontSize: '13px',
                  resize: 'none',
                  outline: 'none'
                }}
              />
            </div>

            <button
              type="submit"
              disabled={isSending}
              style={{
                padding: '12px',
                background: 'linear-gradient(135deg, #00F2FE 0%, #0099FE 100%)',
                border: 'none',
                borderRadius: '8px',
                color: '#050811',
                fontSize: '13px',
                fontWeight: 900,
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                gap: '8px'
              }}
            >
              <Send size={16} /> {isSending ? 'Transmitting...' : 'Dispatch Live Broadcast'}
            </button>
          </form>
        )}
      </div>
    </div>
  );
};
