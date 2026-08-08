import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_colors.dart';

/// The Add Task sheet, mirroring the Figma modal (205:989) including the
/// Repeat row and the compressed vertical layout.
Future<Task?> showAddTaskSheet(BuildContext context, {Task? initial}) {
  return showModalBottomSheet<Task>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkCard
        : AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => AddTaskSheet(initial: initial),
  );
}

class AddTaskSheet extends StatefulWidget {
  final Task? initial;

  const AddTaskSheet({super.key, this.initial});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;

  String _categoryId = 'shopping';
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  RepeatRule _repeat = RepeatRule.none;
  Priority _priority = Priority.medium;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.initial != null;
    _nameController = TextEditingController(text: widget.initial?.title ?? '');
    _notesController = TextEditingController(text: widget.initial?.notes ?? '');
    _categoryId = widget.initial?.categoryId ?? 'shopping';
    _dueDate = widget.initial?.dueDate;
    _dueTime = widget.initial?.dueTime;
    _repeat = widget.initial?.repeat ?? RepeatRule.none;
    _priority = widget.initial?.priority ?? Priority.medium;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) setState(() => _dueTime = picked);
  }

  Future<void> _pickRepeat() async {
    final selected = await showModalBottomSheet<RepeatRule>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Repeat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            for (final rule in RepeatRule.values)
              ListTile(
                leading: Icon(
                  rule == _repeat ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: rule == _repeat ? AppColors.violet : AppColors.muted,
                ),
                title: Text(rule.label),
                onTap: () => Navigator.pop(ctx, rule),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (selected != null) setState(() => _repeat = selected);
  }

  void _save() {
    final title = _nameController.text.trim();
    if (title.isEmpty) return;

    final provider = context.read<TaskProvider>();
    final task = Task(
      id: widget.initial?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      categoryId: _categoryId,
      dueDate: _dueDate,
      dueTime: _dueTime,
      repeat: _repeat,
      notes: _notesController.text.trim(),
      priority: _priority,
      isCompleted: widget.initial?.isCompleted ?? false,
      createdAt: widget.initial?.createdAt ?? DateTime.now(),
    );

    if (_isEdit) {
      provider.updateTask(task.id, task);
    } else {
      provider.addTask(task);
    }
    Navigator.pop(context, task);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.darkLabel : AppColors.muted;
    final fieldValueColor = isDark ? AppColors.darkFieldValue : AppColors.ink;
    final fieldBg = isDark ? AppColors.darkInput : AppColors.track;
    final titleColor = isDark ? AppColors.darkPrimaryText : AppColors.ink;

    return Padding(
      // Keep fields above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grab handle
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
              Center(
                child: Text(
                  _isEdit ? 'Edit Task' : 'Add Task',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Name
              _label(context, 'Name', labelColor),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                autofocus: !_isEdit,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Buy groceries',
                  filled: true,
                  fillColor: fieldBg,
                ),
                style: TextStyle(fontSize: 14, color: fieldValueColor),
              ),
              const SizedBox(height: 20),

              // Category
              _label(context, 'Category', labelColor),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final cat in Category.defaults) ...[
                    _CategoryDot(
                      category: cat,
                      selected: _categoryId == cat.id,
                      onTap: () => setState(() => _categoryId = cat.id),
                    ),
                    if (cat != Category.defaults.last) const Spacer(),
                  ],
                ],
              ),
              const SizedBox(height: 18),

              // Due date + time
              Row(
                children: [
                  Expanded(
                    child: _FieldChip(
                      label: 'Due date',
                      value: _dueDate == null ? 'Pick a date' : _fmtDate(_dueDate!),
                      bg: fieldBg,
                      valueColor: fieldValueColor,
                      onTap: _pickDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _FieldChip(
                      label: 'Time',
                      value: _dueTime == null ? 'Pick a time' : _fmtTime(_dueTime!),
                      bg: fieldBg,
                      valueColor: fieldValueColor,
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Repeat row (added in the design upgrade)
              _label(context, 'Repeat', labelColor),
              const SizedBox(height: 6),
              InkWell(
                onTap: _pickRepeat,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: fieldBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _repeat.label,
                          style: TextStyle(fontSize: 13, color: fieldValueColor),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: AppColors.muted,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Priority
              _label(context, 'Priority', labelColor),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final p in [Priority.low, Priority.medium, Priority.high]) ...[
                    Expanded(
                      child: _PriorityChip(
                        priority: p,
                        selected: _priority == p,
                        onTap: () => setState(() => _priority = p),
                      ),
                    ),
                    if (p != Priority.high) const SizedBox(width: 8),
                  ],
                ],
              ),
              const SizedBox(height: 18),

              // Notes
              _label(context, 'Notes', labelColor),
              const SizedBox(height: 6),
              TextField(
                controller: _notesController,
                maxLines: 2,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Add notes…',
                  filled: true,
                  fillColor: fieldBg,
                ),
                style: TextStyle(fontSize: 13, color: fieldValueColor),
              ),
              const SizedBox(height: 22),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.violet,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    _isEdit ? 'Save Changes' : 'Save Task',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text, Color color) {
    return Text(
      text,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color),
    );
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

class _CategoryDot extends StatelessWidget {
  final Category category;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryDot({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? category.color.withValues(alpha: 0.15) : AppColors.track,
              border: Border.all(
                color: selected ? category.color : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(
              category.icon,
              size: 18,
              color: selected ? category.color : AppColors.muted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            category.name,
            style: const TextStyle(fontSize: 10, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _FieldChip extends StatelessWidget {
  final String label;
  final String value;
  final Color bg;
  final Color valueColor;
  final VoidCallback onTap;

  const _FieldChip({
    required this.label,
    required this.value,
    required this.bg,
    required this.valueColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppColors.muted),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: valueColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final Priority priority;
  final bool selected;
  final VoidCallback onTap;

  const _PriorityChip({
    required this.priority,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      Priority.low => AppColors.muted,
      Priority.medium => AppColors.orange,
      Priority.high => AppColors.red,
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? color : AppColors.track,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flag, size: 14, color: selected ? color : AppColors.muted),
            const SizedBox(width: 6),
            Text(
              priority.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? color : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
