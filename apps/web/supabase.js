/**
 * =========================================================================
 * ZEROMILE GO - PRODUCTION SUPABASE CLIENT LAYER (supabase.js)
 * Strict, 100% Real Database Connectivity — Zero Mock Data
 * =========================================================================
 */

// --- 1. Supabase Client Configuration & Injection ---
const SUPABASE_URL = (window.CONFIG && window.CONFIG.SUPABASE_URL) || '';
const SUPABASE_KEY = (window.CONFIG && window.CONFIG.SUPABASE_ANON_KEY) || '';

let supabaseClient = null;

if (!SUPABASE_URL || !SUPABASE_KEY) {
    console.warn('⚠️ Supabase credentials not found in environment. Database features will be unavailable.');
}

if (window.supabase && SUPABASE_URL && SUPABASE_KEY) {
    try {
        supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);
        console.log('⚡ Connected to Live Production Database');
    } catch (e) {
        console.error('❌ Supabase initialization error:', e);
    }
}

// --- 2. Authentication Module ---

window.supabaseSignInWithOtp = async function(phone) {
    if (!supabaseClient) return { data: null, error: { message: 'Database client not ready. Check environment variables.' } };
    try {
        const res = await supabaseClient.auth.signInWithOtp({ phone });
        return res;
    } catch (e) {
        console.error('OTP send failed:', e.message);
        return { data: null, error: { message: e.message || 'Failed to send OTP. Please try again.' } };
    }
};

window.supabaseVerifyOtp = async function(phone, token) {
    if (!supabaseClient) return { data: null, error: { message: 'Database client not ready. Check environment variables.' } };
    try {
        const res = await supabaseClient.auth.verifyOtp({ phone, token, type: 'sms' });
        return res;
    } catch (e) {
        console.error('OTP verification failed:', e.message);
        return { data: null, error: { message: e.message || 'OTP verification failed. Please try again.' } };
    }
};

window.supabaseGetCurrentUser = async function() {
    if (!supabaseClient) return { data: null, error: null };
    try {
        return await supabaseClient.auth.getUser();
    } catch (e) {
        return { data: null, error: { message: e.message } };
    }
};

window.supabaseSignOut = async function() {
    if (!supabaseClient) return { error: null };
    try {
        return await supabaseClient.auth.signOut();
    } catch (e) {
        return { error: { message: e.message } };
    }
};

window.supabaseCheckSuperAdmin = async function(phone, domainId) {
    if (!supabaseClient) return { data: null, error: { message: 'Database client not ready' } };
    const cleanPhone = (phone || '').replace(/^\+91/, '').trim();
    try {
        const { data, error } = await supabaseClient
            .from('domain_superadmins')
            .select('id')
            .eq('domain_id', domainId)
            .or(`phone_number.eq.${cleanPhone},phone_number.eq.+91${cleanPhone}`)
            .limit(1);

        if (error) return { data: null, error };
        if (data && data.length > 0) return { data: true, error: null };

        // Phone is not an authorized SuperAdmin
        return { 
            data: false, 
            error: { message: 'Access Denied: Mobile number +91 ' + cleanPhone + ' is not provisioned as a SuperAdmin for this domain.' } 
        };
    } catch (e) {
        console.error('SuperAdmin check error:', e);
        return { data: null, error: { message: e.message || 'SuperAdmin verification failed' } };
    }
};

// --- 3. Live Data Query & Mutation Module (100% Real DB) ---

window.fetchEventDomains = async function() {
    if (!supabaseClient) return { data: [], error: null };
    return await supabaseClient.from('event_domains').select('*').order('start_time', { ascending: true });
};

window.fetchEventDomainBySlug = async function(slug) {
    if (!supabaseClient) return { data: null, error: null };
    return await supabaseClient.from('event_domains').select('*').eq('slug', slug).single();
};

window.saveRouteGeojson = async function(domainId, geojson) {
    if (!supabaseClient) return { data: null, error: null };
    return await supabaseClient.from('event_domains').update({ route_geojson: geojson }).eq('id', domainId);
};

window.fetchCheckpoints = async function(domainId) {
    if (!supabaseClient) return { data: [], error: null };
    return await supabaseClient.from('route_checkpoints').select('*').eq('domain_id', domainId).order('sequence_order', { ascending: true });
};

window.upsertCheckpoint = async function(checkpointData) {
    if (!supabaseClient) return { data: null, error: null };
    return await supabaseClient.from('route_checkpoints').upsert(checkpointData);
};

window.deleteCheckpoint = async function(id) {
    if (!supabaseClient) return { data: null, error: null };
    return await supabaseClient.from('route_checkpoints').delete().eq('id', id);
};

window.fetchBroadcasts = async function(domainId) {
    if (!supabaseClient) return { data: [], error: null };
    return await supabaseClient.from('broadcasts').select('*').eq('domain_id', domainId).order('created_at', { ascending: false });
};

window.sendBroadcast = async function(broadcastData) {
    if (!supabaseClient) return { data: null, error: null };
    return await supabaseClient.from('broadcasts').insert(broadcastData);
};

window.fetchSosEvents = async function(domainId) {
    if (!supabaseClient) return { data: [], error: null };
    return await supabaseClient.from('sos_events').select('*').eq('domain_id', domainId).order('created_at', { ascending: false });
};

window.resolveSosEvent = async function(eventId, resolvedBy, notes) {
    if (!supabaseClient) return { data: null, error: null };
    return await supabaseClient
        .from('sos_events')
        .update({ status: 'RESOLVED', resolved_by: resolvedBy, resolved_at: new Date().toISOString(), leader_notes: notes })
        .eq('id', eventId);
};

window.fetchLiveLocations = async function(domainId) {
    if (!supabaseClient) return { data: [], error: null };
    return await supabaseClient.from('user_live_locations').select('*').eq('domain_id', domainId);
};

window.publishUserLocation = async function(domainId, userIdentifier, latitude, longitude, speed = 0, heading = 0) {
    if (!supabaseClient) return { data: null, error: null };
    return await supabaseClient.from('user_live_locations').upsert({
        domain_id: domainId,
        user_identifier: userIdentifier,
        latitude,
        longitude,
        speed_kmh: speed,
        heading,
        updated_at: new Date().toISOString()
    });
};

// --- 4. Realtime Subscriptions Module (PostgreSQL WebSockets) ---

function handleSubscription(table, filter, callback) {
    if (!supabaseClient) return { unsubscribe: () => {} };
    return supabaseClient
        .channel(`public:${table}`)
        .on('postgres_changes', { event: '*', schema: 'public', table, filter }, payload => {
            if (callback) callback(payload);
        })
        .subscribe();
}

window.subscribeToSosEvents = (domainId, callback) => handleSubscription('sos_events', `domain_id=eq.${domainId}`, callback);
window.subscribeToBroadcasts = (domainId, callback) => handleSubscription('broadcasts', `domain_id=eq.${domainId}`, callback);
window.subscribeToLiveLocations = (domainId, callback) => handleSubscription('user_live_locations', `domain_id=eq.${domainId}`, callback);
window.subscribeToEventDomains = (callback) => handleSubscription('event_domains', null, callback);
