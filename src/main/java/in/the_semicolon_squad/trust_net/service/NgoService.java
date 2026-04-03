package in.the_semicolon_squad.trust_net.service;


import in.the_semicolon_squad.trust_net.dto.NgoProfileUpdateRequest;
import in.the_semicolon_squad.trust_net.model.NgoProfile;
import in.the_semicolon_squad.trust_net.repository.NgoProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class NgoService {

    private final NgoProfileRepository ngoProfileRepository;

    public NgoProfile updateProfile(String userId, NgoProfileUpdateRequest request) {
        NgoProfile profile = ngoProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("NGO profile not found"));

        profile.setName(request.getName());
        profile.setDescription(request.getDescription());
        profile.setCause(request.getCause());
        profile.setRegistrationDocumentUrl(request.getRegistrationDocumentUrl());

        if (request.getLocation() != null) {
            profile.setLocation(request.getLocation());
        }

        return ngoProfileRepository.save(profile);
    }

    public NgoProfile getProfileByUserId(String userId) {
        return ngoProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("NGO profile not found"));
    }

    public NgoProfile getProfileById(String id) {
        return ngoProfileRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("NGO profile not found"));
    }
}