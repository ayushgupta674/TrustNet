package in.the_semicolon_squad.trust_net.controller;

import in.the_semicolon_squad.trust_net.model.FraudReport;
import in.the_semicolon_squad.trust_net.service.FraudReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/reports")
@RequiredArgsConstructor
public class FraudReportController {

    private final FraudReportService fraudReportService;

    @PostMapping
    public ResponseEntity<FraudReport> submitReport(
            @RequestHeader("X-User-Id") String reporterId,
            @RequestBody Map<String, String> body) {
        String ngoId = body.get("ngoId");
        String reason = body.get("reason");
        return ResponseEntity.ok(
                fraudReportService.submitReport(reporterId, ngoId, reason)
        );
    }

    @GetMapping("/admin/pending")
    public ResponseEntity<List<FraudReport>> getPendingReports() {
        return ResponseEntity.ok(fraudReportService.getAllPendingReports());
    }

    @PutMapping("/admin/{id}/dismiss")
    public ResponseEntity<FraudReport> dismiss(@PathVariable String id) {
        fraudReportService.dismissReport(id);
        return ResponseEntity.ok(fraudReportService.dismissReport(id));
    }

    @PutMapping("/admin/{id}/warn")
    public ResponseEntity<FraudReport> warn(@PathVariable String id) {
        return ResponseEntity.ok(fraudReportService.warnNgo(id));
    }

    @PutMapping("/admin/{id}/remove")
    public ResponseEntity<FraudReport> remove(@PathVariable String id) {
        return ResponseEntity.ok(fraudReportService.removeNgo(id));
    }
}