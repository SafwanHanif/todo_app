import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class Category {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  const Category({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  /// The five categories shown in the Figma Add-Task modal.
  static const List<Category> defaults = [
    Category(
      id: 'work',
      name: 'Work',
      color: AppColors.work,
      icon: Icons.work_outline,
    ),
    Category(
      id: 'health',
      name: 'Health',
      color: AppColors.health,
      icon: Icons.favorite_outline,
    ),
    Category(
      id: 'shopping',
      name: 'Shopping',
      color: AppColors.shopping,
      icon: Icons.shopping_bag_outlined,
    ),
    Category(
      id: 'personal',
      name: 'Personal',
      color: AppColors.personal,
      icon: Icons.person_outline,
    ),
    Category(
      id: 'finance',
      name: 'Finance',
      color: AppColors.finance,
      icon: Icons.account_balance_wallet_outlined,
    ),
  ];

  static Category byId(String id) => defaults.firstWhere(
        (c) => c.id == id,
        orElse: () => defaults.first,
      );
}
