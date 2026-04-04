// lib/core/widgets/ngo_description_screen.dart
import 'package:flutter/material.dart';

class NgoDescriptionScreen extends StatelessWidget {
  final String ngoName;
  final String ngoDescription;

  const NgoDescriptionScreen({
    super.key,
    required this.ngoName,
    required this.ngoDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ngoName),
        backgroundColor: const Color(0xFF7C3AED),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.volunteer_activism, size: 60, color: Color(0xFF7C3AED)),
            const SizedBox(height: 20),
            Text(
              ngoName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'About',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              ngoDescription,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            // You can add more details like contact, website, etc.
          ],
        ),
      ),
    );
  }
}