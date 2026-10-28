/**
 * =========================================================================
 * ZEROMILE GO - UI TYPES & DOMAIN RE-EXPORTS (types/index.ts)
 * =========================================================================
 */

export * from '../../../../shared/types/domain_contracts';

export type UserRole = 'GUEST' | 'SUPERADMIN' | 'GROUP_LEADER' | 'PARTICIPANT' | 'POLICE';

export interface LatLng {
  lat: number;
  lng: number;
}

export interface NamedLocation extends LatLng {
  id?: string;
  name: string;
  type?: 'COLLEGE' | 'HOSPITAL' | 'SQUARE' | 'TRANSIT' | 'MONUMENT' | 'STADIUM' | 'LAKE' | 'PARK' | 'CUSTOM';
  address?: string;
  context?: string;
}

export interface DomainMetadata {
  id: string; // UUID
  slug: string;
  title: string;
  type: 'CYCLING' | 'MARATHON' | 'PROTEST' | 'WALKATHON';
  icon: string;
  dateStr: string;
  color: string;
  themeColor: string;
  primaryStart: NamedLocation;
  primaryFinish: NamedLocation;
  defaultWaypoints: NamedLocation[];
  estimatedDistanceKm: number;
  estimatedDurationMin: number;
}

export interface RouteStats {
  distanceKm: number;
  durationMin: number;
  turnPointsCount: number;
  climbMeters: number;
}

export interface CommuterAlternateRoute {
  id: string;
  title: string;
  subtitle: string;
  tag: string;
  distanceKm: number;
  durationMin: number;
  trafficLevel: 'LOW' | 'MODERATE' | 'HIGH' | 'BLOCKED';
  color: string;
  coordinates: [number, number][];
  isRecommended: boolean;
  clashDetected: boolean;
  clashDetails?: string;
}

export interface BarricadeClosure {
  id: string;
  name: string;
  location: NamedLocation;
  radiusMeters: number;
  reason: string;
  activeFrom: string;
  activeUntil: string;
}
