package in.the_semicolon_squad.trust_net.controller;

import in.the_semicolon_squad.trust_net.dto.AuthResponse;
import in.the_semicolon_squad.trust_net.dto.LoginRequest;
import in.the_semicolon_squad.trust_net.dto.RegisterRequest;
import in.the_semicolon_squad.trust_net.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        return ResponseEntity.ok(authService.register(request));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }
}
