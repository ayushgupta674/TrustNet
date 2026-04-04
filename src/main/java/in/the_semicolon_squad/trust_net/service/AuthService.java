package in.the_semicolon_squad.trust_net.service;


import in.the_semicolon_squad.trust_net.dto.AuthResponse;
import in.the_semicolon_squad.trust_net.dto.LoginRequest;
import in.the_semicolon_squad.trust_net.dto.RegisterRequest;
import in.the_semicolon_squad.trust_net.enums.Role;
import in.the_semicolon_squad.trust_net.model.DonorProfile;
import in.the_semicolon_squad.trust_net.model.NgoProfile;
import in.the_semicolon_squad.trust_net.model.User;
import in.the_semicolon_squad.trust_net.repository.DonorProfileRepository;
import in.the_semicolon_squad.trust_net.repository.NgoProfileRepository;
import in.the_semicolon_squad.trust_net.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final NgoProfileRepository ngoProfileRepository;
    private final DonorProfileRepository donorProfileRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthResponse register(RegisterRequest request) {

        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email already registered");
        }

        User user = new User();
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(request.getRole());

        User savedUser = userRepository.save(user);

        if (request.getRole() == Role.NGO) {
            NgoProfile profile = new NgoProfile();
            profile.setUserId(savedUser.getId());
            profile.setName(request.getName());
            NgoProfile savedProfile = ngoProfileRepository.save(profile);
            savedUser.setProfileId(savedProfile.getId());
        } else if (request.getRole() == Role.DONOR) {
            DonorProfile profile = new DonorProfile();
            profile.setUserId(savedUser.getId());
            profile.setName(request.getName());
            DonorProfile savedProfile = donorProfileRepository.save(profile);
            savedUser.setProfileId(savedProfile.getId());
        }

        userRepository.save(savedUser);

        String token = jwtService.generateToken(savedUser);
        return new AuthResponse(token, savedUser.getId(), savedUser.getName(), savedUser.getRole());
    }

    public AuthResponse login(LoginRequest request) {

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid password");
        }

        String token = jwtService.generateToken(user);
        return new AuthResponse(token, user.getId(), user.getName(), user.getRole());
    }
}
