/**
 * =========================================================================
 * ZEROMILE GO - MASTER APPLICATION ORCHESTRATOR (App.tsx)
 * Modern React + TypeScript + Vite • Full Video-Guided Feature Restoration
 * =========================================================================
 */

import React, { useState, useRef, useEffect, useCallback } from 'react';
import mapboxgl from 'mapbox-gl';
import { useMapbox, LightPreset } from './features/map/useMapbox';
import { LandingPage } from './components/landing/LandingPage';
import { GatewayLoginModal } from './features/auth/GatewayLoginModal';
import { RouteStudioPanel } from './features/routes/RouteStudioPanel';
import { CommuterRoutePanel } from './features/transit/CommuterRoutePanel';
import { EventConflictCard } from './features/transit/EventConflictCard';
import { NavigationHud } from './features/transit/NavigationHud';
import { MapLightingToolbar } from './features/map/MapLightingToolbar';
import { TrafficLegend } from './features/map/TrafficLegend';
import { FollowCamHud } from './features/map/FollowCamHud';
import { CivicBroadcastBanner } from './features/emergency/CivicBroadcastBanner';
import { BroadcastAlertModal } from './features/emergency/BroadcastAlertModal';
import { AddCheckpointModal } from './features/checkpoints/AddCheckpointModal';
import { useDomain } from './context/DomainContext';
import { useAuth } from './context/AuthContext';
import { useRouteHistory } from './features/routes/hooks/useRouteHistory';
import { fetchSmartRoute } from './services/directionsService';
import { fetchRouteCheckpoints, fetchDomainSosEvents, fetchDomainBroadcasts, upsertRouteCheckpoint } from './services/supabaseClient';
import { NamedLocation, RouteStats, RouteCheckpoint, SosEvent, BroadcastMessage } from './types';
import { NAGPUR_REGISTRY } from './services/nagpurRegistry';

export function App() {
  const mapContainerRef = useRef<HTMLDivElement>(null);
  const { currentDomain } = useDomain();
  const { role, phone, isAuthenticatedAdmin, isGuestMode, openLoginModal, enableGuestMode, logout } = useAuth();

  // Top-Level View State: 'LANDING' | 'MAP'
  const [currentView, setCurrentView] = useState<'LANDING' | 'MAP'>('LANDING');

  // Commuter vs SuperAdmin active studio mode on Map view
  const [studioMode, setStudioMode] = useState<'COMMUTER' | 'SUPERADMIN'>('COMMUTER');

  const handleExploreAsGuest = () => {
    enableGuestMode();
    setStudioMode('SUPERADMIN');
    setCurrentView('MAP');
  };

  // Modals & Banners State
  const [isBroadcastModalOpen, setIsBroadcastModalOpen] = useState(false);
  const [isAddCheckpointModalOpen, setIsAddCheckpointModalOpen] = useState(false);
  const [pendingCheckpointData, setPendingCheckpointData] = useState<{ type: string; name: string; notes: string } | null>(null);
  const [activeBroadcastBanner, setActiveBroadcastBanner] = useState<{ domainTitle: string; corridor: string; text: string } | null>(null);

  // Commuter Conflict & Turn-by-Turn Navigation State
  const [isConflictCardVisible, setIsConflictCardVisible] = useState(true);
  const [isNavigating, setIsNavigating] = useState(false);

  // SuperAdmin Editing Modes
  const [isAdjustingWaypoints, setIsAdjustingWaypoints] = useState(false);
  const [isBarricadeModeActive, setIsBarricadeModeActive] = useState(false);
  const [isLiveMotionActive, setIsLiveMotionActive] = useState(true);
  const [isFollowCamActive, setIsFollowCamActive] = useState(false);

  // Live Database State
  const [checkpoints, setCheckpoints] = useState<RouteCheckpoint[]>([]);
  const [sosEvents, setSosEvents] = useState<SosEvent[]>([]);
  const [broadcasts, setBroadcasts] = useState<BroadcastMessage[]>([]);
  const [barricades, setBarricades] = useState<[number, number][]>([]);

  // Route State via History Hook
  const {
    currentSnapshot,
    pushState,
    undo,
    redo,
    canUndo,
    canRedo
  } = useRouteHistory({
    origin: currentDomain.primaryStart,
    destination: currentDomain.primaryFinish,
    waypoints: currentDomain.defaultWaypoints
  });

  const [activeRouteCoords, setActiveRouteCoords] = useState<[number, number][]>([]);
  const [routeStats, setRouteStats] = useState<RouteStats>({
    distanceKm: currentDomain.estimatedDistanceKm,
    durationMin: currentDomain.estimatedDurationMin,
    turnPointsCount: 14,
    climbMeters: 45
  });

  // Track map marker elements
  const customMarkersRef = useRef<mapboxgl.Marker[]>([]);
  const pelotonAnimationRef = useRef<number | null>(null);

  // Map Click Handler for Barricades and Checkpoints
  const handleMapClick = useCallback((e: mapboxgl.MapMouseEvent) => {
    const lngLat = e.lngLat;

    // Checkpoint Placement Mode
    if (pendingCheckpointData) {
      const newCp: RouteCheckpoint = {
        id: `cp-${Date.now()}`,
        domainId: currentDomain.id,
        checkpointType: pendingCheckpointData.type.toUpperCase() as any,
        name: pendingCheckpointData.name,
        latitude: lngLat.lat,
        longitude: lngLat.lng,
        sequenceOrder: checkpoints.length + 1
      };
      setCheckpoints(prev => [...prev, newCp]);
      upsertRouteCheckpoint(newCp);
      setPendingCheckpointData(null);
      return;
    }

    // Barricade Placement Mode
    if (isBarricadeModeActive) {
      setBarricades(prev => [...prev, [lngLat.lng, lngLat.lat]]);
      // Dynamically add a via waypoint to calculate detour
      pushState({
        ...currentSnapshot,
        waypoints: [...currentSnapshot.waypoints, { name: 'Detour Waypoint', lat: lngLat.lat + 0.004, lng: lngLat.lng + 0.004 }]
      });
      return;
    }

    // Polyline Waypoint Adjustment Click
    if (isAdjustingWaypoints) {
      pushState({
        ...currentSnapshot,
        waypoints: [...currentSnapshot.waypoints, { name: 'Custom Waypoint', lat: lngLat.lat, lng: lngLat.lng }]
      });
    }
  }, [checkpoints.length, currentDomain.id, currentSnapshot, isAdjustingWaypoints, isBarricadeModeActive, pendingCheckpointData, pushState]);

  // Initialize Mapbox Hook
  const {
    map,
    isLoaded,
    currentLightPreset,
    is3DTiltActive,
    isOrbiting,
    setLightPreset,
    setRouteCoordinates,
    fitToCoordinates,
    toggle3DTilt,
    resetNorth,
    toggleOrbit,
    centerOnUserLocation,
    resize
  } = useMapbox({
    containerRef: mapContainerRef,
    initialCenter: currentDomain.primaryStart,
    initialZoom: 13.8,
    initialPitch: 50,
    initialLightPreset: 'day',
    onMapClick: handleMapClick
  });

  // Calculate & Render Route Corridor
  const updateRoute = useCallback(async (origin: NamedLocation, dest: NamedLocation, wps: NamedLocation[]) => {
    const result = await fetchSmartRoute(origin, dest, wps, 'cycling');
    if (result) {
      setActiveRouteCoords(result.coordinates);
      setRouteCoordinates(result.coordinates);
      setRouteStats({
        distanceKm: result.distanceMeters / 1000,
        durationMin: Math.round(result.durationSeconds / 60),
        turnPointsCount: result.coordinates.length,
        climbMeters: 45
      });
      fitToCoordinates(result.coordinates);
    }
  }, [fitToCoordinates, setRouteCoordinates]);

  // Recalculate route on snapshot change
  useEffect(() => {
    if (isLoaded) {
      updateRoute(currentSnapshot.origin, currentSnapshot.destination, currentSnapshot.waypoints);
    }
  }, [currentSnapshot, isLoaded, updateRoute]);

  // Resize and refit map whenever switching from LANDING to MAP view
  useEffect(() => {
    if (currentView === 'MAP' && map) {
      setTimeout(() => {
        resize();
        if (activeRouteCoords.length > 0) {
          fitToCoordinates(activeRouteCoords);
        }
      }, 150);
    }
  }, [activeRouteCoords, currentView, fitToCoordinates, map, resize]);

  // Fetch Database Data for current domain
  const refreshDatabaseData = useCallback(async () => {
    try {
      const [cps, sos, bcs] = await Promise.all([
        fetchRouteCheckpoints(currentDomain.id),
        fetchDomainSosEvents(currentDomain.id),
        fetchDomainBroadcasts(currentDomain.id)
      ]);
      if (cps && cps.length > 0) setCheckpoints(cps);
      if (sos) setSosEvents(sos);
      if (bcs) setBroadcasts(bcs);
    } catch (err) {
      console.warn('Database query notice:', err);
    }
  }, [currentDomain.id]);

  useEffect(() => {
    refreshDatabaseData();
  }, [refreshDatabaseData]);

  // Switch to SuperAdmin Studio when user successfully logs in
  useEffect(() => {
    if (isAuthenticatedAdmin) {
      setStudioMode('SUPERADMIN');
      setCurrentView('MAP');
    }
  }, [isAuthenticatedAdmin]);

  // Render Checkpoints, Barricades & Peloton Stream on Map
  useEffect(() => {
    if (!map || !isLoaded) return;

    // Clear existing markers
    customMarkersRef.current.forEach(m => m.remove());
    customMarkersRef.current = [];

    // 0. Render Origin & Destination Markers (Selected via Location Search)
    if (currentSnapshot.origin) {
      const el = document.createElement('div');
      el.innerHTML = `
        <div style="display: flex; flex-direction: column; align-items: center; cursor: pointer;">
          <div style="width: 28px; height: 28px; border-radius: 50%; background: #00E676; border: 2px solid #fff; display: flex; align-items: center; justify-content: center; font-size: 14px; box-shadow: 0 4px 14px rgba(0,230,118,0.5);">
            🟢
          </div>
          <div style="padding: 2px 8px; border-radius: 6px; background: rgba(5,8,17,0.9); border: 1px solid #00E676; color: #00E676; font-size: 10px; font-weight: 800; margin-top: 2px; white-space: nowrap; max-width: 140px; overflow: hidden; text-overflow: ellipsis;">
            ${currentSnapshot.origin.name}
          </div>
        </div>
      `;
      const originMarker = new mapboxgl.Marker({ element: el })
        .setLngLat([currentSnapshot.origin.lng, currentSnapshot.origin.lat])
        .addTo(map);
      customMarkersRef.current.push(originMarker);
    }

    if (currentSnapshot.destination) {
      const el = document.createElement('div');
      el.innerHTML = `
        <div style="display: flex; flex-direction: column; align-items: center; cursor: pointer;">
          <div style="width: 28px; height: 28px; border-radius: 50%; background: #FF1744; border: 2px solid #fff; display: flex; align-items: center; justify-content: center; font-size: 14px; box-shadow: 0 4px 14px rgba(255,23,68,0.5);">
            🏁
          </div>
          <div style="padding: 2px 8px; border-radius: 6px; background: rgba(5,8,17,0.9); border: 1px solid #FF1744; color: #FF1744; font-size: 10px; font-weight: 800; margin-top: 2px; white-space: nowrap; max-width: 140px; overflow: hidden; text-overflow: ellipsis;">
            ${currentSnapshot.destination.name}
          </div>
        </div>
      `;
      const destMarker = new mapboxgl.Marker({ element: el })
        .setLngLat([currentSnapshot.destination.lng, currentSnapshot.destination.lat])
        .addTo(map);
      customMarkersRef.current.push(destMarker);
    }

    // 1. Render Checkpoints
    checkpoints.forEach((cp) => {
      const el = document.createElement('div');
      el.className = 'custom-checkpoint-pin';
      let icon = '📍';
      let bg = '#00F2FE';

      if (cp.checkpointType === 'WATER_STATION' || (cp as any).checkpointType === 'HYDRATION') {
        icon = '💧';
        bg = '#00F2FE';
      } else if (cp.checkpointType === 'MEDICAL_POST' || (cp as any).checkpointType === 'MEDICAL') {
        icon = '🏥';
        bg = '#FF1744';
      } else if (cp.checkpointType === 'START' || (cp as any).checkpointType === 'FLAGOFF') {
        icon = '🚩';
        bg = '#00E676';
      } else if (cp.checkpointType === 'FINISH') {
        icon = '🏁';
        bg = '#FFD700';
      } else {
        icon = '⏱️';
        bg = '#FF9100';
      }

      el.innerHTML = `
        <div style="width: 32px; height: 32px; border-radius: 50%; background: ${bg}; display: flex; align-items: center; justify-content: center; font-size: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.5); border: 2px solid #fff;">
          ${icon}
        </div>
      `;

      const marker = new mapboxgl.Marker({ element: el })
        .setLngLat([cp.longitude, cp.latitude])
        .setPopup(new mapboxgl.Popup({ offset: 25 }).setHTML(`<b>${cp.name}</b>`))
        .addTo(map);

      customMarkersRef.current.push(marker);
    });

    // 2. Render Barricades (Hazard markers)
    barricades.forEach((coord) => {
      const el = document.createElement('div');
      el.innerHTML = `
        <div style="width: 32px; height: 32px; border-radius: 6px; background: repeating-linear-gradient(45deg, #FFD700, #FFD700 6px, #000 6px, #000 12px); border: 2px solid #fff; box-shadow: 0 4px 12px rgba(0,0,0,0.6); display: flex; align-items: center; justify-content: center; font-size: 14px;">
          🚧
        </div>
      `;
      const marker = new mapboxgl.Marker({ element: el })
        .setLngLat(coord)
        .addTo(map);
      customMarkersRef.current.push(marker);
    });

    // 3. Render Simulated Peloton / Live Motion stream along route
    if (isLiveMotionActive && activeRouteCoords.length > 5) {
      const pelotonCount = 5;
      const speeds = [24.5, 23.9, 27.8, 18.0, 34.0];

      for (let i = 0; i < pelotonCount; i++) {
        const stepIdx = Math.floor((activeRouteCoords.length / (pelotonCount + 1)) * (i + 1));
        const coord = activeRouteCoords[stepIdx] || activeRouteCoords[0];
        const isAlert = i === 2;

        const el = document.createElement('div');
        el.innerHTML = `
          <div style="display: flex; flex-direction: column; align-items: center; cursor: pointer;">
            <div style="width: 24px; height: 24px; border-radius: 50%; background: ${isAlert ? '#FF1744' : '#00F2FE'}; border: 2px solid #fff; display: flex; align-items: center; justify-content: center; font-size: 12px; box-shadow: 0 0 10px ${isAlert ? '#FF1744' : '#00F2FE'};">
              🚴
            </div>
            <div style="padding: 2px 6px; border-radius: 8px; background: rgba(10,15,29,0.9); border: 1px solid ${isAlert ? '#FF1744' : 'rgba(255,255,255,0.2)'}; color: ${isAlert ? '#FF1744' : '#fff'}; font-size: 9px; font-weight: 800; margin-top: 2px;">
              ${isAlert ? 'ALERT' : `${speeds[i]} km/h`}
            </div>
          </div>
        `;

        el.addEventListener('click', () => {
          setIsFollowCamActive(true);
          map.flyTo({ center: coord, zoom: 16, pitch: 55, duration: 1000 });
        });

        const marker = new mapboxgl.Marker({ element: el })
          .setLngLat(coord)
          .addTo(map);

        customMarkersRef.current.push(marker);
      }
    }
  }, [activeRouteCoords, barricades, checkpoints, currentSnapshot.destination, currentSnapshot.origin, isLoaded, isLiveMotionActive, map]);

  // Handle Switch to Bypass Corridor from Event Conflict Card
  const handleSwitchToBypass = () => {
    setIsConflictCardVisible(false);
    // Set bypass via Ambazari & North Ambazari Road
    pushState({
      origin: currentSnapshot.origin,
      destination: currentSnapshot.destination,
      waypoints: [
        { name: 'Ambazari Lake Bypass', lat: 21.1320, lng: 79.0510 },
        { name: 'Civil Lines Outer Ring', lat: 21.1560, lng: 79.0680 }
      ]
    });
  };

  // Launch from Landing Page
  const handleLaunchFromLanding = (o?: NamedLocation, d?: NamedLocation) => {
    if (o && d) {
      pushState({
        origin: o,
        destination: d,
        waypoints: []
      });
    }
    setCurrentView('MAP');
    setStudioMode('COMMUTER');
  };

  return (
    <div style={{ position: 'relative', width: '100%', height: '100vh', overflow: 'hidden', backgroundColor: '#050811' }}>
      {/* 1. PERSISTENT MAPBOX 3D WEBGL CANVAS (Always mounted to initialize immediately) */}
      <div
        ref={mapContainerRef}
        id="map"
        style={{
          position: 'absolute',
          inset: 0,
          width: '100%',
          height: '100%',
          zIndex: 0
        }}
      />

      {/* 2. VIEW A: PUBLIC LANDING PAGE (Overlay at zIndex 50) */}
      {currentView === 'LANDING' && (
        <div
          style={{
            position: 'absolute',
            inset: 0,
            width: '100%',
            height: '100%',
            zIndex: 50,
            overflowY: 'auto',
            backgroundColor: '#050811'
          }}
        >
          <LandingPage
            onLaunchCommuterMap={handleLaunchFromLanding}
            onOpenSuperAdminPortal={() => openLoginModal()}
            onExploreAsGuest={handleExploreAsGuest}
          />
        </div>
      )}

      {/* 3. VIEW B: 3D INTERACTIVE MAP CONTROLS & HUD (Visible when currentView === 'MAP') */}
      {currentView === 'MAP' && (
        <>
          {/* Top-Right Map Lighting & Camera Toolbar */}
          <MapLightingToolbar
            currentLightPreset={currentLightPreset}
            onSelectLightPreset={setLightPreset}
            onLocateMe={centerOnUserLocation}
            isRadarActive={isLiveMotionActive}
            onToggleRadar={() => setIsLiveMotionActive(prev => !prev)}
            is3DTiltActive={is3DTiltActive}
            onToggle3DTilt={toggle3DTilt}
            isOrbiting={isOrbiting}
            onToggleOrbit={toggleOrbit}
          />

          {/* Top-Center Civic Emergency Alert Banner */}
          <CivicBroadcastBanner
            bannerData={activeBroadcastBanner}
            onDismiss={() => setActiveBroadcastBanner(null)}
          />

          {/* Follow-Cam HUD */}
          <FollowCamHud
            isFollowing={isFollowCamActive}
            onReleaseCamera={() => {
              setIsFollowCamActive(false);
              resetNorth();
            }}
          />

          {/* Floating Left Studio Panel (Commuter vs SuperAdmin) */}
          <div style={{ position: 'absolute', top: '16px', left: '16px', zIndex: 40, maxHeight: 'calc(100vh - 32px)', display: 'flex', flexDirection: 'column' }}>
            {studioMode === 'COMMUTER' ? (
              <CommuterRoutePanel
                origin={currentSnapshot.origin}
                destination={currentSnapshot.destination}
                onOriginChange={loc => pushState({ ...currentSnapshot, origin: loc })}
                onDestinationChange={loc => pushState({ ...currentSnapshot, destination: loc })}
                onSelectRoute={coords => {
                  setRouteCoordinates(coords);
                  fitToCoordinates(coords);
                }}
                onReturnToLanding={() => setCurrentView('LANDING')}
                onOpenSuperAdminPortal={() => openLoginModal()}
                onSwitchToStudio={() => setStudioMode('SUPERADMIN')}
              />
            ) : (
              <RouteStudioPanel
                domainId={currentDomain.id}
                domainTitle={currentDomain.title}
                adminPhone={phone || '9823012345'}
                origin={currentSnapshot.origin}
                destination={currentSnapshot.destination}
                waypoints={currentSnapshot.waypoints}
                routeStats={routeStats}
                checkpointsCount={checkpoints.length}
                canUndo={canUndo}
                canRedo={canRedo}
                onUndo={undo}
                onRedo={redo}
                onNorthAlign={resetNorth}
                onReturnToLanding={() => setCurrentView('LANDING')}
                onLogout={() => {
                  logout();
                  setStudioMode('COMMUTER');
                }}
                onEndpointsChange={(o, d) => pushState({ ...currentSnapshot, origin: o, destination: d })}
                isLiveMotionActive={isLiveMotionActive}
                onToggleLiveMotion={() => setIsLiveMotionActive(prev => !prev)}
                isAdjustingWaypoints={isAdjustingWaypoints}
                onToggleAdjustWaypoints={() => setIsAdjustingWaypoints(prev => !prev)}
                isBarricadeModeActive={isBarricadeModeActive}
                onToggleBarricadeMode={() => setIsBarricadeModeActive(prev => !prev)}
                onOpenAddCheckpoint={() => setIsAddCheckpointModalOpen(true)}
                onOpenBroadcastModal={() => setIsBroadcastModalOpen(true)}
                broadcasts={broadcasts}
                sosEvents={sosEvents}
                onRefreshData={refreshDatabaseData}
                currentRouteCoords={activeRouteCoords}
                onSwitchToCommuter={() => setStudioMode('COMMUTER')}
                isGuestView={!isAuthenticatedAdmin}
              />
            )}
          </div>

          {/* Floating Bottom-Right Indicators for Dragging / Barricade Modes */}
          {isAdjustingWaypoints && (
            <div
              style={{
                position: 'absolute',
                bottom: '120px',
                right: '24px',
                zIndex: 40,
                background: 'rgba(10, 15, 29, 0.94)',
                border: '1px solid #00F2FE',
                borderRadius: '12px',
                padding: '10px 14px',
                color: '#fff',
                fontSize: '11px',
                boxShadow: '0 8px 24px rgba(0, 242, 254, 0.3)'
              }}
            >
              <b style={{ color: '#00F2FE' }}>Clean Polyline Dragging Active:</b>
              <div>Click anywhere along the map to drop new road snapping points.</div>
            </div>
          )}

          {isBarricadeModeActive && (
            <div
              style={{
                position: 'absolute',
                bottom: '120px',
                right: '24px',
                zIndex: 40,
                background: 'rgba(20, 10, 15, 0.94)',
                border: '1px solid #FF1744',
                borderRadius: '12px',
                padding: '10px 14px',
                color: '#fff',
                fontSize: '11px',
                boxShadow: '0 8px 24px rgba(255, 23, 68, 0.3)'
              }}
            >
              <b style={{ color: '#FF1744' }}>Blockage Mode Active:</b>
              <div>Click any road or junction to drop a police barricade and recalculate detour.</div>
            </div>
          )}

          {/* Commuter Active Conflict Alert Card */}
          {studioMode === 'COMMUTER' && (
            <EventConflictCard
              isVisible={isConflictCardVisible}
              eventName={currentDomain.title}
              delayMins={20}
              corridorName="Wardha Road"
              onSwitchToBypass={handleSwitchToBypass}
              onDismiss={() => setIsConflictCardVisible(false)}
            />
          )}

          {/* Commuter Turn-by-Turn Navigation HUD */}
          <NavigationHud
            isNavigating={isNavigating}
            onExitNavigation={() => setIsNavigating(false)}
          />

          {/* Live Traffic Legend */}
          <TrafficLegend />
        </>
      )}

      {/* 3. MODALS */}
      <GatewayLoginModal onExploreAsGuest={handleExploreAsGuest} />

      <BroadcastAlertModal
        isOpen={isBroadcastModalOpen}
        onClose={() => setIsBroadcastModalOpen(false)}
        domainId={currentDomain.id}
        domainTitle={currentDomain.title}
        adminPhone={phone || '9823012345'}
        onBroadcastSent={(msg) => {
          setActiveBroadcastBanner({
            domainTitle: currentDomain.title,
            corridor: msg.corridor,
            text: msg.text
          });
        }}
      />

      <AddCheckpointModal
        isOpen={isAddCheckpointModalOpen}
        onClose={() => setIsAddCheckpointModalOpen(false)}
        onActivatePlacement={(data) => {
          setPendingCheckpointData(data);
        }}
      />
    </div>
  );
}
