class MonthPeriodModel {
  final int year;
  final int month;
  final int startDay;
  final int startMonth;
  final int startYear;
  final int endDay;
  final int endMonth;
  final int endYear;
  final bool?
      isCustom; // Optional: indicates if this is a custom setting or default

  MonthPeriodModel({
    required this.year,
    required this.month,
    required this.startDay,
    required this.startMonth,
    required this.startYear,
    required this.endDay,
    required this.endMonth,
    required this.endYear,
    this.isCustom,
  });

  factory MonthPeriodModel.fromJson(Map<String, dynamic> json) {
    return MonthPeriodModel(
      year: json['Year'] ?? json['year'],
      month: json['Month'] ?? json['month'],
      startDay: json['StartDay'] ?? json['startDay'],
      startMonth: json['StartMonth'] ?? json['startMonth'],
      startYear: json['StartYear'] ?? json['startYear'] ?? json['Year'] ?? json['year'],
      endDay: json['EndDay'] ?? json['endDay'],
      endMonth: json['EndMonth'] ?? json['endMonth'],
      endYear: json['EndYear'] ?? json['endYear'] ?? json['Year'] ?? json['year'],
      isCustom: json['IsCustom'] ?? json['isCustom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Year': year,
      'Month': month,
      'StartDay': startDay,
      'StartMonth': startMonth,
      'StartYear': startYear,
      'EndDay': endDay,
      'EndMonth': endMonth,
      'EndYear': endYear,
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
    String startDisplay = '$startDay $startMonthName';
    if (startYear != year) {
      startDisplay += ' $startYear';
    }
    String endDisplay = '$endDay $endMonthName';
    if (endYear != year) {
      endDisplay += ' $endYear';
    }
    return '$startDisplay تا $endDisplay';
  }

  @override
  String toString() {
    return 'MonthPeriodModel(year: $year, month: $month, period: $periodDisplay, isCustom: $isCustom)';
  }
}
