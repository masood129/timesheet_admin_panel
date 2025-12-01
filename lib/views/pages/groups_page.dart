import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/group_controller.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/group_dialog.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GroupController>();

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

                // Add button
                ElevatedButton.icon(
                  onPressed: () => _showGroupDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('گروه جدید'),
                ),
              ],
            ),
          ),

          // Groups list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.groups.isEmpty) {
                return const Center(
                  child: Text('گروهی یافت نشد'),
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
                            flex: 3,
                            child: Text(
                              'نام گروه',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'مدیر گروه',
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
                        itemCount: controller.groups.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final group = controller.groups[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(group.groupId.toString()),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(group.groupName),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(group.managerName ?? '-'),
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
                                        onPressed: () => _showGroupDialog(
                                          context,
                                          group: group,
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
                                          group.groupId,
                                          group.groupName,
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
                            'مجموع: ${controller.totalGroups.value} گروه',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: controller.currentPage.value > 1
                                    ? () => controller.fetchGroups(
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
                                        controller.totalGroups.value
                                    ? () => controller.fetchGroups(
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

  void _showGroupDialog(BuildContext context, {group}) {
    showDialog(
      context: context,
      builder: (context) => GroupDialog(group: group),
    );
  }

  void _confirmDelete(BuildContext context, int groupId, String groupName) {
    Get.dialog(
      AlertDialog(
        title: const Text('تایید حذف'),
        content: Text('آیا از حذف گروه "$groupName" اطمینان دارید؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final controller = Get.find<GroupController>();
              await controller.deleteGroup(groupId);
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
