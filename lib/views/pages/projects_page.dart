import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/project_controller.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/project_dialog.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProjectController>();

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
                      hintText: 'جستجو بر اساس کد یا نام پروژه...',
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
                  onPressed: () => _showProjectDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('پروژه جدید'),
                ),
              ],
            ),
          ),

          // Projects list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.projects.isEmpty) {
                return const Center(
                  child: Text('پروژه‌ای یافت نشد'),
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
                              'نام پروژه',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'وضعیت',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
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
                        itemCount: controller.projects.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final project = controller.projects[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(project.id.toString()),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(project.projectName),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: project.isActive
                                              ? Colors.green.shade100
                                              : Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          project.isActive ? 'فعال' : 'غیرفعال',
                                          style: TextStyle(
                                            color: project.isActive
                                                ? Colors.green.shade800
                                                : Colors.grey.shade700,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () => _showProjectDialog(
                                          context,
                                          project: project,
                                        ),
                                        tooltip: 'ویرایش',
                                      ),
                                      IconButton(
                                        icon:
                                            const Icon(Icons.delete, size: 20),
                                        color: Colors.red,
                                        onPressed: () => _confirmDelete(
                                          context,
                                          project.id,
                                          project.projectName,
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
                            'مجموع: ${controller.totalProjects.value} پروژه',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: controller.currentPage.value > 1
                                    ? () => controller.fetchProjects(
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
                                        controller.totalProjects.value
                                    ? () => controller.fetchProjects(
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

  void _showProjectDialog(BuildContext context, {project}) {
    showDialog(
      context: context,
      builder: (context) => ProjectDialog(project: project),
    );
  }

  void _confirmDelete(BuildContext context, int projectId, String projectName) {
    Get.dialog(
      AlertDialog(
        title: const Text('تایید حذف'),
        content: Text('آیا از حذف پروژه "$projectName" اطمینان دارید؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final controller = Get.find<ProjectController>();
              await controller.deleteProject(projectId);
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
