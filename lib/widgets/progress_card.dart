import 'package:flutter/material.dart';

import '../providers/task_provider.dart';
import '../theme/app_colors.dart';

class ProgressCard extends StatelessWidget {
  final TaskProvider provider;

  const ProgressCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final titleColor = isDark ? AppColors.darkPrimaryText : AppColors.ink;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;

    final total = provider.todaysTotal;
    final done = provider.todaysDone;
    final streak = provider.streak;
    final progress = total == 0 ? 0.0 : done / total;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF17142E).withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Today's progress",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
              ),
              // Streak indicator (flame + count + caption)
              const Icon(Icons.local_fire_department, size: 16, color: AppColors.orange),
              const SizedBox(width: 2),
              Text(
                '$streak',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'streak',
                style: TextStyle(fontSize: 9, color: subColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$done of $total completed',
            style: TextStyle(fontSize: 12, color: subColor),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.track,
              valueColor: const AlwaysStoppedAnimation(AppColors.violet),
            ),
          ),
        ],
      ),
    );
  }
}
