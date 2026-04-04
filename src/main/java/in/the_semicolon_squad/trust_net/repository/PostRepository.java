package in.the_semicolon_squad.trust_net.repository;

import in.the_semicolon_squad.trust_net.model.Post;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface PostRepository extends MongoRepository<Post, String> {
    List<Post> findByNgoIdOrderByCreatedAtDesc(String ngoId);
}