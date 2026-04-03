package in.the_semicolon_squad.trust_net.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Data
@Document(collection = "fraud_reports")
public class FraudReport {

    @Id
    private String id;

    private String reporterId;

    private String ngoId;

    private String reason;

    private String status = "PENDING";

    private String adminAction;

    private LocalDateTime createdAt = LocalDateTime.now();
}