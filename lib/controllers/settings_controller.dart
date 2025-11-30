import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/utils/snackbar_utils.dart';
import '../data/models/dashboard_settings.dart';
import '../data/services/settings_service.dart';

class SettingsController extends GetxController {
  final SettingsService _settingsService = SettingsService();

  final isLoading = false.obs;
  final dashboardSettings = Rx<DashboardSettings?>(null);

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  // بارگذاری تنظیمات
  Future<void> loadSettings() async {
    try {
      isLoading.value = true;
      final settings = await _settingsService.loadDashboardSettings();
      dashboardSettings.value = settings;
    } catch (e) {
      showCustomSnackbar('خطا', 'بارگذاری تنظیمات ناموفق بود: ${e.toString()}',
          isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // ذخیره تنظیمات
  Future<void> saveSettings() async {
    try {
      if (dashboardSettings.value == null) return;

      isLoading.value = true;
      await _settingsService.saveDashboardSettings(dashboardSettings.value!);
      showCustomSnackbar('موفق', 'تنظیمات با موفقیت ذخیره شد');
    } catch (e) {
      showCustomSnackbar('خطا', 'ذخیره تنظیمات ناموفق بود: ${e.toString()}',
          isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // تغییر وضعیت نمایش یک آیتم
  void toggleItemVisibility(String itemId) {
    if (dashboardSettings.value == null) return;

    final items = dashboardSettings.value!.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isVisible: !item.isVisible);
      }
      return item;
    }).toList();

    dashboardSettings.value = dashboardSettings.value!.copyWith(items: items);
  }

  // به‌روزرسانی یک آیتم
  void updateItem(DashboardItem updatedItem) {
    if (dashboardSettings.value == null) return;

    final items = dashboardSettings.value!.items.map((item) {
      if (item.id == updatedItem.id) {
        return updatedItem;
      }
      return item;
    }).toList();

    dashboardSettings.value = dashboardSettings.value!.copyWith(items: items);
  }

  // تغییر ترتیب آیتم‌ها
  void reorderItems(int oldIndex, int newIndex) {
    if (dashboardSettings.value == null) return;

    final items = List<DashboardItem>.from(dashboardSettings.value!.items);
    
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    // به‌روزرسانی order برای همه آیتم‌ها
    final updatedItems = items.asMap().entries.map((entry) {
      return entry.value.copyWith(order: entry.key);
    }).toList();

    dashboardSettings.value =
        dashboardSettings.value!.copyWith(items: updatedItems);
  }

  // تغییر رنگ یک آیتم
  void updateItemColor(String itemId, Color color) {
    if (dashboardSettings.value == null) return;

    final items = dashboardSettings.value!.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(color: color);
      }
      return item;
    }).toList();

    dashboardSettings.value = dashboardSettings.value!.copyWith(items: items);
  }

  // تغییر آیکون یک آیتم
  void updateItemIcon(String itemId, IconData icon) {
    if (dashboardSettings.value == null) return;

    final items = dashboardSettings.value!.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(icon: icon);
      }
      return item;
    }).toList();

    dashboardSettings.value = dashboardSettings.value!.copyWith(items: items);
  }

  // تغییر عنوان یک آیتم
  void updateItemTitle(String itemId, String title) {
    if (dashboardSettings.value == null) return;

    final items = dashboardSettings.value!.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(title: title);
      }
      return item;
    }).toList();

    dashboardSettings.value = dashboardSettings.value!.copyWith(items: items);
  }

  // تغییر نوع نمودار
  void updateChartType(String itemId, ChartType chartType) {
    if (dashboardSettings.value == null) return;

    final items = dashboardSettings.value!.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(chartType: chartType);
      }
      return item;
    }).toList();

    dashboardSettings.value = dashboardSettings.value!.copyWith(items: items);
  }

  // بازنشانی تنظیمات به حالت پیش‌فرض
  Future<void> resetToDefault() async {
    try {
      isLoading.value = true;
      await _settingsService.resetDashboardSettings();
      await loadSettings();
      showCustomSnackbar('موفق', 'تنظیمات به حالت پیش‌فرض بازگشت');
    } catch (e) {
      showCustomSnackbar(
          'خطا', 'بازنشانی تنظیمات ناموفق بود: ${e.toString()}',
          isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // دریافت آیتم با شناسه
  DashboardItem? getItemById(String itemId) {
    if (dashboardSettings.value == null) return null;
    try {
      return dashboardSettings.value!.items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }
}

