import 'package:get/get.dart';
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
      Get.snackbar('خطا', 'دریافت پروژه‌ها ناموفق بود: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Project?> getProjectById(int id) async {
    try {
      final response = await _apiService.getProjectById(id);
      return Project.fromJson(response);
    } catch (e) {
      Get.snackbar('خطا', 'دریافت اطلاعات پروژه ناموفق بود');
      return null;
    }
  }

  Future<bool> createProject({
    required String projectName,
    required int securityLevel,
  }) async {
    try {
      await _apiService.createProject({
        'ProjectName': projectName,
        'securityLevel': securityLevel,
      });
      Get.snackbar('موفق', 'پروژه با موفقیت ایجاد شد');
      await fetchProjects();
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'ایجاد پروژه ناموفق بود: ${e.toString()}');
      return false;
    }
  }

  Future<bool> updateProject(
    int id,
    String projectName,
    int securityLevel,
  ) async {
    try {
      await _apiService.updateProject(id, {
        'ProjectName': projectName,
        'securityLevel': securityLevel,
      });
      Get.snackbar('موفق', 'پروژه با موفقیت بروزرسانی شد');
      await fetchProjects();
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'بروزرسانی پروژه ناموفق بود');
      return false;
    }
  }

  Future<bool> deleteProject(int id) async {
    try {
      await _apiService.deleteProject(id);
      Get.snackbar('موفق', 'پروژه با موفقیت حذف شد');
      await fetchProjects();
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'حذف پروژه ناموفق بود');
      return false;
    }
  }

  Future<List<User>> getProjectUsers(int projectId) async {
    try {
      final response = await _apiService.getProjectUsers(projectId);
      return response.map((u) => User.fromJson(u)).toList();
    } catch (e) {
      Get.snackbar('خطا', 'دریافت کاربران پروژه ناموفق بود');
      return [];
    }
  }

  Future<bool> addUserToProject(int projectId, int userId) async {
    try {
      await _apiService.addUserToProject(projectId, userId);
      Get.snackbar('موفق', 'کاربر به پروژه اضافه شد');
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'افزودن کاربر ناموفق بود');
      return false;
    }
  }

  Future<bool> removeUserFromProject(int projectId, int userId) async {
    try {
      await _apiService.removeUserFromProject(projectId, userId);
      Get.snackbar('موفق', 'کاربر از پروژه حذف شد');
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'حذف کاربر ناموفق بود');
      return false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    fetchProjects();
  }
}
