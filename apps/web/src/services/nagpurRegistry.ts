/**
 * =========================================================================
 * ZEROMILE GO - NAGPUR GEOGRAPHY & PLACES REGISTRY (nagpurRegistry.ts)
 * Master Geocoded Places in Nagpur with Instant Autocomplete
 * =========================================================================
 */

import { NamedLocation } from '../types';

export const NAGPUR_REGISTRY: NamedLocation[] = [
  // Universities & National Institutes
  { id: 'iiit', name: 'IIIT Nagpur, Waranga MIHAN', lat: 21.0260, lng: 79.0300, type: 'COLLEGE' },
  { id: 'aiims', name: 'AIIMS Nagpur, MIHAN Special Economic Zone', lat: 21.0360, lng: 79.0320, type: 'HOSPITAL' },
  { id: 'iim', name: 'IIM Nagpur, MIHAN Campus', lat: 21.0310, lng: 79.0280, type: 'COLLEGE' },
  { id: 'symbiosis', name: 'Symbiosis International University, Wathoda', lat: 21.1290, lng: 79.1450, type: 'COLLEGE' },
  { id: 'vnit', name: 'VNIT Main Gate, South Ambazari Rd', lat: 21.1280, lng: 79.0520, type: 'COLLEGE' },
  { id: 'ycce', name: 'YCCE College of Engineering, Hingna Rd', lat: 21.1020, lng: 78.9780, type: 'COLLEGE' },
  { id: 'rcoem', name: 'Ramdeobaba University (RCOEM), Katol Rd', lat: 21.1760, lng: 79.0610, type: 'COLLEGE' },
  { id: 'gcoen', name: 'GCOEN Government College of Engineering, Sector 27', lat: 21.0950, lng: 79.0550, type: 'COLLEGE' },
  { id: 'lit', name: 'Laxminarayan Institute of Technology (LIT)', lat: 21.1340, lng: 79.0490, type: 'COLLEGE' },
  
  // Prominent Squares, Parks & Junctions
  { id: 'zeromile', name: 'Zero Mile Freedom Park Monument', lat: 21.1498, lng: 79.0806, type: 'MONUMENT' },
  { id: 'zero_mile', name: 'Zero Mile Freedom Park Monument', lat: 21.1498, lng: 79.0806, type: 'MONUMENT' },
  { id: 'kasturchand', name: 'Kasturchand Park Historical Grounds', lat: 21.1530, lng: 79.0840, type: 'PARK' },
  { id: 'sitabuldi', name: 'Sitabuldi Metro Interchange Junction', lat: 21.1460, lng: 79.0820, type: 'TRANSIT' },
  { id: 'law_college', name: 'Law College Square Junction', lat: 21.1390, lng: 79.0680, type: 'SQUARE' },
  { id: 'shankar_nagar', name: 'Shankar Nagar Square (Dharampeth)', lat: 21.1310, lng: 79.0600, type: 'SQUARE' },
  { id: 'samvidhan', name: 'Samvidhan Square (RBI Chowk)', lat: 21.1510, lng: 79.0840, type: 'SQUARE' },
  { id: 'medical_sq', name: 'Medical Square Junction (GMC)', lat: 21.1340, lng: 79.0960, type: 'SQUARE' },
  { id: 'bajaj_nagar', name: 'Bajaj Nagar Square', lat: 21.1230, lng: 79.0610, type: 'SQUARE' },
  
  // Hospitals & Emergency Services
  { id: 'gmc', name: 'Government Medical College & Hospital (GMC)', lat: 21.1350, lng: 79.0920, type: 'HOSPITAL' },
  { id: 'igmc', name: 'IGGMC Mayo Hospital, Central Avenue', lat: 21.1520, lng: 79.0950, type: 'HOSPITAL' },
  { id: 'kingsway', name: 'Kingsway Hospital, Near Nagpur Railway Station', lat: 21.1550, lng: 79.0860, type: 'HOSPITAL' },
  { id: 'orange_city_hosp', name: 'Orange City Hospital, Khamla Square', lat: 21.1150, lng: 79.0650, type: 'HOSPITAL' },
  
  // Lakes, Parks & Monuments
  { id: 'futala', name: 'Futala Lake Waterfront Promenade', lat: 21.1550, lng: 79.0460, type: 'LAKE' },
  { id: 'ambazari', name: 'Ambazari Lake & Biodiversity Park', lat: 21.1270, lng: 79.0390, type: 'LAKE' },
  { id: 'seminary', name: 'Seminary Hills & Japanese Garden', lat: 21.1620, lng: 79.0620, type: 'PARK' },
  { id: 'japanese_garden', name: 'Japanese Garden, Civil Lines Seminary Hills', lat: 21.1620, lng: 79.0620, type: 'PARK' },
  { id: 'deekshabhoomi', name: 'Deekshabhoomi Sacred Stupa Monument', lat: 21.1270, lng: 79.0700, type: 'MONUMENT' }
];

export const findNagpurPlace = (idOrQuery: string): NamedLocation | undefined => {
  const norm = idOrQuery.toLowerCase().replace(/[-_\s]/g, '');
  return NAGPUR_REGISTRY.find(p =>
    (p.id && p.id.toLowerCase().replace(/[-_\s]/g, '') === norm) ||
    p.name.toLowerCase().replace(/[-_\s]/g, '').includes(norm)
  );
};

export const searchNagpurPlaces = (query: string): NamedLocation[] => {
  const clean = query.trim().toLowerCase();
  if (!clean) return NAGPUR_REGISTRY.slice(0, 8);
  return NAGPUR_REGISTRY.filter(
    place => place.name.toLowerCase().includes(clean) || (place.id && place.id.toLowerCase().includes(clean))
  ).slice(0, 8);
};
