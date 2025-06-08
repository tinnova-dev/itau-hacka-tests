package com.authentication.app.service

import org.springframework.stereotype.Service
import java.util.UUID

@Service
class AuthenticationService {

    companion object {
        private const val INVALID_USER: String = "INVALID_USER";
    }

    fun authenticate(creditCard: String): String {
        if (creditCard == INVALID_USER) {
            throw IllegalArgumentException("Invalid User")
        }
        return "TOKEN: " + UUID.randomUUID().toString()
    }
}