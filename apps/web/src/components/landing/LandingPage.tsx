/**
 * =========================================================================
 * ZEROMILE GO - PUBLIC LANDING PAGE (LandingPage.tsx)
 * Reconstructed from Video (01:05-01:19) & Authoritative index.html
 * =========================================================================
 */

import React, { useState } from 'react';
import { NAGPUR_REGISTRY, findNagpurPlace } from '../../services/nagpurRegistry';
import { NamedLocation } from '../../types';
import { LocationSearchInput } from '../common/LocationSearchInput';

interface LandingPageProps {
  onLaunchCommuterMap: (origin?: NamedLocation, destination?: NamedLocation) => void;
  onOpenSuperAdminPortal: () => void;
  onExploreAsGuest?: () => void;
}

export const LandingPage: React.FC<LandingPageProps> = ({
  onLaunchCommuterMap,
  onOpenSuperAdminPortal,
  onExploreAsGuest
}) => {
  const [selectedOrigin, setSelectedOrigin] = useState<NamedLocation>(
    () => NAGPUR_REGISTRY.find(p => p.id === 'vnit') || NAGPUR_REGISTRY[4]
  );
  const [selectedDest, setSelectedDest] = useState<NamedLocation>(
    () => NAGPUR_REGISTRY.find(p => p.id === 'zero_mile') || NAGPUR_REGISTRY[9]
  );
  const [commuteMode, setCommuteMode] = useState('driving');

  const handleSwap = () => {
    const tempO = selectedOrigin;
    const tempD = selectedDest;
    setSelectedOrigin(tempD);
    setSelectedDest(tempO);
  };

  const handleQuickNode = (nodeId: string) => {
    const node = findNagpurPlace(nodeId) || NAGPUR_REGISTRY.find(p => p.id === nodeId);
    if (!node) return;
    setSelectedDest(node);
    onLaunchCommuterMap(selectedOrigin, node);
  };

  const handleSearchNow = () => {
    onLaunchCommuterMap(selectedOrigin, selectedDest);
  };

  return (
    <div className="landing-viewport" style={{ width: '100%', height: '100vh', overflowY: 'auto', backgroundColor: '#050811', color: '#fff' }}>
      {/* 1. Header Navbar */}
      <header className="hero-navbar" style={{ position: 'absolute', top: 0, left: 0, right: 0, zIndex: 100, display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '20px 48px', background: 'linear-gradient(to bottom, rgba(5,8,17,0.85) 0%, transparent 100%)' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '40px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px', cursor: 'pointer' }}>
            <div style={{ width: '38px', height: '38px', borderRadius: '10px', background: 'linear-gradient(135deg, #00F2FE 0%, #4FACFE 100%)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '20px', boxShadow: '0 0 16px rgba(0,242,254,0.4)' }}>
              🧭
            </div>
            <div style={{ fontSize: '22px', fontWeight: 900, letterSpacing: '-0.5px' }}>
              ZeroMile <span style={{ color: '#00F2FE' }}>Go</span>
            </div>
          </div>

          <nav style={{ display: 'flex', alignItems: 'center', gap: '28px', fontSize: '14px', fontWeight: 600, color: '#94A3B8' }}>
            <a href="#routes" onClick={(e) => { e.preventDefault(); handleSearchNow(); }} style={{ color: '#fff', textDecoration: 'none' }}>Explore Routes ▾</a>
            <a href="#corridors" onClick={(e) => { e.preventDefault(); handleSearchNow(); }} style={{ color: '#94A3B8', textDecoration: 'none' }}>Live Corridors</a>
            <a href="#bulletins" onClick={(e) => { e.preventDefault(); alert('Civic Bulletin: Active road diversions around Wardha Road for Nagpur Grand Cyclothon.'); }} style={{ color: '#94A3B8', textDecoration: 'none' }}>Civic Bulletins</a>
            <a href="#traffic" onClick={(e) => { e.preventDefault(); handleSearchNow(); }} style={{ color: '#94A3B8', textDecoration: 'none' }}>Traffic Flow</a>
          </nav>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
          <button
            onClick={() => (onExploreAsGuest ? onExploreAsGuest() : handleSearchNow())}
            style={{ padding: '10px 18px', borderRadius: '30px', background: 'rgba(0, 242, 254, 0.12)', color: '#00F2FE', border: '1px solid rgba(0, 242, 254, 0.4)', fontWeight: 800, fontSize: '13px', cursor: 'pointer', transition: 'all 0.2s', display: 'flex', alignItems: 'center', gap: '6px' }}
          >
            <span>👁️</span> Guest View (No Login)
          </button>
          <button
            onClick={() => handleSearchNow()}
            style={{ padding: '10px 20px', borderRadius: '30px', background: '#fff', color: '#050811', border: 'none', fontWeight: 700, fontSize: '13px', cursor: 'pointer', transition: 'all 0.2s', boxShadow: '0 4px 14px rgba(255,255,255,0.2)' }}
          >
            Commuter Map
          </button>
          <button
            onClick={onOpenSuperAdminPortal}
            style={{ padding: '10px 20px', borderRadius: '30px', background: 'rgba(255, 215, 0, 0.1)', color: '#FFD700', border: '1px solid rgba(255, 215, 0, 0.3)', fontWeight: 700, fontSize: '13px', cursor: 'pointer', transition: 'all 0.2s' }}
          >
            SuperAdmin Portal
          </button>
        </div>
      </header>

      {/* 2. Hero Section */}
      <section className="hero-section" style={{ position: 'relative', minHeight: '640px', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', paddingTop: '100px', paddingBottom: '60px' }}>
        {/* Background photo & overlay */}
        <div
          className="hero-backdrop"
          style={{
            position: 'absolute',
            inset: 0,
            backgroundImage: "url('/hero_banner.jpg')",
            backgroundSize: 'cover',
            backgroundPosition: 'center',
            opacity: 0.38,
            zIndex: 1
          }}
        ></div>
        <div
          className="hero-gradient-overlay"
          style={{
            position: 'absolute',
            inset: 0,
            background: 'linear-gradient(180deg, rgba(5,8,17,0.7) 0%, rgba(5,8,17,0.95) 75%, #050811 100%)',
            zIndex: 2
          }}
        ></div>

        <div className="hero-content" style={{ position: 'relative', zIndex: 10, textAlign: 'center', maxWidth: '960px', padding: '0 24px' }}>
          <h1 className="hero-headline" style={{ fontSize: '56px', fontWeight: 900, letterSpacing: '-1.5px', lineHeight: 1.15, marginBottom: '16px' }}>
            Discover Nagpur with <br />
            <span style={{ background: 'linear-gradient(135deg, #00F2FE 0%, #4FACFE 50%, #00E676 100%)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>
              ZeroMile Go
            </span>
          </h1>
          <p className="hero-subtitle" style={{ fontSize: '18px', color: '#94A3B8', maxWidth: '680px', margin: '0 auto 36px', lineHeight: 1.6 }}>
            Real-time GPS routing, automatic rally &amp; cyclothon detour engine, and 3D civic corridors.
          </p>

          {/* Dual Search Pill Container */}
          <div className="hero-search-dual-container" style={{ display: 'inline-flex', background: 'rgba(16, 24, 43, 0.88)', backdropFilter: 'blur(20px)', border: '1px solid rgba(255, 255, 255, 0.16)', borderRadius: '24px', padding: '12px 18px', boxShadow: '0 20px 50px rgba(0,0,0,0.6)', maxWidth: '920px', width: '100%' }}>
            <div style={{ display: 'flex', alignItems: 'center', width: '100%', gap: '12px', flexWrap: 'wrap' }}>
              {/* Origin Search */}
              <div style={{ flex: '1 1 280px', minWidth: '240px' }}>
                <LocationSearchInput
                  label="STARTING POINT"
                  placeholder="Search starting location in Nagpur..."
                  value={selectedOrigin}
                  onSelect={setSelectedOrigin}
                  accentColor="#00E676"
                />
              </div>

              {/* Swap Button */}
              <button
                type="button"
                onClick={handleSwap}
                style={{ width: '38px', height: '38px', borderRadius: '50%', background: 'rgba(255,255,255,0.08)', border: '1px solid rgba(255,255,255,0.12)', color: '#fff', cursor: 'pointer', fontSize: '16px', display: 'flex', alignItems: 'center', justifyContent: 'center', alignSelf: 'center', transition: 'all 0.2s' }}
                title="Swap Start and Destination"
              >
                ⇄
              </button>

              {/* Destination Search */}
              <div style={{ flex: '1 1 280px', minWidth: '240px' }}>
                <LocationSearchInput
                  label="DESTINATION"
                  placeholder="Search destination in Nagpur..."
                  value={selectedDest}
                  onSelect={setSelectedDest}
                  accentColor="#FF1744"
                />
              </div>

              {/* Action Button */}
              <button
                type="button"
                onClick={handleSearchNow}
                style={{ padding: '12px 28px', borderRadius: '12px', background: 'linear-gradient(135deg, #00C853 0%, #009624 100%)', border: 'none', color: '#fff', fontWeight: 800, fontSize: '14px', cursor: 'pointer', boxShadow: '0 4px 20px rgba(0,200,83,0.4)', transition: 'all 0.2s', whiteSpace: 'nowrap', alignSelf: 'center' }}
              >
                Search Now
              </button>
            </div>
          </div>

          {/* Official Civic Nodes Chips */}
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '10px', marginTop: '24px', flexWrap: 'wrap' }}>
            <span style={{ fontSize: '12px', color: '#64748B', fontWeight: 700 }}>Official Civic Nodes:</span>
            <button onClick={() => handleQuickNode('zeromile')} style={{ padding: '6px 14px', borderRadius: '20px', background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.12)', color: '#fff', fontSize: '12px', cursor: 'pointer' }}>🏛️ Zero Mile</button>
            <button onClick={() => handleQuickNode('vnit')} style={{ padding: '6px 14px', borderRadius: '20px', background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.12)', color: '#fff', fontSize: '12px', cursor: 'pointer' }}>🏛️ VNIT Campus</button>
            <button onClick={() => handleQuickNode('aiims')} style={{ padding: '6px 14px', borderRadius: '20px', background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.12)', color: '#fff', fontSize: '12px', cursor: 'pointer' }}>🏥 AIIMS MIHAN</button>
            <button onClick={() => handleQuickNode('futala')} style={{ padding: '6px 14px', borderRadius: '20px', background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.12)', color: '#fff', fontSize: '12px', cursor: 'pointer' }}>🌊 Futala Lake</button>
          </div>
        </div>
      </section>

      {/* 3. Perfect Commute Route Engine Section */}
      <section style={{ maxWidth: '1100px', margin: '0 auto', padding: '40px 24px 80px', textAlign: 'center' }}>
        <div style={{ display: 'inline-block', padding: '6px 16px', borderRadius: '20px', background: 'rgba(0, 242, 254, 0.1)', border: '1px solid rgba(0, 242, 254, 0.3)', color: '#00F2FE', fontSize: '11px', fontWeight: 800, letterSpacing: '0.8px', marginBottom: '14px' }}>
          ✨ ZEROMILE GO ROUTE ENGINE
        </div>
        <h2 style={{ fontSize: '36px', fontWeight: 900, letterSpacing: '-0.8px', marginBottom: '10px' }}>
          Find Your Perfect Commute &amp; Route
        </h2>
        <p style={{ fontSize: '15px', color: '#94A3B8', maxWidth: '640px', margin: '0 auto 40px' }}>
          Select your origin, destination, and vehicle mode to bypass active rally road closures and delays.
        </p>

        {/* 3 Active Event Showcase Cards */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))', gap: '24px', textAlign: 'left' }}>
          {/* Card 1: Cyclothon */}
          <div
            onClick={() => handleSearchNow()}
            style={{ borderRadius: '18px', background: '#10182b', border: '1px solid rgba(255,255,255,0.08)', overflow: 'hidden', cursor: 'pointer', transition: 'transform 0.2s', boxShadow: '0 10px 30px rgba(0,0,0,0.3)' }}
          >
            <div style={{ height: '170px', backgroundImage: "url('https://images.unsplash.com/photo-1541625602330-2277a4c46182?auto=format&fit=crop&w=700&q=80')", backgroundSize: 'cover', backgroundPosition: 'center', position: 'relative', padding: '14px', display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
              <span style={{ padding: '4px 10px', borderRadius: '14px', background: 'rgba(0,0,0,0.6)', backdropFilter: 'blur(8px)', fontSize: '11px', fontWeight: 700 }}>★ 4.9 • 6.2 km</span>
              <span style={{ padding: '4px 10px', borderRadius: '14px', background: 'rgba(0, 230, 118, 0.85)', color: '#050811', fontSize: '11px', fontWeight: 800 }}>🚴 Active Cyclothon</span>
            </div>
            <div style={{ padding: '18px' }}>
              <h3 style={{ fontSize: '18px', fontWeight: 800, marginBottom: '6px' }}>Nagpur Grand Cyclothon 2026</h3>
              <p style={{ fontSize: '13px', color: '#94A3B8', lineHeight: 1.5, marginBottom: '14px' }}>Corridor through Wardha Road &amp; South Ambazari. Rolling police diversions active.</p>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px', color: '#00F2FE', fontWeight: 700 }}>
                <span>View Route on 3D Map →</span>
                <span style={{ color: '#FFD700' }}>Live Telemetry</span>
              </div>
            </div>
          </div>

          {/* Card 2: Marathon */}
          <div
            onClick={() => handleSearchNow()}
            style={{ borderRadius: '18px', background: '#10182b', border: '1px solid rgba(255,255,255,0.08)', overflow: 'hidden', cursor: 'pointer', transition: 'transform 0.2s', boxShadow: '0 10px 30px rgba(0,0,0,0.3)' }}
          >
            <div style={{ height: '170px', backgroundImage: "url('https://images.unsplash.com/photo-1452626038306-9aae5e071dd3?auto=format&fit=crop&w=700&q=80')", backgroundSize: 'cover', backgroundPosition: 'center', position: 'relative', padding: '14px', display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
              <span style={{ padding: '4px 10px', borderRadius: '14px', background: 'rgba(0,0,0,0.6)', backdropFilter: 'blur(8px)', fontSize: '11px', fontWeight: 700 }}>★ 4.8 • 18.5 km</span>
              <span style={{ padding: '4px 10px', borderRadius: '14px', background: 'rgba(255, 145, 0, 0.85)', color: '#050811', fontSize: '11px', fontWeight: 800 }}>🏃 City Marathon</span>
            </div>
            <div style={{ padding: '18px' }}>
              <h3 style={{ fontSize: '18px', fontWeight: 800, marginBottom: '6px' }}>Nagpur City Marathon</h3>
              <p style={{ fontSize: '13px', color: '#94A3B8', lineHeight: 1.5, marginBottom: '14px' }}>Civil Lines Japanese Garden to Sitabuldi Interchange. Medical stations deployed.</p>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px', color: '#00F2FE', fontWeight: 700 }}>
                <span>View Route on 3D Map →</span>
                <span style={{ color: '#94A3B8' }}>Upcoming</span>
              </div>
            </div>
          </div>

          {/* Card 3: Civic Procession */}
          <div
            onClick={() => handleSearchNow()}
            style={{ borderRadius: '18px', background: '#10182b', border: '1px solid rgba(255,255,255,0.08)', overflow: 'hidden', cursor: 'pointer', transition: 'transform 0.2s', boxShadow: '0 10px 30px rgba(0,0,0,0.3)' }}
          >
            <div style={{ height: '170px', backgroundImage: "url('/civic_procession.jpg')", backgroundSize: 'cover', backgroundPosition: 'center', position: 'relative', padding: '14px', display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
              <span style={{ padding: '4px 10px', borderRadius: '14px', background: 'rgba(0,0,0,0.6)', backdropFilter: 'blur(8px)', fontSize: '11px', fontWeight: 700 }}>★ 5.0 • 12.0 km</span>
              <span style={{ padding: '4px 10px', borderRadius: '14px', background: 'rgba(41, 121, 255, 0.85)', color: '#fff', fontSize: '11px', fontWeight: 800 }}>🚩 Civic Procession</span>
            </div>
            <div style={{ padding: '18px' }}>
              <h3 style={{ fontSize: '18px', fontWeight: 800, marginBottom: '6px' }}>Citizen Procession &amp; Walkathon</h3>
              <p style={{ fontSize: '13px', color: '#94A3B8', lineHeight: 1.5, marginBottom: '14px' }}>Deekshabhoomi to Ambazari Lake park. Dedicated green pedestrian corridor.</p>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px', color: '#00F2FE', fontWeight: 700 }}>
                <span>View Route on 3D Map →</span>
                <span style={{ color: '#00E676' }}>Clear Flow</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* 4. Footer */}
      <footer style={{ borderTop: '1px solid rgba(255,255,255,0.08)', padding: '36px 48px', display: 'flex', justifyContent: 'space-between', alignItems: 'center', fontSize: '12px', color: '#64748B', flexWrap: 'wrap', gap: '16px' }}>
        <div>© 2026 ZeroMile Go Smart Mobility Platform • Powered by Mapbox 3D Engine &amp; Municipal Telemetry</div>
        <div style={{ display: 'flex', gap: '24px' }}>
          <a href="#admin" onClick={(e) => { e.preventDefault(); onOpenSuperAdminPortal(); }} style={{ color: '#94A3B8', textDecoration: 'none' }}>SuperAdmin Login</a>
          <a href="#map" onClick={(e) => { e.preventDefault(); handleSearchNow(); }} style={{ color: '#94A3B8', textDecoration: 'none' }}>ZeroMile Go 3D Live Map</a>
          <a href="#bulletin" onClick={(e) => { e.preventDefault(); alert('Municipal Bulletin: All routes monitored 24/7.'); }} style={{ color: '#94A3B8', textDecoration: 'none' }}>Civic Bulletins</a>
        </div>
      </footer>
    </div>
  );
};
