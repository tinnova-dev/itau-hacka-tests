package com.credit.card.app.adapter.controller

import com.credit.card.app.adapter.controller.request.CreditOperationRequest
import com.credit.card.app.service.CreditService
import org.slf4j.LoggerFactory
import org.slf4j.MDC
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@RestController
@RequestMapping("/transactions")
class TransactionController(
    private val creditService: CreditService,
) {
    private val logger = LoggerFactory.getLogger(TransactionController::class.java)

    @PostMapping("/process")
    fun processTransaction(@RequestBody request: CreditOperationRequest): ResponseEntity<Map<String, Any>> {
        val transactionId = UUID.randomUUID().toString()
        
        try {
            // Set transaction ID in MDC for correlation in logs
            MDC.put("transactionId", transactionId)
            MDC.put("username", request.username)
            
            logger.info("Transaction processing started - amount: {}, user: {}", 
                request.amount, maskUsername(request.username))
            
            // Log sensitive data at debug level with masking
            logger.debug("Processing transaction details - card: {}, amount: {}", 
                maskCreditCard(request.creditCard), request.amount)
            
            // Process the transaction
            val result = creditService.creditOperation(
                creditCard = request.creditCard,
                amount = request.amount,
                username = request.username
            )
            
            logger.info("Transaction processed successfully - transactionId: {}, result: {}", 
                transactionId, result)
            
            return ResponseEntity.ok(mapOf(
                "status" to "success",
                "message" to result,
                "transactionId" to transactionId
            ))
        } catch (e: Exception) {
            logger.error("Error processing transaction - transactionId: {}, error: {}", 
                transactionId, e.message, e)
            
            return ResponseEntity.internalServerError().body(mapOf(
                "status" to "error",
                "message" to "Transaction processing failed",
                "transactionId" to transactionId
            ))
        } finally {
            // Clean up MDC to prevent memory leaks
            MDC.clear()
        }
    }
    
    /**
     * Masks a credit card number for security in logs
     * Only shows the last 4 digits
     */
    private fun maskCreditCard(creditCard: String): String {
        return if (creditCard.length > 4) {
            "*".repeat(creditCard.length - 4) + creditCard.takeLast(4)
        } else {
            "****"
        }
    }
    
    /**
     * Masks a username for privacy in logs
     * Shows first character and last character with asterisks in between
     */
    private fun maskUsername(username: String): String {
        return if (username.length > 2) {
            username.first() + "*".repeat(username.length - 2) + username.last()
        } else {
            "**"
        }
    }
}