import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The "All done!" empty state from the Figma design.
class EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkPrimaryText : AppColors.ink;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          // Illustration: outer tint circle, inner white circle, violet check
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.darkInput : AppColors.buttonTint,
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
                  child: Icon(
                    Icons.check,
                    size: 28,
                    color: AppColors.violet,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'All done!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'You have no tasks for today. Enjoy your free time — or add something new.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.4, color: subColor),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: onAdd,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.violet,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40),
              ),
              child: const Text(
                'Add a task',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
