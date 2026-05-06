import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late ApiService apiService;
  List<dynamic> pendingVehicles = [];
  List<dynamic> pendingJobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    loadData();
  }

  void loadData() async {
    try {
      final vehicles = await apiService.getPendingVehicles();
      final jobs = await apiService.getPendingJobs();
      setState(() {
        pendingVehicles = vehicles;
        pendingJobs = jobs;
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
        title: const Text('Admin Dashboard'),
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
                    'Pending Vehicles',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pendingVehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = pendingVehicles[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(vehicle['client_name'] ?? 'Unknown'),
                          subtitle: Text(
                            'Type: ${vehicle['type']} | Reg: ${vehicle['registration_number'] ?? 'N/A'}',
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Assign job
                            },
                            child: const Text('Assign'),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Pending Jobs',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pendingJobs.length,
                    itemBuilder: (context, index) {
                      final job = pendingJobs[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text('Job #${job['id']}'),
                          subtitle: Text('Vehicle #${job['vehicle_id']}'),
                          trailing: Chip(
                            label: Text(job['status'] ?? 'pending'),
                            backgroundColor: Colors.orange.shade100,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
