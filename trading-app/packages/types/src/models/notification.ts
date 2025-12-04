/**
 * @module @trading-app/types/models/notification
 */

import { NotificationType, NotificationPriority } from '../enums';

/**
 * Notificación del sistema
 */
export interface Notification {
  /** UUID v4 */
  id: string;
  /** FK a User.id */
  userId: string;
  /** Tipo de notificación */
  type: NotificationType;
  /** Título (max 100 caracteres) */
  title: string;
  /** Mensaje (max 500 caracteres) */
  message: string;
  /** Prioridad */
  priority: NotificationPriority;
  /** Leída o no (default: false) */
  isRead: boolean;
  /** Datos adicionales */
  metadata: Record<string, any>;
  /** Fecha de creación (ISO 8601 UTC) */
  createdAt: string;
  /** Fecha de lectura (ISO 8601 UTC) */
  readAt: string | null;
}
