package in.the_semicolon_squad.trust_net.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Data
@Document(collection = "posts")
public class Post {

    @Id
    private String id;

    private String ngoId;

    private String text;

    private String imageUrl;

    private String videoUrl;

    private String campaignId;

    private LocalDateTime createdAt = LocalDateTime.now();
}