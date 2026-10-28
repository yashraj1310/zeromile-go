/**
 * =========================================================================
 * ZEROMILE GO - SUPERADMIN COMMAND CENTER (SuperAdminCommandCenter.tsx)
 * Reconstructed from Video (00:75 - 00:98)
 * =========================================================================
 */

import React, { useState } from 'react';
import { BroadcastMessage, SosEvent } from '../../types';
import { dispatchBroadcastMessage } from '../../services/supabaseClient';

interface SuperAdminCommandCenterProps {
  domainId: string;
  domainTitle: string;
  adminPhone: string;
  broadcasts: BroadcastMessage[];
  sosEvents: SosEvent[];
  onRefresh: () => void;
}

export const SuperAdminCommandCenter: React.FC<SuperAdminCommandCenterProps> = ({
  domainId,
  domainTitle,
  adminPhone,
  broadcasts,
  sosEvents,
  onRefresh
}) => {
  const [broadcastText, setBroadcastText] = useState('');
  const [targetAudience, setTargetAudience] = useState('ALL');
  const [isSending, setIsSending] = useState(false);

  const handleSend = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!broadcastText.trim()) return;

    setIsSending(true);
    await dispatchBroadcastMessage({
      domain_id: domainId,
      sender_role: 'SUPERADMIN',
      target_type: 'GENERAL',
      message_text: broadcastText
    });
    setBroadcastText('');
    setIsSending(false);
    onRefresh();
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '18px' }}>
      <div style={{ fontSize: '11px', color: '#64748B', fontWeight: 700 }}>
        LIVE OPERATIONS &amp; TELEMETRY STREAM
      </div>

      {/* 4 Metric Cards Grid */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '12px' }}>
        {/* Checked In */}
        <div style={{ background: 'rgba(255, 255, 255, 0.04)', border: '1px solid rgba(255, 255, 255, 0.08)', borderRadius: '12px', padding: '12px' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
            <span style={{ fontSize: '16px' }}>📊</span>
            <span style={{ fontSize: '18px', fontWeight: 900, color: '#00F2FE' }}>84%</span>
          </div>
          <div style={{ fontSize: '10px', fontWeight: 800, color: '#94A3B8', letterSpacing: '0.4px', marginBottom: '6px' }}>CHECKED IN</div>
          <div style={{ width: '100%', height: '4px', background: 'rgba(255, 255, 255, 0.1)', borderRadius: '2px', overflow: 'hidden' }}>
            <div style={{ width: '84%', height: '100%', background: '#00F2FE' }}></div>
          </div>
        </div>

        {/* Completed */}
        <div style={{ background: 'rgba(255, 255, 255, 0.04)', border: '1px solid rgba(255, 255, 255, 0.08)', borderRadius: '12px', padding: '12px' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
            <span style={{ fontSize: '16px' }}>🏁</span>
            <span style={{ fontSize: '18px', fontWeight: 900, color: '#00E676' }}>28%</span>
          </div>
          <div style={{ fontSize: '10px', fontWeight: 800, color: '#94A3B8', letterSpacing: '0.4px', marginBottom: '6px' }}>COMPLETED</div>
          <div style={{ width: '100%', height: '4px', background: 'rgba(255, 255, 255, 0.1)', borderRadius: '2px', overflow: 'hidden' }}>
            <div style={{ width: '28%', height: '100%', background: '#00E676' }}></div>
          </div>
        </div>

        {/* Live GPS Feeds */}
        <div style={{ background: 'rgba(255, 255, 255, 0.04)', border: '1px solid rgba(255, 255, 255, 0.08)', borderRadius: '12px', padding: '12px' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
            <span style={{ fontSize: '16px' }}>📡</span>
            <span style={{ fontSize: '18px', fontWeight: 900, color: '#FFD700' }}>328</span>
          </div>
          <div style={{ fontSize: '10px', fontWeight: 800, color: '#94A3B8', letterSpacing: '0.4px' }}>LIVE GPS FEEDS</div>
        </div>

        {/* Pending SOS */}
        <div style={{ background: 'rgba(255, 255, 255, 0.04)', border: '1px solid rgba(255, 255, 255, 0.08)', borderRadius: '12px', padding: '12px' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
            <span style={{ fontSize: '16px' }}>🚨</span>
            <span style={{ fontSize: '18px', fontWeight: 900, color: sosEvents.length > 0 ? '#FF1744' : '#00E676' }}>
              {sosEvents.length}
            </span>
          </div>
          <div style={{ fontSize: '10px', fontWeight: 800, color: '#94A3B8', letterSpacing: '0.4px' }}>PENDING SOS</div>
        </div>
      </div>

      {/* Broadcast Center */}
      <div style={{ background: 'rgba(255, 255, 255, 0.03)', border: '1px solid rgba(255, 255, 255, 0.08)', borderRadius: '14px', padding: '14px' }}>
        <div style={{ fontSize: '12px', fontWeight: 800, color: '#fff', marginBottom: '10px', display: 'flex', alignItems: 'center', gap: '6px' }}>
          <span>📢</span> Broadcast Center
        </div>
        <form onSubmit={handleSend} style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
          <input
            type="text"
            value={broadcastText}
            onChange={(e) => setBroadcastText(e.target.value)}
            placeholder="Type an announcement for participants..."
            style={{ width: '100%', padding: '10px 12px', borderRadius: '8px', background: 'rgba(0,0,0,0.3)', border: '1px solid rgba(255,255,255,0.12)', color: '#fff', fontSize: '12px', outline: 'none' }}
          />
          <div style={{ display: 'flex', gap: '8px' }}>
            <select
              value={targetAudience}
              onChange={(e) => setTargetAudience(e.target.value)}
              style={{ flex: 1, padding: '8px 10px', borderRadius: '8px', background: 'rgba(0,0,0,0.3)', border: '1px solid rgba(255,255,255,0.12)', color: '#94A3B8', fontSize: '11px', outline: 'none' }}
            >
              <option value="ALL">📣 All Participants</option>
              <option value="LEADERS">👥 Group Leaders Only</option>
              <option value="MARSHALS">👮 Police &amp; Marshals</option>
            </select>
            <button
              type="submit"
              disabled={isSending || !broadcastText.trim()}
              style={{ padding: '8px 16px', borderRadius: '8px', background: 'linear-gradient(135deg, #00F2FE 0%, #2979FF 100%)', border: 'none', color: '#fff', fontSize: '12px', fontWeight: 700, cursor: 'pointer' }}
            >
              {isSending ? '...' : 'Send →'}
            </button>
          </div>
        </form>

        <div style={{ marginTop: '12px' }}>
          <div style={{ fontSize: '10px', fontWeight: 800, color: '#64748B', letterSpacing: '0.4px', marginBottom: '6px' }}>RECENT BROADCASTS</div>
          {broadcasts.length === 0 ? (
            <div style={{ fontSize: '11px', color: '#64748B', fontStyle: 'italic' }}>No broadcasts yet</div>
          ) : (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '6px', maxHeight: '120px', overflowY: 'auto' }}>
              {broadcasts.map(b => (
                <div key={b.id} style={{ fontSize: '11px', color: '#CBD5E1', padding: '6px 8px', borderRadius: '6px', background: 'rgba(255,255,255,0.03)' }}>
                  {b.messageText}
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* SOS Alerts Queue */}
      <div style={{ background: 'rgba(255, 255, 255, 0.03)', border: '1px solid rgba(255, 255, 255, 0.08)', borderRadius: '14px', padding: '14px' }}>
        <div style={{ fontSize: '12px', fontWeight: 800, color: '#fff', marginBottom: '10px', display: 'flex', alignItems: 'center', gap: '6px' }}>
          <span>🚨</span> SOS Alerts
        </div>
        {sosEvents.length === 0 ? (
          <div style={{ fontSize: '12px', color: '#00E676', display: 'flex', alignItems: 'center', gap: '6px' }}>
            <span>✅</span> All clear — no active alerts
          </div>
        ) : (
          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
            {sosEvents.map(s => (
              <div key={s.id} style={{ padding: '8px 10px', borderRadius: '8px', background: 'rgba(255, 23, 68, 0.15)', border: '1px solid rgba(255, 23, 68, 0.3)', fontSize: '12px', color: '#fff' }}>
                🚨 <b>{s.emergencyType}</b>: {s.leaderNotes || 'Emergency SOS signal'}
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};
