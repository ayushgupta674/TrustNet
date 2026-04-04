package in.the_semicolon_squad.trust_net.model;

import lombok.Data;

@Data
public class VolunteerApplication {

    private String applicantId;

    private String status = "PENDING";

    private java.time.LocalDateTime appliedAt = java.time.LocalDateTime.now();
}