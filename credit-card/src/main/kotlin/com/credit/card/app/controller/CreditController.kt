package com.credit.card.app.controller

import com.credit.card.app.service.CreditService
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/credit")
class CreditController(
    private val creditService: CreditService
) {

    @PostMapping
    fun creditOperation(): String {
        return creditService.creditOperation();
    }
}   