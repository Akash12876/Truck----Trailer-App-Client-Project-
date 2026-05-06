import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class TechnicianDashboard extends StatefulWidget {
  const TechnicianDashboard({Key? key}) : super(key: key);

  @override
  State<TechnicianDashboard> createState() => _TechnicianDashboardState();
}

class _TechnicianDashboardState extends State<TechnicianDashboard> {
  late ApiService apiService;
  List<dynamic> assignedJobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    loadData();
  }

  void loadData() async {
    try {
      final jobs = await apiService.getPendingJobs();
      setState(() {
        assignedJobs = jobs;
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
        title: const Text('My Jobs'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : assignedJobs.isEmpty
              ? const Center(
                  child: Text('No jobs assigned'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: assignedJobs.length,
                  itemBuilder: (context, index) {
                    final job = assignedJobs[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ExpansionTile(
                        title: Text('Job #${job['id']}'),
                        subtitle: Text('Vehicle #${job['vehicle_id']}'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        apiService.updateJobStatus(
                                          job['id'],
                                          'in_progress',
                                        );
                                      },
                                      child: const Text('Start'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        apiService.updateJobStatus(
                                          job['id'],
                                          'paused',
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                      ),
                                      child: const Text('Pause'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        apiService.updateJobStatus(
                                          job['id'],
                                          'finished',
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: const Text('Finish'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
