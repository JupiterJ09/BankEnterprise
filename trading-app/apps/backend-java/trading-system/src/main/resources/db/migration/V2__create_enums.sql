-- ============================================================================
-- V2: Crear Tipos Enumerados (ENUMs)
-- ============================================================================
-- Descripción: Define todos los tipos enumerados del sistema
-- Autor: Aníbal
-- Fecha: 2024-11-27
-- ============================================================================

-- Roles de usuario
CREATE TYPE user_role AS ENUM ('USER', 'TRADER', 'ADMIN');

-- Estado de usuario
CREATE TYPE user_status AS ENUM ('ACTIVE', 'SUSPENDED', 'CLOSED');

-- Tipo de cuenta bancaria
CREATE TYPE account_type AS ENUM ('SAVINGS', 'CHECKING', 'INVESTMENT');

-- Estado de cuenta
CREATE TYPE account_status AS ENUM ('ACTIVE', 'FROZEN', 'CLOSED');

-- Tipo de transacción
CREATE TYPE transaction_type AS ENUM (
    'DEPOSIT', 
    'WITHDRAWAL', 
    'TRANSFER_IN', 
    'TRANSFER_OUT', 
    'TRADE_BUY', 
    'TRADE_SELL'
);

-- Estado de transacción
CREATE TYPE transaction_status AS ENUM ('PENDING', 'COMPLETED', 'FAILED', 'REVERSED');

-- Tipo de orden de trading
CREATE TYPE order_type AS ENUM ('MARKET', 'LIMIT', 'STOP_LOSS', 'STOP_LIMIT');

-- Lado de la orden (compra/venta)
CREATE TYPE order_side AS ENUM ('BUY', 'SELL');

-- Estado de orden de trading
CREATE TYPE order_status AS ENUM (
    'PENDING', 
    'PARTIALLY_FILLED', 
    'FILLED', 
    'CANCELLED', 
    'REJECTED'
);

-- Dirección de predicción ML
CREATE TYPE prediction_direction AS ENUM ('UP', 'DOWN', 'NEUTRAL');

-- Tipo de notificación
CREATE TYPE notification_type AS ENUM (
    'TRADE_EXECUTED', 
    'PRICE_ALERT', 
    'TRANSACTION', 
    'SECURITY', 
    'SYSTEM', 
    'NEWS'
);

-- Prioridad de notificación
CREATE TYPE notification_priority AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'URGENT');
