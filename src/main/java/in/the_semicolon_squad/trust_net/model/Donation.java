package in.the_semicolon_squad.trust_net.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Data
@Document(collection = "donations")
public class Donation {

    @Id
    private String id;

    private String donorId;

    private String ngoId;

    private String campaignId;

    private double amount;

    private String razorpayOrderId;

    private String razorpayPaymentId;

    private boolean verified = false;

    private LocalDateTime createdAt = LocalDateTime.now();
}