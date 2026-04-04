package in.the_semicolon_squad.trust_net.repository;

import in.the_semicolon_squad.trust_net.model.FraudReport;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface FraudReportRepository extends MongoRepository<FraudReport, String> {
    List<FraudReport> findByStatus(String status);
    List<FraudReport> findByNgoId(String ngoId);
}