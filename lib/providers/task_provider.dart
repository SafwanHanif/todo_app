import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  List<Task> get tasks => List.unmodifiable(_tasks);

  TaskProvider() {
    _seedSampleData();
  }

  // ---------------------------------------------------------------------------
  // Mutations
  // ---------------------------------------------------------------------------

  void addTask(Task task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void updateTask(String id, Task updated) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = updated;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggleComplete(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final t = _tasks[index];
      _tasks[index] = t.copyWith(
        isCompleted: !t.isCompleted,
        completedOn: !t.isCompleted ? DateTime.now() : null,
      );
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // Derived lists
  // ---------------------------------------------------------------------------

  bool sameDay(DateTime? a, DateTime b) =>
      a != null && a.year == b.year && a.month == b.month && a.day == b.day;

  List<Task> forDay(DateTime day) => _tasks
      .where((t) => !t.isCompleted && sameDay(t.dueDate, day))
      .toList();

  List<Task> get todayTasks => forDay(DateTime.now());

  List<Task> get activeTasks => _tasks.where((t) => !t.isCompleted).toList();

  List<Task> get completedTasks => _tasks.where((t) => t.isCompleted).toList();

  List<Task> get overdueTasks {
    final now = DateTime.now();
    return activeTasks.where((t) {
      final d = t.dueDate;
      return d != null && d.isBefore(DateTime(now.year, now.month, now.day));
    }).toList();
  }

  List<Task> get nextSevenDays {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 7));
    return activeTasks
        .where((t) => t.dueDate != null && !t.dueDate!.isBefore(start) && t.dueDate!.isBefore(end))
        .toList();
  }

  List<Task> get highPriorityTasks =>
      activeTasks.where((t) => t.priority == Priority.high).toList();

  List<Task> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return _tasks.where((t) {
      final cat = _categoryName(t.categoryId).toLowerCase();
      return t.title.toLowerCase().contains(q) || cat.contains(q);
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Derived stats
  // ---------------------------------------------------------------------------

  int get streak {
    // Consecutive days up to (and including) today with >= 1 completed task.
    var count = 0;
    final day = DateTime.now();
    var cursor = DateTime(day.year, day.month, day.day);
    // Include today only if something is already completed today.
    while (completedOnOrBefore(cursor)) {
      count++;
      cursor = cursor.subtract(const Duration(days: 1));
      if (cursor.isAfter(DateTime(day.year, day.month, day.day))) break;
    }
    // If today has nothing completed yet, start counting from yesterday.
    if (count == 0 || !completedOnOrBefore(DateTime(day.year, day.month, day.day))) {
      var back = DateTime(day.year, day.month, day.day).subtract(const Duration(days: 1));
      var backCount = 0;
      while (completedOnOrBefore(back)) {
        backCount++;
        back = back.subtract(const Duration(days: 1));
      }
      count = backCount;
    }
    return count;
  }

  bool completedOnOrBefore(DateTime day) => _tasks.any((t) {
        if (!t.isCompleted || t.completedOn == null) return false;
        final c = t.completedOn!;
        return c.year == day.year && c.month == day.month && c.day == day.day;
      });

  /// Tasks due today, plus completed tasks that were completed today.
  List<Task> get todaysProgressPool {
    final today = DateTime.now();
    final pool = <Task>[];
    for (final t in _tasks) {
      if (sameDay(t.dueDate, today) || sameDay(t.completedOn, today)) {
        pool.add(t);
      }
    }
    return pool;
  }

  int get todaysTotal => todaysProgressPool.length;
  int get todaysDone => todaysProgressPool.where((t) => t.isCompleted).length;

  int countForCategory(String categoryId) =>
      _tasks.where((t) => t.categoryId == categoryId).length;

  int completedForCategory(String categoryId) =>
      _tasks.where((t) => t.categoryId == categoryId && t.isCompleted).length;

  /// Number of tasks completed on the given calendar day.
  int completedOn(DateTime day) => _tasks
      .where((t) => t.isCompleted && sameDay(t.completedOn, day))
      .length;

  String _categoryName(String id) {
    const names = {
      'work': 'Work',
      'health': 'Health',
      'shopping': 'Shopping',
      'personal': 'Personal',
      'finance': 'Finance',
    };
    return names[id] ?? 'General';
  }

  // ---------------------------------------------------------------------------
  // Sample data matching the Figma design
  // ---------------------------------------------------------------------------

  void _seedSampleData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final tasks = <Task>[
      Task(
        id: 't1',
        title: 'Morning run',
        categoryId: 'health',
        dueDate: today,
        dueTime: const TimeOfDay(hour: 7, minute: 0),
        priority: Priority.medium,
        isCompleted: true,
        completedOn: today,
        createdAt: now.subtract(const Duration(days: 7)),
      ),
      Task(
        id: 't2',
        title: 'Team standup',
        categoryId: 'work',
        dueDate: today,
        dueTime: const TimeOfDay(hour: 9, minute: 30),
        priority: Priority.medium,
        isCompleted: true,
        completedOn: today,
        createdAt: now.subtract(const Duration(days: 7)),
      ),
      Task(
        id: 't3',
        title: 'Buy groceries',
        categoryId: 'shopping',
        dueDate: today,
        dueTime: const TimeOfDay(hour: 18, minute: 0),
        priority: Priority.high,
        notes: 'Milk, eggs, bread, coffee',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: 't4',
        title: 'Read 20 pages',
        categoryId: 'personal',
        dueDate: today,
        dueTime: const TimeOfDay(hour: 21, minute: 0),
        priority: Priority.medium,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Task(
        id: 't5',
        title: 'Pay electricity bill',
        categoryId: 'finance',
        dueDate: today,
        dueTime: const TimeOfDay(hour: 12, minute: 0),
        priority: Priority.high,
        repeat: RepeatRule.monthly,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      Task(
        id: 't6',
        title: 'Plan project sprint',
        categoryId: 'work',
        dueDate: today.add(const Duration(days: 1)),
        priority: Priority.high,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: 't7',
        title: 'Gym workout',
        categoryId: 'health',
        dueDate: today.add(const Duration(days: 2)),
        priority: Priority.medium,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: 't8',
        title: 'Call mom',
        categoryId: 'personal',
        dueDate: today.add(const Duration(days: 3)),
        priority: Priority.low,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    // Seed a 7-day completion streak (days -1 .. -7).
    final streakSeed = <Task>[];
    for (var i = 1; i <= 7; i++) {
      final day = today.subtract(Duration(days: i));
      streakSeed.add(Task(
        id: 'seed$i',
        title: 'Completed task',
        categoryId: 'work',
        dueDate: day,
        priority: Priority.low,
        isCompleted: true,
        completedOn: day,
        createdAt: day,
      ));
    }

    _tasks.addAll([...tasks, ...streakSeed]);
  }
}
