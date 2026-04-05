// lib/features/explore/views/explore_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/nog_model.dart';
import '../providers/explore_provider.dart';
import '../widgets/explore_search_bar.dart';
import '../widgets/nearby_ngo_button.dart';
import '../widgets/ngo_card.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  // Fixed demo location – replace with actual GPS later
  final double _userLat = 28.6139;
  final double _userLng = 77.2090;
  final double _radiusKm = 10000.0;

  void _fetchNearby() {
    ref.refresh(nearbyNgosProvider((lat: _userLat, lng: _userLng, radius: _radiusKm)));
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResultsAsync = ref.watch(searchResultsProvider(searchQuery));
    final nearbyAsync = ref.watch(nearbyNgosProvider((lat: _userLat, lng: _userLng, radius: _radiusKm)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore NGOs'),
        backgroundColor: const Color(0xFF7C3AED),
      ),
      body: Column(
        children: [
          ExploreSearchBar(),
          NearbyNgoButton(onTap: _fetchNearby),
          Expanded(
            child: searchQuery.isEmpty
                ? _buildNearbyList(nearbyAsync)
                : _buildSearchResults(searchResultsAsync),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyList(AsyncValue<List<NgoModel>> async) {
    return async.when(
      data: (ngos) {
        if (ngos.isEmpty) {
          return const Center(child: Text('No NGOs found nearby.'));
        }
        return ListView.builder(
          itemCount: ngos.length,
          itemBuilder: (context, index) => NgoCard(
            ngo: ngos[index],
            onTap: () => _showNgoDetails(ngos[index]),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildSearchResults(AsyncValue<List<NgoModel>> async) {
    return async.when(
      data: (ngos) {
        if (ngos.isEmpty) {
          return const Center(child: Text('No NGOs match your search.'));
        }
        return ListView.builder(
          itemCount: ngos.length,
          itemBuilder: (context, index) => NgoCard(
            ngo: ngos[index],
            onTap: () => _showNgoDetails(ngos[index]),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  void _showNgoDetails(NgoModel ngo) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(ngo.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                if (ngo.isVerified) const Icon(Icons.verified, color: Colors.blueAccent),
              ],
            ),
            const SizedBox(height: 8),
            Text(ngo.cause, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 12),
            Text(ngo.description),
            const SizedBox(height: 20),
            if (ngo.distance != null)
              Text('📍 ${ngo.distance!.toStringAsFixed(1)} km away'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}