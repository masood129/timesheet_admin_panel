import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/dashboard_settings.dart';

class DashboardItemEditorDialog extends StatefulWidget {
  final DashboardItem item;
  final Function(DashboardItem) onSave;

  const DashboardItemEditorDialog({
    super.key,
    required this.item,
    required this.onSave,
  });

  @override
  State<DashboardItemEditorDialog> createState() =>
      _DashboardItemEditorDialogState();
}

class _DashboardItemEditorDialogState extends State<DashboardItemEditorDialog> {
  late TextEditingController titleController;
  late Color selectedColor;
  late IconData selectedIcon;
  late ChartType? selectedChartType;

  final List<Color> availableColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.amber,
    Colors.indigo,
    Colors.cyan,
  ];

  final List<IconData> availableIcons = [
    Icons.people,
    Icons.work,
    Icons.groups,
    Icons.pending_actions,
    Icons.dashboard,
    Icons.analytics,
    Icons.assessment,
    Icons.bar_chart,
    Icons.pie_chart,
    Icons.show_chart,
    Icons.timeline,
    Icons.leaderboard,
    Icons.trending_up,
    Icons.trending_down,
    Icons.task_alt,
    Icons.schedule,
  ];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.item.title);
    selectedColor = widget.item.color ?? AppTheme.primaryColor;
    selectedIcon = widget.item.icon ?? Icons.dashboard;
    selectedChartType = widget.item.chartType;
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isChart = widget.item.type == DashboardItemType.pieChart ||
        widget.item.type == DashboardItemType.barChart ||
        widget.item.type == DashboardItemType.lineChart;

    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // هدر
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selectedColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    selectedIcon,
                    color: selectedColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ویرایش ویجت',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        _getItemTypeLabel(widget.item.type),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // عنوان
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'عنوان',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 24),

            // انتخاب رنگ
            Text(
              'رنگ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: availableColors.map((color) {
                final isSelected = color.value == selectedColor.value;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 28,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // انتخاب آیکون
            Text(
              'آیکون',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: availableIcons.length,
                itemBuilder: (context, index) {
                  final icon = availableIcons[index];
                  final isSelected = icon.codePoint == selectedIcon.codePoint;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIcon = icon;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? selectedColor.withValues(alpha: 0.2)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? selectedColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? selectedColor : Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),

            // نوع نمودار (فقط برای نمودارها)
            if (isChart) ...[
              const SizedBox(height: 24),
              Text(
                'نوع نمودار',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildChartTypeCard(
                      context,
                      ChartType.pie,
                      Icons.pie_chart,
                      'دایره‌ای',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildChartTypeCard(
                      context,
                      ChartType.bar,
                      Icons.bar_chart,
                      'میله‌ای',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildChartTypeCard(
                      context,
                      ChartType.line,
                      Icons.show_chart,
                      'خطی',
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 32),

            // دکمه‌ها
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('انصراف'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save),
                  label: const Text('ذخیره'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartTypeCard(
    BuildContext context,
    ChartType type,
    IconData icon,
    String label,
  ) {
    final isSelected = selectedChartType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedChartType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withValues(alpha: 0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? selectedColor : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? selectedColor : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    final updatedItem = widget.item.copyWith(
      title: titleController.text,
      color: selectedColor,
      icon: selectedIcon,
      chartType: selectedChartType,
    );

    widget.onSave(updatedItem);
    Navigator.of(context).pop();
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
}

