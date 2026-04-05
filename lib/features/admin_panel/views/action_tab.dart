// lib/features/admin_dashboard/views/actions_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_provider.dart';

import '../widgets/impact_verfication_card.dart';
import '../widgets/verification_card.dart';
import '../widgets/fraud_report_card.dart';


class ActionsTab extends ConsumerStatefulWidget {
  const ActionsTab({super.key});

  @override
  ConsumerState<ActionsTab> createState() => _ActionsTabState();
}

class _ActionsTabState extends ConsumerState<ActionsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialIndex = ref.read(adminActionsSubTabProvider);
    _tabController = TabController(length: 3, vsync: this, initialIndex: initialIndex);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        ref.read(adminActionsSubTabProvider.notifier).state = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Verifications'),
            Tab(text: 'Fraud Reports'),
            Tab(text: 'Impact Verify'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _VerificationsList(),
              _FraudReportsList(),
              _ImpactVerificationList(),
            ],
          ),
        ),
      ],
    );
  }
}

// The list widgets remain unchanged (they are already ConsumerWidget)
class _VerificationsList extends ConsumerWidget {
  const _VerificationsList();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingVerificationsProvider);
    return pendingAsync.when(
      data: (list) {
        if (list.isEmpty) {
          return const Center(child: Text('No pending verifications'));
        }
        return ListView.builder(itemCount: list.length, itemBuilder: (_, i) => VerificationCard(ngo: list[i]));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}
class _FraudReportsList extends ConsumerWidget {
  const _FraudReportsList();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(pendingFraudReportsProvider);
    return reportsAsync.when(
      data: (list) => ListView.builder(itemCount: list.length, itemBuilder: (_, i) => FraudReportCard(report: list[i])),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _ImpactVerificationList extends ConsumerWidget {
  const _ImpactVerificationList();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignsAsync = ref.watch(pendingImpactCampaignsProvider);
    return campaignsAsync.when(
      data: (list) => ListView.builder(itemCount: list.length, itemBuilder: (_, i) => ImpactVerificationCard(campaign: list[i])),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}