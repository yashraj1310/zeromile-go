import React, { useState, useEffect } from 'react';
import {
  MapPin,
  Navigation,
  Radio,
  Bell,
  Users,
  Shield,
  AlertTriangle,
  Flame,
  CheckCircle2,
  ChevronRight,
  Send,
  Phone,
  QrCode,
  Calendar,
  Clock,
  ArrowRight,
  Share2,
  Filter,
  Eye,
  RefreshCw,
  Plus,
  Compass,
  Activity,
  Layers,
  Sparkles,
  Info,
  ChevronDown,
  Volume2,
  Check
} from 'lucide-react';

const DOMAINS = [
  { id: 'cycling-2026', name: '🚲 CYCLING RALLY 2026', type: 'CYCLING', date: '15-Nov-2026', time: '06:00 - 11:30 AM', color: '#00F2FE', participants: '1,248 Riders' },
  { id: 'marathon-2026', name: '🏃 NAGPUR CITY MARATHON', type: 'MARATHON', date: '22-Nov-2026', time: '05:30 - 10:00 AM', color: '#00E676', participants: '3,400 Runners' },
  { id: 'protest-2026', name: '📢 CITIZEN PEACE MARCH', type: 'PROTEST', date: '01-Dec-2026', time: '09:00 - 02:00 PM', color: '#FF9100', participants: '850 Citizens' },
];

export function App() {
  const [activeTab, setActiveTab] = useState<'SCREEN_1_LIVE' | 'SCREEN_1B_INACTIVE' | 'SCREEN_2_GROUPS' | 'SCREEN_4_REQUEST' | 'PROFILE_QR' | 'PUBLIC_MAP'>('SCREEN_1_LIVE');
  const [currentDomain, setCurrentDomain] = useState(DOMAINS[0]);
  const [activeGroupId, setActiveGroupId] = useState('vnit-club');
  const [showSosModal, setShowSosModal] = useState(false);
  const [showShareModal, setShowShareModal] = useState(false);
  const [toastMsg, setToastMsg] = useState<string | null>(null);
  const [sosHolding, setSosHolding] = useState(false);
  const [holdProgress, setHoldProgress] = useState(0);

  // SOS 3-Second Hold Simulation
  useEffect(() => {
    let interval: any;
    if (sosHolding) {
      interval = setInterval(() => {
        setHoldProgress((prev) => {
          if (prev >= 100) {
            clearInterval(interval);
            setSosHolding(false);
            setShowSosModal(true);
            return 0;
          }
          return prev + 5;
        });
      }, 50);
    } else {
      setHoldProgress(0);
    }
    return () => clearInterval(interval);
  }, [sosHolding]);

  const showToast = (msg: string) => {
    setToastMsg(msg);
    setTimeout(() => setToastMsg(null), 3500);
  };

  return (
    <div style={{ position: 'relative', display: 'flex', flexDirection: 'column', height: '100vh', backgroundColor: '#060911', color: '#F8FAFC', overflow: 'hidden' }}>
      
      {/* Dynamic Ambient Background Illumination */}
      <div className="ambient-glow" style={{ top: '-100px', left: '-100px', background: 'radial-gradient(circle, rgba(0, 242, 254, 0.12) 0%, rgba(6, 9, 17, 0) 70%)' }} />
      <div className="ambient-glow" style={{ bottom: '-150px', right: '-100px', background: 'radial-gradient(circle, rgba(0, 230, 118, 0.08) 0%, rgba(6, 9, 17, 0) 70%)' }} />
      <div className="ambient-glow" style={{ top: '30%', right: '25%', background: 'radial-gradient(circle, rgba(255, 23, 68, 0.05) 0%, rgba(6, 9, 17, 0) 70%)' }} />

      {/* Top Luxury Command Bar */}
      <header style={{
        zIndex: 50,
        backgroundColor: 'rgba(10, 15, 29, 0.85)',
        backdropFilter: 'blur(20px)',
        borderBottom: '1px solid rgba(255, 255, 255, 0.08)',
        padding: '12px 28px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        boxShadow: '0 4px 30px rgba(0, 0, 0, 0.5)'
      }}>
        {/* Left Branding */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '20px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            <div style={{
              width: '36px',
              height: '36px',
              borderRadius: '10px',
              background: 'linear-gradient(135deg, #00F2FE 0%, #4FACFE 100%)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              boxShadow: '0 0 20px rgba(0, 242, 254, 0.5)'
            }}>
              <Compass size={22} color="#060911" strokeWidth={2.5} />
            </div>
            <div>
              <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                <h1 style={{ fontSize: '17px', fontWeight: '800', margin: 0, letterSpacing: '0.8px', background: 'linear-gradient(180deg, #FFFFFF 0%, #94A3B8 100%)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>
                  VIKASIT NAGPUR
                </h1>
                <span style={{ fontSize: '10px', backgroundColor: 'rgba(0, 242, 254, 0.15)', color: '#00F2FE', border: '1px solid rgba(0, 242, 254, 0.3)', padding: '2px 8px', borderRadius: '12px', fontWeight: 700, letterSpacing: '0.5px' }}>
                  CIVIC PLATFORM
                </span>
              </div>
              <p style={{ fontSize: '11px', color: '#64748B', margin: 0 }}>Smart City Event & Rally Orchestrator</p>
            </div>
          </div>

          {/* Multi-Tenant Event Domain Dropdown */}
          <div style={{ position: 'relative' }}>
            <select
              value={currentDomain.id}
              onChange={(e) => {
                const d = DOMAINS.find(x => x.id === e.target.value);
                if (d) {
                  setCurrentDomain(d);
                  showToast(`Switched Tenant Domain to ${d.name}`);
                }
              }}
              style={{
                backgroundColor: 'rgba(19, 27, 46, 0.9)',
                color: '#F8FAFC',
                border: `1.5px solid ${currentDomain.color}`,
                borderRadius: '10px',
                padding: '8px 16px',
                fontSize: '12px',
                fontWeight: '700',
                cursor: 'pointer',
                outline: 'none',
                boxShadow: `0 0 16px ${currentDomain.color}25`
              }}
            >
              {DOMAINS.map(d => (
                <option key={d.id} value={d.id} style={{ backgroundColor: '#090D16', color: '#FFFFFF' }}>{d.name} ({d.participants})</option>
              ))}
            </select>
          </div>
        </div>

        {/* Yashraj's Interactive Screen Switcher Pills */}
        <div style={{ display: 'flex', gap: '8px', padding: '4px', backgroundColor: 'rgba(15, 23, 42, 0.8)', borderRadius: '14px', border: '1px solid rgba(255, 255, 255, 0.06)' }}>
          {[
            { id: 'SCREEN_1_LIVE', label: '📱 Screen 1: Active Live HUD', color: '#00F2FE' },
            { id: 'SCREEN_1B_INACTIVE', label: '🏁 Screen 1B: Pre/Post Inactive', color: '#94A3B8' },
            { id: 'SCREEN_2_GROUPS', label: '👥 Screen 2: Groups (Max 3 / 1-Active)', color: '#38BDF8' },
            { id: 'SCREEN_4_REQUEST', label: '📋 Screen 4: 8-Org Form', color: '#A855F7' },
            { id: 'PROFILE_QR', label: '👤 Profile & QR Pass', color: '#00E676' },
            { id: 'PUBLIC_MAP', label: '🌐 Public Commuter Map', color: '#FF9100' },
          ].map(tab => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id as any)}
              style={{
                padding: '8px 14px',
                borderRadius: '10px',
                fontSize: '11px',
                fontWeight: '700',
                border: 'none',
                cursor: 'pointer',
                transition: 'all 0.2s ease',
                backgroundColor: activeTab === tab.id ? tab.color : 'transparent',
                color: activeTab === tab.id ? '#060911' : '#94A3B8',
                boxShadow: activeTab === tab.id ? `0 0 20px ${tab.color}40` : 'none'
              }}
            >
              {tab.label}
            </button>
          ))}
        </div>
      </header>

      {/* Main Showcase Viewport */}
      <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '24px', overflowY: 'auto', zIndex: 10 }}>
        
        {activeTab !== 'PUBLIC_MAP' ? (
          /* High-Fidelity Mobile Hardware Simulator Frame */
          <div style={{
            width: '410px',
            height: '840px',
            background: 'linear-gradient(180deg, #0D1424 0%, #080C17 100%)',
            borderRadius: '46px',
            border: '10px solid #1E293B',
            boxShadow: '0 30px 90px rgba(0, 0, 0, 0.8), 0 0 50px rgba(0, 242, 254, 0.15)',
            overflow: 'hidden',
            display: 'flex',
            flexDirection: 'column',
            position: 'relative'
          }}>
            
            {/* Dynamic Island & Hardware Notch */}
            <div style={{ padding: '10px 24px', display: 'flex', justifyContent: 'space-between', alignItems: 'center', backgroundColor: '#0D1424', fontSize: '11px', color: '#94A3B8', borderBottom: '1px solid rgba(255,255,255,0.04)' }}>
              <span style={{ fontWeight: '600', color: '#FFFFFF' }}>08:30 AM</span>
              <div style={{
                width: '90px',
                height: '22px',
                backgroundColor: '#000000',
                borderRadius: '20px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                gap: '6px',
                fontSize: '9px',
                color: '#00F2FE',
                fontWeight: '700'
              }}>
                <div style={{ width: '6px', height: '6px', borderRadius: '50%', backgroundColor: '#00E676', animation: 'pulseGlow 2s infinite' }} />
                <span>LIVE RALLY</span>
              </div>
              <div style={{ display: 'flex', gap: '6px', alignItems: 'center' }}>
                <span style={{ color: '#00E676', fontWeight: 'bold' }}>5G</span>
                <span>100%</span>
              </div>
            </div>

            {/* SCREEN 1: ACTIVE EVENT WINDOW */}
            {activeTab === 'SCREEN_1_LIVE' && (
              <div style={{ flex: 1, display: 'flex', flexDirection: 'column', overflowY: 'auto', padding: '16px', gap: '14px', position: 'relative' }}>
                
                {/* Domain Header Card */}
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <div>
                    <h2 style={{ fontSize: '16px', fontWeight: '800', margin: 0, color: '#FFFFFF', letterSpacing: '0.3px' }}>{currentDomain.name}</h2>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '6px', marginTop: '2px' }}>
                      <div style={{ width: '6px', height: '6px', borderRadius: '50%', backgroundColor: '#00E676', animation: 'pulseGlow 1.5s infinite' }} />
                      <span style={{ fontSize: '10px', color: '#00E676', fontWeight: 700, letterSpacing: '0.5px' }}>EVENT WINDOW ACTIVE (GPS & SOS ON)</span>
                    </div>
                  </div>
                  <div style={{ position: 'relative', width: '36px', height: '36px', borderRadius: '10px', backgroundColor: 'rgba(255,255,255,0.05)', display: 'flex', alignItems: 'center', justifyContent: 'center', border: '1px solid rgba(255,255,255,0.1)' }}>
                    <Bell size={18} color="#00F2FE" />
                    <span style={{ position: 'absolute', top: '-2px', right: '-2px', backgroundColor: '#FF1744', fontSize: '9px', fontWeight: '800', borderRadius: '50%', width: '15px', height: '15px', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#FFFFFF' }}>2</span>
                  </div>
                </div>

                {/* Interactive Live Route Map (Vector Canvas Simulation) */}
                <div style={{
                  background: 'linear-gradient(135deg, rgba(19, 27, 46, 0.9) 0%, rgba(13, 20, 36, 0.95) 100%)',
                  borderRadius: '20px',
                  border: '1px solid rgba(0, 242, 254, 0.3)',
                  padding: '14px',
                  boxShadow: '0 8px 30px rgba(0, 242, 254, 0.12)'
                }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '8px' }}>
                    <span style={{ fontSize: '11px', fontWeight: '800', color: '#00F2FE', display: 'flex', alignItems: 'center', gap: '6px', letterSpacing: '0.5px' }}>
                      <Navigation size={14} color="#00F2FE" /> INTERACTIVE LIVE RALLY ROUTE MAP
                    </span>
                    <span style={{ fontSize: '10px', color: '#94A3B8', fontFamily: 'monospace' }}>24.5 KM LOOP</span>
                  </div>

                  {/* High-Tech Vector Map Layer */}
                  <div style={{ height: '140px', backgroundColor: '#080C17', borderRadius: '14px', position: 'relative', overflow: 'hidden', border: '1px solid rgba(255, 255, 255, 0.06)' }}>
                    
                    {/* Glowing Street Grid Pattern */}
                    <div style={{
                      position: 'absolute',
                      inset: 0,
                      backgroundImage: 'radial-gradient(rgba(0, 242, 254, 0.08) 1px, transparent 1px)',
                      backgroundSize: '16px 16px'
                    }} />

                    {/* Animated Flowing Polyline */}
                    <svg width="100%" height="100%" style={{ position: 'absolute' }}>
                      <path
                        d="M 30 110 Q 110 30 190 70 T 340 40"
                        fill="none"
                        stroke="#00F2FE"
                        strokeWidth="5"
                        strokeDasharray="10 5"
                        style={{ animation: 'routeFlow 3s linear infinite' }}
                      />
                      {/* Density Cluster Zones */}
                      <circle cx="110" cy="50" r="18" fill="rgba(241, 240, 117, 0.2)" stroke="#F1F075" strokeWidth="1" />
                      <circle cx="260" cy="55" r="14" fill="rgba(59, 178, 208, 0.2)" stroke="#3BB2D0" strokeWidth="1" />
                    </svg>

                    {/* Start Pin */}
                    <div style={{ position: 'absolute', bottom: '12px', left: '12px', display: 'flex', alignItems: 'center', gap: '4px', backgroundColor: 'rgba(9, 13, 22, 0.9)', padding: '3px 8px', borderRadius: '6px', border: '1px solid #00E676', fontSize: '9px', fontWeight: 'bold', color: '#00E676' }}>
                      <div style={{ width: '5px', height: '5px', borderRadius: '50%', backgroundColor: '#00E676' }} />
                      🚩 Zero Mile Start
                    </div>

                    {/* Live User Node with Pulsing Radar Rings */}
                    <div style={{ position: 'absolute', top: '48px', left: '42%', transform: 'translate(-50%, -50%)', display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                      <div style={{ position: 'relative', width: '16px', height: '16px', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                        <div style={{ position: 'absolute', width: '100%', height: '100%', borderRadius: '50%', backgroundColor: '#00F2FE', animation: 'radarWave 1.8s infinite' }} />
                        <div style={{ width: '10px', height: '10px', borderRadius: '50%', backgroundColor: '#00F2FE', border: '2px solid #FFFFFF', zIndex: 2 }} />
                      </div>
                      <span style={{ fontSize: '9px', fontWeight: '800', color: '#FFFFFF', backgroundColor: 'rgba(0, 242, 254, 0.9)', padding: '1px 6px', borderRadius: '4px', marginTop: '2px', color: '#060911' }}>
                        📍 YOU
                      </span>
                    </div>

                    {/* Finish Pin */}
                    <div style={{ position: 'absolute', top: '12px', right: '12px', display: 'flex', alignItems: 'center', gap: '4px', backgroundColor: 'rgba(9, 13, 22, 0.9)', padding: '3px 8px', borderRadius: '6px', border: '1px solid #FF9100', fontSize: '9px', fontWeight: 'bold', color: '#FF9100' }}>
                      🏁 Deekshabhoomi
                    </div>
                  </div>

                  {/* Route Checkpoint Badges */}
                  <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '8px', marginTop: '8px' }}>
                    <div style={{ backgroundColor: 'rgba(0, 242, 254, 0.06)', padding: '8px 10px', borderRadius: '10px', border: '1px solid rgba(0, 242, 254, 0.2)', fontSize: '11px' }}>
                      <div style={{ color: '#00F2FE', fontWeight: '700' }}>💧 Water Point 1</div>
                      <div style={{ fontSize: '10px', color: '#94A3B8' }}>Shankar Nagar Sq (2 km)</div>
                    </div>
                    <div style={{ backgroundColor: 'rgba(255, 23, 68, 0.06)', padding: '8px 10px', borderRadius: '10px', border: '1px solid rgba(255, 23, 68, 0.2)', fontSize: '11px' }}>
                      <div style={{ color: '#FF1744', fontWeight: '700' }}>🚑 Medical Post</div>
                      <div style={{ fontSize: '10px', color: '#94A3B8' }}>Law College Sq (5 km)</div>
                    </div>
                  </div>
                </div>

                {/* Latest Prioritized Broadcasts Feed */}
                <div style={{ background: 'linear-gradient(135deg, rgba(19, 27, 46, 0.9) 0%, rgba(13, 20, 36, 0.95) 100%)', borderRadius: '20px', border: '1px solid rgba(255, 255, 255, 0.08)', padding: '14px' }}>
                  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '8px' }}>
                    <span style={{ fontSize: '11px', fontWeight: '800', color: '#FFFFFF', display: 'flex', alignItems: 'center', gap: '6px', letterSpacing: '0.5px' }}>
                      <Radio size={14} color="#FF9100" /> 📢 LATEST BROADCASTS
                    </span>
                    <span style={{ fontSize: '10px', color: '#00E676', fontWeight: 'bold' }}>LIVE FEED</span>
                  </div>
                  <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                    <div style={{ backgroundColor: 'rgba(255, 23, 68, 0.08)', borderLeft: '3px solid #FF1744', padding: '8px 12px', borderRadius: '8px', fontSize: '11px' }}>
                      <strong style={{ color: '#FF1744' }}>🚨 SUPERADMIN:</strong> "Flag-off at 06:00 AM from Zero Mile Monument."
                    </div>
                    <div style={{ backgroundColor: 'rgba(0, 242, 254, 0.08)', borderLeft: '3px solid #00F2FE', padding: '8px 12px', borderRadius: '8px', fontSize: '11px' }}>
                      <strong style={{ color: '#00F2FE' }}>📣 LEADER NOTE:</strong> "Assemble at Gate 1 by 05:30 AM sharp."
                    </div>
                  </div>
                </div>

                {/* Your Active Sub-Group Card */}
                <div style={{ background: 'linear-gradient(135deg, rgba(19, 27, 46, 0.95) 0%, rgba(13, 20, 36, 0.95) 100%)', borderRadius: '20px', border: '1px solid rgba(0, 242, 254, 0.25)', padding: '14px', boxShadow: '0 8px 24px rgba(0,0,0,0.4)' }}>
                  <span style={{ fontSize: '10px', color: '#64748B', textTransform: 'uppercase', letterSpacing: '0.8px', fontWeight: '700' }}>
                    YOUR ACTIVE SUB-GROUP:
                  </span>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: '4px' }}>
                    <div>
                      <h3 style={{ fontSize: '15px', fontWeight: '800', margin: 0, color: '#FFFFFF' }}>
                        🎓 VNIT Cycling Club
                      </h3>
                      <span style={{ fontSize: '11px', color: '#94A3B8' }}>38 Members • Status: Check-in Open</span>
                    </div>
                    <span style={{ fontSize: '10px', backgroundColor: 'rgba(0, 230, 118, 0.2)', color: '#00E676', border: '1px solid rgba(0, 230, 118, 0.4)', padding: '3px 8px', borderRadius: '6px', fontWeight: '800' }}>
                      LEADER
                    </span>
                  </div>

                  <div style={{ marginTop: '12px', display: 'flex', gap: '8px' }}>
                    <button
                      onClick={() => showToast('Navigating to Group Leader Hub...')}
                      style={{ flex: 1, background: 'linear-gradient(135deg, #1E293B 0%, #0F172A 100%)', color: '#00F2FE', border: '1px solid rgba(0, 242, 254, 0.3)', borderRadius: '10px', padding: '9px', fontSize: '11px', fontWeight: '700', cursor: 'pointer' }}
                    >
                      [ Open Group Chat & Roster &gt; ]
                    </button>
                    <button
                      onClick={() => setActiveTab('SCREEN_2_GROUPS')}
                      style={{ backgroundColor: 'rgba(255, 255, 255, 0.05)', color: '#F8FAFC', border: '1px solid rgba(255, 255, 255, 0.1)', borderRadius: '10px', padding: '9px 12px', fontSize: '11px', fontWeight: '600', cursor: 'pointer' }}
                    >
                      🔄 Change
                    </button>
                  </div>
                </div>

                {/* Floating Multi-Ring Breathing Emergency SOS Panic FAB */}
                <div style={{ position: 'absolute', bottom: '70px', right: '16px', zIndex: 30, display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                  <button
                    onMouseDown={() => setSosHolding(true)}
                    onMouseUp={() => setSosHolding(false)}
                    onTouchStart={() => setSosHolding(true)}
                    onTouchEnd={() => setSosHolding(false)}
                    onClick={() => setShowSosModal(true)}
                    style={{
                      width: '68px',
                      height: '68px',
                      borderRadius: '50%',
                      background: 'radial-gradient(circle, #FF1744 0%, #B71C1C 100%)',
                      color: '#FFFFFF',
                      border: '3px solid rgba(255, 255, 255, 0.9)',
                      boxShadow: '0 0 30px rgba(255, 23, 68, 0.8), 0 0 60px rgba(255, 23, 68, 0.4)',
                      display: 'flex',
                      flexDirection: 'column',
                      alignItems: 'center',
                      justifyContent: 'center',
                      fontWeight: '900',
                      fontSize: '13px',
                      cursor: 'pointer',
                      letterSpacing: '0.5px'
                    }}
                  >
                    <AlertTriangle size={20} />
                    <span>SOS</span>
                  </button>
                  <span style={{ fontSize: '9px', color: '#FF8A80', fontWeight: '700', marginTop: '4px', textShadow: '0 0 10px rgba(0,0,0,0.8)' }}>
                    TAP OR HOLD
                  </span>
                </div>
              </div>
            )}

            {/* SCREEN 1B: PRE/POST INACTIVE EVENT WINDOW */}
            {activeTab === 'SCREEN_1B_INACTIVE' && (
              <div style={{ flex: 1, display: 'flex', flexDirection: 'column', overflowY: 'auto', padding: '16px', gap: '14px' }}>
                <div style={{ background: 'linear-gradient(135deg, rgba(30, 41, 59, 0.9) 0%, rgba(15, 23, 42, 0.9) 100%)', borderRadius: '16px', padding: '14px', border: '1px solid rgba(255, 255, 255, 0.1)' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '6px', color: '#94A3B8', fontSize: '11px', fontWeight: '800' }}>
                    <Calendar size={14} color="#00F2FE" />
                    🏁 EVENT STATUS: CONCLUDED / PRE-EVENT
                  </div>
                  <div style={{ fontSize: '13px', color: '#FFFFFF', marginTop: '4px', fontWeight: '700' }}>
                    🕒 Schedule: 15-Nov-2026 (06:00 - 11:30 AM)
                  </div>
                  <p style={{ fontSize: '11px', color: '#64748B', margin: '4px 0 0 0' }}>
                    Live GPS tracking and SOS emergency buttons are deactivated outside official hours.
                  </p>
                </div>

                <div style={{ background: 'linear-gradient(135deg, rgba(19, 27, 46, 0.9) 0%, rgba(13, 20, 36, 0.95) 100%)', borderRadius: '20px', border: '1px solid rgba(255, 255, 255, 0.08)', padding: '14px' }}>
                  <span style={{ fontSize: '11px', fontWeight: '800', color: '#FFFFFF', letterSpacing: '0.5px' }}>🗺️ PUBLISHED ROUTE PREVIEW (STATIC)</span>
                  <div style={{ height: '140px', backgroundColor: '#080C17', borderRadius: '14px', marginTop: '10px', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: '8px', color: '#94A3B8', fontSize: '11px', textAlign: 'center', padding: '16px', border: '1px solid rgba(255,255,255,0.06)' }}>
                    <MapPin size={28} color="#00F2FE" />
                    <span style={{ fontWeight: '700', color: '#FFFFFF' }}>[ Zero Mile ] === 24.5 km Route ===&gt; [ Deekshabhoomi ]</span>
                    <span style={{ color: '#64748B', fontSize: '10px' }}>ℹ️ Live GPS tracking & SOS are inactive outside official hours.</span>
                  </div>
                </div>

                <div style={{ background: 'linear-gradient(135deg, rgba(19, 27, 46, 0.9) 0%, rgba(13, 20, 36, 0.95) 100%)', borderRadius: '20px', border: '1px solid rgba(255, 255, 255, 0.08)', padding: '14px' }}>
                  <span style={{ fontSize: '11px', fontWeight: '800', color: '#FFFFFF', letterSpacing: '0.5px' }}>📢 EVENT ANNOUNCEMENTS</span>
                  <p style={{ fontSize: '11px', color: '#94A3B8', margin: '8px 0 0 0' }}>
                    ℹ️ "Event concluded successfully. Participation certificates are now ready for download in your Profile tab."
                  </p>
                </div>

                <div style={{ background: 'linear-gradient(135deg, rgba(19, 27, 46, 0.9) 0%, rgba(13, 20, 36, 0.95) 100%)', borderRadius: '20px', border: '1px solid rgba(255, 255, 255, 0.08)', padding: '14px' }}>
                  <span style={{ fontSize: '11px', fontWeight: '800', color: '#FFFFFF', letterSpacing: '0.5px' }}>YOUR SUB-GROUPS:</span>
                  <div style={{ marginTop: '8px', display: 'flex', flexDirection: 'column', gap: '8px' }}>
                    <div style={{ fontSize: '13px', fontWeight: '700', color: '#00F2FE' }}>🎓 VNIT Cycling Club (38 enrolled)</div>
                    <button onClick={() => setActiveTab('SCREEN_2_GROUPS')} style={{ background: 'linear-gradient(135deg, #1E293B 0%, #0F172A 100%)', color: '#FFFFFF', border: '1px solid rgba(255,255,255,0.1)', padding: '10px', borderRadius: '10px', fontSize: '11px', fontWeight: '700', cursor: 'pointer', textAlign: 'left' }}>
                      [ + Join / Exit Sub-Groups &gt; ]
                    </button>
                  </div>
                </div>
              </div>
            )}

            {/* SCREEN 2: GROUPS MANAGEMENT (MAX 3 & 1-ACTIVE TOGGLE) */}
            {activeTab === 'SCREEN_2_GROUPS' && (
              <div style={{ flex: 1, display: 'flex', flexDirection: 'column', overflowY: 'auto', padding: '16px', gap: '14px' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <h2 style={{ fontSize: '16px', fontWeight: '800', margin: 0 }}>MY SUB-GROUPS</h2>
                  <span style={{ fontSize: '11px', backgroundColor: 'rgba(0, 242, 254, 0.15)', color: '#00F2FE', border: '1px solid rgba(0, 242, 254, 0.3)', padding: '3px 10px', borderRadius: '8px', fontWeight: '800' }}>
                    2 / 3 ENROLLED
                  </span>
                </div>
                <p style={{ fontSize: '11px', color: '#94A3B8', margin: 0 }}>
                  Select which group is <strong>ACTIVE</strong> for today's live muster, telemetry, and SOS routing:
                </p>

                {/* Sub-Group 1 */}
                <div style={{
                  background: activeGroupId === 'vnit-club' ? 'linear-gradient(135deg, rgba(0, 242, 254, 0.08) 0%, rgba(19, 27, 46, 0.95) 100%)' : '#131B2E',
                  borderRadius: '20px',
                  border: activeGroupId === 'vnit-club' ? '1.5px solid #00F2FE' : '1px solid rgba(255, 255, 255, 0.08)',
                  padding: '14px',
                  boxShadow: activeGroupId === 'vnit-club' ? '0 0 20px rgba(0, 242, 254, 0.15)' : 'none'
                }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <span style={{
                      fontSize: '10px',
                      fontWeight: '800',
                      padding: '3px 8px',
                      borderRadius: '6px',
                      backgroundColor: activeGroupId === 'vnit-club' ? '#00E676' : '#475569',
                      color: '#060911'
                    }}>
                      {activeGroupId === 'vnit-club' ? '● CURRENTLY ACTIVE' : '○ INACTIVE'}
                    </span>
                    <span style={{ fontSize: '10px', color: '#64748B', fontWeight: '700' }}>COLLEGE UNION</span>
                  </div>

                  <h3 style={{ fontSize: '15px', fontWeight: '800', margin: '8px 0 2px 0', color: '#FFFFFF' }}>
                    🎓 VNIT Cycling Club
                  </h3>
                  <p style={{ fontSize: '11px', color: '#94A3B8', margin: 0 }}>38 Members • Muster: Ambazari Gate</p>
                  <p style={{ fontSize: '10px', color: '#00F2FE', margin: '4px 0 0 0', fontWeight: '600' }}>
                    ℹ️ SOS will route to: Rajesh Sharma (Leader)
                  </p>

                  <div style={{ marginTop: '12px' }}>
                    {activeGroupId === 'vnit-club' ? (
                      <div style={{ width: '100%', backgroundColor: 'rgba(0, 230, 118, 0.1)', color: '#00E676', border: '1px solid rgba(0, 230, 118, 0.3)', borderRadius: '10px', padding: '9px', fontSize: '11px', fontWeight: '800', textAlign: 'center' }}>
                        ✓ ACTIVE FOR TODAY'S RALLY
                      </div>
                    ) : (
                      <button onClick={() => { setActiveGroupId('vnit-club'); showToast('Switched Active Group to VNIT Club'); }} style={{ width: '100%', background: 'linear-gradient(135deg, #00F2FE 0%, #4FACFE 100%)', color: '#060911', border: 'none', borderRadius: '10px', padding: '9px', fontSize: '11px', fontWeight: '800', cursor: 'pointer' }}>
                        👉 Set as Active Group
                      </button>
                    )}
                  </div>
                </div>

                {/* Sub-Group 2 */}
                <div style={{
                  background: activeGroupId === 'orange-sprinters' ? 'linear-gradient(135deg, rgba(0, 242, 254, 0.08) 0%, rgba(19, 27, 46, 0.95) 100%)' : '#131B2E',
                  borderRadius: '20px',
                  border: activeGroupId === 'orange-sprinters' ? '1.5px solid #00F2FE' : '1px solid rgba(255, 255, 255, 0.08)',
                  padding: '14px',
                  boxShadow: activeGroupId === 'orange-sprinters' ? '0 0 20px rgba(0, 242, 254, 0.15)' : 'none'
                }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <span style={{
                      fontSize: '10px',
                      fontWeight: '800',
                      padding: '3px 8px',
                      borderRadius: '6px',
                      backgroundColor: activeGroupId === 'orange-sprinters' ? '#00E676' : '#475569',
                      color: '#060911'
                    }}>
                      {activeGroupId === 'orange-sprinters' ? '● CURRENTLY ACTIVE' : '○ INACTIVE'}
                    </span>
                    <span style={{ fontSize: '10px', color: '#64748B', fontWeight: '700' }}>SPORTS CLUB</span>
                  </div>

                  <h3 style={{ fontSize: '15px', fontWeight: '800', margin: '8px 0 2px 0', color: '#FFFFFF' }}>
                    ⚡ Orange City Sprinters
                  </h3>
                  <p style={{ fontSize: '11px', color: '#94A3B8', margin: 0 }}>Leader: Neha Verma • 28 Members</p>
                  <p style={{ fontSize: '10px', color: '#94A3B8', margin: '4px 0 0 0' }}>Muster: Law College Ground</p>

                  <div style={{ marginTop: '12px' }}>
                    {activeGroupId === 'orange-sprinters' ? (
                      <div style={{ width: '100%', backgroundColor: 'rgba(0, 230, 118, 0.1)', color: '#00E676', border: '1px solid rgba(0, 230, 118, 0.3)', borderRadius: '10px', padding: '9px', fontSize: '11px', fontWeight: '800', textAlign: 'center' }}>
                        ✓ ACTIVE FOR TODAY'S RALLY
                      </div>
                    ) : (
                      <button onClick={() => { setActiveGroupId('orange-sprinters'); showToast('Switched Active Group to Orange City Sprinters'); }} style={{ width: '100%', background: 'linear-gradient(135deg, #00F2FE 0%, #4FACFE 100%)', color: '#060911', border: 'none', borderRadius: '10px', padding: '9px', fontSize: '11px', fontWeight: '800', cursor: 'pointer' }}>
                        👉 Set as Active Group
                      </button>
                    )}
                  </div>
                </div>

                {/* 3rd Slot Available */}
                <button
                  onClick={() => setActiveTab('SCREEN_4_REQUEST')}
                  style={{
                    backgroundColor: 'transparent',
                    border: '2px dashed rgba(0, 242, 254, 0.4)',
                    borderRadius: '20px',
                    padding: '16px',
                    color: '#00F2FE',
                    fontSize: '12px',
                    fontWeight: '800',
                    cursor: 'pointer',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    gap: '8px'
                  }}
                >
                  <Plus size={16} /> [ + Join or Request 3rd Sub-Group ]
                </button>
              </div>
            )}

            {/* SCREEN 4: NEW GROUP APPLICATION (8 ORG CATEGORIES) */}
            {activeTab === 'SCREEN_4_REQUEST' && (
              <div style={{ flex: 1, display: 'flex', flexDirection: 'column', overflowY: 'auto', padding: '16px', gap: '12px' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                  <button onClick={() => setActiveTab('SCREEN_2_GROUPS')} style={{ background: 'none', border: 'none', color: '#00F2FE', fontSize: '14px', cursor: 'pointer', fontWeight: 'bold' }}>[&lt;]</button>
                  <h2 style={{ fontSize: '16px', fontWeight: '800', margin: 0 }}>NEW GROUP APPLICATION</h2>
                </div>
                <p style={{ fontSize: '11px', color: '#94A3B8', margin: 0 }}>
                  Fill details for your contingent. Submitted for SuperAdmin approval:
                </p>

                <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                  <div>
                    <label style={{ fontSize: '11px', color: '#94A3B8', fontWeight: '600' }}>1. Group / Team Name:</label>
                    <input defaultValue="Nagpur Citizen Front" style={{ width: '100%', backgroundColor: '#131B2E', border: '1px solid rgba(255,255,255,0.1)', borderRadius: '10px', padding: '9px 12px', color: '#FFFFFF', fontSize: '12px', marginTop: '4px', boxSizing: 'border-box' }} />
                  </div>

                  <div>
                    <label style={{ fontSize: '11px', color: '#94A3B8', fontWeight: '600' }}>2. Organization Category (8 Orgs Dropdown):</label>
                    <select style={{ width: '100%', backgroundColor: '#131B2E', border: '1.5px solid rgba(0,242,254,0.4)', borderRadius: '10px', padding: '9px 12px', color: '#00F2FE', fontSize: '12px', marginTop: '4px', boxSizing: 'border-box', fontWeight: '700' }}>
                      <option>NGO / Civil Society Org</option>
                      <option>Labor Union / Trade Association</option>
                      <option>College / University Student Union</option>
                      <option>School Contingent</option>
                      <option>Corporate / Workplace Team</option>
                      <option>Resident Welfare Association (RWA)</option>
                      <option>Sports / Athletic Club</option>
                      <option>Grassroots / Independent Collective</option>
                    </select>
                  </div>

                  <div>
                    <label style={{ fontSize: '11px', color: '#94A3B8', fontWeight: '600' }}>3. Estimated Contingent Size:</label>
                    <input defaultValue="50 - 100 participants" style={{ width: '100%', backgroundColor: '#131B2E', border: '1px solid rgba(255,255,255,0.1)', borderRadius: '10px', padding: '9px 12px', color: '#FFFFFF', fontSize: '12px', marginTop: '4px', boxSizing: 'border-box' }} />
                  </div>

                  <div>
                    <label style={{ fontSize: '11px', color: '#94A3B8', fontWeight: '600' }}>4. Proposed Assembly / Muster Point:</label>
                    <input defaultValue="Samvidhan Square, Nagpur" style={{ width: '100%', backgroundColor: '#131B2E', border: '1px solid rgba(255,255,255,0.1)', borderRadius: '10px', padding: '9px 12px', color: '#FFFFFF', fontSize: '12px', marginTop: '4px', boxSizing: 'border-box' }} />
                  </div>

                  <div>
                    <label style={{ fontSize: '11px', color: '#94A3B8', fontWeight: '600' }}>5. Leader Contact & Purpose Notes:</label>
                    <textarea defaultValue="Peaceful civic awareness contingent with 60 registered participants." rows={2} style={{ width: '100%', backgroundColor: '#131B2E', border: '1px solid rgba(255,255,255,0.1)', borderRadius: '10px', padding: '9px 12px', color: '#FFFFFF', fontSize: '12px', marginTop: '4px', boxSizing: 'border-box' }} />
                  </div>
                </div>

                <div style={{ backgroundColor: 'rgba(0, 242, 254, 0.08)', padding: '10px', borderRadius: '10px', border: '1px solid rgba(0, 242, 254, 0.2)', fontSize: '10px', color: '#00F2FE' }}>
                  ℹ️ Reviewed by Domain SuperAdmins. On approval, you will be appointed as Group Leader.
                </div>

                <button
                  onClick={() => { showToast('Application submitted to SuperAdmins for review!'); setActiveTab('SCREEN_2_GROUPS'); }}
                  style={{ background: 'linear-gradient(135deg, #00F2FE 0%, #4FACFE 100%)', color: '#060911', border: 'none', borderRadius: '12px', padding: '13px', fontSize: '12px', fontWeight: '800', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '6px', marginTop: '4px' }}
                >
                  🚀 SUBMIT APPLICATION FOR APPROVAL
                </button>
              </div>
            )}

            {/* PROFILE & QR RALLY PASS SCREEN */}
            {activeTab === 'PROFILE_QR' && (
              <div style={{ flex: 1, display: 'flex', flexDirection: 'column', overflowY: 'auto', padding: '16px', gap: '14px' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <h2 style={{ fontSize: '16px', fontWeight: '800', margin: 0 }}>PARTICIPANT PROFILE</h2>
                  <button onClick={() => setShowShareModal(true)} style={{ backgroundColor: 'rgba(0, 242, 254, 0.1)', color: '#00F2FE', border: '1px solid rgba(0,242,254,0.3)', padding: '6px 12px', borderRadius: '10px', fontSize: '11px', fontWeight: '700', display: 'flex', alignItems: 'center', gap: '4px', cursor: 'pointer' }}>
                    <Share2 size={12} /> Share Pass
                  </button>
                </div>

                <div style={{ background: 'linear-gradient(135deg, rgba(19, 27, 46, 0.95) 0%, rgba(13, 20, 36, 0.95) 100%)', borderRadius: '20px', border: '1px solid rgba(255, 255, 255, 0.08)', padding: '14px', display: 'flex', alignItems: 'center', gap: '12px' }}>
                  <div style={{ width: '50px', height: '50px', borderRadius: '50%', background: 'linear-gradient(135deg, #00F2FE 0%, #4FACFE 100%)', color: '#060911', fontWeight: '800', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '18px' }}>
                    RS
                  </div>
                  <div>
                    <h3 style={{ fontSize: '15px', fontWeight: '800', margin: 0, color: '#FFFFFF' }}>Rajesh Sharma</h3>
                    <p style={{ fontSize: '11px', color: '#94A3B8', margin: '2px 0 0 0' }}>+91 98230-12345 • Blood Group: O+</p>
                    <span style={{ fontSize: '10px', color: '#00E676', fontWeight: '800' }}>✓ Verified Participant</span>
                  </div>
                </div>

                <div style={{ background: 'linear-gradient(135deg, rgba(19, 27, 46, 0.95) 0%, rgba(13, 20, 36, 0.95) 100%)', borderRadius: '20px', border: '1px solid rgba(0, 242, 254, 0.4)', padding: '20px', display: 'flex', flexDirection: 'column', alignItems: 'center', textAlign: 'center', gap: '12px' }}>
                  <span style={{ fontSize: '11px', fontWeight: '800', color: '#00F2FE', letterSpacing: '1.5px' }}>OFFICIAL RALLY PASS</span>
                  <div style={{ width: '150px', height: '150px', backgroundColor: '#FFFFFF', borderRadius: '16px', padding: '12px', display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: '0 0 30px rgba(0, 242, 254, 0.2)' }}>
                    <div style={{ width: '100%', height: '100%', backgroundColor: '#000000', display: 'grid', gridTemplateColumns: 'repeat(5, 1fr)', gap: '4px', padding: '6px' }}>
                      {Array.from({ length: 25 }).map((_, i) => (
                        <div key={i} style={{ backgroundColor: (i % 2 === 0 || i % 3 === 0) ? '#FFFFFF' : '#000000', borderRadius: '2px' }} />
                      ))}
                    </div>
                  </div>
                  <div style={{ fontSize: '13px', fontWeight: '800', color: '#FFFFFF', fontFamily: 'monospace', letterSpacing: '1px' }}>
                    NAGPUR-2026-RS-8891
                  </div>
                  <p style={{ fontSize: '10px', color: '#94A3B8', margin: 0 }}>Scan at Muster Check-In Point and Finish Line Pavilion</p>
                </div>

                <div style={{ background: 'linear-gradient(135deg, rgba(255, 23, 68, 0.08) 0%, rgba(19, 27, 46, 0.9) 100%)', borderRadius: '16px', border: '1px solid rgba(255, 23, 68, 0.3)', padding: '12px 14px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <div>
                    <span style={{ fontSize: '10px', color: '#FF1744', fontWeight: '800' }}>EMERGENCY NEXT-OF-KIN:</span>
                    <div style={{ fontSize: '12px', color: '#FFFFFF', fontWeight: '700', marginTop: '2px' }}>Sunita Sharma (Spouse)</div>
                    <div style={{ fontSize: '11px', color: '#94A3B8' }}>+91 98221-99887</div>
                  </div>
                  <Phone size={20} color="#FF1744" />
                </div>
              </div>
            )}

            {/* Bottom Nav */}
            <div style={{
              height: '60px',
              backgroundColor: '#0D1424',
              borderTop: '1px solid rgba(255, 255, 255, 0.06)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-around',
              fontSize: '10px',
              color: '#94A3B8'
            }}>
              <div onClick={() => setActiveTab('SCREEN_1_LIVE')} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '2px', cursor: 'pointer', color: activeTab === 'SCREEN_1_LIVE' ? '#00F2FE' : '#94A3B8', fontWeight: activeTab === 'SCREEN_1_LIVE' ? '700' : '500' }}>
                <Navigation size={18} />
                <span>Home</span>
              </div>
              <div onClick={() => setActiveTab('SCREEN_2_GROUPS')} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '2px', cursor: 'pointer', color: activeTab === 'SCREEN_2_GROUPS' ? '#00F2FE' : '#94A3B8', fontWeight: activeTab === 'SCREEN_2_GROUPS' ? '700' : '500' }}>
                <Users size={18} />
                <span>Groups</span>
              </div>
              <div onClick={() => setActiveTab('PROFILE_QR')} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '2px', cursor: 'pointer', color: activeTab === 'PROFILE_QR' ? '#00F2FE' : '#94A3B8', fontWeight: activeTab === 'PROFILE_QR' ? '700' : '500' }}>
                <QrCode size={18} />
                <span>Pass</span>
              </div>
            </div>

          </div>
        ) : (
          /* PUBLIC ZERO-LOGIN SPECTATOR WEB MAP */
          <div style={{ width: '100%', maxWidth: '1100px', height: '800px', display: 'flex', flexDirection: 'column', backgroundColor: '#0D1424', borderRadius: '24px', border: '1px solid rgba(255,255,255,0.08)', overflow: 'hidden', boxShadow: '0 25px 60px rgba(0,0,0,0.8)' }}>
            <div style={{ padding: '18px 28px', backgroundColor: '#131B2E', borderBottom: '1px solid rgba(255,255,255,0.08)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <div>
                <h2 style={{ fontSize: '18px', fontWeight: '800', margin: 0, color: '#00F2FE' }}>NAGPUR PUBLIC LIVE SPECTATOR MAP</h2>
                <p style={{ fontSize: '12px', color: '#94A3B8', margin: '2px 0 0 0' }}>Zero-login civic observer & traffic route portal</p>
              </div>
              <div style={{ display: 'flex', gap: '8px' }}>
                <span style={{ fontSize: '11px', backgroundColor: 'rgba(0, 230, 118, 0.15)', color: '#00E676', border: '1px solid rgba(0, 230, 118, 0.3)', padding: '6px 14px', borderRadius: '10px', fontWeight: '800' }}>
                  ● 1,248 RIDERS ON ROUTE
                </span>
              </div>
            </div>

            <div style={{ flex: 1, position: 'relative', display: 'flex', alignItems: 'center', justifyContent: 'center', backgroundColor: '#080C17' }}>
              <div style={{ textAlign: 'center' }}>
                <Navigation size={56} color="#00F2FE" style={{ marginBottom: '14px' }} />
                <h3 style={{ margin: 0, fontSize: '22px', fontWeight: '800' }}>Zero Mile to Deekshabhoomi Corridor</h3>
                <p style={{ color: '#94A3B8', fontSize: '13px', marginTop: '4px' }}>Real-time route density and public road closure status</p>
              </div>

              {/* Commuter Alert Pill */}
              <div style={{ position: 'absolute', bottom: '24px', left: '24px', right: '24px', backgroundColor: 'rgba(19, 27, 46, 0.95)', border: '1.5px solid rgba(255, 145, 0, 0.6)', borderRadius: '14px', padding: '16px 24px', display: 'flex', alignItems: 'center', gap: '14px', backdropFilter: 'blur(20px)' }}>
                <AlertTriangle size={24} color="#FF9100" />
                <span style={{ fontSize: '13px', color: '#FFFFFF', lineHeight: '1.4' }}>
                  <strong style={{ color: '#FF9100' }}>TRAFFIC POLICE ADVISORY:</strong> Wardha Road corridor open to public. Shankar Nagar flyover experiencing 10-15m slowdowns due to rally pack.
                </span>
              </div>
            </div>
          </div>
        )}

      </div>

      {/* SOS MODAL */}
      {showSosModal && (
        <div style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.85)', backdropFilter: 'blur(10px)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100, padding: '20px' }}>
          <div style={{ width: '360px', background: 'linear-gradient(135deg, #1A121E 0%, #131B2E 100%)', borderRadius: '28px', border: '2px solid #FF1744', padding: '24px', textAlign: 'center', display: 'flex', flexDirection: 'column', gap: '16px', boxShadow: '0 0 50px rgba(255, 23, 68, 0.5)' }}>
            <div style={{ width: '60px', height: '60px', borderRadius: '50%', backgroundColor: 'rgba(255, 23, 68, 0.2)', color: '#FF1744', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto', boxShadow: '0 0 20px rgba(255, 23, 68, 0.5)' }}>
              <AlertTriangle size={32} />
            </div>

            <div>
              <h3 style={{ fontSize: '18px', fontWeight: '800', margin: 0, color: '#FF1744' }}>TRIGGER EMERGENCY SOS</h3>
              <p style={{ fontSize: '12px', color: '#94A3B8', marginTop: '6px' }}>
                Your active group is <strong>VNIT Cycling Club</strong>. Alert will route to Leader <strong>Rajesh Sharma</strong>.
              </p>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '8px', fontSize: '11px' }}>
              <button style={{ backgroundColor: '#1E293B', color: '#FFFFFF', border: '1px solid rgba(255,255,255,0.1)', padding: '10px', borderRadius: '10px', cursor: 'pointer', fontWeight: '600' }}>🚑 Medical Help</button>
              <button style={{ backgroundColor: '#1E293B', color: '#FFFFFF', border: '1px solid rgba(255,255,255,0.1)', padding: '10px', borderRadius: '10px', cursor: 'pointer', fontWeight: '600' }}>🛠️ Bike Breakdown</button>
            </div>

            <button
              onClick={() => { setShowSosModal(false); showToast('🚨 SOS Transmitted to Leader Rajesh Sharma!'); }}
              style={{ background: 'linear-gradient(135deg, #FF1744 0%, #D50000 100%)', color: '#FFFFFF', border: 'none', borderRadius: '14px', padding: '14px', fontSize: '13px', fontWeight: '800', cursor: 'pointer', boxShadow: '0 0 25px rgba(255, 23, 68, 0.6)' }}
            >
              🚨 CONFIRM & DISPATCH ALERT
            </button>

            <button onClick={() => setShowSosModal(false)} style={{ background: 'none', border: 'none', color: '#94A3B8', fontSize: '12px', cursor: 'pointer', fontWeight: '600' }}>
              Cancel
            </button>
          </div>
        </div>
      )}

      {/* SHARE MODAL */}
      {showShareModal && (
        <div style={{ position: 'fixed', inset: 0, backgroundColor: 'rgba(0,0,0,0.85)', backdropFilter: 'blur(10px)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 100, padding: '20px' }}>
          <div style={{ width: '380px', background: 'linear-gradient(135deg, #131B2E 0%, #0D1424 100%)', borderRadius: '28px', border: '1.5px solid rgba(0, 242, 254, 0.4)', padding: '24px', display: 'flex', flexDirection: 'column', gap: '14px', boxShadow: '0 0 40px rgba(0, 242, 254, 0.2)' }}>
            <h3 style={{ fontSize: '16px', fontWeight: '800', margin: 0, color: '#00F2FE' }}>SHARE ENCRYPTED LINKS</h3>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', fontSize: '11px' }}>
              <button onClick={() => { setShowShareModal(false); showToast('Copied Rally Pass Link!'); }} style={{ backgroundColor: '#1E293B', color: '#FFFFFF', border: '1px solid rgba(255,255,255,0.08)', padding: '12px', borderRadius: '10px', textAlign: 'left', cursor: 'pointer' }}>
                🎫 <strong>Live Rally Pass Link</strong><br /><span style={{ color: '#64748B', fontSize: '10px' }}>https://vikasitnagpur.in/pass/RS8891</span>
              </button>
              <button onClick={() => { setShowShareModal(false); showToast('Copied Contingent Live Map Link!'); }} style={{ backgroundColor: '#1E293B', color: '#FFFFFF', border: '1px solid rgba(255,255,255,0.08)', padding: '12px', borderRadius: '10px', textAlign: 'left', cursor: 'pointer' }}>
                👥 <strong>Contingent Live Map Link</strong><br /><span style={{ color: '#64748B', fontSize: '10px' }}>https://vikasitnagpur.in/team/vnit-cycling</span>
              </button>
              <button onClick={() => { setShowShareModal(false); showToast('Copied Public Observer Link!'); }} style={{ backgroundColor: '#1E293B', color: '#FFFFFF', border: '1px solid rgba(255,255,255,0.08)', padding: '12px', borderRadius: '10px', textAlign: 'left', cursor: 'pointer' }}>
                🌐 <strong>Public Observer Map</strong><br /><span style={{ color: '#64748B', fontSize: '10px' }}>https://vikasitnagpur.in/live/cycling-2026</span>
              </button>
            </div>
            <button onClick={() => setShowShareModal(false)} style={{ background: 'none', border: 'none', color: '#94A3B8', fontSize: '12px', cursor: 'pointer', fontWeight: '600' }}>Close</button>
          </div>
        </div>
      )}

      {/* Luxury Toast Banner */}
      {toastMsg && (
        <div style={{ position: 'fixed', bottom: '28px', right: '28px', background: 'linear-gradient(135deg, #00F2FE 0%, #4FACFE 100%)', color: '#060911', padding: '14px 24px', borderRadius: '14px', fontWeight: '800', fontSize: '13px', boxShadow: '0 10px 30px rgba(0, 242, 254, 0.5)', zIndex: 200, display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Check size={18} strokeWidth={3} />
          {toastMsg}
        </div>
      )}

    </div>
  );
}

export default App;
