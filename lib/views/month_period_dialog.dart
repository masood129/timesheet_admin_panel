import 'package:flutter/material.dart';
import '../controllers/month_period_controller.dart';
import '../data/models/month_period_model.dart';

class MonthPeriodDialog extends StatefulWidget {
  final MonthPeriodController controller;
  final MonthPeriodModel? period; // null for create, non-null for edit

  const MonthPeriodDialog({
    super.key,
    required this.controller,
    this.period,
  });

  @override
  State<MonthPeriodDialog> createState() => _MonthPeriodDialogState();
}

class _MonthPeriodDialogState extends State<MonthPeriodDialog> {
  late int year;
  late int month;
  late int startDay;
  late int startMonth;
  late int endDay;
  late int endMonth;

  final monthNames = [
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.period != null) {
      // Edit mode
      year = widget.period!.year;
      month = widget.period!.month;
      startDay = widget.period!.startDay;
      startMonth = widget.period!.startMonth;
      endDay = widget.period!.endDay;
      endMonth = widget.period!.endMonth;
    } else {
      // Create mode - use current year/month
      year = widget.controller.selectedYear.value;
      month = 1;
      startDay = 1;
      startMonth = 1;
      endDay = 31;
      endMonth = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.period != null;

    return AlertDialog(
      title: Text(isEditMode ? 'ویرایش بازه ماه' : 'افزودن بازه ماه'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month selector (only for create mode)
              if (!isEditMode)
                DropdownButtonFormField<int>(
                  value: month,
                  decoration: const InputDecoration(labelText: 'ماه'),
                  items: List.generate(
                    12,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text(monthNames[index]),
                    ),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        month = value;
                      });
                    }
                  },
                ),
              if (isEditMode)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'ماه: ${monthNames[month - 1]}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(height: 16),

              // Start date
              const Text('تاریخ شروع:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: startMonth,
                      decoration: const InputDecoration(labelText: 'ماه'),
                      items: List.generate(
                        12,
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text(monthNames[index]),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            startMonth = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: startDay,
                      decoration: const InputDecoration(labelText: 'روز'),
                      items: List.generate(
                        31,
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            startDay = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // End date
              const Text('تاریخ پایان:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: endMonth,
                      decoration: const InputDecoration(labelText: 'ماه'),
                      items: List.generate(
                        12,
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text(monthNames[index]),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            endMonth = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: endDay,
                      decoration: const InputDecoration(labelText: 'روز'),
                      items: List.generate(
                        31,
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            endDay = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Summary
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'خلاصه:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$startDay ${monthNames[startMonth - 1]} تا $endDay ${monthNames[endMonth - 1]}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('انصراف'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(isEditMode ? 'بروزرسانی' : 'ایجاد'),
        ),
      ],
    );
  }

  void _save() async {
    bool success;

    if (widget.period != null) {
      // Edit mode
      success = await widget.controller.updateMonthPeriod(
        year: year,
        month: month,
        startDay: startDay,
        startMonth: startMonth,
        endDay: endDay,
        endMonth: endMonth,
      );
    } else {
      // Create mode
      success = await widget.controller.createMonthPeriod(
        year: year,
        month: month,
        startDay: startDay,
        startMonth: startMonth,
        endDay: endDay,
        endMonth: endMonth,
      );
    }

    if (success && mounted) {
      Navigator.pop(context);
    }
  }
}
