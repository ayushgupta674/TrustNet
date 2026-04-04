package in.the_semicolon_squad.trust_net.controller;

import in.the_semicolon_squad.trust_net.model.Donation;
import in.the_semicolon_squad.trust_net.service.DonationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/donations")
@RequiredArgsConstructor
public class DonationController {

    private final DonationService donationService;

    @PostMapping("/initiate")
    public ResponseEntity<Map<String, String>> initiate(
            @RequestHeader("X-User-Id") String donorId,
            @RequestBody Map<String, String> body) throws Exception {

        String ngoId = body.get("ngoId");
        String campaignId = body.get("campaignId");
        double amount = Double.parseDouble(body.get("amount"));

        String orderId = donationService.initiateDonation(donorId, ngoId, campaignId, amount);
        return ResponseEntity.ok(Map.of("orderId", orderId));
    }

    @PostMapping("/verify")
    public ResponseEntity<Donation> verify(
            @RequestBody Map<String, String> body) {

        String razorpayOrderId = body.get("razorpayOrderId");
        String razorpayPaymentId = body.get("razorpayPaymentId");
        String signature = body.get("signature");
        Donation donation = donationService.verifyAndRecord(razorpayOrderId, razorpayPaymentId, signature);


        return ResponseEntity.ok(
               donation
        );
    }

    @GetMapping("/{id}/receipt")
    public ResponseEntity<Donation> getReceipt(@PathVariable String id) {
        return ResponseEntity.ok(donationService.getDonationById(id));
    }
}