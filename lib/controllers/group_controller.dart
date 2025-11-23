import 'package:get/get.dart';
import '../core/utils/snackbar_utils.dart';
import '../data/models/models.dart';
import '../data/services/api_service.dart';

class GroupController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final groups = <Group>[].obs;
  final totalGroups = 0.obs;
  final currentPage = 1.obs;
  final searchQuery = ''.obs;

  final potentialManagers = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
    fetchPotentialManagers();
  }

  Future<void> fetchPotentialManagers() async {
    try {
      // Fetch all users to be selected as managers
      // You might want to filter by role 'group_manager' if applicable
      final response = await _apiService.getUsers(limit: 1000);
      potentialManagers.value =
          (response['users'] as List).map((u) => User.fromJson(u)).toList();
    } catch (e) {
      print('Error fetching managers: $e');
    }
  }

  Future<void> fetchGroups({int page = 1}) async {
    try {
      isLoading.value = true;
      currentPage.value = page;

      final response = await _apiService.getGroups(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        page: page,
        limit: 20,
      );

      groups.value =
          (response['groups'] as List).map((g) => Group.fromJson(g)).toList();
      totalGroups.value = response['total'];
    } catch (e) {
      showCustomSnackbar('خطا', 'دریافت گروه‌ها ناموفق بود: ${e.toString()}',
          isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<Group?> getGroupById(int id) async {
    try {
      final response = await _apiService.getGroupById(id);
      return Group.fromJson(response);
    } catch (e) {
      showCustomSnackbar('خطا', 'دریافت اطلاعات گروه ناموفق بود',
          isError: true);
      return null;
    }
  }

  Future<bool> createGroup({
    required String groupName,
    required int managerId,
  }) async {
    try {
      await _apiService.createGroup({
        'GroupName': groupName,
        'ManagerId': managerId,
      });
      showCustomSnackbar('موفق', 'گروه با موفقیت ایجاد شد');
      await fetchGroups();
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'ایجاد گروه ناموفق بود: ${e.toString()}',
          isError: true);
      return false;
    }
  }

  Future<bool> updateGroup(
    int id,
    String groupName,
  ) async {
    try {
      await _apiService.updateGroup(id, {
        'GroupName': groupName,
      });
      showCustomSnackbar('موفق', 'گروه با موفقیت بروزرسانی شد');
      await fetchGroups();
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'بروزرسانی گروه ناموفق بود', isError: true);
      return false;
    }
  }

  Future<bool> deleteGroup(int id) async {
    try {
      await _apiService.deleteGroup(id);
      showCustomSnackbar('موفق', 'گروه با موفقیت حذف شد');
      await fetchGroups();
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'حذف گروه ناموفق بود', isError: true);
      return false;
    }
  }

  Future<bool> setGroupManager(int groupId, int managerId) async {
    try {
      await _apiService.setGroupManager(groupId, managerId);
      showCustomSnackbar('موفق', 'مدیر گروه تعیین شد');
      await fetchGroups();
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'تعیین مدیر ناموفق بود', isError: true);
      return false;
    }
  }

  Future<bool> addUserToGroup(int groupId, int userId) async {
    try {
      await _apiService.addUserToGroup(groupId, userId);
      showCustomSnackbar('موفق', 'کاربر به گروه اضافه شد');
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'افزودن کاربر ناموفق بود', isError: true);
      return false;
    }
  }

  Future<bool> removeUserFromGroup(int groupId, int userId) async {
    try {
      await _apiService.removeUserFromGroup(groupId, userId);
      showCustomSnackbar('موفق', 'کاربر از گروه حذف شد');
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'حذف کاربر ناموفق بود', isError: true);
      return false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    fetchGroups();
  }
}
