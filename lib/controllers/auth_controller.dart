import 'package:get/get.dart';
import '../core/utils/snackbar_utils.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/constants/app_constants.dart';
import '../../data/services/api_service.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  final _storage = GetStorage();

  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final username = ''.obs;
  final userId = 0.obs;
  final role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    final token = _storage.read(AppConstants.tokenKey);
    if (token != null) {
      isLoggedIn.value = true;
      username.value = _storage.read(AppConstants.usernameKey) ?? '';
      userId.value = _storage.read(AppConstants.userIdKey) ?? 0;
      role.value = _storage.read(AppConstants.roleKey) ?? '';
    }
  }

  Future<bool> login(String usernameInput) async {
    try {
      isLoading.value = true;
      final response = await _apiService.login(usernameInput);

      // Save auth data
      await _storage.write(AppConstants.tokenKey, response['token']);
      await _storage.write(AppConstants.usernameKey, response['Username']);
      await _storage.write(AppConstants.userIdKey, response['userId']);
      await _storage.write(AppConstants.roleKey, response['Role']);

      // Check if user is admin
      if (response['Role'] != 'admin') {
        showCustomSnackbar('خطا', 'شما دسترسی ادمین ندارید', isError: true);
        await logout();
        return false;
      }

      // Update state
      username.value = response['Username'];
      userId.value = response['userId'];
      role.value = response['Role'];
      isLoggedIn.value = true;

      showCustomSnackbar('موفق', 'خوش آمدید ${response['Username']}');

      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'ورود ناموفق بود: ${e.toString()}',
          isError: true);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storage.remove(AppConstants.tokenKey);
    await _storage.remove(AppConstants.usernameKey);
    await _storage.remove(AppConstants.userIdKey);
    await _storage.remove(AppConstants.roleKey);

    isLoggedIn.value = false;
    username.value = '';
    userId.value = 0;
    role.value = '';

    Get.offAllNamed('/login');
  }
}
