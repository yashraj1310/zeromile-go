/**
 * =========================================================================
 * ZEROMILE GO - RUNTIME CLIENT CONFIGURATION (env.ts)
 * Secure, non-secret client configuration loader
 * =========================================================================
 */

interface ClientConfig {
  MAPBOX_ACCESS_TOKEN: string;
  SUPABASE_URL: string;
  SUPABASE_ANON_KEY: string;
  DEFAULT_COORDS: {
    NAGPUR_ZERO_MILE: { lat: number; lng: number };
    VNIT_CAMPUS: { lat: number; lng: number };
  };
}

// Read from Vite environment (VITE_* or prefix configured) or window.CONFIG fallback
const getEnv = (key: string, fallback: string = ''): string => {
  try {
    const metaEnv = (import.meta as unknown as { env?: Record<string, string> }).env;
    if (metaEnv) {
      const viteVal = metaEnv[`VITE_${key}`] || metaEnv[key];
      if (viteVal) return viteVal;
    }
  } catch {
    // Ignore environments where import.meta is not defined
  }

  if (typeof window !== 'undefined' && (window as unknown as { CONFIG?: Record<string, string> }).CONFIG) {
    const winVal = (window as unknown as { CONFIG: Record<string, string> }).CONFIG[key];
    if (winVal) return winVal;
  }
  return fallback;
};

export const CONFIG: ClientConfig = Object.freeze({
  MAPBOX_ACCESS_TOKEN: getEnv('MAPBOX_ACCESS_TOKEN', ''),
  SUPABASE_URL: getEnv('SUPABASE_URL', ''),
  SUPABASE_ANON_KEY: getEnv('SUPABASE_ANON_KEY', ''),
  DEFAULT_COORDS: {
    NAGPUR_ZERO_MILE: { lat: 21.1498, lng: 79.0806 },
    VNIT_CAMPUS: { lat: 21.1280, lng: 79.0520 }
  }
});
