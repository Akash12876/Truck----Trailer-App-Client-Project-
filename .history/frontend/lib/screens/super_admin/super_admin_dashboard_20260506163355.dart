import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class SuperAdminDashboard extends StatefulWidget {
  const SuperAdminDashboard({Key? key}) : super(key: key);

  @override
  State<SuperAdminDashboard> createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  late ApiService apiService;
  Map<String, dynamic>? analyticsData;
  List<dynamic> systemLogs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    loadData();
  }

  void loadData() async {
    try {
      final analytics = await apiService.getCompanyAnalytics();
      final logs = await apiService.getSystemLogs();
      setState(() {
        analyticsData = analytics;
        systemLogs = logs;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin Dashboard'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analytics Overview',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildAnalyticsCard(
                        'Total Revenue',
                        '\$${analyticsData?['total_revenue'] ?? 0}',
                        Icons.trending_up,
                        Colors.green,
                      ),
                      _buildAnalyticsCard(
                        'Avg Repair Time',
                        '${analyticsData?['avg_repair_time'] ?? 0}h',
                        Icons.schedule,
                        Colors.blue,
                      ),
                      _buildAnalyticsCard(
                        'Branches',
                        '${analyticsData?['branch_count'] ?? 0}',
                        Icons.location_city,
                        Colors.orange,
                      ),
                      _buildAnalyticsCard(
                        'Active Jobs',
                        '12',
                        Icons.build,
                        Colors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'System Logs',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: systemLogs.length.clamp(0, 5),
                    itemBuilder: (context, index) {
                      final log = systemLogs[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(log['action'] ?? 'Unknown Action'),
                          subtitle: Text(
                            log['details'] ?? 'No details',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.info),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
