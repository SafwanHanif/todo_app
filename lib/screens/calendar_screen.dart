import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/task_tile.dart';
import 'task_detail_sheet.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _month;
  DateTime _selected = DateTime.now();

  @override
  void initState() {
    super.initState();
    _month = DateTime(_selected.year, _selected.month);
  }

  void _changeMonth(int delta) {
    setState(() => _month = DateTime(_month.year, _month.month + delta));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkPrimaryText : AppColors.ink;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;

    final dayTasks = provider.forDay(_selected);

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Text(
              'Calendar',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Month selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  icon: const Icon(Icons.chevron_left, color: AppColors.violet),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _monthLabel(_month),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _changeMonth(1),
                  icon: const Icon(Icons.chevron_right, color: AppColors.violet),
                ),
              ],
            ),
          ),

          // Weekday headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (final day in ['S', 'M', 'T', 'W', 'T', 'F', 'S'])
                  Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: subColor),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Month grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _MonthGrid(
              month: _month,
              selected: _selected,
              tasksByDay: provider.tasks,
              onSelect: (d) => setState(() => _selected = d),
            ),
          ),
          const SizedBox(height: 8),

          const Divider(height: 1),

          // Selected day tasks
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              children: [
                Text(
                  _selectedLabel(_selected),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                if (dayTasks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        Icon(Icons.event_available, size: 56, color: AppColors.track),
                        const SizedBox(height: 12),
                        Text(
                          'No tasks this day',
                          style: TextStyle(fontSize: 14, color: subColor),
                        ),
                      ],
                    ),
                  )
                else
                  ...dayTasks.map((task) => TaskTile(
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

  String _monthLabel(DateTime m) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[m.month - 1]} ${m.year}';
  }

  String _selectedLabel(DateTime d) {
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return '${weekdays[d.weekday - 1]}, ${_monthLabel(d).split(' ')[0]} ${d.day}';
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final DateTime selected;
  final List<Task> tasksByDay;
  final ValueChanged<DateTime> onSelect;

  const _MonthGrid({
    required this.month,
    required this.selected,
    required this.tasksByDay,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // weekday 1=Mon..7=Sun; grid starts Sunday -> offset = weekday % 7
    final leading = firstDay.weekday % 7;
    final totalCells = ((leading + daysInMonth + 6) ~/ 7) * 7;

    final cells = <Widget>[];
    for (var i = 0; i < totalCells; i++) {
      final dayNum = i - leading + 1;
      if (dayNum < 1 || dayNum > daysInMonth) {
        cells.add(const SizedBox.shrink());
        continue;
      }
      final date = DateTime(month.year, month.month, dayNum);
      final hasTasks = tasksByDay.any((t) => !t.isCompleted && _sameDay(t.dueDate, date));
      final isSelected = _sameDay(date, selected);
      final isToday = _sameDay(date, DateTime.now());

      cells.add(GestureDetector(
        onTap: () => onSelect(date),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.violet
                    : isToday && !isDark
                        ? AppColors.buttonTint
                        : Colors.transparent,
              ),
              child: Text(
                '$dayNum',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? AppColors.white
                      : isDark
                          ? AppColors.darkPrimaryText
                          : AppColors.ink,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasTasks ? (isSelected ? AppColors.white : AppColors.violet) : Colors.transparent,
              ),
            ),
          ],
        ),
      ));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.9,
      mainAxisSpacing: 4,
      children: cells,
    );
  }

  bool _sameDay(DateTime? a, DateTime b) =>
      a != null && a.year == b.year && a.month == b.month && a.day == b.day;
}
