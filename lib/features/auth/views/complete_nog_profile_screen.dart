// lib/features/auth/views/complete_ngo_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../ngo_dashboard/views/ngo_dashboard_screen.dart';
import '../data/services/cloudinary_service.dart';
import '../providers/ngo_profile_provider.dart';

class CompleteNgoProfileScreen extends ConsumerStatefulWidget {
  const CompleteNgoProfileScreen({super.key});

  @override
  ConsumerState<CompleteNgoProfileScreen> createState() => _CompleteNgoProfileScreenState();
}

class _CompleteNgoProfileScreenState extends ConsumerState<CompleteNgoProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCause;
  String? _documentUrl;
  bool _isLoading = false;
  List<double> _location = [];

  final List<String> _causes = [
    'Education', 'Environment', 'Health', 'Women Empowerment',
    'Animal Welfare', 'Food & Hunger', 'Disaster Relief', 'Other'
  ];



  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  final UploadService _uploadService = UploadService();

  Future<void> _uploadDocument() async {
    final file = await _uploadService.pickImage();
    if (file == null) return;
    setState(() => _isLoading = true);
    try {
      final url = await _uploadService.uploadImage(file, endpoint: '/upload/document');
      setState(() => _documentUrl = url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document uploaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location services')),
        );
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      final position = await Geolocator.getCurrentPosition();
      setState(() => _location = [position.longitude, position.latitude]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getLocationFromCity(String city) async {
    setState(() => _isLoading = true);
    try {
      List<Location> locations = await locationFromAddress(city);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        setState(() => _location = [loc.longitude, loc.latitude]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('City not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Geocoding error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showCityInputDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enter City Name'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'e.g., New York')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _getLocationFromCity(controller.text.trim());
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCause == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a cause')));
      return;
    }
    if (_documentUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please upload registration document')));
      return;
    }
    if (_location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please set location')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(ngoProfileRepositoryProvider);
      await repo.updateProfile({
        'name': _nameController.text.trim(),
        'cause': _selectedCause,
        'description': _descriptionController.text.trim(),
        'registrationDocumentUrl': _documentUrl,
        'location': _location,
      });
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NgoDashboardScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete NGO Profile'), backgroundColor: const Color(0xFF7C3AED)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'NGO Name', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCause,
                decoration: const InputDecoration(labelText: 'Cause', border: OutlineInputBorder()),
                items: _causes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCause = v),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                maxLines: 4,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _uploadDocument,
                icon: const Icon(Icons.upload_file),
                label: Text(_documentUrl == null ? 'Upload Registration Document' : 'Document Uploaded'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _documentUrl == null ? const Color(0xFF7C3AED) : Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _getCurrentLocation,
                      icon: const Icon(Icons.gps_fixed),
                      label: const Text('Use Current Location'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _showCityInputDialog,
                      icon: const Icon(Icons.location_city),
                      label: const Text('Enter City'),
                    ),
                  ),
                ],
              ),
              if (_location.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Location set: ${_location[1]}, ${_location[0]}'),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: _isLoading ? const CircularProgressIndicator() : const Text('Complete Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}