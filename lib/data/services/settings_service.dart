import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dashboard_settings.dart';

class SettingsService {
  static const String _dashboardSettingsKey = 'dashboard_settings';

  // ذخیره تنظیمات داشبورد
  Future<void> saveDashboardSettings(DashboardSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(settings.toJson());
      await prefs.setString(_dashboardSettingsKey, jsonString);
    } catch (e) {
      throw Exception('خطا در ذخیره تنظیمات: $e');
    }
  }

  // بارگذاری تنظیمات داشبورد
  Future<DashboardSettings> loadDashboardSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_dashboardSettingsKey);
      
      if (jsonString == null) {
        // اگر تنظیماتی ذخیره نشده، تنظیمات پیش‌فرض را برگردان
        return DashboardSettings.defaultSettings();
      }
      
      final json = jsonDecode(jsonString);
      return DashboardSettings.fromJson(json);
    } catch (e) {
      // در صورت خطا، تنظیمات پیش‌فرض را برگردان
      return DashboardSettings.defaultSettings();
    }
  }

  // بازنشانی تنظیمات به حالت پیش‌فرض
  Future<void> resetDashboardSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_dashboardSettingsKey);
    } catch (e) {
      throw Exception('خطا در بازنشانی تنظیمات: $e');
    }
  }

  // حذف همه تنظیمات
  Future<void> clearAllSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw Exception('خطا در حذف تنظیمات: $e');
    }
  }
}

