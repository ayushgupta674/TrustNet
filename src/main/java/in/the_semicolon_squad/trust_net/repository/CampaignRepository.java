package in.the_semicolon_squad.trust_net.repository;

import in.the_semicolon_squad.trust_net.model.Campaign;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface CampaignRepository extends MongoRepository<Campaign, String> {
    List<Campaign> findByNgoId(String ngoId);
    List<Campaign> findByNgoIdAndActive(String ngoId, boolean active);

    long countByActive(boolean active);
}