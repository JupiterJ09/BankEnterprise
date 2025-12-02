-- ============================================================================
-- V3: Crear Tablas de Usuarios
-- ============================================================================
-- Descripción: Crea tablas users y user_profiles
-- Autor: Aníbal
-- Fecha: 2024-11-27
-- ============================================================================

-- ============================================================================
-- TABLA: users (Usuarios)
-- ============================================================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(60) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
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

-- Comentario
COMMENT ON TABLE users IS 'Tabla principal de usuarios del sistema';

-- ============================================================================
-- TABLA: user_profiles (Perfiles de Usuario)
-- ============================================================================

CREATE TABLE user_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    avatar_url VARCHAR(500),
    bio VARCHAR(500),
    timezone VARCHAR(50) NOT NULL DEFAULT 'America/Mexico_City',
    locale VARCHAR(10) NOT NULL DEFAULT 'es-MX',
    currency VARCHAR(3) NOT NULL DEFAULT 'MXN',
    
    -- Preferencias de notificaciones
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

-- Comentario
COMMENT ON TABLE user_profiles IS 'Perfiles y preferencias de usuarios';
