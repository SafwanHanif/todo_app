import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:todo_app/main.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/providers/settings_provider.dart';

void main() {
  testWidgets('App boots to splash screen', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TaskProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
        child: const TodoApp(),
      ),
    );
    await tester.pump();

    // Splash screen shows the app name.
    expect(find.text('To-Do'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
