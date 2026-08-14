import React from 'react';
import { Radio, AlertTriangle } from 'lucide-react';

export const BroadcastDrawer: React.FC = () => {
  return (
    <aside style={{
      width: '360px',
      backgroundColor: 'rgba(19, 27, 46, 0.85)',
      backdropFilter: 'blur(20px)',
      borderLeft: '1px solid rgba(255, 255, 255, 0.08)',
      height: 'calc(100vh - 64px)',
      padding: '20px',
      display: 'flex',
      flexDirection: 'column',
      gap: '16px',
      color: '#FFFFFF'
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
        <Radio size={20} color="#00F2FE" />
        <h3 style={{ margin: 0, fontFamily: 'Outfit, sans-serif', fontSize: '16px', fontWeight: 600 }}>
          Live Event Broadcasts
        </h3>
      </div>

      <div style={{
        padding: '12px',
        backgroundColor: '#090D16',
        borderRadius: '12px',
        border: '1px solid rgba(255, 255, 255, 0.08)'
      }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '4px' }}>
          <span style={{ color: '#00F2FE', fontSize: '11px', fontWeight: 700 }}>ORGANIZER UPDATE</span>
          <span style={{ color: '#64748B', fontSize: '10px' }}>07:15 AM</span>
        </div>
        <p style={{ margin: 0, fontSize: '13px', color: '#94A3B8', lineHeight: 1.4 }}>
          🏁 Flag-off started at Futala Lake! First peloton heading towards Law College Chowk.
        </p>
      </div>

      <div style={{
        padding: '12px',
        backgroundColor: '#090D16',
        borderRadius: '12px',
        border: '1px solid rgba(255, 145, 0, 0.3)'
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '6px', marginBottom: '4px' }}>
          <AlertTriangle size={14} color="#FF9100" />
          <span style={{ color: '#FF9100', fontSize: '11px', fontWeight: 700 }}>POLICE TRAFFIC ADVISORY</span>
        </div>
        <p style={{ margin: 0, fontSize: '13px', color: '#94A3B8', lineHeight: 1.4 }}>
          ⚠️ Moderate traffic slowdown near Variety Square Chowk. Commuters advised to use Katol Flyover.
        </p>
      </div>
    </aside>
  );
};
