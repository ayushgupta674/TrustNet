package in.the_semicolon_squad.trust_net.service;

import in.the_semicolon_squad.trust_net.dto.NgoProfileUpdateRequest;
import in.the_semicolon_squad.trust_net.model.NgoProfile;
import in.the_semicolon_squad.trust_net.repository.NgoProfileRepository;
import lombok.RequiredArgsConstructor;
import org.bson.Document;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
public class NgoService {

    private final NgoProfileRepository ngoProfileRepository;
    private final MongoTemplate mongoTemplate;

    public NgoProfile updateProfile(String userId, NgoProfileUpdateRequest request) {
        NgoProfile profile = ngoProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("NGO profile not found"));

        profile.setName(request.getName());
        profile.setDescription(request.getDescription());
        profile.setCause(request.getCause());
        profile.setRegistrationDocumentUrl(request.getRegistrationDocumentUrl());

        if (request.getLocation() != null) {
            profile.setLocation(request.getLocation());
        }

        return ngoProfileRepository.save(profile);
    }

    public NgoProfile getProfileByUserId(String userId) {
        return ngoProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("NGO profile not found"));
    }

    public NgoProfile getProfileById(String id) {
        return ngoProfileRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("NGO profile not found"));
    }

    public List<NgoProfile> searchNgos(String query) {
        Document searchStage = new Document("$search", new Document()
                .append("index", "ngo_search")
                .append("text", new Document()
                        .append("query", query)
                        .append("path", Arrays.asList("name", "cause", "description"))
                )
        );

        Document matchStage = new Document("$match",
                new Document("verifiedBadge", true)
        );

        List<Document> pipeline = Arrays.asList(searchStage, matchStage);

        return mongoTemplate.getCollection("ngo_profiles")
                .aggregate(pipeline, Document.class)
                .into(new java.util.ArrayList<>())
                .stream()
                .map(doc -> mongoTemplate.getConverter().read(NgoProfile.class, doc))
                .toList();
    }

    public List<NgoProfile> findNearbyNgos(double longitude, double latitude, double radiusKm) {
        Query query = new Query();
        query.addCriteria(Criteria.where("location").nearSphere(
                new org.springframework.data.geo.Point(longitude, latitude)
        ).maxDistance(radiusKm / 6371.0));

        return mongoTemplate.find(query, NgoProfile.class);
    }
}