package in.the_semicolon_squad.trust_net.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.config.EnableMongoAuditing;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

@Configuration
@EnableMongoRepositories(basePackages = "in.the_semicolon_squad.trust_net.repository")
@EnableMongoAuditing
public class MongoConfig {
}