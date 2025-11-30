import 'package:flutter/material.dart';

enum DashboardItemType {
  statCard,
  pieChart,
  barChart,
  lineChart,
  reportStatus,
  recentActivity,
}

enum ChartType {
  pie,
  bar,
  line,
}

class DashboardItem {
  final String id;
  final String title;
  final DashboardItemType type;
  final bool isVisible;
  final int order;
  final Color? color;
  final IconData? icon;
  final ChartType? chartType;
  final Map<String, dynamic>? customData;

  DashboardItem({
    required this.id,
    required this.title,
    required this.type,
    this.isVisible = true,
    this.order = 0,
    this.color,
    this.icon,
    this.chartType,
    this.customData,
  });

  DashboardItem copyWith({
    String? id,
    String? title,
    DashboardItemType? type,
    bool? isVisible,
    int? order,
    Color? color,
    IconData? icon,
    ChartType? chartType,
    Map<String, dynamic>? customData,
  }) {
    return DashboardItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      isVisible: isVisible ?? this.isVisible,
      order: order ?? this.order,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      chartType: chartType ?? this.chartType,
      customData: customData ?? this.customData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.toString(),
      'isVisible': isVisible,
      'order': order,
      'color': color?.value,
      'iconCodePoint': icon?.codePoint,
      'chartType': chartType?.toString(),
      'customData': customData,
    };
  }

  factory DashboardItem.fromJson(Map<String, dynamic> json) {
    return DashboardItem(
      id: json['id'],
      title: json['title'],
      type: DashboardItemType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => DashboardItemType.statCard,
      ),
      isVisible: json['isVisible'] ?? true,
      order: json['order'] ?? 0,
      color: json['color'] != null ? Color(json['color']) : null,
      icon: json['iconCodePoint'] != null
          ? IconData(json['iconCodePoint'], fontFamily: 'MaterialIcons')
          : null,
      chartType: json['chartType'] != null
          ? ChartType.values.firstWhere(
              (e) => e.toString() == json['chartType'],
              orElse: () => ChartType.pie,
            )
          : null,
      customData: json['customData'],
    );
  }
}

class DashboardSettings {
  final List<DashboardItem> items;
  final DateTime lastModified;

  DashboardSettings({
    required this.items,
    DateTime? lastModified,
  }) : lastModified = lastModified ?? DateTime.now();

  DashboardSettings copyWith({
    List<DashboardItem>? items,
    DateTime? lastModified,
  }) {
    return DashboardSettings(
      items: items ?? this.items,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'lastModified': lastModified.toIso8601String(),
    };
  }

  factory DashboardSettings.fromJson(Map<String, dynamic> json) {
    return DashboardSettings(
      items: (json['items'] as List)
          .map((item) => DashboardItem.fromJson(item))
          .toList(),
      lastModified: DateTime.parse(json['lastModified']),
    );
  }

  // پیش‌فرض‌های سیستم
  factory DashboardSettings.defaultSettings() {
    return DashboardSettings(
      items: [
        DashboardItem(
          id: 'total_users',
          title: 'کل کاربران',
          type: DashboardItemType.statCard,
          order: 0,
          color: Colors.blue,
          icon: Icons.people,
          customData: {'dataKey': 'totalUsers'},
        ),
        DashboardItem(
          id: 'total_projects',
          title: 'کل پروژه‌ها',
          type: DashboardItemType.statCard,
          order: 1,
          color: Colors.green,
          icon: Icons.work,
          customData: {'dataKey': 'totalProjects'},
        ),
        DashboardItem(
          id: 'total_groups',
          title: 'کل گروه‌ها',
          type: DashboardItemType.statCard,
          order: 2,
          color: Colors.orange,
          icon: Icons.groups,
          customData: {'dataKey': 'totalGroups'},
        ),
        DashboardItem(
          id: 'pending_reports',
          title: 'گزارش‌های در انتظار',
          type: DashboardItemType.statCard,
          order: 3,
          color: Colors.red,
          icon: Icons.pending_actions,
          customData: {'dataKey': 'pendingReports'},
        ),
        DashboardItem(
          id: 'users_by_role',
          title: 'توزیع کاربران بر اساس نقش',
          type: DashboardItemType.pieChart,
          order: 4,
          chartType: ChartType.pie,
          customData: {'dataKey': 'usersByRole'},
        ),
        DashboardItem(
          id: 'report_status',
          title: 'وضعیت گزارش‌ها',
          type: DashboardItemType.reportStatus,
          order: 5,
          customData: {
            'dataKeys': ['approvedReports', 'pendingReports'],
          },
        ),
        DashboardItem(
          id: 'recent_activity',
          title: 'فعالیت اخیر',
          type: DashboardItemType.recentActivity,
          order: 6,
          color: Colors.purple,
          customData: {'dataKey': 'recentActivityCount'},
        ),
      ],
    );
  }

  List<DashboardItem> get visibleItems {
    return items.where((item) => item.isVisible).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  List<DashboardItem> get statCards {
    return visibleItems
        .where((item) => item.type == DashboardItemType.statCard)
        .toList();
  }

  List<DashboardItem> get charts {
    return visibleItems
        .where((item) =>
            item.type == DashboardItemType.pieChart ||
            item.type == DashboardItemType.barChart ||
            item.type == DashboardItemType.lineChart)
        .toList();
  }
}

