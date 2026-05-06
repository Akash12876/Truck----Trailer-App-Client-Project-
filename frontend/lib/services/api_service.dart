import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/company_analytics.dart';
import '../models/job.dart';
import '../models/system_log.dart';
import '../models/vehicle.dart';
import '../models/vehicle_history.dart';

class ApiService {
  ApiService({String? baseUrl}) : baseUrl = baseUrl ?? 'http://127.0.0.1:8000';

  final String baseUrl;
  String? token;

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> login(String username, String password) async {
    final data = await _post('/auth/login', {
      'username': username,
      'password': password,
    });
    token = data['access_token'] as String?;
  }

  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    await _post('/auth/signup', {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    });
  }

  Future<void> admitVehicle(Map<String, dynamic> payload) async {
    await _post('/inventory/intake', payload);
  }

  Future<List<Vehicle>> fetchVehicles() async {
    final data = await _getList('/inventory/pending');
    return data.map((item) => Vehicle.fromJson(item)).toList();
  }

  Future<void> assignJob({
    required int vehicleId,
    required int? assignedToId,
    String? issueLog,
  }) async {
    await _post('/jobs/assign', {
      'vehicle_id': vehicleId,
      'assigned_to_id': assignedToId,
      'issue_log': issueLog,
    });
  }

  Future<List<RepairJob>> fetchPendingJobs() async {
    final data = await _getList('/jobs/pending');
    return data.map((item) => RepairJob.fromJson(item)).toList();
  }

  Future<void> updateJobStatus(int jobId, JobStatus status) async {
    await _post('/jobs/update_status', {
      'job_id': jobId,
      'status': status.value,
    });
  }

  Future<List<VehicleHistory>> fetchVehicleHistory(int vehicleId) async {
    final data = await _getList('/history/vehicle/$vehicleId');
    return data.map((item) => VehicleHistory.fromJson(item)).toList();
  }

  Future<CompanyAnalytics?> fetchAnalytics() async {
    final response = await http.get(Uri.parse('$baseUrl/analytics/company'));
    if (response.statusCode == 200 && response.body != 'null') {
      return CompanyAnalytics.fromJson(jsonDecode(response.body));
    }
    _throwForResponse(response);
    return null;
  }

  Future<List<SystemLog>> fetchLogs() async {
    final data = await _getList('/logs/');
    return data.map((item) => SystemLog.fromJson(item)).toList();
  }

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    _throwForResponse(response);
  }

  Future<List<Map<String, dynamic>>> _getList(String path) async {
    final response = await http.get(Uri.parse('$baseUrl$path'), headers: _headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.cast<Map<String, dynamic>>();
    }
    _throwForResponse(response);
  }

  Never _throwForResponse(http.Response response) {
    throw ApiException('Request failed (${response.statusCode}): ${response.body}');
  }
}

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}
