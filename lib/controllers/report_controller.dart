import 'package:get/get.dart';
import '../core/utils/snackbar_utils.dart';
import '../data/models/models.dart';
import '../data/services/api_service.dart';

class ReportController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final reports = <MonthlyReport>[].obs;
  final totalReports = 0.obs;
  final currentPage = 1.obs;
  final selectedStatus = Rx<String?>(null);
  final selectedUserId = Rx<int?>(null);
  final selectedYear = Rx<int?>(null);
  final selectedMonth = Rx<int?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  Future<void> fetchReports({int page = 1}) async {
    try {
      isLoading.value = true;
      currentPage.value = page;

      final response = await _apiService.getMonthlyReports(
        status: selectedStatus.value,
        userId: selectedUserId.value,
        year: selectedYear.value,
        month: selectedMonth.value,
        page: page,
        limit: 20,
      );

      reports.value = (response['reports'] as List)
          .map((r) => MonthlyReport.fromJson(r))
          .toList();
      totalReports.value = response['total'];
    } catch (e) {
      showCustomSnackbar('خطا', 'دریافت گزارش‌ها ناموفق بود: ${e.toString()}',
          isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<MonthlyReport?> getReportById(int id) async {
    try {
      final response = await _apiService.getReportById(id);
      return MonthlyReport.fromJson(response);
    } catch (e) {
      showCustomSnackbar('خطا', 'دریافت اطلاعات گزارش ناموفق بود',
          isError: true);
      return null;
    }
  }

  Future<bool> updateReport(int id, Map<String, dynamic> data) async {
    try {
      await _apiService.updateReport(id, data);
      showCustomSnackbar('موفق', 'گزارش با موفقیت بروزرسانی شد');
      await fetchReports();
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'بروزرسانی گزارش ناموفق بود', isError: true);
      return false;
    }
  }

  Future<bool> deleteReport(int id) async {
    try {
      await _apiService.deleteReport(id);
      showCustomSnackbar('موفق', 'گزارش با موفقیت حذف شد');
      await fetchReports();
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'حذف گزارش ناموفق بود', isError: true);
      return false;
    }
  }

  Future<bool> approveReport(int id, String status, String? comment) async {
    try {
      await _apiService.approveReport(id, {
        'Status': status,
        if (comment != null && comment.isNotEmpty) 'Comment': comment,
      });
      showCustomSnackbar('موفق', 'گزارش با موفقیت تایید شد');
      await fetchReports();
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'تایید گزارش ناموفق بود', isError: true);
      return false;
    }
  }

  void setStatusFilter(String? status) {
    selectedStatus.value = status;
    fetchReports();
  }

  void setUserFilter(int? userId) {
    selectedUserId.value = userId;
    fetchReports();
  }

  void setYearFilter(int? year) {
    selectedYear.value = year;
    fetchReports();
  }

  void setMonthFilter(int? month) {
    selectedMonth.value = month;
    fetchReports();
  }

  void clearFilters() {
    selectedStatus.value = null;
    selectedUserId.value = null;
    selectedYear.value = null;
    selectedMonth.value = null;
    fetchReports();
  }
}
