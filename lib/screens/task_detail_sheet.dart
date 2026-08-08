import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_colors.dart';
import 'add_task_sheet.dart';

/// Task detail sheet — the design's task-detail modal, in light and dark.
Future<void> showTaskDetailSheet(BuildContext context, Task task) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkCard
        : AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => TaskDetailSheet(task: task),
  );
}

class TaskDetailSheet extends StatelessWidget {
  final Task task;

  const TaskDetailSheet({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final category = Category.byId(task.categoryId);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkPrimaryText : AppColors.ink;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;
    final fieldBg = isDark ? AppColors.darkInput : AppColors.track;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.track,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Check circle
                GestureDetector(
                  onTap: () => provider.toggleComplete(task.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: task.isCompleted ? AppColors.violet : Colors.transparent,
                      border: task.isCompleted
                          ? null
                          : Border.all(color: AppColors.track, width: 1.5),
                    ),
                    child: task.isCompleted
                        ? const Icon(Icons.check, size: 16, color: AppColors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: subColor),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(category.icon, size: 14, color: category.color),
                const SizedBox(width: 6),
                Text(
                  category.name,
                  style: TextStyle(fontSize: 13, color: subColor),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _InfoRow(
              icon: Icons.event,
              label: 'Due date',
              value: task.dueDate == null ? 'No date' : _fmtDate(task.dueDate!),
              fieldBg: fieldBg,
              valueColor: isDark ? AppColors.darkFieldValue : AppColors.ink,
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.schedule,
              label: 'Time',
              value: task.dueTime == null ? 'No time' : _fmtTime(task.dueTime!),
              fieldBg: fieldBg,
              valueColor: isDark ? AppColors.darkFieldValue : AppColors.ink,
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.repeat,
              label: 'Repeat',
              value: task.repeat.label,
              fieldBg: fieldBg,
              valueColor: isDark ? AppColors.darkFieldValue : AppColors.ink,
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.flag,
              label: 'Priority',
              value: task.priority.label,
              fieldBg: fieldBg,
              valueColor: switch (task.priority) {
                Priority.high => AppColors.red,
                Priority.medium => AppColors.orange,
                Priority.low => AppColors.muted,
              },
            ),
            if (task.notes.isNotEmpty) ...[
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.notes,
                label: 'Notes',
                value: task.notes,
                fieldBg: fieldBg,
                valueColor: isDark ? AppColors.darkFieldValue : AppColors.ink,
              ),
            ],
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _delete(context, provider),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.red,
                      side: BorderSide(color: AppColors.red.withValues(alpha: 0.4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => _edit(context, provider),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.violet,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Edit', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _delete(BuildContext context, TaskProvider provider) {
    provider.deleteTask(task.id);
    Navigator.pop(context);
  }

  Future<void> _edit(BuildContext context, TaskProvider provider) async {
    Navigator.pop(context);
    await showAddTaskSheet(context, initial: task);
  }

  String _fmtDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  String _fmtTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final amPm = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:${t.minute.toString().padLeft(2, '0')} $amPm';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color fieldBg;
  final Color valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.fieldBg,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.muted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
          ),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: valueColor),
          ),
        ],
      ),
    );
  }
}
