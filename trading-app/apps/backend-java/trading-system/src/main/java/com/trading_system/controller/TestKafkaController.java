package com.trading_system.controller;


import com.trading_system.dto.events.*;
import com.trading_system.service.KafkaProducerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Controlador de prueba para Kafka
 * 
 * Este controlador permite probar el envío de eventos a Kafka
 * mediante endpoints REST.
 */
@Slf4j
@RestController
@RequestMapping("/api/test/kafka")
public class TestKafkaController {

    @Autowired
    private KafkaProducerService kafkaProducerService;

    /**
     * Prueba el envío de evento ORDER_CREATED
     * 
     * GET http://localhost:8080/api/test/kafka/order-created
     */
    @GetMapping("/order-created")
    public ResponseEntity<Map<String, Object>> testOrderCreated() {
        log.info("🧪 Probando publicación de ORDER_CREATED");
        
        OrderCreatedEvent event = OrderCreatedEvent.builder()
            .orderId(1001L)
            .userId(1L)
            .accountId(100L)
            .stockSymbol("AAPL")
            .orderType("BUY")
            .quantity(50)
            .price(new BigDecimal("175.50"))
            .status("PENDING")
            .createdAt(LocalDateTime.now())
            .build();
        
        kafkaProducerService.publishOrderCreated(event);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Evento ORDER_CREATED enviado a Kafka");
        response.put("event", event);
        
        return ResponseEntity.ok(response);
    }

    /**
     * Prueba el envío de evento ORDER_EXECUTED
     * 
     * GET http://localhost:8080/api/test/kafka/order-executed
     */
    @GetMapping("/order-executed")
    public ResponseEntity<Map<String, Object>> testOrderExecuted() {
        log.info("🧪 Probando publicación de ORDER_EXECUTED");
        
        OrderExecutedEvent event = OrderExecutedEvent.builder()
            .orderId(1001L)
            .userId(1L)
            .accountId(100L)
            .stockSymbol("AAPL")
            .orderType("BUY")
            .quantity(50)
            .executionPrice(new BigDecimal("175.75"))
            .totalAmount(new BigDecimal("8787.50"))
            .executedAt(LocalDateTime.now())
            .build();
        
        kafkaProducerService.publishOrderExecuted(event);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Evento ORDER_EXECUTED enviado a Kafka");
        response.put("event", event);
        
        return ResponseEntity.ok(response);
    }

    /**
     * Prueba el envío de evento TRANSACTION_COMPLETED
     * 
     * GET http://localhost:8080/api/test/kafka/transaction-completed
     */
    @GetMapping("/transaction-completed")
    public ResponseEntity<Map<String, Object>> testTransactionCompleted() {
        log.info("🧪 Probando publicación de TRANSACTION_COMPLETED");
        
        TransactionCompletedEvent event = TransactionCompletedEvent.builder()
            .transactionId(5001L)
            .userId(1L)
            .accountId(100L)
            .transactionType("TRADE")
            .amount(new BigDecimal("8787.50"))
            .currency("USD")
            .status("COMPLETED")
            .description("Compra de 50 acciones AAPL @ $175.75")
            .completedAt(LocalDateTime.now())
            .build();
        
        kafkaProducerService.publishTransactionCompleted(event);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Evento TRANSACTION_COMPLETED enviado a Kafka");
        response.put("event", event);
        
        return ResponseEntity.ok(response);
    }

    /**
     * Prueba el envío de evento STOCK_PRICE_UPDATED
     * 
     * GET http://localhost:8080/api/test/kafka/stock-price-updated
     */
    @GetMapping("/stock-price-updated")
    public ResponseEntity<Map<String, Object>> testStockPriceUpdated() {
        log.info("🧪 Probando publicación de STOCK_PRICE_UPDATED");
        
        BigDecimal previousPrice = new BigDecimal("175.50");
        BigDecimal currentPrice = new BigDecimal("176.25");
        BigDecimal changeAmount = currentPrice.subtract(previousPrice);
        BigDecimal changePercentage = changeAmount.divide(previousPrice, 4, BigDecimal.ROUND_HALF_UP)
                                                   .multiply(new BigDecimal("100"));
        
        StockPriceUpdatedEvent event = StockPriceUpdatedEvent.builder()
            .stockId(1L)
            .symbol("AAPL")
            .companyName("Apple Inc.")
            .previousPrice(previousPrice)
            .currentPrice(currentPrice)
            .changeAmount(changeAmount)
            .changePercentage(changePercentage)
            .volume(15_234_567L)
            .updatedAt(LocalDateTime.now())
            .build();
        
        kafkaProducerService.publishStockPriceUpdated(event);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Evento STOCK_PRICE_UPDATED enviado a Kafka");
        response.put("event", event);
        
        return ResponseEntity.ok(response);
    }

    /**
     * Prueba todos los eventos en secuencia
     * 
     * GET http://localhost:8080/api/test/kafka/all
     */
    @GetMapping("/all")
    public ResponseEntity<Map<String, Object>> testAllEvents() {
        log.info("🧪 Probando publicación de TODOS los eventos");
        
        // Simular una operación completa de trading
        
        // 1. Se crea una orden
        testOrderCreated();
        
        try {
            Thread.sleep(1000); // Esperar 1 segundo
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        // 2. La orden se ejecuta
        testOrderExecuted();
        
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        // 3. Se completa la transacción
        testTransactionCompleted();
        
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        
        // 4. Se actualiza el precio de la acción
        testStockPriceUpdated();
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Todos los eventos enviados a Kafka en secuencia");
        
        return ResponseEntity.ok(response);
    }
}