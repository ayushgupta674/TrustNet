package in.the_semicolon_squad.trust_net.controller;

import in.the_semicolon_squad.trust_net.model.Post;
import in.the_semicolon_squad.trust_net.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/posts")
@RequiredArgsConstructor
public class PostController {

    private final PostService postService;

    @PostMapping
    public ResponseEntity<Post> createPost(
            @RequestHeader("X-User-Id") String userId,
            @RequestBody Map<String, String> body) {

        String text = body.get("text");
        String imageUrl = body.get("imageUrl");
        String videoUrl = body.get("videoUrl");
        String campaignId = body.get("campaignId");

        return ResponseEntity.ok(
                postService.createPost(userId, text, imageUrl, videoUrl, campaignId)
        );
    }

    @GetMapping("/feed")
    public ResponseEntity<List<Post>> getFeed() {
        return ResponseEntity.ok(postService.getFeed());
    }

    @GetMapping("/ngo/{ngoId}")
    public ResponseEntity<List<Post>> getPostsByNgo(@PathVariable String ngoId) {
        return ResponseEntity.ok(postService.getPostsByNgo(ngoId));
    }
}