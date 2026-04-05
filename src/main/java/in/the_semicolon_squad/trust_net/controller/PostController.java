package in.the_semicolon_squad.trust_net.controller;

import in.the_semicolon_squad.trust_net.model.Comment;
import in.the_semicolon_squad.trust_net.model.Post;
import in.the_semicolon_squad.trust_net.service.CommentLikeService;
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
    private final CommentLikeService commentLikeService;

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


    @PostMapping("/{postId}/comments")
    public ResponseEntity<Comment> addComment(
            @PathVariable String postId,
            @RequestHeader("X-User-Id") String userId,
            @RequestBody Map<String, String> body) {

        String userName = body.get("userName");
        String text = body.get("text");

        return ResponseEntity.ok(
                commentLikeService.addComment(postId, userId, userName, text)
        );
    }

    @GetMapping("/{postId}/comments")
    public ResponseEntity<List<Comment>> getComments(@PathVariable String postId) {
        return ResponseEntity.ok(commentLikeService.getCommentsByPost(postId));
    }

    @GetMapping("/{postId}/comments/count")
    public ResponseEntity<Map<String, Long>> getCommentCount(@PathVariable String postId) {
        return ResponseEntity.ok(
                Map.of("count", commentLikeService.getCommentCount(postId))
        );
    }

    @DeleteMapping("/comments/{commentId}")
    public ResponseEntity<Void> deleteComment(
            @PathVariable String commentId,
            @RequestHeader("X-User-Id") String userId) {
        commentLikeService.deleteComment(commentId, userId);
        return ResponseEntity.ok().build();
    }

    // ── LIKES ──

    @PostMapping("/{postId}/like")
    public ResponseEntity<Post> likePost(
            @PathVariable String postId,
            @RequestHeader("X-User-Id") String userId) {
        return ResponseEntity.ok(commentLikeService.likePost(postId, userId));
    }

    @DeleteMapping("/{postId}/like")
    public ResponseEntity<Post> unlikePost(
            @PathVariable String postId,
            @RequestHeader("X-User-Id") String userId) {
        return ResponseEntity.ok(commentLikeService.unlikePost(postId, userId));
    }

    @GetMapping("/{postId}/liked")
    public ResponseEntity<Map<String, Boolean>> isLiked(
            @PathVariable String postId,
            @RequestHeader("X-User-Id") String userId) {
        return ResponseEntity.ok(
                Map.of("liked", commentLikeService.isLikedByUser(postId, userId))
        );
    }
}