-- ============================================================================
-- V6: Crear Tabla de Trading Orders
-- ============================================================================
-- Descripción: Crea tabla trading_orders
-- Autor: Aníbal
-- Fecha: 2024-11-27
-- ============================================================================

-- ============================================================================
-- TABLA: trading_orders (Órdenes de Trading)
-- ============================================================================

CREATE TABLE trading_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    account_id UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    symbol VARCHAR(10) NOT NULL REFERENCES stocks(symbol) ON DELETE RESTRICT,
    order_type order_type NOT NULL,
    side order_side NOT NULL,
    quantity INTEGER NOT NULL,
    price NUMERIC(10,4),
    stop_price NUMERIC(10,4),
    status order_status NOT NULL DEFAULT 'PENDING',
    filled_quantity INTEGER NOT NULL DEFAULT 0,
    average_fill_price NUMERIC(10,4),
    commission NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    total_cost NUMERIC(15,2),
    rejection_reason VARCHAR(200),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    executed_at TIMESTAMP WITH TIME ZONE,
    
    -- Constraints
    CONSTRAINT trading_orders_quantity_positive CHECK (quantity > 0),
    CONSTRAINT trading_orders_filled_quantity_valid CHECK (
        filled_quantity >= 0 AND filled_quantity <= quantity
    ),
    CONSTRAINT trading_orders_price_check CHECK (
        (order_type = 'MARKET' AND price IS NULL) OR
        (order_type != 'MARKET' AND price IS NOT NULL AND price > 0)
    ),
    CONSTRAINT trading_orders_stop_price_check CHECK (
        (order_type IN ('STOP_LOSS', 'STOP_LIMIT') AND stop_price IS NOT NULL AND stop_price > 0) OR
        (order_type NOT IN ('STOP_LOSS', 'STOP_LIMIT') AND stop_price IS NULL)
    ),
    CONSTRAINT trading_orders_commission_positive CHECK (commission >= 0),
    CONSTRAINT trading_orders_executed_at_check CHECK (
        (status IN ('FILLED', 'PARTIALLY_FILLED') AND executed_at IS NOT NULL) OR
        (status NOT IN ('FILLED', 'PARTIALLY_FILLED'))
    ),
    CONSTRAINT trading_orders_rejection_reason_check CHECK (
        (status = 'REJECTED' AND rejection_reason IS NOT NULL) OR
        (status != 'REJECTED' AND rejection_reason IS NULL)
    )
);

-- Índices para trading_orders
CREATE INDEX idx_trading_orders_user_id ON trading_orders(user_id);
CREATE INDEX idx_trading_orders_account_id ON trading_orders(account_id);
CREATE INDEX idx_trading_orders_symbol ON trading_orders(symbol);
CREATE INDEX idx_trading_orders_status ON trading_orders(status);
CREATE INDEX idx_trading_orders_side ON trading_orders(side);
CREATE INDEX idx_trading_orders_created_at ON trading_orders(created_at DESC);
CREATE INDEX idx_trading_orders_user_symbol ON trading_orders(user_id, symbol);

-- Comentario
COMMENT ON TABLE trading_orders IS 'Órdenes de compra/venta de acciones';
