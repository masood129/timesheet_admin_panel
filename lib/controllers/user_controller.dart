import 'package:get/get.dart';
import '../data/models/models.dart';
import '../data/services/api_service.dart';

class UserController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final users = <User>[].obs;
  final totalUsers = 0.obs;
  final currentPage = 1.obs;
  final searchQuery = ''.obs;
  final selectedRole = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers({int page = 1}) async {
    try {
      isLoading.value = true;
      currentPage.value = page;

      final response = await _apiService.getUsers(
        role: selectedRole.value,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        page: page,
        limit: 20,
      );

      users.value =
          (response['users'] as List).map((u) => User.fromJson(u)).toList();
      totalUsers.value = response['total'];
    } catch (e) {
      Get.snackbar('خطا', 'دریافت کاربران ناموفق بود: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<User?> getUserById(int id) async {
    try {
      final response = await _apiService.getUserById(id);
      return User.fromJson(response);
    } catch (e) {
      Get.snackbar('خطا', 'دریافت اطلاعات کاربر ناموفق بود');
      return null;
    }
  }

  Future<bool> createUser({
    required int userId,
    required String username,
    required String role,
  }) async {
    try {
      await _apiService.createUser({
        'UserId': userId,
        'Username': username,
        'Role': role,
      });
      Get.snackbar('موفق', 'کاربر با موفقیت ایجاد شد');
      await fetchUsers();
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'ایجاد کاربر ناموفق بود: ${e.toString()}');
      return false;
    }
  }

  Future<bool> updateUser(int id, String username) async {
    try {
      await _apiService.updateUser(id, {'Username': username});
      Get.snackbar('موفق', 'کاربر با موفقیت بروزرسانی شد');
      await fetchUsers();
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'بروزرسانی کاربر ناموفق بود');
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      await _apiService.deleteUser(id);
      Get.snackbar('موفق', 'کاربر با موفقیت حذف شد');
      await fetchUsers();
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'حذف کاربر ناموفق بود');
      return false;
    }
  }

  Future<bool> updateUserRole(int id, String role) async {
    try {
      await _apiService.updateUserRole(id, role);
      Get.snackbar('موفق', 'نقش کاربر با موفقیت تغییر کرد');
      await fetchUsers();
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'تغییر نقش ناموفق بود');
      return false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    fetchUsers();
  }

  void setRoleFilter(String? role) {
    selectedRole.value = role;
    fetchUsers();
  }
}
