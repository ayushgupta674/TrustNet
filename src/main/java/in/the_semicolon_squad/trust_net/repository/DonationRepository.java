package in.the_semicolon_squad.trust_net.repository;

import in.the_semicolon_squad.trust_net.model.Donation;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface DonationRepository extends MongoRepository<Donation, String> {
    List<Donation> findByCampaignId(String campaignId);
    List<Donation> findByDonorId(String donorId);
}