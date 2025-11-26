import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/logs_controller.dart';
import '../../data/models/log_entry_model.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LogsController controller = Get.put(LogsController(
      logsService: Get.find(),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refresh,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => controller.clearFilters(),
            tooltip: 'Clear Filters',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters Section
          _buildFiltersSection(controller),
          const Divider(height: 1),
          // Stats Section
          _buildStatsSection(controller),
          const Divider(height: 1),
          // Logs List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.error.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        controller.error.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.refresh,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.logs.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.description_outlined,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No logs found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.logs.length,
                itemBuilder: (context, index) {
                  final log = controller.logs[index];
                  return _buildLogCard(log, context);
                },
              );
            }),
          ),
          // Pagination
          _buildPagination(controller),
        ],
      ),
    );
  }

  Widget _buildFiltersSection(LogsController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Obx(() => Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              // Category Filter
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  value: controller.selectedCategory.value,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    isDense: true,
                  ),
                  items: ['all', ...controller.categories.keys]
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat == 'all' ? 'All Categories' : cat),
                          ))
                      .toList(),
                  onChanged: (value) => controller.selectCategory(value!),
                ),
              ),
              // Level Filter
              SizedBox(
                width: 150,
                child: DropdownButtonFormField<String>(
                  value: controller.selectedLevel.value,
                  decoration: const InputDecoration(
                    labelText: 'Level',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Levels')),
                    DropdownMenuItem(value: 'error', child: Text('Error')),
                    DropdownMenuItem(value: 'warn', child: Text('Warning')),
                    DropdownMenuItem(value: 'info', child: Text('Info')),
                  ],
                  onChanged: (value) => controller.selectLevel(value!),
                ),
              ),
              // Search
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: const OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    isDense: true,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // Search will be triggered on text change
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      controller.searchAllLogs(value);
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildStatsSection(LogsController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.blue[50],
      child: Obx(() => Row(
            children: [
              const Icon(Icons.description, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Total Logs: ${controller.total.value}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 24),
              Text(
                'Page: ${controller.currentPage.value} / ${controller.totalPages.value}',
                style: const TextStyle(color: Colors.grey),
              ),
              const Spacer(),
              Text(
                'Category: ${controller.selectedCategory.value}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          )),
    );
  }

  Widget _buildLogCard(LogEntryModel log, BuildContext context) {
    Color levelColor;
    switch (log.level.toLowerCase()) {
      case 'error':
        levelColor = Colors.red;
        break;
      case 'warn':
      case 'warning':
        levelColor = Colors.orange;
        break;
      case 'info':
        levelColor = Colors.blue;
        break;
      default:
        levelColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 4,
          height: double.infinity,
          color: levelColor,
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: levelColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: levelColor),
              ),
              child: Text(
                log.level.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: levelColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                log.category,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                log.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              log.timestamp,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            if (log.userId != null)
              Text(
                'User ID: ${log.userId}',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline, size: 20),
          onPressed: () => _showLogDetails(context, log),
        ),
      ),
    );
  }

  Widget _buildPagination(LogsController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: controller.currentPage.value > 1
                    ? controller.previousPage
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                'Page ${controller.currentPage.value} of ${controller.totalPages.value}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed:
                    controller.currentPage.value < controller.totalPages.value
                        ? controller.nextPage
                        : null,
              ),
            ],
          )),
    );
  }

  void _showLogDetails(BuildContext context, LogEntryModel log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(log.levelIcon),
            const SizedBox(width: 8),
            const Text('Log Details'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Level', log.level),
              _buildDetailRow('Category', log.category),
              _buildDetailRow('Timestamp', log.timestamp),
              if (log.userId != null)
                _buildDetailRow('User ID', log.userId.toString()),
              const Divider(),
              const Text(
                'Message:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SelectableText(log.message),
              if (log.metadata != null) ...[
                const Divider(),
                const Text(
                  'Metadata:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  log.metadata.toString(),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }
}
