package com.trading_system.dto.events;


import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Evento: Precio de Acción Actualizado
 * Se publica cuando cambia el precio de una acción
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StockPriceUpdatedEvent {
    
    @JsonProperty("stock_id")
    private Long stockId;
    
    @JsonProperty("symbol")
    private String symbol; // "AAPL", "GOOGL", etc.
    
    @JsonProperty("company_name")
    private String companyName;
    
    @JsonProperty("previous_price")
    private BigDecimal previousPrice;
    
    @JsonProperty("current_price")
    private BigDecimal currentPrice;
    
    @JsonProperty("change_amount")
    private BigDecimal changeAmount;
    
    @JsonProperty("change_percentage")
    private BigDecimal changePercentage;
    
    @JsonProperty("volume")
    private Long volume;
    
    @JsonProperty("updated_at")
    private LocalDateTime updatedAt;
    
    @JsonProperty("event_timestamp")
    private LocalDateTime eventTimestamp;
}