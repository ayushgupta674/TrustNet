package in.the_semicolon_squad.trust_net.model;


import in.the_semicolon_squad.trust_net.enums.VerificationStatus;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.GeoSpatialIndexType;
import org.springframework.data.mongodb.core.index.GeoSpatialIndexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Data
@Document(collection = "ngo_profiles")
public class NgoProfile {

    @Id
    private String id;

    private String userId;

    private String name;

    private String description;

    private String cause;

    private String registrationDocumentUrl;

    private VerificationStatus verificationStatus = VerificationStatus.PENDING;

    private boolean verifiedBadge = false;

    private String rejectionReason;

    private List<String> followerIds;

    @GeoSpatialIndexed(type = GeoSpatialIndexType.GEO_2DSPHERE)
    private double[] location;
}