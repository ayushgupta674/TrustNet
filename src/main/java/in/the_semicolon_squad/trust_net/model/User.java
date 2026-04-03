package in.the_semicolon_squad.trust_net.model;


import in.the_semicolon_squad.trust_net.enums.Role;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "users")
public class User {

    @Id
    private String id;

    private String name;

    @Indexed(unique = true)
    private String email;
    private String password;
    private Role role;
    private String profileId;
}
