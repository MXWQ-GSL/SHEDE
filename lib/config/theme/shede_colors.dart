import 'package:flutter/material.dart';

/// Neumorphism 色彩系统
/// 核心：同色背景 + 双向阴影 = 浮雕 3D 效果
class SheDeColors {
  SheDeColors._();

  // ========== 浅色模式 ==========
  static const Color background = Color(0xFFE0E5EC);
  static const Color surface = Color(0xFFE0E5EC);
  static const Color shadowDark = Color(0xFFA3B1C6);
  static const Color shadowLight = Color(0xFFFFFFFF);

  static const Color label = Color(0xFF2D3748);
  static const Color secondaryLabel = Color(0xFF8E99A4);
  static const Color tertiaryLabel = Color(0xFFB0BAC9);

  static const Color tintColor = Color(0xFF6C8EBF);
  static const Color systemGreen = Color(0xFF6BAF7B);
  static const Color systemRed = Color(0xFFD4726A);
  static const Color systemOrange = Color(0xFFD4A55A);
  static const Color systemIndigo = Color(0xFF7C6FBF);
  static const Color systemTeal = Color(0xFF5AACB4);

  static const Color opaqueSeparator = Color(0xFFC8CDD5);

  // ========== 深色模式 ==========
  static const Color darkBackground = Color(0xFF2D2D35);
  static const Color darkSurface = Color(0xFF2D2D35);
  static const Color darkShadowDark = Color(0xFF1A1A20);
  static const Color darkShadowLight = Color(0xFF404048);

  static const Color darkLabel = Color(0xFFE8E8EC);
  static const Color darkSecondaryLabel = Color(0xFF9898A0);
  static const Color darkTertiaryLabel = Color(0xFF68686F);

  static const Color darkTintColor = Color(0xFF8BA8D0);
  static const Color darkSystemGreen = Color(0xFF7EC48E);
  static const Color darkSystemRed = Color(0xFFE88880);
  static const Color darkSystemOrange = Color(0xFFE8C070);
  static const Color darkOpaqueSeparator = Color(0xFF48484F);
}
