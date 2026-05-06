import 'package:flutter/material.dart';

import '../models/system_log.dart';
import '../models/vehicle_history.dart';
import '../services/api_service.dart';
import '../widgets/section_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({required this.api, super.key});

  final ApiService api;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _vehicleId = TextEditingController();
  Future<List<VehicleHistory>>? _history;
  late Future<List<SystemLog>> _logs;

  @override
  void initState() {
    super.initState();
    _logs = widget.api.fetchLogs();
  }

  @override
  void dispose() {
    _vehicleId.dispose();
    super.dispose();
  }

  void _search() {
    setState(() {
      _history = widget.api.fetchVehicleHistory(int.parse(_vehicleId.text));
      _logs = widget.api.fetchLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionCard(
          title: 'Vehicle History',
          action: IconButton(
            tooltip: 'Search',
            onPressed: _search,
            icon: const Icon(Icons.search),
          ),
          child: Column(
            children: [
              TextField(
                controller: _vehicleId,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Vehicle ID'),
                onSubmitted: (_) => _search(),
              ),
              const SizedBox(height: 12),
              if (_history != null)
                FutureBuilder<List<VehicleHistory>>(
                  future: _history,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    final history = snapshot.data!;
                    if (history.isEmpty) return const Text('No history found.');
                    return Column(
                      children: history
                          .map(
                            (item) => ListTile(
                              title: Text(item.action),
                              subtitle: Text('Job #${item.jobId} by user #${item.performedById}'),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'System Logs',
          child: FutureBuilder<List<SystemLog>>(
            future: _logs,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final logs = snapshot.data!;
              if (logs.isEmpty) return const Text('No system logs yet.');
              return Column(
                children: logs
                    .map(
                      (log) => ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text(log.action),
                        subtitle: Text(log.details ?? 'User #${log.userId ?? '-'}'),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
