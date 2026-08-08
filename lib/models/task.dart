import 'package:flutter/material.dart';

enum RepeatRule { none, daily, weekly, monthly }

extension RepeatRuleLabel on RepeatRule {
  String get label => switch (this) {
        RepeatRule.none => 'Does not repeat',
        RepeatRule.daily => 'Daily',
        RepeatRule.weekly => 'Weekly',
        RepeatRule.monthly => 'Monthly',
      };
}

enum Priority { low, medium, high }

extension PriorityLabel on Priority {
  String get label => switch (this) {
        Priority.low => 'Low',
        Priority.medium => 'Medium',
        Priority.high => 'High',
      };
}

class Task {
  final String id;
  final String title;
  final String categoryId;
  final DateTime? dueDate;
  final TimeOfDay? dueTime;
  final RepeatRule repeat;
  final String notes;
  final Priority priority;
  final bool isCompleted;
  final DateTime? completedOn;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    required this.categoryId,
    this.dueDate,
    this.dueTime,
    this.repeat = RepeatRule.none,
    this.notes = '',
    this.priority = Priority.medium,
    this.isCompleted = false,
    this.completedOn,
    required this.createdAt,
  });

  Task copyWith({
    String? title,
    String? categoryId,
    DateTime? dueDate,
    bool clearDueDate = false,
    TimeOfDay? dueTime,
    bool clearDueTime = false,
    RepeatRule? repeat,
    String? notes,
    Priority? priority,
    bool? isCompleted,
    DateTime? completedOn,
    bool clearCompletedOn = false,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      dueTime: clearDueTime ? null : (dueTime ?? this.dueTime),
      repeat: repeat ?? this.repeat,
      notes: notes ?? this.notes,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      completedOn: clearCompletedOn ? null : (completedOn ?? this.completedOn),
      createdAt: createdAt,
    );
  }
}
