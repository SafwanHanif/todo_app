import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/bottom_nav.dart';
import 'add_task_sheet.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'statistics_screen.dart';

/// Hosts the four main tabs behind the shared bottom nav + FAB.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _tabs = [
    HomeScreen(),
    CalendarScreen(),
    StatisticsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final hasTodayTasks = provider.todayTasks.isNotEmpty;

    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      floatingActionButton: (_index == 0 && hasTodayTasks)
          ? FloatingActionButton.extended(
              onPressed: () => showAddTaskSheet(context),
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                'Add a task',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            )
          : null,
      bottomNavigationBar: BottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
