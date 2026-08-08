import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/task.dart';
import '../theme/app_colors.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;

  const TaskTile({super.key, required this.task, this.onTap, this.onToggle});

  @override
  Widget build(BuildContext context) {
    final category = Category.byId(task.categoryId);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = task.isCompleted
        ? AppColors.muted
        : (isDark ? AppColors.darkPrimaryText : AppColors.ink);
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;

    final subtitleParts = <String>[
      category.name,
      if (task.dueTime != null) _formatTime(task.dueTime!),
    ];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // Check circle
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.isCompleted ? AppColors.violet : Colors.transparent,
                  border: task.isCompleted
                      ? null
                      : Border.all(color: AppColors.track, width: 1.5),
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, size: 14, color: AppColors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      decorationColor: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        category.icon,
                        size: 12,
                        color: category.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        subtitleParts.join(' • '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: subColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Priority flag (matches the Figma design)
            if (task.priority == Priority.high)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.flag, size: 16, color: AppColors.red),
              )
            else if (task.priority == Priority.medium)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.flag, size: 16, color: AppColors.orange),
              ),
            if (task.repeat != RepeatRule.none) ...[
              const SizedBox(width: 4),
              Icon(Icons.repeat, size: 13, color: AppColors.muted),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final amPm = time.period == DayPeriod.am ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $amPm';
  }
}
