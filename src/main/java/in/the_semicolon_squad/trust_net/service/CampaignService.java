package in.the_semicolon_squad.trust_net.service;

import in.the_semicolon_squad.trust_net.model.Campaign;
import in.the_semicolon_squad.trust_net.repository.CampaignRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CampaignService {

    private final CampaignRepository campaignRepository;

    public Campaign createCampaign(Campaign campaign) {
        return campaignRepository.save(campaign);
    }

    public Campaign getCampaignById(String id) {
        return campaignRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Campaign not found"));
    }

    public List<Campaign> getCampaignsByNgo(String ngoId) {
        return campaignRepository.findByNgoId(ngoId);
    }

    public Campaign postOutcomeUpdate(String campaignId, String outcome) {
        Campaign campaign = getCampaignById(campaignId);
        campaign.setOutcomeUpdate(outcome);
        campaign.setActive(false);
        return campaignRepository.save(campaign);
    }

    public Campaign uploadImpactProof(String campaignId, String proofUrl) {
        Campaign campaign = getCampaignById(campaignId);
        campaign.setImpactProofUrl(proofUrl);
        return campaignRepository.save(campaign);
    }

    public Campaign verifyImpact(String campaignId) {
        Campaign campaign = getCampaignById(campaignId);
        campaign.setImpactVerified(true);
        return campaignRepository.save(campaign);
    }
}