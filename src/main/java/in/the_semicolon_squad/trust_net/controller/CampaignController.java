package in.the_semicolon_squad.trust_net.controller;

import in.the_semicolon_squad.trust_net.dto.CampaignRequest;
import in.the_semicolon_squad.trust_net.model.Campaign;
import in.the_semicolon_squad.trust_net.model.NgoProfile;
import in.the_semicolon_squad.trust_net.service.CampaignService;
import in.the_semicolon_squad.trust_net.service.DonationService;
import in.the_semicolon_squad.trust_net.service.NgoService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/campaigns")
@RequiredArgsConstructor
public class CampaignController {

    private final CampaignService campaignService;
    private final NgoService ngoService;
private  final DonationService donationService;
    @PostMapping
    public ResponseEntity<Campaign> createCampaign(
            @RequestHeader("X-User-Id") String userId,
            @Valid @RequestBody CampaignRequest request) {

        NgoProfile profile = ngoService.getProfileByUserId(userId);

        Campaign campaign = new Campaign();
        campaign.setNgoId(profile.getId());
        campaign.setTitle(request.getTitle());
        campaign.setDescription(request.getDescription());
        campaign.setGoalAmount(request.getGoalAmount());
        campaign.setDeadline(request.getDeadline());

        return ResponseEntity.ok(campaignService.createCampaign(campaign));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Campaign> getCampaign(@PathVariable String id) {
        return ResponseEntity.ok(campaignService.getCampaignById(id));
    }

    @GetMapping("/ngo/{ngoId}")
    public ResponseEntity<List<Campaign>> getCampaignsByNgo(@PathVariable String ngoId) {
        return ResponseEntity.ok(campaignService.getCampaignsByNgo(ngoId));
    }

    @PostMapping("/{id}/proof")
    public ResponseEntity<Campaign> uploadProof(
            @PathVariable String id,
            @RequestBody Map<String, String> body) {
        String proofUrl = body.get("proofUrl");
        return ResponseEntity.ok(campaignService.uploadImpactProof(id, proofUrl));
    }

    @PostMapping("/{id}/outcome")
    public ResponseEntity<Campaign> postOutcome(
            @PathVariable String id,
            @RequestBody Map<String, String> body) {
        String outcome = body.get("outcome");
        return ResponseEntity.ok(campaignService.postOutcomeUpdate(id, outcome));
    }

    @GetMapping("/{id}/transparency")
    public ResponseEntity<List<Map>> getTransparency(@PathVariable String id) {
        return ResponseEntity.ok(donationService.getTransparencyDashboard(id));
    }
}