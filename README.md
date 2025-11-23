# پنل ادمین تایم‌شیت - Flutter Web

پنل ادمین وب برای سیستم مدیریت تایم‌شیت، ساخته شده با Flutter و GetX.

## ویژگی‌ها

✅ **احراز هویت**
- ورود با نام کاربری
- مدیریت توکن JWT
- محدودیت دسترسی به کاربران ادمین

✅ **داشبورد**
- نمایش آمار کلی سیستم
- نمودار توزیع کاربران بر اساس نقش
- وضعیت گزارش‌ها
- فعالیت اخیر

✅ **مدیریت کاربران**
- لیست کاربران با جستجو و فیلتر
- ایجاد کاربر جدید
- ویرایش کاربران
- حذف کاربران
- تغییر نقش کاربران
- صفحه‌بندی

✅ **طراحی**
- رابط کاربری مدرن و زیبا
- پشتیبانی کامل از RTL
- Responsive Design
- تم سفارشی با Material 3

## فناوری‌های استفاده شده

- **Flutter** - فریمورک اصلی
- **GetX** - مدیریت state و routing
- **Dio** - HTTP client
- **GetStorage** - ذخیره‌سازی محلی
- **FL Chart** - نمودارها
- **Google Fonts** - فونت‌های زیبا

## نصب و راه‌اندازی

### پیش‌نیازها

- Flutter SDK (3.0.0 یا بالاتر)
- Dart SDK
- مرورگر وب (Chrome توصیه می‌شود)

### مراحل نصب

1. **دانلود dependencies:**
```bash
flutter pub get
```

2. **تنظیم آدرس API:**

فایل `lib/core/constants/app_constants.dart` را باز کنید و آدرس backend را تنظیم کنید:

```dart
static const String baseUrl = 'http://localhost:3000';
```

3. **اجرای برنامه:**

```bash
# اجرا در مرورگر
flutter run -d chrome

# یا برای Windows
flutter run -d windows

# یا برای Android
flutter run -d android
```

4. **Build برای production:**

```bash
# Build برای وب
flutter build web

# Build برای Windows
flutter build windows
```

## ساختار پروژه

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart      # تنظیمات و ثابت‌ها
│   └── theme/
│       └── app_theme.dart           # تم برنامه
├── data/
│   ├── models/
│   │   └── models.dart              # مدل‌های داده
│   └── services/
│       └── api_service.dart         # سرویس API
├── controllers/
│   ├── auth_controller.dart         # کنترلر احراز هویت
│   ├── dashboard_controller.dart    # کنترلر داشبورد
│   └── user_controller.dart         # کنترلر کاربران
├── views/
│   ├── pages/
│   │   ├── login_page.dart          # صفحه ورود
│   │   ├── main_layout.dart         # لایه اصلی
│   │   ├── dashboard_page.dart      # صفحه داشبورد
│   │   └── users_page.dart          # صفحه کاربران
│   └── widgets/
│       ├── sidebar.dart             # منوی کناری
│       └── user_dialog.dart         # دیالوگ کاربر
└── main.dart                        # نقطه شروع برنامه
```

## استفاده

### ورود به سیستم

1. برنامه را اجرا کنید
2. نام کاربری ادمین را وارد کنید
3. فقط کاربران با نقش `admin` می‌توانند وارد شوند

### مدیریت کاربران

- **جستجو**: از کادر جستجو برای یافتن کاربران استفاده کنید
- **فیلتر**: کاربران را بر اساس نقش فیلتر کنید
- **ایجاد**: دکمه "کاربر جدید" را کلیک کنید
- **ویرایش**: روی آیکون ویرایش کلیک کنید
- **حذف**: روی آیکون حذف کلیک کنید

### داشبورد

داشبورد شامل:
- تعداد کل کاربران، پروژه‌ها، و گروه‌ها
- گزارش‌های در انتظار تایید
- نمودار توزیع کاربران بر اساس نقش
- وضعیت گزارش‌های تایید شده و در انتظار
- تعداد فعالیت‌های 30 روز اخیر

## تنظیمات API

تمام endpointهای API در فایل `lib/data/services/api_service.dart` تعریف شده‌اند:

- `/auth/login` - ورود
- `/admin/users` - مدیریت کاربران
- `/admin/projects` - مدیریت پروژه‌ها
- `/admin/groups` - مدیریت گروه‌ها
- `/admin/reports` - گزارش‌ها
- `/admin/config` - تنظیمات

## توسعه بیشتر

برای افزودن صفحات جدید:

1. کنترلر جدید در `controllers/` ایجاد کنید
2. صفحه جدید در `views/pages/` ایجاد کنید
3. آیتم منو را در `sidebar.dart` اضافه کنید
4. صفحه را در `main_layout.dart` به لیست اضافه کنید

## مشکلات رایج

### خطای CORS

اگر با خطای CORS مواجه شدید، مطمئن شوید که backend شما CORS را برای origin برنامه فعال کرده است.

### خطای Connection

مطمئن شوید که:
- Backend در حال اجرا است
- آدرس API در `app_constants.dart` صحیح است
- توکن JWT معتبر است

## لایسنس

این پروژه برای استفاده داخلی است.

## پشتیبانی

برای سوالات و مشکلات، با تیم توسعه تماس بگیرید.
