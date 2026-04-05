// lib/core/services/upload_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/dio_client.dart';

class UploadService {
  final DioClient _dio = DioClient();

  /// Upload an image file to your backend.
  /// [endpoint] can be overridden (e.g., '/upload/document').
  Future<String> uploadImage(File image, {String endpoint = '/upload/image'}) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path),
    });
    final response = await _dio.post(endpoint, data: formData);
    return response.data['url'];
  }

  /// Upload a video file to your backend.
  /// [endpoint] can be overridden (e.g., '/upload/video').
// Inside UploadService class
  Future<String> uploadVideo(File video, {String endpoint = '/upload/video'}) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(video.path),
    });
    final response = await _dio.post(
      endpoint,  // use the endpoint parameter
      data: formData,
      options: Options(
        sendTimeout: const Duration(seconds: 300),    // 5 minutes
        receiveTimeout: const Duration(seconds: 300), // 5 minutes
      ),
    );
    return response.data['url'];
  }

  /// Pick an image from gallery.
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;
    return File(picked.path);
  }

  /// Pick a video from gallery.
  Future<File?> pickVideo() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked == null) return null;
    return File(picked.path);
  }
}