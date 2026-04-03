package in.the_semicolon_squad.trust_net.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CampaignRequest {

    @NotBlank
    private String title;

    @NotBlank
    private String description;

    @NotNull
    private Double goalAmount;

    @NotNull
    private LocalDateTime deadline;
}