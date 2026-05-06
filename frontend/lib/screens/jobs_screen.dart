import 'package:flutter/material.dart';

import '../models/job.dart';
import '../services/api_service.dart';
import '../widgets/section_card.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({required this.api, super.key});

  final ApiService api;

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final _vehicleId = TextEditingController();
  final _technicianId = TextEditingController();
  final _issue = TextEditingController();
  late Future<List<RepairJob>> _jobs;

  @override
  void initState() {
    super.initState();
    _jobs = widget.api.fetchPendingJobs();
  }

  @override
  void dispose() {
    _vehicleId.dispose();
    _technicianId.dispose();
    _issue.dispose();
    super.dispose();
  }

  Future<void> _assign() async {
    await widget.api.assignJob(
      vehicleId: int.parse(_vehicleId.text),
      assignedToId: _technicianId.text.trim().isEmpty ? null : int.parse(_technicianId.text),
      issueLog: _issue.text.trim(),
    );
    _vehicleId.clear();
    _technicianId.clear();
    _issue.clear();
    setState(() => _jobs = widget.api.fetchPendingJobs());
  }

  Future<void> _setStatus(RepairJob job, JobStatus status) async {
    await widget.api.updateJobStatus(job.id, status);
    setState(() => _jobs = widget.api.fetchPendingJobs());
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionCard(
          title: 'Assign Job',
          child: Column(
            children: [
              TextField(
                controller: _vehicleId,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Vehicle ID'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _technicianId,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Technician user ID'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _issue,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Issue log'),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: _assign,
                  icon: const Icon(Icons.assignment_ind),
                  label: const Text('Assign'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Pending Jobs',
          child: FutureBuilder<List<RepairJob>>(
            future: _jobs,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final jobs = snapshot.data!;
              if (jobs.isEmpty) return const Text('No pending jobs.');
              return Column(
                children: jobs
                    .map(
                      (job) => ListTile(
                        title: Text('Job #${job.id} - Vehicle #${job.vehicleId}'),
                        subtitle: Text(job.issueLog ?? job.status.value),
                        trailing: PopupMenuButton<JobStatus>(
                          onSelected: (status) => _setStatus(job, status),
                          itemBuilder: (context) => JobStatus.values
                              .map(
                                (status) => PopupMenuItem(
                                  value: status,
                                  child: Text(status.value),
                                ),
                              )
                              .toList(),
                        ),
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
