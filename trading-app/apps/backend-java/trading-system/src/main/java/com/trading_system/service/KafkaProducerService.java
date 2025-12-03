package com.trading_system.service;

import com.trading_system.dto.events.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.concurrent.CompletableFuture;

/**
 * Servicio para producir mensajes a Kafka
 * 
 * Este servicio se encarga de publicar eventos a los diferentes topics
 * de Kafka del sistema de trading.
 */
@Slf4j
@Service
public class KafkaProducerService {

    @Autowired
    private KafkaTemplate<String, Object> kafkaTemplate;

    @Value("${kafka.topic.order-created}")
    private String orderCreatedTopic;

    @Value("${kafka.topic.order-executed}")
    private String orderExecutedTopic;

    @Value("${kafka.topic.transaction-completed}")
    private String transactionCompletedTopic;

    @Value("${kafka.topic.stock-price-updated}")
    private String stockPriceUpdatedTopic;

    /**
     * Publica evento de orden creada
     * 
     * @param event Evento con los datos de la orden creada
     */
    public void publishOrderCreated(OrderCreatedEvent event) {
        event.setEventTimestamp(LocalDateTime.now());
        
        CompletableFuture<SendResult<String, Object>> future = 
            kafkaTemplate.send(orderCreatedTopic, event.getOrderId().toString(), event);
        
        future.whenComplete((result, ex) -> {
            if (ex == null) {
                log.info("✅ Evento ORDER_CREATED publicado: orderId={}, topic={}, partition={}, offset={}", 
                    event.getOrderId(), 
                    result.getRecordMetadata().topic(),
                    result.getRecordMetadata().partition(),
                    result.getRecordMetadata().offset());
            } else {
                log.error("❌ Error al publicar ORDER_CREATED: orderId={}", event.getOrderId(), ex);
            }
        });
    }

    /**
     * Publica evento de orden ejecutada
     * 
     * @param event Evento con los datos de la orden ejecutada
     */
    public void publishOrderExecuted(OrderExecutedEvent event) {
        event.setEventTimestamp(LocalDateTime.now());
        
        CompletableFuture<SendResult<String, Object>> future = 
            kafkaTemplate.send(orderExecutedTopic, event.getOrderId().toString(), event);
        
        future.whenComplete((result, ex) -> {
            if (ex == null) {
                log.info("✅ Evento ORDER_EXECUTED publicado: orderId={}, topic={}, partition={}, offset={}", 
                    event.getOrderId(),
                    result.getRecordMetadata().topic(),
                    result.getRecordMetadata().partition(),
                    result.getRecordMetadata().offset());
            } else {
                log.error("❌ Error al publicar ORDER_EXECUTED: orderId={}", event.getOrderId(), ex);
            }
        });
    }

    /**
     * Publica evento de transacción completada
     * 
     * @param event Evento con los datos de la transacción
     */
    public void publishTransactionCompleted(TransactionCompletedEvent event) {
        event.setEventTimestamp(LocalDateTime.now());
        
        CompletableFuture<SendResult<String, Object>> future = 
            kafkaTemplate.send(transactionCompletedTopic, event.getTransactionId().toString(), event);
        
        future.whenComplete((result, ex) -> {
            if (ex == null) {
                log.info("✅ Evento TRANSACTION_COMPLETED publicado: transactionId={}, topic={}, partition={}, offset={}", 
                    event.getTransactionId(),
                    result.getRecordMetadata().topic(),
                    result.getRecordMetadata().partition(),
                    result.getRecordMetadata().offset());
            } else {
                log.error("❌ Error al publicar TRANSACTION_COMPLETED: transactionId={}", event.getTransactionId(), ex);
            }
        });
    }

    /**
     * Publica evento de actualización de precio de acción
     * 
     * @param event Evento con los nuevos precios de la acción
     */
    public void publishStockPriceUpdated(StockPriceUpdatedEvent event) {
        event.setEventTimestamp(LocalDateTime.now());
        
        CompletableFuture<SendResult<String, Object>> future = 
            kafkaTemplate.send(stockPriceUpdatedTopic, event.getSymbol(), event);
        
        future.whenComplete((result, ex) -> {
            if (ex == null) {
                log.info("✅ Evento STOCK_PRICE_UPDATED publicado: symbol={}, price={}, topic={}, partition={}, offset={}", 
                    event.getSymbol(),
                    event.getCurrentPrice(),
                    result.getRecordMetadata().topic(),
                    result.getRecordMetadata().partition(),
                    result.getRecordMetadata().offset());
            } else {
                log.error("❌ Error al publicar STOCK_PRICE_UPDATED: symbol={}", event.getSymbol(), ex);
            }
        });
    }

    /**
     * Método genérico para enviar cualquier evento a un topic específico
     * 
     * @param topic Topic de destino
     * @param key Clave del mensaje
     * @param event Evento a enviar
     */
    public void publishEvent(String topic, String key, Object event) {
        CompletableFuture<SendResult<String, Object>> future = 
            kafkaTemplate.send(topic, key, event);
        
        future.whenComplete((result, ex) -> {
            if (ex == null) {
                log.info("✅ Evento publicado: topic={}, key={}, partition={}, offset={}", 
                    topic,
                    key,
                    result.getRecordMetadata().partition(),
                    result.getRecordMetadata().offset());
            } else {
                log.error("❌ Error al publicar evento: topic={}, key={}", topic, key, ex);
            }
        });
    }
}