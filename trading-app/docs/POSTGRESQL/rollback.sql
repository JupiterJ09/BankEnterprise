
-- Confirmar antes de ejecutar
DO $$
BEGIN
    RAISE NOTICE '  ADVERTENCIA: Este script eliminará TODAS las tablas y datos';
    RAISE NOTICE 'Si estás seguro, continúa con la ejecución';
END $$;


-- ============================================================================

DROP FUNCTION IF EXISTS get_user_portfolio(VARCHAR);
DROP FUNCTION IF EXISTS validate_luhn(VARCHAR);
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;


-- ============================================================================

-- Tablas sin dependencias de otras tablas
DROP TABLE IF EXISTS technical_indicators CASCADE;
DROP TABLE IF EXISTS stock_predictions CASCADE;
DROP TABLE IF EXISTS portfolio_summaries CASCADE;
DROP TABLE IF EXISTS portfolio_positions CASCADE;
DROP TABLE IF EXISTS trading_orders CASCADE;
DROP TABLE IF EXISTS stock_price_history CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS accounts CASCADE;
DROP TABLE IF EXISTS user_profiles CASCADE;
DROP TABLE IF EXISTS stocks CASCADE;
DROP TABLE IF EXISTS users CASCADE;


-- ============================================================================

DROP TYPE IF EXISTS notification_priority CASCADE;
DROP TYPE IF EXISTS notification_type CASCADE;
DROP TYPE IF EXISTS prediction_direction CASCADE;
DROP TYPE IF EXISTS order_status CASCADE;
DROP TYPE IF EXISTS order_side CASCADE;
DROP TYPE IF EXISTS order_type CASCADE;
DROP TYPE IF EXISTS transaction_status CASCADE;
DROP TYPE IF EXISTS transaction_type CASCADE;
DROP TYPE IF EXISTS account_status CASCADE;
DROP TYPE IF EXISTS account_type CASCADE;
DROP TYPE IF EXISTS user_status CASCADE;
DROP TYPE IF EXISTS user_role CASCADE;


SELECT 
    table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
    AND table_type = 'BASE TABLE'
ORDER BY table_name;



RAISE NOTICE 'Rollback completado';
RAISE NOTICE 'Verifica que no haya tablas restantes ejecutando la consulta de verificación';
