class SystemLog {
  const SystemLog({
    required this.id,
    required this.action,
    this.userId,
    this.details,
  });

  final int id;
  final String action;
  final int? userId;
  final String? details;

  factory SystemLog.fromJson(Map<String, dynamic> json) {
    return SystemLog(
      id: json['id'] as int,
      action: json['action'] as String,
      userId: json['user_id'] as int?,
      details: json['details'] as String?,
    );
  }
}
