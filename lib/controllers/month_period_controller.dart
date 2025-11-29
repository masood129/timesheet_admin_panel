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
      
      // Refresh ماه‌های مجاور که ممکن است به صورت خودکار تنظیم شده باشند
      await _refreshNeighborMonths(year, month, startYear, startMonth, startDay, endYear, endMonth, endDay);
      
      // Refresh سال جاری
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
      
      // Refresh ماه‌های مجاور که ممکن است به صورت خودکار تنظیم شده باشند
      await _refreshNeighborMonths(year, month, startYear, startMonth, startDay, endYear, endMonth, endDay);
      
      // Refresh سال جاری
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

  /// Refresh ماه‌های مجاور که ممکن است به صورت خودکار تنظیم شده باشند
  Future<void> _refreshNeighborMonths(
    int year,
    int month,
    int startYear,
    int startMonth,
    int startDay,
    int endYear,
    int endMonth,
    int endDay,
  ) async {
    // محاسبه ماه قبل و بعد
    int prevMonth = month == 1 ? 12 : month - 1;
    int prevYear = month == 1 ? year - 1 : year;
    int nextMonth = month == 12 ? 1 : month + 1;
    int nextYear = month == 12 ? year + 1 : year;

    // بررسی اینکه آیا بازه در همان ماه است یا به ماه‌های دیگر ادامه می‌دهد
    bool isStartInSameMonth = startMonth == month && startYear == year;
    bool isEndInSameMonth = endMonth == month && endYear == year;

    // اگر بازه از اول ماه شروع نمی‌شود، ماه قبل را refresh کن
    if (isStartInSameMonth && startDay > 1) {
      // اگر از اول ماه شروع نمی‌شود، ماه قبل را refresh کن
      if (prevYear == selectedYear.value || prevYear == year) {
        await fetchYearMonthPeriods(year: prevYear);
      }
    } else if (startMonth == prevMonth && startYear == prevYear) {
      // اگر بازه از ماه قبل شروع می‌شود، ماه قبل را refresh کن
      if (prevYear == selectedYear.value || prevYear == year) {
        await fetchYearMonthPeriods(year: prevYear);
      }
    }

    // اگر بازه تا آخر ماه تمام نمی‌شود، ماه بعد را refresh کن
    if (isEndInSameMonth) {
      // بررسی اینکه آیا تا آخر ماه تمام می‌شود (تقریبی - برای ماه‌های 30 روزه)
      int monthLength = month <= 6 ? 31 : (month == 12 ? 29 : 30);
      if (endDay < monthLength) {
        // اگر تا آخر ماه تمام نمی‌شود، ماه بعد را refresh کن
        if (nextYear == selectedYear.value || nextYear == year) {
          await fetchYearMonthPeriods(year: nextYear);
        }
      }
    } else if (endMonth == nextMonth && endYear == nextYear) {
      // اگر بازه به ماه بعد ادامه می‌دهد، ماه بعد را refresh کن
      if (nextYear == selectedYear.value || nextYear == year) {
        await fetchYearMonthPeriods(year: nextYear);
      }
    }

    // اگر بازه به سال بعد ادامه می‌دهد، سال بعد را هم refresh کن
    if (endYear > year || (endYear == year && endMonth == 12 && nextYear > year)) {
      await fetchYearMonthPeriods(year: endYear > year ? endYear : year + 1);
    }

    // اگر بازه از سال قبل شروع می‌شود، سال قبل را هم refresh کن
    if (startYear < year || (startYear == year && startMonth == 1 && prevYear < year)) {
      await fetchYearMonthPeriods(year: startYear < year ? startYear : year - 1);
    }
  }
}
