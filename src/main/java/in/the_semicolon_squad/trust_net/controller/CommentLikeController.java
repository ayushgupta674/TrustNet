package in.the_semicolon_squad.trust_net.controller;

import in.the_semicolon_squad.trust_net.model.Comment;
import in.the_semicolon_squad.trust_net.model.Post;
import in.the_semicolon_squad.trust_net.service.CommentLikeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class CommentLikeController {

    private final CommentLikeService commentLikeService;

    // ── COMMENTS ──

    @PostMapping("/posts/{postId}/comments")
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

    @GetMapping("/posts/{postId}/comments")
    public ResponseEntity<List<Comment>> getComments(@PathVariable String postId) {
        return ResponseEntity.ok(commentLikeService.getCommentsByPost(postId));
    }

    @GetMapping("/posts/{postId}/comments/count")
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

    @PostMapping("/posts/{postId}/like")
    public ResponseEntity<Post> likePost(
            @PathVariable String postId,
            @RequestHeader("X-User-Id") String userId) {
        return ResponseEntity.ok(commentLikeService.likePost(postId, userId));
    }

    @DeleteMapping("/posts/{postId}/like")
    public ResponseEntity<Post> unlikePost(
            @PathVariable String postId,
            @RequestHeader("X-User-Id") String userId) {
        return ResponseEntity.ok(commentLikeService.unlikePost(postId, userId));
    }

    @GetMapping("/posts/{postId}/liked")
    public ResponseEntity<Map<String, Boolean>> isLiked(
            @PathVariable String postId,
            @RequestHeader("X-User-Id") String userId) {
        return ResponseEntity.ok(
                Map.of("liked", commentLikeService.isLikedByUser(postId, userId))
        );
    }
}