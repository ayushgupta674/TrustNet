import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_video_editor/easy_video_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoTrimmerView extends StatefulWidget {
  final Function(File? trimmedVideo, String? error) onComplete;
  const VideoTrimmerView({super.key, required this.onComplete});

  @override
  State<VideoTrimmerView> createState() => _VideoTrimmerViewState();
}

class _VideoTrimmerViewState extends State<VideoTrimmerView> {
  final ImagePicker _picker = ImagePicker();
  File? _originalVideo;
  VideoPlayerController? _controller;
  bool _isProcessing = false;
  final int maxDurationMs = 60000; // 60 seconds

  Future<void> _pickVideo() async {
    final XFile? picked = await _picker.pickVideo(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() {
      _originalVideo = File(picked.path);
      _controller?.dispose();
      _controller = VideoPlayerController.file(File(picked.path))
        ..initialize().then((_) {
          setState(() {});
          _showTrimmer();
        });
    });
  }

  void _showTrimmer() async {
    if (_originalVideo == null) return;
    final String outputDir = (await getTemporaryDirectory()).path;
    final String outputPath = '$outputDir/trimmed_video_${DateTime.now().millisecondsSinceEpoch}.mp4';

    setState(() => _isProcessing = true);
    try {
      // Use the native trimmer to cut the video
      final editor = VideoEditorBuilder(videoPath: _originalVideo!.path)
          .trim(startTimeMs: 0, endTimeMs: maxDurationMs);
      final String? trimmedPath = await editor.export(outputPath: outputPath);
      widget.onComplete(File(trimmedPath!), null);
    } catch (e) {
      widget.onComplete(null, e.toString());
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_originalVideo == null)
          ElevatedButton.icon(
            onPressed: _pickVideo,
            icon: const Icon(Icons.video_library),
            label: const Text('Select Video'),
          )
        else if (_controller != null && _controller!.value.isInitialized)
          SizedBox(
            height: 200,
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          ),
        const SizedBox(height: 12),
        if (_isProcessing)
          const LinearProgressIndicator(),
        if (_originalVideo != null && !_isProcessing)
          Text('✓ Video will be trimmed to ${maxDurationMs ~/ 1000} seconds'),
        const SizedBox(height: 12),
      ],
    );
  }
}