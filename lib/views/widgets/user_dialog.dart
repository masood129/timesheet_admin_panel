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
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _arrivalTimeController;
  late TextEditingController _leaveTimeController;
  late TextEditingController _minHoursController;
  
  String _selectedRole = 'user';
  int? _selectedGroupId;
  int? _selectedDirectAdminId;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController(
      text: widget.user?.userId.toString() ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.user?.username ?? '',
    );
    _firstNameController = TextEditingController(
      text: widget.user?.farsifirstname ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.user?.farsilastname ?? '',
    );
    _emailController = TextEditingController(
      text: widget.user?.email ?? '',
    );
    _arrivalTimeController = TextEditingController(
      text: widget.user?.contractArrivalTime ?? '',
    );
    _leaveTimeController = TextEditingController(
      text: widget.user?.contractLeaveTime ?? '',
    );
    _minHoursController = TextEditingController(
      text: widget.user?.minMonthlyHours?.toString() ?? '',
    );
    
    _selectedRole = widget.user?.role ?? 'user';
    _selectedGroupId = widget.user?.groupId;
    _selectedDirectAdminId = widget.user?.directAdminid;
    _isActive = widget.user?.isActive ?? true;
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _arrivalTimeController.dispose();
    _leaveTimeController.dispose();
    _minHoursController.dispose();
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
        // Update existing user - send all editable fields
        final updateData = <String, dynamic>{
          'Username': _usernameController.text,
          'Role': _selectedRole,
          'farsifirstname': _firstNameController.text.isEmpty ? null : _firstNameController.text,
          'farsilastname': _lastNameController.text.isEmpty ? null : _lastNameController.text,
          'email': _emailController.text.isEmpty ? null : _emailController.text,
          'groupid': _selectedGroupId,
          'IsActive': _isActive,
          'directAdminid': _selectedDirectAdminId,
          'ContractArrivalTime': _arrivalTimeController.text.isEmpty ? null : _arrivalTimeController.text,
          'ContractLeaveTime': _leaveTimeController.text.isEmpty ? null : _leaveTimeController.text,
          'MinMonthlyHours': _minHoursController.text.isEmpty ? null : int.tryParse(_minHoursController.text),
        };
        
        success = await controller.updateUser(
          widget.user!.userId,
          updateData,
        );
      }

      if (success) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;
    final controller = Get.find<UserController>();

    return AlertDialog(
      title: Text(isEdit ? 'ویرایش کاربر' : 'کاربر جدید'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 600,
          child: SingleChildScrollView(
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

                if (isEdit) ...[
                  const SizedBox(height: 16),

                  // First Name (Persian)
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'نام (فارسی)',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Last Name (Persian)
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'نام خانوادگی (فارسی)',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'ایمیل',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),
                ],

                // Role
                DropdownButtonFormField<String>(
                  value: _selectedRole,
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

                if (isEdit) ...[
                  const SizedBox(height: 16),

                  // Group
                  Obx(() => DropdownButtonFormField<int>(
                        value: _selectedGroupId,
                        decoration: const InputDecoration(
                          labelText: 'گروه',
                          prefixIcon: Icon(Icons.group),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('بدون گروه'),
                          ),
                          ...controller.allGroups.map(
                            (group) => DropdownMenuItem(
                              value: group.groupId,
                              child: Text(group.groupName),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedGroupId = value;
                          });
                        },
                      )),

                  const SizedBox(height: 16),

                  // Direct Admin
                  Obx(() => DropdownButtonFormField<int>(
                        value: _selectedDirectAdminId,
                        decoration: const InputDecoration(
                          labelText: 'مدیر مستقیم',
                          prefixIcon: Icon(Icons.supervised_user_circle),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('بدون مدیر مستقیم'),
                          ),
                          ...controller.allAdmins
                              .where((u) => u.userId != widget.user?.userId)
                              .map(
                                (admin) => DropdownMenuItem(
                                  value: admin.userId,
                                  child: Text('${admin.fullName} (${admin.username})'),
                                ),
                              ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedDirectAdminId = value;
                          });
                        },
                      )),

                  const SizedBox(height: 16),

                  // Active Status
                  SwitchListTile(
                    title: const Text('وضعیت فعال'),
                    subtitle: Text(_isActive ? 'فعال' : 'غیرفعال'),
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Contract Arrival Time
                  TextFormField(
                    controller: _arrivalTimeController,
                    decoration: const InputDecoration(
                      labelText: 'ساعت ورود قراردادی (مثال: 09:00)',
                      prefixIcon: Icon(Icons.access_time),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Contract Leave Time
                  TextFormField(
                    controller: _leaveTimeController,
                    decoration: const InputDecoration(
                      labelText: 'ساعت خروج قراردادی (مثال: 17:00)',
                      prefixIcon: Icon(Icons.access_time_filled),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Minimum Monthly Hours
                  TextFormField(
                    controller: _minHoursController,
                    decoration: const InputDecoration(
                      labelText: 'حداقل ساعات ماهانه',
                      prefixIcon: Icon(Icons.timelapse),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ],
            ),
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
