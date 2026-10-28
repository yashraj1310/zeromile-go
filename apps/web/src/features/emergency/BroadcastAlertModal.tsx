/**
 * =========================================================================
 * ZEROMILE GO - BROADCAST CIVIC ALERT MODAL (BroadcastAlertModal.tsx)
 * Reconstructed from Video (00:15 - 00:28)
 * =========================================================================
 */

import React, { useState } from 'react';
import { dispatchBroadcastMessage } from '../../services/supabaseClient';

interface BroadcastAlertModalProps {
  isOpen: boolean;
  onClose: () => void;
  domainId: string;
  domainTitle: string;
  adminPhone: string;
  onBroadcastSent: (message: { severity: string; corridor: string; text: string }) => void;
}

export const BroadcastAlertModal: React.FC<BroadcastAlertModalProps> = ({
  isOpen,
  onClose,
  domainId,
  domainTitle,
  adminPhone,
  onBroadcastSent
}) => {
  const [severity, setSeverity] = useState('EMERGENCY');
  const [corridor, setCorridor] = useState('Wardha Road & Shankar Nagar Sq');
  const [message, setMessage] = useState(
    'Nagpur Grand Cyclothon is passing through Shankar Nagar Square. Commuters please switch to Alternate Route (Ambazari & Civil Lines bypass).'
  );
  const [isSubmitting, setIsSubmitting] = useState(false);

  if (!isOpen) return null;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);

    try {
      // Send to Supabase broadcasts table
      await dispatchBroadcastMessage({
        domain_id: domainId,
        sender_role: 'SUPERADMIN',
        target_type: 'GENERAL',
        message_text: `[${severity}] ${corridor}: ${message}`
      });

      onBroadcastSent({ severity, corridor, text: message });
      onClose();
    } catch (err) {
      console.warn('Broadcast send notice:', err);
      onBroadcastSent({ severity, corridor, text: message });
      onClose();
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div
      className="modal-overlay active"
      style={{
        position: 'fixed',
        inset: 0,
        zIndex: 9999,
        background: 'rgba(5, 8, 17, 0.85)',
        backdropFilter: 'blur(16px)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '20px'
      }}
    >
      <div
        className="sos-dialog"
        style={{
          width: '100%',
          maxWidth: '520px',
          background: 'rgba(16, 24, 43, 0.96)',
          border: '1px solid rgba(255, 23, 68, 0.4)',
          borderRadius: '20px',
          boxShadow: '0 20px 50px rgba(255, 23, 68, 0.25)',
          padding: '28px',
          position: 'relative'
        }}
      >
        <button
          onClick={onClose}
          style={{ position: 'absolute', top: '18px', right: '18px', background: 'none', border: 'none', color: '#94A3B8', fontSize: '20px', cursor: 'pointer' }}
        >
          ✕
        </button>

        <div style={{ textAlign: 'center', marginBottom: '20px' }}>
          <div style={{ fontSize: '32px', marginBottom: '6px' }}>🚨</div>
          <h2 style={{ fontSize: '20px', fontWeight: 900, color: '#fff' }}>Broadcast Civic Alert to Commuters</h2>
          <p style={{ fontSize: '12px', color: '#94A3B8', marginTop: '4px' }}>
            Instantly alert connected commuters and citizens about rolling closures, diversions or emergencies.
          </p>
        </div>

        <form onSubmit={handleSubmit}>
          {/* Severity */}
          <div style={{ marginBottom: '16px' }}>
            <label style={{ fontSize: '11px', fontWeight: 800, color: '#64748B', display: 'block', marginBottom: '6px' }}>ALERT SEVERITY</label>
            <select
              value={severity}
              onChange={(e) => setSeverity(e.target.value)}
              style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', background: 'rgba(0,0,0,0.3)', border: '1px solid rgba(255,255,255,0.15)', color: '#fff', fontSize: '13px', outline: 'none' }}
            >
              <option value="EMERGENCY">🔴 CRITICAL ALERT (Immediate Diversion)</option>
              <option value="WARNING">🟡 TRAFFIC NOTICE (Heavy Rally Congestion)</option>
              <option value="INFO">🟢 CIVIC ADVISORY (Route Cleared / Normal Flow)</option>
            </select>
          </div>

          {/* Corridor */}
          <div style={{ marginBottom: '16px' }}>
            <label style={{ fontSize: '11px', fontWeight: 800, color: '#64748B', display: 'block', marginBottom: '6px' }}>AFFECTED CORRIDOR / ROAD</label>
            <input
              type="text"
              value={corridor}
              onChange={(e) => setCorridor(e.target.value)}
              placeholder="e.g. Wardha Road / Shankar Nagar Square"
              style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', background: 'rgba(0,0,0,0.3)', border: '1px solid rgba(255,255,255,0.15)', color: '#fff', fontSize: '13px', outline: 'none' }}
            />
          </div>

          {/* Message */}
          <div style={{ marginBottom: '24px' }}>
            <label style={{ fontSize: '11px', fontWeight: 800, color: '#64748B', display: 'block', marginBottom: '6px' }}>BROADCAST MESSAGE</label>
            <textarea
              rows={3}
              value={message}
              onChange={(e) => setMessage(e.target.value)}
              style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', background: 'rgba(0,0,0,0.3)', border: '1px solid rgba(255,255,255,0.15)', color: '#fff', fontSize: '13px', outline: 'none', resize: 'vertical' }}
            />
          </div>

          {/* Buttons */}
          <div style={{ display: 'flex', gap: '12px' }}>
            <button
              type="button"
              onClick={onClose}
              style={{ flex: 1, padding: '12px', borderRadius: '10px', background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.12)', color: '#fff', fontWeight: 700, fontSize: '13px', cursor: 'pointer' }}
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={isSubmitting}
              style={{ flex: 2, padding: '12px', borderRadius: '10px', background: 'linear-gradient(135deg, #FF1744 0%, #D50000 100%)', border: 'none', color: '#fff', fontWeight: 800, fontSize: '13px', cursor: 'pointer', boxShadow: '0 4px 16px rgba(255, 23, 68, 0.4)' }}
            >
              {isSubmitting ? 'Sending...' : '🚨 Send Citywide Broadcast'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
