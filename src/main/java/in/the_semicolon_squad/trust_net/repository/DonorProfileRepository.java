package in.the_semicolon_squad.trust_net.repository;

import in.the_semicolon_squad.trust_net.model.DonorProfile;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface DonorProfileRepository extends MongoRepository<DonorProfile, String> {
    Optional<DonorProfile> findByUserId(String userId);
}