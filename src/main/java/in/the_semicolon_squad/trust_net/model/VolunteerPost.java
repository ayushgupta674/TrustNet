package in.the_semicolon_squad.trust_net.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@Document(collection = "volunteer_posts")
public class VolunteerPost {

    @Id
    private String id;

    private String ngoId;

    private String skillNeeded;

    private String description;

    private LocalDateTime date;

    private List<VolunteerApplication> applications = new ArrayList<>();
}