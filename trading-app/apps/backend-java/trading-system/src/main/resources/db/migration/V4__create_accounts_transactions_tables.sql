-- ============================================================================
-- V4: Crear Tablas de Cuentas y Transacciones
-- ============================================================================
-- Descripción: Crea tablas accounts y transactions
-- Autor: Aníbal
-- Fecha: 2024-11-27
-- ============================================================================

-- ============================================================================
-- TABLA: accounts (Cuentas Bancarias)
-- ============================================================================

CREATE TABLE accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    account_number VARCHAR(16) NOT NULL UNIQUE,
    account_type account_type NOT NULL,
    balance NUMERIC(15,2) NOT NULL DEFAULT 0.00,
    currency VARCHAR(3) NOT NULL DEFAULT 'MXN',
    status account_status NOT NULL DEFAULT 'ACTIVE',
    interest_rate NUMERIC(5,4),
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

-- Comentario
COMMENT ON TABLE accounts IS 'Cuentas bancarias de los usuarios';

-- ============================================================================
-- TABLA: transactions (Transacciones)
-- ============================================================================

CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    type transaction_type NOT NULL,
    amount NUMERIC(15,2) NOT NULL,
    balance_after NUMERIC(15,2) NOT NULL,
    description VARCHAR(200) NOT NULL,
    reference VARCHAR(100),
    status transaction_status NOT NULL DEFAULT 'PENDING',
    metadata JSONB,
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

-- Comentario
COMMENT ON TABLE transactions IS 'Registro de todas las transacciones financieras';
