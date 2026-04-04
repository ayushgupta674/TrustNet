package in.the_semicolon_squad.trust_net.service;

import in.the_semicolon_squad.trust_net.model.DonorProfile;
import in.the_semicolon_squad.trust_net.model.NgoProfile;
import in.the_semicolon_squad.trust_net.repository.DonorProfileRepository;
import in.the_semicolon_squad.trust_net.repository.NgoProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DonorService {

    private final DonorProfileRepository donorProfileRepository;
    private final NgoProfileRepository ngoProfileRepository;

    public DonorProfile getProfileByUserId(String userId) {
        return donorProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Donor profile not found"));
    }

    public DonorProfile followNgo(String userId, String ngoId) {
        DonorProfile profile = getProfileByUserId(userId);
        if (!profile.getFollowedNgoIds().contains(ngoId)) {
            profile.getFollowedNgoIds().add(ngoId);
            donorProfileRepository.save(profile);
        }
        return profile;
    }

    public DonorProfile unfollowNgo(String userId, String ngoId) {
        DonorProfile profile = getProfileByUserId(userId);
        profile.getFollowedNgoIds().remove(ngoId);
        return donorProfileRepository.save(profile);
    }

    public List<NgoProfile> getFollowedNgos(String userId) {
        DonorProfile profile = getProfileByUserId(userId);
        return ngoProfileRepository.findAllById(profile.getFollowedNgoIds());
    }
}