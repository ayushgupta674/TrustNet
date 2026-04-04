package in.the_semicolon_squad.trust_net.controller;

import in.the_semicolon_squad.trust_net.model.DonorProfile;
import in.the_semicolon_squad.trust_net.model.NgoProfile;
import in.the_semicolon_squad.trust_net.service.DonorService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/donor")
@RequiredArgsConstructor
public class DonorController {

    private final DonorService donorService;

    @GetMapping("/profile")
    public ResponseEntity<DonorProfile> getProfile(
            @RequestHeader("X-User-Id") String userId) {
        return ResponseEntity.ok(donorService.getProfileByUserId(userId));
    }

    @PostMapping("/follow/{ngoId}")
    public ResponseEntity<DonorProfile> followNgo(
            @RequestHeader("X-User-Id") String userId,
            @PathVariable String ngoId) {
        return ResponseEntity.ok(donorService.followNgo(userId, ngoId));
    }

    @DeleteMapping("/unfollow/{ngoId}")
    public ResponseEntity<DonorProfile> unfollowNgo(
            @RequestHeader("X-User-Id") String userId,
            @PathVariable String ngoId) {
        return ResponseEntity.ok(donorService.unfollowNgo(userId, ngoId));
    }

    @GetMapping("/following")
    public ResponseEntity<List<NgoProfile>> getFollowedNgos(
            @RequestHeader("X-User-Id") String userId) {
        return ResponseEntity.ok(donorService.getFollowedNgos(userId));
    }
}