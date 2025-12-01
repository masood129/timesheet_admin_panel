import 'package:get/get.dart';
import '../core/utils/snackbar_utils.dart';
import '../data/models/models.dart';
import '../data/services/api_service.dart';

class ProjectController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final projects = <Project>[].obs;
  final totalProjects = 0.obs;
  final currentPage = 1.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  Future<void> fetchProjects({int page = 1}) async {
    try {
      isLoading.value = true;
      currentPage.value = page;

      final response = await _apiService.getProjects(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        page: page,
        limit: 20,
      );

      projects.value = (response['projects'] as List)
          .map((p) => Project.fromJson(p))
          .toList();
      totalProjects.value = response['total'];
    } catch (e) {
      showCustomSnackbar('خطا', 'دریافت پروژه‌ها ناموفق بود: ${e.toString()}',
          isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<Project?> getProjectById(int id) async {
    try {
      final response = await _apiService.getProjectById(id);
      return Project.fromJson(response);
    } catch (e) {
      showCustomSnackbar('خطا', 'دریافت اطلاعات پروژه ناموفق بود',
          isError: true);
      return null;
    }
  }

  Future<bool> createProject({
    required int id,
    required String projectName,
    bool isActive = true,
    int? directAdminId,
  }) async {
    try {
      final data = <String, dynamic>{
        'id': id,
        'projectName': projectName,
        'IsActive': isActive,
      };
      
      if (directAdminId != null) {
        data['DirectAdminId'] = directAdminId;
      }
      
      await _apiService.createProject(data);
      showCustomSnackbar('موفق', 'پروژه با موفقیت ایجاد شد');
      await fetchProjects();
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'ایجاد پروژه ناموفق بود: ${e.toString()}',
          isError: true);
      return false;
    }
  }

  Future<bool> updateProject(
    int id,
    String projectName, {
    int? newId,
    bool? isActive,
    int? directAdminId,
  }) async {
    try {
      final data = <String, dynamic>{
        'projectName': projectName,
      };
      
      if (newId != null) {
        data['id'] = newId;
      }
      
      if (isActive != null) {
        data['IsActive'] = isActive;
      }
      
      if (directAdminId != null) {
        data['DirectAdminId'] = directAdminId;
      } else {
        // Allow setting to null explicitly
        data['DirectAdminId'] = null;
      }
      
      await _apiService.updateProject(id, data);
      showCustomSnackbar('موفق', 'پروژه با موفقیت بروزرسانی شد');
      await fetchProjects();
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'بروزرسانی پروژه ناموفق بود', isError: true);
      return false;
    }
  }

  Future<bool> deleteProject(int id) async {
    try {
      await _apiService.deleteProject(id);
      showCustomSnackbar('موفق', 'پروژه با موفقیت حذف شد');
      await fetchProjects();
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'حذف پروژه ناموفق بود', isError: true);
      return false;
    }
  }

  Future<List<User>> getProjectUsers(int projectId) async {
    try {
      final response = await _apiService.getProjectUsers(projectId);
      return response.map((u) => User.fromJson(u)).toList();
    } catch (e) {
      showCustomSnackbar('خطا', 'دریافت کاربران پروژه ناموفق بود',
          isError: true);
      return [];
    }
  }

  Future<bool> addUserToProject(int projectId, int userId) async {
    try {
      await _apiService.addUserToProject(projectId, userId);
      showCustomSnackbar('موفق', 'کاربر به پروژه اضافه شد');
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'افزودن کاربر ناموفق بود', isError: true);
      return false;
    }
  }

  Future<bool> removeUserFromProject(int projectId, int userId) async {
    try {
      await _apiService.removeUserFromProject(projectId, userId);
      showCustomSnackbar('موفق', 'کاربر از پروژه حذف شد');
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'حذف کاربر ناموفق بود', isError: true);
      return false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    fetchProjects();
  }
}
