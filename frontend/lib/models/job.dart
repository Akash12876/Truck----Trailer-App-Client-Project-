enum JobStatus {
  pending('pending'),
  inProgress('in_progress'),
  paused('paused'),
  awaitingParts('awaiting_parts'),
  finished('finished'),
  transferred('transferred');

  const JobStatus(this.value);
  final String value;
}

class RepairJob {
  const RepairJob({
    required this.id,
    required this.vehicleId,
    required this.status,
    this.assignedToId,
    this.issueLog,
  });

  final int id;
  final int vehicleId;
  final int? assignedToId;
  final JobStatus status;
  final String? issueLog;

  factory RepairJob.fromJson(Map<String, dynamic> json) {
    return RepairJob(
      id: json['id'] as int,
      vehicleId: json['vehicle_id'] as int,
      assignedToId: json['assigned_to_id'] as int?,
      status: JobStatus.values.firstWhere(
        (status) => status.value == json['status'],
        orElse: () => JobStatus.pending,
      ),
      issueLog: json['issue_log'] as String?,
    );
  }
}
