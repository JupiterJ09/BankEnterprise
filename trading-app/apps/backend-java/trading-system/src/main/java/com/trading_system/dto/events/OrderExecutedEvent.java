package com.trading_system.dto.events;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Evento: Orden de Trading Ejecutada
 * Se publica cuando una orden se ejecuta exitosamente
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderExecutedEvent {
    
    @JsonProperty("order_id")
    private Long orderId;
    
    @JsonProperty("user_id")
    private Long userId;
    
    @JsonProperty("account_id")
    private Long accountId;
    
    @JsonProperty("stock_symbol")
    private String stockSymbol;
    
    @JsonProperty("order_type")
    private String orderType;
    
    @JsonProperty("quantity")
    private Integer quantity;
    
    @JsonProperty("execution_price")
    private BigDecimal executionPrice;
    
    @JsonProperty("total_amount")
    private BigDecimal totalAmount;
    
    @JsonProperty("executed_at")
    private LocalDateTime executedAt;
    
    @JsonProperty("event_timestamp")
    private LocalDateTime eventTimestamp;
}
