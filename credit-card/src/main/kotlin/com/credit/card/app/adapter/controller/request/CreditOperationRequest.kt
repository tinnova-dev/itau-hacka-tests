package com.credit.card.app.adapter.controller.request

data class CreditOperationRequest(
    val creditCard: String,
    val amount: Long,
    val username: String,
)