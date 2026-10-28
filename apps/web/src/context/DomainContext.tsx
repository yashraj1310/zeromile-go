/**
 * =========================================================================
 * ZEROMILE GO - TENANT DOMAIN CONTEXT (DomainContext.tsx)
 * Multi-Domain Civic Event State Management
 * =========================================================================
 */

import React, { createContext, useContext, useState } from 'react';
import { DomainMetadata } from '../types';

export const OFFICIAL_DOMAINS: DomainMetadata[] = [
  {
    id: 'a1111111-1111-1111-1111-111111111111',
    slug: 'cycling-2026',
    title: 'Nagpur Grand Cyclothon 2026',
    type: 'CYCLING',
    icon: '🚴',
    dateStr: 'Sunday, 15 Nov 2026 • 06:00 AM',
    color: '#00F2FE',
    themeColor: 'rgba(0, 242, 254, 0.2)',
    primaryStart: { name: 'Zero Mile Monument Arch', lat: 21.1498, lng: 79.0806 },
    primaryFinish: { name: 'VNIT Main Gate, South Ambazari', lat: 21.1280, lng: 79.0520 },
    defaultWaypoints: [
      { name: 'Law College Square Junction', lat: 21.1390, lng: 79.0680 },
      { name: 'Futala Lake Waterfront', lat: 21.1550, lng: 79.0460 }
    ],
    estimatedDistanceKm: 24.2,
    estimatedDurationMin: 65
  },
  {
    id: 'b2222222-2222-2222-2222-222222222222',
    slug: 'marathon-2026',
    title: 'Nagpur City Marathon 2026',
    type: 'MARATHON',
    icon: '🏃',
    dateStr: 'Sunday, 22 Nov 2026 • 05:30 AM',
    color: '#00E676',
    themeColor: 'rgba(0, 230, 118, 0.2)',
    primaryStart: { name: 'Civil Lines Japanese Garden', lat: 21.1620, lng: 79.0620 },
    primaryFinish: { name: 'Sitabuldi Interchange', lat: 21.1460, lng: 79.0820 },
    defaultWaypoints: [
      { name: 'Samvidhan Square (RBI Chowk)', lat: 21.1510, lng: 79.0840 },
      { name: 'Medical Square Junction', lat: 21.1340, lng: 79.0960 }
    ],
    estimatedDistanceKm: 42.1,
    estimatedDurationMin: 210
  },
  {
    id: 'c3333333-3333-3333-3333-333333333333',
    slug: 'walkathon-2026',
    title: 'Citizen Environmental Walkathon',
    type: 'WALKATHON',
    icon: '🚶',
    dateStr: 'Saturday, 28 Nov 2026 • 07:00 AM',
    color: '#FF9100',
    themeColor: 'rgba(255, 145, 0, 0.2)',
    primaryStart: { name: 'Deekshabhoomi Sacred Monument', lat: 21.1270, lng: 79.0700 },
    primaryFinish: { name: 'Ambazari Lake Park', lat: 21.1270, lng: 79.0390 },
    defaultWaypoints: [
      { name: 'Bajaj Nagar Square', lat: 21.1230, lng: 79.0610 }
    ],
    estimatedDistanceKm: 8.5,
    estimatedDurationMin: 90
  }
];

interface DomainContextType {
  currentDomain: DomainMetadata;
  switchDomain: (domainId: string) => void;
  domains: DomainMetadata[];
}

const DomainContext = createContext<DomainContextType>({
  currentDomain: OFFICIAL_DOMAINS[0],
  switchDomain: () => {},
  domains: OFFICIAL_DOMAINS
});

export const DomainProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [currentDomain, setCurrentDomain] = useState<DomainMetadata>(OFFICIAL_DOMAINS[0]);

  const switchDomain = (domainId: string) => {
    const found = OFFICIAL_DOMAINS.find(d => d.id === domainId || d.slug === domainId);
    if (found) setCurrentDomain(found);
  };

  return (
    <DomainContext.Provider value={{ currentDomain, switchDomain, domains: OFFICIAL_DOMAINS }}>
      {children}
    </DomainContext.Provider>
  );
};

export const useDomain = () => useContext(DomainContext);
