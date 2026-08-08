import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/task_tile.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkPrimaryText : AppColors.ink;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;

    final completed = provider.completedTasks;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: [
                Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.buttonTint,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${completed.length}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.violet,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: completed.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.task_alt, size: 56, color: AppColors.track),
                        const SizedBox(height: 12),
                        Text(
                          'No completed tasks yet',
                          style: TextStyle(fontSize: 14, color: subColor),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    children: [
                      for (final task in completed) ...[
                        Dismissible(
                          key: ValueKey(task.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.delete_outline, color: Colors.white),
                          ),
                          onDismissed: (_) => provider.deleteTask(task.id),
                          child: TaskTile(
                            task: task,
                            onToggle: () => provider.toggleComplete(task.id),
                            onTap: () => _showDetail(context, task),
                          ),
                        ),
                        const Divider(height: 1),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDetail(BuildContext context, Task task) async {
    final category = Category.byId(task.categoryId);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkPrimaryText : AppColors.ink;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;
    final provider = context.read<TaskProvider>();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(category.icon, size: 14, color: category.color),
                  const SizedBox(width: 6),
                  Text(
                    '${category.name} • Completed',
                    style: TextStyle(fontSize: 13, color: subColor),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        provider.toggleComplete(task.id);
                        Navigator.pop(ctx);
                      },
                      icon: const Icon(Icons.undo, size: 18),
                      label: const Text('Restore'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.violet,
                        side: BorderSide(color: AppColors.violet.withValues(alpha: 0.4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        provider.deleteTask(task.id);
                        Navigator.pop(ctx);
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Delete'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.red,
                        side: BorderSide(color: AppColors.red.withValues(alpha: 0.4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
