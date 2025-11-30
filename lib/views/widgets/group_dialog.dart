import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/group_controller.dart';
import '../../data/models/models.dart';
import 'searchable_dropdown.dart';

class GroupDialog extends StatefulWidget {
  final Group? group;

  const GroupDialog({super.key, this.group});

  @override
  State<GroupDialog> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _groupNameController;
  int? _selectedManagerId;

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController(
      text: widget.group?.groupName ?? '',
    );
    if (widget.group != null) {
      _selectedManagerId = widget.group!.managerId;
    }
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
          managerId: _selectedManagerId!,
        );
      } else {
        // Update existing group
        success = await controller.updateGroup(
          widget.group!.groupId,
          _groupNameController.text,
          _selectedManagerId,
        );
      }

      if (success && context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.group != null;
    final controller = Get.find<GroupController>();

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
              const SizedBox(height: 16),

              // Manager Dropdown
              Obx(() {
                if (controller.potentialManagers.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SearchableDropdown<int>(
                  value: _selectedManagerId,
                  decoration: const InputDecoration(
                    labelText: 'مدیر گروه',
                    prefixIcon: Icon(Icons.person),
                  ),
                  searchHint: 'جستجوی مدیر...',
                  items: controller.potentialManagers.map((user) {
                    return DropdownMenuItem<int>(
                      value: user.userId,
                      child: Text('${user.username} (${user.userId})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedManagerId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'انتخاب مدیر گروه الزامی است';
                    }
                    return null;
                  },
                );
              }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
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
