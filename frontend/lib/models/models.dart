class User {
  final int id;
  final String username;
  final String email;
  final String role;
  final bool isActive;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      isActive: json['is_active'],
    );
  }
}

class Vehicle {
  final int id;
  final String type;
  final String? registrationNumber;
  final String? chassisNumber;
  final String clientName;
  final DateTime intakeTime;

  Vehicle({
    required this.id,
    required this.type,
    this.registrationNumber,
    this.chassisNumber,
    required this.clientName,
    required this.intakeTime,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      type: json['type'],
      registrationNumber: json['registration_number'],
      chassisNumber: json['chassis_number'],
      clientName: json['client_name'],
      intakeTime: DateTime.parse(json['intake_time']),
    );
  }
}

class Job {
  final int id;
  final int vehicleId;
  final int? assignedToId;
  final String status;
  final DateTime createdAt;

  Job({
    required this.id,
    required this.vehicleId,
    this.assignedToId,
    required this.status,
    required this.createdAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      vehicleId: json['vehicle_id'],
      assignedToId: json['assigned_to_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
