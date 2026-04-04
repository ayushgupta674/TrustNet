package in.the_semicolon_squad.trust_net.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class NgoProfileUpdateRequest {

    @NotBlank
    private String name;

    @NotBlank
    private String description;

    @NotBlank
    private String cause;

    private String registrationDocumentUrl;

    // [longitude, latitude] — MongoDB GeoJSON order
    private double[] location;
}