package com.credit.card.app.adapter.client

import com.credit.card.app.adapter.client.request.TransactionCreditAuthRequest
import org.springframework.cloud.openfeign.FeignClient
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping

@FeignClient(name = "transactionCreditAuthClient", url = "\${transaction-credit-auth.service.url}")
interface TransactionCreditAuthClient {
    @PostMapping("/auth")
    fun creditAuth(request: TransactionCreditAuthRequest): ResponseEntity<String>
}
