// ========================================================================= //
// ZEROMILE GO - MASTER APPLICATION ENGINE (app.js)                          //
// Multi-Route High-Visibility • SuperAdmin Studio • Universal Search        //
// ========================================================================= //

// Active Mapbox Access Token (Centralized via window.CONFIG)
mapboxgl.accessToken = (window.CONFIG && window.CONFIG.MAPBOX_ACCESS_TOKEN) || '';
if (!mapboxgl.accessToken) {
  console.warn('Mapbox access token is missing. Configure MAPBOX_ACCESS_TOKEN in .env or environment configuration.');
}

// ZeroMile Toast Notification System
function showToast(message, duration = 3500) {
  let container = document.querySelector('.zm-toast-container');
  if (!container) {
    container = document.createElement('div');
    container.className = 'zm-toast-container';
    document.body.appendChild(container);
  }
  const toast = document.createElement('div');
  toast.className = 'zm-toast';
  toast.innerHTML = message;
  container.appendChild(toast);

  setTimeout(() => {
    toast.style.animation = 'toastFadeOut 0.3s cubic-bezier(0.16, 1, 0.3, 1) forwards';
    setTimeout(() => toast.remove(), 300);
  }, duration);
}

// Master Application State
let map = null;
let currentView = 'landing'; // 'landing' | 'map'
let currentUserRole = 'GUEST'; // 'GUEST' | 'SUPERADMIN'
let currentAdminDomain = 'CYCLOTHON'; // 'CYCLOTHON' | 'MARATHON' | 'RALLY'
let currentAdminPhone = null;
let generatedOtp = '849201';
let currentLightPreset = 'night';

// Live Participant Mobility & Fleet Radar State (OFF by default)
let isMobilityRadarActive = false;
let followingParticipantId = null;
let rallyAnimFrameId = null;
let liveParticipantMarkers = {};
let liveParticipantsData = [];

// Dynamic Commuter Routing State (Clean start)
let commuterOrigin = null;
let commuterDest = null;
let commuteMode = 'driving'; // 'driving' | 'cycling' | 'walking'
let currentSelectedRoute = 'primary'; // 'primary' | 'alt2' | 'alt1'
let isFetchingRoute = false;

// SuperAdmin Single Route State (Clean start)
let adminOrigin = null;
let adminDest = null;
let adminSinglePathWaypoints = [];
let customViaPoints = []; // Invisible via points for clean polyline tweaking
let adminSinglePathCoords = [];
let isEditWaypointsMode = false;
let isRoadClosureMode = false;
let isCheckpointPlacementMode = false;
let pendingCheckpointData = null;
let activeDragMarker = null;

// History Stack (Undo / Redo)
let historyStack = [];
let redoStack = [];

// 3D Map Visualization Controls
let is3DTiltActive = true;
let is3DOrbitActive = false;
let orbitInterval = null;
let isNavigating = false;
let navSimulationInterval = null;
let simStepIndex = 0;

// Map Marker References
let originPinMarker = null;
let destPinMarker = null;
let adminWaypointMarkers = [];
let checkpointMarkers = [];
let closureMarkers = [];
let liveVehicleMarker = null;
let eventProcessionMarkers = [];
let gpsWatchId = null;
let gpsMarker = null;

// Audio Context
let audioCtx = null;

// ========================================================================= //
// 1. NAGPUR MASTER GEOGRAPHY & PLACES REGISTRY (Universal Search)           //
// ========================================================================= //

const NAGPUR_REGISTRY = [
  // Institutes of National Importance & Universities
  { id: 'iiit', name: 'IIIT Nagpur (Indian Institute of Information Technology), Waranga MIHAN', lat: 21.0260, lng: 79.0300, type: 'COLLEGE' },
  { id: 'aiims', name: 'AIIMS Nagpur (All India Institute of Medical Sciences), MIHAN', lat: 21.0360, lng: 79.0320, type: 'HOSPITAL' },
  { id: 'iim', name: 'IIM Nagpur (Indian Institute of Management), MIHAN Campus', lat: 21.0310, lng: 79.0280, type: 'COLLEGE' },
  { id: 'symbiosis', name: 'Symbiosis International University Campus, Wathoda', lat: 21.1290, lng: 79.1450, type: 'COLLEGE' },

  // Engineering & Degree Colleges
  { id: 'vnit', name: 'VNIT Main Gate (South Ambazari)', lat: 21.1280, lng: 79.0520, type: 'COLLEGE' },
  { id: 'ycce', name: 'YCCE College of Engineering (Hingna Rd)', lat: 21.1020, lng: 78.9780, type: 'COLLEGE' },
  { id: 'rcoem', name: 'Ramdeobaba University (RCOEM Katol Rd)', lat: 21.1760, lng: 79.0610, type: 'COLLEGE' },
  { id: 'gcoen', name: 'GCOEN Government College of Engineering, Sector 27', lat: 21.0950, lng: 79.0550, type: 'COLLEGE' },
  { id: 'datta_meghe', name: 'Datta Meghe Institute of Higher Education, Wanadongri', lat: 21.0950, lng: 78.9680, type: 'COLLEGE' },
  { id: 'raisoni', name: 'GH Raisoni College of Engineering, Digdoh Hills', lat: 21.1020, lng: 78.9850, type: 'COLLEGE' },
  { id: 'kdk', name: 'KDK College of Engineering, Great Nag Rd Nandanvan', lat: 21.1350, lng: 79.1220, type: 'COLLEGE' },
  { id: 'pallotti', name: 'St Vincent Pallotti College of Engineering, Gavsi Manapur', lat: 21.0450, lng: 79.0620, type: 'COLLEGE' },
  { id: 'lit', name: 'LIT Nagpur (Laxminarayan Institute)', lat: 21.1340, lng: 79.0490, type: 'COLLEGE' },
  { id: 'lawcollege', name: 'Law College Square Junction', lat: 21.1390, lng: 79.0680, type: 'SQUARE' },
  { id: 'hislop', name: 'Hislop College Campus, Civil Lines', lat: 21.1490, lng: 79.0720, type: 'COLLEGE' },
  { id: 'cp_berar', name: 'CP & Berar College, Tulsibagh Mahal', lat: 21.1410, lng: 79.1050, type: 'COLLEGE' },
  { id: 'gs_college', name: 'GS College of Commerce & Economics, Law College Sq', lat: 21.1380, lng: 79.0670, type: 'COLLEGE' },

  // Medical Colleges & Hospitals
  { id: 'gmc', name: 'Government Medical College (GMC), Ajni', lat: 21.1350, lng: 79.0920, type: 'HOSPITAL' },
  { id: 'igmc', name: 'IGGMC Mayo Hospital (Central Avenue)', lat: 21.1520, lng: 79.0950, type: 'HOSPITAL' },
  { id: 'nkp_salve', name: 'NKP Salve Institute of Medical Sciences, Digdoh', lat: 21.0980, lng: 78.9820, type: 'HOSPITAL' },

  // Core Landmarks & Civic Hubs
  { id: 'zeromile', name: 'Zero Mile Freedom Park Monument', lat: 21.1498, lng: 79.0806, type: 'LANDMARK' },
  { id: 'sitabuldi', name: 'Sitabuldi Metro Interchange & Fort', lat: 21.1460, lng: 79.0820, type: 'METRO' },
  { id: 'deekshabhoomi', name: 'Deekshabhoomi Monument & Stupa', lat: 21.1278, lng: 79.0664, type: 'LANDMARK' },
  { id: 'kasturchand', name: 'Kasturchand Park Grounds', lat: 21.1520, lng: 79.0840, type: 'PARK' },
  { id: 'yashwant', name: 'Yashwant Stadium (Dhantoli)', lat: 21.1380, lng: 79.0830, type: 'STADIUM' },
  { id: 'reshimbagh', name: 'Reshimbagh Ground & Memorial', lat: 21.1310, lng: 79.1080, type: 'LANDMARK' },
  { id: 'maharajbagh', name: 'Maharajbagh Zoo & Botanical Gardens', lat: 21.1430, lng: 79.0760, type: 'PARK' },

  // Lakes & Parks
  { id: 'futala', name: 'Futala Lake Waterfront Promenade', lat: 21.1550, lng: 79.0450, type: 'LAKE' },
  { id: 'ambazari', name: 'Ambazari Lake & Garden Gate', lat: 21.1250, lng: 79.0480, type: 'LAKE' },
  { id: 'seminary', name: 'Seminary Hills Botanical Garden', lat: 21.1620, lng: 79.0600, type: 'PARK' },
  { id: 'gorekada', name: 'Gorewada Zoo & International Bio-Park', lat: 21.1960, lng: 79.0320, type: 'PARK' },
  { id: 'sakkardara', name: 'Sakkardara Lake Garden', lat: 21.1210, lng: 79.1120, type: 'LAKE' },
  { id: 'gandhisagar', name: 'Gandhi Sagar Lake (Shukrawari Talav)', lat: 21.1440, lng: 79.0980, type: 'LAKE' },

  // Squares & Commercial Areas
  { id: 'shankar', name: 'Shankar Nagar Square Metro Station', lat: 21.1310, lng: 79.0600, type: 'SQUARE' },
  { id: 'dharampeth', name: 'Dharampeth Main Market (WHC Road)', lat: 21.1420, lng: 79.0620, type: 'MARKET' },
  { id: 'ramdaspeth', name: 'Ramdaspeth Central Avenue', lat: 21.1370, lng: 79.0750, type: 'RESIDENTIAL' },
  { id: 'sadar', name: 'Sadar Residency Road Bazaar', lat: 21.1600, lng: 79.0800, type: 'MARKET' },
  { id: 'medical', name: 'Medical Square (Ajni Link Rd)', lat: 21.1320, lng: 79.0950, type: 'SQUARE' },
  { id: 'khamla', name: 'Khamla Main Square', lat: 21.1180, lng: 79.0560, type: 'SQUARE' },
  { id: 'trimurti', name: 'Trimurti Nagar Chowk', lat: 21.1210, lng: 79.0390, type: 'SQUARE' },
  { id: 'pratapnagar', name: 'Pratap Nagar Ring Road Chowk', lat: 21.1160, lng: 79.0490, type: 'SQUARE' },
  { id: 'bajajnagar', name: 'Bajaj Nagar Central Square', lat: 21.1280, lng: 79.0620, type: 'RESIDENTIAL' },
  { id: 'laxminagar', name: 'Laxmi Nagar Square (Water Tank)', lat: 21.1220, lng: 79.0660, type: 'SQUARE' },
  { id: 'manish', name: 'Manish Nagar Beltarodi Junction', lat: 21.0950, lng: 79.0780, type: 'RESIDENTIAL' },
  { id: 'besa', name: 'Besa Main Chowk (Ghogli Rd)', lat: 21.0820, lng: 79.0850, type: 'RESIDENTIAL' },
  { id: 'beltarodi', name: 'Beltarodi Police Station Chowk', lat: 21.0850, lng: 79.0750, type: 'RESIDENTIAL' },
  { id: 'somalwada', name: 'Somalwada Square (Wardha Rd)', lat: 21.1020, lng: 79.0640, type: 'SQUARE' },
  { id: 'chhatrapati', name: 'Chhatrapati Square Metro Station', lat: 21.1120, lng: 79.0620, type: 'METRO' },
  { id: 'rahate', name: 'Rahate Colony Square (Wardha Rd)', lat: 21.1360, lng: 79.0730, type: 'SQUARE' },
  { id: 'lokmat', name: 'Lokmat Square (Panchsheel Cinema)', lat: 21.1410, lng: 79.0790, type: 'SQUARE' },
  { id: 'variety', name: 'Variety Square (Maharajbagh Rd)', lat: 21.1440, lng: 79.0810, type: 'SQUARE' },

  // East & North Nagpur
  { id: 'wardhaman', name: 'Wardhaman Nagar Central Avenue', lat: 21.1480, lng: 79.1350, type: 'MARKET' },
  { id: 'nandanvan', name: 'Nandanvan Main Chowk', lat: 21.1350, lng: 79.1280, type: 'RESIDENTIAL' },
  { id: 'mahal', name: 'Mahal Heritage Market (Kotwali)', lat: 21.1430, lng: 79.1080, type: 'MARKET' },
  { id: 'itwari', name: 'Itwari Wholesale Market & Railway Station', lat: 21.1550, lng: 79.1150, type: 'MARKET' },
  { id: 'gandhibagh', name: 'Gandhibagh Garden & Cloth Market', lat: 21.1490, lng: 79.1020, type: 'MARKET' },
  { id: 'jaripatka', name: 'Jaripatka Main Market', lat: 21.1850, lng: 79.0910, type: 'MARKET' },
  { id: 'koradi', name: 'Koradi Devi Temple & Thermal Power', lat: 21.2450, lng: 79.0980, type: 'LANDMARK' },
  { id: 'mankapur', name: 'Mankapur Sports Stadium Chowk', lat: 21.1890, lng: 79.0780, type: 'STADIUM' },
  { id: 'zingabai', name: 'Zingabai Takli Godhani Rd', lat: 21.1820, lng: 79.0550, type: 'RESIDENTIAL' },
  { id: 'katolrd', name: 'Katol Road Square (Friends Colony)', lat: 21.1680, lng: 79.0480, type: 'RESIDENTIAL' },

  // Transit Hubs & Malls
  { id: 'airport', name: 'Dr. Babasaheb Ambedkar Airport (NAG)', lat: 21.0920, lng: 79.0480, type: 'AIRPORT' },
  { id: 'railway', name: 'Nagpur Main Junction Railway Station', lat: 21.1520, lng: 79.0880, type: 'TRANSIT' },
  { id: 'ajni', name: 'Ajni Railway Station (South Nagpur)', lat: 21.1240, lng: 79.0820, type: 'TRANSIT' },
  { id: 'empress', name: 'Empress Mall & Raman Science Centre', lat: 21.1480, lng: 79.0920, type: 'MALL' },
  { id: 'vrmall', name: 'VR Mall Nagpur (Medical Square Rd)', lat: 21.1280, lng: 79.1020, type: 'MALL' },
  { id: 'eternity', name: 'Eternity Mall (Variety Square)', lat: 21.1445, lng: 79.0825, type: 'MALL' },

  // Suburbs & Industrial
  { id: 'mihan_sez', name: 'MIHAN SEZ Tech Park Hub', lat: 21.0350, lng: 79.0300, type: 'INDUSTRIAL' },
  { id: 'hingna', name: 'Hingna MIDC Industrial Area', lat: 21.0850, lng: 78.9650, type: 'INDUSTRIAL' },
  { id: 'wadi', name: 'Wadi Naka (Amravati National Highway)', lat: 21.1530, lng: 78.9950, type: 'SUBURB' },
  { id: 'pardi', name: 'Pardi Square (Bhandara Road Highway)', lat: 21.1450, lng: 79.1620, type: 'HIGHWAY' },
  { id: 'kalamna', name: 'Kalamna APMC Market Yard', lat: 21.1720, lng: 79.1480, type: 'MARKET' },
  { id: 'butibori', name: 'Butibori Industrial Corridor (MIDC)', lat: 20.9320, lng: 78.9950, type: 'INDUSTRIAL' }
];

// ========================================================================= //
// 2. DOMAIN EVENTS & OFFICIAL CORRIDORS                                     //
// ========================================================================= //

const DOMAIN_DATA = {
  CYCLOTHON: {
    id: 'CYCLOTHON',
    title: 'Nagpur Grand Cyclothon 2026',
    adminTitle: 'CYCLOTHON CORRIDOR STUDIO',
    corridorName: 'South Ambazari Rd ➔ Wardha Rd ➔ Sitabuldi',
    delayMins: 15,
    color: '#FFB300', // Electric Gold
    description: '15km rolling peloton on Wardha Road corridor. Closed to motorized traffic.',
    defaultOrigin: { id: 'vnit', name: 'VNIT Main Gate (South Ambazari)', lng: 79.0520, lat: 21.1280 },
    defaultDest: { id: 'zeromile', name: 'Zero Mile Freedom Park Monument', lng: 79.0806, lat: 21.1498 },
    checkpoints: [
      { name: '🚩 Cyclothon Flag-off: VNIT Gate', type: 'flagoff', lng: 79.0520, lat: 21.1280, note: 'Assembly at 06:00 AM' },
      { name: '💧 Shankar Nagar Hydration Post', type: 'hydration', lng: 79.0600, lat: 21.1310, note: '500 energy drinks ready' },
      { name: '⏱️ Rahate Colony Timing Mat', type: 'timing', lng: 79.0720, lat: 21.1380, note: '5km RFID timing split' },
      { name: '🏥 Lokmat Square Medical Unit', type: 'medical', lng: 79.0790, lat: 21.1420, note: 'Ambulance & first aiders' },
      { name: '🏁 Zero Mile Finish Line', type: 'finish', lng: 79.0806, lat: 21.1498, note: 'Finish line & podium' }
    ]
  },
  MARATHON: {
    id: 'MARATHON',
    title: 'Nagpur 21K & 42K City Marathon',
    adminTitle: 'MARATHON CORRIDOR STUDIO',
    corridorName: 'Civil Lines ➔ High Court ➔ Seminary Hills Promenade',
    delayMins: 20,
    color: '#FF9100', // Amber
    description: 'Official 21K green corridor through Civil Lines & Seminary Hills.',
    defaultOrigin: { id: 'zeromile', name: 'Zero Mile Freedom Park Monument', lng: 79.0806, lat: 21.1498 },
    defaultDest: { id: 'seminary', name: 'Seminary Hills Botanical Garden', lng: 79.0600, lat: 21.1620 },
    checkpoints: [
      { name: '🚩 Marathon Flag-off: Zero Mile', type: 'flagoff', lng: 79.0806, lat: 21.1498, note: '21K flag-off at 05:30 AM' },
      { name: '💧 High Court Hydration Post', type: 'hydration', lng: 79.0780, lat: 21.1490, note: 'Water sponges' },
      { name: '⏱️ Seminary Hills Timing Split', type: 'timing', lng: 79.0600, lat: 21.1620, note: '10km split' },
      { name: '🏁 Seminary Hills Recovery Zone', type: 'finish', lng: 79.0600, lat: 21.1620, note: 'Medal distribution' }
    ]
  },
  RALLY: {
    id: 'RALLY',
    title: 'Sitabuldi Heritage Civic Procession',
    adminTitle: 'RALLY & PROCESSION STUDIO',
    corridorName: 'Variety Square ➔ Sitabuldi Main Market Corridor',
    delayMins: 25,
    color: '#FF1744', // Crimson
    description: 'Sitabuldi central market artery barricaded for civic procession.',
    defaultOrigin: { id: 'variety', name: 'Variety Square Junction (Sitabuldi)', lng: 79.0800, lat: 21.1420 },
    defaultDest: { id: 'zeromile', name: 'Zero Mile Freedom Park Monument', lng: 79.0806, lat: 21.1498 },
    checkpoints: [
      { name: '🚩 Rally Assembly: Variety Square', type: 'flagoff', lng: 79.0800, lat: 21.1420, note: 'Assembly point' },
      { name: '🚧 Police Barricade: Sitabuldi Entry', type: 'barricade', lng: 79.0810, lat: 21.1450, note: 'Road blocked' },
    ]
  }
};

// Commuter Multi-Route Store
let ROUTE_DATA = {
  primary: {
    id: 'primary',
    name: 'Direct Corridor (Through Event Area)',
    via: 'via Wardha Road Main Artery',
    distance: '6.2 km',
    duration: '38 min',
    delayMins: 20,
    isAffectedByEvent: true,
    color: '#EF4444', // Bold Red
    coordinates: []
  },
  alt2: {
    id: 'alt2',
    name: 'Recommended Bypass Route',
    via: 'via Ambazari Lake & Civil Lines',
    distance: '7.4 km',
    duration: '18 min',
    delayMins: 0,
    isAffectedByEvent: false,
    color: '#00F2FE', // Radiant Blue
    coordinates: []
  },
  alt1: {
    id: 'alt1',
    name: 'Outer Ring Expressway Bypass',
    via: 'via Outer Ring Expressway',
    distance: '8.5 km',
    duration: '22 min',
    delayMins: 0,
    isAffectedByEvent: false,
    color: '#10B981', // Crisp Emerald
    coordinates: []
  }
};

let activeCheckpoints = [...DOMAIN_DATA.CYCLOTHON.checkpoints];
let roadClosures = [
  { name: 'Wardha Road - Shankar Nagar Flyover Entry', lat: 21.1310, lng: 79.0600, desc: 'Closed for Cyclothon rolling pack' },
  { name: 'Sitabuldi Central Market Artery', lat: 21.1440, lng: 79.0820, desc: 'Barricaded for civic procession' }
];

// ========================================================================= //
// 3. MAPBOX DIRECTIONS & DYNAMIC GPS ENGINE                                 //
// ========================================================================= //

async function fetchSingleMapboxRoute(coordsList, profile = 'driving-traffic') {
  const coordsStr = coordsList.map(c => `${c[0].toFixed(5)},${c[1].toFixed(5)}`).join(';');
  
  // 1. Try Mapbox Directions API
  const url = `https://api.mapbox.com/directions/v5/mapbox/${profile}/${coordsStr}?geometries=geojson&steps=true&overview=full&access_token=${mapboxgl.accessToken}`;
  try {
    const response = await fetch(url);
    const data = await response.json();
    if (data && data.routes && data.routes.length > 0) {
      return data.routes[0];
    }
  } catch (e) {}

  // 2. Secondary Engine: OSRM Public Routing API (Real road network)
  try {
    const osrmProfile = profile === 'cycling' ? 'bike' : (profile === 'walking' ? 'foot' : 'driving');
    const osrmUrl = `https://router.project-osrm.org/route/v1/${osrmProfile}/${coordsStr}?overview=full&geometries=geojson&steps=true`;
    const osrmResp = await fetch(osrmUrl);
    const osrmData = await osrmResp.json();
    if (osrmData && osrmData.routes && osrmData.routes.length > 0) {
      return osrmData.routes[0];
    }
  } catch (err) {}

  return null;
}

async function fetchDynamicRouteDirections(orig, dest, mode) {
  const profileMap = { driving: 'driving-traffic', cycling: 'cycling', walking: 'walking' };
  const profile = profileMap[mode] || 'driving';

  let routes = [];

  // Tier 1: Query Mapbox alternatives
  try {
    const url = `https://api.mapbox.com/directions/v5/mapbox/${profile}/${orig.lng.toFixed(5)},${orig.lat.toFixed(5)};${dest.lng.toFixed(5)},${dest.lat.toFixed(5)}?alternatives=true&geometries=geojson&steps=true&overview=full&access_token=${mapboxgl.accessToken}`;
    const response = await fetch(url);
    const data = await response.json();
    if (data && data.routes && data.routes.length > 0) {
      routes = [...data.routes];
    }
  } catch (err) {
    console.warn('Mapbox primary query note:', err);
  }

  // Tier 2: If Mapbox gave 0 routes, query OSRM directly
  if (routes.length === 0) {
    try {
      const osrmUrl = `https://router.project-osrm.org/route/v1/driving/${orig.lng.toFixed(5)},${orig.lat.toFixed(5)};${dest.lng.toFixed(5)},${dest.lat.toFixed(5)}?overview=full&geometries=geojson&alternatives=true&steps=true`;
      const osrmResp = await fetch(osrmUrl);
      const osrmData = await osrmResp.json();
      if (osrmData && osrmData.routes && osrmData.routes.length > 0) {
        routes = [...osrmData.routes];
      }
    } catch (e) {}
  }

  // Tier 3: Query real distinct arterial roadway bypasses (Ambazari/Civil Lines vs Outer Ring Road)
  if (routes.length < 3) {
    const midLng = (orig.lng + dest.lng) / 2;
    const midLat = (orig.lat + dest.lat) / 2;
    const deltaLng = dest.lng - orig.lng;
    const deltaLat = dest.lat - orig.lat;

    // Perpendicular vectors for distinct road bypasses
    const perpLng = -deltaLat * 0.35;
    const perpLat = deltaLng * 0.35;

    // Query Alternate Bypass 1 (Arterial corridor)
    if (routes.length < 2) {
      try {
        const way1 = [midLng + perpLng, midLat + perpLat];
        const altRoute1 = await fetchSingleMapboxRoute([[orig.lng, orig.lat], way1, [dest.lng, dest.lat]], profile);
        if (altRoute1) {
          altRoute1.legs = [{ steps: [{ name: 'North Corridor Bypass' }] }];
          routes.push(altRoute1);
        }
      } catch (e) {}
    }

    // Query Alternate Bypass 2 (Expressway corridor)
    if (routes.length < 3) {
      try {
        const way2 = [midLng - perpLng, midLat - perpLat];
        const altRoute2 = await fetchSingleMapboxRoute([[orig.lng, orig.lat], way2, [dest.lng, dest.lat]], profile);
        if (altRoute2) {
          altRoute2.legs = [{ steps: [{ name: 'Outer Ring Expressway' }] }];
          routes.push(altRoute2);
        }
      } catch (e) {}
    }
  }

  // Fallback: If still fewer than 3, clone primary with slight distance offsets along road geometry
  if (routes.length === 0) {
    return generateDynamicFallbackRoutes(orig, dest, mode);
  }

  while (routes.length < 3) {
    const base = routes[0];
    const idx = routes.length;
    routes.push({
      geometry: { coordinates: [...base.geometry.coordinates] },
      distance: base.distance * (1 + idx * 0.12),
      duration: base.duration * (1 + idx * 0.15),
      legs: [{ steps: [{ name: idx === 1 ? 'Alternate Arterial Bypass' : 'Outer Ring Expressway' }] }]
    });
  }

  return routes;
}

function generateDynamicFallbackRoutes(orig, dest, mode) {
  const distKm = turf.distance(turf.point([orig.lng, orig.lat]), turf.point([dest.lng, dest.lat]), { units: 'kilometers' }) * 1.25;
  const speed = mode === 'cycling' ? 18 : (mode === 'walking' ? 5 : 35);
  const durMins = Math.max(3, Math.round((distKm / speed) * 60));

  // Connect start and destination with intermediate road-step points
  const p1 = [orig.lng, orig.lat];
  const p2 = [dest.lng, dest.lat];
  const mid = [(p1[0] + p2[0]) / 2, (p1[1] + p2[1]) / 2];

  return [
    {
      geometry: { coordinates: [p1, mid, p2] },
      distance: distKm * 1000,
      duration: durMins * 60,
      legs: [{ steps: [{ name: 'Direct Corridor' }] }]
    },
    {
      geometry: { coordinates: [p1, [mid[0] - 0.005, mid[1] + 0.005], p2] },
      distance: (distKm * 1.15) * 1000,
      duration: (durMins + 3) * 60,
      legs: [{ steps: [{ name: 'Alternate Bypass' }] }]
    },
    {
      geometry: { coordinates: [p1, [mid[0] + 0.008, mid[1] - 0.008], p2] },
      distance: (distKm * 1.28) * 1000,
      duration: (durMins + 6) * 60,
      legs: [{ steps: [{ name: 'Outer Expressway' }] }]
    }
  ];
}

// ========================================================================= //
// 4. COMMUTER ROUTE EVALUATION & MULTI-ROUTE RENDERING                      //
// ========================================================================= //

async function setCommuterDirectQuickRoute(origId, destId) {
  const o = NAGPUR_REGISTRY.find(p => p.id === origId) || NAGPUR_REGISTRY[0];
  const d = NAGPUR_REGISTRY.find(p => p.id === destId) || NAGPUR_REGISTRY[1];
  commuterOrigin = o;
  commuterDest = d;
  ['mapOriginInput', 'heroOriginInput', 'filterStartInput'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.value = o.name;
  });
  ['mapDestInput', 'heroDestInput', 'filterEndInput'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.value = d.name;
  });
  await evaluateRouteConflictAndRender();
}

async function evaluateRouteConflictAndRender() {
  if (isFetchingRoute) return;
  isFetchingRoute = true;

  if (currentUserRole === 'SUPERADMIN') {
    await renderSuperAdminSinglePath();
    isFetchingRoute = false;
    return;
  }

  // If start or destination is not yet chosen, show clean map view centered at Zero Mile
  if (!commuterOrigin || !commuterDest) {
    wipeAllNonAdminLayers();
    if (map && map.isStyleLoaded()) {
      map.flyTo({ center: [79.0806, 21.1498], zoom: 13.5, pitch: 45, duration: 800 });
    }
    isFetchingRoute = false;
    return;
  }

  const originName = commuterOrigin.name;
  const destName = commuterDest.name;

  ['mapOriginInput', 'heroOriginInput', 'filterStartInput'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.value = originName;
  });
  ['mapDestInput', 'heroDestInput', 'filterEndInput'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.value = destName;
  });

  // Commuter Multi-Engine Flow (Mapbox Directions + OSRM Road Fallback)
  const apiRoutes = await fetchDynamicRouteDirections(commuterOrigin, commuterDest, commuteMode);

  if (apiRoutes && apiRoutes.length > 0) {
    const extractVia = (route) => {
      try {
        const steps = route.legs?.[0]?.steps || [];
        const mainRoad = steps.find(s => s.name && s.name.length > 2);
        return mainRoad ? `via ${mainRoad.name}` : 'via Direct Road';
      } catch (e) { return 'via Direct Road'; }
    };

    const r0 = apiRoutes[0];
    const distKm0 = (r0.distance / 1000).toFixed(1);
    const durMins0 = Math.round(r0.duration / 60);
    ROUTE_DATA.primary.coordinates = r0.geometry.coordinates;
    ROUTE_DATA.primary.distance = `${distKm0} km`;
    ROUTE_DATA.primary.duration = `${durMins0} min`;
    ROUTE_DATA.primary.via = extractVia(r0);

    const r1 = apiRoutes[1] || apiRoutes[0];
    const distKm1 = (r1.distance / 1000).toFixed(1);
    const durMins1 = Math.round(r1.duration / 60);
    ROUTE_DATA.alt2.coordinates = r1.geometry.coordinates;
    ROUTE_DATA.alt2.distance = `${distKm1} km`;
    ROUTE_DATA.alt2.duration = `${durMins1} min`;
    ROUTE_DATA.alt2.via = extractVia(r1);

    const r2 = apiRoutes[2] || apiRoutes[0];
    const distKm2 = (r2.distance / 1000).toFixed(1);
    const durMins2 = Math.round(r2.duration / 60);
    ROUTE_DATA.alt1.coordinates = r2.geometry.coordinates;
    ROUTE_DATA.alt1.distance = `${distKm2} km`;
    ROUTE_DATA.alt1.duration = `${durMins2} min`;
    ROUTE_DATA.alt1.via = extractVia(r2);
  }

  // 1. Precise Real-Time Clash Check: Only trigger if an active police barricade/closure is directly on the commuter's road
  const activeEvent = DOMAIN_DATA[currentAdminDomain];
  let isClashDetected = false;
  let clashingClosure = null;

  if (ROUTE_DATA.primary.coordinates && ROUTE_DATA.primary.coordinates.length >= 2 && roadClosures.length > 0) {
    try {
      const primaryLine = turf.lineString(ROUTE_DATA.primary.coordinates);
      for (const rc of roadClosures) {
        const d = turf.pointToLineDistance(turf.point([rc.lng, rc.lat]), primaryLine, { units: 'kilometers' });
        if (d < 0.08) { // within 80 meters of the roadway
          isClashDetected = true;
          clashingClosure = rc;
          break;
        }
      }
    } catch (e) {
      isClashDetected = false;
    }
  }

  const conflictCard = document.getElementById('eventConflictCard');
  const dur0 = parseInt(ROUTE_DATA.primary.duration) || 20;
  const dur1 = parseInt(ROUTE_DATA.alt2.duration) || 30;
  const dur2 = parseInt(ROUTE_DATA.alt1.duration) || 25;

  let bestRouteKey = 'primary';

  if (isClashDetected) {
    // Barricade or Active Closure intersects this road!
    ROUTE_DATA.primary.isAffectedByEvent = true;
    const eventDelay = activeEvent?.delayMins || 20;
    ROUTE_DATA.primary.delayMins = eventDelay;
    ROUTE_DATA.primary.duration = `${dur0 + eventDelay} min`;
    ROUTE_DATA.primary.color = '#EF4444'; // Red / Roadblock
    bestRouteKey = 'alt2'; // Recommend Alternate Bypass

    if (conflictCard) {
      conflictCard.classList.remove('hidden');
      document.getElementById('conflictEventName').textContent = `ROAD CLOSURE: ${clashingClosure?.name || activeEvent?.title || 'Police Barricade'}`;
      document.getElementById('conflictDelayPill').querySelector('.delay-val').textContent = `+${eventDelay} min`;
      document.getElementById('conflictDescText').textContent = `Direct road is barricaded near ${clashingClosure?.name || 'event area'}. Taking the clean bypass saves time.`;
    }
  } else {
    // NO road closure on this corridor - clean free flow!
    ROUTE_DATA.primary.isAffectedByEvent = false;
    ROUTE_DATA.primary.delayMins = 0;
    ROUTE_DATA.primary.color = '#2563EB'; // Clean Blue

    if (conflictCard) conflictCard.classList.add('hidden');

    // Pick the fastest among the 3 clear routes
    if (dur0 <= dur1 && dur0 <= dur2) bestRouteKey = 'primary';
    else if (dur1 <= dur0 && dur1 <= dur2) bestRouteKey = 'alt2';
    else bestRouteKey = 'alt1';
  }

  selectRouteOption(bestRouteKey);
  updateCommuterCardsUI(isClashDetected, activeEvent, bestRouteKey);
  renderCommuterRoutesOnMap();
  updateActiveRouteSimulation();
  renderEndpointsMarkers(ROUTE_DATA[currentSelectedRoute].coordinates);
  renderRoadClosures();
  fitMapToCurrentRoute();

  isFetchingRoute = false;
}

function updateCommuterCardsUI(isClash, activeEvent, bestRouteKey) {
  const opt1 = document.getElementById('optRoutePrimary');
  const opt2 = document.getElementById('optRouteAlt2');
  const opt3 = document.getElementById('optRouteAlt1');

  const dur0 = parseInt(ROUTE_DATA.primary.duration) || 0;
  const dur1 = parseInt(ROUTE_DATA.alt2.duration) || 0;
  const dur2 = parseInt(ROUTE_DATA.alt1.duration) || 0;

  // 1. Primary Card (Direct Path)
  if (opt1) {
    opt1.querySelector('.rc-time').textContent = ROUTE_DATA.primary.duration;
    opt1.querySelector('.rc-via').textContent = `${ROUTE_DATA.primary.distance} • ${ROUTE_DATA.primary.via}`;
    const status = opt1.querySelector('.rc-traffic-status');
    const tag = opt1.querySelector('.rc-tag');
    
    if (isClash) {
      if (bestRouteKey === 'primary') {
        status.className = 'rc-traffic-status yellow';
        status.textContent = `🟡 Near ${activeEvent.title} (Moderate Traffic) • Still Quickest`;
        tag.className = 'rc-tag recommended';
        tag.textContent = '✨ Recommended • Fastest';
      } else {
        status.className = 'rc-traffic-status red';
        status.textContent = `🔴 Passes Through Closed ${activeEvent.title}`;
        tag.className = 'rc-tag delay';
        tag.textContent = `⚠️ +${ROUTE_DATA.primary.delayMins} min Event Delay`;
      }
    } else {
      status.className = 'rc-traffic-status green';
      status.textContent = '🟢 Free Flow • Direct Path';
      if (bestRouteKey === 'primary') {
        tag.className = 'rc-tag recommended';
        tag.textContent = '✨ Recommended • Fastest';
      } else {
        tag.className = 'rc-tag';
        tag.textContent = 'Direct Route';
      }
    }
  }

  // 2. Alt2 Bypass Card (Arterial / Lake Corridor)
  if (opt2) {
    opt2.querySelector('.rc-time').textContent = ROUTE_DATA.alt2.duration;
    opt2.querySelector('.rc-via').textContent = `${ROUTE_DATA.alt2.distance} • ${ROUTE_DATA.alt2.via}`;
    const status = opt2.querySelector('.rc-traffic-status');
    const tag = opt2.querySelector('.rc-tag');

    if (isClash) {
      if (bestRouteKey === 'alt2') {
        status.className = 'rc-traffic-status green';
        status.textContent = '🟢 Clean Bypass • Avoids Event Closures';
        tag.className = 'rc-tag recommended';
        const saved = Math.max(8, dur0 - dur1);
        tag.textContent = `✨ Saves ${saved} mins • Recommended`;
      } else {
        status.className = 'rc-traffic-status green';
        status.textContent = '🟢 Open Bypass • Avoids Event Area';
        tag.className = 'rc-tag';
        tag.textContent = 'Alternate Bypass';
      }
    } else {
      status.className = 'rc-traffic-status green';
      status.textContent = '🟢 Clean Arterial Bypass';
      if (bestRouteKey === 'alt2') {
        tag.className = 'rc-tag recommended';
        tag.textContent = '✨ Recommended • Fastest';
      } else {
        tag.className = 'rc-tag';
        tag.textContent = 'Alternate Route';
      }
    }
  }

  // 3. Alt1 Expressway Card (Outer Ring Road)
  if (opt3) {
    opt3.querySelector('.rc-time').textContent = ROUTE_DATA.alt1.duration;
    opt3.querySelector('.rc-via').textContent = `${ROUTE_DATA.alt1.distance} • ${ROUTE_DATA.alt1.via}`;
    const status = opt3.querySelector('.rc-traffic-status');
    const tag = opt3.querySelector('.rc-tag');
    status.className = 'rc-traffic-status green';
    status.textContent = '🟢 Free Highway Flow';
    if (bestRouteKey === 'alt1') {
      tag.className = 'rc-tag recommended';
      tag.textContent = '✨ Recommended • Fastest';
    } else {
      tag.className = 'rc-tag';
      tag.textContent = '⚡ Expressway Flow';
    }
  }

  // 4. Dynamically reorder cards in DOM so the Recommended Route is ALWAYS visually at the TOP!
  const container = document.getElementById('gmapsRouteOptions');
  if (container && opt1 && opt2 && opt3) {
    const cardMap = { primary: opt1, alt2: opt2, alt1: opt3 };
    const order = [bestRouteKey, ...['primary', 'alt2', 'alt1'].filter(k => k !== bestRouteKey)];
    order.forEach(k => {
      if (cardMap[k]) container.appendChild(cardMap[k]);
    });
  }
}

// RENDER ALL 3 COMMUTER ROUTES SIMULTANEOUSLY WITH HIGH VISIBILITY
function renderCommuterRoutesOnMap() {
  if (!map || !map.isStyleLoaded()) return;

  // Hide admin layers in commuter mode
  ['admin-event-route-casing', 'admin-event-route-mid', 'admin-event-route-line'].forEach(id => {
    if (map.getLayer(id)) map.setLayoutProperty(id, 'visibility', 'none');
  });

  if (map.getLayer('event-corridor-glow')) map.setLayoutProperty('event-corridor-glow', 'visibility', 'visible');
  if (map.getLayer('event-corridor-dots')) map.setLayoutProperty('event-corridor-dots', 'visibility', 'visible');

  // Render ALL 3 routes simultaneously!
  ['primary', 'alt2', 'alt1'].forEach(routeKey => {
    const route = ROUTE_DATA[routeKey];
    const src = map.getSource(`${routeKey}-route-src`);
    if (src) {
      src.setData({
        type: 'Feature',
        geometry: { type: 'LineString', coordinates: route.coordinates }
      });
    }

    if (map.getLayer(`${routeKey}-route-line`)) {
      map.setLayoutProperty(`${routeKey}-route-line`, 'visibility', 'visible');
      map.setLayoutProperty(`${routeKey}-route-casing`, 'visibility', 'visible');
      map.setPaintProperty(`${routeKey}-route-line`, 'line-color', route.color);
      
      const isSel = routeKey === currentSelectedRoute;
      map.setPaintProperty(`${routeKey}-route-line`, 'line-width', isSel ? 8 : 5.5);
      map.setPaintProperty(`${routeKey}-route-line`, 'line-opacity', isSel ? 1.0 : 0.85);
      map.setPaintProperty(`${routeKey}-route-casing`, 'line-width', isSel ? 12 : 9);
    }
  });
}

// ========================================================================= //
// 4B. DYNAMIC ROAD-SNAPPED TRAFFIC SIMULATION & MOBILITY RADAR              //
// ========================================================================= //

let rallyAnimProgress = 0;
let lastParticleUpdate = 0;
const PARTICLE_UPDATE_INTERVAL_MS = 40; // 25 FPS = Silky smooth GPU flow

function updateActiveRouteSimulation() {
  if (!map || !map.isStyleLoaded()) return;

  let activeCoords = [];
  let particleColor = '#00F2FE'; // Radiant cyan default

  if (currentUserRole === 'SUPERADMIN') {
    activeCoords = (adminSinglePathCoords && adminSinglePathCoords.length >= 2) ? adminSinglePathCoords : [];
    particleColor = '#FFB300';
  } else {
    const selectedRoute = ROUTE_DATA[currentSelectedRoute];
    if (selectedRoute && selectedRoute.coordinates && selectedRoute.coordinates.length >= 2) {
      activeCoords = selectedRoute.coordinates;
      particleColor = selectedRoute.color || '#00F2FE';
    }
  }

  if (!activeCoords || activeCoords.length < 2) return;

  if (map.getLayer('event-corridor-dots')) {
    map.setPaintProperty('event-corridor-dots', 'circle-color', particleColor);
    map.setLayoutProperty('event-corridor-dots', 'visibility', 'visible');
  }

  startActiveRouteParticleAnimation(activeCoords, particleColor);

  // In SuperAdmin mode (when radar is active), show race participant pucks strictly on the official route
  if (currentUserRole === 'SUPERADMIN' && isMobilityRadarActive) {
    initLiveMobilityRadar(activeCoords);
  } else {
    // In commuter mode, clear any participant pucks so the map displays clean road flow and navigation car
    Object.values(liveParticipantMarkers).forEach(m => m.marker.remove());
    liveParticipantMarkers = {};
  }
}

function startActiveRouteParticleAnimation(coords, color) {
  if (rallyAnimFrameId) {
    cancelAnimationFrame(rallyAnimFrameId);
    rallyAnimFrameId = null;
  }

  if (!coords || coords.length < 2) return;

  let line = null;
  let totalLen = 0;
  try {
    line = turf.lineString(coords);
    totalLen = turf.length(line, { units: 'kilometers' });
  } catch (e) { return; }

  if (totalLen <= 0) return;

  const numParticles = 20;

  function step(timestamp) {
    if (currentView !== 'map' || !map) {
      rallyAnimFrameId = null;
      return;
    }

    if (!lastParticleUpdate || timestamp - lastParticleUpdate >= PARTICLE_UPDATE_INTERVAL_MS) {
      const dt = lastParticleUpdate ? Math.min((timestamp - lastParticleUpdate) / 1000, 0.1) : 0.04;
      lastParticleUpdate = timestamp;
      rallyAnimProgress = (rallyAnimProgress + dt * 0.06) % 1.0;

      const movingPoints = [];
      for (let i = 0; i < numParticles; i++) {
        const pOffset = (rallyAnimProgress + (i / numParticles)) % 1.0;
        try {
          const pt = turf.along(line, pOffset * totalLen, { units: 'kilometers' });
          movingPoints.push(pt.geometry.coordinates);
        } catch (err) {}
      }

      const src = map ? map.getSource('active-event-corridor-src') : null;
      if (src) {
        src.setData({
          type: 'FeatureCollection',
          features: movingPoints.map((coord, idx) => ({
            type: 'Feature',
            properties: { index: idx },
            geometry: { type: 'Point', coordinates: coord }
          }))
        });
      }

      if (currentUserRole === 'SUPERADMIN' && isMobilityRadarActive) {
        updateLiveParticipantPositions(line, totalLen);
      }
    }

    rallyAnimFrameId = requestAnimationFrame(step);
  }

  rallyAnimFrameId = requestAnimationFrame(step);
}

function getDomainParticipants() {
  if (currentAdminDomain === 'MARATHON') {
    return [
      { id: 'runner-101', name: 'Priya S. (Lead Runner)', bib: '#101', category: 'lead', icon: '🏃', speed: 18.5, progress: 0.72, status: 'Active' },
      { id: 'runner-102', name: 'Vikram Singh (Pacer)', bib: '#102', category: 'lead', icon: '🏃', speed: 17.0, progress: 0.68, status: 'Active' },
      { id: 'runner-201', name: 'Main Marathon Pack', bib: '#200-PAC', category: 'peloton', icon: '🏃', speed: 14.5, progress: 0.50, status: 'Active' },
      { id: 'runner-202', name: 'Mid-Pack Runners', bib: '#312', category: 'peloton', icon: '🏃', speed: 13.0, progress: 0.44, status: 'Active' },
      { id: 'marshal-01', name: 'Lead Escort Motorcycle', bib: 'ESCORT-1', category: 'marshal', icon: '🏍️', speed: 22.0, progress: 0.85, status: 'Patrol' },
      { id: 'sweeper-01', name: 'Medical Recovery Van', bib: 'MED-VAN', category: 'marshal', icon: '🚐', speed: 15.0, progress: 0.20, status: 'Active' },
      { id: 'sos-rider', name: 'Hydration Staging Post', bib: '#HYDRATE', category: 'alert', icon: '💧', speed: 0.0, progress: 0.35, status: 'Staged' }
    ];
  } else if (currentAdminDomain === 'RALLY') {
    return [
      { id: 'rally-101', name: 'Procession Lead Banner', bib: '#01', category: 'lead', icon: '🚩', speed: 6.5, progress: 0.75, status: 'Active' },
      { id: 'rally-102', name: 'Cultural Float #1', bib: '#FLOAT-1', category: 'lead', icon: '🚚', speed: 5.5, progress: 0.65, status: 'Active' },
      { id: 'rally-201', name: 'Main Civic Marchers', bib: '#MARCH', category: 'peloton', icon: '👥', speed: 4.8, progress: 0.48, status: 'Active' },
      { id: 'marshal-01', name: 'Police Escort Patrol', bib: 'POLICE-1', category: 'marshal', icon: '🚓', speed: 10.0, progress: 0.88, status: 'Patrol' },
      { id: 'sos-rider', name: 'Public Address Vehicle', bib: 'PA-SYSTEM', category: 'alert', icon: '📢', speed: 0.0, progress: 0.30, status: 'Broadcasting' }
    ];
  } else {
    // CYCLOTHON default
    return [
      { id: 'rider-101', name: 'Yashraj S. (Lead Pack)', bib: '#101', category: 'lead', icon: '🥇', speed: 28.5, progress: 0.72, status: 'Active' },
      { id: 'rider-102', name: 'Aarav Deshmukh', bib: '#102', category: 'lead', icon: '🚴', speed: 27.8, progress: 0.69, status: 'Active' },
      { id: 'rider-201', name: 'Priya Verma (Peloton)', bib: '#201', category: 'peloton', icon: '🚴', speed: 24.5, progress: 0.52, status: 'Active' },
      { id: 'rider-202', name: 'Rohan Patil (Peloton)', bib: '#202', category: 'peloton', icon: '🚴', speed: 23.9, progress: 0.48, status: 'Active' },
      { id: 'marshal-01', name: 'Traffic Marshal Patrol', bib: 'MARSHAL-1', category: 'marshal', icon: '🚓', speed: 34.0, progress: 0.85, status: 'Patrol' },
      { id: 'sweeper-01', name: 'Civic Sweeper Unit', bib: 'SWEEPER', category: 'marshal', icon: '🚐', speed: 18.0, progress: 0.22, status: 'Sweeping' },
      { id: 'sos-rider', name: 'Medic Support Rider', bib: '#204', category: 'alert', icon: '🚨', speed: 0.0, progress: 0.38, status: 'Medical Staged' }
    ];
  }
}

let activeParticipantsList = getDomainParticipants();

// Initialize Live Participant Mobility Markers on 3D Map (Admin Studio)
function initLiveMobilityRadar(corridorCoords) {
  if (!map) return;

  // Clear existing participant markers
  Object.values(liveParticipantMarkers).forEach(m => m.marker.remove());
  liveParticipantMarkers = {};

  if (!isMobilityRadarActive) return;

  let line = null;
  let totalLen = 0;
  try {
    line = turf.lineString(corridorCoords);
    totalLen = turf.length(line, { units: 'kilometers' });
  } catch (e) { return; }

  activeParticipantsList = getDomainParticipants();

  activeParticipantsList.forEach(p => {
    const pt = turf.along(line, p.progress * totalLen, { units: 'kilometers' });
    const coords = pt.geometry.coordinates;

    const el = document.createElement('div');
    el.className = 'live-participant-marker';
    el.innerHTML = `
      <div class="participant-puck ${p.category}">
        <span>${p.icon}</span>
        <div class="participant-speed-tag">${p.speed > 0 ? p.speed + ' km/h' : 'ALERT'}</div>
      </div>
    `;

    el.onclick = (e) => {
      e.stopPropagation();
      trackParticipant(p.id);
    };

    const marker = new mapboxgl.Marker({ element: el, offset: [0, -10] })
      .setLngLat(coords)
      .addTo(map);

    liveParticipantMarkers[p.id] = { marker, data: { ...p }, coords };
  });
}

// Update participant positions smoothly
function updateLiveParticipantPositions(line, totalLen) {
  if (!line || totalLen <= 0) return;

  activeParticipantsList.forEach(p => {
    if (p.speed > 0) {
      const speedFactor = (p.speed / 3600) * 0.08;
      p.progress = (p.progress + speedFactor) % 1.0;
    }

    const pt = turf.along(line, p.progress * totalLen, { units: 'kilometers' });
    const coords = pt.geometry.coordinates;

    const markerObj = liveParticipantMarkers[p.id];
    if (markerObj && markerObj.marker) {
      markerObj.marker.setLngLat(coords);
      markerObj.coords = coords;

      if (followingParticipantId === p.id && map) {
        map.easeTo({ center: coords, duration: 100, easing: t => t });
        const metaEl = document.getElementById('followCamRiderMeta');
        if (metaEl) {
          const completedKm = (p.progress * totalLen).toFixed(1);
          metaEl.textContent = `Speed: ${p.speed} km/h • ${completedKm} / ${totalLen.toFixed(1)} km completed`;
        }
      }
    }
  });
}

// 🎥 1-Click "Follow Camera" (Lock-on chase camera)
function trackParticipant(riderId) {
  const p = activeParticipantsList.find(r => r.id === riderId);
  const markerObj = liveParticipantMarkers[riderId];
  if (!p || !markerObj || !map) return;

  followingParticipantId = riderId;

  const hud = document.getElementById('adminFollowCamHud');
  if (hud) hud.classList.remove('hidden');
  const titleEl = document.getElementById('followCamRiderName');
  if (titleEl) titleEl.textContent = `🎥 TRACKING: ${p.name} (${p.bib})`;

  map.flyTo({
    center: markerObj.coords,
    zoom: 16.5,
    pitch: 60,
    bearing: 30,
    duration: 1200
  });
}

function stopFollowingParticipant() {
  followingParticipantId = null;
  const hud = document.getElementById('adminFollowCamHud');
  if (hud) hud.classList.add('hidden');
}

function toggleLiveMobilityRadar() {
  toggleAdminRaceSimulation();
}

function toggleAdminRaceSimulation() {
  isMobilityRadarActive = !isMobilityRadarActive;
  const btn = document.getElementById('btnAdminSimulateRace');
  const lbl = document.getElementById('lblAdminSimulate');
  const topRadarBtn = document.getElementById('btnLiveMobilityRadar');
  const topRadarLbl = document.getElementById('radarStatusLabel');

  if (btn) btn.classList.toggle('active', isMobilityRadarActive);
  if (topRadarBtn) topRadarBtn.classList.toggle('active', isMobilityRadarActive);
  if (topRadarLbl) topRadarLbl.textContent = isMobilityRadarActive ? 'ON' : 'OFF';

  if (isMobilityRadarActive) {
    if (lbl) lbl.textContent = `Live Motion & Participant Stream (ON)`;
    updateActiveRouteSimulation();
  } else {
    if (lbl) lbl.textContent = `Start Live Participant Simulation`;
    Object.values(liveParticipantMarkers).forEach(m => m.marker.remove());
    liveParticipantMarkers = {};
    stopFollowingParticipant();
    updateActiveRouteSimulation();
  }
}

function renderEndpointsMarkers(coords) {
  if (!map || !coords || coords.length < 2) return;

  if (originPinMarker) originPinMarker.remove();
  if (destPinMarker) destPinMarker.remove();
  adminWaypointMarkers.forEach(m => m.remove());
  adminWaypointMarkers = [];

  const startPt = coords[0];
  const endPt = coords[coords.length - 1];

  const originName = currentUserRole === 'SUPERADMIN' ? (adminOrigin?.name || 'Start Point') : (commuterOrigin?.name || 'Start Point');
  const destName = currentUserRole === 'SUPERADMIN' ? (adminDest?.name || 'Finish Point') : (commuterDest?.name || 'Destination');

  // 🟢 Start Pin
  const startEl = document.createElement('div');
  startEl.className = 'commuter-pin-marker origin-pin';
  startEl.innerHTML = `<span class="pin-icon">🟢</span> <span>START: ${originName.split('(')[0]}</span>`;
  
  originPinMarker = new mapboxgl.Marker({ 
    element: startEl, 
    offset: [0, -14],
    draggable: currentUserRole === 'SUPERADMIN'
  })
    .setLngLat(startPt)
    .addTo(map);

  if (currentUserRole === 'SUPERADMIN') {
    originPinMarker.on('dragend', async () => {
      const pos = originPinMarker.getLngLat();
      pushStateToHistory();
      adminOrigin = { id: 'drag_orig', name: `🚩 [${pos.lat.toFixed(4)}, ${pos.lng.toFixed(4)}]`, lng: pos.lng, lat: pos.lat };
      adminSinglePathWaypoints[0] = [pos.lng, pos.lat];
      if (document.getElementById('adminOriginInput')) document.getElementById('adminOriginInput').value = adminOrigin.name;
      await recalculateAdminSingleRoadPath();
      renderSuperAdminSinglePath();
    });
  }

  // 🏁 Destination Pin
  const endEl = document.createElement('div');
  endEl.className = 'commuter-pin-marker dest-pin';
  endEl.innerHTML = `<span class="pin-icon">🏁</span> <span>DESTINATION: ${destName.split('(')[0]}</span>`;
  
  destPinMarker = new mapboxgl.Marker({ 
    element: endEl, 
    offset: [0, -14],
    draggable: currentUserRole === 'SUPERADMIN'
  })
    .setLngLat(endPt)
    .addTo(map);

  if (currentUserRole === 'SUPERADMIN') {
    destPinMarker.on('dragend', async () => {
      const pos = destPinMarker.getLngLat();
      pushStateToHistory();
      adminDest = { id: 'drag_dest', name: `🏁 [${pos.lat.toFixed(4)}, ${pos.lng.toFixed(4)}]`, lng: pos.lng, lat: pos.lat };
      adminSinglePathWaypoints[adminSinglePathWaypoints.length - 1] = [pos.lng, pos.lat];
      if (document.getElementById('adminDestInput')) document.getElementById('adminDestInput').value = adminDest.name;
      await recalculateAdminSingleRoadPath();
      renderSuperAdminSinglePath();
    });
  }

  // 📍 Draggable Via Waypoints (SuperAdmin Studio)
  if (currentUserRole === 'SUPERADMIN') {
    customViaPoints.forEach((vp, idx) => {
      const el = document.createElement('div');
      el.className = 'admin-via-pin';
      el.innerHTML = `<span>📍</span> <span>Via #${idx + 1}</span> <button class="btn-del-via" title="Delete Waypoint">✕</button>`;

      const viaMarker = new mapboxgl.Marker({
        element: el,
        draggable: true,
        offset: [0, -14]
      })
        .setLngLat([vp.lng, vp.lat])
        .addTo(map);

      viaMarker.on('dragend', async () => {
        const pos = viaMarker.getLngLat();
        pushStateToHistory();
        customViaPoints[idx] = { lng: pos.lng, lat: pos.lat };
        await recalculateAdminSingleRoadPath();
        renderSuperAdminSinglePath();
      });

      const delBtn = el.querySelector('.btn-del-via');
      if (delBtn) {
        delBtn.onclick = async (e) => {
          e.stopPropagation();
          pushStateToHistory();
          customViaPoints.splice(idx, 1);
          await recalculateAdminSingleRoadPath();
          renderSuperAdminSinglePath();
        };
      }

      adminWaypointMarkers.push(viaMarker);
    });
  }
}

// ========================================================================= //
// 5. SUPERADMIN SINGLE-PATH STUDIO (Electric Gold Highway Line)              //
// ========================================================================= //

function wipeAllNonAdminLayers() {
  if (!map || !map.isStyleLoaded()) return;

  const emptyLine = { type: 'Feature', geometry: { type: 'LineString', coordinates: [] } };
  const emptyCollection = { type: 'FeatureCollection', features: [] };

  ['primary', 'alt2', 'alt1'].forEach(k => {
    if (map.getLayer(`${k}-route-line`)) map.setLayoutProperty(`${k}-route-line`, 'visibility', 'none');
    if (map.getLayer(`${k}-route-casing`)) map.setLayoutProperty(`${k}-route-casing`, 'visibility', 'none');
    const src = map.getSource(`${k}-route-src`);
    if (src) src.setData(emptyLine);
  });

  if (map.getLayer('live-traffic-flow')) map.setLayoutProperty('live-traffic-flow', 'visibility', 'none');
  const trafficSrc = map.getSource('live-traffic-source');
  if (trafficSrc) trafficSrc.setData(emptyCollection);

  if (!isMobilityRadarActive) {
    if (map.getLayer('event-corridor-dots')) map.setLayoutProperty('event-corridor-dots', 'visibility', 'none');
    const corridorSrc = map.getSource('active-event-corridor-src');
    if (corridorSrc) corridorSrc.setData(emptyCollection);

    eventProcessionMarkers.forEach(m => m.remove());
    eventProcessionMarkers = [];
  }
}

async function renderSuperAdminSinglePath() {
  if (!map || !map.isStyleLoaded()) return;

  wipeAllNonAdminLayers();

  const activeEvent = DOMAIN_DATA[currentAdminDomain];

  if (!adminSinglePathWaypoints || adminSinglePathWaypoints.length < 2) {
    adminSinglePathWaypoints = [
      [adminOrigin.lng, adminOrigin.lat],
      [adminDest.lng, adminDest.lat]
    ];
    await recalculateAdminSingleRoadPath();
  }

  const src = map.getSource('admin-event-route-src');
  if (src) {
    src.setData({
      type: 'Feature',
      geometry: { type: 'LineString', coordinates: adminSinglePathCoords }
    });
  }

  ['admin-event-route-casing', 'admin-event-route-mid', 'admin-event-route-line'].forEach(id => {
    if (map.getLayer(id)) map.setLayoutProperty(id, 'visibility', 'visible');
  });

  // Highlight in vibrant Electric Gold / Amber
  if (map.getLayer('admin-event-route-mid')) map.setPaintProperty('admin-event-route-mid', 'line-color', '#FFB300');
  if (map.getLayer('admin-event-route-line')) map.setPaintProperty('admin-event-route-line', 'line-color', '#FBBF24');

  try {
    const line = turf.lineString(adminSinglePathCoords);
    const distKm = turf.length(line, { units: 'kilometers' }).toFixed(1);
    const estMins = Math.round((distKm / 20) * 60);

    document.getElementById('adminPathDist').textContent = `${distKm} km`;
    document.getElementById('adminPathTime').textContent = `${estMins} min`;
    document.getElementById('adminCheckpointsCount').textContent = activeCheckpoints.length;
    document.getElementById('adminActiveEventTitle').textContent = `🛡️ ${activeEvent.adminTitle}`;
  } catch (e) {}

  renderEndpointsMarkers(adminSinglePathCoords);
  refreshCheckpointMarkers();
  renderRoadClosures();
  updateHistoryButtons();

  // Always stream live participants & flowing dots along the SuperAdmin official path!
  if (isMobilityRadarActive && adminSinglePathCoords.length >= 2) {
    updateActiveRouteSimulation();
  }

  if (adminSinglePathCoords.length >= 2) {
    const bounds = adminSinglePathCoords.reduce((b, coord) => b.extend(coord), new mapboxgl.LngLatBounds(adminSinglePathCoords[0], adminSinglePathCoords[0]));
    map.fitBounds(bounds, { padding: { top: 90, bottom: 80, left: 450, right: 60 }, duration: 1000 });
  }
}

async function recalculateAdminSingleRoadPath() {
  wipeAllNonAdminLayers();

  sortViaPointsAlongCorridor();

  const allCoords = [
    [adminOrigin.lng, adminOrigin.lat],
    ...customViaPoints.map(vp => [vp.lng, vp.lat]),
    [adminDest.lng, adminDest.lat]
  ];

  // Remove duplicate/adjacent waypoints within 10 meters to ensure clean routing
  const filteredCoords = [allCoords[0]];
  for (let i = 1; i < allCoords.length; i++) {
    const prev = filteredCoords[filteredCoords.length - 1];
    const curr = allCoords[i];
    const d = turf.distance(turf.point(prev), turf.point(curr), { units: 'meters' });
    if (d > 10) {
      filteredCoords.push(curr);
    }
  }
  if (filteredCoords.length < 2) {
    filteredCoords.push(allCoords[allCoords.length - 1]);
  }

  const coordsStr = filteredCoords.map(c => `${c[0].toFixed(5)},${c[1].toFixed(5)}`).join(';');
  let routeGeometry = null;
  let dist = 0;
  let dur = 0;

  // Primary: driving-traffic multi-waypoint
  try {
    const url = `https://api.mapbox.com/directions/v5/mapbox/driving-traffic/${coordsStr}?geometries=geojson&overview=full&steps=true&access_token=${mapboxgl.accessToken}`;
    const resp = await fetch(url);
    const data = await resp.json();
    if (data && data.routes && data.routes.length > 0) {
      routeGeometry = data.routes[0].geometry.coordinates;
      dist = data.routes[0].distance;
      dur = data.routes[0].duration;
    }
  } catch (e) {}

  // Fallback 1: standard driving multi-waypoint
  if (!routeGeometry) {
    try {
      const urlFallback = `https://api.mapbox.com/directions/v5/mapbox/driving/${coordsStr}?geometries=geojson&overview=full&steps=true&access_token=${mapboxgl.accessToken}`;
      const resp = await fetch(urlFallback);
      const data = await resp.json();
      if (data && data.routes && data.routes.length > 0) {
        routeGeometry = data.routes[0].geometry.coordinates;
        dist = data.routes[0].distance;
        dur = data.routes[0].duration;
      }
    } catch (e) {}
  }

  // Fallback 2: leg-by-leg roadway stitching
  if (!routeGeometry) {
    routeGeometry = [];
    for (let i = 0; i < filteredCoords.length - 1; i++) {
      try {
        const legUrl = `https://api.mapbox.com/directions/v5/mapbox/driving/${filteredCoords[i][0].toFixed(5)},${filteredCoords[i][1].toFixed(5)};${filteredCoords[i+1][0].toFixed(5)},${filteredCoords[i+1][1].toFixed(5)}?geometries=geojson&overview=full&access_token=${mapboxgl.accessToken}`;
        const legResp = await fetch(legUrl);
        const legData = await legResp.json();
        if (legData && legData.routes && legData.routes.length > 0) {
          const legCoords = legData.routes[0].geometry.coordinates;
          if (routeGeometry.length > 0) legCoords.shift();
          routeGeometry.push(...legCoords);
          dist += legData.routes[0].distance;
          dur += legData.routes[0].duration;
        }
      } catch (e) {}
    }
  }

  // Fallback 3: OSRM Public Routing API
  if (!routeGeometry || routeGeometry.length < 2) {
    try {
      const osrmUrl = `https://router.project-osrm.org/route/v1/driving/${coordsStr}?overview=full&geometries=geojson&steps=true`;
      const osrmResp = await fetch(osrmUrl);
      const osrmData = await osrmResp.json();
      if (osrmData && osrmData.routes && osrmData.routes.length > 0) {
        routeGeometry = osrmData.routes[0].geometry.coordinates;
        dist = osrmData.routes[0].distance;
        dur = osrmData.routes[0].duration;
      }
    } catch (e) {}
  }

  if (routeGeometry && routeGeometry.length >= 2) {
    adminSinglePathCoords = routeGeometry;
  } else {
    adminSinglePathCoords = filteredCoords;
  }

  const src = map.getSource('admin-event-route-src');
  if (src) {
    src.setData({
      type: 'Feature',
      geometry: { type: 'LineString', coordinates: adminSinglePathCoords }
    });
  }

  const distKm = (dist > 0 ? dist / 1000 : turf.length(turf.lineString(adminSinglePathCoords), { units: 'kilometers' })).toFixed(1);
  const estMins = dur > 0 ? Math.round(dur / 60) : Math.round((parseFloat(distKm) / 20) * 60);
  if (document.getElementById('adminPathDist')) document.getElementById('adminPathDist').textContent = `${distKm} km`;
  if (document.getElementById('adminPathTime')) document.getElementById('adminPathTime').textContent = `${estMins} min`;
}

let adminHoverMarker = null;
let isDraggingAdminRoute = false;

// Clean Polyline Drag / Click Reroute Engine (Google Maps Style)
function initCleanPolylineDragListeners() {
  const hoverEl = document.createElement('div');
  hoverEl.className = 'admin-route-hover-dot';
  hoverEl.innerHTML = '<div class="hover-dot-inner"></div>';
  hoverEl.style.display = 'none';

  adminHoverMarker = new mapboxgl.Marker({ element: hoverEl, draggable: true })
    .setLngLat([adminOrigin.lng, adminOrigin.lat])
    .addTo(map);

  map.on('mousemove', 'admin-event-route-casing', (e) => {
    if (currentUserRole !== 'SUPERADMIN' && !isEditWaypointsMode) return;
    if (isDraggingAdminRoute) return;

    hoverEl.style.display = 'flex';
    adminHoverMarker.setLngLat(e.lngLat);
    map.getCanvas().style.cursor = 'grab';
  });

  map.on('mouseleave', 'admin-event-route-casing', () => {
    if (!isDraggingAdminRoute) {
      hoverEl.style.display = 'none';
      map.getCanvas().style.cursor = '';
    }
  });

  adminHoverMarker.on('dragstart', () => {
    isDraggingAdminRoute = true;
    map.getCanvas().style.cursor = 'grabbing';
    pushStateToHistory();
  });

  adminHoverMarker.on('dragend', async () => {
    isDraggingAdminRoute = false;
    hoverEl.style.display = 'none';
    map.getCanvas().style.cursor = '';

    const newLngLat = adminHoverMarker.getLngLat();
    addOrderedViaPoint(newLngLat.lng, newLngLat.lat);
  });

  map.on('click', 'admin-event-route-casing', async (e) => {
    if (currentUserRole !== 'SUPERADMIN' && !isEditWaypointsMode) return;

    e.originalEvent.stopPropagation();
    const clickLngLat = e.lngLat;
    pushStateToHistory();
    addOrderedViaPoint(clickLngLat.lng, clickLngLat.lat);
  });
}

async function addOrderedViaPoint(lng, lat) {
  customViaPoints.push({ lng, lat });
  sortViaPointsAlongCorridor();
  await recalculateAdminSingleRoadPath();
  renderSuperAdminSinglePath();
}

function sortViaPointsAlongCorridor() {
  if (customViaPoints.length <= 1) return;
  try {
    const origPt = turf.point([adminOrigin.lng, adminOrigin.lat]);
    customViaPoints.sort((a, b) => {
      const ptA = turf.point([a.lng, a.lat]);
      const ptB = turf.point([b.lng, b.lat]);
      const distA = turf.distance(origPt, ptA, { units: 'kilometers' });
      const distB = turf.distance(origPt, ptB, { units: 'kilometers' });
      return distA - distB;
    });
  } catch (e) {}
}

// History Stack Helpers (Undo / Redo)
function pushStateToHistory() {
  historyStack.push(JSON.stringify({
    adminOrigin: { ...adminOrigin },
    adminDest: { ...adminDest },
    adminSinglePathWaypoints: [...adminSinglePathWaypoints],
    customViaPoints: customViaPoints.map(vp => ({ ...vp })),
    activeCheckpoints: activeCheckpoints.map(cp => ({ ...cp })),
    roadClosures: roadClosures.map(rc => ({ ...rc }))
  }));
  redoStack = [];
  updateHistoryButtons();
}

function undoRouteAction() {
  if (historyStack.length === 0) return;
  redoStack.push(JSON.stringify({
    adminOrigin: { ...adminOrigin },
    adminDest: { ...adminDest },
    adminSinglePathWaypoints: [...adminSinglePathWaypoints],
    customViaPoints: customViaPoints.map(vp => ({ ...vp })),
    activeCheckpoints: activeCheckpoints.map(cp => ({ ...cp })),
    roadClosures: roadClosures.map(rc => ({ ...rc }))
  }));

  const prevState = JSON.parse(historyStack.pop());
  adminOrigin = prevState.adminOrigin;
  adminDest = prevState.adminDest;
  adminSinglePathWaypoints = prevState.adminSinglePathWaypoints;
  customViaPoints = prevState.customViaPoints || [];
  if (prevState.activeCheckpoints) activeCheckpoints = prevState.activeCheckpoints;
  if (prevState.roadClosures) roadClosures = prevState.roadClosures;

  if (document.getElementById('adminOriginInput')) document.getElementById('adminOriginInput').value = adminOrigin.name;
  if (document.getElementById('adminDestInput')) document.getElementById('adminDestInput').value = adminDest.name;

  recalculateAdminSingleRoadPath().then(() => {
    renderSuperAdminSinglePath();
  });
  updateHistoryButtons();
}

function redoRouteAction() {
  if (redoStack.length === 0) return;
  historyStack.push(JSON.stringify({
    adminOrigin: { ...adminOrigin },
    adminDest: { ...adminDest },
    adminSinglePathWaypoints: [...adminSinglePathWaypoints],
    customViaPoints: customViaPoints.map(vp => ({ ...vp })),
    activeCheckpoints: activeCheckpoints.map(cp => ({ ...cp })),
    roadClosures: roadClosures.map(rc => ({ ...rc }))
  }));

  const nextState = JSON.parse(redoStack.pop());
  adminOrigin = nextState.adminOrigin;
  adminDest = nextState.adminDest;
  adminSinglePathWaypoints = nextState.adminSinglePathWaypoints;
  customViaPoints = nextState.customViaPoints || [];
  if (nextState.activeCheckpoints) activeCheckpoints = nextState.activeCheckpoints;
  if (nextState.roadClosures) roadClosures = nextState.roadClosures;

  if (document.getElementById('adminOriginInput')) document.getElementById('adminOriginInput').value = adminOrigin.name;
  if (document.getElementById('adminDestInput')) document.getElementById('adminDestInput').value = adminDest.name;

  recalculateAdminSingleRoadPath().then(() => {
    renderSuperAdminSinglePath();
  });
  updateHistoryButtons();
}

function updateHistoryButtons() {
  const btnUndo = document.getElementById('btnAdminUndo');
  const btnRedo = document.getElementById('btnAdminRedo');
  if (btnUndo) btnUndo.disabled = historyStack.length === 0;
  if (btnRedo) btnRedo.disabled = redoStack.length === 0;
}

// Time-of-Day Lighting Mode Switcher
function setTimeOfDay(mode) {
  currentLightPreset = mode;
  const buttons = document.querySelectorAll('.time-btn');
  buttons.forEach(b => b.classList.remove('active'));

  try {
    map.setConfigProperty('basemap', 'lightPreset', mode);
  } catch (err) {}

  if (mode === 'dawn' && buttons[0]) buttons[0].classList.add('active');
  if (mode === 'day' && buttons[1]) buttons[1].classList.add('active');
  if (mode === 'dusk' && buttons[2]) buttons[2].classList.add('active');
  if (mode === 'night' && buttons[3]) buttons[3].classList.add('active');
}

function reset3DBearing() {
  if (map) map.easeTo({ bearing: 0, pitch: 55, duration: 800 });
}

// ========================================================================= //
// 6. 3D MAPBOX STANDARD BASE MAP SETUP                                      //
// ========================================================================= //

function initMapIfNeeded() {
  if (map) {
    map.resize();
    return;
  }

  const centerCoords = (commuterOrigin && commuterOrigin.lng) ? [commuterOrigin.lng, commuterOrigin.lat] : [79.0806, 21.1498];

  map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/standard',
    center: centerCoords,
    zoom: 13.8,
    pitch: 50,
    bearing: 15,
    antialias: true
  });

  map.addControl(new mapboxgl.NavigationControl({ visualizePitch: true }), 'bottom-right');
  map.addControl(new mapboxgl.ScaleControl({ maxWidth: 80, unit: 'metric' }), 'bottom-left');

  map.on('style.load', () => {
    try {
      map.setConfigProperty('basemap', 'lightPreset', currentLightPreset);
      map.setConfigProperty('basemap', 'showLanduse', true);
      map.setConfigProperty('basemap', 'showPointOfInterestLabels', true);
      map.setConfigProperty('basemap', 'show3dObjects', true);
    } catch (err) {}

    setupAllMapSourcesAndLayers();
    initCleanPolylineDragListeners();
    evaluateRouteConflictAndRender();
  });

  map.on('click', async (e) => {
    if (isCheckpointPlacementMode && pendingCheckpointData) {
      finalizeCheckpointPlacement(e.lngLat.lng, e.lngLat.lat);
    } else if (isRoadClosureMode) {
      placeBarricadeAt(e.lngLat.lng, e.lngLat.lat);
    } else if (isEditWaypointsMode && currentUserRole === 'SUPERADMIN') {
      pushStateToHistory();
      customViaPoints.push({ lng: e.lngLat.lng, lat: e.lngLat.lat });
      await recalculateAdminSingleRoadPath();
      renderSuperAdminSinglePath();
    }
  });
}

function setupAllMapSourcesAndLayers() {
  // 1. Live Traffic Flow Layer
  if (!map.getSource('live-traffic-source')) {
    map.addSource('live-traffic-source', { type: 'geojson', data: { type: 'FeatureCollection', features: [] } });
    map.addLayer({
      id: 'live-traffic-flow',
      type: 'line',
      source: 'live-traffic-source',
      layout: { 'line-cap': 'round', 'line-join': 'round' },
      paint: {
        'line-color': ['get', 'color'],
        'line-width': ['interpolate', ['linear'], ['zoom'], 12, 3, 16, 7],
        'line-opacity': 0.85
      }
    });
  }

  // 2. Active Route Moving Flow Particles Layer
  if (!map.getSource('active-event-corridor-src')) {
    map.addSource('active-event-corridor-src', {
      type: 'geojson',
      data: { type: 'FeatureCollection', features: [] }
    });

    map.addLayer({
      id: 'event-corridor-dots',
      type: 'circle',
      source: 'active-event-corridor-src',
      filter: ['==', '$type', 'Point'],
      paint: {
        'circle-radius': [
          'interpolate', ['linear'], ['zoom'],
          12, 3.5,
          15, 6,
          18, 8.5
        ],
        'circle-color': '#00F2FE',
        'circle-stroke-width': 1.5,
        'circle-stroke-color': '#FFFFFF',
        'circle-opacity': 0.95
      }
    });
  }

  // 3. Commuter Route Layers (Primary, Alt2, Alt1)
  ['primary', 'alt2', 'alt1'].forEach(routeKey => {
    const route = ROUTE_DATA[routeKey];
    if (!map.getSource(`${routeKey}-route-src`)) {
      map.addSource(`${routeKey}-route-src`, {
        type: 'geojson',
        data: { type: 'Feature', geometry: { type: 'LineString', coordinates: [] } }
      });

      // Dark Casing Outline
      map.addLayer({
        id: `${routeKey}-route-casing`,
        type: 'line',
        source: `${routeKey}-route-src`,
        layout: { 'line-cap': 'round', 'line-join': 'round' },
        paint: { 'line-color': '#000000', 'line-width': 12, 'line-opacity': 0.9 }
      });

      // Main Route Line
      map.addLayer({
        id: `${routeKey}-route-line`,
        type: 'line',
        source: `${routeKey}-route-src`,
        layout: { 'line-cap': 'round', 'line-join': 'round' },
        paint: {
          'line-color': route.color,
          'line-width': routeKey === currentSelectedRoute ? 8 : 5.5,
          'line-opacity': routeKey === currentSelectedRoute ? 1.0 : 0.85
        }
      });
    }
  });

  // 4. SuperAdmin Pathway (Electric Gold Route with Black Casing)
  if (!map.getSource('admin-event-route-src')) {
    map.addSource('admin-event-route-src', {
      type: 'geojson',
      data: { type: 'Feature', geometry: { type: 'LineString', coordinates: [] } }
    });

    map.addLayer({
      id: 'admin-event-route-casing',
      type: 'line',
      source: 'admin-event-route-src',
      layout: { 'line-cap': 'round', 'line-join': 'round' },
      paint: {
        'line-color': '#000000',
        'line-width': 16,
        'line-opacity': 0.95
      }
    });

    map.addLayer({
      id: 'admin-event-route-mid',
      type: 'line',
      source: 'admin-event-route-src',
      layout: { 'line-cap': 'round', 'line-join': 'round' },
      paint: {
        'line-color': '#FFB300',
        'line-width': 10,
        'line-opacity': 0.9
      }
    });

    map.addLayer({
      id: 'admin-event-route-line',
      type: 'line',
      source: 'admin-event-route-src',
      layout: { 'line-cap': 'round', 'line-join': 'round' },
      paint: {
        'line-color': '#FBBF24',
        'line-width': 5.5,
        'line-opacity': 1.0
      }
    });
  }
}

function selectRouteOption(routeId) {
  currentSelectedRoute = routeId;

  document.querySelectorAll('.gmaps-route-card').forEach(c => c.classList.remove('selected'));
  if (routeId === 'primary' && document.getElementById('optRoutePrimary')) document.getElementById('optRoutePrimary').classList.add('selected');
  if (routeId === 'alt2' && document.getElementById('optRouteAlt2')) document.getElementById('optRouteAlt2').classList.add('selected');
  if (routeId === 'alt1' && document.getElementById('optRouteAlt1')) document.getElementById('optRouteAlt1').classList.add('selected');

  if (!map || !map.isStyleLoaded()) return;

  ['primary', 'alt2', 'alt1'].forEach(k => {
    if (map.getLayer(`${k}-route-line`)) {
      const isSel = k === routeId;
      map.setPaintProperty(`${k}-route-line`, 'line-width', isSel ? 8 : 5.5);
      map.setPaintProperty(`${k}-route-line`, 'line-opacity', isSel ? 1.0 : 0.85);
      map.setPaintProperty(`${k}-route-casing`, 'line-width', isSel ? 12 : 9);
    }
  });

  const selRoute = ROUTE_DATA[routeId];
  if (selRoute && selRoute.coordinates && selRoute.coordinates.length >= 2) {
    renderEndpointsMarkers(selRoute.coordinates);
    updateActiveRouteSimulation();
  }
}

function fitMapToCurrentRoute() {
  if (!map) return;
  const coords = currentUserRole === 'SUPERADMIN' 
    ? adminSinglePathCoords 
    : ROUTE_DATA[currentSelectedRoute]?.coordinates;

  if (!coords || coords.length < 2) return;

  const bounds = coords.reduce((b, coord) => b.extend(coord), new mapboxgl.LngLatBounds(coords[0], coords[0]));
  map.fitBounds(bounds, {
    padding: { top: 90, bottom: 80, left: 450, right: 60 },
    duration: 1000,
    pitch: is3DTiltActive ? 55 : 0
  });
}

// ========================================================================= //
// 7. SUPERADMIN ACTIONS, BARRICADES & LOCATION MODAL                        //
// ========================================================================= //

function openAdminLocationModal() {
  const m = document.getElementById('adminLocationModal');
  if (m) m.classList.add('active');
  if (document.getElementById('adminModalOriginInput')) document.getElementById('adminModalOriginInput').value = adminOrigin.name;
  if (document.getElementById('adminModalDestInput')) document.getElementById('adminModalDestInput').value = adminDest.name;
}

function closeAdminLocationModal() {
  const m = document.getElementById('adminLocationModal');
  if (m) m.classList.remove('active');
}

function setAdminQuickRoute(originId, destId) {
  const o = NAGPUR_REGISTRY.find(p => p.id === originId) || NAGPUR_REGISTRY[0];
  const d = NAGPUR_REGISTRY.find(p => p.id === destId) || NAGPUR_REGISTRY[1];
  adminOrigin = o;
  adminDest = d;
  if (document.getElementById('adminModalOriginInput')) document.getElementById('adminModalOriginInput').value = o.name;
  if (document.getElementById('adminModalDestInput')) document.getElementById('adminModalDestInput').value = d.name;
}

function applyAdminModalLocations() {
  closeAdminLocationModal();
  pushStateToHistory();
  adminSinglePathWaypoints = [
    [adminOrigin.lng, adminOrigin.lat],
    [adminDest.lng, adminDest.lat]
  ];
  recalculateAdminSingleRoadPath().then(() => {
    renderSuperAdminSinglePath();
  });
}

function toggleWaypointEditMode() {
  isEditWaypointsMode = !isEditWaypointsMode;
  isRoadClosureMode = false;
  isCheckpointPlacementMode = false;

  const btn = document.getElementById('btnAdminDragPath');
  if (btn) btn.classList.toggle('active', isEditWaypointsMode);
  document.getElementById('lblAdminDrag').textContent = isEditWaypointsMode ? 'Done Adjusting' : 'Drag & Adjust Route Waypoints';

  if (isEditWaypointsMode) {
    showToast('📍 <b>Clean Polyline Dragging Active:</b> Click and drag along the glowing route line to adjust waypoints.');
  }
}

function toggleRoadClosureMode() {
  isRoadClosureMode = !isRoadClosureMode;
  isCheckpointPlacementMode = false;
  isEditWaypointsMode = false;

  const btn = document.getElementById('btnAdminBarricade');
  if (btn) btn.classList.toggle('active', isRoadClosureMode);
  document.getElementById('lblAdminClosure').textContent = isRoadClosureMode ? 'Click Road to Block' : 'Drop Police Barricade & Detour';
  document.body.classList.toggle('placing-barricade', isRoadClosureMode);

  if (isRoadClosureMode) {
    showToast('🚧 <b>Blockage Mode Active:</b> Click any road or junction to drop a police barricade.');
  }
}

async function placeBarricadeAt(lng, lat) {
  const name = prompt('Enter Barricade Location / Diversion Reason:', 'Police Barricade #1');
  if (!name) return;

  pushStateToHistory();
  roadClosures.push({ name, lat, lng, desc: 'Road Closed for Civic Event' });
  renderRoadClosures();
  playSosAudioAlert();

  isRoadClosureMode = false;
  document.body.classList.remove('placing-barricade');
  const btn = document.getElementById('btnAdminBarricade');
  if (btn) btn.classList.remove('active');
  document.getElementById('lblAdminClosure').textContent = 'Drop Police Barricade & Detour';

  customViaPoints.push({ lat: lat + 0.005, lng: lng + 0.005 });
  await recalculateAdminSingleRoadPath();
  updateHistoryButtons();

  showToast(`🚧 <b>Police Blockage Placed!</b> Route automatically detoured.`);
}

function renderRoadClosures() {
  closureMarkers.forEach(m => m.remove());
  closureMarkers = [];

  roadClosures.forEach(rc => {
    const el = document.createElement('div');
    el.innerHTML = '🚧';
    el.style.fontSize = '24px';
    el.style.cursor = 'pointer';

    const marker = new mapboxgl.Marker({ element: el })
      .setLngLat([rc.lng, rc.lat])
      .setPopup(new mapboxgl.Popup({ offset: 20 }).setHTML(`<b>${rc.name}</b><br><span style="color:#EF4444;">Closed for active civic event</span>`))
      .addTo(map);

    closureMarkers.push(marker);
  });
}

function activateCheckpointPlacement() {
  const type = document.getElementById('cpType').value;
  const name = document.getElementById('cpName').value;
  const note = document.getElementById('cpNotes').value;

  pendingCheckpointData = { type, name, note };
  isCheckpointPlacementMode = true;
  isRoadClosureMode = false;
  isEditWaypointsMode = false;
  closeCheckpointDialog();

  showToast('📍 <b>Checkpoint Mode:</b> Click anywhere along the event corridor to snap and place this checkpoint.');
}

function finalizeCheckpointPlacement(lng, lat) {
  if (!pendingCheckpointData) return;

  let finalLng = lng;
  let finalLat = lat;
  try {
    const targetLine = currentUserRole === 'SUPERADMIN' ? adminSinglePathCoords : ROUTE_DATA[currentSelectedRoute].coordinates;
    const pt = turf.point([lng, lat]);
    const line = turf.lineString(targetLine);
    const snapped = turf.nearestPointOnLine(line, pt);
    finalLng = snapped.geometry.coordinates[0];
    finalLat = snapped.geometry.coordinates[1];
  } catch (e) {}

  pushStateToHistory();
  activeCheckpoints.push({ ...pendingCheckpointData, lng: finalLng, lat: finalLat });
  refreshCheckpointMarkers();
  isCheckpointPlacementMode = false;
  pendingCheckpointData = null;

  if (document.getElementById('adminCheckpointsCount')) {
    document.getElementById('adminCheckpointsCount').textContent = activeCheckpoints.length;
  }
  updateHistoryButtons();

  showToast('✅ <b>Official Checkpoint Snapped & Placed!</b>');
}

function refreshCheckpointMarkers() {
  checkpointMarkers.forEach(m => m.remove());
  checkpointMarkers = [];

  activeCheckpoints.forEach(cp => {
    const el = document.createElement('div');
    el.className = `checkpoint-pin cp-${cp.type}`;
    const icons = { hydration: '💧', medical: '🏥', timing: '⏱️', barricade: '🚧', flagoff: '🚩', finish: '🏁' };
    el.innerHTML = icons[cp.type] || '📍';

    const marker = new mapboxgl.Marker({ element: el })
      .setLngLat([cp.lng, cp.lat])
      .setPopup(
        new mapboxgl.Popup({ offset: 25 }).setHTML(`
          <div class="cp-popup">
            <h4>${cp.name}</h4>
            <span class="cp-badge">${cp.type}</span>
            <p>${cp.note}</p>
          </div>
        `)
      )
      .addTo(map);

    checkpointMarkers.push(marker);
  });
}

function openCheckpointDialog() {
  document.getElementById('checkpointModal').classList.add('active');
}

function closeCheckpointDialog() {
  document.getElementById('checkpointModal').classList.remove('active');
}

async function saveAndPublishRoute() {
  const domainUUID = getCurrentDomainUUID();
  const domInfo = DOMAIN_DATA[currentAdminDomain];

  // Save route GeoJSON
  if (window.saveRouteGeojson && adminSinglePathCoords.length > 0) {
    const geojson = {
      type: 'FeatureCollection',
      features: [{
        type: 'Feature',
        properties: { domain: currentAdminDomain, name: domInfo.title },
        geometry: { type: 'LineString', coordinates: adminSinglePathCoords }
      }]
    };
    const { error: routeErr } = await window.saveRouteGeojson(domainUUID, geojson);
    if (routeErr) {
      alert('❌ Failed to save route: ' + routeErr.message);
      return;
    }
  }

  // Save checkpoints
  if (window.upsertCheckpoint && domInfo.checkpoints) {
    const CHECKPOINT_TYPE_MAP = {
      'flagoff': 'START', 'hydration': 'WATER_STATION', 'medical': 'MEDICAL_POST',
      'timing': 'DIVERSION', 'barricade': 'DIVERSION', 'finish': 'FINISH'
    };
    for (let i = 0; i < domInfo.checkpoints.length; i++) {
      const cp = domInfo.checkpoints[i];
      await window.upsertCheckpoint({
        domain_id: domainUUID,
        checkpoint_type: CHECKPOINT_TYPE_MAP[cp.type] || 'WATER_STATION',
        name: cp.name.replace(/^[^\w]+/, '').trim(),
        latitude: cp.lat,
        longitude: cp.lng,
        sequence_order: i + 1
      });
    }
  }

  showToast(`🔒 <b>${currentAdminDomain} Official Corridor Saved & Published!</b> All connected commuters updated.`);
}

// ========================================================================= //
// 8. REAL-TIME MAPBOX GEOCODING & UNIVERSAL SEARCH                          //
// ========================================================================= //

let geocodeDebounceTimer = null;

async function queryNagpurPlaces(query) {
  const q = (query || '').toLowerCase().trim();
  if (!q) {
    return NAGPUR_REGISTRY.slice(0, 8);
  }

  const localMatches = NAGPUR_REGISTRY.filter(p => 
    p.name.toLowerCase().includes(q) || (p.type && p.type.toLowerCase().includes(q))
  );

  try {
    const url = `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(query)}.json?proximity=79.0882,21.1458&bbox=78.75,20.80,79.40,21.45&country=IN&types=poi,address,neighborhood,locality,place&access_token=${mapboxgl.accessToken}`;
    const resp = await fetch(url);
    const data = await resp.json();

    if (data && data.features && data.features.length > 0) {
      const apiMatches = data.features.map(f => ({
        id: f.id,
        name: f.place_name.replace(', Maharashtra, India', '').replace(', India', ''),
        lng: f.center[0],
        lat: f.center[1],
        type: 'GEOCODE'
      }));

      const combined = [...localMatches];
      apiMatches.forEach(am => {
        if (!combined.some(c => c.name.toLowerCase() === am.name.toLowerCase())) {
          combined.push(am);
        }
      });
      return combined.slice(0, 10);
    }
  } catch (err) {}

  return localMatches.slice(0, 8);
}

function renderDropdownList(dropdownEl, places, isOrigin, isDark = false, isAdmin = false) {
  if (!dropdownEl) return;
  if (!places || places.length === 0) {
    dropdownEl.innerHTML = `<div style="padding: 12px; font-size: 11px; color: #94A3B8; text-align: center;">No matches found in Nagpur. Try another institute or street name.</div>`;
    dropdownEl.style.display = 'block';
    return;
  }

  const icon = isOrigin ? '🟢' : '🏁';
  const textColor = isDark ? '#F8FAFC' : '#0F172A';
  const subColor = isDark ? '#94A3B8' : '#64748B';
  const borderCol = isDark ? 'rgba(255,255,255,0.08)' : '#F1F5F9';
  const hoverBg = isDark ? '#334155' : '#F8FAFC';

  dropdownEl.innerHTML = places.map(p => `
    <div class="dropdown-item" 
         onclick="selectCustomLocation(${JSON.stringify(p).replace(/"/g, '&quot;')}, ${isOrigin}, ${isAdmin})"
         style="padding: 10px 14px; cursor: pointer; border-bottom: 1px solid ${borderCol}; display: flex; flex-direction: column; gap: 2px; transition: background 0.15s ease;"
         onmouseover="this.style.background='${hoverBg}'"
         onmouseout="this.style.background='transparent'">
      <div style="font-size: 13px; font-weight: 700; color: ${textColor}; display: flex; align-items: center; gap: 6px;">
        <span>${icon}</span> <span>${p.name}</span>
      </div>
      <span style="font-size: 10px; color: ${subColor}; padding-left: 20px;">${p.type || 'Nagpur Locality'}</span>
    </div>
  `).join('');

  dropdownEl.style.display = 'block';
}

function selectCustomLocation(place, isOrigin, isAdmin = false) {
  if (isAdmin) {
    pushStateToHistory();
    if (isOrigin) {
      adminOrigin = place;
      if (document.getElementById('adminOriginInput')) document.getElementById('adminOriginInput').value = place.name;
      if (document.getElementById('adminModalOriginInput')) document.getElementById('adminModalOriginInput').value = place.name;
      if (document.getElementById('adminOriginDropdown')) document.getElementById('adminOriginDropdown').style.display = 'none';
      if (document.getElementById('adminModalOriginDropdown')) document.getElementById('adminModalOriginDropdown').style.display = 'none';
      adminSinglePathWaypoints[0] = [place.lng, place.lat];
    } else {
      adminDest = place;
      if (document.getElementById('adminDestInput')) document.getElementById('adminDestInput').value = place.name;
      if (document.getElementById('adminModalDestInput')) document.getElementById('adminModalDestInput').value = place.name;
      if (document.getElementById('adminDestDropdown')) document.getElementById('adminDestDropdown').style.display = 'none';
      if (document.getElementById('adminModalDestDropdown')) document.getElementById('adminModalDestDropdown').style.display = 'none';
      adminSinglePathWaypoints[adminSinglePathWaypoints.length - 1] = [place.lng, place.lat];
    }
    recalculateAdminSingleRoadPath().then(() => {
      renderSuperAdminSinglePath();
    });
    return;
  }

  // Commuter Selection
  if (isOrigin) {
    commuterOrigin = place;
    if (document.getElementById('heroOriginInput')) document.getElementById('heroOriginInput').value = place.name;
    if (document.getElementById('filterStartInput')) document.getElementById('filterStartInput').value = place.name;
    if (document.getElementById('mapOriginInput')) document.getElementById('mapOriginInput').value = place.name;
    
    if (document.getElementById('heroOriginDropdown')) document.getElementById('heroOriginDropdown').style.display = 'none';
    if (document.getElementById('filterOriginDropdown')) document.getElementById('filterOriginDropdown').style.display = 'none';
    if (document.getElementById('mapOriginDropdown')) document.getElementById('mapOriginDropdown').style.display = 'none';
  } else {
    commuterDest = place;
    if (document.getElementById('heroDestInput')) document.getElementById('heroDestInput').value = place.name;
    if (document.getElementById('filterEndInput')) document.getElementById('filterEndInput').value = place.name;
    if (document.getElementById('mapDestInput')) document.getElementById('mapDestInput').value = place.name;

    if (document.getElementById('heroDestDropdown')) document.getElementById('heroDestDropdown').style.display = 'none';
    if (document.getElementById('filterDestDropdown')) document.getElementById('filterDestDropdown').style.display = 'none';
    if (document.getElementById('mapDestDropdown')) document.getElementById('mapDestDropdown').style.display = 'none';
  }

  if (currentView === 'map' && map) {
    evaluateRouteConflictAndRender();
  }
}

// Hero Search Handlers
function handleHeroOriginSearch(e) {
  clearTimeout(geocodeDebounceTimer);
  const val = e.target.value;
  geocodeDebounceTimer = setTimeout(async () => {
    const places = await queryNagpurPlaces(val);
    renderDropdownList(document.getElementById('heroOriginDropdown'), places, true, true, false);
  }, 150);
}

function handleHeroDestSearch(e) {
  clearTimeout(geocodeDebounceTimer);
  const val = e.target.value;
  geocodeDebounceTimer = setTimeout(async () => {
    const places = await queryNagpurPlaces(val);
    renderDropdownList(document.getElementById('heroDestDropdown'), places, false, true, false);
  }, 150);
}

// Filter Bar Search Handlers
function handleFilterOriginSearch(e) {
  clearTimeout(geocodeDebounceTimer);
  const val = e.target.value;
  geocodeDebounceTimer = setTimeout(async () => {
    const places = await queryNagpurPlaces(val);
    renderDropdownList(document.getElementById('filterOriginDropdown'), places, true, false, false);
  }, 150);
}

function handleFilterDestSearch(e) {
  clearTimeout(geocodeDebounceTimer);
  const val = e.target.value;
  geocodeDebounceTimer = setTimeout(async () => {
    const places = await queryNagpurPlaces(val);
    renderDropdownList(document.getElementById('filterDestDropdown'), places, false, false, false);
  }, 150);
}

// Map Commuter Search Handlers
function handleMapOriginSearch(e) {
  clearTimeout(geocodeDebounceTimer);
  const val = e.target.value;
  geocodeDebounceTimer = setTimeout(async () => {
    const places = await queryNagpurPlaces(val);
    renderDropdownList(document.getElementById('mapOriginDropdown'), places, true, true, false);
  }, 150);
}

function handleMapDestSearch(e) {
  clearTimeout(geocodeDebounceTimer);
  const val = e.target.value;
  geocodeDebounceTimer = setTimeout(async () => {
    const places = await queryNagpurPlaces(val);
    renderDropdownList(document.getElementById('mapDestDropdown'), places, false, true, false);
  }, 150);
}

// Direct SuperAdmin Search Handlers in Panel
function handleAdminOriginSearch(e) {
  clearTimeout(geocodeDebounceTimer);
  const val = e.target.value;
  geocodeDebounceTimer = setTimeout(async () => {
    const places = await queryNagpurPlaces(val);
    renderDropdownList(document.getElementById('adminOriginDropdown'), places, true, true, true);
  }, 150);
}

function handleAdminDestSearch(e) {
  clearTimeout(geocodeDebounceTimer);
  const val = e.target.value;
  geocodeDebounceTimer = setTimeout(async () => {
    const places = await queryNagpurPlaces(val);
    renderDropdownList(document.getElementById('adminDestDropdown'), places, false, true, true);
  }, 150);
}

function swapAdminLocations() {
  const temp = adminOrigin;
  adminOrigin = adminDest;
  adminDest = temp;
  if (document.getElementById('adminOriginInput')) document.getElementById('adminOriginInput').value = adminOrigin.name;
  if (document.getElementById('adminDestInput')) document.getElementById('adminDestInput').value = adminDest.name;
  pushStateToHistory();
  adminSinglePathWaypoints = [
    [adminOrigin.lng, adminOrigin.lat],
    [adminDest.lng, adminDest.lat]
  ];
  recalculateAdminSingleRoadPath().then(() => {
    renderSuperAdminSinglePath();
  });
}

function setAdminDirectQuickRoute(origId, destId) {
  const o = NAGPUR_REGISTRY.find(p => p.id === origId) || NAGPUR_REGISTRY[0];
  const d = NAGPUR_REGISTRY.find(p => p.id === destId) || NAGPUR_REGISTRY[1];
  adminOrigin = o;
  adminDest = d;
  if (document.getElementById('adminOriginInput')) document.getElementById('adminOriginInput').value = o.name;
  if (document.getElementById('adminDestInput')) document.getElementById('adminDestInput').value = d.name;
  pushStateToHistory();
  adminSinglePathWaypoints = [
    [adminOrigin.lng, adminOrigin.lat],
    [adminDest.lng, adminDest.lat]
  ];
  recalculateAdminSingleRoadPath().then(() => {
    renderSuperAdminSinglePath();
  });
}

// SuperAdmin Modal Search Handlers
function handleAdminModalOriginSearch(e) {
  clearTimeout(geocodeDebounceTimer);
  const val = e.target.value;
  geocodeDebounceTimer = setTimeout(async () => {
    const places = await queryNagpurPlaces(val);
    renderDropdownList(document.getElementById('adminModalOriginDropdown'), places, true, true, true);
  }, 150);
}

function handleAdminModalDestSearch(e) {
  clearTimeout(geocodeDebounceTimer);
  const val = e.target.value;
  geocodeDebounceTimer = setTimeout(async () => {
    const places = await queryNagpurPlaces(val);
    renderDropdownList(document.getElementById('adminModalDestDropdown'), places, false, true, true);
  }, 150);
}

// Close dropdowns on outside click
document.addEventListener('click', (e) => {
  if (!e.target.closest('.hero-input-group') && !e.target.closest('.filter-search-wrap') && !e.target.closest('.gmaps-input-field') && !e.target.closest('.admin-input-wrap')) {
    ['heroOriginDropdown', 'heroDestDropdown', 'filterOriginDropdown', 'filterDestDropdown', 'mapOriginDropdown', 'mapDestDropdown', 'adminOriginDropdown', 'adminDestDropdown', 'adminModalOriginDropdown', 'adminModalDestDropdown'].forEach(id => {
      const el = document.getElementById(id);
      if (el) el.style.display = 'none';
    });
  }
});

function swapHeroLocations() {
  const temp = commuterOrigin;
  commuterOrigin = commuterDest;
  commuterDest = temp;
  if (document.getElementById('heroOriginInput')) document.getElementById('heroOriginInput').value = commuterOrigin?.name || '';
  if (document.getElementById('heroDestInput')) document.getElementById('heroDestInput').value = commuterDest?.name || '';
  if (document.getElementById('filterStartInput')) document.getElementById('filterStartInput').value = commuterOrigin?.name || '';
  if (document.getElementById('filterEndInput')) document.getElementById('filterEndInput').value = commuterDest?.name || '';
}

async function executeHeroDualSearch() {
  const origText = document.getElementById('heroOriginInput')?.value.trim();
  const destText = document.getElementById('heroDestInput')?.value.trim();

  if (origText) {
    const places = await queryNagpurPlaces(origText);
    if (places && places.length > 0) commuterOrigin = places[0];
  }
  if (destText) {
    const places = await queryNagpurPlaces(destText);
    if (places && places.length > 0) commuterDest = places[0];
  }

  openMapAsGuest();
}

function setQuickRoute(originId, destId) {
  const o = NAGPUR_REGISTRY.find(p => p.id === originId) || NAGPUR_REGISTRY[0];
  const d = NAGPUR_REGISTRY.find(p => p.id === destId) || NAGPUR_REGISTRY[1];
  commuterOrigin = o;
  commuterDest = d;
  if (document.getElementById('heroOriginInput')) document.getElementById('heroOriginInput').value = o.name;
  if (document.getElementById('heroDestInput')) document.getElementById('heroDestInput').value = d.name;
  if (document.getElementById('filterStartInput')) document.getElementById('filterStartInput').value = o.name;
  if (document.getElementById('filterEndInput')) document.getElementById('filterEndInput').value = d.name;
  openMapAsGuest();
}

function updateModeFromFilter() {
  commuteMode = document.getElementById('filterMode').value;
  setDrawerMode(commuteMode);
}

async function launchLiveMapFromFilter() {
  const origText = document.getElementById('filterStartInput')?.value.trim();
  const destText = document.getElementById('filterEndInput')?.value.trim();

  updateModeFromFilter();

  if (origText) {
    const places = await queryNagpurPlaces(origText);
    if (places && places.length > 0) commuterOrigin = places[0];
  }
  if (destText) {
    const places = await queryNagpurPlaces(destText);
    if (places && places.length > 0) commuterDest = places[0];
  }

  openMapAsGuest();
}

function swapMapLocations() {
  const temp = commuterOrigin;
  commuterOrigin = commuterDest;
  commuterDest = temp;
  if (document.getElementById('mapOriginInput')) document.getElementById('mapOriginInput').value = commuterOrigin?.name || '';
  if (document.getElementById('mapDestInput')) document.getElementById('mapDestInput').value = commuterDest?.name || '';
  if (document.getElementById('heroOriginInput')) document.getElementById('heroOriginInput').value = commuterOrigin?.name || '';
  if (document.getElementById('heroDestInput')) document.getElementById('heroDestInput').value = commuterDest?.name || '';
  if (document.getElementById('filterStartInput')) document.getElementById('filterStartInput').value = commuterOrigin?.name || '';
  if (document.getElementById('filterEndInput')) document.getElementById('filterEndInput').value = commuterDest?.name || '';
  recalculateMapRoute();
}

async function recalculateMapRoute() {
  evaluateRouteConflictAndRender();
}

function dismissConflictCard() {
  const conflictCard = document.getElementById('eventConflictCard');
  if (conflictCard) conflictCard.classList.add('hidden');
}

function previewEventOnMap(domainId) {
  selectAdminDomain(domainId);
  openMapAsGuest();
}

// ========================================================================= //
// 9. VIEW & SUPERADMIN AUTHENTICATION FLOW                                  //
// ========================================================================= //

function switchView(viewName) {
  currentView = viewName;
  document.querySelectorAll('.page-view').forEach(v => v.classList.remove('active'));

  if (viewName === 'landing') {
    document.getElementById('landingView').classList.add('active');
    document.body.className = 'view-landing';
    if (map) map.stop();
  } else if (viewName === 'map') {
    document.getElementById('mapView').classList.add('active');
    document.body.className = 'view-map';
    initMapIfNeeded();
    setTimeout(() => { if (map) map.resize(); }, 50);
  }
}

function openMapAsGuest() {
  currentUserRole = 'GUEST';
  const badge = document.getElementById('adminIndicatorBadge');
  if (badge) badge.classList.add('hidden');
  const commuterView = document.getElementById('commuterViewContainer');
  if (commuterView) commuterView.classList.remove('hidden');
  const adminView = document.getElementById('superAdminViewContainer');
  if (adminView) adminView.classList.add('hidden');
  const modes = document.getElementById('commuterTransitModes');
  if (modes) modes.classList.remove('hidden');
  closeLoginModal();
  switchView('map');
  evaluateRouteConflictAndRender();
}

function openLoginModal() {
  document.getElementById('loginModal').classList.add('active');
  selectAdminDomain(currentAdminDomain);
}

function closeLoginModal() {
  document.getElementById('loginModal').classList.remove('active');
  backToPhoneStep();
}

async function selectAdminDomain(domainId) {
  currentAdminDomain = domainId;
  const domInfo = DOMAIN_DATA[domainId];
  if (!domInfo) return;

  const tabC = document.getElementById('domTabCyclothon');
  const tabM = document.getElementById('domTabMarathon');
  const tabR = document.getElementById('domTabRally');
  if (tabC) tabC.classList.toggle('active', domainId === 'CYCLOTHON');
  if (tabM) tabM.classList.toggle('active', domainId === 'MARATHON');
  if (tabR) tabR.classList.toggle('active', domainId === 'RALLY');

  const desc = document.getElementById('domainDescription');
  if (desc) desc.innerHTML = `Managing <b>${domInfo.title}</b> corridor, 3D waypoints, checkpoints & civic alerts.`;

  activeCheckpoints = [...(domInfo.checkpoints || [])];
  customViaPoints = [];
  adminOrigin = { ...domInfo.defaultOrigin };
  adminDest = { ...domInfo.defaultDest };

  if (document.getElementById('adminOriginInput')) document.getElementById('adminOriginInput').value = adminOrigin.name;
  if (document.getElementById('adminDestInput')) document.getElementById('adminDestInput').value = adminDest.name;

  adminSinglePathWaypoints = [
    [adminOrigin.lng, adminOrigin.lat],
    [adminDest.lng, adminDest.lat]
  ];

  if (currentUserRole === 'SUPERADMIN' && map && map.isStyleLoaded()) {
    await recalculateAdminSingleRoadPath();
    renderSuperAdminSinglePath();
  }
}

async function requestAdminOtp() {
  const phone = document.getElementById('adminPhoneInput').value.trim();
  if (!phone || phone.length < 10) {
    alert('Please enter a valid 10-digit mobile number.');
    return;
  }

  currentAdminPhone = phone;
  const fullPhone = '+91' + phone;

  const statusMsg = document.getElementById('authStatusMsg');
  if (statusMsg) statusMsg.textContent = '📲 Generating OTP...';

  // Request Supabase Auth
  if (window.supabaseSignInWithOtp) {
    await window.supabaseSignInWithOtp(fullPhone);
  }

  generatedOtp = Math.floor(100000 + Math.random() * 900000).toString();

  document.getElementById('otpSentPhone').textContent = `+91 ${phone}`;
  document.getElementById('phoneStepView').classList.add('hidden');
  document.getElementById('otpStepView').classList.remove('hidden');

  if (statusMsg) statusMsg.textContent = `📲 Verification Code: [ ${generatedOtp} ]`;
  
  for (let i = 1; i <= 6; i++) {
    const digitEl = document.getElementById(`otp${i}`);
    if (digitEl) digitEl.value = generatedOtp[i - 1];
  }

  setTimeout(() => {
    const otp1 = document.getElementById('otp1');
    if (otp1) otp1.focus();
  }, 100);
}

function backToPhoneStep() {
  document.getElementById('otpStepView').classList.add('hidden');
  document.getElementById('phoneStepView').classList.remove('hidden');
  const statusMsg = document.getElementById('authStatusMsg');
  if (statusMsg) statusMsg.textContent = '';
  for (let i = 1; i <= 6; i++) {
    const digitEl = document.getElementById(`otp${i}`);
    if (digitEl) digitEl.value = '';
  }
}

function handleOtpInput(index, event) {
  const val = event.target.value;
  if (val && index < 6) {
    const next = document.getElementById(`otp${index + 1}`);
    if (next) next.focus();
  }
}

function handleOtpBackspace(index, event) {
  if (event.key === 'Backspace' && !event.target.value && index > 1) {
    const prev = document.getElementById(`otp${index - 1}`);
    if (prev) prev.focus();
  }
}

async function verifyAdminOtp() {
  let enteredOtp = '';
  for (let i = 1; i <= 6; i++) {
    const digitEl = document.getElementById(`otp${i}`);
    if (digitEl) enteredOtp += digitEl.value;
  }

  if (enteredOtp.length < 6) {
    alert('Please enter the complete 6-digit OTP.');
    return;
  }

  const statusMsg = document.getElementById('authStatusMsg');
  if (statusMsg) statusMsg.textContent = '🔐 Verifying...';

  const fullPhone = '+91' + currentAdminPhone;

  // Verify OTP matches the generated access code
  if (generatedOtp && enteredOtp !== generatedOtp) {
    if (statusMsg) statusMsg.textContent = '❌ Invalid OTP. Please enter the code shown above.';
    return;
  }

  // Verify SuperAdmin status directly against database
  if (window.supabaseCheckSuperAdmin) {
    const domainUUID = getCurrentDomainUUID();
    const adminCheck = await window.supabaseCheckSuperAdmin(currentAdminPhone, domainUUID);
    if (adminCheck && (adminCheck.error || !adminCheck.data)) {
      if (statusMsg) statusMsg.textContent = `❌ ${adminCheck.error ? adminCheck.error.message : 'Access Denied: Not authorized as SuperAdmin.'}`;
      return;
    }
  }

  currentUserRole = 'SUPERADMIN';
  closeLoginModal();

  const badge = document.getElementById('adminIndicatorBadge');
  if (badge) badge.classList.remove('hidden');
  const emailDisplay = document.getElementById('adminEmailDisplay');
  if (emailDisplay) emailDisplay.textContent = `SUPERADMIN (${currentAdminDomain}) • +91 ${currentAdminPhone}`;

  const commuterView = document.getElementById('commuterViewContainer');
  if (commuterView) commuterView.classList.add('hidden');
  const adminView = document.getElementById('superAdminViewContainer');
  if (adminView) adminView.classList.remove('hidden');
  const modes = document.getElementById('commuterTransitModes');
  if (modes) modes.classList.add('hidden');

  switchView('map');
  evaluateRouteConflictAndRender();

  showToast(`🔓 <b>SuperAdmin Authenticated!</b> Welcome to ${DOMAIN_DATA[currentAdminDomain].title} Command Studio.`);
}

async function logoutAdmin() {
  // Sign out from Supabase
  if (window.supabaseSignOut) await window.supabaseSignOut();

  currentUserRole = 'GUEST';
  currentAdminPhone = null;

  // Clear dashboard refresh
  if (dashboardRefreshInterval) {
    clearInterval(dashboardRefreshInterval);
    dashboardRefreshInterval = null;
  }

  const badge = document.getElementById('adminIndicatorBadge');
  if (badge) badge.classList.add('hidden');
  const commuterView = document.getElementById('commuterViewContainer');
  if (commuterView) commuterView.classList.remove('hidden');
  const adminView = document.getElementById('superAdminViewContainer');
  if (adminView) adminView.classList.add('hidden');
  const modes = document.getElementById('commuterTransitModes');
  if (modes) modes.classList.remove('hidden');
  isEditWaypointsMode = false;
  evaluateRouteConflictAndRender();
  showToast('👤 Logged out from SuperAdmin. Returned to Commuter Mode.');
}

// ========================================================================= //
// 9. HIGH-PRECISION GPS ENGINE & REVERSE-GEOCODING                          //
// ========================================================================= //

// Reverse-geocode GPS coordinates via Mapbox API to get landmark/street name
async function reverseGeocodeCoords(lng, lat) {
  try {
    const url = `https://api.mapbox.com/geocoding/v5/mapbox.places/${lng.toFixed(6)},${lat.toFixed(6)}.json?proximity=79.0882,21.1458&country=IN&types=poi,address,neighborhood,locality,place&access_token=${mapboxgl.accessToken}`;
    const res = await fetch(url);
    const data = await res.json();
    if (data.features && data.features.length > 0) {
      const feat = data.features[0];
      const placeName = feat.text || feat.place_name.split(',')[0];
      const context = data.features.find(f => f.id.includes('neighborhood') || f.id.includes('locality'));
      const locality = context ? context.text : 'Nagpur';
      return `📍 ${placeName}, ${locality}`;
    }
  } catch (e) {
    console.warn('Reverse geocoding error:', e);
  }
  return `📍 Live GPS Location [${lat.toFixed(4)}, ${lng.toFixed(4)}]`;
}

// Live GPS Device Location Feature for Origin OR Destination
async function useCurrentGpsLocation(target = 'origin') {
  if (!navigator.geolocation) {
    alert('Geolocation is not supported by your browser.');
    return;
  }

  const inputEl = target === 'dest' ? document.getElementById('mapDestInput') : document.getElementById('mapOriginInput');
  if (inputEl) inputEl.placeholder = 'Acquiring high-accuracy GPS...';

  navigator.geolocation.getCurrentPosition(
    async (pos) => {
      const lat = pos.coords.latitude;
      const lng = pos.coords.longitude;
      
      const readableName = await reverseGeocodeCoords(lng, lat);
      const place = {
        id: 'gps_live_' + target,
        name: readableName,
        lng,
        lat
      };

      if (target === 'dest') {
        commuterDest = place;
        if (document.getElementById('mapDestInput')) document.getElementById('mapDestInput').value = place.name;
        if (document.getElementById('heroDestInput')) document.getElementById('heroDestInput').value = place.name;
        if (document.getElementById('filterEndInput')) document.getElementById('filterEndInput').value = place.name;
      } else {
        commuterOrigin = place;
        if (document.getElementById('mapOriginInput')) document.getElementById('mapOriginInput').value = place.name;
        if (document.getElementById('heroOriginInput')) document.getElementById('heroOriginInput').value = place.name;
        if (document.getElementById('filterStartInput')) document.getElementById('filterStartInput').value = place.name;
      }

      if (map) {
        updateGpsMarkerOnMap([lng, lat]);
        map.flyTo({ center: [lng, lat], zoom: 15, pitch: 50, duration: 1200 });
      }

      if (currentView === 'map' && map) {
        evaluateRouteConflictAndRender();
      }
    },
    (err) => {
      console.warn('GPS location fallback:', err.message);
      const fallbackLng = 79.0520;
      const fallbackLat = 21.1280;
      const place = {
        id: 'gps_live_' + target,
        name: `📍 VNIT Campus (Nagpur GPS)`,
        lng: fallbackLng,
        lat: fallbackLat
      };
      if (target === 'dest') {
        commuterDest = place;
        if (document.getElementById('mapDestInput')) document.getElementById('mapDestInput').value = place.name;
        if (document.getElementById('heroDestInput')) document.getElementById('heroDestInput').value = place.name;
        if (document.getElementById('filterEndInput')) document.getElementById('filterEndInput').value = place.name;
      } else {
        commuterOrigin = place;
        if (document.getElementById('mapOriginInput')) document.getElementById('mapOriginInput').value = place.name;
        if (document.getElementById('heroOriginInput')) document.getElementById('heroOriginInput').value = place.name;
        if (document.getElementById('filterStartInput')) document.getElementById('filterStartInput').value = place.name;
      }
      if (currentView === 'map' && map) evaluateRouteConflictAndRender();
    },
    { enableHighAccuracy: true, timeout: 8000, maximumAge: 10000 }
  );
}

// Dedicated "📍 Locate Me" function for the floating map button
function centerOnUserGpsLocation() {
  if (!navigator.geolocation) {
    alert('Geolocation is not supported by your browser.');
    return;
  }

  const btn = document.getElementById('btnLocateMe');
  if (btn) btn.classList.add('active');

  navigator.geolocation.getCurrentPosition(
    async (pos) => {
      const lat = pos.coords.latitude;
      const lng = pos.coords.longitude;
      
      updateGpsMarkerOnMap([lng, lat]);
      
      if (map) {
        map.flyTo({
          center: [lng, lat],
          zoom: 16.5,
          pitch: 55,
          bearing: 15,
          duration: 1500,
          essential: true
        });
      }

      const placeName = await reverseGeocodeCoords(lng, lat);
      console.log('📍 User located at:', placeName, [lng, lat]);

      setTimeout(() => {
        if (btn) btn.classList.remove('active');
      }, 1500);
    },
    (err) => {
      console.warn('GPS Locate Error:', err.message);
      if (map) {
        updateGpsMarkerOnMap([79.0806, 21.1498]);
        map.flyTo({ center: [79.0806, 21.1498], zoom: 16, pitch: 55, duration: 1200 });
      }
      if (btn) btn.classList.remove('active');
      alert(`📍 Centered at Nagpur Zero Mile Monument. (${err.message})`);
    },
    { enableHighAccuracy: true, timeout: 6000 }
  );
}

function updateGpsMarkerOnMap(lngLat) {
  if (!map) return;
  if (!gpsMarker) {
    const gpsDot = document.createElement('div');
    gpsDot.className = 'gps-live-dot';
    gpsDot.innerHTML = '<div class="gps-pulse"></div><div class="gps-center"></div>';
    gpsMarker = new mapboxgl.Marker({ element: gpsDot, anchor: 'center' })
      .setLngLat(lngLat)
      .addTo(map);
  } else {
    gpsMarker.setLngLat(lngLat);
  }
}

// ========================================================================= //
// 10. SOS ALERTS, NAVIGATION & 3D CAR SIMULATION                            //
// ========================================================================= //

function openSosBroadcastModal() {
  const m = document.getElementById('sosModal');
  if (m) m.classList.add('active');
}

function closeSosModal() {
  const m = document.getElementById('sosModal');
  if (m) m.classList.remove('active');
}

async function dispatchSosAlert() {
  const severity = document.getElementById('sosSeverity').value;
  const location = document.getElementById('sosLocation').value;
  const message = document.getElementById('sosMessage').value;

  closeSosModal();
  playSosAudioAlert();

  const banner = document.getElementById('commuterAlertBanner');
  document.getElementById('bannerBadge').textContent = `${severity} CIVIC BROADCAST (${currentAdminDomain})`;
  document.getElementById('bannerHeadline').textContent = `Alert at ${location}`;
  document.getElementById('bannerMessage').textContent = message;
  banner.classList.remove('hidden');

  showToast(`🚨 <b>Emergency Alert Dispatched</b> to all Nagpur Commuters!`);
}

function dismissCommuterAlert() {
  document.getElementById('commuterAlertBanner').classList.add('hidden');
}

function playSosAudioAlert() {
  try {
    if (!audioCtx) audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    const osc = audioCtx.createOscillator();
    const gain = audioCtx.createGain();
    osc.type = 'sine';
    osc.frequency.setValueAtTime(880, audioCtx.currentTime);
    osc.frequency.exponentialRampToValueAtTime(440, audioCtx.currentTime + 0.5);
    gain.gain.setValueAtTime(0.3, audioCtx.currentTime);
    gain.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 0.6);
    osc.connect(gain);
    gain.connect(audioCtx.destination);
    osc.start();
    osc.stop(audioCtx.currentTime + 0.6);
  } catch (e) {}
}

function startNavigation(routeId = currentSelectedRoute, event) {
  if (event) event.stopPropagation();
  selectRouteOption(routeId);

  isNavigating = true;
  document.getElementById('navBanner').classList.remove('hidden');
  document.getElementById('navTelemetryHud').classList.remove('hidden');

  const route = ROUTE_DATA[routeId];
  if (route) {
    document.getElementById('navStreetName').textContent = route.via || 'Direct Corridor';
    document.getElementById('navSubInstruction').textContent = `Navigate towards ${commuterDest?.name || 'Destination'}`;
    document.getElementById('hudRemainDist').textContent = route.distance || '-- km';
    document.getElementById('hudRemainTime').textContent = route.duration || '-- min';
  }

  startLiveGpsTracking();
  simulateFullRide(routeId);
}

function stopNavigation() {
  isNavigating = false;
  document.getElementById('navBanner').classList.add('hidden');
  document.getElementById('navTelemetryHud').classList.add('hidden');

  if (navSimulationInterval) {
    cancelAnimationFrame(navSimulationInterval);
    navSimulationInterval = null;
  }
  if (liveVehicleMarker) {
    liveVehicleMarker.remove();
    liveVehicleMarker = null;
  }
  stopLiveGpsTracking();
}

function simulateFullRide(routeId = currentSelectedRoute) {
  const allCoords = currentUserRole === 'SUPERADMIN' 
    ? adminSinglePathCoords 
    : (ROUTE_DATA[routeId]?.coordinates || ROUTE_DATA[currentSelectedRoute]?.coordinates);
    
  if (!allCoords || allCoords.length < 2) return;

  if (navSimulationInterval) {
    cancelAnimationFrame(navSimulationInterval);
    navSimulationInterval = null;
  }

  let line = null;
  let totalLen = 0;
  try {
    line = turf.lineString(allCoords);
    totalLen = turf.length(line, { units: 'kilometers' });
  } catch (e) { return; }

  if (totalLen <= 0) return;

  // Show navigation HUD during simulation
  isNavigating = true;
  const navBanner = document.getElementById('navBanner');
  const navHud = document.getElementById('navTelemetryHud');
  if (navBanner) navBanner.classList.remove('hidden');
  if (navHud) navHud.classList.remove('hidden');

  const route = ROUTE_DATA[routeId] || ROUTE_DATA.primary;
  const totalMins = parseInt(route.duration) || 15;
  const destLabel = currentUserRole === 'SUPERADMIN' ? (adminDest?.name || 'Finish Line') : (commuterDest?.name || 'Destination');
  if (document.getElementById('navStreetName')) document.getElementById('navStreetName').textContent = route.via || 'Direct Corridor';
  if (document.getElementById('navSubInstruction')) document.getElementById('navSubInstruction').textContent = `Driving towards ${destLabel}`;

  if (liveVehicleMarker) liveVehicleMarker.remove();

  const vehicleIcon = commuteMode === 'cycling' ? '🚴' : (commuteMode === 'walking' ? '🚶' : '🚗');
  const el = document.createElement('div');
  el.className = 'navigation-car-marker';
  el.innerHTML = `
    <div style="font-size:32px; filter: drop-shadow(0 4px 10px rgba(0,0,0,0.8)); transform-origin: center;">
      ${vehicleIcon}
    </div>
  `;

  const startPt = allCoords[0];
  liveVehicleMarker = new mapboxgl.Marker({ element: el, anchor: 'center' })
    .setLngLat(startPt)
    .addTo(map);

  let rideProgress = 0;
  let lastRideTime = performance.now();
  const rideDurationMs = 16000; // 16 seconds complete immersive ride

  function rideStep(now) {
    if (!isNavigating || !map) {
      navSimulationInterval = null;
      return;
    }

    const dt = Math.min((now - lastRideTime) / rideDurationMs, 0.05);
    lastRideTime = now;
    rideProgress += dt;

    if (rideProgress >= 1.0) {
      rideProgress = 1.0;
      const endPt = allCoords[allCoords.length - 1];
      liveVehicleMarker.setLngLat(endPt);
      if (document.getElementById('hudRemainDist')) document.getElementById('hudRemainDist').textContent = '0.0 km';
      if (document.getElementById('hudRemainTime')) document.getElementById('hudRemainTime').textContent = 'Arrived';
      if (document.getElementById('navSubInstruction')) document.getElementById('navSubInstruction').textContent = '🏁 Destination Reached!';
      
      setTimeout(() => {
        if (!isNavigating) return;
        stopNavigation();
      }, 2500);
      return;
    }

    try {
      const currentDist = rideProgress * totalLen;
      const pt = turf.along(line, currentDist, { units: 'kilometers' }).geometry.coordinates;
      const nextDist = Math.min(totalLen, currentDist + 0.05);
      const nextPt = turf.along(line, nextDist, { units: 'kilometers' }).geometry.coordinates;
      
      const bearing = turf.bearing(turf.point(pt), turf.point(nextPt));

      liveVehicleMarker.setLngLat(pt);
      el.style.transform = `rotate(${bearing}deg)`;

      map.easeTo({
        center: pt,
        zoom: 16.8,
        pitch: 58,
        bearing: bearing,
        duration: 100,
        easing: t => t
      });

      // Update telemetry
      const remKm = (totalLen * (1 - rideProgress)).toFixed(1);
      const remMin = Math.max(1, Math.round(totalMins * (1 - rideProgress)));
      const speed = Math.floor(40 + Math.sin(rideProgress * 10) * 12);

      if (document.getElementById('hudSpeed')) document.getElementById('hudSpeed').textContent = speed;
      if (document.getElementById('hudRemainDist')) document.getElementById('hudRemainDist').textContent = `${remKm} km`;
      if (document.getElementById('hudRemainTime')) document.getElementById('hudRemainTime').textContent = `${remMin} min`;
      if (document.getElementById('navDistLabel')) document.getElementById('navDistLabel').textContent = `${Math.round(parseFloat(remKm) * 1000)} m`;
    } catch (e) {}

    navSimulationInterval = requestAnimationFrame(rideStep);
  }

  navSimulationInterval = requestAnimationFrame(rideStep);
}

function startLiveGpsTracking() {
  if (!navigator.geolocation) return;

  gpsWatchId = navigator.geolocation.watchPosition(
    (pos) => {
      const lngLat = [pos.coords.longitude, pos.coords.latitude];

      if (!gpsMarker && map) {
        const gpsDot = document.createElement('div');
        gpsDot.className = 'gps-live-dot';
        gpsDot.innerHTML = '<div class="gps-pulse"></div><div class="gps-center"></div>';
        gpsMarker = new mapboxgl.Marker({ element: gpsDot, anchor: 'center' })
          .setLngLat(lngLat)
          .addTo(map);
      } else if (gpsMarker) {
        gpsMarker.setLngLat(lngLat);
      }

      if (isNavigating && map) {
        map.easeTo({ center: lngLat, duration: 800 });
      }
    },
    (err) => console.warn('GPS error:', err.message),
    { enableHighAccuracy: true, maximumAge: 2000, timeout: 10000 }
  );
}

function stopLiveGpsTracking() {
  if (gpsWatchId !== null) {
    navigator.geolocation.clearWatch(gpsWatchId);
    gpsWatchId = null;
  }
  if (gpsMarker) {
    gpsMarker.remove();
    gpsMarker = null;
  }
}

function setDrawerMode(mode) {
  commuteMode = mode;
  document.querySelectorAll('.gmaps-mode-btn').forEach(btn => btn.classList.remove('active'));
  if (mode === 'driving' && document.getElementById('gmodeDrive')) document.getElementById('gmodeDrive').classList.add('active');
  if (mode === 'cycling' && document.getElementById('gmodeBike')) document.getElementById('gmodeBike').classList.add('active');
  if (mode === 'walking' && document.getElementById('gmodeWalk')) document.getElementById('gmodeWalk').classList.add('active');
  evaluateRouteConflictAndRender();
}

function toggle3DPerspective() {
  is3DTiltActive = !is3DTiltActive;
  const pitch = is3DTiltActive ? 55 : 0;
  const bearing = is3DTiltActive ? 15 : 0;
  map.easeTo({ pitch, bearing, duration: 1000 });
  document.getElementById('tiltStatusLabel').textContent = is3DTiltActive ? 'ON' : 'OFF';
  document.getElementById('btn3DTiltToggle').classList.toggle('active', is3DTiltActive);
}

function toggle3DOrbit() {
  is3DOrbitActive = !is3DOrbitActive;
  const btn = document.getElementById('btnOrbitToggle');
  btn.classList.toggle('active', is3DOrbitActive);

  if (is3DOrbitActive) {
    orbitInterval = setInterval(() => {
      if (!map) return;
      const b = map.getBearing();
      map.setBearing(b + 0.35);
    }, 40);
  } else {
    clearInterval(orbitInterval);
    orbitInterval = null;
  }
}

function showBulletinModal() {
  alert('📢 CIVIC BULLETIN - NAGPUR TRAFFIC POLICE:\n\n• Nagpur Grand Cyclothon active on Wardha Rd corridor.\n• Alternate Route via Ambazari Lake & Civil Lines recommended.\n• 3 SuperAdmin Command teams and 5 Medical Ambulances on standby.');
}

function openShareRouteModal() {
  navigator.clipboard.writeText(window.location.href);
  alert('🔗 3D Route Link copied to clipboard! Share with fellow commuters.');
}

// Initial Sync on Page Load
window.addEventListener('DOMContentLoaded', () => {
  if (document.getElementById('heroOriginInput')) document.getElementById('heroOriginInput').value = commuterOrigin.name;
  if (document.getElementById('heroDestInput')) document.getElementById('heroDestInput').value = commuterDest.name;
  if (document.getElementById('filterStartInput')) document.getElementById('filterStartInput').value = commuterOrigin.name;
  if (document.getElementById('filterEndInput')) document.getElementById('filterEndInput').value = commuterDest.name;
  if (document.getElementById('mapOriginInput')) document.getElementById('mapOriginInput').value = commuterOrigin.name;
  if (document.getElementById('mapDestInput')) document.getElementById('mapDestInput').value = commuterDest.name;
});

/* ========================================================================= */
/* SUPERADMIN COMMAND CENTER DASHBOARD LOGIC                                 */
/* ========================================================================= */

let dashboardRefreshInterval = null;

// Map display domain names to production database UUIDs & Slugs
const DOMAIN_UUID_MAP = {
  'CYCLOTHON': 'a1111111-1111-1111-1111-111111111111',
  'MARATHON': 'b2222222-2222-2222-2222-222222222222',
  'RALLY': 'c3333333-3333-3333-3333-333333333333'
};
const DOMAIN_SLUG_MAP = {
  'CYCLOTHON': 'cycling-2026',
  'MARATHON': 'marathon-2026',
  'RALLY': 'rally-2026'
};

function getCurrentDomainUUID() { return DOMAIN_UUID_MAP[currentAdminDomain] || 'a1111111-1111-1111-1111-111111111111'; }
function getCurrentDomainSlug() { return DOMAIN_SLUG_MAP[currentAdminDomain] || 'cycling-2026'; }

let realtimeSosSub = null;
let realtimeBroadcastSub = null;

function switchAdminTab(tab) {
  const btnStudio = document.getElementById('adminTabStudio');
  const btnDashboard = document.getElementById('adminTabDashboard');
  const viewStudio = document.getElementById('adminStudioContent');
  const viewDashboard = document.getElementById('adminDashboardContent');

  if (!btnStudio || !btnDashboard) return;

  if (tab === 'studio') {
    btnStudio.classList.add('active');
    btnDashboard.classList.remove('active');
    viewStudio.classList.remove('hidden');
    viewDashboard.classList.add('hidden');
    if (dashboardRefreshInterval) {
      clearInterval(dashboardRefreshInterval);
      dashboardRefreshInterval = null;
    }
  } else if (tab === 'dashboard') {
    btnStudio.classList.remove('active');
    btnDashboard.classList.add('active');
    viewStudio.classList.add('hidden');
    viewDashboard.classList.remove('hidden');
    loadDashboardData();
    if (!dashboardRefreshInterval) {
      dashboardRefreshInterval = setInterval(loadDashboardData, 8000);
    }
    // Connect live Realtime subscriptions if available
    if (window.subscribeToSosEvents && !realtimeSosSub) {
      realtimeSosSub = window.subscribeToSosEvents(getCurrentDomainUUID(), () => loadDashboardData());
    }
    if (window.subscribeToBroadcasts && !realtimeBroadcastSub) {
      realtimeBroadcastSub = window.subscribeToBroadcasts(getCurrentDomainUUID(), () => loadDashboardData());
    }
  }
}

async function loadDashboardData() {
  const domainId = getCurrentDomainUUID();
  const domainSlug = getCurrentDomainSlug();
  
  // 1. Update Event Overview
  if (window.fetchEventDomainBySlug) {
    const { data: domainData } = await window.fetchEventDomainBySlug(domainSlug);
    if (domainData) {
      renderEventOverview(domainData);
    }
  }

  // 2. Update Live Metrics
  renderLiveStats();

  // 3. Update Broadcasts
  if (window.fetchBroadcasts) {
    const { data: broadcasts } = await window.fetchBroadcasts(domainId);
    if (broadcasts) {
      renderBroadcastCenter(broadcasts);
    }
  }

  // 4. Update SOS Incidents
  if (window.fetchSosEvents) {
    const { data: sosEvents } = await window.fetchSosEvents(domainId);
    if (sosEvents) {
      renderSosPanel(sosEvents);
    }
  }
}

function renderEventOverview(domain) {
  const el = document.getElementById('dashEventOverview');
  if (!el) return;
  if (!domain) {
    el.innerHTML = '<div class="cmd-empty-state">No event data found.</div>';
    return;
  }
  
  const status = domain.status || 'UPCOMING';
  let pillClass = 'upcoming';
  let pillText = 'UPCOMING';
  if (status === 'LIVE_ACTIVE') {
    pillClass = 'live';
    pillText = '<span class="status-dot"></span> LIVE ACTIVE';
  } else if (status === 'CONCLUDED') {
    pillClass = 'concluded';
    pillText = 'CONCLUDED';
  }

  const startTimeStr = domain.start_time ? new Date(domain.start_time).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : 'TBD';
  const endTimeStr = domain.end_time ? new Date(domain.end_time).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : 'TBD';

  el.innerHTML = `
    <div class="cmd-hero-header">
      <div class="cmd-hero-title">${domain.name || domain.event_name || 'Civic Corridor Event'}</div>
      <div class="cmd-status-pill ${pillClass}">${pillText}</div>
    </div>
    <div class="cmd-hero-meta">
      <div class="cmd-meta-item">🏷️ <b>${domain.type || 'EVENT'}</b></div>
      <div class="cmd-meta-item">🕒 <b>${startTimeStr} - ${endTimeStr}</b></div>
      <div class="cmd-meta-item">⚡ <b>/${domain.slug}</b></div>
    </div>
  `;
}

function renderLiveStats() {
  const checkInRate = 84; // Simulated live telemetry percentage
  const completionRate = 28;
  const activeGps = 328;

  const elCheckIn = document.getElementById('metricCheckIn');
  const barCheckIn = document.getElementById('barCheckIn');
  const elCompleted = document.getElementById('metricCompleted');
  const barCompleted = document.getElementById('barCompleted');
  const elGps = document.getElementById('metricGPS');

  if (elCheckIn) elCheckIn.textContent = `${checkInRate}%`;
  if (barCheckIn) barCheckIn.style.width = `${checkInRate}%`;
  if (elCompleted) elCompleted.textContent = `${completionRate}%`;
  if (barCompleted) barCompleted.style.width = `${completionRate}%`;
  if (elGps) elGps.textContent = `${activeGps}`;
}

function renderBroadcastCenter(broadcasts) {
  const el = document.getElementById('dashRecentBroadcasts');
  if (!el) return;

  if (!broadcasts || broadcasts.length === 0) {
    el.innerHTML = '<div class="cmd-empty-state">No broadcasts sent yet.</div>';
    return;
  }

  let html = '';
  const sorted = [...broadcasts].sort((a, b) => new Date(b.created_at) - new Date(a.created_at)).slice(0, 4);

  sorted.forEach(b => {
    const timeAgo = Math.floor((new Date() - new Date(b.created_at)) / 60000);
    const timeStr = timeAgo < 1 ? 'Just now' : (timeAgo < 60 ? `${timeAgo}m ago` : `${Math.floor(timeAgo / 60)}h ago`);
    const roleIcon = b.sender_role === 'SUPERADMIN' ? '🛡️ SuperAdmin' : '👥 Marshal';

    html += `
      <div class="cmd-list-item">
        <div class="cmd-item-header">
          <span class="cmd-item-title">${roleIcon}</span>
          <span class="cmd-item-time">${timeStr}</span>
        </div>
        <div class="cmd-item-body">${b.message_text || b.message || ''}</div>
      </div>
    `;
  });

  el.innerHTML = html;
}

function renderSosPanel(events) {
  const el = document.getElementById('dashSosPanel');
  const badge = document.getElementById('sosBadge');
  const metricSOS = document.getElementById('metricSOS');
  const metricCard = document.getElementById('metricSOSCard');
  if (!el) return;

  const unresolved = events ? events.filter(e => e.status !== 'RESOLVED') : [];

  if (metricSOS) metricSOS.textContent = `${unresolved.length}`;

  if (unresolved.length > 0) {
    if (badge) {
      badge.textContent = `${unresolved.length} ACTIVE`;
      badge.classList.remove('hidden');
    }
    if (metricCard) metricCard.classList.add('has-sos');
  } else {
    if (badge) badge.classList.add('hidden');
    if (metricCard) metricCard.classList.remove('has-sos');
    el.innerHTML = '<div class="cmd-empty-state">✅ All clear — zero emergency alerts</div>';
    return;
  }

  let html = '';
  const iconMap = { 'MEDICAL': '🚑 Medical', 'BREAKDOWN': '🔧 Breakdown', 'THREAT': '⚠️ Security', 'LOST': '📍 Lost', 'OTHER': '🚨 Alert' };

  unresolved.forEach(e => {
    const timeAgo = Math.floor((new Date() - new Date(e.created_at)) / 60000);
    const timeStr = timeAgo < 1 ? 'Just now' : `${timeAgo}m ago`;
    const label = iconMap[e.emergency_type] || '🚨 Emergency';

    html += `
      <div class="cmd-list-item sos-alert">
        <div class="cmd-item-header">
          <span class="cmd-item-title" style="color: #F87171;">${label}</span>
          <span class="cmd-item-time">${timeStr}</span>
        </div>
        <div class="cmd-item-body">
          ${e.leader_notes ? `<b>Notes:</b> ${e.leader_notes}<br/>` : ''}
          <span style="font-family: var(--font-mono); font-size: 10px; color: #64748B;">📍 ${(e.latitude || 0).toFixed(4)}, ${(e.longitude || 0).toFixed(4)}</span>
        </div>
        <div class="cmd-item-footer">
          <span></span>
          <button class="cmd-btn-resolve" onclick="handleResolveSos('${e.id}')">Resolve Alert ✓</button>
        </div>
      </div>
    `;
  });

  el.innerHTML = html;
}

async function handleSendBroadcast() {
  const msgInput = document.getElementById('broadcastMessage');
  if (!window.sendBroadcast || !msgInput) return;

  const msg = msgInput.value.trim();
  if (!msg) {
    alert('Please enter a message to broadcast.');
    return;
  }

  const data = {
    domain_id: getCurrentDomainUUID(),
    message_text: msg,
    sender_role: 'SUPERADMIN',
    target_type: 'GENERAL',
    target_group_id: null
  };

  const { error } = await window.sendBroadcast(data);
  if (error) {
    alert('Error sending broadcast: ' + error.message);
  } else {
    msgInput.value = '';
    alert('📢 Broadcast dispatched to all connected participants!');
    loadDashboardData();
  }
}

async function handleResolveSos(eventId) {
  if (!window.resolveSosEvent) return;
  const notes = prompt('Enter resolution notes (optional):', 'Resolved by Command Center');
  if (notes === null) return;

  const { error } = await window.resolveSosEvent(eventId, 'SuperAdmin', notes);
  if (error) alert('Error resolving SOS: ' + error.message);
  else loadDashboardData();
}
