import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/task_provider.dart';
import '../theme/app_colors.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkPrimaryText : AppColors.ink;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;

    final total = provider.tasks.length;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        children: [
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$total tasks organized',
            style: TextStyle(fontSize: 14, color: subColor),
          ),
          const SizedBox(height: 20),
          for (final cat in Category.defaults)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cat.color.withValues(alpha: 0.15),
                      ),
                      child: Icon(cat.icon, size: 20, color: cat.color),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: titleColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${provider.countForCategory(cat.id)} tasks',
                            style: TextStyle(fontSize: 12, color: subColor),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${provider.countForCategory(cat.id)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: cat.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
