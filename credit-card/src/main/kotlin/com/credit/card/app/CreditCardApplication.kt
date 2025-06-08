package com.credit.card.app

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.cloud.openfeign.EnableFeignClients

@SpringBootApplication
@EnableFeignClients
class CreditCardApplication

fun main(args: Array<String>) {
    runApplication<CreditCardApplication>(*args)
}
