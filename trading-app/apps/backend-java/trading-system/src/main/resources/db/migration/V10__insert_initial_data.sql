-- ============================================================================
-- V10: Insertar Datos Iniciales
-- ============================================================================
-- Descripción: Inserta datos de prueba y configuración inicial
-- Autor: Aníbal
-- Fecha: 2024-11-27
-- ============================================================================

-- ============================================================================
-- USUARIO ADMIN DE PRUEBA
-- ============================================================================

-- Insertar usuario administrador
-- Password: secret123 (bcrypt hash con 10 rounds)
INSERT INTO users (email, password_hash, first_name, last_name, role, email_verified)
VALUES (
    'admin@trading.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    'Admin',
    'System',
    'ADMIN',
    true
);

-- Insertar perfil del usuario admin
INSERT INTO user_profiles (user_id, timezone, locale, currency)
SELECT 
    id,
    'America/Mexico_City',
    'es-MX',
    'MXN'
FROM users 
WHERE email = 'admin@trading.com';

-- ============================================================================
-- ACCIONES DE PRUEBA
-- ============================================================================

INSERT INTO stocks (symbol, name, exchange, sector, current_price, previous_close, change_percent, volume, market_cap)
VALUES 
    ('AAPL', 'Apple Inc.', 'NASDAQ', 'Technology', 178.50, 175.20, 1.88, 50234567, 2800000000000),
    ('TSLA', 'Tesla Inc.', 'NASDAQ', 'Automotive', 245.80, 252.30, -2.58, 98765432, 780000000000),
    ('AMZN', 'Amazon.com Inc.', 'NASDAQ', 'E-Commerce', 142.35, 140.10, 1.61, 45678901, 1470000000000),
    ('GOOGL', 'Alphabet Inc.', 'NASDAQ', 'Technology', 138.90, 137.25, 1.20, 23456789, 1750000000000),
    ('MSFT', 'Microsoft Corporation', 'NASDAQ', 'Technology', 368.45, 365.10, 0.92, 34567890, 2740000000000),
    ('META', 'Meta Platforms Inc.', 'NASDAQ', 'Technology', 328.75, 325.40, 1.03, 18234567, 850000000000),
    ('NFLX', 'Netflix Inc.', 'NASDAQ', 'Entertainment', 445.20, 442.80, 0.54, 8765432, 195000000000),
    ('NVDA', 'NVIDIA Corporation', 'NASDAQ', 'Technology', 495.30, 488.90, 1.31, 67890123, 1220000000000);

-- ============================================================================
-- CUENTA DE PRUEBA
-- ============================================================================

-- Insertar cuenta de inversión para admin
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
        VALUES (admin_user_id, '4532148803436460', 'INVESTMENT', 50000.00, 'USD', 'ACTIVE')
        RETURNING id INTO new_account_id;
        
        -- Insertar transacción inicial (depósito)
        INSERT INTO transactions (account_id, type, amount, balance_after, description, status, completed_at)
        VALUES (
            new_account_id, 
            'DEPOSIT', 
            50000.00, 
            50000.00, 
            'Depósito inicial de cuenta', 
            'COMPLETED', 
            CURRENT_TIMESTAMP
        );
        
        RAISE NOTICE 'Cuenta creada con ID: %', new_account_id;
    END IF;
END $$;
