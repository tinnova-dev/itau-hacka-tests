package com.authentication.app.controller

import com.authentication.app.controller.request.AuthenticationRequest
import com.authentication.app.service.AuthenticationService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.RequestBody

@RestController
@RequestMapping("/auth")
class AuthenticationController(
    private val authenticationService: AuthenticationService
) {

    @PostMapping
    fun creditOperation(@RequestBody creditCard: AuthenticationRequest): ResponseEntity<String> {
        authenticationService.authenticate(creditCard.creditCard)
        return ResponseEntity.ok("Authenticated")
    }
}   