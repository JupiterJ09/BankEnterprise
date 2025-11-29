# Arquitectura del Sistema
 
## Visión General
Sistema de microservicios con:
- 3 Backends independientes (Java, Python, Node.js)
- 1 Frontend (Angular)
- Comunicación asíncrona con Kafka
- Comunicación en tiempo real con WebSocket
 
## Diagrama de Componentes
```
┌─────────────┐
│   Angular   │
│  Frontend   │
└──────┬──────┘
      │
  ┌───┴───┐
  │  API  │
  │Gateway│
  └───┬───┘
      │
  ┌───┴────────────┬────────────┐
  │                │            │
┌──▼───┐      ┌────▼──┐    ┌───▼────┐
│ Java │      │Python │    │ Node.js│
└──┬───┘      └───┬───┘    └───┬────┘
  │              │            │
  └──────────┬───┴────────────┘
             │
        ┌────▼────┐
        │  Kafka  │
        └─────────┘
```
 
## Responsabilidades
- **Backend Java**: Autenticación, usuarios, cuentas
- **Backend Python**: Predicciones ML, análisis
- **Backend Node.js**: Notificaciones, WebSocket, eventos
- **Frontend**: Interfaz de usuario