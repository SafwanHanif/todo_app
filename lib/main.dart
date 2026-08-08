import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/settings_provider.dart';
import 'providers/task_provider.dart';
import 'screens/calendar_screen.dart';
import 'screens/completed_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/search_screen.dart';
import 'screens/smart_lists_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/main_shell.dart';
import 'screens/statistics_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return MaterialApp(
      title: 'To-Do',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/home': (_) => const MainShell(),
        '/calendar': (_) => const CalendarScreen(),
        '/stats': (_) => const StatisticsScreen(),
        '/categories': (_) => const CategoriesScreen(),
        '/search': (_) => const SearchScreen(),
        '/smart-lists': (_) => const SmartListsScreen(),
        '/completed': (_) => const CompletedScreen(),
      },
    );
  }
}
