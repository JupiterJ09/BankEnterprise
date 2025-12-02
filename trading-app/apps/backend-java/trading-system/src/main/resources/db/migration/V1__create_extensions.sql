-- ============================================================================
-- V1: Crear Extensiones de PostgreSQL
-- ============================================================================
-- Descripción: Habilita extensiones necesarias para UUIDs y criptografía
-- Autor: Aníbal
-- Fecha: 2024-11-27
-- ============================================================================

-- Extensión para generación de UUIDs v4
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Extensión para funciones criptográficas (hashing, encriptación)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
