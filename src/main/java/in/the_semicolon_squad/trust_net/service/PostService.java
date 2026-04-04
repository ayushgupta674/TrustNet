package in.the_semicolon_squad.trust_net.service;

import in.the_semicolon_squad.trust_net.enums.NotificationType;
import in.the_semicolon_squad.trust_net.enums.VerificationStatus;
import in.the_semicolon_squad.trust_net.model.NgoProfile;
import in.the_semicolon_squad.trust_net.model.Post;
import in.the_semicolon_squad.trust_net.repository.NgoProfileRepository;
import in.the_semicolon_squad.trust_net.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PostService {

    private final PostRepository postRepository;
    private final NgoProfileRepository ngoProfileRepository;
    private final NotificationService notificationService;

    public Post createPost(String userId, String text,
                           String imageUrl, String videoUrl, String campaignId) {

        NgoProfile profile = ngoProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("NGO profile not found"));

        if (!profile.isVerifiedBadge()) {
            throw new RuntimeException("Only verified NGOs can post");
        }

        Post post = new Post();
        post.setNgoId(profile.getId());
        post.setText(text);
        post.setImageUrl(imageUrl);
        post.setVideoUrl(videoUrl);
        post.setCampaignId(campaignId);

        return postRepository.save(post);
    }

    public List<Post> getFeed() {
        List<NgoProfile> verifiedNgos = ngoProfileRepository
                .findByVerificationStatus(VerificationStatus.VERIFIED);

        List<Post> feed = new ArrayList<>();
        for (NgoProfile ngo : verifiedNgos) {
            feed.addAll(postRepository.findByNgoIdOrderByCreatedAtDesc(ngo.getId()));
        }

        feed.sort(Comparator.comparing(Post::getCreatedAt).reversed());
        return feed;
    }

    public List<Post> getPostsByNgo(String ngoId) {
        return postRepository.findByNgoIdOrderByCreatedAtDesc(ngoId);
    }
}