package com.credit.card.app.service

import com.credit.card.app.adapter.client.AuthenticationClient
import com.credit.card.app.adapter.client.TransactionCreditAuthClient
import com.credit.card.app.adapter.client.request.AuthenticationRequest
import com.credit.card.app.adapter.client.request.TransactionCreditAuthRequest
import org.springframework.stereotype.Service

@Service
class CreditService(
    private val authenticationClient: AuthenticationClient,
    private val transactionCreditAuthClient: TransactionCreditAuthClient
) {

    fun creditOperation(creditCard: String, value: Long): String {
        authenticationClient.authenticate(AuthenticationRequest(creditCard))
//            transactionCreditAuthClient.creditAuth(TransactionCreditAuthRequest(creditCard, value))
        return "APPROVED"
    }
}