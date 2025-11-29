import 'package:get/get.dart';
import '../data/models/log_entry_model.dart';
import '../data/services/logs_service.dart';

class LogsController extends GetxController {
  final LogsService logsService;

  LogsController({required this.logsService});

  // Observable properties
  final RxMap<String, List<Map<String, dynamic>>> categories = RxMap();
  final RxList<LogEntryModel> logs = RxList();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Filters
  final RxString selectedCategory = 'all'.obs;
  final RxString selectedLevel = 'all'.obs;
  final RxString selectedDate = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 0.obs;
  final RxInt total = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  /// Load available log categories
  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await logsService.getLogCategories();
      categories.value = result;

      // Load logs for first category if available
      if (result.isNotEmpty) {
        selectedCategory.value = result.keys.first;
        await loadLogs();
      }
    } catch (e) {
      error.value = 'Failed to load categories: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Load logs for selected category with filters
  Future<void> loadLogs() async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await logsService.getLogsByCategory(
        category: selectedCategory.value,
        date: selectedDate.value.isNotEmpty ? selectedDate.value : null,
        level: selectedLevel.value != 'all' ? selectedLevel.value : null,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        page: currentPage.value,
        limit: 100,
      );

      logs.value = result['logs'] as List<LogEntryModel>;
      total.value = result['total'];
      currentPage.value = result['page'];
      totalPages.value = result['totalPages'];
    } catch (e) {
      error.value = 'Failed to load logs: $e';
      logs.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Search logs across all categories
  Future<void> searchAllLogs(String query) async {
    if (query.isEmpty) return;

    try {
      isLoading.value = true;
      error.value = '';
      searchQuery.value = query;

      final result = await logsService.searchLogs(
        query: query,
        category:
            selectedCategory.value != 'all' ? selectedCategory.value : null,
        level: selectedLevel.value != 'all' ? selectedLevel.value : null,
        limit: 200,
      );

      logs.value = result['logs'] as List<LogEntryModel>;
      total.value = result['total'];
    } catch (e) {
      error.value = 'Failed to search logs: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Change selected category
  void selectCategory(String category) {
    selectedCategory.value = category;
    currentPage.value = 1;
    selectedDate.value = '';
    loadLogs();
  }

  /// Change log level filter
  void selectLevel(String level) {
    selectedLevel.value = level;
    currentPage.value = 1;
    loadLogs();
  }

  /// Change date filter
  void selectDate(String date) {
    selectedDate.value = date;
    currentPage.value = 1;
    loadLogs();
  }

  /// Clear all filters
  void clearFilters() {
    selectedLevel.value = 'all';
    selectedDate.value = '';
    searchQuery.value = '';
    currentPage.value = 1;
    loadLogs();
  }

  /// Go to next page
  void nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      loadLogs();
    }
  }

  /// Go to previous page
  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      loadLogs();
    }
  }

  /// Refresh logs
  @override
  void refresh() {
    currentPage.value = 1;
    loadLogs();
  }

  /// Download log file
  Future<void> downloadLog(String category, String date) async {
    try {
      await logsService.downloadLog(category: category, date: date);
      Get.snackbar('Success', 'Log file downloaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to download log: $e');
    }
  }
}
