package in.the_semicolon_squad.trust_net.service;

import in.the_semicolon_squad.trust_net.enums.NotificationType;
import in.the_semicolon_squad.trust_net.model.VolunteerApplication;
import in.the_semicolon_squad.trust_net.model.VolunteerPost;
import in.the_semicolon_squad.trust_net.repository.VolunteerPostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class VolunteerService {

    private final VolunteerPostRepository volunteerPostRepository;
    private final NotificationService notificationService;

    public VolunteerPost createVolunteerPost(VolunteerPost post) {
        return volunteerPostRepository.save(post);
    }

    public List<VolunteerPost> getVolunteerPostsByNgo(String ngoId) {
        return volunteerPostRepository.findByNgoId(ngoId);
    }

    public VolunteerPost applyToVolunteer(String postId, String applicantId) {
        VolunteerPost post = volunteerPostRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Volunteer post not found"));

        boolean alreadyApplied = post.getApplications().stream()
                .anyMatch(a -> a.getApplicantId().equals(applicantId));

        if (alreadyApplied) {
            throw new RuntimeException("Already applied to this volunteer post");
        }

        VolunteerApplication application = new VolunteerApplication();
        application.setApplicantId(applicantId);

        post.getApplications().add(application);
        return volunteerPostRepository.save(post);
    }

    public VolunteerPost acceptApplication(String postId, String applicantId) {
        VolunteerPost post = volunteerPostRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Volunteer post not found"));

        post.getApplications().stream()
                .filter(a -> a.getApplicantId().equals(applicantId))
                .findFirst()
                .ifPresent(a -> a.setStatus("ACCEPTED"));

        volunteerPostRepository.save(post);

        notificationService.sendNotification(
                applicantId,
                NotificationType.VOLUNTEER_ACCEPTED,
                "Your volunteer application has been accepted!"
        );

        return post;
    }

    public VolunteerPost rejectApplication(String postId, String applicantId) {
        VolunteerPost post = volunteerPostRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Volunteer post not found"));

        post.getApplications().stream()
                .filter(a -> a.getApplicantId().equals(applicantId))
                .findFirst()
                .ifPresent(a -> a.setStatus("REJECTED"));

        return volunteerPostRepository.save(post);
    }
}