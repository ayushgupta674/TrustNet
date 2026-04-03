package in.the_semicolon_squad.trust_net.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Data
@Document(collection = "donor_profiles")
public class DonorProfile {

    @Id
    private String id;

    private String userId;

    private String name;

    private List<String> followedNgoIds;

    private List<String> donationIds;

    private List<String> volunteerApplicationIds;
}
