import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/snackbar_utils.dart';
import 'data/services/api_service.dart';
import 'views/pages/login_page.dart';
import 'views/pages/main_layout.dart';
import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dotenv
  await dotenv.load(fileName: ".env");

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize API Service
  ApiService().init();

  // Initialize Auth Controller
  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return GetMaterialApp(
      scaffoldMessengerKey: snackbarKey,
      title: 'پنل ادمین تایم‌شیت',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,

      // Initial route based on login status
      home: Obx(() => authController.isLoggedIn.value
          ? const MainLayout()
          : const LoginPage()),

      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/home', page: () => const MainLayout()),
      ],
    );
  }
}
