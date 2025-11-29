import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../core/utils/snackbar_utils.dart';
import '../data/models/month_period_model.dart';
import '../data/services/api_service.dart';

class MonthPeriodController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final monthPeriods = <MonthPeriodModel>[].obs;
  final selectedYear = Jalali.now().year.obs;

  @override
  void onInit() {
    super.onInit();
    fetchYearMonthPeriods();
  }

  /// دریافت تمام بازه‌های یک سال
  Future<void> fetchYearMonthPeriods({int? year}) async {
    try {
      isLoading.value = true;
      final targetYear = year ?? selectedYear.value;
      selectedYear.value = targetYear;

      final response = await _apiService.getYearMonthPeriods(targetYear);
      monthPeriods.value =
          response.map((period) => MonthPeriodModel.fromJson(period)).toList();
    } catch (e) {
      showCustomSnackbar(
          'خطا', 'دریافت بازه‌های ماه ناموفق بود: ${e.toString()}',
          isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  /// دریافت بازه یک ماه خاص
  Future<MonthPeriodModel?> getMonthPeriod(int year, int month) async {
    try {
      final response = await _apiService.getMonthPeriod(year, month);
      return MonthPeriodModel.fromJson(response);
    } catch (e) {
      showCustomSnackbar('خطا', 'دریافت بازه ماه ناموفق بود', isError: true);
      return null;
    }
  }

  /// ایجاد بازه جدید
  Future<bool> createMonthPeriod({
    required int year,
    required int month,
    required int startDay,
    required int startMonth,
    required int startYear,
    required int endDay,
    required int endMonth,
    required int endYear,
  }) async {
    try {
      // دریافت تاریخ جاری شمسی
      final now = Jalali.now();

      await _apiService.createMonthPeriod({
        'Year': year,
        'Month': month,
        'StartDay': startDay,
        'StartMonth': startMonth,
        'StartYear': startYear,
        'EndDay': endDay,
        'EndMonth': endMonth,
        'EndYear': endYear,
        'CurrentJalaliYear': now.year,
        'CurrentJalaliMonth': now.month,
      });

      showCustomSnackbar('موفق', 'بازه ماه با موفقیت ایجاد شد');
      await fetchYearMonthPeriods();
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'ایجاد بازه ماه ناموفق بود: ${e.toString()}',
          isError: true);
      return false;
    }
  }

  /// ویرایش بازه موجود
  Future<bool> updateMonthPeriod({
    required int year,
    required int month,
    required int startDay,
    required int startMonth,
    required int startYear,
    required int endDay,
    required int endMonth,
    required int endYear,
  }) async {
    try {
      final now = Jalali.now();

      await _apiService.updateMonthPeriod(year, month, {
        'StartDay': startDay,
        'StartMonth': startMonth,
        'StartYear': startYear,
        'EndDay': endDay,
        'EndMonth': endMonth,
        'EndYear': endYear,
        'CurrentJalaliYear': now.year,
        'CurrentJalaliMonth': now.month,
      });

      showCustomSnackbar('موفق', 'بازه ماه با موفقیت بروزرسانی شد');
      await fetchYearMonthPeriods();
      return true;
    } catch (e) {
      showCustomSnackbar(
          'خطا', 'بروزرسانی بازه ماه ناموفق بود: ${e.toString()}',
          isError: true);
      return false;
    }
  }

  /// حذف بازه (بازگشت به پیش‌فرض)
  Future<bool> deleteMonthPeriod(int year, int month) async {
    try {
      final now = Jalali.now();

      await _apiService.deleteMonthPeriod(year, month, {
        'CurrentJalaliYear': now.year,
        'CurrentJalaliMonth': now.month,
      });

      showCustomSnackbar('موفق', 'بازه ماه حذف شد و به حالت پیش‌فرض بازگشت');
      await fetchYearMonthPeriods();
      return true;
    } catch (e) {
      showCustomSnackbar('خطا', 'حذف بازه ماه ناموفق بود: ${e.toString()}',
          isError: true);
      return false;
    }
  }

  /// تغییر سال نمایش
  void changeYear(int year) {
    fetchYearMonthPeriods(year: year);
  }

  /// بررسی اینکه آیا ماه قابل ویرایش است
  bool isMonthEditable(int year, int month) {
    final now = Jalali.now();

    if (year > now.year) return true;
    if (year == now.year && month >= now.month) return true;

    return false;
  }

  /// دریافت نام ماه به فارسی
  String getMonthName(int month) {
    const monthNames = [
      'فروردین',
      'اردیبهشت',
      'خرداد',
      'تیر',
      'مرداد',
      'شهریور',
      'مهر',
      'آبان',
      'آذر',
      'دی',
      'بهمن',
      'اسفند'
    ];
    return monthNames[month - 1];
  }
}
