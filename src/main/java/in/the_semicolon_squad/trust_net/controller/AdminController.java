package in.the_semicolon_squad.trust_net.controller;


import in.the_semicolon_squad.trust_net.model.NgoProfile;
import in.the_semicolon_squad.trust_net.service.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;

    @GetMapping("/verifications/pending")
    public ResponseEntity<List<NgoProfile>> getPendingVerifications() {
        return ResponseEntity.ok(adminService.getPendingVerifications());
    }

    @PutMapping("/verifications/{id}/approve")
    public ResponseEntity<NgoProfile> approveNgo(@PathVariable String id) {
        return ResponseEntity.ok(adminService.approveNgo(id));
    }

    @PutMapping("/verifications/{id}/reject")
    public ResponseEntity<NgoProfile> rejectNgo(
            @PathVariable String id,
            @RequestBody Map<String, String> body) {
        String reason = body.get("reason");
        return ResponseEntity.ok(adminService.rejectNgo(id, reason));
    }

    @GetMapping("/analytics")
    public ResponseEntity<Map<String, Object>> getAnalytics() {
        return ResponseEntity.ok(adminService.getAnalytics());
    }
}
