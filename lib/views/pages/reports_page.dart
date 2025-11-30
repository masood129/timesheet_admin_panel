import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/report_controller.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/report_dialog.dart';
import '../widgets/searchable_dropdown.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportController>();
    final searchController = TextEditingController();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Toolbar with filters and search
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    // Search field
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          labelText: 'جستجو در گزارشات',
                          hintText: 'نام کاربر، شناسه یا توضیحات...',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          // Debounce search
                          Future.delayed(const Duration(milliseconds: 500), () {
                            if (searchController.text == value) {
                              controller.setSearchQuery(
                                  value.isEmpty ? null : value);
                            }
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Status filter
                    Expanded(
                      child: Obx(() => SearchableDropdown<String>(
                            value: controller.selectedStatus.value,
                            decoration: const InputDecoration(
                              labelText: 'فیلتر وضعیت',
                              prefixIcon: Icon(Icons.filter_list),
                            ),
                            searchHint: 'جستجوی وضعیت...',
                            items: const [
                              DropdownMenuItem(value: null, child: Text('همه')),
                              DropdownMenuItem(
                                  value: 'draft', child: Text('پیش‌نویس')),
                              DropdownMenuItem(
                                  value: 'submitted_to_group_manager',
                                  child: Text('ارسال به مدیر گروه')),
                              DropdownMenuItem(
                                  value: 'submitted_to_general_manager',
                                  child: Text('ارسال به مدیر کل')),
                              DropdownMenuItem(
                                  value: 'submitted_to_finance',
                                  child: Text('ارسال به مالی')),
                              DropdownMenuItem(
                                  value: 'approved', child: Text('تایید شده')),
                            ],
                            onChanged: (value) =>
                                controller.setStatusFilter(value),
                          )),
                    ),

                    const SizedBox(width: 16),

                    // Clear filters button
                    ElevatedButton.icon(
                      onPressed: () {
                        searchController.clear();
                        controller.clearFilters();
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('پاک کردن'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Reports list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.reports.isEmpty) {
                return const Center(
                  child: Text('گزارشی یافت نشد'),
                );
              }

              return Card(
                margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    // Table header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'شناسه',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'کاربر',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'تاریخ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'ساعات',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'وضعیت',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'عملیات',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Table rows
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.reports.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final report = controller.reports[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(report.reportId.toString()),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(report.username ?? '-'),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                      '${report.jalaliYear}/${report.jalaliMonth}'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text('${report.totalHours}'),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: _buildStatusBadge(report.status),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.visibility,
                                            size: 20),
                                        onPressed: () => _showReportDialog(
                                          context,
                                          report,
                                        ),
                                        tooltip: 'مشاهده',
                                      ),
                                      IconButton(
                                        icon:
                                            const Icon(Icons.delete, size: 20),
                                        color: Colors.red,
                                        onPressed: () => _confirmDelete(
                                          context,
                                          report.reportId,
                                          report.username ?? 'گزارش',
                                        ),
                                        tooltip: 'حذف',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Pagination
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'مجموع: ${controller.totalReports.value} گزارش',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: controller.currentPage.value > 1
                                    ? () => controller.fetchReports(
                                          page:
                                              controller.currentPage.value - 1,
                                        )
                                    : null,
                              ),
                              Text(
                                'صفحه ${controller.currentPage.value}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: controller.currentPage.value * 20 <
                                        controller.totalReports.value
                                    ? () => controller.fetchReports(
                                          page:
                                              controller.currentPage.value + 1,
                                        )
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'draft':
        color = Colors.grey;
        label = 'پیش‌نویس';
        break;
      case 'submitted_to_group_manager':
        color = Colors.blue;
        label = 'ارسال به مدیر گروه';
        break;
      case 'submitted_to_general_manager':
        color = Colors.orange;
        label = 'ارسال به مدیر کل';
        break;
      case 'submitted_to_finance':
        color = Colors.purple;
        label = 'ارسال به مالی';
        break;
      case 'approved':
        color = Colors.green;
        label = 'تایید شده';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context, report) {
    showDialog(
      context: context,
      builder: (context) => ReportDialog(report: report),
    );
  }

  void _confirmDelete(BuildContext context, int reportId, String username) {
    Get.dialog(
      AlertDialog(
        title: const Text('تایید حذف'),
        content: Text('آیا از حذف گزارش "$username" اطمینان دارید؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final controller = Get.find<ReportController>();
              await controller.deleteReport(reportId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
