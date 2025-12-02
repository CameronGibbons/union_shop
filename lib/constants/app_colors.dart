import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF4d2963); // UPSU Purple
  static const Color secondary = Color(0xFF2c2c2c); // Dark grey (footer)

  // Accent Colors
  static const Color error = Colors.red;
  static const Color success = Colors.green;

  // Neutral Colors
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.grey;
  static const Color backgroundLight = Colors.white;
  static const Color backgroundGrey = Color(0xFFF5F5F5);

  // Opacity Variants
  static Color primaryLight = primary.withValues(alpha: 0.1);
  static Color primaryMedium = primary.withValues(alpha: 0.5);
}
