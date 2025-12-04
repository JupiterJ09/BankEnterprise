/**
 * @module @trading-app/types/models/user
 */

import { UserRole, UserStatus } from '../enums';

/**
 * Preferencias de notificaciones del usuario
 */
export interface NotificationPreferences {
  emailNotifications: boolean;
  pushNotifications: boolean;
  smsNotifications: boolean;
  tradingAlerts: boolean;
  priceAlerts: boolean;
  newsAlerts: boolean;
}

/**
 * Usuario principal del sistema
 */
export interface User {
  /** UUID v4 */
  id: string;
  /** Email único y válido */
  email: string;
  /** Hash bcrypt (10 rounds) */
  passwordHash: string;
  /** Nombre (max 50 caracteres) */
  firstName: string;
  /** Apellido (max 50 caracteres) */
  lastName: string;
  /** Formato E.164: +521234567890 */
  phoneNumber: string | null;
  /** Rol del usuario */
  role: UserRole;
  /** Estado de la cuenta */
  status: UserStatus;
  /** Email verificado */
  emailVerified: boolean;
  /** 2FA habilitado */
  twoFactorEnabled: boolean;
  /** Fecha de creación (ISO 8601 UTC) */
  createdAt: string;
  /** Última actualización (ISO 8601 UTC) */
  updatedAt: string;
}

/**
 * Perfil extendido del usuario
 */
export interface UserProfile {
  /** FK a User.id */
  userId: string;
  /** URL del avatar */
  avatarUrl: string | null;
  /** Biografía (max 500 caracteres) */
  bio: string | null;
  /** Formato IANA: America/Mexico_City */
  timezone: string;
  /** Formato BCP 47: es-MX, en-US */
  locale: string;
  /** ISO 4217: MXN, USD */
  currency: string;
  /** Preferencias de notificaciones */
  notificationPreferences: NotificationPreferences;
}

/**
 * DTO para registro de usuario (sin campos sensibles)
 */
export interface UserDTO {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  phoneNumber: string | null;
  role: UserRole;
  status: UserStatus;
  emailVerified: boolean;
  twoFactorEnabled: boolean;
  createdAt: string;
  updatedAt: string;
}
