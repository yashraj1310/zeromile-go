/**
 * =========================================================================
 * ZEROMILE GO - MAPBOX GL JS ENGINE HOOK (useMapbox.ts)
 * Mapbox Standard 3D • 4 Lighting Presets • 3D Buildings • Orbit & Peloton
 * =========================================================================
 */

import { useEffect, useRef, useState, useCallback } from 'react';
import mapboxgl from 'mapbox-gl';
import { CONFIG } from '../../config/env';
import { LatLng, NamedLocation } from '../../types';

export type LightPreset = 'dawn' | 'day' | 'dusk' | 'night';

export interface UseMapboxOptions {
  containerRef: React.RefObject<HTMLDivElement>;
  initialCenter?: LatLng;
  initialZoom?: number;
  initialPitch?: number;
  initialLightPreset?: LightPreset;
  onMapClick?: (e: mapboxgl.MapMouseEvent) => void;
}

export const useMapbox = ({
  containerRef,
  initialCenter = CONFIG.DEFAULT_COORDS.NAGPUR_ZERO_MILE,
  initialZoom = 13.8,
  initialPitch = 50,
  initialLightPreset = 'day',
  onMapClick
}: UseMapboxOptions) => {
  const mapRef = useRef<mapboxgl.Map | null>(null);
  const [map, setMap] = useState<mapboxgl.Map | null>(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [currentLightPreset, setCurrentLightPreset] = useState<LightPreset>(initialLightPreset);
  const [is3DTiltActive, setIs3DTiltActive] = useState(true);
  const [isOrbiting, setIsOrbiting] = useState(false);

  // References to preserve state across React renders
  const markersRef = useRef<mapboxgl.Marker[]>([]);
  const pelotonMarkersRef = useRef<mapboxgl.Marker[]>([]);
  const orbitIntervalRef = useRef<number | null>(null);
  const pendingCoordsRef = useRef<[number, number][]>([]);
  const clickHandlerRef = useRef(onMapClick);
  clickHandlerRef.current = onMapClick;

  // Initialize Mapbox Instance Once
  useEffect(() => {
    if (!containerRef.current || mapRef.current) return;

    mapboxgl.accessToken = CONFIG.MAPBOX_ACCESS_TOKEN;

    const mapInstance = new mapboxgl.Map({
      container: containerRef.current,
      style: 'mapbox://styles/mapbox/standard',
      center: [initialCenter.lng, initialCenter.lat],
      zoom: initialZoom,
      pitch: initialPitch,
      bearing: 15,
      antialias: true
    });

    mapInstance.addControl(new mapboxgl.NavigationControl({ visualizePitch: true }), 'bottom-right');
    mapInstance.addControl(new mapboxgl.ScaleControl({ maxWidth: 100, unit: 'metric' }), 'bottom-left');

    const setupSourcesAndLayers = () => {
      try {
        mapInstance.setConfigProperty('basemap', 'lightPreset', initialLightPreset);
        mapInstance.setConfigProperty('basemap', 'showPointOfInterestLabels', true);
        mapInstance.setConfigProperty('basemap', 'show3dObjects', true);
      } catch {
        // Fallback if standard style config is unavailable
      }

      // 1. Route GeoJSON Source & Layers
      if (!mapInstance.getSource('active-route-source')) {
        mapInstance.addSource('active-route-source', {
          type: 'geojson',
          data: {
            type: 'FeatureCollection',
            features: pendingCoordsRef.current.length > 0 ? [
              {
                type: 'Feature',
                geometry: {
                  type: 'LineString',
                  coordinates: pendingCoordsRef.current
                },
                properties: {}
              }
            ] : []
          }
        });

        // Heavy dark outer casing
        mapInstance.addLayer({
          id: 'route-casing',
          type: 'line',
          source: 'active-route-source',
          layout: { 'line-join': 'round', 'line-cap': 'round' },
          paint: {
            'line-color': '#050811',
            'line-width': ['interpolate', ['linear'], ['zoom'], 12, 8, 16, 14],
            'line-opacity': 0.95
          }
        });

        // Golden electric highway ribbon (matching video reference)
        mapInstance.addLayer({
          id: 'route-main',
          type: 'line',
          source: 'active-route-source',
          layout: { 'line-join': 'round', 'line-cap': 'round' },
          paint: {
            'line-color': '#FFB800',
            'line-width': ['interpolate', ['linear'], ['zoom'], 12, 5, 16, 9],
            'line-opacity': 1.0
          }
        });

        // Inner glowing laser highlight
        mapInstance.addLayer({
          id: 'route-inner',
          type: 'line',
          source: 'active-route-source',
          layout: { 'line-join': 'round', 'line-cap': 'round' },
          paint: {
            'line-color': '#FFFFFF',
            'line-width': ['interpolate', ['linear'], ['zoom'], 12, 1.5, 16, 3],
            'line-opacity': 0.85
          }
        });
      }

      // 2. Fallback 3D Buildings layer (if standard 3d objects need enhancement)
      if (!mapInstance.getLayer('3d-buildings-fallback')) {
        const layers = mapInstance.getStyle().layers;
        const labelLayerId = layers?.find(l => l.type === 'symbol' && l.layout?.['text-field'])?.id;
        try {
          mapInstance.addLayer(
            {
              id: '3d-buildings-fallback',
              source: 'composite',
              'source-layer': 'building',
              filter: ['==', 'extrude', 'true'],
              type: 'fill-extrusion',
              minzoom: 14.5,
              paint: {
                'fill-extrusion-color': '#111827',
                'fill-extrusion-height': ['get', 'height'],
                'fill-extrusion-base': ['get', 'min_height'],
                'fill-extrusion-opacity': 0.65
              }
            },
            labelLayerId
          );
        } catch {
          // Standard style already includes 3d objects
        }
      }

      setIsLoaded(true);
    };

    mapInstance.on('style.load', setupSourcesAndLayers);
    mapInstance.on('load', setupSourcesAndLayers);
    mapInstance.on('error', (e) => {
      console.warn('Mapbox internal notice:', e);
    });

    mapInstance.on('click', (e) => {
      if (clickHandlerRef.current) {
        clickHandlerRef.current(e);
      }
    });

    mapRef.current = mapInstance;
    setMap(mapInstance);

    return () => {
      if (orbitIntervalRef.current) {
        clearInterval(orbitIntervalRef.current);
      }
      mapInstance.remove();
      mapRef.current = null;
      setMap(null);
    };
  }, [containerRef, initialCenter.lat, initialCenter.lng, initialLightPreset, initialPitch, initialZoom]);

  // Set Light Preset (Dawn, Day, Dusk, Night)
  const setLightPreset = useCallback((preset: LightPreset) => {
    setCurrentLightPreset(preset);
    if (!mapRef.current) return;
    try {
      mapRef.current.setConfigProperty('basemap', 'lightPreset', preset);
    } catch (err) {
      console.warn('Failed to set Mapbox light preset:', err);
    }
  }, []);

  // Update Route Polyline Coordinates
  const setRouteCoordinates = useCallback((coordinates: [number, number][]) => {
    pendingCoordsRef.current = coordinates;
    if (!mapRef.current) return;
    const source = mapRef.current.getSource('active-route-source') as mapboxgl.GeoJSONSource;
    if (!source) return;

    if (coordinates.length === 0) {
      source.setData({ type: 'FeatureCollection', features: [] });
      return;
    }

    source.setData({
      type: 'FeatureCollection',
      features: [
        {
          type: 'Feature',
          geometry: {
            type: 'LineString',
            coordinates
          },
          properties: {}
        }
      ]
    });
  }, []);

  // Fit Camera to Coordinates Bounding Box
  const fitToCoordinates = useCallback((coordinates: [number, number][]) => {
    if (!mapRef.current || coordinates.length === 0) return;
    const bounds = coordinates.reduce(
      (b, coord) => b.extend(coord as [number, number]),
      new mapboxgl.LngLatBounds(coordinates[0], coordinates[0])
    );
    mapRef.current.fitBounds(bounds, { padding: 90, duration: 1200, maxZoom: 15.5 });
  }, []);

  // Toggle 3D Tilt (Isometric perspective vs Flat)
  const toggle3DTilt = useCallback(() => {
    if (!mapRef.current) return;
    const current = mapRef.current.getPitch();
    const nextPitch = current > 20 ? 0 : 55;
    mapRef.current.easeTo({ pitch: nextPitch, duration: 900 });
    setIs3DTiltActive(nextPitch > 0);
  }, []);

  // Reset Bearing to North
  const resetNorth = useCallback(() => {
    if (!mapRef.current) return;
    mapRef.current.easeTo({ bearing: 0, pitch: 45, duration: 800 });
  }, []);

  // Toggle Continuous 360 Camera Orbit
  const toggleOrbit = useCallback(() => {
    if (isOrbiting) {
      if (orbitIntervalRef.current) clearInterval(orbitIntervalRef.current);
      orbitIntervalRef.current = null;
      setIsOrbiting(false);
    } else {
      setIsOrbiting(true);
      orbitIntervalRef.current = window.setInterval(() => {
        if (!mapRef.current) return;
        const currentBearing = mapRef.current.getBearing();
        mapRef.current.setBearing((currentBearing + 0.4) % 360);
      }, 30);
    }
  }, [isOrbiting]);

  // Center on User GPS
  const centerOnUserLocation = useCallback(() => {
    if (!navigator.geolocation || !mapRef.current) return;
    navigator.geolocation.getCurrentPosition(
      (pos) => {
        if (!mapRef.current) return;
        mapRef.current.flyTo({
          center: [pos.coords.longitude, pos.coords.latitude],
          zoom: 15.5,
          pitch: 50,
          duration: 1500
        });
      },
      (err) => console.warn('Geolocation warning:', err.message),
      { enableHighAccuracy: true, timeout: 6000 }
    );
  }, []);

  return {
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
    resize: () => mapRef.current?.resize(),
    markersRef,
    pelotonMarkersRef
  };
};
