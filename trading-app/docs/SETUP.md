# Guía de Instalación
 
## Requisitos Previos
- Node.js 18+
- Java 17+
- Python 3.11+
- PostgreSQL 14+
- Docker (opcional)
 
## Instalación Paso a Paso
 
### 1. Clonar repositorio
```bash
git clone https://github.com/tu-repo/trading-app.git
cd trading-app
```
 
### 2. Configurar base de datos
```bash
createdb trading_app
# Ejecutar migraciones
```
 
### 3. Instalar dependencias
```bash
# TypeScript compartido
cd packages/types
npm install
npm run build
 
# Backend Node.js
cd ../../apps/backend-node
npm install
 
# Frontend
cd ../frontend-angular
npm install
```
 
### 4. Variables de entorno
Copiar .env.example a .env y configurar:
```
DATABASE_URL=postgresql://...
JWT_SECRET=tu-secret
KAFKA_BROKERS=localhost:9092
```
 
### 5. Ejecutar
```bash
# Backend Node.js
npm run dev
 
# Frontend (otra terminal)
cd ../frontend-angular
npm start
```