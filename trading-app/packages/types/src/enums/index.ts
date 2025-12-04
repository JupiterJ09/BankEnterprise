/**
 * @module @trading-app/types/enums
 */

// User Enums
export enum UserRole {
  USER = 'USER',
  TRADER = 'TRADER',
  ADMIN = 'ADMIN'
}

export enum UserStatus {
  ACTIVE = 'ACTIVE',
  SUSPENDED = 'SUSPENDED',
  CLOSED = 'CLOSED'
}

// Account Enums
export enum AccountType {
  SAVINGS = 'SAVINGS',
  CHECKING = 'CHECKING',
  INVESTMENT = 'INVESTMENT'
}

export enum AccountStatus {
  ACTIVE = 'ACTIVE',
  FROZEN = 'FROZEN',
  CLOSED = 'CLOSED'
}

// Transaction Enums
export enum TransactionType {
  DEPOSIT = 'DEPOSIT',
  WITHDRAWAL = 'WITHDRAWAL',
  TRANSFER_IN = 'TRANSFER_IN',
  TRANSFER_OUT = 'TRANSFER_OUT',
  TRADE_BUY = 'TRADE_BUY',
  TRADE_SELL = 'TRADE_SELL'
}

export enum TransactionStatus {
  PENDING = 'PENDING',
  COMPLETED = 'COMPLETED',
  FAILED = 'FAILED',
  REVERSED = 'REVERSED'
}

// Trading Enums
export enum OrderType {
  MARKET = 'MARKET',
  LIMIT = 'LIMIT',
  STOP_LOSS = 'STOP_LOSS',
  STOP_LIMIT = 'STOP_LIMIT'
}

export enum OrderSide {
  BUY = 'BUY',
  SELL = 'SELL'
}

export enum OrderStatus {
  PENDING = 'PENDING',
  PARTIALLY_FILLED = 'PARTIALLY_FILLED',
  FILLED = 'FILLED',
  CANCELLED = 'CANCELLED',
  REJECTED = 'REJECTED'
}

// Notification Enums
export enum NotificationType {
  TRADE_EXECUTED = 'TRADE_EXECUTED',
  PRICE_ALERT = 'PRICE_ALERT',
  TRANSACTION = 'TRANSACTION',
  SECURITY = 'SECURITY',
  SYSTEM = 'SYSTEM',
  NEWS = 'NEWS'
}

export enum NotificationPriority {
  LOW = 'LOW',
  MEDIUM = 'MEDIUM',
  HIGH = 'HIGH',
  URGENT = 'URGENT'
}

// Stock Market Enums
export enum Exchange {
  NYSE = 'NYSE',
  NASDAQ = 'NASDAQ',
  BMV = 'BMV'
}

// Prediction Enums
export enum PredictionDirection {
  UP = 'UP',
  DOWN = 'DOWN',
  NEUTRAL = 'NEUTRAL'
}

// Risk Tolerance
export enum RiskTolerance {
  LOW = 'LOW',
  MEDIUM = 'MEDIUM',
  HIGH = 'HIGH'
}
