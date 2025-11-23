import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/project_controller.dart';
import '../../controllers/group_controller.dart';
import '../../controllers/report_controller.dart';
import '../../controllers/month_period_controller.dart';
import '../widgets/sidebar.dart';
import 'dashboard_page.dart';
import 'users_page.dart';
import 'projects_page.dart';
import 'groups_page.dart';
import 'reports_page.dart';
import '../month_periods_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final _selectedIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => UserController());
    Get.lazyPut(() => ProjectController());
    Get.lazyPut(() => GroupController());
    Get.lazyPut(() => ReportController());
    Get.lazyPut(() => MonthPeriodController());
  }

  List<Widget> _getPages() {
    return [
      const DashboardPage(),
      const UsersPage(),
      const ProjectsPage(),
      const GroupsPage(),
      const ReportsPage(),
      const MonthPeriodsPage(),
      const Center(child: Text('تنظیمات')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final pages = _getPages();

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Sidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              _selectedIndex.value = index;
            },
          ),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Top app bar
                Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getPageTitle(_selectedIndex.value),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),

                      // User info
                      Obx(() => Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    authController.username.value,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    'ادمین',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: Text(
                                  authController.username.value.isNotEmpty
                                      ? authController.username.value[0]
                                          .toUpperCase()
                                      : 'A',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 8),
                              PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Row(
                                      children: [
                                        Icon(Icons.logout, size: 20),
                                        SizedBox(width: 12),
                                        Text('خروج'),
                                      ],
                                    ),
                                    onTap: () => authController.logout(),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                ),

                // Page content
                Expanded(
                  child: Obx(() => pages[_selectedIndex.value]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle(int index) {
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
        return 'تنظیمات';
      default:
        return '';
    }
  }
}
