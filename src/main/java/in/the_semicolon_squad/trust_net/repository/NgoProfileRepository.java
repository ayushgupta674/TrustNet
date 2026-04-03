package in.the_semicolon_squad.trust_net.repository;

import in.the_semicolon_squad.trust_net.model.NgoProfile;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface NgoProfileRepository extends MongoRepository<NgoProfile, String> {
    Optional<NgoProfile> findByUserId(String userId);
}
