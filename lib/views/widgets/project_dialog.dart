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
  late TextEditingController _projectIdController;
  late TextEditingController _projectNameController;

  @override
  void initState() {
    super.initState();
    _projectIdController = TextEditingController();
    _projectNameController = TextEditingController(
      text: widget.project?.projectName ?? '',
    );
  }

  @override
  void dispose() {
    _projectIdController.dispose();
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
          id: int.parse(_projectIdController.text),
          projectName: _projectNameController.text,
        );
      } else {
        // Update existing project
        success = await controller.updateProject(
          widget.project!.id,
          _projectNameController.text,
        );
      }

      if (success && context.mounted) {
        Navigator.of(context).pop();
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
              // Project ID (only for new projects)
              if (!isEdit)
                TextFormField(
                  controller: _projectIdController,
                  decoration: const InputDecoration(
                    labelText: 'شناسه پروژه',
                    prefixIcon: Icon(Icons.tag),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'شناسه پروژه الزامی است';
                    }
                    if (int.tryParse(value) == null) {
                      return 'شناسه باید عدد باشد';
                    }
                    return null;
                  },
                ),

              if (!isEdit) const SizedBox(height: 16),

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
