import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/project_controller.dart';
import '../../data/models/models.dart';

class ProjectDialog extends StatefulWidget {
  final Project? project;

  const ProjectDialog({super.key, this.project});

  @override
  State<ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<ProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _projectNameController;
  int _securityLevel = 1;

  @override
  void initState() {
    super.initState();
    _projectNameController = TextEditingController(
      text: widget.project?.projectName ?? '',
    );
    _securityLevel = widget.project?.securityLevel ?? 1;
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<ProjectController>();
      bool success;

      if (widget.project == null) {
        // Create new project
        success = await controller.createProject(
          projectName: _projectNameController.text,
          securityLevel: _securityLevel,
        );
      } else {
        // Update existing project
        success = await controller.updateProject(
          widget.project!.id,
          _projectNameController.text,
          _securityLevel,
        );
      }

      if (success) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.project != null;

    return AlertDialog(
      title: Text(isEdit ? 'ویرایش پروژه' : 'پروژه جدید'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Project Name
              TextFormField(
                controller: _projectNameController,
                decoration: const InputDecoration(
                  labelText: 'نام پروژه',
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'نام پروژه الزامی است';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Security Level
              DropdownButtonFormField<int>(
                value: _securityLevel,
                decoration: const InputDecoration(
                  labelText: 'سطح امنیتی',
                  prefixIcon: Icon(Icons.security),
                ),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('سطح 1 - عمومی')),
                  DropdownMenuItem(value: 2, child: Text('سطح 2 - محرمانه')),
                  DropdownMenuItem(
                      value: 3, child: Text('سطح 3 - بسیار محرمانه')),
                ],
                onChanged: (value) {
                  setState(() {
                    _securityLevel = value!;
                  });
                },
              ),
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
