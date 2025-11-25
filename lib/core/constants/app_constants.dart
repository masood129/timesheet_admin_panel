import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // API Configuration
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  static const String apiVersion = '/api/v1';

  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String adminEndpoint = '/admin';
  static const String adminUsersEndpoint = '/admin/users';
  static const String adminProjectsEndpoint = '/admin/projects';
  static const String adminGroupsEndpoint = '/admin/groups';
  static const String adminReportsEndpoint = '/admin/reports';
  static const String adminConfigEndpoint = '/admin/config';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String usernameKey = 'username';
  static const String roleKey = 'role';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // App Info
  static const String appName = 'Timesheet Admin Panel';
  static const String appVersion = '1.0.0';
}
