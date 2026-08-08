import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const _pages = [
    _OnboardPage(
      icon: Icons.check_circle_outline,
      title: 'Stay on top of your day',
      subtitle: 'Plan tasks, set priorities, and check them off as you go. Everything in one place.',
    ),
    _OnboardPage(
      icon: Icons.calendar_month_outlined,
      title: 'Schedule & repeat',
      subtitle: 'Add due dates, times, and repeating tasks so nothing slips through the cracks.',
    ),
    _OnboardPage(
      icon: Icons.local_fire_department_outlined,
      title: 'Build your streak',
      subtitle: 'Complete tasks daily to grow your streak and watch your progress take off.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkPrimaryText : AppColors.ink;
    final subColor = isDark ? AppColors.darkLabel : AppColors.muted;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => _buildPage(_pages[i], titleColor, subColor),
              ),
            ),
            // Progress dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _pages.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _page ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _page ? AppColors.violet : AppColors.track,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            // CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _next,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.violet,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: Text(
                    _page == _pages.length - 1 ? 'Get Started' : 'Next',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardPage page, Color titleColor, Color subColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.buttonTint,
            ),
            child: Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                child: Icon(page.icon, size: 48, color: AppColors.violet),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.5, color: subColor),
          ),
        ],
      ),
    );
  }
}

class _OnboardPage {
  final IconData icon;
  final String title;
  final String subtitle;

  const _OnboardPage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
