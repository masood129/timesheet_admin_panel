import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../data/models/models.dart';

class UserDialog extends StatefulWidget {
  final User? user;

  const UserDialog({super.key, this.user});

  @override
  State<UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userIdController;
  late TextEditingController _usernameController;
  String _selectedRole = 'user';

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController(
      text: widget.user?.userId.toString() ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.user?.username ?? '',
    );
    _selectedRole = widget.user?.role ?? 'user';
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<UserController>();
      bool success;

      if (widget.user == null) {
        // Create new user
        success = await controller.createUser(
          userId: int.parse(_userIdController.text),
          username: _usernameController.text,
          role: _selectedRole,
        );
      } else {
        // Update existing user
        if (_selectedRole != widget.user!.role) {
          // Update role
          success = await controller.updateUserRole(
            widget.user!.userId,
            _selectedRole,
          );
        } else {
          // Update username
          success = await controller.updateUser(
            widget.user!.userId,
            _usernameController.text,
          );
        }
      }

      if (success) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;

    return AlertDialog(
      title: Text(isEdit ? 'ویرایش کاربر' : 'کاربر جدید'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // User ID
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(
                  labelText: 'شناسه کاربر',
                  prefixIcon: Icon(Icons.tag),
                ),
                keyboardType: TextInputType.number,
                enabled: !isEdit, // Can't change ID in edit mode
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'شناسه کاربر الزامی است';
                  }
                  if (int.tryParse(value) == null) {
                    return 'شناسه باید عدد باشد';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Username
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'نام کاربری',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'نام کاربری الزامی است';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Role
              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'نقش',
                  prefixIcon: Icon(Icons.admin_panel_settings),
                ),
                items: const [
                  DropdownMenuItem(value: 'user', child: Text('کاربر')),
                  DropdownMenuItem(
                      value: 'group_manager', child: Text('مدیر گروه')),
                  DropdownMenuItem(
                      value: 'general_manager', child: Text('مدیر کل')),
                  DropdownMenuItem(
                      value: 'finance_manager', child: Text('مدیر مالی')),
                  DropdownMenuItem(value: 'admin', child: Text('ادمین')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
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
