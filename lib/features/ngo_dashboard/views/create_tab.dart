// lib/features/ngo_dashboard/views/create_tab.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
// unified upload service
import '../../auth/data/services/cloudinary_service.dart';
import '../providers/ngo_dashboard_providers.dart';
import '../widgets/video_trimmer.dart';

class CreateTab extends ConsumerStatefulWidget {
  const CreateTab({super.key});

  @override
  ConsumerState<CreateTab> createState() => _CreateTabState();
}

class _CreateTabState extends ConsumerState<CreateTab> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final UploadService _uploadService = UploadService(); // backend uploader

  // Type selection: 'post' (image) or 'short' (video)
  String _selectedType = 'post';
  File? _imageFile;
  File? _videoFile;
  bool _isUploading = false;

  // Campaign fields (unchanged)
  final TextEditingController _campaignTitleController = TextEditingController();
  final TextEditingController _campaignDescController = TextEditingController();
  final TextEditingController _campaignGoalController = TextEditingController();
  DateTime _selectedDeadline = DateTime.now().add(const Duration(days: 30));
  String? _campaignImageUrl;
  bool _isUploadingCampaignImage = false;

  // Volunteer fields (unchanged)
  final TextEditingController _volunteerSkillController = TextEditingController();
  final TextEditingController _volunteerDescController = TextEditingController();
  DateTime _selectedVolunteerDate = DateTime.now().add(const Duration(days: 7));
  String? _volunteerImageUrl;
  bool _isUploadingVolunteerImage = false;

  @override
  void dispose() {
    _textController.dispose();
    _campaignTitleController.dispose();
    _campaignDescController.dispose();
    _campaignGoalController.dispose();
    _volunteerSkillController.dispose();
    _volunteerDescController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  void _handleVideoTrimmed(File? trimmedVideo, String? error) {
    setState(() {
      if (trimmedVideo != null) {
        _videoFile = trimmedVideo;
      } else if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      }
    });
  }

  Future<void> _publishContent() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter some text')));
      return;
    }

    setState(() => _isUploading = true);
    String? mediaUrl;

    try {
      if (_selectedType == 'post' && _imageFile != null) {
        // ✅ use uploadImage, not uploadFile
        mediaUrl = await _uploadService.uploadImage(_imageFile!);
      } else if (_selectedType == 'short' && _videoFile != null) {
        // ✅ use uploadVideo, not uploadFile
        mediaUrl = await _uploadService.uploadVideo(_videoFile!);
      }

      final data = {
        'text': _textController.text.trim(),
        'imageUrl': _selectedType == 'post' ? mediaUrl : null,
        'videoUrl': _selectedType == 'short' ? mediaUrl : null,
        'campaignId': null,
      };
      await ref.read(createPostProvider(data).future);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Published successfully!')));
        _textController.clear();
        setState(() {
          _imageFile = null;
          _videoFile = null;
        });
        ref.invalidate(ngoPostsProvider);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to publish: $e')));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Post / Short'),
              Tab(text: 'Campaign'),
              Tab(text: 'Volunteer'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPostShortTab(),
            _buildCampaignForm(),
            _buildVolunteerForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostShortTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'post', label: Text('Post'), icon: Icon(Icons.image)),
              ButtonSegment(value: 'short', label: Text('Short'), icon: Icon(Icons.video_library)),
            ],
            selected: {_selectedType},
            onSelectionChanged: (Set<String> selection) {
              setState(() => _selectedType = selection.first);
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _textController,
            decoration: const InputDecoration(labelText: 'What’s on your mind?', border: OutlineInputBorder()),
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          if (_selectedType == 'post')
            Column(
              children: [
                if (_imageFile == null)
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('Add Image'),
                  )
                else ...[
                  Image.file(_imageFile!, height: 200),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() => _imageFile = null),
                    child: const Text('Remove Image'),
                  ),
                ],
              ],
            ),
          if (_selectedType == 'short')
            VideoTrimmerView(onComplete: _handleVideoTrimmed),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isUploading ? null : _publishContent,
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: _isUploading ? const CircularProgressIndicator() : const Text('Publish'),
          ),
        ],
      ),
    );
  }

  // ==================== Campaign Form (unchanged) ====================
  Widget _buildCampaignForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(controller: _campaignTitleController, decoration: const InputDecoration(labelText: 'Campaign Title')),
          const SizedBox(height: 16),
          TextField(controller: _campaignDescController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
          const SizedBox(height: 16),
          TextField(controller: _campaignGoalController, decoration: const InputDecoration(labelText: 'Goal Amount (₹)'), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Deadline'),
            subtitle: Text('${_selectedDeadline.day}/${_selectedDeadline.month}/${_selectedDeadline.year}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDeadline,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) setState(() => _selectedDeadline = date);
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _createCampaign, child: const Text('Launch Campaign')),
        ],
      ),
    );
  }

  Future<void> _createCampaign() async {
    final goal = double.tryParse(_campaignGoalController.text.trim()) ?? 0;
    if (goal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid goal amount')));
      return;
    }
    final data = {
      'title': _campaignTitleController.text.trim(),
      'description': _campaignDescController.text.trim(),
      'goalAmount': goal,
      'deadline': _selectedDeadline.toIso8601String(),
      'imageUrl': _campaignImageUrl,
    };
    await ref.read(createCampaignProvider(data).future);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Campaign launched!')));
      _campaignTitleController.clear();
      _campaignDescController.clear();
      _campaignGoalController.clear();
      setState(() => _campaignImageUrl = null);
      ref.invalidate(ngoCampaignsProvider);
    }
  }

  // ==================== Volunteer Form (unchanged) ====================
  Widget _buildVolunteerForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(controller: _volunteerSkillController, decoration: const InputDecoration(labelText: 'Skill Needed')),
          const SizedBox(height: 16),
          TextField(controller: _volunteerDescController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Event Date'),
            subtitle: Text('${_selectedVolunteerDate.day}/${_selectedVolunteerDate.month}/${_selectedVolunteerDate.year}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedVolunteerDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 180)),
              );
              if (date != null) setState(() => _selectedVolunteerDate = date);
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _createVolunteerPost, child: const Text('Create Volunteer Post')),
        ],
      ),
    );
  }

  Future<void> _createVolunteerPost() async {
    final data = {
      'skillNeeded': _volunteerSkillController.text.trim(),
      'description': _volunteerDescController.text.trim(),
      'date': _selectedVolunteerDate.toIso8601String(),
      'imageUrl': _volunteerImageUrl,
    };
    await ref.read(createVolunteerPostProvider(data).future);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Volunteer post created!')));
      _volunteerSkillController.clear();
      _volunteerDescController.clear();
      setState(() => _volunteerImageUrl = null);
      ref.invalidate(ngoVolunteerPostsProvider);
    }
  }
}