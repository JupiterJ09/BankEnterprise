-- ============================================================================
-- V5: Crear Tablas de Stocks
-- ============================================================================
-- Descripción: Crea tablas stocks y stock_price_history
-- Autor: Aníbal
-- Fecha: 2024-11-27
-- ============================================================================

-- ============================================================================
-- TABLA: stocks (Acciones)
-- ============================================================================

CREATE TABLE stocks (
    symbol VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    exchange VARCHAR(20) NOT NULL,
    sector VARCHAR(50) NOT NULL,
    current_price NUMERIC(10,4) NOT NULL,
    previous_close NUMERIC(10,4) NOT NULL,
    change_percent NUMERIC(6,2) NOT NULL,
    volume BIGINT NOT NULL,
    market_cap BIGINT,
    last_updated TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT stocks_symbol_uppercase CHECK (symbol = UPPER(symbol)),
    CONSTRAINT stocks_current_price_positive CHECK (current_price > 0),
    CONSTRAINT stocks_previous_close_positive CHECK (previous_close > 0),
    CONSTRAINT stocks_volume_positive CHECK (volume >= 0),
    CONSTRAINT stocks_market_cap_positive CHECK (market_cap IS NULL OR market_cap > 0)
);

-- Índices para stocks
CREATE INDEX idx_stocks_exchange ON stocks(exchange);
CREATE INDEX idx_stocks_sector ON stocks(sector);
CREATE INDEX idx_stocks_last_updated ON stocks(last_updated DESC);
CREATE INDEX idx_stocks_change_percent ON stocks(change_percent DESC);

-- Comentario
COMMENT ON TABLE stocks IS 'Información de acciones disponibles para trading';

-- ============================================================================
-- TABLA: stock_price_history (Historial de Precios OHLCV)
-- ============================================================================

CREATE TABLE stock_price_history (
    id BIGSERIAL PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL REFERENCES stocks(symbol) ON DELETE CASCADE,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    open NUMERIC(10,4) NOT NULL,
    high NUMERIC(10,4) NOT NULL,
    low NUMERIC(10,4) NOT NULL,
    close NUMERIC(10,4) NOT NULL,
    volume BIGINT NOT NULL,
    adjusted_close NUMERIC(10,4),
    
    -- Constraints
    CONSTRAINT stock_price_history_unique_symbol_timestamp UNIQUE (symbol, timestamp),
    CONSTRAINT stock_price_history_ohlc_valid CHECK (
        high >= low AND
        high >= open AND
        high >= close AND
        low <= open AND
        low <= close
    ),
    CONSTRAINT stock_price_history_prices_positive CHECK (
        open > 0 AND high > 0 AND low > 0 AND close > 0
    ),
    CONSTRAINT stock_price_history_volume_positive CHECK (volume >= 0)
);

-- Índices para stock_price_history
CREATE INDEX idx_stock_price_history_symbol ON stock_price_history(symbol);
CREATE INDEX idx_stock_price_history_timestamp ON stock_price_history(timestamp DESC);
CREATE INDEX idx_stock_price_history_symbol_timestamp ON stock_price_history(symbol, timestamp DESC);

-- Comentario
COMMENT ON TABLE stock_price_history IS 'Historial OHLCV de precios de acciones';
