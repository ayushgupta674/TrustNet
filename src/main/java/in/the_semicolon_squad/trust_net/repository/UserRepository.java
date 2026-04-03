package in.the_semicolon_squad.trust_net.repository;

import in.the_semicolon_squad.trust_net.enums.Role;
import in.the_semicolon_squad.trust_net.model.User;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface UserRepository extends MongoRepository<User, String> {
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);

    long countByRole(Role role);
}
