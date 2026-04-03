package in.the_semicolon_squad.trust_net.service;

import in.the_semicolon_squad.trust_net.model.Campaign;
import in.the_semicolon_squad.trust_net.model.Donation;
import in.the_semicolon_squad.trust_net.repository.CampaignRepository;
import in.the_semicolon_squad.trust_net.repository.DonationRepository;
import lombok.RequiredArgsConstructor;
import org.bson.Document;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class DonationService {

    private final DonationRepository donationRepository;
    private final CampaignRepository campaignRepository;
    private final RazorpayService razorpayService;
    private final MongoTemplate mongoTemplate;

    public String initiateDonation(String donorId, String ngoId,
                                   String campaignId, double amount) throws Exception {
        String orderId = razorpayService.createOrder(amount, "INR");

        Donation donation = new Donation();
        donation.setDonorId(donorId);
        donation.setNgoId(ngoId);
        donation.setCampaignId(campaignId);
        donation.setAmount(amount);
        donation.setRazorpayOrderId(orderId);
        donation.setVerified(false);

        donationRepository.save(donation);
        return orderId;
    }

    public Donation verifyAndRecord(String razorpayOrderId,
                                    String razorpayPaymentId,
                                    String signature) {
        boolean valid = razorpayService.verifyPayment(
                razorpayOrderId, razorpayPaymentId, signature
        );

        if (!valid) {
            throw new RuntimeException("Payment verification failed");
        }

        Donation donation = donationRepository.findByRazorpayOrderId(razorpayOrderId)
                .orElseThrow(() -> new RuntimeException("Donation not found"));

        donation.setRazorpayPaymentId(razorpayPaymentId);
        donation.setVerified(true);
        donationRepository.save(donation);

        // update campaign raised amount
        Campaign campaign = campaignRepository.findById(donation.getCampaignId())
                .orElseThrow(() -> new RuntimeException("Campaign not found"));
        campaign.setRaisedAmount(campaign.getRaisedAmount() + donation.getAmount());
        campaignRepository.save(campaign);

        return donation;
    }

    public Donation getDonationById(String id) {
        return donationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Donation not found"));
    }

    public List<Map> getTransparencyDashboard(String campaignId) {
        Document matchStage = new Document("$match",
                new Document("campaignId", campaignId)
                        .append("verified", true)
        );

        Document groupStage = new Document("$group",
                new Document("_id", new Document("$dateToString",
                        new Document("format", "%Y-%m-%d")
                                .append("date", "$createdAt")
                ))
                        .append("totalAmount", new Document("$sum", "$amount"))
                        .append("count", new Document("$sum", 1))
        );

        Document sortStage = new Document("$sort", new Document("_id", 1));

        List<Document> pipeline = Arrays.asList(matchStage, groupStage, sortStage);

        return mongoTemplate.getCollection("donations")
                .aggregate(pipeline, Document.class)
                .into(new java.util.ArrayList<>())
                .stream()
                .map(doc -> (Map) doc)
                .toList();
    }
}