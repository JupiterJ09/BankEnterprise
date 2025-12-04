// packages/types/src/models/trading.ts
import { OrderType, OrderSide, OrderStatus } from '../enums';

export interface TradingOrder {
  id: string;
  userId: string;
  accountId: string;
  symbol: string;
  orderType: OrderType;
  side: OrderSide;
  quantity: number;
  price: number | null;
  stopPrice: number | null;
  status: OrderStatus;
  filledQuantity: number;
  averageFillPrice: number | null;
  commission: number;
  totalCost: number | null;
  rejectionReason: string | null;
  createdAt: string;
  updatedAt: string;
  executedAt: string | null;
}