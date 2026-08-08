import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _tabs = [
    _TabItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Today'),
    _TabItem(icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_today, label: 'Calendar'),
    _TabItem(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: 'Stats'),
    _TabItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.white;
    final divider = isDark ? AppColors.darkDivider : AppColors.divider;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1px separator
        Container(height: 1, color: divider),
        Container(
          height: 80,
          color: bg,
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                for (var i = 0; i < _tabs.length; i++)
                  Expanded(
                    child: _NavItem(
                      item: _tabs[i],
                      selected: i == currentIndex,
                      onTap: () => onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final _TabItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.violet : AppColors.muted;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(selected ? item.activeIcon : item.icon, size: 24, color: color),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
