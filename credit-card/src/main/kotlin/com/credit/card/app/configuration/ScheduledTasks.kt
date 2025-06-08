package com.credit.card.app.configuration

import org.slf4j.LoggerFactory
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component

@Component
class ScheduledTasks {

    private val logger = LoggerFactory.getLogger(ScheduledTasks::class.java)

    @Scheduled(fixedRate = 10000)
    fun logEveryTenSeconds() {
        logger.info("this should not be logging")
    }

    @Scheduled(fixedRate = 300000)
    fun logEveryFiveMinutes() {
        logger.info("this is a good log")
    }
}