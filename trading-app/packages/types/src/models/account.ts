/**
 * @module @trading-app/types/models/account
 */

import { AccountType, AccountStatus } from '../enums';

/**
 * Cuenta bancaria del usuario
 */
export interface Account {
  /** UUID v4 */
  id: string;
  /** FK a User.id */
  userId: string;
  /** 16 dígitos, validado con algoritmo Luhn */
  accountNumber: string;
  /** Tipo de cuenta */
  accountType: AccountType;
  /** Balance (decimal 15,2 - siempre >= 0) */
  balance: number;
  /** ISO 4217 (MXN, USD) */
  currency: string;
  /** Estado de la cuenta */
  status: AccountStatus;
  /** Tasa de interés (decimal 5,4 - solo para SAVINGS) */
  interestRate: number | null;
  /** Fecha de creación (ISO 8601 UTC) */
  createdAt: string;
  /** Última actualización (ISO 8601 UTC) */
  updatedAt: string;
}

/**
 * Balance de cuenta
 */
export interface AccountBalance {
  accountId: string;
  balance: number;
  currency: string;
  lastUpdated: string;
}
