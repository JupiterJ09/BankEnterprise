-- ============================================================================
-- V7: Crear Tablas de Portfolio
-- ============================================================================
-- Descripción: Crea tablas portfolio_positions y portfolio_summaries
-- Autor: Aníbal
-- Fecha: 2024-11-27
-- ============================================================================

-- ============================================================================
-- TABLA: portfolio_positions (Posiciones en Portfolio)
-- ============================================================================

CREATE TABLE portfolio_positions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    symbol VARCHAR(10) NOT NULL REFERENCES stocks(symbol) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL,
    average_buy_price NUMERIC(10,4) NOT NULL,
    current_price NUMERIC(10,4) NOT NULL,
    total_cost NUMERIC(15,2) NOT NULL,
    current_value NUMERIC(15,2) NOT NULL,
    unrealized_pnl NUMERIC(15,2) NOT NULL,
    unrealized_pnl_percent NUMERIC(6,2) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT portfolio_positions_unique_user_symbol UNIQUE (user_id, symbol),
    CONSTRAINT portfolio_positions_quantity_positive CHECK (quantity > 0),
    CONSTRAINT portfolio_positions_average_buy_price_positive CHECK (average_buy_price > 0),
    CONSTRAINT portfolio_positions_current_price_positive CHECK (current_price > 0),
    CONSTRAINT portfolio_positions_total_cost_calculation CHECK (
        ABS(total_cost - (quantity * average_buy_price)) < 0.01
    ),
    CONSTRAINT portfolio_positions_current_value_calculation CHECK (
        ABS(current_value - (quantity * current_price)) < 0.01
    ),
    CONSTRAINT portfolio_positions_unrealized_pnl_calculation CHECK (
        ABS(unrealized_pnl - (current_value - total_cost)) < 0.01
    )
);

-- Índices para portfolio_positions
CREATE INDEX idx_portfolio_positions_user_id ON portfolio_positions(user_id);
CREATE INDEX idx_portfolio_positions_symbol ON portfolio_positions(symbol);
CREATE INDEX idx_portfolio_positions_unrealized_pnl ON portfolio_positions(unrealized_pnl DESC);
CREATE INDEX idx_portfolio_positions_updated_at ON portfolio_positions(updated_at DESC);

-- Comentario
COMMENT ON TABLE portfolio_positions IS 'Posiciones actuales en el portfolio de cada usuario';

-- ============================================================================
-- TABLA: portfolio_summaries (Resúmenes de Portfolio)
-- ============================================================================

CREATE TABLE portfolio_summaries (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    total_value NUMERIC(15,2) NOT NULL,
    cash_balance NUMERIC(15,2) NOT NULL,
    invested_value NUMERIC(15,2) NOT NULL,
    total_pnl NUMERIC(15,2) NOT NULL,
    total_pnl_percent NUMERIC(6,2) NOT NULL,
    diversification JSONB,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT portfolio_summaries_total_value_positive CHECK (total_value >= 0),
    CONSTRAINT portfolio_summaries_cash_balance_positive CHECK (cash_balance >= 0),
    CONSTRAINT portfolio_summaries_invested_value_positive CHECK (invested_value >= 0),
    CONSTRAINT portfolio_summaries_total_value_calculation CHECK (
        ABS(total_value - (cash_balance + invested_value)) < 0.01
    )
);

-- Índices para portfolio_summaries
CREATE INDEX idx_portfolio_summaries_total_pnl ON portfolio_summaries(total_pnl DESC);
CREATE INDEX idx_portfolio_summaries_updated_at ON portfolio_summaries(updated_at DESC);
CREATE INDEX idx_portfolio_summaries_diversification ON portfolio_summaries USING GIN(diversification);

-- Comentario
COMMENT ON TABLE portfolio_summaries IS 'Resumen consolidado del portfolio por usuario';
