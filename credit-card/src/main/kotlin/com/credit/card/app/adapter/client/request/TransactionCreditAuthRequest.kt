package com.credit.card.app.adapter.client.request

data class TransactionCreditAuthRequest(
    val creditCard: String,
    val value: Long
)