import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/project_controller.dart';
import '../../data/models/models.dart';
import '../../data/services/api_service.dart';

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
  late TextEditingController _financeCenterCostController;
  late TextEditingController _baseCenterCostController;
  late TextEditingController _bLineController;
  late TextEditingController _systemTypeController;
  late TextEditingController _contractTypeController;
  late TextEditingController _centerTypeController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _projectIdController = TextEditingController(
      text: widget.project?.id.toString() ?? '',
    );
    _projectNameController = TextEditingController(
      text: widget.project?.projectName ?? '',
    );
    _financeCenterCostController = TextEditingController(
      text: widget.project?.financeCenterCost?.toString() ?? '',
    );
    _baseCenterCostController = TextEditingController(
      text: widget.project?.baseCenterCost ?? '',
    );
    _bLineController = TextEditingController(
      text: widget.project?.bLine ?? '',
    );
    _systemTypeController = TextEditingController(
      text: widget.project?.systemType ?? '',
    );
    _contractTypeController = TextEditingController(
      text: widget.project?.contractType ?? '',
    );
    _centerTypeController = TextEditingController(
      text: widget.project?.centerType ?? '',
    );
    _isActive = widget.project?.isActive ?? true;
  }

  @override
  void dispose() {
    _projectIdController.dispose();
    _projectNameController.dispose();
    _financeCenterCostController.dispose();
    _baseCenterCostController.dispose();
    _bLineController.dispose();
    _systemTypeController.dispose();
    _contractTypeController.dispose();
    _centerTypeController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<ProjectController>();
      bool success;

      final financeCenterCost = _financeCenterCostController.text.isEmpty
          ? null
          : int.tryParse(_financeCenterCostController.text);

      if (widget.project == null) {
        // Create new project
        success = await controller.createProject(
          id: int.parse(_projectIdController.text),
          projectName: _projectNameController.text.isEmpty 
              ? null 
              : _projectNameController.text,
          isActive: _isActive,
          financeCenterCost: financeCenterCost,
          baseCenterCost: _baseCenterCostController.text.isEmpty 
              ? null 
              : _baseCenterCostController.text,
          bLine: _bLineController.text.isEmpty 
              ? null 
              : _bLineController.text,
          systemType: _systemTypeController.text.isEmpty 
              ? null 
              : _systemTypeController.text,
          contractType: _contractTypeController.text.isEmpty 
              ? null 
              : _contractTypeController.text,
          centerType: _centerTypeController.text.isEmpty 
              ? null 
              : _centerTypeController.text,
        );
      } else {
        // Update existing project
        success = await controller.updateProject(
          widget.project!.id,
          newId: int.parse(_projectIdController.text),
          projectName: _projectNameController.text.isEmpty 
              ? null 
              : _projectNameController.text,
          isActive: _isActive,
          financeCenterCost: financeCenterCost,
          baseCenterCost: _baseCenterCostController.text.isEmpty 
              ? null 
              : _baseCenterCostController.text,
          bLine: _bLineController.text.isEmpty 
              ? null 
              : _bLineController.text,
          systemType: _systemTypeController.text.isEmpty 
              ? null 
              : _systemTypeController.text,
          contractType: _contractTypeController.text.isEmpty 
              ? null 
              : _contractTypeController.text,
          centerType: _centerTypeController.text.isEmpty 
              ? null 
              : _centerTypeController.text,
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
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Project ID
                TextFormField(
                  controller: _projectIdController,
                  decoration: const InputDecoration(
                    labelText: 'کد پروژه *',
                    prefixIcon: Icon(Icons.tag),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'کد پروژه الزامی است';
                    }
                    if (int.tryParse(value) == null) {
                      return 'کد باید عدد باشد';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Project Name
                TextFormField(
                  controller: _projectNameController,
                  decoration: const InputDecoration(
                    labelText: 'نام پروژه',
                    prefixIcon: Icon(Icons.work),
                  ),
                ),

                const SizedBox(height: 16),

                // Finance Center Cost
                TextFormField(
                  controller: _financeCenterCostController,
                  decoration: const InputDecoration(
                    labelText: 'هزینه مرکز مالی',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (int.tryParse(value) == null) {
                        return 'مقدار باید عدد باشد';
                      }
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Base Center Cost
                TextFormField(
                  controller: _baseCenterCostController,
                  decoration: const InputDecoration(
                    labelText: 'هزینه مرکز پایه',
                    prefixIcon: Icon(Icons.account_balance),
                  ),
                  maxLength: 50,
                ),

                const SizedBox(height: 16),

                // BLine
                TextFormField(
                  controller: _bLineController,
                  decoration: const InputDecoration(
                    labelText: 'BLine',
                    prefixIcon: Icon(Icons.linear_scale),
                  ),
                  maxLength: 50,
                ),

                const SizedBox(height: 16),

                // System Type
                TextFormField(
                  controller: _systemTypeController,
                  decoration: const InputDecoration(
                    labelText: 'نوع سیستم',
                    prefixIcon: Icon(Icons.computer),
                  ),
                  maxLength: 50,
                ),

                const SizedBox(height: 16),

                // Contract Type
                TextFormField(
                  controller: _contractTypeController,
                  decoration: const InputDecoration(
                    labelText: 'نوع قرارداد',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLength: 50,
                ),

                const SizedBox(height: 16),

                // Center Type
                TextFormField(
                  controller: _centerTypeController,
                  decoration: const InputDecoration(
                    labelText: 'نوع مرکز',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  maxLength: 50,
                ),

                const SizedBox(height: 16),

                // Active/Inactive Status
                SwitchListTile(
                  title: const Text('وضعیت پروژه'),
                  subtitle: Text(_isActive ? 'فعال' : 'غیرفعال'),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                  secondary: Icon(
                    _isActive ? Icons.check_circle : Icons.cancel,
                    color: _isActive ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
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
