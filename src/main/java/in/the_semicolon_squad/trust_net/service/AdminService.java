package in.the_semicolon_squad.trust_net.service;

import in.the_semicolon_squad.trust_net.enums.NotificationType;
import in.the_semicolon_squad.trust_net.enums.Role;
import in.the_semicolon_squad.trust_net.enums.VerificationStatus;
import in.the_semicolon_squad.trust_net.model.NgoProfile;
import in.the_semicolon_squad.trust_net.repository.*;
import lombok.RequiredArgsConstructor;
import org.bson.Document;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AdminService {
    private final UserRepository userRepository;
    private final CampaignRepository campaignRepository;
    private final DonationRepository donationRepository;
    private final FraudReportRepository fraudReportRepository;
    private final VolunteerPostRepository volunteerPostRepository;
    private final MongoTemplate mongoTemplate;
    private final NgoProfileRepository ngoProfileRepository;
    private final NotificationService  notificationService;

    public List<NgoProfile> getPendingVerifications() {
        return ngoProfileRepository.findByVerificationStatus(VerificationStatus.PENDING);
    }

    public NgoProfile approveNgo(String profileId) {
        NgoProfile profile = ngoProfileRepository.findById(profileId)
                .orElseThrow(() -> new RuntimeException("NGO profile not found"));

        profile.setVerificationStatus(VerificationStatus.VERIFIED);
        profile.setVerifiedBadge(true);
        profile.setRejectionReason(null);

        NgoProfile saved = ngoProfileRepository.save(profile);

        notificationService.sendNotification(
                saved.getUserId(),
                NotificationType.NGO_VERIFIED,
                "Congratulations! Your NGO has been verified."
        );

        return saved;
    }

    public NgoProfile rejectNgo(String profileId, String reason) {
        NgoProfile profile = ngoProfileRepository.findById(profileId)
                .orElseThrow(() -> new RuntimeException("NGO profile not found"));

        profile.setVerificationStatus(VerificationStatus.REJECTED);
        profile.setVerifiedBadge(false);
        profile.setRejectionReason(reason);

        return ngoProfileRepository.save(profile);
    }

    public Map<String, Object> getAnalytics() {
        Map<String, Object> analytics = new HashMap<>();

        // NGO counts
        analytics.put("totalNgos", ngoProfileRepository.count());
        analytics.put("verifiedNgos", ngoProfileRepository
                .findByVerificationStatus(VerificationStatus.VERIFIED).size());
        analytics.put("pendingNgos", ngoProfileRepository
                .findByVerificationStatus(VerificationStatus.PENDING).size());
        analytics.put("rejectedNgos", ngoProfileRepository
                .findByVerificationStatus(VerificationStatus.REJECTED).size());

        // Donor count
        analytics.put("totalDonors", userRepository.countByRole(Role.DONOR));

        // Donation stats via aggregation pipeline
        Document matchVerified = new Document("$match",
                new Document("verified", true));
        Document groupTotal = new Document("$group",
                new Document("_id", null)
                        .append("totalAmount", new Document("$sum", "$amount"))
                        .append("totalCount", new Document("$sum", 1)));

        List<Document> pipeline = Arrays.asList(matchVerified, groupTotal);
        List<Document> result = mongoTemplate.getCollection("donations")
                .aggregate(pipeline, Document.class)
                .into(new java.util.ArrayList<>());

        if (!result.isEmpty()) {
            Document stats = result.get(0);
            analytics.put("totalDonations", stats.getInteger("totalCount"));
            analytics.put("totalAmountRaised", stats.getDouble("totalAmount"));
        } else {
            analytics.put("totalDonations", 0);
            analytics.put("totalAmountRaised", 0.0);
        }

        // Campaign counts
        analytics.put("totalCampaigns", campaignRepository.count());
        analytics.put("activeCampaigns", campaignRepository.countByActive(true));

        // Volunteer and fraud counts
        analytics.put("totalVolunteerPosts", volunteerPostRepository.count());
        analytics.put("totalFraudReports", fraudReportRepository.count());
        analytics.put("pendingFraudReports",
                fraudReportRepository.findByStatus("PENDING").size());

        return analytics;
    }
}