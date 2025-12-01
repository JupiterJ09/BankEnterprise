package com.trading_system.controller;

import com.trading_system.service.RedisCacheService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/test")
@RequiredArgsConstructor
public class TestRedisController {

    private final RedisCacheService cacheService;

    @GetMapping("/redis-status")
    public Map<String, Object> testRedis() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Test 1: Guardar y recuperar
            String testKey = "test:connection";
            String testValue = "Redis funciona correctamente!";
            
            cacheService.set(testKey, testValue, Duration.ofMinutes(5));
            Object retrieved = cacheService.get(testKey);
            
            response.put("status", "SUCCESS");
            response.put("message", "Redis está funcionando");
            response.put("test_saved", testValue);
            response.put("test_retrieved", retrieved);
            response.put("keys_exist", cacheService.exists(testKey));
            
            // Limpiar
            cacheService.delete(testKey);
            
        } catch (Exception e) {
            response.put("status", "ERROR");
            response.put("message", e.getMessage());
        }
        
        return response;
    }

    @PostMapping("/cache/set")
    public Map<String, String> setCache(
            @RequestParam String key, 
            @RequestParam String value) {
        
        cacheService.set(key, value, Duration.ofMinutes(10));
        
        Map<String, String> response = new HashMap<>();
        response.put("message", "Guardado en cache");
        response.put("key", key);
        response.put("value", value);
        return response;
    }

    @GetMapping("/cache/get")
    public Map<String, Object> getCache(@RequestParam String key) {
        Object value = cacheService.get(key);
        
        Map<String, Object> response = new HashMap<>();
        response.put("key", key);
        response.put("value", value);
        response.put("exists", cacheService.exists(key));
        return response;
    }
}