/**
 * @module @trading-app/types/models/transaction
 */

import { TransactionType, TransactionStatus } from '../enums';

/**
 * Transacción bancaria o de trading
 */
export interface Transaction {
  /** UUID v4 */
  id: string;
  /** FK a Account.id */
  accountId: string;
  /** Tipo de transacción */
  type: TransactionType;
  /** Monto (decimal 15,2 - siempre > 0) */
  amount: number;
  /** Balance después de la transacción (decimal 15,2) */
  balanceAfter: number;
  /** Descripción (max 200 caracteres) */
  description: string;
  /** Número de referencia externo */
  reference: string | null;
  /** Estado de la transacción */
  status: TransactionStatus;
  /** Datos adicionales flexibles */
  metadata: Record<string, any>;
  /** Fecha de creación (ISO 8601 UTC) */
  createdAt: string;
  /** Fecha de completado (ISO 8601 UTC) */
  completedAt: string | null;
}
