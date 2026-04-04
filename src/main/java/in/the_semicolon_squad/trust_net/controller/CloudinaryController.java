package in.the_semicolon_squad.trust_net.controller;

import in.the_semicolon_squad.trust_net.service.CloudinaryService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@RestController
@RequestMapping("/upload")
public class CloudinaryController {

    private final CloudinaryService cloudinaryService;

    public CloudinaryController(CloudinaryService cloudinaryService) {
        this.cloudinaryService = cloudinaryService;
    }

    @PostMapping("/image")
    public ResponseEntity<?> uploadImage(@RequestParam("file") MultipartFile file) throws IOException {
        String url = cloudinaryService.uploadImage(file);
        return ResponseEntity.ok(Map.of("url", url));
    }

    @PostMapping("/video")
    public ResponseEntity<?> uploadVideo(@RequestParam("file") MultipartFile file) throws IOException {
        String url = cloudinaryService.uploadVideo(file);
        return ResponseEntity.ok(Map.of("url", url));
    }

    @PostMapping("/document")
    public ResponseEntity<?> uploadDocument(@RequestParam("file") MultipartFile file) throws IOException {
        String url = cloudinaryService.uploadDocument(file);
        return ResponseEntity.ok(Map.of("url", url));
    }
}