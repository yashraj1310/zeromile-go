/**
 * =========================================================================
 * ZEROMILE GO - ROUTE HISTORY HOOK (useRouteHistory.ts)
 * Undo / Redo State Stack for Route Waypoints & Coordinates
 * =========================================================================
 */

import { useState, useCallback } from 'react';
import { NamedLocation } from '../../../types';

export interface RouteSnapshot {
  origin: NamedLocation;
  destination: NamedLocation;
  waypoints: NamedLocation[];
}

export const useRouteHistory = (initialState: RouteSnapshot) => {
  const [history, setHistory] = useState<RouteSnapshot[]>([initialState]);
  const [currentIndex, setCurrentIndex] = useState(0);

  const currentSnapshot = history[currentIndex] || initialState;

  const pushState = useCallback((newSnapshot: RouteSnapshot) => {
    setHistory(prev => {
      const trimmed = prev.slice(0, currentIndex + 1);
      return [...trimmed, newSnapshot];
    });
    setCurrentIndex(prev => prev + 1);
  }, [currentIndex]);

  const undo = useCallback(() => {
    if (currentIndex > 0) {
      setCurrentIndex(prev => prev - 1);
    }
  }, [currentIndex]);

  const redo = useCallback(() => {
    if (currentIndex < history.length - 1) {
      setCurrentIndex(prev => prev + 1);
    }
  }, [currentIndex, history.length]);

  const canUndo = currentIndex > 0;
  const canRedo = currentIndex < history.length - 1;

  return {
    currentSnapshot,
    pushState,
    undo,
    redo,
    canUndo,
    canRedo
  };
};
