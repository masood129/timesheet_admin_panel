import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/api_logger.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  final _storage = GetStorage();

  void init() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add auth token interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token
        final token = _storage.read(AppConstants.tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));

    // Add logging interceptor
    _dio.interceptors.add(ApiLoggerInterceptor());
  }

  // Public getters for baseUrl and token
  String get baseUrl => AppConstants.baseUrl;
  String? get token => _storage.read(AppConstants.tokenKey);

  // Auth
  Future<Map<String, dynamic>> login(String username) async {
    try {
      final response = await _dio.post(
        AppConstants.loginEndpoint,
        data: {'username': username},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Users
  Future<Map<String, dynamic>> getUsers({
    String? role,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.adminUsersEndpoint,
        queryParameters: {
          if (role != null) 'role': role,
          if (search != null) 'search': search,
          'page': page,
          'limit': limit,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserById(int id) async {
    try {
      final response = await _dio.get('${AppConstants.adminUsersEndpoint}/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        AppConstants.adminUsersEndpoint,
        data: data,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> data) async {
    try {
      await _dio.put(
        '${AppConstants.adminUsersEndpoint}/$id',
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _dio.delete('${AppConstants.adminUsersEndpoint}/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserRole(int id, String role) async {
    try {
      await _dio.put(
        '${AppConstants.adminUsersEndpoint}/$id/role',
        data: {'Role': role},
      );
    } catch (e) {
      rethrow;
    }
  }

  // Projects
  Future<Map<String, dynamic>> getProjects({
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.adminProjectsEndpoint,
        queryParameters: {
          if (search != null) 'search': search,
          'page': page,
          'limit': limit,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProjectById(int id) async {
    try {
      final response =
          await _dio.get('${AppConstants.adminProjectsEndpoint}/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createProject(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        AppConstants.adminProjectsEndpoint,
        data: data,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProject(int id, Map<String, dynamic> data) async {
    try {
      await _dio.put(
        '${AppConstants.adminProjectsEndpoint}/$id',
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProject(int id) async {
    try {
      await _dio.delete('${AppConstants.adminProjectsEndpoint}/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getProjectUsers(int projectId) async {
    try {
      final response = await _dio.get(
        '${AppConstants.adminProjectsEndpoint}/$projectId/users',
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addUserToProject(int projectId, int userId) async {
    try {
      await _dio.post(
        '${AppConstants.adminProjectsEndpoint}/$projectId/users',
        data: {'UserId': userId},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeUserFromProject(int projectId, int userId) async {
    try {
      await _dio.delete(
        '${AppConstants.adminProjectsEndpoint}/$projectId/users/$userId',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Groups
  Future<Map<String, dynamic>> getGroups({
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.adminGroupsEndpoint,
        queryParameters: {
          if (search != null) 'search': search,
          'page': page,
          'limit': limit,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getGroupById(int id) async {
    try {
      final response =
          await _dio.get('${AppConstants.adminGroupsEndpoint}/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createGroup(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        AppConstants.adminGroupsEndpoint,
        data: data,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateGroup(int id, Map<String, dynamic> data) async {
    try {
      await _dio.put(
        '${AppConstants.adminGroupsEndpoint}/$id',
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGroup(int id) async {
    try {
      await _dio.delete('${AppConstants.adminGroupsEndpoint}/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addUserToGroup(int groupId, int userId) async {
    try {
      await _dio.post(
        '${AppConstants.adminGroupsEndpoint}/$groupId/members',
        data: {'UserId': userId},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeUserFromGroup(int groupId, int userId) async {
    try {
      await _dio.delete(
        '${AppConstants.adminGroupsEndpoint}/$groupId/members/$userId',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setGroupManager(int groupId, int managerId) async {
    try {
      await _dio.put(
        '${AppConstants.adminGroupsEndpoint}/$groupId/manager',
        data: {'ManagerId': managerId},
      );
    } catch (e) {
      rethrow;
    }
  }

  // Reports
  Future<Map<String, dynamic>> getMonthlyReports({
    String? status,
    int? userId,
    int? year,
    int? month,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '${AppConstants.adminReportsEndpoint}/monthly',
        queryParameters: {
          if (status != null) 'status': status,
          if (userId != null) 'userId': userId,
          if (year != null) 'year': year,
          if (month != null) 'month': month,
          'page': page,
          'limit': limit,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getReportById(int id) async {
    try {
      final response = await _dio.get(
        '${AppConstants.adminReportsEndpoint}/$id',
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateReport(int id, Map<String, dynamic> data) async {
    try {
      await _dio.put(
        '${AppConstants.adminReportsEndpoint}/$id',
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteReport(int id) async {
    try {
      await _dio.delete('${AppConstants.adminReportsEndpoint}/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> approveReport(int id, Map<String, dynamic> data) async {
    try {
      await _dio.post(
        '${AppConstants.adminReportsEndpoint}/$id/approve',
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSystemStatistics() async {
    try {
      final response = await _dio.get(
        '${AppConstants.adminReportsEndpoint}/statistics',
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserActivitySummary(
    int userId, {
    String? startDate,
    String? endDate,
  }) async {
    try {
      final response = await _dio.get(
        '${AppConstants.adminReportsEndpoint}/user/$userId/summary',
        queryParameters: {
          if (startDate != null) 'startDate': startDate,
          if (endDate != null) 'endDate': endDate,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Config
  Future<List<dynamic>> getAllContractHours() async {
    try {
      final response = await _dio.get(
        '${AppConstants.adminConfigEndpoint}/contract-hours',
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateContractHours(
      int userId, Map<String, dynamic> data) async {
    try {
      await _dio.put(
        '${AppConstants.adminConfigEndpoint}/contract-hours/$userId',
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Month Period Settings
  Future<List<dynamic>> getYearMonthPeriods(int year) async {
    try {
      final response = await _dio.get(
        '${AppConstants.adminEndpoint}/month-periods/$year',
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMonthPeriod(int year, int month) async {
    try {
      final response = await _dio.get(
        '${AppConstants.adminEndpoint}/month-periods/$year/$month',
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createMonthPeriod(
      Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        '${AppConstants.adminEndpoint}/month-periods',
        data: data,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateMonthPeriod(
      int year, int month, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        '${AppConstants.adminEndpoint}/month-periods/$year/$month',
        data: data,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMonthPeriod(
      int year, int month, Map<String, dynamic> data) async {
    try {
      await _dio.delete(
        '${AppConstants.adminEndpoint}/month-periods/$year/$month',
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }
}
