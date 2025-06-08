# Logging Best Practices

This document outlines the logging patterns implemented in the `TransactionController` as a reference for implementing consistent logging across the application.

## Key Logging Patterns

### 1. Logger Initialization
```kotlin
private val logger = LoggerFactory.getLogger(YourClass::class.java)
```

### 2. Using Mapped Diagnostic Context (MDC)
MDC allows you to add contextual information to all log messages within a request:

```kotlin
// Set values
MDC.put("transactionId", transactionId)
MDC.put("username", username)

// Clear when done
MDC.clear()
```

### 3. Appropriate Log Levels
- **INFO**: Normal application flow, important business events
- **DEBUG**: Detailed information useful during development and troubleshooting
- **WARN**: Potential issues that don't prevent the application from working
- **ERROR**: Errors that prevent normal operation

### 4. Structured Log Messages
Use a consistent format with key-value pairs:
```kotlin
logger.info("Event description - key1: {}, key2: {}", value1, value2)
```

### 5. Security and Privacy
- Mask sensitive information (credit cards, personal data)
- Don't log full sensitive data even at DEBUG level
- Use helper methods for consistent masking

### 6. Error Handling
```kotlin
try {
    // Operation
    logger.info("Operation successful - key: {}", value)
} catch (e: Exception) {
    logger.error("Operation failed - error: {}", e.message, e)
    // Handle exception
}
```

### 7. Transaction Tracing
Generate and include a unique ID for each transaction to enable tracing across services.

## Configuration
Ensure your `application.yml` has appropriate log level settings for different environments:

```yaml
logging:
  level:
    root: INFO
    com.credit.card: INFO  # More detailed in dev/test environments
```