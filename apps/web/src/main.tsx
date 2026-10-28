/**
 * =========================================================================
 * ZEROMILE GO - REACT ROOT ENTRY (main.tsx)
 * =========================================================================
 */

import React from 'react';
import ReactDOM from 'react-dom/client';
import { App } from './App';
import { DomainProvider } from './context/DomainContext';
import { AuthProvider } from './context/AuthContext';
import { ToastProvider } from './context/ToastContext';
import 'mapbox-gl/dist/mapbox-gl.css';
import './styles/global.css';
import './styles/platform.css';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <DomainProvider>
      <AuthProvider>
        <ToastProvider>
          <App />
        </ToastProvider>
      </AuthProvider>
    </DomainProvider>
  </React.StrictMode>
);
