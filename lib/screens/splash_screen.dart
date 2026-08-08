import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkPrimaryText : AppColors.ink;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Logo: tint circle + white circle + violet check
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.buttonTint,
              ),
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                  child: const Center(
                    child: Icon(Icons.check, size: 28, color: AppColors.violet),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'To-Do',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Organize your day, one task at a time',
              style: TextStyle(fontSize: 14, color: subColor),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.violet,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
