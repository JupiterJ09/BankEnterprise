-- ============================================================================
-- ESQUEMA POSTGRESQL - SISTEMA DE TRADING FINANCIERO
-- Responsable: Aníbal
-- Versión: 1.0
-- Fecha: 2024
-- ============================================================================

-- ============================================================================
-- 1. EXTENSIONES Y CONFIGURACIONES
-- ============================================================================

-- Habilitar extensión para UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Habilitar extensión para validaciones avanzadas
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- 2. TIPOS ENUMERADOS (ENUMS)
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

-- ============================================================================
-- 3. TABLA: users (Usuarios)
-- ============================================================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(60) NOT NULL, -- bcrypt hash (60 caracteres)
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20), -- Formato E.164: +521234567890
    role user_role NOT NULL DEFAULT 'USER',
    status user_status NOT NULL DEFAULT 'ACTIVE',
    email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    two_factor_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT users_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT users_phone_format CHECK (
        phone_number IS NULL OR 
        phone_number ~* '^\+[1-9]\d{1,14}$'
    )
);

-- Índices para users
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_created_at ON users(created_at DESC);

-- ============================================================================
-- 4. TABLA: user_profiles (Perfiles de Usuario)
-- ============================================================================

CREATE TABLE user_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    avatar_url VARCHAR(500),
    bio VARCHAR(500),
    timezone VARCHAR(50) NOT NULL DEFAULT 'America/Mexico_City', -- Formato IANA
    locale VARCHAR(10) NOT NULL DEFAULT 'es-MX', -- Formato BCP 47
    currency VARCHAR(3) NOT NULL DEFAULT 'MXN', -- ISO 4217
    
    -- Preferencias de notificaciones (JSON)
    email_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    push_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    sms_notifications BOOLEAN NOT NULL DEFAULT FALSE,
    trading_alerts BOOLEAN NOT NULL DEFAULT TRUE,
    price_alerts BOOLEAN NOT NULL DEFAULT TRUE,
    news_alerts BOOLEAN NOT NULL DEFAULT TRUE,
    
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT user_profiles_currency_format CHECK (currency ~ '^[A-Z]{3}$')
);

-- Índices para user_profiles
CREATE INDEX idx_user_profiles_currency ON user_profiles(currency);
CREATE INDEX idx_user_profiles_locale ON user_profiles(locale);

-- ============================================================================
-- 5. TABLA: accounts (Cuentas Bancarias)
-- ============================================================================

CREATE TABLE accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    account_number VARCHAR(16) NOT NULL UNIQUE,
    account_type account_type NOT NULL,
    balance NUMERIC(15,2) NOT NULL DEFAULT 0.00,
    currency VARCHAR(3) NOT NULL DEFAULT 'MXN',
    status account_status NOT NULL DEFAULT 'ACTIVE',
    interest_rate NUMERIC(5,4), -- Solo para SAVINGS
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT accounts_balance_positive CHECK (balance >= 0),
    CONSTRAINT accounts_account_number_length CHECK (length(account_number) = 16),
    CONSTRAINT accounts_account_number_digits CHECK (account_number ~ '^\d{16}$'),
    CONSTRAINT accounts_currency_format CHECK (currency ~ '^[A-Z]{3}$'),
    CONSTRAINT accounts_interest_rate_check CHECK (
        (account_type = 'SAVINGS' AND interest_rate IS NOT NULL AND interest_rate >= 0) OR
        (account_type != 'SAVINGS' AND interest_rate IS NULL)
    )
);

-- Índices para accounts
CREATE INDEX idx_accounts_user_id ON accounts(user_id);
CREATE INDEX idx_accounts_account_number ON accounts(account_number);
CREATE INDEX idx_accounts_status ON accounts(status);
CREATE INDEX idx_accounts_account_type ON accounts(account_type);

-- ============================================================================
-- 6. TABLA: transactions (Transacciones)
-- ============================================================================

CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    type transaction_type NOT NULL,
    amount NUMERIC(15,2) NOT NULL,
    balance_after NUMERIC(15,2) NOT NULL,
    description VARCHAR(200) NOT NULL,
    reference VARCHAR(100), -- Número de referencia externo
    status transaction_status NOT NULL DEFAULT 'PENDING',
    metadata JSONB, -- Datos adicionales flexibles
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE,
    
    -- Constraints
    CONSTRAINT transactions_amount_positive CHECK (amount > 0),
    CONSTRAINT transactions_balance_after_positive CHECK (balance_after >= 0),
    CONSTRAINT transactions_completed_at_check CHECK (
        (status = 'COMPLETED' AND completed_at IS NOT NULL) OR
        (status != 'COMPLETED' AND completed_at IS NULL)
    )
);

-- Índices para transactions
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_type ON transactions(type);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_transactions_created_at ON transactions(created_at DESC);
CREATE INDEX idx_transactions_reference ON transactions(reference) WHERE reference IS NOT NULL;
CREATE INDEX idx_transactions_metadata ON transactions USING GIN(metadata);

-- ============================================================================
-- 7. TABLA: stocks (Acciones)
-- ============================================================================

CREATE TABLE stocks (
    symbol VARCHAR(10) PRIMARY KEY, -- Ticker symbol: AAPL, TSLA, AMZN
    name VARCHAR(100) NOT NULL,
    exchange VARCHAR(20) NOT NULL, -- NYSE, NASDAQ, BMV
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

-- ============================================================================
-- 8. TABLA: stock_price_history (Historial de Precios OHLCV)
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

-- ============================================================================
-- 9. TABLA: trading_orders (Órdenes de Trading)
-- ============================================================================

CREATE TABLE trading_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    account_id UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    symbol VARCHAR(10) NOT NULL REFERENCES stocks(symbol) ON DELETE RESTRICT,
    order_type order_type NOT NULL,
    side order_side NOT NULL,
    quantity INTEGER NOT NULL,
    price NUMERIC(10,4), -- NULL para órdenes MARKET
    stop_price NUMERIC(10,4), -- Solo para órdenes STOP
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

-- ============================================================================
-- 10. TABLA: portfolio_positions (Posiciones en Portfolio)
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

-- ============================================================================
-- 11. TABLA: portfolio_summaries (Resúmenes de Portfolio)
-- ============================================================================

CREATE TABLE portfolio_summaries (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    total_value NUMERIC(15,2) NOT NULL,
    cash_balance NUMERIC(15,2) NOT NULL,
    invested_value NUMERIC(15,2) NOT NULL,
    total_pnl NUMERIC(15,2) NOT NULL,
    total_pnl_percent NUMERIC(6,2) NOT NULL,
    diversification JSONB, -- {sector: porcentaje}
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

-- ============================================================================
-- 12. TABLA: stock_predictions (Predicciones ML)
-- ============================================================================

CREATE TABLE stock_predictions (
    id BIGSERIAL PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL REFERENCES stocks(symbol) ON DELETE CASCADE,
    prediction_date DATE NOT NULL,
    predicted_price NUMERIC(10,4) NOT NULL,
    confidence NUMERIC(5,4) NOT NULL,
    direction prediction_direction NOT NULL,
    target_date DATE NOT NULL,
    model VARCHAR(50) NOT NULL, -- RandomForest, LSTM, etc.
    features JSONB, -- {nombreFeature: valor}
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

-- ============================================================================
-- 13. TABLA: technical_indicators (Indicadores Técnicos)
-- ============================================================================

CREATE TABLE technical_indicators (
    id BIGSERIAL PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL REFERENCES stocks(symbol) ON DELETE CASCADE,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    
    -- Indicadores
    rsi NUMERIC(5,2), -- 0-100
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
    atr NUMERIC(10,4), -- Average True Range
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

-- ============================================================================
-- 14. TRIGGERS PARA UPDATED_AT AUTOMÁTICO
-- ============================================================================

-- Función genérica para actualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger a todas las tablas con updated_at
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_accounts_updated_at
    BEFORE UPDATE ON accounts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_trading_orders_updated_at
    BEFORE UPDATE ON trading_orders
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_portfolio_positions_updated_at
    BEFORE UPDATE ON portfolio_positions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_portfolio_summaries_updated_at
    BEFORE UPDATE ON portfolio_summaries
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- 15. FUNCIÓN PARA VALIDAR ALGORITMO LUHN (TARJETAS/CUENTAS)
-- ============================================================================

CREATE OR REPLACE FUNCTION validate_luhn(account_number VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE
    sum INTEGER := 0;
    digit INTEGER;
    i INTEGER;
    should_double BOOLEAN := FALSE;
BEGIN
    -- Validar que sean solo dígitos
    IF account_number !~ '^\d+$' THEN
        RETURN FALSE;
    END IF;
    
    -- Algoritmo Luhn (de derecha a izquierda)
    FOR i IN REVERSE length(account_number)..1 LOOP
        digit := substring(account_number FROM i FOR 1)::INTEGER;
        
        IF should_double THEN
            digit := digit * 2;
            IF digit > 9 THEN
                digit := digit - 9;
            END IF;
        END IF;
        
        sum := sum + digit;
        should_double := NOT should_double;
    END LOOP;
    
    RETURN (sum % 10) = 0;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- ============================================================================
-- 16. DATOS DE EJEMPLO (OPCIONAL - PARA TESTING)
-- ============================================================================

-- Insertar un usuario de prueba
INSERT INTO users (email, password_hash, first_name, last_name, role)
VALUES (
    'admin@trading.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', -- password: secret
    'Admin',
    'System',
    'ADMIN'
);

-- ============================================================================
-- 17. COMENTARIOS EN TABLAS
-- ============================================================================

COMMENT ON TABLE users IS 'Tabla principal de usuarios del sistema';
COMMENT ON TABLE user_profiles IS 'Perfiles y preferencias de usuarios';
COMMENT ON TABLE accounts IS 'Cuentas bancarias de los usuarios';
COMMENT ON TABLE transactions IS 'Registro de todas las transacciones financieras';
COMMENT ON TABLE stocks IS 'Información de acciones disponibles para trading';
COMMENT ON TABLE stock_price_history IS 'Historial OHLCV de precios de acciones';
COMMENT ON TABLE trading_orders IS 'Órdenes de compra/venta de acciones';
COMMENT ON TABLE portfolio_positions IS 'Posiciones actuales en el portfolio de cada usuario';
COMMENT ON TABLE portfolio_summaries IS 'Resumen consolidado del portfolio por usuario';
COMMENT ON TABLE stock_predictions IS 'Predicciones de Machine Learning para acciones';
COMMENT ON TABLE technical_indicators IS 'Indicadores técnicos calculados para análisis';


