import 'package:flutter/material.dart';
import '../controllers/month_period_controller.dart';
import '../data/models/month_period_model.dart';
import 'widgets/searchable_dropdown.dart';

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
  late int startYear;
  late int endDay;
  late int endMonth;
  late int endYear;

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

  /// محاسبه طول واقعی یک ماه شمسی
  int _getMonthLength(int year, int month) {
    // ماه‌های 1 تا 6: 31 روز
    if (month <= 6) {
      return 31;
    }
    // ماه‌های 7 تا 11: 30 روز
    if (month <= 11) {
      return 30;
    }
    // اسفند: بررسی سال کبیسه
    // الگوریتم ساده برای سال کبیسه شمسی (چرخه 33 ساله)
    int yearInCycle = year % 33;
    if (yearInCycle == 1 || yearInCycle == 5 || yearInCycle == 9 || 
        yearInCycle == 13 || yearInCycle == 17 || yearInCycle == 22 || 
        yearInCycle == 26 || yearInCycle == 30) {
      return 30; // سال کبیسه
    }
    return 29; // سال عادی
  }

  @override
  void initState() {
    super.initState();
    if (widget.period != null) {
      // Edit mode
      year = widget.period!.year;
      month = widget.period!.month;
      startDay = widget.period!.startDay;
      startMonth = widget.period!.startMonth;
      startYear = widget.period!.startYear;
      endDay = widget.period!.endDay;
      endMonth = widget.period!.endMonth;
      endYear = widget.period!.endYear;
    } else {
      // Create mode - use current year/month
      year = widget.controller.selectedYear.value;
      month = 1;
      startDay = 1;
      startMonth = 1;
      startYear = year;
      endMonth = 1;
      endYear = year;
      endDay = _getMonthLength(endYear, endMonth); // استفاده از طول واقعی ماه
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
                SearchableDropdown<int>(
                  value: month,
                  decoration: const InputDecoration(labelText: 'ماه'),
                  searchHint: 'جستجوی ماه...',
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
                    child: SearchableDropdown<int>(
                      value: startYear,
                      decoration: const InputDecoration(labelText: 'سال'),
                      searchHint: 'جستجو...',
                      items: List.generate(
                        10,
                        (index) => DropdownMenuItem(
                          value: year - 1 + index,
                          child: Text('${year - 1 + index}'),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            startYear = value;
                            // اگر روز انتخاب شده بیشتر از طول ماه جدید است، آن را محدود کن
                            int maxDay = _getMonthLength(startYear, startMonth);
                            if (startDay > maxDay) {
                              startDay = maxDay;
                            }
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SearchableDropdown<int>(
                      value: startMonth,
                      decoration: const InputDecoration(labelText: 'ماه'),
                      searchHint: 'جستجو...',
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
                            // اگر روز انتخاب شده بیشتر از طول ماه جدید است، آن را محدود کن
                            int maxDay = _getMonthLength(startYear, startMonth);
                            if (startDay > maxDay) {
                              startDay = maxDay;
                            }
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SearchableDropdown<int>(
                      value: startDay,
                      decoration: const InputDecoration(labelText: 'روز'),
                      searchHint: 'جستجو...',
                      items: List.generate(
                        _getMonthLength(startYear, startMonth),
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            startDay = value;
                            // اگر روز انتخاب شده بیشتر از طول ماه جدید است، آن را محدود کن
                            int maxDay = _getMonthLength(startYear, startMonth);
                            if (startDay > maxDay) {
                              startDay = maxDay;
                            }
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
                    child: SearchableDropdown<int>(
                      value: endYear,
                      decoration: const InputDecoration(labelText: 'سال'),
                      searchHint: 'جستجو...',
                      items: List.generate(
                        10,
                        (index) => DropdownMenuItem(
                          value: year - 1 + index,
                          child: Text('${year - 1 + index}'),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            endYear = value;
                            // اگر روز انتخاب شده بیشتر از طول ماه جدید است، آن را محدود کن
                            int maxDay = _getMonthLength(endYear, endMonth);
                            if (endDay > maxDay) {
                              endDay = maxDay;
                            }
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SearchableDropdown<int>(
                      value: endMonth,
                      decoration: const InputDecoration(labelText: 'ماه'),
                      searchHint: 'جستجو...',
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
                            // اگر روز انتخاب شده بیشتر از طول ماه جدید است، آن را محدود کن
                            int maxDay = _getMonthLength(endYear, endMonth);
                            if (endDay > maxDay) {
                              endDay = maxDay;
                            }
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SearchableDropdown<int>(
                      value: endDay,
                      decoration: const InputDecoration(labelText: 'روز'),
                      searchHint: 'جستجو...',
                      items: List.generate(
                        _getMonthLength(endYear, endMonth),
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            endDay = value;
                            // اگر روز انتخاب شده بیشتر از طول ماه جدید است، آن را محدود کن
                            int maxDay = _getMonthLength(endYear, endMonth);
                            if (endDay > maxDay) {
                              endDay = maxDay;
                            }
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
                      _getSummaryText(),
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
    // اعتبارسنجی: بررسی اینکه بازه معتبر است
    if (startYear > endYear ||
        (startYear == endYear && startMonth > endMonth) ||
        (startYear == endYear && startMonth == endMonth && startDay > endDay)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تاریخ شروع نمی‌تواند بعد از تاریخ پایان باشد'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // اعتبارسنجی: اگر بازه به ماه بعد ادامه می‌دهد، ماه بعد نباید گذشته باشد
    if (endMonth != month || endYear != year) {
      // بازه به ماه بعد ادامه می‌دهد
      int nextMonth, nextYear;
      if (endMonth == 12) {
        nextYear = endYear + 1;
        nextMonth = 1;
      } else {
        nextYear = endYear;
        nextMonth = endMonth + 1;
      }
      
      // بررسی اینکه ماه بعد قابل ویرایش است
      if (!widget.controller.isMonthEditable(nextYear, nextMonth)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('نمی‌توانید بازه را تا ماه گذشته ادامه دهید'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }

    bool success;

    if (widget.period != null && (widget.period!.isCustom == true)) {
      // Edit mode - only if it's already a custom period
      success = await widget.controller.updateMonthPeriod(
        year: year,
        month: month,
        startDay: startDay,
        startMonth: startMonth,
        startYear: startYear,
        endDay: endDay,
        endMonth: endMonth,
        endYear: endYear,
      );
    } else {
      // Create mode - for new periods or editing default periods
      success = await widget.controller.createMonthPeriod(
        year: year,
        month: month,
        startDay: startDay,
        startMonth: startMonth,
        startYear: startYear,
        endDay: endDay,
        endMonth: endMonth,
        endYear: endYear,
      );
    }

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  String _getSummaryText() {
    String startText = '$startDay ${monthNames[startMonth - 1]}';
    if (startYear != year) {
      startText += ' $startYear';
    }
    String endText = '$endDay ${monthNames[endMonth - 1]}';
    if (endYear != year) {
      endText += ' $endYear';
    }
    
    String summary = '$startText تا $endText';
    
    // اگر بازه به ماه بعد ادامه پیدا می‌کند، اطلاعات ماه بعد را نمایش بده
    if (endMonth != month || endYear != year) {
      int nextMonth, nextYear;
      if (endMonth == 12) {
        nextYear = endYear + 1;
        nextMonth = 1;
      } else {
        nextYear = endYear;
        nextMonth = endMonth + 1;
      }
      
      // محاسبه طول ماه بعد (تقریبی)
      int nextMonthLength = 30;
      if (nextMonth <= 6) {
        nextMonthLength = 31;
      } else if (nextMonth == 12) {
        // اسفند - بررسی کبیسه (تقریبی)
        nextMonthLength = 29;
      }
      
      summary += '\n\nماه بعد (${monthNames[nextMonth - 1]} $nextYear):';
      summary += '\nاز ${endDay + 1} ${monthNames[endMonth - 1]} تا $nextMonthLength ${monthNames[nextMonth - 1]}';
      summary += '\n(محاسبه خودکار)';
    }
    
    return summary;
  }
}
