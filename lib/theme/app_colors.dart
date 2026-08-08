import 'package:flutter/material.dart';

/// Design system colors lifted directly from the Figma To-Do app design.
abstract class AppColors {
  // ---- Light palette ----
  static const Color bg = Color(0xFFF4F3F8);
  static const Color violet = Color(0xFF6C5CE7);
  static const Color ink = Color(0xFF2B2A33);
  static const Color muted = Color(0xFF8E8C9B);
  static const Color track = Color(0xFFE9E8F2);
  static const Color divider = Color(0xFFECEBF0);
  static const Color buttonTint = Color(0xFFF0EDFF);
  static const Color red = Color(0xFFFF6B6B);
  static const Color orange = Color(0xFFFFA94D);
  static const Color white = Color(0xFFFFFFFF);

  // ---- Dark palette ----
  static const Color darkBg = Color(0xFF1C1B22);
  static const Color darkCard = Color(0xFF26252E);
  static const Color darkInput = Color(0xFF2E2D38);
  static const Color darkDivider = Color(0xFF3A3942);
  static const Color darkLabel = Color(0xFFA09FAE);
  static const Color darkFieldValue = Color(0xFFBCBAC8);
  static const Color darkPrimaryText = Color(0xFFF4F3F8);

  // ---- Category colors ----
  static const Color work = Color(0xFF6C5CE7);
  static const Color health = Color(0xFF00B894);
  static const Color shopping = Color(0xFFFFA94D);
  static const Color personal = Color(0xFFFF6B6B);
  static const Color finance = Color(0xFF0984E3);
}
