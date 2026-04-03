package in.the_semicolon_squad.trust_net.controller;

import in.the_semicolon_squad.trust_net.model.Notification;
import in.the_semicolon_squad.trust_net.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @GetMapping
    public ResponseEntity<List<Notification>> getUnread(
            @RequestHeader("X-User-Id") String userId) {
        return ResponseEntity.ok(notificationService.getUnreadNotifications(userId));
    }

    @GetMapping("/all")
    public ResponseEntity<List<Notification>> getAll(
            @RequestHeader("X-User-Id") String userId) {
        return ResponseEntity.ok(notificationService.getAllNotifications(userId));
    }

    @GetMapping("/count")
    public ResponseEntity<Map<String, Long>> getUnreadCount(
            @RequestHeader("X-User-Id") String userId) {
        long count = notificationService.getUnreadCount(userId);
        return ResponseEntity.ok(Map.of("unreadCount", count));
    }

    @PutMapping("/read")
    public ResponseEntity<Void> markAllRead(
            @RequestHeader("X-User-Id") String userId) {
        notificationService.markAllRead(userId);
        return ResponseEntity.ok().build();
    }
}