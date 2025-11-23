import 'package:get/get.dart';
import '../data/models/models.dart';
import '../data/services/api_service.dart';

class GroupController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final groups = <Group>[].obs;
  final totalGroups = 0.obs;
  final currentPage = 1.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
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
      Get.snackbar('خطا', 'دریافت گروه‌ها ناموفق بود: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Group?> getGroupById(int id) async {
    try {
      final response = await _apiService.getGroupById(id);
      return Group.fromJson(response);
    } catch (e) {
      Get.snackbar('خطا', 'دریافت اطلاعات گروه ناموفق بود');
      return null;
    }
  }

  Future<bool> createGroup({
    required int groupId,
    required String groupName,
    int? managerId,
  }) async {
    try {
      await _apiService.createGroup({
        'GroupId': groupId,
        'GroupName': groupName,
        if (managerId != null) 'ManagerId': managerId,
      });
      Get.snackbar('موفق', 'گروه با موفقیت ایجاد شد');
      await fetchGroups();
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'ایجاد گروه ناموفق بود: ${e.toString()}');
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
      Get.snackbar('موفق', 'گروه با موفقیت بروزرسانی شد');
      await fetchGroups();
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'بروزرسانی گروه ناموفق بود');
      return false;
    }
  }

  Future<bool> deleteGroup(int id) async {
    try {
      await _apiService.deleteGroup(id);
      Get.snackbar('موفق', 'گروه با موفقیت حذف شد');
      await fetchGroups();
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'حذف گروه ناموفق بود');
      return false;
    }
  }

  Future<bool> setGroupManager(int groupId, int managerId) async {
    try {
      await _apiService.setGroupManager(groupId, managerId);
      Get.snackbar('موفق', 'مدیر گروه تعیین شد');
      await fetchGroups();
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'تعیین مدیر ناموفق بود');
      return false;
    }
  }

  Future<bool> addUserToGroup(int groupId, int userId) async {
    try {
      await _apiService.addUserToGroup(groupId, userId);
      Get.snackbar('موفق', 'کاربر به گروه اضافه شد');
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'افزودن کاربر ناموفق بود');
      return false;
    }
  }

  Future<bool> removeUserFromGroup(int groupId, int userId) async {
    try {
      await _apiService.removeUserFromGroup(groupId, userId);
      Get.snackbar('موفق', 'کاربر از گروه حذف شد');
      return true;
    } catch (e) {
      Get.snackbar('خطا', 'حذف کاربر ناموفق بود');
      return false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    fetchGroups();
  }
}
