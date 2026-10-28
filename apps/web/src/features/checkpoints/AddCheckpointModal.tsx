/**
 * =========================================================================
 * ZEROMILE GO - ADD CHECKPOINT MODAL (AddCheckpointModal.tsx)
 * Reconstructed from Video (00:59 - 00:75)
 * =========================================================================
 */

import React, { useState } from 'react';

interface AddCheckpointModalProps {
  isOpen: boolean;
  onClose: () => void;
  onActivatePlacement: (data: { type: string; name: string; notes: string }) => void;
}

export const AddCheckpointModal: React.FC<AddCheckpointModalProps> = ({
  isOpen,
  onClose,
  onActivatePlacement
}) => {
  const [cpType, setCpType] = useState('timing');
  const [cpName, setCpName] = useState('Shankar Nagar Hydration Post');
  const [cpNotes, setCpNotes] = useState('200 Energy drinks ready. 2 marshals stationed.');

  if (!isOpen) return null;

  const handlePlace = () => {
    onActivatePlacement({
      type: cpType,
      name: cpName,
      notes: cpNotes
    });
    onClose();
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
          maxWidth: '480px',
          background: 'rgba(16, 24, 43, 0.95)',
          border: '1px solid rgba(255, 255, 255, 0.16)',
          borderRadius: '20px',
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
          <div style={{ fontSize: '32px', marginBottom: '6px' }}>📍</div>
          <h2 style={{ fontSize: '20px', fontWeight: 900, color: '#fff' }}>Add Official Event Checkpoint</h2>
          <p style={{ fontSize: '12px', color: '#94A3B8', marginTop: '4px' }}>
            Drop a monitored station along the active corridor for runners, cyclists or marshals.
          </p>
        </div>

        <div style={{ marginBottom: '16px' }}>
          <label style={{ fontSize: '11px', fontWeight: 800, color: '#64748B', display: 'block', marginBottom: '6px' }}>CHECKPOINT TYPE</label>
          <select
            value={cpType}
            onChange={(e) => setCpType(e.target.value)}
            style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', background: 'rgba(0,0,0,0.3)', border: '1px solid rgba(255,255,255,0.15)', color: '#fff', fontSize: '13px', outline: 'none' }}
          >
            <option value="timing">⏱️ Timing Mat / RFID Checkpoint</option>
            <option value="hydration">💧 Hydration / Water Station</option>
            <option value="medical">🏥 First Aid / Medical Station</option>
            <option value="barricade">🚧 Police Traffic Barricade</option>
            <option value="flagoff">🚩 Flag-Off / Assembly Point</option>
            <option value="finish">🏁 Finish Line Pavilion</option>
          </select>
        </div>

        <div style={{ marginBottom: '16px' }}>
          <label style={{ fontSize: '11px', fontWeight: 800, color: '#64748B', display: 'block', marginBottom: '6px' }}>CHECKPOINT NAME / LANDMARK</label>
          <input
            type="text"
            value={cpName}
            onChange={(e) => setCpName(e.target.value)}
            style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', background: 'rgba(0,0,0,0.3)', border: '1px solid rgba(255,255,255,0.15)', color: '#fff', fontSize: '13px', outline: 'none' }}
          />
        </div>

        <div style={{ marginBottom: '24px' }}>
          <label style={{ fontSize: '11px', fontWeight: 800, color: '#64748B', display: 'block', marginBottom: '6px' }}>OPERATIONAL NOTES</label>
          <textarea
            rows={2}
            value={cpNotes}
            onChange={(e) => setCpNotes(e.target.value)}
            style={{ width: '100%', padding: '10px 14px', borderRadius: '10px', background: 'rgba(0,0,0,0.3)', border: '1px solid rgba(255,255,255,0.15)', color: '#fff', fontSize: '13px', outline: 'none' }}
          />
        </div>

        <div style={{ display: 'flex', gap: '12px' }}>
          <button
            onClick={onClose}
            style={{ flex: 1, padding: '12px', borderRadius: '10px', background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.12)', color: '#fff', fontWeight: 700, fontSize: '13px', cursor: 'pointer' }}
          >
            Cancel
          </button>
          <button
            onClick={handlePlace}
            style={{ flex: 2, padding: '12px', borderRadius: '10px', background: 'linear-gradient(135deg, #00F2FE 0%, #4FACFE 100%)', border: 'none', color: '#050811', fontWeight: 800, fontSize: '13px', cursor: 'pointer', boxShadow: '0 4px 16px rgba(0, 242, 254, 0.4)' }}
          >
            📍 Place on 3D Map
          </button>
        </div>
      </div>
    </div>
  );
};
