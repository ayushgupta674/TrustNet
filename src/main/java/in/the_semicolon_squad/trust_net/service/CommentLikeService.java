package in.the_semicolon_squad.trust_net.service;

import in.the_semicolon_squad.trust_net.model.Comment;
import in.the_semicolon_squad.trust_net.model.Post;
import in.the_semicolon_squad.trust_net.repository.CommentRepository;
import in.the_semicolon_squad.trust_net.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CommentLikeService {

    private final CommentRepository commentRepository;
    private final PostRepository postRepository;

    // ── COMMENTS ──

    public Comment addComment(String postId, String userId,
                              String userName, String text) {
        // verify post exists
        postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        Comment comment = new Comment();
        comment.setPostId(postId);
        comment.setUserId(userId);
        comment.setUserName(userName);
        comment.setText(text);

        return commentRepository.save(comment);
    }

    public List<Comment> getCommentsByPost(String postId) {
        return commentRepository.findByPostIdOrderByCreatedAtAsc(postId);
    }

    public long getCommentCount(String postId) {
        return commentRepository.countByPostId(postId);
    }

    public void deleteComment(String commentId, String userId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new RuntimeException("Comment not found"));

        if (!comment.getUserId().equals(userId)) {
            throw new RuntimeException("You can only delete your own comments");
        }

        commentRepository.delete(comment);
    }

    // ── LIKES ──

    public Post likePost(String postId, String userId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        if (!post.getLikedByUserIds().contains(userId)) {
            post.getLikedByUserIds().add(userId);
            post.setLikeCount(post.getLikedByUserIds().size());
            postRepository.save(post);
        }

        return post;
    }

    public Post unlikePost(String postId, String userId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        post.getLikedByUserIds().remove(userId);
        post.setLikeCount(post.getLikedByUserIds().size());

        return postRepository.save(post);
    }

    public boolean isLikedByUser(String postId, String userId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));
        return post.getLikedByUserIds().contains(userId);
    }
}