/**
 * =========================================================================
 * ZEROMILE GO - REUSABLE LOCATION SEARCH INPUT COMPONENT (LocationSearchInput.tsx)
 * Debounced Geocoding • Keyboard Accessible • Race-Condition Proof • Mobile-Ready
 * =========================================================================
 */

import React, { useState, useEffect, useRef, useCallback } from 'react';
import { NamedLocation } from '../../types';
import { searchLocations } from '../../services/geocodingService';
import { Search, X, Loader2, MapPin, Building, GraduationCap, Cross, Waves, TreePine, Train } from 'lucide-react';

interface LocationSearchInputProps {
  label?: string;
  placeholder?: string;
  value: NamedLocation | null;
  onSelect: (location: NamedLocation) => void;
  accentColor?: string;
  showClearButton?: boolean;
  className?: string;
}

export const LocationSearchInput: React.FC<LocationSearchInputProps> = ({
  label,
  placeholder = 'Search locations in Nagpur...',
  value,
  onSelect,
  accentColor = '#00F2FE',
  showClearButton = true
}) => {
  const [inputValue, setInputValue] = useState(value?.name || '');
  const [results, setResults] = useState<NamedLocation[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [isOpen, setIsOpen] = useState(false);
  const [highlightedIndex, setHighlightedIndex] = useState(-1);
  const [hasSearched, setHasSearched] = useState(false);

  const containerRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);
  const abortControllerRef = useRef<AbortController | null>(null);
  const debounceTimerRef = useRef<NodeJS.Timeout | null>(null);

  // Sync internal state when external value changes
  useEffect(() => {
    if (value) {
      setInputValue(value.name);
    }
  }, [value]);

  // Click outside to dismiss dropdown
  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setIsOpen(false);
        setHighlightedIndex(-1);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Perform debounced geocoding search
  const performSearch = useCallback((query: string) => {
    if (debounceTimerRef.current) {
      clearTimeout(debounceTimerRef.current);
    }

    if (abortControllerRef.current) {
      abortControllerRef.current.abort();
    }

    const trimmed = query.trim();
    if (!trimmed) {
      setResults([]);
      setIsLoading(false);
      setHasSearched(false);
      return;
    }

    setIsLoading(true);
    setHasSearched(true);

    const controller = new AbortController();
    abortControllerRef.current = controller;

    debounceTimerRef.current = setTimeout(async () => {
      try {
        const data = await searchLocations(trimmed, controller.signal);
        setResults(data);
        setHighlightedIndex(data.length > 0 ? 0 : -1);
      } catch (err: unknown) {
        if ((err as Error)?.name !== 'AbortError') {
          console.warn('Geocoding search warning:', err);
        }
      } finally {
        setIsLoading(false);
      }
    }, 250);
  }, []);

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newVal = e.target.value;
    setInputValue(newVal);
    setIsOpen(true);
    performSearch(newVal);
  };

  const handleSelectLocation = (loc: NamedLocation) => {
    setInputValue(loc.name);
    setIsOpen(false);
    setResults([]);
    setHighlightedIndex(-1);
    onSelect(loc);
  };

  const handleClear = () => {
    setInputValue('');
    setResults([]);
    setIsOpen(false);
    setHasSearched(false);
    inputRef.current?.focus();
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (!isOpen || results.length === 0) {
      if (e.key === 'ArrowDown' || e.key === 'Enter') {
        setIsOpen(true);
        performSearch(inputValue);
      }
      return;
    }

    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault();
        setHighlightedIndex(prev => (prev < results.length - 1 ? prev + 1 : 0));
        break;
      case 'ArrowUp':
        e.preventDefault();
        setHighlightedIndex(prev => (prev > 0 ? prev - 1 : results.length - 1));
        break;
      case 'Enter':
        e.preventDefault();
        if (highlightedIndex >= 0 && highlightedIndex < results.length) {
          handleSelectLocation(results[highlightedIndex]);
        }
        break;
      case 'Escape':
        e.preventDefault();
        setIsOpen(false);
        setHighlightedIndex(-1);
        break;
      default:
        break;
    }
  };

  const renderIcon = (type?: string) => {
    switch (type) {
      case 'COLLEGE':
        return <GraduationCap size={15} color="#00F2FE" />;
      case 'HOSPITAL':
        return <Cross size={15} color="#FF1744" />;
      case 'LAKE':
        return <Waves size={15} color="#2979FF" />;
      case 'PARK':
        return <TreePine size={15} color="#00E676" />;
      case 'TRANSIT':
        return <Train size={15} color="#FFB800" />;
      case 'MONUMENT':
        return <Building size={15} color="#FFD700" />;
      default:
        return <MapPin size={15} color="#94A3B8" />;
    }
  };

  return (
    <div ref={containerRef} style={{ position: 'relative', width: '100%' }}>
      {label && (
        <div style={{ fontSize: '9px', fontWeight: 800, color: accentColor, marginBottom: '2px', letterSpacing: '0.4px' }}>
          {label}
        </div>
      )}

      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
          background: 'rgba(0, 0, 0, 0.25)',
          borderRadius: '10px',
          padding: '4px 8px',
          border: isOpen ? `1px solid ${accentColor}` : '1px solid rgba(255, 255, 255, 0.1)',
          transition: 'border-color 0.2s',
          width: '100%'
        }}
      >
        <Search size={14} color="#64748B" />

        <input
          ref={inputRef}
          type="text"
          value={inputValue}
          placeholder={placeholder}
          onChange={handleInputChange}
          onKeyDown={handleKeyDown}
          onFocus={() => {
            if (inputValue.trim()) {
              setIsOpen(true);
              performSearch(inputValue);
            }
          }}
          style={{
            flex: 1,
            background: 'transparent',
            border: 'none',
            color: '#fff',
            fontSize: '13px',
            fontWeight: 600,
            outline: 'none',
            minWidth: 0
          }}
        />

        {isLoading && (
          <Loader2 size={14} color={accentColor} className="spin-animation" style={{ animation: 'spin 1s linear infinite' }} />
        )}

        {showClearButton && inputValue && !isLoading && (
          <button
            type="button"
            onClick={handleClear}
            title="Clear Search"
            style={{
              background: 'none',
              border: 'none',
              color: '#64748B',
              cursor: 'pointer',
              padding: '2px',
              display: 'flex',
              alignItems: 'center'
            }}
          >
            <X size={13} />
          </button>
        )}
      </div>

      {/* Autocomplete Dropdown Menu */}
      {isOpen && (
        <div
          style={{
            position: 'absolute',
            top: 'calc(100% + 6px)',
            left: 0,
            right: 0,
            maxHeight: '260px',
            overflowY: 'auto',
            background: '#0d1527',
            border: '1px solid rgba(255, 255, 255, 0.16)',
            borderRadius: '12px',
            boxShadow: '0 16px 40px rgba(0, 0, 0, 0.7)',
            zIndex: 100,
            padding: '4px'
          }}
        >
          {results.length > 0 ? (
            results.map((item, idx) => {
              const isSelected = idx === highlightedIndex;
              return (
                <div
                  key={item.id || `${item.name}-${idx}`}
                  onMouseDown={(e) => {
                    // Use onMouseDown so it executes before onBlur
                    e.preventDefault();
                    handleSelectLocation(item);
                  }}
                  onMouseEnter={() => setHighlightedIndex(idx)}
                  style={{
                    display: 'flex',
                    alignItems: 'flex-start',
                    gap: '10px',
                    padding: '8px 12px',
                    borderRadius: '8px',
                    cursor: 'pointer',
                    background: isSelected ? 'rgba(0, 242, 254, 0.15)' : 'transparent',
                    borderLeft: isSelected ? `3px solid ${accentColor}` : '3px solid transparent',
                    transition: 'all 0.15s'
                  }}
                >
                  <div style={{ marginTop: '2px', flexShrink: 0 }}>{renderIcon(item.type)}</div>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: '12px', fontWeight: 700, color: '#fff', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                      {item.name}
                    </div>
                    {item.address && item.address !== item.name && (
                      <div style={{ fontSize: '10px', color: '#94A3B8', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis', marginTop: '1px' }}>
                        {item.address}
                      </div>
                    )}
                  </div>
                </div>
              );
            })
          ) : hasSearched && !isLoading ? (
            <div style={{ padding: '12px', textAlign: 'center', fontSize: '12px', color: '#64748B' }}>
              No places found in Nagpur. Try "Dharampeth", "Sitabuldi", or "Zero Mile".
            </div>
          ) : null}
        </div>
      )}
    </div>
  );
};
