class CompanyAnalytics {
  const CompanyAnalytics({
    required this.totalRevenue,
    required this.avgRepairTime,
    required this.branchCount,
  });

  final double totalRevenue;
  final double avgRepairTime;
  final int branchCount;

  factory CompanyAnalytics.fromJson(Map<String, dynamic> json) {
    return CompanyAnalytics(
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0,
      avgRepairTime: (json['avg_repair_time'] as num?)?.toDouble() ?? 0,
      branchCount: (json['branch_count'] as num?)?.toInt() ?? 0,
    );
  }
}
