package in.the_semicolon_squad.trust_net.service;

import in.the_semicolon_squad.trust_net.enums.VerificationStatus;
import in.the_semicolon_squad.trust_net.model.NgoProfile;
import in.the_semicolon_squad.trust_net.repository.NgoProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final NgoProfileRepository ngoProfileRepository;

    public List<NgoProfile> getPendingVerifications() {
        return ngoProfileRepository.findByVerificationStatus(VerificationStatus.PENDING);
    }

    public NgoProfile approveNgo(String profileId) {
        NgoProfile profile = ngoProfileRepository.findById(profileId)
                .orElseThrow(() -> new RuntimeException("NGO profile not found"));

        profile.setVerificationStatus(VerificationStatus.VERIFIED);
        profile.setVerifiedBadge(true);
        profile.setRejectionReason(null);

        return ngoProfileRepository.save(profile);
    }

    public NgoProfile rejectNgo(String profileId, String reason) {
        NgoProfile profile = ngoProfileRepository.findById(profileId)
                .orElseThrow(() -> new RuntimeException("NGO profile not found"));

        profile.setVerificationStatus(VerificationStatus.REJECTED);
        profile.setVerifiedBadge(false);
        profile.setRejectionReason(reason);

        return ngoProfileRepository.save(profile);
    }
}