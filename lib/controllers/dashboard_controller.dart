import 'package:get/get.dart';
import '../core/utils/snackbar_utils.dart';
import '../data/models/models.dart';
import '../data/services/api_service.dart';

class DashboardController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final statistics = Rx<SystemStatistics?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getSystemStatistics();
      statistics.value = SystemStatistics.fromJson(response);
    } catch (e) {
      showCustomSnackbar('خطا', 'دریافت آمار ناموفق بود: ${e.toString()}',
          isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void refresh() {
    fetchStatistics();
  }
}
