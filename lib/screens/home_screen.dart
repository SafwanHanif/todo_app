import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state.dart';
import '../widgets/progress_card.dart';
import '../widgets/task_tile.dart';
import 'add_task_sheet.dart';
import 'task_detail_sheet.dart';

/// Home tab body (no Scaffold — the shell owns it).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkPrimaryText : AppColors.ink;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;

    final today = provider.todayTasks;
    final showEmpty = today.isEmpty;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        children: [
          Text(
            'Today',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _todayLabel(DateTime.now()),
            style: TextStyle(fontSize: 14, color: subColor),
          ),
          const SizedBox(height: 20),
          ProgressCard(provider: provider),
          const SizedBox(height: 28),
          Row(
            children: [
              Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
              const Spacer(),
              Text(
                '${today.length}',
                style: TextStyle(fontSize: 14, color: subColor),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (showEmpty)
            EmptyState(onAdd: () => showAddTaskSheet(context))
          else
            ...today.map((task) => TaskTile(
                  task: task,
                  onToggle: () => provider.toggleComplete(task.id),
                  onTap: () => showTaskDetailSheet(context, task),
                )),
        ],
      ),
    );
  }

  String _todayLabel(DateTime d) {
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${weekdays[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}';
  }
}
