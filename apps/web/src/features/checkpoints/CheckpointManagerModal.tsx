/**
 * =========================================================================
 * ZEROMILE GO - CHECKPOINT MANAGER MODAL (CheckpointManagerModal.tsx)
 * Placement, Inspection and Supabase Persistence of Geocoded Checkpoints
 * =========================================================================
 */

import React, { useState } from 'react';
import { RouteCheckpoint, CheckpointType } from '../../types';
import { MapPin, Plus, Trash2, Droplets, ShieldAlert, Flag, CheckCircle2, X } from 'lucide-react';
import { upsertRouteCheckpoint, deleteRouteCheckpoint } from '../../services/supabaseClient';
import { useToast } from '../../context/ToastContext';

interface CheckpointManagerModalProps {
  isOpen: boolean;
  onClose: () => void;
  domainId: string;
  checkpoints: RouteCheckpoint[];
  onRefresh: () => void;
}

export const CheckpointManagerModal: React.FC<CheckpointManagerModalProps> = ({
  isOpen,
  onClose,
  domainId,
  checkpoints,
  onRefresh
}) => {
  const { showToast } = useToast();
  const [name, setName] = useState('');
  const [type, setType] = useState<CheckpointType>('WATER_STATION');
  const [lat, setLat] = useState('21.1498');
  const [lng, setLng] = useState('79.0806');
  const [isSubmitting, setIsSubmitting] = useState(false);

  if (!isOpen) return null;

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) return;

    setIsSubmitting(true);
    const success = await upsertRouteCheckpoint({
      domainId,
      name: name.trim(),
      checkpointType: type,
      latitude: parseFloat(lat),
      longitude: parseFloat(lng),
      sequenceOrder: checkpoints.length + 1
    });

    setIsSubmitting(false);
    if (success) {
      showToast(`📍 Checkpoint "<b>${name}</b>" deployed & synced to live database!`, 'success');
      setName('');
      onRefresh();
    } else {
      showToast('❌ Failed to save checkpoint to database.', 'error');
    }
  };

  const handleDelete = async (id: string, cpName: string) => {
    const success = await deleteRouteCheckpoint(id);
    if (success) {
      showToast(`🗑️ Removed checkpoint "<b>${cpName}</b>"`, 'info');
      onRefresh();
    }
  };

  const getTypeIcon = (cpType: CheckpointType) => {
    switch (cpType) {
      case 'WATER_STATION': return <Droplets size={16} color="#00F2FE" />;
      case 'MEDICAL_POST': return <ShieldAlert size={16} color="#FF1744" />;
      case 'START': return <Flag size={16} color="#00E676" />;
      case 'FINISH': return <CheckCircle2 size={16} color="#FFD700" />;
      default: return <MapPin size={16} color="#94A3B8" />;
    }
  };

  return (
    <div style={{
      position: 'fixed',
      inset: 0,
      zIndex: 9999,
      backgroundColor: 'rgba(5, 8, 17, 0.8)',
      backdropFilter: 'blur(12px)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '20px'
    }}>
      <div className="glass-panel-elevated" style={{ width: '100%', maxWidth: '640px', padding: '24px' }}>
        {/* Header */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            <div style={{ padding: '8px', background: 'rgba(0, 242, 254, 0.15)', borderRadius: '8px' }}>
              <MapPin size={22} color="#00F2FE" />
            </div>
            <div>
              <h3 style={{ fontSize: '18px', fontWeight: 800, color: '#fff' }}>Route Checkpoints & Stations</h3>
              <p style={{ fontSize: '12px', color: '#94A3B8' }}>Deploy hydration posts, medical trauma units & timing gates</p>
            </div>
          </div>
          <button onClick={onClose} style={{ background: 'none', border: 'none', color: '#94A3B8', cursor: 'pointer' }}>
            <X size={20} />
          </button>
        </div>

        {/* Existing Checkpoints List */}
        <div style={{ maxHeight: '220px', overflowY: 'auto', marginBottom: '20px', display: 'flex', flexDirection: 'column', gap: '8px' }}>
          {checkpoints.length === 0 ? (
            <div style={{ textAlign: 'center', padding: '24px', color: '#64748B', fontSize: '13px' }}>
              No checkpoints deployed yet. Add your first station below.
            </div>
          ) : (
            checkpoints.map(cp => (
              <div
                key={cp.id}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                  padding: '10px 14px',
                  background: 'rgba(255, 255, 255, 0.04)',
                  borderRadius: '8px',
                  border: '1px solid rgba(255, 255, 255, 0.06)'
                }}
              >
                <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                  {getTypeIcon(cp.checkpointType)}
                  <div>
                    <div style={{ fontSize: '13px', fontWeight: 700, color: '#fff' }}>{cp.name}</div>
                    <div style={{ fontSize: '11px', color: '#64748B' }}>
                      Seq #{cp.sequenceOrder} • {cp.latitude.toFixed(4)}, {cp.longitude.toFixed(4)}
                    </div>
                  </div>
                </div>
                <button
                  onClick={() => handleDelete(cp.id, cp.name)}
                  style={{ background: 'none', border: 'none', color: '#FF1744', cursor: 'pointer', padding: '4px' }}
                >
                  <Trash2 size={16} />
                </button>
              </div>
            ))
          )}
        </div>

        {/* Add New Form */}
        <form onSubmit={handleCreate} style={{ display: 'flex', flexDirection: 'column', gap: '14px', borderTop: '1px solid rgba(255, 255, 255, 0.08)', paddingTop: '16px' }}>
          <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: '10px' }}>
            <div>
              <label style={{ fontSize: '11px', fontWeight: 700, color: '#94A3B8', display: 'block', marginBottom: '4px' }}>STATION NAME</label>
              <input
                type="text"
                value={name}
                onChange={e => setName(e.target.value)}
                placeholder="e.g. Shankar Nagar Hydration Post"
                required
                style={{
                  width: '100%',
                  padding: '10px 12px',
                  background: 'rgba(0, 0, 0, 0.3)',
                  border: '1px solid rgba(255, 255, 255, 0.12)',
                  borderRadius: '6px',
                  color: '#fff',
                  fontSize: '13px'
                }}
              />
            </div>
            <div>
              <label style={{ fontSize: '11px', fontWeight: 700, color: '#94A3B8', display: 'block', marginBottom: '4px' }}>TYPE</label>
              <select
                value={type}
                onChange={e => setType(e.target.value as CheckpointType)}
                style={{
                  width: '100%',
                  padding: '10px 12px',
                  background: '#0d1527',
                  border: '1px solid rgba(255, 255, 255, 0.12)',
                  borderRadius: '6px',
                  color: '#fff',
                  fontSize: '13px'
                }}
              >
                <option value="WATER_STATION">Hydration Station</option>
                <option value="MEDICAL_POST">Medical Trauma Van</option>
                <option value="START">Start Line Arch</option>
                <option value="FINISH">Finish Line Gate</option>
              </select>
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '10px' }}>
            <div>
              <label style={{ fontSize: '11px', fontWeight: 700, color: '#94A3B8', display: 'block', marginBottom: '4px' }}>LATITUDE</label>
              <input
                type="number"
                step="any"
                value={lat}
                onChange={e => setLat(e.target.value)}
                required
                style={{
                  width: '100%',
                  padding: '8px 12px',
                  background: 'rgba(0, 0, 0, 0.3)',
                  border: '1px solid rgba(255, 255, 255, 0.12)',
                  borderRadius: '6px',
                  color: '#fff',
                  fontSize: '12px'
                }}
              />
            </div>
            <div>
              <label style={{ fontSize: '11px', fontWeight: 700, color: '#94A3B8', display: 'block', marginBottom: '4px' }}>LONGITUDE</label>
              <input
                type="number"
                step="any"
                value={lng}
                onChange={e => setLng(e.target.value)}
                required
                style={{
                  width: '100%',
                  padding: '8px 12px',
                  background: 'rgba(0, 0, 0, 0.3)',
                  border: '1px solid rgba(255, 255, 255, 0.12)',
                  borderRadius: '6px',
                  color: '#fff',
                  fontSize: '12px'
                }}
              />
            </div>
          </div>

          <button
            type="submit"
            disabled={isSubmitting}
            style={{
              marginTop: '8px',
              padding: '12px',
              background: 'linear-gradient(135deg, #00F2FE 0%, #0099FE 100%)',
              border: 'none',
              borderRadius: '8px',
              color: '#050811',
              fontWeight: 800,
              fontSize: '13px',
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              gap: '8px'
            }}
          >
            <Plus size={16} /> Deploy Checkpoint to Route
          </button>
        </form>
      </div>
    </div>
  );
};
