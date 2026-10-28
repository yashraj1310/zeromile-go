/**
 * =========================================================================
 * ZEROMILE GO - AUTHENTICATION & ACCESS CONTROL CONTEXT (AuthContext.tsx)
 * Enforces SuperAdmin Authorization & Unlocked Guest Explorer Mode
 * =========================================================================
 */

import React, { createContext, useContext, useState, useEffect } from 'react';
import { UserRole } from '../types';
import { verifySuperAdminPermission } from '../services/supabaseAuth';
import { useDomain } from './DomainContext';

interface AuthContextType {
  role: UserRole;
  phone: string | null;
  isAuthenticatedAdmin: boolean;
  isGuestMode: boolean;
  isLoginModalOpen: boolean;
  openLoginModal: () => void;
  closeLoginModal: () => void;
  authenticateAsSuperAdmin: (phone: string) => Promise<{ success: boolean; message?: string }>;
  enableGuestMode: () => void;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType>({
  role: 'GUEST',
  phone: null,
  isAuthenticatedAdmin: false,
  isGuestMode: false,
  isLoginModalOpen: false,
  openLoginModal: () => {},
  closeLoginModal: () => {},
  authenticateAsSuperAdmin: async () => ({ success: false }),
  enableGuestMode: () => {},
  logout: () => {}
});

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [role, setRole] = useState<UserRole>('GUEST');
  const [phone, setPhone] = useState<string | null>(null);
  const [isGuestMode, setIsGuestMode] = useState(false);
  const [isLoginModalOpen, setIsLoginModalOpen] = useState(false);
  const { currentDomain } = useDomain();

  // Re-verify authorization when domain changes
  useEffect(() => {
    if (role === 'SUPERADMIN' && phone) {
      verifySuperAdminPermission(phone, currentDomain.id).then(res => {
        if (!res.authorized) {
          console.warn('SuperAdmin permission lost for newly selected domain:', res.message);
        }
      });
    }
  }, [currentDomain.id, phone, role]);

  const openLoginModal = () => setIsLoginModalOpen(true);
  const closeLoginModal = () => setIsLoginModalOpen(false);

  const authenticateAsSuperAdmin = async (inputPhone: string): Promise<{ success: boolean; message?: string }> => {
    const cleanPhone = inputPhone.replace(/^\+91/, '').replace(/\s+/g, '').trim();
    if (cleanPhone.length < 10) {
      return { success: false, message: 'Please enter a valid 10-digit mobile number.' };
    }

    const check = await verifySuperAdminPermission(cleanPhone, currentDomain.id);
    if (!check.authorized) {
      return {
        success: false,
        message: check.message || 'Access Denied: Not an authorized SuperAdmin.'
      };
    }

    // Role authorized
    setRole('SUPERADMIN');
    setPhone(cleanPhone);
    setIsGuestMode(false);
    closeLoginModal();
    return { success: true };
  };

  const enableGuestMode = () => {
    setIsGuestMode(true);
    closeLoginModal();
  };

  const logout = () => {
    setRole('GUEST');
    setPhone(null);
    setIsGuestMode(false);
  };

  return (
    <AuthContext.Provider
      value={{
        role,
        phone,
        isAuthenticatedAdmin: role === 'SUPERADMIN',
        isGuestMode,
        isLoginModalOpen,
        openLoginModal,
        closeLoginModal,
        authenticateAsSuperAdmin,
        enableGuestMode,
        logout
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);
