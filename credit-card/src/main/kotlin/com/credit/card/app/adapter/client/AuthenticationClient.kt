package com.credit.card.app.adapter.client

import com.credit.card.app.adapter.client.request.AuthenticationRequest
import org.springframework.cloud.openfeign.FeignClient
import org.springframework.http.ResponseEntity

import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody

@FeignClient(name = "authenticationClient", url = "\${authentication.service.url}")
interface AuthenticationClient {
    @PostMapping("/auth")
    fun authenticate(@RequestBody request: AuthenticationRequest): ResponseEntity<String>
}