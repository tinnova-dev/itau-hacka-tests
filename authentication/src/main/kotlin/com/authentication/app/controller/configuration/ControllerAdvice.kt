package com.authentication.app.controller.configuration

import com.authentication.app.exception.InvalidCreditCardAuthenticationException
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.context.request.WebRequest

@ControllerAdvice
class GlobalControllerAdvice {

    @ExceptionHandler(Exception::class)
    fun handleAllExceptions(ex: Exception, request: WebRequest): ResponseEntity<String> {
        return ResponseEntity("An error occurred: ${ex.message}", HttpStatus.INTERNAL_SERVER_ERROR)
    }
    
    @ExceptionHandler(InvalidCreditCardAuthenticationException::class)
    fun handleInvalidCreditCardAuthenticationException(
        ex: InvalidCreditCardAuthenticationException,
        request: WebRequest
    ): ResponseEntity<String> {
        return ResponseEntity("${ex.message}", HttpStatus.UNAUTHORIZED)
    }


}