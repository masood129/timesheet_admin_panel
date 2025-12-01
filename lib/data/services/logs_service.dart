import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/log_entry_model.dart';

class LogsService {
  final String baseUrl;
  final String token;

  LogsService({required this.baseUrl, required this.token});

  /// Get all available log categories
  Future<Map<String, List<Map<String, dynamic>>>> getLogCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/logs/categories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data.map((key, value) => MapEntry(
            key,
            List<Map<String, dynamic>>.from(value),
          ));
    } else {
      throw Exception('Failed to load log categories');
    }
  }

  /// Get logs for a specific category
  Future<Map<String, dynamic>> getLogsByCategory({
    required String category,
    String? date,
    String? level,
    String? search,
    int? userId,
    int page = 1,
    int limit = 100,
  }) async {
    final queryParams = {
      if (date != null) 'date': date,
      if (level != null) 'level': level,
      if (search != null) 'search': search,
      if (userId != null) 'userId': userId.toString(),
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final uri = Uri.parse('$baseUrl/admin/logs/$category')
        .replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'logs': (data['logs'] as List)
            .map((log) => LogEntryModel.fromJson(log))
            .toList(),
        'total': data['total'],
        'page': data['page'],
        'totalPages': data['totalPages'],
        'category': data['category'],
        'filename': data['filename'],
      };
    } else if (response.statusCode == 404) {
      throw Exception('Log file not found');
    } else {
      throw Exception('Failed to load logs');
    }
  }

  /// Get all logs (across all categories) with optional filters
  Future<Map<String, dynamic>> getAllLogs({
    String? level,
    String? search,
    String? startDate,
    String? endDate,
    int? userId,
    int page = 1,
    int limit = 100,
  }) async {
    final queryParams = {
      if (search != null && search.isNotEmpty) 'query': search,
      if (level != null) 'level': level,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      if (userId != null) 'userId': userId.toString(),
      'limit': limit.toString(),
    };

    final uri = Uri.parse('$baseUrl/admin/logs/search/all')
        .replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final logs = (data['logs'] as List)
          .map((log) => LogEntryModel.fromJson(log))
          .toList();
      final total = data['total'] as int;
      
      // Calculate pagination info
      final totalPages = (total / limit).ceil();
      
      return {
        'logs': logs,
        'total': total,
        'page': page,
        'totalPages': totalPages,
        'truncated': data['truncated'] ?? false,
      };
    } else {
      throw Exception('Failed to fetch all logs');
    }
  }

  /// Search across all logs
  Future<Map<String, dynamic>> searchLogs({
    required String query,
    String? category,
    String? level,
    String? startDate,
    String? endDate,
    int? userId,
    int limit = 100,
  }) async {
    final queryParams = {
      'query': query,
      if (category != null) 'category': category,
      if (level != null) 'level': level,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      if (userId != null) 'userId': userId.toString(),
      'limit': limit.toString(),
    };

    final uri = Uri.parse('$baseUrl/admin/logs/search/all')
        .replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'logs': (data['logs'] as List)
            .map((log) => LogEntryModel.fromJson(log))
            .toList(),
        'total': data['total'],
        'truncated': data['truncated'],
      };
    } else {
      throw Exception('Failed to search logs');
    }
  }

  /// Download a log file
  Future<void> downloadLog({
    required String category,
    required String date,
  }) async {
    final uri = Uri.parse('$baseUrl/admin/logs/download/$category/$date');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Return the file data - actual file saving will be handled by the UI layer
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Log file not found');
    } else {
      throw Exception('Failed to download log file');
    }
  }
}
