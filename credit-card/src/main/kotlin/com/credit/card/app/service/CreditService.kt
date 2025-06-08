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

    fun creditOperation(creditCard: String, amount: Long, username: String): String {
      val authToken = authenticationClient.authenticate(AuthenticationRequest(username))
        if (authToken.statusCode.isError) {
            return authToken.body!!
        }
        return transactionCreditAuthClient.creditAuth(
            TransactionCreditAuthRequest(creditCard, amount, authToken.body!!)
        ).toString()
    }
}