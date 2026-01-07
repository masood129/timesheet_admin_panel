import 'package:get/get.dart';
import '../core/utils/snackbar_utils.dart';
import '../data/models/models.dart';
import '../data/services/api_service.dart';
import 'group_controller.dart';

class UserController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final users = <User>[].obs;
  final totalUsers = 0.obs;
  final currentPage = 1.obs;
  final searchQuery = ''.obs;
  final selectedRole = Rx<String?>(null);
  
  // For edit dialog dropdowns
  final allGroups = <Group>[].obs;
  final allAdmins = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    fetchGroupsForDropdown();
    fetchAdminsForDropdown();
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
      showCustomSnackbar('خطا', 'دریافت کاربران ناموفق بود: ${e.toString()}',
          isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<User?> getUserById(int id) async {
    try {
      final response = await _apiService.getUserById(id);
      return User.fromJson(response);
    } catch (e) {
      showCustomSnackbar('خطا', 'دریافت اطلاعات کاربر ناموفق بود',
          isError: true);
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
      showCustomSnackbar('موفق', 'کاربر با موفقیت ایجاد شد');
      await fetchUsers();
      // Refresh dropdown lists that contain users
      await fetchAdminsForDropdown();
      // Also refresh GroupController's potential managers if it exists
      try {
        final groupController = Get.find<GroupController>();
        await groupController.fetchPotentialManagers();
      } catch (e) {
        // GroupController might not be initialized, ignore
      }
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'ایجاد کاربر ناموفق بود: ${e.toString()}',
          isError: true);
      return false;
    }
  }

  Future<bool> updateUser(int id, Map<String, dynamic> data) async {
    try {
      await _apiService.updateUser(id, data);
      showCustomSnackbar('موفق', 'کاربر با موفقیت بروزرسانی شد');
      await fetchUsers();
      // Refresh dropdown lists that contain users
      await fetchAdminsForDropdown();
      // Also refresh GroupController's potential managers if it exists
      try {
        final groupController = Get.find<GroupController>();
        await groupController.fetchPotentialManagers();
      } catch (e) {
        // GroupController might not be initialized, ignore
      }
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'بروزرسانی کاربر ناموفق بود', isError: true);
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      await _apiService.deleteUser(id);
      showCustomSnackbar('موفق', 'کاربر با موفقیت حذف شد');
      await fetchUsers();
      // Refresh dropdown lists that contain users
      await fetchAdminsForDropdown();
      // Also refresh GroupController's potential managers if it exists
      try {
        final groupController = Get.find<GroupController>();
        await groupController.fetchPotentialManagers();
      } catch (e) {
        // GroupController might not be initialized, ignore
      }
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'حذف کاربر ناموفق بود', isError: true);
      return false;
    }
  }

  Future<bool> updateUserRole(int id, String role) async {
    try {
      await _apiService.updateUserRole(id, role);
      showCustomSnackbar('موفق', 'نقش کاربر با موفقیت تغییر کرد');
      await fetchUsers();
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'تغییر نقش ناموفق بود', isError: true);
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

  Future<void> fetchGroupsForDropdown() async {
    try {
      final response = await _apiService.getGroups(limit: 1000);
      allGroups.value =
          (response['groups'] as List).map((g) => Group.fromJson(g)).toList();
    } catch (e) {
      print('Error fetching groups: $e');
    }
  }

  Future<void> fetchAdminsForDropdown() async {
    try {
      // Fetch all users that can be direct admins (managers)
      final response = await _apiService.getUsers(limit: 1000);
      allAdmins.value =
          (response['users'] as List).map((u) => User.fromJson(u)).toList();
    } catch (e) {
      print('Error fetching admins: $e');
    }
  }
}
