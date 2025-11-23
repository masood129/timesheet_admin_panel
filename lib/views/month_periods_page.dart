import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/month_period_controller.dart';
import '../data/models/month_period_model.dart';
import 'month_period_dialog.dart';

class MonthPeriodsPage extends StatelessWidget {
  const MonthPeriodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MonthPeriodController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('مدیریت بازه ماه‌ها'),
        actions: [
          // Year selector
          Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => controller
                          .changeYear(controller.selectedYear.value - 1),
                    ),
                    Text(
                      controller.selectedYear.value.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () => controller
                          .changeYear(controller.selectedYear.value + 1),
                    ),
                  ],
                ),
              )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.monthPeriods.isEmpty) {
          return const Center(child: Text('داده‌ای یافت نشد'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.monthPeriods.length,
          itemBuilder: (context, index) {
            final period = controller.monthPeriods[index];
            return _MonthPeriodCard(
              period: period,
              controller: controller,
            );
          },
        );
      }),
    );
  }
}

class _MonthPeriodCard extends StatelessWidget {
  final MonthPeriodModel period;
  final MonthPeriodController controller;

  const _MonthPeriodCard({
    required this.period,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isEditable = controller.isMonthEditable(period.year, period.month);
    final isCustom = period.isCustom ?? false;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          period.monthName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              period.periodDisplay,
              style: TextStyle(
                color: isCustom ? Colors.blue : Colors.grey[600],
                fontWeight: isCustom ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            if (isCustom)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'تنظیم شخصی',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 12,
                  ),
                ),
              ),
            if (!isEditable)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'غیرقابل ویرایش (ماه گذشته)',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        trailing: isEditable
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => MonthPeriodDialog(
                          controller: controller,
                          period: period,
                        ),
                      );
                    },
                    tooltip: 'ویرایش',
                  ),
                  if (isCustom)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, period),
                      tooltip: 'بازگشت به پیش‌فرض',
                    ),
                ],
              )
            : const Icon(Icons.lock, color: Colors.grey),
      ),
    );
  }

  void _confirmDelete(BuildContext context, MonthPeriodModel period) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('بازگشت به حالت پیش‌فرض'),
        content: Text(
          'آیا می‌خواهید بازه ${period.monthName} را به حالت پیش‌فرض بازگردانید؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await controller.deleteMonthPeriod(period.year, period.month);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('بازگشت به پیش‌فرض'),
          ),
        ],
      ),
    );
  }
}
