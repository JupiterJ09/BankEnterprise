package com.trading_system.dto.events;



import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Evento: Transacción Completada
 * Se publica cuando se completa cualquier transacción financiera
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TransactionCompletedEvent {
    
    @JsonProperty("transaction_id")
    private Long transactionId;
    
    @JsonProperty("user_id")
    private Long userId;
    
    @JsonProperty("account_id")
    private Long accountId;
    
    @JsonProperty("transaction_type")
    private String transactionType; // "DEPOSIT", "WITHDRAWAL", "TRADE"
    
    @JsonProperty("amount")
    private BigDecimal amount;
    
    @JsonProperty("currency")
    private String currency; // "USD", "MXN", etc.
    
    @JsonProperty("status")
    private String status; // "COMPLETED", "FAILED", "PENDING"
    
    @JsonProperty("description")
    private String description;
    
    @JsonProperty("completed_at")
    private LocalDateTime completedAt;
    
    @JsonProperty("event_timestamp")
    private LocalDateTime eventTimestamp;
}