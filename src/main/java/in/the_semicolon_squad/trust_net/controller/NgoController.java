package in.the_semicolon_squad.trust_net.controller;


import in.the_semicolon_squad.trust_net.dto.NgoProfileUpdateRequest;
import in.the_semicolon_squad.trust_net.model.NgoProfile;
import in.the_semicolon_squad.trust_net.service.NgoService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/ngo")
@RequiredArgsConstructor
public class NgoController {

    private final NgoService ngoService;

    @PutMapping("/profile")
    public ResponseEntity<NgoProfile> updateProfile(
            @RequestHeader("X-User-Id") String userId,
            @Valid @RequestBody NgoProfileUpdateRequest request) {
        return ResponseEntity.ok(ngoService.updateProfile(userId, request));
    }

    @GetMapping("/profile")
    public ResponseEntity<NgoProfile> getMyProfile(
            @RequestHeader("X-User-Id") String userId) {
        return ResponseEntity.ok(ngoService.getProfileByUserId(userId));
    }

    @GetMapping("/profile/{id}")
    public ResponseEntity<NgoProfile> getProfileById(@PathVariable String id) {
        return ResponseEntity.ok(ngoService.getProfileById(id));
    }
}