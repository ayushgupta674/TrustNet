// lib/features/ngo_dashboard/views/create_tab.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/ngo_dashboard_providers.dart';
import '../../auth/data/services/cloudinary_service.dart';

class CreateTab extends ConsumerStatefulWidget {
  const CreateTab({super.key});

  @override
  ConsumerState<CreateTab> createState() => _CreateTabState();
}

class _CreateTabState extends ConsumerState<CreateTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Post fields
  final _postTextController = TextEditingController();
  String? _postImageUrl;
  bool _isUploadingImage = false;

  // Campaign fields
  final _campaignTitleController = TextEditingController();
  final _campaignDescController = TextEditingController();
  final _campaignGoalController = TextEditingController();
  DateTime _selectedDeadline = DateTime.now().add(const Duration(days: 30));
  String? _campaignImageUrl;
  bool _isUploadingCampaignImage = false;

  // Volunteer post fields
  final _volunteerSkillController = TextEditingController();
  final _volunteerDescController = TextEditingController();
  DateTime _selectedVolunteerDate = DateTime.now().add(const Duration(days: 7));
  String? _volunteerImageUrl;
  bool _isUploadingVolunteerImage = false;

  var _dio = Dio();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _postTextController.dispose();
    _campaignTitleController.dispose();
    _campaignDescController.dispose();
    _campaignGoalController.dispose();
    _volunteerSkillController.dispose();
    _volunteerDescController.dispose();
    super.dispose();
  }
  Future<void> _pickAndUploadImage(Function(String?) setImageUrl, Function(bool) setUploading) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setUploading(true);
    try {
      // Send file to your backend (assumes POST /upload)
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(pickedFile.path),
      });
      final response = await _dio.post('/uploadVerification', data: formData);
      final url = response.data['url'];
      setImageUrl(url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      setUploading(false);
    }
  }
  Future<void> _createPost() async {
    if (_postTextController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter post text')));
      return;
    }
    final data = {
      'text': _postTextController.text.trim(),
      'imageUrl': _postImageUrl,
      'videoUrl': null,
      'campaignId': null,
    };
    await ref.read(createPostProvider(data).future);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post created!')));
      _postTextController.clear();
      setState(() => _postImageUrl = null);
      ref.invalidate(ngoPostsProvider);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Post'),
            Tab(text: 'Campaign'),
            Tab(text: 'Volunteer'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPostForm(),
          _buildCampaignForm(),
          _buildVolunteerForm(),
        ],
      ),
    );
  }

  Widget _buildPostForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _postTextController,
            decoration: const InputDecoration(
              labelText: 'Post Text',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          _buildImagePickerSection(
            imageUrl: _postImageUrl,
            isUploading: _isUploadingImage,
            onPick: () => _pickAndUploadImage(
                  (url) => setState(() => _postImageUrl = url),
                  (loading) => setState(() => _isUploadingImage = loading),
            ),
            onRemove: () => setState(() => _postImageUrl = null),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _createPost,
            child: const Text('Publish Post'),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _campaignTitleController,
            decoration: const InputDecoration(labelText: 'Campaign Title', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _campaignDescController,
            decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _campaignGoalController,
            decoration: const InputDecoration(labelText: 'Goal Amount (₹)', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
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
          const SizedBox(height: 16),
          _buildImagePickerSection(
            imageUrl: _campaignImageUrl,
            isUploading: _isUploadingCampaignImage,
            onPick: () => _pickAndUploadImage(
                  (url) => setState(() => _campaignImageUrl = url),
                  (loading) => setState(() => _isUploadingCampaignImage = loading),
            ),
            onRemove: () => setState(() => _campaignImageUrl = null),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _createCampaign,
            child: const Text('Launch Campaign'),
          ),
        ],
      ),
    );
  }

  Widget _buildVolunteerForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _volunteerSkillController,
            decoration: const InputDecoration(labelText: 'Skill Needed', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _volunteerDescController,
            decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            maxLines: 3,
          ),
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
          const SizedBox(height: 16),
          _buildImagePickerSection(
            imageUrl: _volunteerImageUrl,
            isUploading: _isUploadingVolunteerImage,
            onPick: () => _pickAndUploadImage(
                  (url) => setState(() => _volunteerImageUrl = url),
                  (loading) => setState(() => _isUploadingVolunteerImage = loading),
            ),
            onRemove: () => setState(() => _volunteerImageUrl = null),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _createVolunteerPost,
            child: const Text('Create Volunteer Post'),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerSection({
    required String? imageUrl,
    required bool isUploading,
    required VoidCallback onPick,
    required VoidCallback onRemove,
  }) {
    return Column(
      children: [
        if (imageUrl != null)
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 80),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove Image'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          )
        else if (isUploading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          )
        else
          ElevatedButton.icon(
            onPressed: onPick,
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Add Image'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.black87,
            ),
          ),
      ],
    );
  }
}