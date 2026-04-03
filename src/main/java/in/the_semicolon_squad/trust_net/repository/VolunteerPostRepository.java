package in.the_semicolon_squad.trust_net.repository;

import in.the_semicolon_squad.trust_net.model.VolunteerPost;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface VolunteerPostRepository extends MongoRepository<VolunteerPost, String> {
    List<VolunteerPost> findByNgoId(String ngoId);
}