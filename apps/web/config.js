/**
 * =========================================================================
 * ZEROMILE GO - RUNTIME ENVIRONMENT CONFIGURATION (config.js)
 * Dynamically populated by server.js / hosting provider environment
 * =========================================================================
 */

(function(window) {
  'use strict';

  if (!window.CONFIG) {
    window.CONFIG = Object.freeze({
      MAPBOX_ACCESS_TOKEN: window.__MAPBOX_TOKEN__ || (window.process && window.process.env && window.process.env.MAPBOX_ACCESS_TOKEN) || '',
      SUPABASE_URL: window.__SUPABASE_URL__ || (window.process && window.process.env && window.process.env.SUPABASE_URL) || '',
      SUPABASE_ANON_KEY: window.__SUPABASE_ANON_KEY__ || (window.process && window.process.env && window.process.env.SUPABASE_ANON_KEY) || '',

      DEFAULT_COORDS: {
        NAGPUR_ZERO_MILE: { lat: 21.1498, lng: 79.0806 },
        VNIT_CAMPUS: { lat: 21.1280, lng: 79.0520 }
      }
    });
  }

})(typeof window !== 'undefined' ? window : this);
