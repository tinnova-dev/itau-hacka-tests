package com.credit.card.app.adapter.controller

import org.slf4j.LoggerFactory
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/logs")
class LoggingController {

    private val logger = LoggerFactory.getLogger(LoggingController::class.java)

    @GetMapping
    fun generateLogs(): ResponseEntity<String> {
        // Log 1
        logger.info("Log 1: Starting the logging process")
        
        // Log 2
        logger.debug("Log 2: This is a debug message")
        
        // Log 3
        logger.info("Log 3: Processing request to generate logs")
        
        // Log 4
        logger.warn("Log 4: This is a warning message")
        
        // Log 5
        logger.error("Log 5: This is an error message")
        
        // Log 6
        logger.info("Log 6: Halfway through the first batch of logs")
        
        // Log 7
        logger.debug("Log 7: More detailed information for debugging")
        
        // Log 8
        logger.info("Log 8: Still processing the request")
        
        // Log 9
        logger.warn("Log 9: Another warning message")
        
        // Log 10
        logger.info("Log 10: Completed first half of logs")
        
        // Log 11
        logger.debug("Log 11: Starting second half of logs")
        
        // Log 12
        logger.info("Log 12: Continuing the logging process")
        
        // Log 13
        logger.warn("Log 13: Third warning message")
        
        // Log 14
        logger.error("Log 14: Second error message")
        
        // Log 15
        logger.info("Log 15: Almost done with logging")
        
        // Log 16
        logger.debug("Log 16: Final debug message")
        
        // Log 17
        logger.info("Log 17: Preparing to complete the request")
        
        // Log 18
        logger.warn("Log 18: Final warning message")
        
        // Log 19
        logger.error("Log 19: Final error message")
        
        // Log 20
        logger.info("Log 20: Logging process completed successfully")
        
        return ResponseEntity.ok("20 logs have been generated. Check the application logs.")
    }
}