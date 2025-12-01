import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/user_dialog.dart';
import '../widgets/searchable_dropdown.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Toolbar
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // Search
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'جستجو...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      // Debounce search
                      Future.delayed(const Duration(milliseconds: 500), () {
                        controller.setSearchQuery(value);
                      });
                    },
                  ),
                ),

                const SizedBox(width: 16),

                // Role filter
                Expanded(
                  child: Obx(() => SearchableDropdown<String>(
                        value: controller.selectedRole.value,
                        decoration: const InputDecoration(
                          labelText: 'فیلتر نقش',
                          prefixIcon: Icon(Icons.filter_list),
                        ),
                        searchHint: 'جستجوی نقش...',
                        items: const [
                          DropdownMenuItem(value: null, child: Text('همه')),
                          DropdownMenuItem(
                              value: 'admin', child: Text('ادمین')),
                          DropdownMenuItem(
                              value: 'general_manager', child: Text('مدیر کل')),
                          DropdownMenuItem(
                              value: 'finance_manager',
                              child: Text('مدیر مالی')),
                          DropdownMenuItem(
                              value: 'group_manager', child: Text('مدیر گروه')),
                          DropdownMenuItem(value: 'user', child: Text('کاربر')),
                        ],
                        onChanged: (value) => controller.setRoleFilter(value),
                      )),
                ),

                const SizedBox(width: 16),

                // Add button
                ElevatedButton.icon(
                  onPressed: () => _showUserDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('کاربر جدید'),
                ),
              ],
            ),
          ),

          // Users list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.users.isEmpty) {
                return const Center(
                  child: Text('کاربری یافت نشد'),
                );
              }

              return Card(
                margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    // Table header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'شناسه',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'نام کاربری',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'نقش',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'گروه',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'عملیات',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Table rows
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.users.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final user = controller.users[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(user.userId.toString()),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(user.username),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: _buildRoleBadge(user.role),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(user.groupName ?? '-'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 18),
                                        iconSize: 18,
                                        padding: const EdgeInsets.all(8),
                                        constraints: const BoxConstraints(),
                                        onPressed: () => _showUserDialog(
                                          context,
                                          user: user,
                                        ),
                                        tooltip: 'ویرایش',
                                      ),
                                      IconButton(
                                        icon:
                                            const Icon(Icons.delete, size: 18),
                                        iconSize: 18,
                                        padding: const EdgeInsets.all(8),
                                        constraints: const BoxConstraints(),
                                        color: Colors.red,
                                        onPressed: () => _confirmDelete(
                                          context,
                                          user.userId,
                                          user.username,
                                        ),
                                        tooltip: 'حذف',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Pagination
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'مجموع: ${controller.totalUsers.value} کاربر',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: controller.currentPage.value > 1
                                    ? () => controller.fetchUsers(
                                          page:
                                              controller.currentPage.value - 1,
                                        )
                                    : null,
                              ),
                              Text(
                                'صفحه ${controller.currentPage.value}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: controller.currentPage.value * 20 <
                                        controller.totalUsers.value
                                    ? () => controller.fetchUsers(
                                          page:
                                              controller.currentPage.value + 1,
                                        )
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color color;
    String label;

    switch (role) {
      case 'admin':
        color = Colors.purple;
        label = 'ادمین';
        break;
      case 'general_manager':
        color = Colors.blue;
        label = 'مدیر کل';
        break;
      case 'finance_manager':
        color = Colors.green;
        label = 'مدیر مالی';
        break;
      case 'group_manager':
        color = Colors.orange;
        label = 'مدیر گروه';
        break;
      case 'user':
        color = Colors.grey;
        label = 'کاربر';
        break;
      default:
        color = Colors.grey;
        label = role;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showUserDialog(BuildContext context, {user}) {
    showDialog(
      context: context,
      builder: (context) => UserDialog(user: user),
    );
  }

  void _confirmDelete(BuildContext context, int userId, String username) {
    Get.dialog(
      AlertDialog(
        title: const Text('تایید حذف'),
        content: Text('آیا از حذف کاربر "$username" اطمینان دارید؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final controller = Get.find<UserController>();
              await controller.deleteUser(userId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
