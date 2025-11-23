class MonthPeriodModel {
  final int year;
  final int month;
  final int startDay;
  final int startMonth;
  final int endDay;
  final int endMonth;
  final bool?
      isCustom; // Optional: indicates if this is a custom setting or default

  MonthPeriodModel({
    required this.year,
    required this.month,
    required this.startDay,
    required this.startMonth,
    required this.endDay,
    required this.endMonth,
    this.isCustom,
  });

  factory MonthPeriodModel.fromJson(Map<String, dynamic> json) {
    return MonthPeriodModel(
      year: json['Year'] ?? json['year'],
      month: json['Month'] ?? json['month'],
      startDay: json['StartDay'] ?? json['startDay'],
      startMonth: json['StartMonth'] ?? json['startMonth'],
      endDay: json['EndDay'] ?? json['endDay'],
      endMonth: json['EndMonth'] ?? json['endMonth'],
      isCustom: json['IsCustom'] ?? json['isCustom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Year': year,
      'Month': month,
      'StartDay': startDay,
      'StartMonth': startMonth,
      'EndDay': endDay,
      'EndMonth': endMonth,
      if (isCustom != null) 'IsCustom': isCustom,
    };
  }

  /// Helper: Get month name in Persian
  String get monthName {
    const monthNames = [
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
      'اسفند'
    ];
    return monthNames[month - 1];
  }

  /// Helper: Get start month name
  String get startMonthName {
    const monthNames = [
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
      'اسفند'
    ];
    return monthNames[startMonth - 1];
  }

  /// Helper: Get end month name
  String get endMonthName {
    const monthNames = [
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
      'اسفند'
    ];
    return monthNames[endMonth - 1];
  }

  /// Helper: Format period as readable string
  String get periodDisplay {
    return '$startDay $startMonthName تا $endDay $endMonthName';
  }

  @override
  String toString() {
    return 'MonthPeriodModel(year: $year, month: $month, period: $periodDisplay, isCustom: $isCustom)';
  }
}
