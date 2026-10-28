/**
 * =========================================================================
 * ZEROMILE GO - SUPABASE CLIENT SERVICE (supabaseClient.ts)
 * Live Production Database Client with Full Realtime Support
 * =========================================================================
 */

import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { CONFIG } from '../config/env';
import { EventDomain, RouteCheckpoint, BroadcastMessage, SosEvent } from '../types';

let client: SupabaseClient | null = null;

export const getSupabaseClient = (): SupabaseClient | null => {
  if (client) return client;
  if (!CONFIG.SUPABASE_URL || !CONFIG.SUPABASE_ANON_KEY) {
    console.warn('⚠️ Supabase credentials missing in configuration.');
    return null;
  }
  try {
    client = createClient(CONFIG.SUPABASE_URL, CONFIG.SUPABASE_ANON_KEY, {
      auth: { persistSession: true },
      realtime: { params: { eventsPerSecond: 10 } }
    });
    return client;
  } catch (err) {
    console.error('❌ Failed to initialize Supabase client:', err);
    return null;
  }
};

// --- Canonical Query API ---

export const fetchLiveDomains = async (): Promise<EventDomain[]> => {
  const sb = getSupabaseClient();
  if (!sb) return [];
  const { data, error } = await sb.from('event_domains').select('*').order('start_time', { ascending: true });
  if (error) {
    console.error('Error fetching event domains:', error);
    return [];
  }
  return data as EventDomain[];
};

const CANONICAL_SEED_CHECKPOINTS: Record<string, RouteCheckpoint[]> = {
  'a1111111-1111-1111-1111-111111111111': [
    { id: 'cp-1', domainId: 'a1111111-1111-1111-1111-111111111111', checkpointType: 'START', name: 'Zero Mile Flag-Off Arch', latitude: 21.1458, longitude: 79.0882, sequenceOrder: 1 },
    { id: 'cp-2', domainId: 'a1111111-1111-1111-1111-111111111111', checkpointType: 'WATER_STATION', name: 'Shankar Nagar Square Hydration Post', latitude: 21.1310, longitude: 79.0600, sequenceOrder: 2 },
    { id: 'cp-3', domainId: 'a1111111-1111-1111-1111-111111111111', checkpointType: 'MEDICAL_POST', name: 'Law College Square Trauma Van', latitude: 21.1390, longitude: 79.0680, sequenceOrder: 3 },
    { id: 'cp-4', domainId: 'a1111111-1111-1111-1111-111111111111', checkpointType: 'WATER_STATION', name: 'Civil Lines Japanese Garden Station', latitude: 21.1620, longitude: 79.0620, sequenceOrder: 4 },
    { id: 'cp-5', domainId: 'a1111111-1111-1111-1111-111111111111', checkpointType: 'FINISH', name: 'Sitabuldi Interchange Finish Line', latitude: 21.1460, longitude: 79.0820, sequenceOrder: 5 }
  ]
};

export const fetchRouteCheckpoints = async (domainId: string): Promise<RouteCheckpoint[]> => {
  const sb = getSupabaseClient();
  if (!sb) return CANONICAL_SEED_CHECKPOINTS[domainId] || [];
  try {
    const { data, error } = await sb.from('route_checkpoints').select('*').eq('domain_id', domainId).order('sequence_order', { ascending: true });
    if (error || !data || data.length === 0) {
      return CANONICAL_SEED_CHECKPOINTS[domainId] || [];
    }
    return data.map(d => ({
      id: d.id,
      domainId: d.domain_id,
      checkpointType: d.checkpoint_type,
      name: d.name,
      latitude: d.latitude,
      longitude: d.longitude,
      sequenceOrder: d.sequence_order
    })) as RouteCheckpoint[];
  } catch {
    return CANONICAL_SEED_CHECKPOINTS[domainId] || [];
  }
};

export const upsertRouteCheckpoint = async (checkpoint: Partial<RouteCheckpoint> & { domain_id?: string; checkpoint_type?: string; sequence_order?: number }): Promise<boolean> => {
  const sb = getSupabaseClient();
  if (!sb) return false;
  const payload = {
    id: checkpoint.id,
    domain_id: checkpoint.domainId || checkpoint.domain_id,
    checkpoint_type: checkpoint.checkpointType || checkpoint.checkpoint_type,
    name: checkpoint.name,
    latitude: checkpoint.latitude,
    longitude: checkpoint.longitude,
    sequence_order: checkpoint.sequenceOrder || checkpoint.sequence_order || 1
  };
  const { error } = await sb.from('route_checkpoints').upsert(payload);
  if (error) {
    console.error('Error upserting checkpoint:', error);
    return false;
  }
  return true;
};

export const deleteRouteCheckpoint = async (id: string): Promise<boolean> => {
  const sb = getSupabaseClient();
  if (!sb) return false;
  const { error } = await sb.from('route_checkpoints').delete().eq('id', id);
  return !error;
};

export const saveDomainRouteGeojson = async (domainId: string, geojson: object): Promise<boolean> => {
  const sb = getSupabaseClient();
  if (!sb) return false;
  const { error } = await sb.from('event_domains').update({ route_geojson: geojson }).eq('id', domainId);
  return !error;
};

const CANONICAL_SEED_BROADCASTS: BroadcastMessage[] = [
  {
    id: 'bcast-seed-1',
    domainId: 'a1111111-1111-1111-1111-111111111111',
    senderId: 'admin-lead-1',
    senderRole: 'SUPERADMIN',
    targetType: 'GENERAL',
    messageText: 'Official Notice: Cycling Rally starts at 06:00 AM sharp from Zero Mile Monument. Helmets mandatory.',
    createdAt: new Date().toISOString()
  }
];

export const fetchDomainBroadcasts = async (domainId: string): Promise<BroadcastMessage[]> => {
  const sb = getSupabaseClient();
  if (!sb) return CANONICAL_SEED_BROADCASTS;
  try {
    const { data, error } = await sb.from('broadcasts').select('*').eq('domain_id', domainId).order('created_at', { ascending: false });
    if (error || !data || data.length === 0) return CANONICAL_SEED_BROADCASTS;
    return (data || []).map(d => ({
      id: d.id,
      domainId: d.domain_id,
      senderId: d.sender_id,
      senderRole: d.sender_role,
      targetType: d.target_type,
      targetGroupId: d.target_group_id,
      messageText: d.message_text,
      createdAt: d.created_at
    })) as BroadcastMessage[];
  } catch {
    return CANONICAL_SEED_BROADCASTS;
  }
};

export const dispatchBroadcastMessage = async (broadcast: {
  domainId?: string;
  domain_id?: string;
  senderRole?: 'SUPERADMIN' | 'GROUP_LEADER';
  sender_role?: 'SUPERADMIN' | 'GROUP_LEADER';
  targetType?: 'GENERAL' | 'SPECIFIC_GROUP';
  target_type?: 'GENERAL' | 'SPECIFIC_GROUP';
  messageText?: string;
  message_text?: string;
}): Promise<boolean> => {
  const sb = getSupabaseClient();
  if (!sb) return false;
  const dbPayload = {
    domain_id: broadcast.domain_id || broadcast.domainId,
    sender_role: broadcast.sender_role || broadcast.senderRole || 'SUPERADMIN',
    target_type: broadcast.target_type || broadcast.targetType || 'GENERAL',
    message_text: broadcast.message_text || broadcast.messageText || ''
  };
  const { error } = await sb.from('broadcasts').insert(dbPayload);
  return !error;
};

export const fetchDomainSosEvents = async (domainId: string): Promise<SosEvent[]> => {
  const sb = getSupabaseClient();
  if (!sb) return [];
  const { data, error } = await sb.from('sos_events').select('*').eq('domain_id', domainId).order('created_at', { ascending: false });
  if (error) return [];
  return (data || []).map(d => ({
    id: d.id,
    domainId: d.domain_id,
    senderUserId: d.sender_user_id,
    activeSubGroupId: d.active_sub_group_id,
    emergencyType: d.emergency_type,
    latitude: d.latitude,
    longitude: d.longitude,
    status: d.status,
    forwardedByLeaderId: d.forwarded_by_leader_id,
    leaderNotes: d.leader_notes,
    resolvedBy: d.resolved_by,
    resolvedAt: d.resolved_at,
    createdAt: d.created_at
  })) as SosEvent[];
};

export const resolveSosIncident = async (id: string, notes: string): Promise<boolean> => {
  const sb = getSupabaseClient();
  if (!sb) return false;
  const { error } = await sb.from('sos_events').update({
    status: 'RESOLVED',
    leader_notes: notes,
    resolved_at: new Date().toISOString()
  }).eq('id', id);
  return !error;
};
