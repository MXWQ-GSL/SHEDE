import 'package:flutter/material.dart';
import 'shede_colors.dart';

/// 舍得 App Neumorphism 主题
/// 核心：同色背景 + 双向阴影 = 浮雕 3D 效果
class ShedeTheme {
  ShedeTheme._();

  // ========== Neumorphism 阴影预设 ==========

  /// 凸起效果（默认态）
  static List<BoxShadow> get raisedShadow => [
    BoxShadow(
      color: SheDeColors.shadowDark.withOpacity(0.5),
      offset: const Offset(6, 6),
      blurRadius: 12,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: SheDeColors.shadowLight.withOpacity(0.8),
      offset: const Offset(-6, -6),
      blurRadius: 12,
      spreadRadius: 1,
    ),
  ];

  /// 凸起效果 - 小型元素
  static List<BoxShadow> get raisedShadowSm => [
    BoxShadow(
      color: SheDeColors.shadowDark.withOpacity(0.4),
      offset: const Offset(3, 3),
      blurRadius: 6,
    ),
    BoxShadow(
      color: SheDeColors.shadowLight.withOpacity(0.7),
      offset: const Offset(-3, -3),
      blurRadius: 6,
    ),
  ];

  /// 凹陷效果（按下态/选中态）
  static List<BoxShadow> get insetShadow => [
    BoxShadow(
      color: SheDeColors.shadowDark.withOpacity(0.5),
      offset: const Offset(4, 4),
      blurRadius: 8,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: SheDeColors.shadowLight.withOpacity(0.7),
      offset: const Offset(-4, -4),
      blurRadius: 8,
      spreadRadius: 1,
    ),
  ];

  /// 深色卡片阴影（深色主色调卡片）
  static List<BoxShadow> get darkCardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      offset: const Offset(6, 6),
      blurRadius: 16,
    ),
    BoxShadow(
      color: SheDeColors.shadowLight.withOpacity(0.1),
      offset: const Offset(-4, -4),
      blurRadius: 10,
    ),
  ];

  // ========== 深色模式阴影预设 ==========

  static List<BoxShadow> get darkRaisedShadow => [
    BoxShadow(color: SheDeColors.darkShadowDark.withOpacity(0.6), offset: const Offset(6, 6), blurRadius: 12, spreadRadius: 1),
    BoxShadow(color: SheDeColors.darkShadowLight.withOpacity(0.4), offset: const Offset(-6, -6), blurRadius: 12, spreadRadius: 1),
  ];

  static List<BoxShadow> get darkRaisedShadowSm => [
    BoxShadow(color: SheDeColors.darkShadowDark.withOpacity(0.5), offset: const Offset(3, 3), blurRadius: 6),
    BoxShadow(color: SheDeColors.darkShadowLight.withOpacity(0.3), offset: const Offset(-3, -3), blurRadius: 6),
  ];

  static List<BoxShadow> get darkInsetShadow => [
    BoxShadow(color: SheDeColors.darkShadowDark.withOpacity(0.6), offset: const Offset(4, 4), blurRadius: 8, spreadRadius: 1),
    BoxShadow(color: SheDeColors.darkShadowLight.withOpacity(0.4), offset: const Offset(-4, -4), blurRadius: 8, spreadRadius: 1),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      // 不设置 fontFamily，使用浏览器默认字体（天然支持中文）
      brightness: Brightness.light,

      colorScheme: const ColorScheme.light(
        primary: SheDeColors.tintColor,
        onPrimary: Colors.white,
        primaryContainer: SheDeColors.background,
        onPrimaryContainer: SheDeColors.label,
        secondary: SheDeColors.systemGreen,
        onSecondary: Colors.white,
        error: SheDeColors.systemRed,
        onError: Colors.white,
        surface: SheDeColors.surface,
        onSurface: SheDeColors.label,
        onSurfaceVariant: SheDeColors.secondaryLabel,
        outline: SheDeColors.opaqueSeparator,
        outlineVariant: SheDeColors.opaqueSeparator,
      ),

      scaffoldBackgroundColor: SheDeColors.background,

      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: SheDeColors.background,
        foregroundColor: SheDeColors.label,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: SheDeColors.label,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: SheDeColors.background,
          foregroundColor: SheDeColors.label,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SheDeColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: SheDeColors.tintColor, width: 1.5),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return SheDeColors.tintColor;
          }
          return SheDeColors.background;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return SheDeColors.tintColor.withOpacity(0.3);
          }
          return SheDeColors.opaqueSeparator;
        }),
      ),

      dividerTheme: const DividerThemeData(
        color: SheDeColors.opaqueSeparator,
        thickness: 0.5,
        space: 0,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.37,
          color: SheDeColors.label,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: SheDeColors.label,
        ),
        displaySmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: SheDeColors.label,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: SheDeColors.label,
        ),
        headlineSmall: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: SheDeColors.label,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: SheDeColors.label,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: SheDeColors.label,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: SheDeColors.secondaryLabel,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: SheDeColors.secondaryLabel,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: SheDeColors.secondaryLabel,
        ),
      ),
    );
  }

  // ========== 深色主题 ==========

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: const ColorScheme.dark(
        primary: SheDeColors.darkTintColor,
        onPrimary: SheDeColors.darkBackground,
        primaryContainer: SheDeColors.darkBackground,
        onPrimaryContainer: SheDeColors.darkLabel,
        secondary: SheDeColors.darkSystemGreen,
        onSecondary: SheDeColors.darkBackground,
        error: SheDeColors.darkSystemRed,
        onError: SheDeColors.darkBackground,
        surface: SheDeColors.darkSurface,
        onSurface: SheDeColors.darkLabel,
        onSurfaceVariant: SheDeColors.darkSecondaryLabel,
        outline: SheDeColors.darkOpaqueSeparator,
        outlineVariant: SheDeColors.darkOpaqueSeparator,
      ),

      scaffoldBackgroundColor: SheDeColors.darkBackground,

      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: SheDeColors.darkBackground,
        foregroundColor: SheDeColors.darkLabel,
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: SheDeColors.darkLabel),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: SheDeColors.darkBackground,
          foregroundColor: SheDeColors.darkLabel,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SheDeColors.darkBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: SheDeColors.darkTintColor, width: 1.5),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return SheDeColors.darkTintColor;
          return SheDeColors.darkBackground;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return SheDeColors.darkTintColor.withOpacity(0.3);
          return SheDeColors.darkOpaqueSeparator;
        }),
      ),

      dividerTheme: const DividerThemeData(color: SheDeColors.darkOpaqueSeparator, thickness: 0.5, space: 0),

      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: 0.37, color: SheDeColors.darkLabel),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: SheDeColors.darkLabel),
        displaySmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: SheDeColors.darkLabel),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: SheDeColors.darkLabel),
        headlineSmall: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: SheDeColors.darkLabel),
        bodyLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: SheDeColors.darkLabel),
        bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: SheDeColors.darkLabel),
        bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: SheDeColors.darkSecondaryLabel),
        labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: SheDeColors.darkSecondaryLabel),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: SheDeColors.darkSecondaryLabel),
      ),
    );
  }
}
