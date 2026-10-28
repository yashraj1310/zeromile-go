/**
 * ============================================================================
 * VIKASIT NAGPUR / ZEROMILE GO - SHARED DOMAIN CONTRACTS & TYPES
 * Canonical Data Types for Web (React / TypeScript) and Mobile (Flutter / Dart)
 * ============================================================================
 */

export type DomainType = 'CYCLING' | 'MARATHON' | 'PROTEST' | 'WALKATHON';
export type DomainStatus = 'UPCOMING' | 'LIVE_ACTIVE' | 'CONCLUDED' | 'ARCHIVED';

export type OrgCategory = 
  | 'GENERAL'
  | 'COLLEGE'
  | 'NGO'
  | 'LABOR_UNION'
  | 'CORPORATE'
  | 'SPORTS_CLUB'
  | 'RWA'
  | 'GRASSROOTS';

export type UserRole = 'DEVELOPER' | 'SUPERADMIN' | 'GROUP_LEADER' | 'PARTICIPANT' | 'POLICE' | 'GUEST';

export type SosEmergencyType = 'MEDICAL' | 'BREAKDOWN' | 'THREAT' | 'LOST' | 'OTHER';
export type SosStatus = 'TRIGGERED' | 'FORWARDED_TO_ADMIN' | 'RESOLVED';

export type CheckpointType = 'START' | 'WATER_STATION' | 'MEDICAL_POST' | 'DIVERSION' | 'FINISH';
export type ParticipationStatus = 'NOT_CHECKED_IN' | 'CHECKED_IN' | 'IN_TRANSIT' | 'COMPLETED' | 'DROPPED_OUT';

export interface EventDomain {
  id: string; // UUID
  name: string;
  slug: string;
  type: DomainType;
  status: DomainStatus;
  startTime: string; // ISO 8601
  endTime: string; // ISO 8601
  routeGeojson?: Record<string, unknown> | null;
  createdAt: string;
}

export interface UserProfile {
  id: string; // UUID
  phoneNumber: string;
  fullName: string;
  avatarUrl?: string | null;
  emergencyContact?: string | null;
  createdAt: string;
}

export interface SubGroup {
  id: string;
  domainId: string;
  name: string;
  isGeneral: boolean;
  orgType: OrgCategory;
  leaderId?: string | null;
  musterPoint?: string | null;
  approvalStatus: 'PENDING' | 'APPROVED' | 'REJECTED' | 'SUSPENDED';
  createdAt: string;
}

export interface GroupMembership {
  id: string;
  domainId: string;
  groupId: string;
  userId: string;
  isActive: boolean;
  isLeader: boolean;
  participationStatus: ParticipationStatus;
  checkinTime?: string | null;
  completionTime?: string | null;
  joinedAt: string;
}

export interface RouteCheckpoint {
  id: string;
  domainId: string;
  checkpointType: CheckpointType;
  name: string;
  latitude: number;
  longitude: number;
  sequenceOrder: number;
}

export interface BroadcastMessage {
  id: string;
  domainId: string;
  senderId: string;
  senderRole: 'SUPERADMIN' | 'GROUP_LEADER';
  targetType: 'GENERAL' | 'SPECIFIC_GROUP';
  targetGroupId?: string | null;
  messageText: string;
  createdAt: string;
}

export interface SosEvent {
  id: string;
  domainId: string;
  senderUserId: string;
  activeSubGroupId?: string | null;
  emergencyType: SosEmergencyType;
  latitude: number;
  longitude: number;
  status: SosStatus;
  forwardedByLeaderId?: string | null;
  leaderNotes?: string | null;
  resolvedBy?: string | null;
  resolvedAt?: string | null;
  createdAt: string;
}

export interface UserLiveLocation {
  id: string;
  domainId: string;
  userId: string;
  activeGroupId?: string | null;
  latitude: number;
  longitude: number;
  speedKmh: number;
  heading: number;
  updatedAt: string;
}

export interface LeaderSquadSummary {
  groupId: string;
  groupName: string;
  musterPoint: string;
  totalEnrolled: number;
  checkedIn: number;
  completed: number;
  activeTelemetry: number;
  pendingSos: number;
  checkinPercentage: number;
  completionPercentage: number;
}

export interface SectorDensityMetric {
  checkpointId: string;
  sequenceOrder: number;
  name: string;
  checkpointType: CheckpointType;
  latitude: number;
  longitude: number;
  activeRidersNearby: number;
}
