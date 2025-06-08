package com.authentication.app.exception

class InvalidCreditCardAuthenticationException(
    message: String = "Invalid credit card authentication.",
) : RuntimeException(message)
