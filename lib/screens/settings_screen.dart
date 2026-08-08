import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkPrimaryText : AppColors.ink;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;

    // Profile initials
    final initials = settings.userName
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 20),

          // Profile card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.buttonTint,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.violet,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        settings.userName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        settings.userEmail,
                        style: TextStyle(fontSize: 12, color: subColor),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.muted),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _SectionTitle('Appearance', titleColor),
          const SizedBox(height: 8),
          _Card(
            bg: cardBg,
            children: [
              _SwitchRow(
                icon: Icons.dark_mode_outlined,
                title: 'Dark mode',
                value: settings.darkMode,
                onChanged: (v) => settings.setDarkMode(v),
              ),
              const Divider(height: 1),
              _SwitchRow(
                icon: Icons.brush_outlined,
                title: 'Use system theme',
                value: false,
                onChanged: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          _SectionTitle('Notifications', titleColor),
          const SizedBox(height: 8),
          _Card(
            bg: cardBg,
            children: [
              _SwitchRow(
                icon: Icons.notifications_outlined,
                title: 'Reminders',
                subtitle: 'Task due notifications',
                value: settings.remindersEnabled,
                onChanged: (_) => settings.toggleReminders(),
              ),
              const Divider(height: 1),
              _SwitchRow(
                icon: Icons.summarize_outlined,
                title: 'Daily summary',
                subtitle: 'Streak and progress recap',
                value: settings.dailySummaryEnabled,
                onChanged: (_) => settings.toggleDailySummary(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _SectionTitle('About', titleColor),
          const SizedBox(height: 8),
          _Card(
            bg: cardBg,
            children: [
              _LinkRow(icon: Icons.info_outline, title: 'Version', value: '1.0.0'),
              const Divider(height: 1),
              const _LinkRow(
                icon: Icons.help_outline,
                title: 'Help & support',
                value: '',
              ),
              const Divider(height: 1),
              const _LinkRow(
                icon: Icons.star_outline,
                title: 'Rate the app',
                value: '',
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final Color color;

  const _SectionTitle(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color.withValues(alpha: 0.7),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Color bg;
  final List<Widget> children;

  const _Card({required this.bg, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.violet),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(fontSize: 11, color: AppColors.muted),
                  ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _LinkRow({required this.icon, required this.title, this.value = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.violet),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: const TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          const Icon(Icons.chevron_right, size: 18, color: AppColors.muted),
        ],
      ),
    );
  }
}
