package com.credit.card.app.adapter.controller

import com.credit.card.app.adapter.controller.request.CreditOperationRequest
import com.credit.card.app.service.CreditService
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/credit")
class CreditController(
    private val creditService: CreditService
) {

    @PostMapping
    fun creditOperation(@RequestBody creditOperationRequest: CreditOperationRequest): String {
        return creditService.creditOperation(
            creditCard = creditOperationRequest.creditCard,
            value = creditOperationRequest.amount
        );
    }
}   