import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/dashboard_settings.dart';
import '../widgets/dashboard_item_editor_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final settings = controller.dashboardSettings.value;
        if (settings == null) {
          return const Center(child: Text('خطا در بارگذاری تنظیمات'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // هدر
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تنظیمات داشبورد',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'مدیریت و سفارشی‌سازی ویجت‌های داشبورد',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showResetDialog(context, controller),
                        icon: const Icon(Icons.restore),
                        label: const Text('بازنشانی به پیش‌فرض'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () => controller.saveSettings(),
                        icon: const Icon(Icons.save),
                        label: const Text('ذخیره تنظیمات'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // لیست ویجت‌ها
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ویجت‌های داشبورد',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'برای تغییر ترتیب، آیتم‌ها را بکشید و رها کنید',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      const SizedBox(height: 24),
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: settings.items.length,
                        onReorder: (oldIndex, newIndex) {
                          controller.reorderItems(oldIndex, newIndex);
                        },
                        itemBuilder: (context, index) {
                          final item = settings.items[index];
                          return _buildDashboardItemTile(
                            context,
                            item,
                            controller,
                            key: ValueKey(item.id),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // راهنما
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline,
                              color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'راهنما',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildHelpItem(
                        context,
                        icon: Icons.visibility,
                        title: 'نمایش/مخفی کردن',
                        description:
                            'برای فعال یا غیرفعال کردن نمایش ویجت، روی آیکون چشم کلیک کنید',
                      ),
                      const SizedBox(height: 12),
                      _buildHelpItem(
                        context,
                        icon: Icons.edit,
                        title: 'ویرایش ویجت',
                        description:
                            'با کلیک روی دکمه ویرایش می‌توانید عنوان، رنگ، آیکون و نوع نمودار را تغییر دهید',
                      ),
                      const SizedBox(height: 12),
                      _buildHelpItem(
                        context,
                        icon: Icons.drag_indicator,
                        title: 'تغییر ترتیب',
                        description:
                            'برای تغییر ترتیب نمایش، ویجت‌ها را بگیرید و به جای دلخواه بکشید',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDashboardItemTile(
    BuildContext context,
    DashboardItem item,
    SettingsController controller, {
    required Key key,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isVisible ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.drag_indicator,
              color: Colors.grey,
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (item.color ?? AppTheme.primaryColor)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.icon ?? Icons.dashboard,
                color: item.color ?? AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: item.isVisible ? Colors.black : Colors.grey,
          ),
        ),
        subtitle: Text(
          _getItemTypeLabel(item.type),
          style: TextStyle(
            color: item.isVisible ? Colors.grey : Colors.grey.shade400,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // نوع نمودار (اگر نمودار باشد)
            if (item.chartType != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getChartIcon(item.chartType!),
                      size: 16,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getChartTypeLabel(item.chartType!),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
            // دکمه ویرایش
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              iconSize: 20,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
              onPressed: () => _showEditDialog(context, item, controller),
              tooltip: 'ویرایش',
            ),
            // دکمه نمایش/مخفی
            IconButton(
              icon: Icon(
                item.isVisible ? Icons.visibility : Icons.visibility_off,
                size: 20,
                color: item.isVisible ? AppTheme.primaryColor : Colors.grey,
              ),
              iconSize: 20,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
              onPressed: () => controller.toggleItemVisibility(item.id),
              tooltip: item.isVisible ? 'مخفی کردن' : 'نمایش دادن',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(
    BuildContext context,
    DashboardItem item,
    SettingsController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => DashboardItemEditorDialog(
        item: item,
        onSave: (updatedItem) {
          controller.updateItem(updatedItem);
        },
      ),
    );
  }

  void _showResetDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('بازنشانی تنظیمات'),
        content: const Text(
          'آیا مطمئن هستید که می‌خواهید تنظیمات را به حالت پیش‌فرض بازگردانید؟\nتمام تغییرات شما حذف خواهد شد.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.resetToDefault();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('بازنشانی'),
          ),
        ],
      ),
    );
  }

  String _getItemTypeLabel(DashboardItemType type) {
    switch (type) {
      case DashboardItemType.statCard:
        return 'کارت آماری';
      case DashboardItemType.pieChart:
        return 'نمودار دایره‌ای';
      case DashboardItemType.barChart:
        return 'نمودار میله‌ای';
      case DashboardItemType.lineChart:
        return 'نمودار خطی';
      case DashboardItemType.reportStatus:
        return 'وضعیت گزارش‌ها';
      case DashboardItemType.recentActivity:
        return 'فعالیت اخیر';
    }
  }

  String _getChartTypeLabel(ChartType type) {
    switch (type) {
      case ChartType.pie:
        return 'دایره‌ای';
      case ChartType.bar:
        return 'میله‌ای';
      case ChartType.line:
        return 'خطی';
    }
  }

  IconData _getChartIcon(ChartType type) {
    switch (type) {
      case ChartType.pie:
        return Icons.pie_chart;
      case ChartType.bar:
        return Icons.bar_chart;
      case ChartType.line:
        return Icons.show_chart;
    }
  }
}
