# API REST Documentation
 
## Autenticación
Todos los endpoints requieren token JWT en header:
```
Authorization: Bearer <token>
```
 
## Endpoints
 
### POST /api/v1/orders
Crea una nueva orden de trading.
 
**Request:**
```json
{
 "symbol": "AAPL",
 "type": "MARKET",
 "side": "BUY",
 "quantity": 10
}
```
 
**Response:**
```json
{
 "orderId": "abc123",
 "status": "PENDING",
 "createdAt": "2024-01-15T10:00:00Z"
}
```
 
**Errores:**
- 400: Parámetros inválidos
- 401: No autenticado
- 403: Saldo insuficiente