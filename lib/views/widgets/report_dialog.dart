import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../controllers/report_controller.dart';
import '../../data/models/models.dart';

class ReportDialog extends StatefulWidget {
  final MonthlyReport report;

  const ReportDialog({super.key, required this.report});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final _commentController = TextEditingController();
  String? _selectedAction;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleApprove() async {
    if (_selectedAction == null) {
      showCustomSnackbar('خطا', 'لطفا یک عملیات انتخاب کنید', isError: true);
      return;
    }

    final controller = Get.find<ReportController>();
    final success = await controller.approveReport(
      widget.report.reportId,
      _selectedAction!,
      _commentController.text,
    );

    if (success && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('جزئیات گزارش'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('کاربر', widget.report.username ?? '-'),
              _buildInfoRow(
                'تاریخ',
                '${widget.report.jalaliYear}/${widget.report.jalaliMonth}',
              ),
              _buildInfoRow(
                'مجموع ساعات',
                '${widget.report.totalHours} ساعت',
              ),
              _buildInfoRow(
                'هزینه باشگاه',
                '${widget.report.gymCost} تومان',
              ),
              _buildInfoRow('وضعیت', widget.report.statusDisplay),

              if (widget.report.managerComment != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'نظر مدیر:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(widget.report.managerComment!),
              ],

              if (widget.report.financeComment != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'نظر مالی:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(widget.report.financeComment!),
              ],

              const Divider(height: 32),

              // Action selector
              DropdownButtonFormField<String>(
                initialValue: _selectedAction,
                decoration: const InputDecoration(
                  labelText: 'عملیات',
                  prefixIcon: Icon(Icons.check_circle),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'approved',
                    child: Text('تایید'),
                  ),
                  DropdownMenuItem(
                    value: 'rejected',
                    child: Text('رد'),
                  ),
                  DropdownMenuItem(
                    value: 'submitted_to_general_manager',
                    child: Text('ارسال به مدیر کل'),
                  ),
                  DropdownMenuItem(
                    value: 'submitted_to_finance',
                    child: Text('ارسال به مالی'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedAction = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Comment
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'نظر (اختیاری)',
                  prefixIcon: Icon(Icons.comment),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('بستن'),
        ),
        ElevatedButton(
          onPressed: _handleApprove,
          child: const Text('اعمال'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
