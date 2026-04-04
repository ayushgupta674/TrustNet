import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ngo_dashboard_providers.dart';

class CreateTab extends ConsumerStatefulWidget {
  const CreateTab({super.key});

  @override
  ConsumerState<CreateTab> createState() => _CreateTabState();
}

class _CreateTabState extends ConsumerState<CreateTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Post fields
  final _postTextController = TextEditingController();
  final _postImageUrlController = TextEditingController();

  // Campaign fields
  final _campaignTitleController = TextEditingController();
  final _campaignDescController = TextEditingController();
  final _campaignGoalController = TextEditingController();
  DateTime _selectedDeadline = DateTime.now().add(const Duration(days: 30));

  // Volunteer post fields
  final _volunteerSkillController = TextEditingController();
  final _volunteerDescController = TextEditingController();
  DateTime _selectedVolunteerDate = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _postTextController.dispose();
    _postImageUrlController.dispose();
    _campaignTitleController.dispose();
    _campaignDescController.dispose();
    _campaignGoalController.dispose();
    _volunteerSkillController.dispose();
    _volunteerDescController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    final data = {
      'text': _postTextController.text.trim(),
      'imageUrl': _postImageUrlController.text.isNotEmpty
          ? _postImageUrlController.text.trim()
          : null,
      'videoUrl': null,
      'campaignId': null,
    };
    await ref.read(createPostProvider(data).future);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Post created!')));
      _postTextController.clear();
      _postImageUrlController.clear();
      ref.invalidate(ngoPostsProvider);
    }
  }

  Future<void> _createCampaign() async {
    final goal = double.tryParse(_campaignGoalController.text.trim()) ?? 0;
    final data = {
      'title': _campaignTitleController.text.trim(),
      'description': _campaignDescController.text.trim(),
      'goalAmount': goal,
      'deadline': _selectedDeadline.toIso8601String(),
    };
    await ref.read(createCampaignProvider(data).future);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Campaign launched!')));
      _campaignTitleController.clear();
      _campaignDescController.clear();
      _campaignGoalController.clear();
      ref.invalidate(ngoCampaignsProvider);
    }
  }

  Future<void> _createVolunteerPost() async {
    final data = {
      'skillNeeded': _volunteerSkillController.text.trim(),
      'description': _volunteerDescController.text.trim(),
      'date': _selectedVolunteerDate.toIso8601String(),
    };
    await ref.read(createVolunteerPostProvider(data).future);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Volunteer post created!')));
      _volunteerSkillController.clear();
      _volunteerDescController.clear();
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
    return Padding(
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
          TextField(
            controller: _postImageUrlController,
            decoration: const InputDecoration(
              labelText: 'Image URL (optional)',
              border: OutlineInputBorder(),
            ),
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          TextField(
            controller: _campaignTitleController,
            decoration: const InputDecoration(
              labelText: 'Campaign Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _campaignDescController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _campaignGoalController,
            decoration: const InputDecoration(
              labelText: 'Goal Amount (₹)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Deadline'),
            subtitle: Text(
                '${_selectedDeadline.day}/${_selectedDeadline.month}/${_selectedDeadline.year}'),
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
          ElevatedButton(
            onPressed: _createCampaign,
            child: const Text('Launch Campaign'),
          ),
        ],
      ),
    );
  }

  Widget _buildVolunteerForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          TextField(
            controller: _volunteerSkillController,
            decoration: const InputDecoration(
              labelText: 'Skill Needed',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _volunteerDescController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Event Date'),
            subtitle: Text(
                '${_selectedVolunteerDate.day}/${_selectedVolunteerDate.month}/${_selectedVolunteerDate.year}'),
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
          ElevatedButton(
            onPressed: _createVolunteerPost,
            child: const Text('Create Volunteer Post'),
          ),
        ],
      ),
    );
  }
}