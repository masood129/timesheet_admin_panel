import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/group_controller.dart';
import '../../data/models/models.dart';

class GroupDialog extends StatefulWidget {
  final Group? group;

  const GroupDialog({super.key, this.group});

  @override
  State<GroupDialog> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _groupNameController;

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController(
      text: widget.group?.groupName ?? '',
    );
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<GroupController>();
      bool success;

      if (widget.group == null) {
        // Create new group
        success = await controller.createGroup(
          groupName: _groupNameController.text,
        );
      } else {
        // Update existing group
        success = await controller.updateGroup(
          widget.group!.groupId,
          _groupNameController.text,
        );
      }

      if (success) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.group != null;

    return AlertDialog(
      title: Text(isEdit ? 'ویرایش گروه' : 'گروه جدید'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Group Name
              TextFormField(
                controller: _groupNameController,
                decoration: const InputDecoration(
                  labelText: 'نام گروه',
                  prefixIcon: Icon(Icons.groups),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'نام گروه الزامی است';
                  }
                  return null;
                },
              ),

              if (isEdit && widget.group!.managerName != null) ...[
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('مدیر گروه'),
                  subtitle: Text(widget.group!.managerName!),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('انصراف'),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: Text(isEdit ? 'ذخیره' : 'ایجاد'),
        ),
      ],
    );
  }
}
