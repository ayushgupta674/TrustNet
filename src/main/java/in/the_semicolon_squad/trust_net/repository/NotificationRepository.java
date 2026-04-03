package in.the_semicolon_squad.trust_net.repository;

import in.the_semicolon_squad.trust_net.model.Notification;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface NotificationRepository extends MongoRepository<Notification, String> {
    List<Notification> findByUserIdAndReadFalse(String userId);
    List<Notification> findByUserId(String userId);
    long countByUserIdAndReadFalse(String userId);
}