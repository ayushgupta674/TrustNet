package in.the_semicolon_squad.trust_net.controller;

import in.the_semicolon_squad.trust_net.model.VolunteerPost;
import in.the_semicolon_squad.trust_net.service.NgoService;
import in.the_semicolon_squad.trust_net.service.VolunteerService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/volunteer")
@RequiredArgsConstructor
public class VolunteerController {

    private final VolunteerService volunteerService;
    private final NgoService ngoService;

    @PostMapping("/posts")
    public ResponseEntity<VolunteerPost> createPost(
            @RequestHeader("X-User-Id") String userId,
            @RequestBody Map<String, String> body) {

        VolunteerPost post = new VolunteerPost();
        post.setNgoId(ngoService.getProfileByUserId(userId).getId());
        post.setSkillNeeded(body.get("skillNeeded"));
        post.setDescription(body.get("description"));
        post.setDate(LocalDateTime.parse(body.get("date")));

        return ResponseEntity.ok(volunteerService.createVolunteerPost(post));
    }

    @GetMapping("/posts/ngo/{ngoId}")
    public ResponseEntity<List<VolunteerPost>> getPostsByNgo(@PathVariable String ngoId) {
        return ResponseEntity.ok(volunteerService.getVolunteerPostsByNgo(ngoId));
    }

    @PostMapping("/posts/{postId}/apply")
    public ResponseEntity<VolunteerPost> apply(
            @PathVariable String postId,
            @RequestHeader("X-User-Id") String applicantId) {
        return ResponseEntity.ok(volunteerService.applyToVolunteer(postId, applicantId));
    }

    @PutMapping("/posts/{postId}/applications/{applicantId}/accept")
    public ResponseEntity<VolunteerPost> accept(
            @PathVariable String postId,
            @PathVariable String applicantId) {
        return ResponseEntity.ok(volunteerService.acceptApplication(postId, applicantId));
    }

    @PutMapping("/posts/{postId}/applications/{applicantId}/reject")
    public ResponseEntity<VolunteerPost> reject(
            @PathVariable String postId,
            @PathVariable String applicantId) {
        return ResponseEntity.ok(volunteerService.rejectApplication(postId, applicantId));
    }
}