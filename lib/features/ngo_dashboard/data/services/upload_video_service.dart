import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class VideoUploadService {
  final DioClient _dio = DioClient();

  Future<String> uploadVideo(File videoFile) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(videoFile.path),
    });
    final response = await _dio.post('/upload/video', data: formData);
    return response.data['url'];
  }
}