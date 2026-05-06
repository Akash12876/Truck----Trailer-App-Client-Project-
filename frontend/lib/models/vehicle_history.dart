class VehicleHistory {
  const VehicleHistory({
    required this.id,
    required this.vehicleId,
    required this.jobId,
    required this.action,
    required this.performedById,
  });

  final int id;
  final int vehicleId;
  final int jobId;
  final String action;
  final int performedById;

  factory VehicleHistory.fromJson(Map<String, dynamic> json) {
    return VehicleHistory(
      id: json['id'] as int,
      vehicleId: json['vehicle_id'] as int,
      jobId: json['job_id'] as int,
      action: json['action'] as String,
      performedById: json['performed_by_id'] as int,
    );
  }
}
