import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';

class Sidebar extends StatelessWidget {
  final RxInt selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: AppTheme.sidebarColor,
      child: Column(
        children: [
          // Logo/Header
          Container(
            height: 64,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'پنل ادمین',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white24, height: 1),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard,
                  title: 'داشبورد',
                  index: 0,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.people,
                  title: 'کاربران',
                  index: 1,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.work,
                  title: 'پروژه‌ها',
                  index: 2,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.groups,
                  title: 'گروه‌ها',
                  index: 3,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.assessment,
                  title: 'گزارش‌ها',
                  index: 4,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.calendar_month,
                  title: 'بازه ماه‌ها',
                  index: 5,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.description,
                  title: 'لاگ‌های سیستم',
                  index: 6,
                ),
                const Divider(color: Colors.white24, height: 32),
                _buildMenuItem(
                  context,
                  icon: Icons.settings,
                  title: 'تنظیمات',
                  index: 7,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
  }) {
    return Obx(() {
      final isSelected = selectedIndex.value == index;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.sidebarActiveColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: isSelected,
          hoverColor: AppTheme.sidebarHoverColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onTap: () => onItemSelected(index),
        ),
      );
    });
  }
}
