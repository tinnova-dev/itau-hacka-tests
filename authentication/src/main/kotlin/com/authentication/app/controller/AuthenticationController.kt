package com.authentication.app.controller

import com.authentication.app.controller.request.AuthenticationRequest
import com.authentication.app.service.AuthenticationService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/auth")
class AuthenticationController(
    private val authenticationService: AuthenticationService,
) {
    @PostMapping
    fun creditOperation(
        @RequestBody creditCard: AuthenticationRequest,
    ): ResponseEntity<String> {
        authenticationService.authenticate(creditCard.username)
        return ResponseEntity.ok("Authenticated")
    }
}
