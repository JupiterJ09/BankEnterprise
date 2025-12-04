/**
 * @module @trading-app/types/models/trading
 */

import { OrderType, OrderSide, OrderStatus } from '../enums';

/**
 * Orden de trading
 */
export interface TradingOrder {
  /** UUID v4 */
  id: string;
  /** FK a User.id */
  userId: string;
  /** FK a Account.id */
  accountId: string;
  /** FK a Stock.symbol */
  symbol: string;
  /** Tipo de orden */
  orderType: OrderType;
  /** Lado de la orden (compra/venta) */
  side: OrderSide;
  /** Cantidad (integer - siempre > 0) */
  quantity: number;
  /** Precio límite (decimal 10,4 - null para órdenes MARKET) */
  price: number | null;
  /** Precio stop (decimal 10,4 - solo para órdenes STOP) */
  stopPrice: number | null;
  /** Estado de la orden */
  status: OrderStatus;
  /** Cantidad ejecutada (integer - 0 <= filledQuantity <= quantity) */
  filledQuantity: number;
  /** Precio promedio de ejecución (decimal 10,4) */
  averageFillPrice: number | null;
  /** Comisión (decimal 10,2) */
  commission: number;
  /** Costo total (decimal 15,2) */
  totalCost: number | null;
  /** Razón de rechazo (max 200 caracteres) */
  rejectionReason: string | null;
  /** Fecha de creación (ISO 8601 UTC) */
  createdAt: string;
  /** Última actualización (ISO 8601 UTC) */
  updatedAt: string;
  /** Fecha de ejecución (ISO 8601 UTC) */
  executedAt: string | null;
}
