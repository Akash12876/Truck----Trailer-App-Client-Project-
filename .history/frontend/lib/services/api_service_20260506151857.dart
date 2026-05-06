import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/company_analytics.dart';
import '../models/job.dart';
import '../models/system_log.dart';
import '../models/vehicle.dart';
import '../models/vehicle_history.dart';

class ApiService {
  ApiService({String? baseUrl})
    : baseUrl = _normalizeBaseUrl(baseUrl ?? _defaultBaseUrl);

  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );
  static const String _localApiBaseUrl = 'http://localhost:8000';
  static const String _defaultBaseUrl = _configuredBaseUrl == ''
      ? _localApiBaseUrl
      : _configuredBaseUrl;

  final String baseUrl;
  String? token;

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // login
  Future<void> login(String username, String password) async {
    final data = await _post('/auth/login', {
      'username': username,
      'password': password,
    });
    token = data['access_token'] as String?;
  }

  // signup
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
    final response = await _get('/analytics/company');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.trim().isEmpty || response.body == 'null') {
        return null;
      }
      return CompanyAnalytics.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    _throwForResponse(response);
  }

  Future<List<SystemLog>> fetchLogs() async {
    final data = await _getList('/logs/');
    return data.map((item) => SystemLog.fromJson(item)).toList();
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _send(() {
      return http.post(uri, headers: _headers, body: jsonEncode(body));
    }, uri);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.trim().isEmpty) {
        return <String, dynamic>{};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    _throwForResponse(response);
  }

  Future<List<Map<String, dynamic>>> _getList(String path) async {
    final response = await _get(path);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.cast<Map<String, dynamic>>();
    }
    _throwForResponse(response);
  }

  Future<http.Response> _get(String path) {
    final uri = Uri.parse('$baseUrl$path');
    return _send(() => http.get(uri, headers: _headers), uri);
  }

  Future<http.Response> _send(
    Future<http.Response> Function() request,
    Uri uri,
  ) async {
    try {
      return await request();
    } on http.ClientException catch (error) {
      throw ApiException(_connectionMessage(uri, error));
    }
  }

  Never _throwForResponse(http.Response response) {
    throw ApiException(
      'Request failed (${response.statusCode}): ${response.body}',
    );
  }

  static String _normalizeBaseUrl(String url) {
    final trimmedUrl = url.trim();
    final withoutTrailingSlash = trimmedUrl.endsWith('/')
        ? trimmedUrl.substring(0, trimmedUrl.length - 1)
        : trimmedUrl;

    return withoutTrailingSlash.replaceFirst('://127.0.0.1:', '://localhost:');
  }

  static String _connectionMessage(Uri uri, http.ClientException error) {
    return 'Backend API se connection nahi ban pa raha hai. '
        'Request URL: $uri. '
        'Backend server start hai aur API_BASE_URL sahi hai ye verify karein. '
        'Original error: ${error.message}';
  }
}

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}
