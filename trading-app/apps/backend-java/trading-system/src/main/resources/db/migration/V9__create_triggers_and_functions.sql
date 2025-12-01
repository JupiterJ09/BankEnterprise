-- ============================================================================
-- V9: Crear Triggers y Funciones
-- ============================================================================
-- Descripción: Crea funciones y triggers automáticos
-- Autor: Aníbal
-- Fecha: 2024-11-27
-- ============================================================================

-- ============================================================================
-- FUNCIÓN: Actualizar updated_at automáticamente
-- ============================================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- TRIGGERS: Aplicar a todas las tablas con updated_at
-- ============================================================================

-- Trigger para users
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger para user_profiles
CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger para accounts
CREATE TRIGGER update_accounts_updated_at
    BEFORE UPDATE ON accounts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger para trading_orders
CREATE TRIGGER update_trading_orders_updated_at
    BEFORE UPDATE ON trading_orders
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger para portfolio_positions
CREATE TRIGGER update_portfolio_positions_updated_at
    BEFORE UPDATE ON portfolio_positions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger para portfolio_summaries
CREATE TRIGGER update_portfolio_summaries_updated_at
    BEFORE UPDATE ON portfolio_summaries
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- FUNCIÓN: Validar Algoritmo Luhn
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
