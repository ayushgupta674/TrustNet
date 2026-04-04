package in.the_semicolon_squad.trust_net.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Data
@Document(collection = "campaigns")
public class Campaign {

    @Id
    private String id;

    private String ngoId;

    private String title;

    private String description;

    private double goalAmount;

    private double raisedAmount = 0.0;

    private LocalDateTime deadline;

    private boolean active = true;

    private boolean impactVerified = false;

    private String impactProofUrl;

    private String outcomeUpdate;

    private LocalDateTime createdAt = LocalDateTime.now();
}