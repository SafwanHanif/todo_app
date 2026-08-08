import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/task_provider.dart';
import '../theme/app_colors.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkPrimaryText : AppColors.ink;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;

    final total = provider.tasks.length;
    final done = provider.completedTasks.length;
    final pct = total == 0 ? 0.0 : done / total;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        children: [
          Text(
            'Statistics',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your productivity at a glance',
            style: TextStyle(fontSize: 14, color: subColor),
          ),
          const SizedBox(height: 20),

          // Progress ring card
          _Card(
            bg: cardBg,
            child: Row(
              children: [
                SizedBox(
                  width: 96,
                  height: 96,
                  child: _ProgressRing(
                    progress: pct,
                    color: AppColors.violet,
                    track: isDark ? AppColors.darkInput : AppColors.track,
                    center: '${(pct * 100).round()}%',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall completion',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$done of $total tasks completed',
                        style: TextStyle(fontSize: 13, color: subColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Keep it up!',
                        style: TextStyle(fontSize: 12, color: AppColors.violet),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 7-day bar chart
          _Card(
            bg: cardBg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last 7 days',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 18),
                _WeekBars(provider: provider),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Category breakdown
          _Card(
            bg: cardBg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'By category',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 16),
                for (final cat in Category.defaults)
                  _CategoryBreakdownRow(category: cat, provider: provider),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Color bg;
  final Widget child;

  const _Card({required this.bg, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF17142E).withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ProgressRing extends StatelessWidget {
  final double progress;
  final Color color;
  final Color track;
  final String center;

  const _ProgressRing({
    required this.progress,
    required this.color,
    required this.track,
    required this.center,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RingPainter(progress: progress, color: color, track: track),
      child: Center(
        child: Text(
          center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.violet,
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color track;

  _RingPainter({required this.progress, required this.color, required this.track});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 10.0;
    final rect = Rect.fromLTWH(stroke / 2, stroke / 2, size.width - stroke, size.height - stroke);
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track;
    canvas.drawArc(rect, 0, math.pi * 2, false, trackPaint);

    final fillPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * progress, false, fillPaint);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color || old.track != track;
}

class _WeekBars extends StatelessWidget {
  final TaskProvider provider;

  const _WeekBars({required this.provider});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;
    final now = DateTime.now();

    final days = <DateTime>[];
    for (var i = 6; i >= 0; i--) {
      days.add(DateTime(now.year, now.month, now.day).subtract(Duration(days: i)));
    }
    final maxCount = days
        .map((d) => provider.completedOn(d))
        .fold<int>(1, (a, b) => a > b ? a : b);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final day in days)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${provider.completedOn(day)}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: subColor,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 64,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 16,
                    height: maxCount == 0
                        ? 4
                        : (provider.completedOn(day) / maxCount) * 64,
                    decoration: BoxDecoration(
                      color: _sameDay(day, now) ? AppColors.violet : AppColors.buttonTint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _shortWeekday(day),
                  style: TextStyle(fontSize: 10, color: subColor),
                ),
              ],
            ),
          ),
      ],
    );
  }

  bool _sameDay(DateTime? a, DateTime b) =>
      a != null && a.year == b.year && a.month == b.month && a.day == b.day;

  String _shortWeekday(DateTime d) {
    const w = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return w[d.weekday - 1];
  }
}

class _CategoryBreakdownRow extends StatelessWidget {
  final Category category;
  final TaskProvider provider;

  const _CategoryBreakdownRow({required this.category, required this.provider});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;
    final total = provider.countForCategory(category.id);
    final done = provider.completedForCategory(category.id);
    final pct = total == 0 ? 0.0 : done / total;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: category.color,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  category.name,
                  style: TextStyle(fontSize: 13, color: subColor),
                ),
              ),
              Text(
                '$done/$total',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: subColor,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 40,
                child: Text(
                  '${(pct * 100).round()}%',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.violet,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: isDark ? AppColors.darkInput : AppColors.track,
              valueColor: AlwaysStoppedAnimation(category.color),
            ),
          ),
        ],
      ),
    );
  }
}
