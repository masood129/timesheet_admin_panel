import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/dashboard_settings.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final settingsController = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value ||
            settingsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = controller.statistics.value;
        final settings = settingsController.dashboardSettings.value;

        if (stats == null) {
          return const Center(child: Text('خطا در دریافت اطلاعات'));
        }

        if (settings == null) {
          return const Center(child: Text('خطا در بارگذاری تنظیمات'));
        }

        return RefreshIndicator(
          onRefresh: () async => controller.refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistics Cards
                _buildStatisticsGrid(context, stats, settings),

                const SizedBox(height: 24),

                // Charts and Other Widgets
                _buildChartsAndWidgets(context, stats, settings),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatisticsGrid(
    BuildContext context,
    dynamic stats,
    DashboardSettings settings,
  ) {
    final statCards = settings.statCards;

    if (statCards.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: statCards.length >= 4 ? 4 : statCards.length,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: statCards.length,
      itemBuilder: (context, index) {
        final item = statCards[index];
        final value = _getStatValue(stats, item.customData?['dataKey']);
        return _buildStatCard(
          context,
          title: item.title,
          value: value.toString(),
          icon: item.icon ?? Icons.dashboard,
          color: item.color ?? AppTheme.primaryColor,
        );
      },
    );
  }

  Widget _buildChartsAndWidgets(
    BuildContext context,
    dynamic stats,
    DashboardSettings settings,
  ) {
    final widgets = settings.visibleItems
        .where((item) => item.type != DashboardItemType.statCard)
        .toList();

    if (widgets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: widgets.map((item) {
        switch (item.type) {
          case DashboardItemType.pieChart:
          case DashboardItemType.barChart:
          case DashboardItemType.lineChart:
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildChartWidget(context, stats, item),
            );
          case DashboardItemType.reportStatus:
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildReportStatusWidget(context, stats, item),
            );
          case DashboardItemType.recentActivity:
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildRecentActivityWidget(context, stats, item),
            );
          default:
            return const SizedBox.shrink();
        }
      }).toList(),
    );
  }

  Widget _buildChartWidget(
    BuildContext context,
    dynamic stats,
    DashboardItem item,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (item.color ?? Colors.blue).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getChartIcon(item.chartType ?? ChartType.pie),
                        size: 16,
                        color: item.color ?? Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getChartTypeLabel(item.chartType ?? ChartType.pie),
                        style: TextStyle(
                          fontSize: 12,
                          color: item.color ?? Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: _buildChart(context, stats, item),
            ),
            const SizedBox(height: 16),
            _buildChartLegend(context, stats),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(
    BuildContext context,
    dynamic stats,
    DashboardItem item,
  ) {
    final chartType = item.chartType ?? ChartType.pie;

    switch (chartType) {
      case ChartType.pie:
        return _buildPieChart(stats);
      case ChartType.bar:
        return _buildBarChart(stats);
      case ChartType.line:
        return _buildLineChart(stats);
    }
  }

  Widget _buildPieChart(dynamic stats) {
    return PieChart(
      PieChartData(
        sections: stats.usersByRole.map<PieChartSectionData>((role) {
          return PieChartSectionData(
            value: role.count.toDouble(),
            title: '${role.count}',
            color: _getRoleColor(role.role),
            radius: 100,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildBarChart(dynamic stats) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: stats.usersByRole
            .map((role) => role.count)
            .reduce((a, b) => a > b ? a : b)
            .toDouble() * 1.2,
        barGroups: stats.usersByRole.asMap().entries.map<BarChartGroupData>((entry) {
          final index = entry.key;
          final role = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: role.count.toDouble(),
                color: _getRoleColor(role.role),
                width: 40,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= stats.usersByRole.length) return const Text('');
                final role = stats.usersByRole[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _getRoleLabel(role.role),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildLineChart(dynamic stats) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= stats.usersByRole.length) return const Text('');
                final role = stats.usersByRole[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _getRoleLabel(role.role),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: stats.usersByRole.asMap().entries.map<FlSpot>((entry) {
              return FlSpot(
                entry.key.toDouble(),
                entry.value.count.toDouble(),
              );
            }).toList(),
            isCurved: true,
            color: AppTheme.primaryColor,
            barWidth: 4,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: Colors.white,
                  strokeWidth: 3,
                  strokeColor: AppTheme.primaryColor,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(BuildContext context, dynamic stats) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: stats.usersByRole.map<Widget>((role) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _getRoleColor(role.role),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(_getRoleLabel(role.role)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildReportStatusWidget(
    BuildContext context,
    dynamic stats,
    DashboardItem item,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            _buildReportStatusItem(
              context,
              'گزارش‌های تایید شده',
              stats.approvedReports,
              Colors.green,
            ),
            const SizedBox(height: 16),
            _buildReportStatusItem(
              context,
              'گزارش‌های در انتظار',
              stats.pendingReports,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityWidget(
    BuildContext context,
    dynamic stats,
    DashboardItem item,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  item.icon ?? Icons.schedule,
                  color: item.color ?? AppTheme.primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'فعالیت اخیر (30 روز)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${stats.recentActivityCount} رکورد',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: item.color ?? AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 32),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportStatusItem(
    BuildContext context,
    String title,
    int count,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title),
        ),
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  int _getStatValue(dynamic stats, String? dataKey) {
    switch (dataKey) {
      case 'totalUsers':
        return stats.totalUsers;
      case 'totalProjects':
        return stats.totalProjects;
      case 'totalGroups':
        return stats.totalGroups;
      case 'pendingReports':
        return stats.pendingReports;
      case 'approvedReports':
        return stats.approvedReports;
      case 'recentActivityCount':
        return stats.recentActivityCount;
      default:
        return 0;
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.purple;
      case 'general_manager':
        return Colors.blue;
      case 'finance_manager':
        return Colors.green;
      case 'group_manager':
        return Colors.orange;
      case 'user':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'admin':
        return 'ادمین';
      case 'general_manager':
        return 'مدیر کل';
      case 'finance_manager':
        return 'مدیر مالی';
      case 'group_manager':
        return 'مدیر گروه';
      case 'user':
        return 'کاربر';
      default:
        return role;
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
