import 'package:flutter/material.dart';

import '../models/company_analytics.dart';
import '../services/api_service.dart';
import '../widgets/section_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({required this.api, super.key});

  final ApiService api;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CompanyAnalytics?>(
      future: api.fetchAnalytics(),
      builder: (context, snapshot) {
        final analytics = snapshot.data;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SectionCard(
              title: 'Company Analytics',
              child: snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _MetricTile(
                          label: 'Revenue',
                          value: '\$${(analytics?.totalRevenue ?? 0).toStringAsFixed(2)}',
                          icon: Icons.payments,
                        ),
                        _MetricTile(
                          label: 'Avg repair time',
                          value: '${(analytics?.avgRepairTime ?? 0).toStringAsFixed(1)}h',
                          icon: Icons.timer,
                        ),
                        _MetricTile(
                          label: 'Branches',
                          value: '${analytics?.branchCount ?? 0}',
                          icon: Icons.business,
                        ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(height: 16),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
