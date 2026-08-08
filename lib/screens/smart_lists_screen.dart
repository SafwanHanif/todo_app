import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/task_tile.dart';
import 'task_detail_sheet.dart';

enum _SmartList { today, next7, high, overdue }

class SmartListsScreen extends StatefulWidget {
  const SmartListsScreen({super.key});

  @override
  State<SmartListsScreen> createState() => _SmartListsScreenState();
}

class _SmartListsScreenState extends State<SmartListsScreen> {
  _SmartList _selected = _SmartList.today;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkPrimaryText : AppColors.ink;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;

    final tasks = switch (_selected) {
      _SmartList.today => provider.todayTasks,
      _SmartList.next7 => provider.nextSevenDays,
      _SmartList.high => provider.highPriorityTasks,
      _SmartList.overdue => provider.overdueTasks,
    };

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Text(
              'Smart Lists',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Segmented chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                for (final item in _SmartList.values) ...[
                  Expanded(
                    child: _Chip(
                      label: _label(item),
                      selected: _selected == item,
                      onTap: () => setState(() => _selected = item),
                    ),
                  ),
                  if (item != _SmartList.values.last) const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '${tasks.length} task${tasks.length == 1 ? '' : 's'}',
              style: TextStyle(fontSize: 13, color: subColor),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Text(
                      'Nothing here yet',
                      style: TextStyle(fontSize: 14, color: subColor),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    children: [
                      ...tasks.map((task) => TaskTile(
                            task: task,
                            onToggle: () => provider.toggleComplete(task.id),
                            onTap: () => showTaskDetailSheet(context, task),
                          )),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  String _label(_SmartList list) => switch (list) {
        _SmartList.today => 'Today',
        _SmartList.next7 => 'Next 7',
        _SmartList.high => 'High',
        _SmartList.overdue => 'Overdue',
      };
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.buttonTint : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.violet : AppColors.track,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.violet : AppColors.muted,
          ),
        ),
      ),
    );
  }
}
