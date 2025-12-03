package com.trading_system.config;

import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.core.ProducerFactory;
import org.springframework.kafka.support.serializer.JsonSerializer;

import java.util.HashMap;
import java.util.Map;

/**
 * Configuración de Kafka Producer
 * 
 * Esta clase configura el productor de Kafka para enviar mensajes
 * a los diferentes topics del sistema de trading.
 */
@Configuration
public class KafkaConfig {

    @Value("${spring.kafka.bootstrap-servers}")
    private String bootstrapServers;

    /**
     * Configuración del Producer Factory
     * Define cómo se serializarán los mensajes enviados a Kafka
     */
    @Bean
    public ProducerFactory<String, Object> producerFactory() {
        Map<String, Object> configProps = new HashMap<>();

        // Dirección del servidor Kafka
        configProps.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);

        // Serializer para la clave del mensaje (String)
        configProps.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);

        // ✅ CORREGIDO: Usar JsonSerializer de Spring Kafka
        configProps.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class);
        
        // ✅ Configuración adicional para JsonSerializer
        configProps.put(JsonSerializer.ADD_TYPE_INFO_HEADERS, false);

        // Configuración de confiabilidad
        configProps.put(ProducerConfig.ACKS_CONFIG, "all"); // Espera confirmación de todas las réplicas
        configProps.put(ProducerConfig.RETRIES_CONFIG, 3); // Reintenta 3 veces si falla

        // Optimización de rendimiento
        configProps.put(ProducerConfig.BATCH_SIZE_CONFIG, 16384); // Agrupa mensajes en lotes
        configProps.put(ProducerConfig.LINGER_MS_CONFIG, 10); // Espera 10ms antes de enviar un lote

        // Compresión para ahorrar ancho de banda
        configProps.put(ProducerConfig.COMPRESSION_TYPE_CONFIG, "snappy");

        return new DefaultKafkaProducerFactory<>(configProps);
    }

    /**
     * KafkaTemplate para enviar mensajes
     * Es el objeto principal que usarás en tus servicios
     */
    @Bean
    public KafkaTemplate<String, Object> kafkaTemplate() {
        return new KafkaTemplate<>(producerFactory());
    }
}