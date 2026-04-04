package in.the_semicolon_squad.trust_net.model;

import in.the_semicolon_squad.trust_net.enums.NotificationType;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Data
@Document(collection = "notifications")
public class Notification {

    @Id
    private String id;

    private String userId;

    private NotificationType type;

    private String message;

    private boolean read = false;

    private LocalDateTime createdAt = LocalDateTime.now();
}