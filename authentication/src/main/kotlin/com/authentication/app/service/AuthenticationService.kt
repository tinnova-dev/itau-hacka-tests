package com.authentication.app.service

import org.springframework.stereotype.Service

@Service
class AuthenticationService {
    companion object {
        private const val INVALID_CARD: String = "INVALID_CARD"
    }

    fun authenticate(creditCard: String) {
        if (creditCard == INVALID_CARD) {
            throw IllegalArgumentException("Invalid credit card")
        }
    }
}
