import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class PageTitleManager {
  static final PageTitleManager _instance = PageTitleManager._internal();
  factory PageTitleManager() => _instance;
  PageTitleManager._internal();

  static const String _baseTitle = 'پنل ادمین تایم‌شیت';

  /// Set the page title with optional subtitle
  static void setTitle(String subtitle) {
    final fullTitle = subtitle.isNotEmpty 
        ? '$_baseTitle - $subtitle' 
        : _baseTitle;
    
    if (kIsWeb) {
      html.document.title = fullTitle;
    }
  }

  /// Reset to base title
  static void resetTitle() {
    setTitle('');
  }

  /// Get title for each page index
  static String getTitleForPageIndex(int index) {
    switch (index) {
      case 0:
        return 'داشبورد';
      case 1:
        return 'مدیریت کاربران';
      case 2:
        return 'مدیریت پروژه‌ها';
      case 3:
        return 'مدیریت گروه‌ها';
      case 4:
        return 'گزارش‌ها';
      case 5:
        return 'مدیریت بازه ماه‌ها';
      case 6:
        return 'لاگ‌های سیستم';
      case 7:
        return 'تنظیمات';
      default:
        return '';
    }
  }
}

