package in.the_semicolon_squad.trust_net.service;

import in.the_semicolon_squad.trust_net.model.FraudReport;
import in.the_semicolon_squad.trust_net.model.NgoProfile;
import in.the_semicolon_squad.trust_net.repository.FraudReportRepository;
import in.the_semicolon_squad.trust_net.repository.NgoProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FraudReportService {

    private final FraudReportRepository fraudReportRepository;
    private final NgoProfileRepository ngoProfileRepository;

    public FraudReport submitReport(String reporterId, String ngoId, String reason) {
        FraudReport report = new FraudReport();
        report.setReporterId(reporterId);
        report.setNgoId(ngoId);
        report.setReason(reason);
        return fraudReportRepository.save(report);
    }

    public List<FraudReport> getAllPendingReports() {
        return fraudReportRepository.findByStatus("PENDING");
    }

    public FraudReport dismissReport(String reportId) {
        FraudReport report = fraudReportRepository.findById(reportId)
                .orElseThrow(() -> new RuntimeException("Report not found"));
        report.setStatus("DISMISSED");
        report.setAdminAction("Report dismissed after review");
        return fraudReportRepository.save(report);
    }

    public FraudReport warnNgo(String reportId) {
        FraudReport report = fraudReportRepository.findById(reportId)
                .orElseThrow(() -> new RuntimeException("Report not found"));
        report.setStatus("WARNED");
        report.setAdminAction("NGO has been warned");
        return fraudReportRepository.save(report);
    }

    public FraudReport removeNgo(String reportId) {
        FraudReport report = fraudReportRepository.findById(reportId)
                .orElseThrow(() -> new RuntimeException("Report not found"));

        NgoProfile ngo = ngoProfileRepository.findById(report.getNgoId())
                .orElseThrow(() -> new RuntimeException("NGO not found"));

        ngo.setVerifiedBadge(false);
        ngo.setVerificationStatus(
                in.the_semicolon_squad.trust_net.enums.VerificationStatus.REJECTED
        );
        ngoProfileRepository.save(ngo);

        report.setStatus("REMOVED");
        report.setAdminAction("NGO has been removed from platform");
        return fraudReportRepository.save(report);
    }
}