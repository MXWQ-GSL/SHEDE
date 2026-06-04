import 'package:flutter/material.dart';
import 'shede_colors.dart';
import 'shede_theme.dart';

/// Neumorphism 主题适配工具
/// 根据当前 brightness 返回正确的颜色和阴影
class NeuTheme {
  NeuTheme._();

  /// 当前是否深色模式
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// 背景色
  static Color bg(BuildContext context) =>
      isDark(context) ? SheDeColors.darkBackground : SheDeColors.background;

  /// 主要文字色
  static Color label(BuildContext context) =>
      isDark(context) ? SheDeColors.darkLabel : SheDeColors.label;

  /// 次要文字色
  static Color secondaryLabel(BuildContext context) =>
      isDark(context) ? SheDeColors.darkSecondaryLabel : SheDeColors.secondaryLabel;

  /// 辅助文字色
  static Color tertiaryLabel(BuildContext context) =>
      isDark(context) ? SheDeColors.darkTertiaryLabel : SheDeColors.tertiaryLabel;

  /// 强调色
  static Color tint(BuildContext context) =>
      isDark(context) ? SheDeColors.darkTintColor : SheDeColors.tintColor;

  /// 收入/绿色
  static Color green(BuildContext context) =>
      isDark(context) ? SheDeColors.darkSystemGreen : SheDeColors.systemGreen;

  /// 支出/红色
  static Color red(BuildContext context) =>
      isDark(context) ? SheDeColors.darkSystemRed : SheDeColors.systemRed;

  /// 警告/橙色
  static Color orange(BuildContext context) =>
      isDark(context) ? SheDeColors.darkSystemOrange : SheDeColors.systemOrange;

  /// 分隔线
  static Color separator(BuildContext context) =>
      isDark(context) ? SheDeColors.darkOpaqueSeparator : SheDeColors.opaqueSeparator;

  /// 凸起阴影
  static List<BoxShadow> raisedShadow(BuildContext context) =>
      isDark(context) ? ShedeTheme.darkRaisedShadow : ShedeTheme.raisedShadow;

  /// 小型凸起阴影
  static List<BoxShadow> raisedShadowSm(BuildContext context) =>
      isDark(context) ? ShedeTheme.darkRaisedShadowSm : ShedeTheme.raisedShadowSm;

  /// 凹陷阴影
  static List<BoxShadow> insetShadow(BuildContext context) =>
      isDark(context) ? ShedeTheme.darkInsetShadow : ShedeTheme.insetShadow;
}
