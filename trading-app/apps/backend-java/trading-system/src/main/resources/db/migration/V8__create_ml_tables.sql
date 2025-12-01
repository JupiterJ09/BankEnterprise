-- ============================================================================
-- V8: Crear Tablas de Machine Learning
-- ============================================================================
-- Descripción: Crea tablas stock_predictions y technical_indicators
-- Autor: Aníbal
-- Fecha: 2024-11-27
-- ============================================================================

-- ============================================================================
-- TABLA: stock_predictions (Predicciones ML)
-- ============================================================================

CREATE TABLE stock_predictions (
    id BIGSERIAL PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL REFERENCES stocks(symbol) ON DELETE CASCADE,
    prediction_date DATE NOT NULL,
    predicted_price NUMERIC(10,4) NOT NULL,
    confidence NUMERIC(5,4) NOT NULL,
    direction prediction_direction NOT NULL,
    target_date DATE NOT NULL,
    model VARCHAR(50) NOT NULL,
    features JSONB,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT stock_predictions_unique_symbol_prediction_date UNIQUE (symbol, prediction_date, model),
    CONSTRAINT stock_predictions_predicted_price_positive CHECK (predicted_price > 0),
    CONSTRAINT stock_predictions_confidence_range CHECK (confidence >= 0 AND confidence <= 1),
    CONSTRAINT stock_predictions_target_date_future CHECK (target_date > prediction_date)
);

-- Índices para stock_predictions
CREATE INDEX idx_stock_predictions_symbol ON stock_predictions(symbol);
CREATE INDEX idx_stock_predictions_prediction_date ON stock_predictions(prediction_date DESC);
CREATE INDEX idx_stock_predictions_target_date ON stock_predictions(target_date);
CREATE INDEX idx_stock_predictions_model ON stock_predictions(model);
CREATE INDEX idx_stock_predictions_confidence ON stock_predictions(confidence DESC);

-- Comentario
COMMENT ON TABLE stock_predictions IS 'Predicciones de Machine Learning para acciones';

-- ============================================================================
-- TABLA: technical_indicators (Indicadores Técnicos)
-- ============================================================================

CREATE TABLE technical_indicators (
    id BIGSERIAL PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL REFERENCES stocks(symbol) ON DELETE CASCADE,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    
    -- Indicadores
    rsi NUMERIC(5,2),
    macd NUMERIC(10,4),
    macd_signal NUMERIC(10,4),
    sma_20 NUMERIC(10,4),
    sma_50 NUMERIC(10,4),
    sma_200 NUMERIC(10,4),
    ema_12 NUMERIC(10,4),
    ema_26 NUMERIC(10,4),
    bollinger_upper NUMERIC(10,4),
    bollinger_middle NUMERIC(10,4),
    bollinger_lower NUMERIC(10,4),
    atr NUMERIC(10,4),
    volume BIGINT NOT NULL,
    
    -- Constraints
    CONSTRAINT technical_indicators_unique_symbol_timestamp UNIQUE (symbol, timestamp),
    CONSTRAINT technical_indicators_rsi_range CHECK (rsi IS NULL OR (rsi >= 0 AND rsi <= 100)),
    CONSTRAINT technical_indicators_volume_positive CHECK (volume >= 0),
    CONSTRAINT technical_indicators_bollinger_order CHECK (
        (bollinger_upper IS NULL OR bollinger_middle IS NULL OR bollinger_lower IS NULL) OR
        (bollinger_upper >= bollinger_middle AND bollinger_middle >= bollinger_lower)
    )
);

-- Índices para technical_indicators
CREATE INDEX idx_technical_indicators_symbol ON technical_indicators(symbol);
CREATE INDEX idx_technical_indicators_timestamp ON technical_indicators(timestamp DESC);
CREATE INDEX idx_technical_indicators_symbol_timestamp ON technical_indicators(symbol, timestamp DESC);
CREATE INDEX idx_technical_indicators_rsi ON technical_indicators(rsi) WHERE rsi IS NOT NULL;

-- Comentario
COMMENT ON TABLE technical_indicators IS 'Indicadores técnicos calculados para análisis';
