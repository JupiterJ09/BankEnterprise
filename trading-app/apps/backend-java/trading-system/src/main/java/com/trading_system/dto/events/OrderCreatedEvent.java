package com.trading_system.dto.events;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Evento: Orden de Trading Creada
 * Se publica cuando un usuario crea una nueva orden de compra/venta
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderCreatedEvent {
    
    @JsonProperty("order_id")
    private Long orderId;
    
    @JsonProperty("user_id")
    private Long userId;
    
    @JsonProperty("account_id")
    private Long accountId;
    
    @JsonProperty("stock_symbol")
    private String stockSymbol;
    
    @JsonProperty("order_type")
    private String orderType; // "BUY" o "SELL"
    
    @JsonProperty("quantity")
    private Integer quantity;
    
    @JsonProperty("price")
    private BigDecimal price;
    
    @JsonProperty("status")
    private String status; // "PENDING", "EXECUTED", "CANCELLED"
    
    @JsonProperty("created_at")
    private LocalDateTime createdAt;
    
    @JsonProperty("event_timestamp")
    private LocalDateTime eventTimestamp;
}