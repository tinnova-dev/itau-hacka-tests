package com.authentication.app.controller

import com.authentication.app.service.AuthenticationService
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/credit")
class AuthenticationController(
    private val authenticationService: AuthenticationService
) {

    @PostMapping
    fun creditOperation(): String {
        return authenticationService.creditOperation();
    }
}   