/**
 * =========================================================================
 * ZEROMILE GO - HYBRID GEOCODING & LOCATION SEARCH ENGINE (geocodingService.ts)
 * Mapbox Geocoding v5 + Curated Nagpur Civic Hubs + Geofenced Bounding Box
 * Zero Information Leaks • Offline Resilient • Race-Condition Proof
 * =========================================================================
 */

import { CONFIG } from '../config/env';
import { NamedLocation } from '../types';
import { NAGPUR_REGISTRY, searchNagpurPlaces } from './nagpurRegistry';

// Nagpur Metropolitan Bounding Box & Center
const NAGPUR_BBOX = '78.7,20.8,79.4,21.5';
const NAGPUR_PROXIMITY = '79.0806,21.1498'; // Zero Mile Monument

// Query Cache to prevent duplicate network calls during typing/backspacing
const queryCache = new Map<string, NamedLocation[]>();

/**
 * Calculate haversine distance in meters to detect duplicates between registry and Mapbox
 */
function haversineDistanceMeters(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const R = 6371e3;
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLon = ((lon2 - lon1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

/**
 * Mapbox place type to UI category
 */
function determineCategory(feature: any): NamedLocation['type'] {
  const text = ((feature.text || '') + ' ' + (feature.place_name || '')).toLowerCase();
  const types = (feature.place_type || []) as string[];

  if (text.includes('college') || text.includes('university') || text.includes('institute') || text.includes('school') || text.includes('iit') || text.includes('vnit') || text.includes('iiit') || text.includes('iim')) {
    return 'COLLEGE';
  }
  if (text.includes('hospital') || text.includes('medical') || text.includes('clinic') || text.includes('aiims') || text.includes('gmc')) {
    return 'HOSPITAL';
  }
  if (text.includes('lake') || text.includes('talav') || text.includes('waterfront') || text.includes('futala') || text.includes('ambazari')) {
    return 'LAKE';
  }
  if (text.includes('park') || text.includes('garden') || text.includes('ground') || text.includes('kasturchand')) {
    return 'PARK';
  }
  if (text.includes('metro') || text.includes('railway') || text.includes('station') || text.includes('airport') || text.includes('bus stand')) {
    return 'TRANSIT';
  }
  if (text.includes('square') || text.includes('chowk') || text.includes('junction') || text.includes('sq')) {
    return 'SQUARE';
  }
  if (text.includes('monument') || text.includes('memorial') || text.includes('zero mile') || text.includes('deekshabhoomi')) {
    return 'MONUMENT';
  }
  if (types.includes('poi')) return 'SQUARE';
  return 'CUSTOM';
}

/**
 * Validate that coordinates fall within greater Nagpur geographical bounds
 */
export function isValidNagpurCoordinate(lat: number, lng: number): boolean {
  return (
    typeof lat === 'number' &&
    typeof lng === 'number' &&
    !isNaN(lat) &&
    !isNaN(lng) &&
    lat >= 20.5 &&
    lat <= 21.6 &&
    lng >= 78.5 &&
    lng <= 79.6
  );
}

/**
 * Main Location Search: Combines Curated Nagpur Registry with Mapbox Geocoding
 */
export async function searchLocations(
  query: string,
  signal?: AbortSignal
): Promise<NamedLocation[]> {
  const cleanQuery = query.trim();
  if (!cleanQuery) {
    return NAGPUR_REGISTRY.slice(0, 6);
  }

  const cacheKey = cleanQuery.toLowerCase();
  if (queryCache.has(cacheKey)) {
    return queryCache.get(cacheKey)!;
  }

  // 1. Search Local Registry (Instant sub-millisecond match)
  const localMatches = searchNagpurPlaces(cleanQuery);

  // If query is very short (< 2 chars), return local registry immediately
  if (cleanQuery.length < 2) {
    return localMatches.slice(0, 6);
  }

  // 2. Query Mapbox Geocoding API v5
  let mapboxResults: NamedLocation[] = [];
  const token = CONFIG.MAPBOX_ACCESS_TOKEN;

  if (token && !token.startsWith('your_')) {
    try {
      const endpoint = `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(
        cleanQuery
      )}.json?access_token=${token}&country=IN&proximity=${NAGPUR_PROXIMITY}&bbox=${NAGPUR_BBOX}&types=poi,address,neighborhood,locality,place&limit=8&autocomplete=true`;

      const res = await fetch(endpoint, { signal });
      if (res.ok) {
        const data = await res.json();
        if (data.features && Array.isArray(data.features)) {
          mapboxResults = data.features
            .filter((f: any) => {
              if (!f.center || !Array.isArray(f.center) || f.center.length < 2) return false;
              const [lng, lat] = f.center;
              return isValidNagpurCoordinate(lat, lng);
            })
            .map((f: any) => {
              const [lng, lat] = f.center;
              // Clean place name: e.g. "Dharampeth, Nagpur, Maharashtra, India" -> short display
              const parts = (f.place_name || f.text || '').split(',');
              const displayName = parts.length > 2 ? `${parts[0].trim()}, ${parts[1].trim()}` : f.place_name;

              return {
                id: f.id || `mb-${Date.now()}-${Math.random().toString(36).slice(2, 7)}`,
                name: displayName,
                lat,
                lng,
                type: determineCategory(f),
                address: f.place_name
              } as NamedLocation;
            });
        }
      }
    } catch (err: unknown) {
      if ((err as Error)?.name !== 'AbortError') {
        console.warn('Mapbox geocoding notice:', err);
      }
    }
  }

  // 3. Deduplicate and merge results
  // Give priority to curated local registry matches, then append distinct Mapbox results
  const merged: NamedLocation[] = [...localMatches];

  for (const mb of mapboxResults) {
    const isDuplicate = merged.some(existing => {
      // Name overlap
      const normExist = existing.name.toLowerCase().replace(/[-_\s,]/g, '');
      const normMb = mb.name.toLowerCase().replace(/[-_\s,]/g, '');
      if (normExist.includes(normMb) || normMb.includes(normExist)) return true;

      // Close spatial proximity (< 250 meters)
      const dist = haversineDistanceMeters(existing.lat, existing.lng, mb.lat, mb.lng);
      return dist < 250;
    });

    if (!isDuplicate) {
      merged.push(mb);
    }
  }

  const finalResults = merged.slice(0, 8);
  queryCache.set(cacheKey, finalResults);
  return finalResults;
}
