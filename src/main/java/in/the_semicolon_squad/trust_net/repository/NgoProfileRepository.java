package in.the_semicolon_squad.trust_net.repository;

import in.the_semicolon_squad.trust_net.enums.VerificationStatus;
import in.the_semicolon_squad.trust_net.model.NgoProfile;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface NgoProfileRepository extends MongoRepository<NgoProfile, String> {
    Optional<NgoProfile> findByUserId(String userId);

    List<NgoProfile> findByVerificationStatus(VerificationStatus verificationStatus);
}
