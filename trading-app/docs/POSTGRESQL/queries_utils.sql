


SELECT 
    table_name,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as num_columns
FROM information_schema.tables t
WHERE table_schema = 'public' 
    AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- ============================================================================
--  VERIFICATION OF  ÍNDICES
-- ============================================================================

SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- ============================================================================
-- VERIFICATION OF FOREIGN KEYS
-- ============================================================================

-- Listar todas las relaciones de Foreign Keys
SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    tc.constraint_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_schema = 'public'
ORDER BY tc.table_name;

-- ============================================================================
-- VERIFICATION OF CONSTRAINTS
-- ============================================================================

-- Listar todos los constraints (CHECK, UNIQUE, etc.)
SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    cc.check_clause
FROM information_schema.table_constraints tc
LEFT JOIN information_schema.check_constraints cc
    ON tc.constraint_name = cc.constraint_name
WHERE tc.table_schema = 'public'
ORDER BY tc.table_name, tc.constraint_type;



-- SEE ALL USERS
SELECT 
    id,
    email,
    first_name,
    last_name,
    role,
    status,
    email_verified,
    created_at
FROM users
ORDER BY created_at DESC;

-- SEE A ESPECIFIC ACOUNNT
SELECT 
    a.id,
    a.account_number,
    a.account_type,
    a.balance,
    a.currency,
    a.status,
    u.email as user_email
FROM accounts a
JOIN users u ON a.user_id = u.id
WHERE u.email = 'admin@trading.com';

-- SEE TRANSACTION OF ACOUNNT
SELECT 
    t.id,
    t.type,
    t.amount,
    t.balance_after,
    t.description,
    t.status,
    t.created_at,
    t.completed_at
FROM transactions t
WHERE t.account_id = 'UUID_DE_LA_CUENTA'
ORDER BY t.created_at DESC;

-- SEE AVAIBLE ACTIONS
SELECT 
    symbol,
    name,
    exchange,
    sector,
    current_price,
    change_percent,
    volume,
    last_updated
FROM stocks
ORDER BY change_percent DESC;

-- SEE ORDERS OF TRADING OF USER
SELECT 
    to_id,
    s.symbol,
    s.name,
    to_order_type,
    to_side,
    to_quantity,
    to_price,
    to_status,
    to_filled_quantity,
    to_average_fill_price,
    to_created_at
FROM trading_orders to
JOIN stocks s ON to.symbol = s.symbol
JOIN users u ON to_user_id = u.id
WHERE u.email = 'admin@trading.com'
ORDER BY to.created_at DESC;

-- SEE A PORTAFOLIO OF A USER
SELECT 
    pp.symbol,
    s.name,
    pp.quantity,
    pp.average_buy_price,
    pp.current_price,
    pp.current_value,
    pp.unrealized_pnl,
    pp.unrealized_pnl_percent,
    pp.updated_at
FROM portfolio_positions pp
JOIN stocks s ON pp.symbol = s.symbol
JOIN users u ON pp.user_id = u.id
WHERE u.email = 'admin@trading.com'
ORDER BY pp.unrealized_pnl DESC;

-- SEE A SUMMARIZE OF PORTAFOLIO
SELECT 
    ps.total_value,
    ps.cash_balance,
    ps.invested_value,
    ps.total_pnl,
    ps.total_pnl_percent,
    ps.diversification,
    ps.updated_at,
    u.email
FROM portfolio_summaries ps
JOIN users u ON ps.user_id = u.id
WHERE u.email = 'admin@trading.com';


-- FUNCTION TO SEE A COMPLETE PORTAFOLIO OF USER
CREATE OR REPLACE FUNCTION get_user_portfolio(user_email VARCHAR)
RETURNS TABLE (
    symbol VARCHAR,
    stock_name VARCHAR,
    quantity INTEGER,
    average_buy_price NUMERIC,
    current_price NUMERIC,
    total_cost NUMERIC,
    current_value NUMERIC,
    unrealized_pnl NUMERIC,
    unrealized_pnl_percent NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pp.symbol,
        s.name,
        pp.quantity,
        pp.average_buy_price,
        pp.current_price,
        pp.total_cost,
        pp.current_value,
        pp.unrealized_pnl,
        pp.unrealized_pnl_percent
    FROM portfolio_positions pp
    JOIN stocks s ON pp.symbol = s.symbol
    JOIN users u ON pp.user_id = u.id
    WHERE u.email = user_email;
END;
$$ LANGUAGE plpgsql;

-- Ejemplo de uso:
-- SELECT * FROM get_user_portfolio('admin@trading.com');

-- ============================================================================
--  INSERT IN STOCK
-- ============================================================================

-- Insertar acciones de prueba
INSERT INTO stocks (symbol, name, exchange, sector, current_price, previous_close, change_percent, volume, market_cap)
VALUES 
    ('AAPL', 'Apple Inc.', 'NASDAQ', 'Technology', 178.50, 175.20, 1.88, 50234567, 2800000000000),
    ('TSLA', 'Tesla Inc.', 'NASDAQ', 'Automotive', 245.80, 252.30, -2.58, 98765432, 780000000000),
    ('AMZN', 'Amazon.com Inc.', 'NASDAQ', 'E-Commerce', 142.35, 140.10, 1.61, 45678901, 1470000000000),
    ('GOOGL', 'Alphabet Inc.', 'NASDAQ', 'Technology', 138.90, 137.25, 1.20, 23456789, 1750000000000),
    ('MSFT', 'Microsoft Corporation', 'NASDAQ', 'Technology', 368.45, 365.10, 0.92, 34567890, 2740000000000);

-- Crear cuenta de prueba para el usuario admin
DO $$
DECLARE
    admin_user_id UUID;
    new_account_id UUID;
BEGIN
    -- Obtener el ID del usuario admin
    SELECT id INTO admin_user_id FROM users WHERE email = 'admin@trading.com';
    
    IF admin_user_id IS NOT NULL THEN
        -- Insertar cuenta INVESTMENT
        INSERT INTO accounts (user_id, account_number, account_type, balance, currency, status)
        VALUES (admin_user_id, '1234567890123456', 'INVESTMENT', 50000.00, 'USD', 'ACTIVE')
        RETURNING id INTO new_account_id;
        
        -- Insertar transacción inicial (depósito)
        INSERT INTO transactions (account_id, type, amount, balance_after, description, status, completed_at)
        VALUES (new_account_id, 'DEPOSIT', 50000.00, 50000.00, 'Depósito inicial', 'COMPLETED', CURRENT_TIMESTAMP);
        
        RAISE NOTICE 'Cuenta creada con ID: %', new_account_id;
    END IF;
END $$;


-- Vacuum y Analyze FOR OPTIMIZE
VACUUM ANALYZE users;
VACUUM ANALYZE accounts;
VACUUM ANALYZE transactions;
VACUUM ANALYZE stocks;
VACUUM ANALYZE trading_orders;
VACUUM ANALYZE portfolio_positions;

