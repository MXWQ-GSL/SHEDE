import 'package:flutter/material.dart';
import 'shede_colors.dart';
import 'shede_theme.dart';

/// Neumorphism 主题适配
/// 用法: final c = context.neu; // 扩展 ColorScheme
///       final s = NeuShadows.of(context); // 阴影
extension NeuColors on ColorScheme {
  Color get neuBg => brightness == Brightness.dark ? SheDeColors.darkBackground : SheDeColors.background;
  Color get neuLabel => brightness == Brightness.dark ? SheDeColors.darkLabel : SheDeColors.label;
  Color get neuSecondaryLabel => brightness == Brightness.dark ? SheDeColors.darkSecondaryLabel : SheDeColors.secondaryLabel;
  Color get neuTertiaryLabel => brightness == Brightness.dark ? SheDeColors.darkTertiaryLabel : SheDeColors.tertiaryLabel;
  Color get neuTint => brightness == Brightness.dark ? SheDeColors.darkTintColor : SheDeColors.tintColor;
  Color get neuGreen => brightness == Brightness.dark ? SheDeColors.darkSystemGreen : SheDeColors.systemGreen;
  Color get neuRed => brightness == Brightness.dark ? SheDeColors.darkSystemRed : SheDeColors.systemRed;
  Color get neuOrange => brightness == Brightness.dark ? SheDeColors.darkSystemOrange : SheDeColors.systemOrange;
  Color get neuSeparator => brightness == Brightness.dark ? SheDeColors.darkOpaqueSeparator : SheDeColors.opaqueSeparator;
  Color get neuTeal => SheDeColors.systemTeal;
  Color get neuIndigo => SheDeColors.systemIndigo;
}

/// Neumorphism 阴影 - 根据主题自动切换
class NeuShadows {
  final bool isDark;
  NeuShadows._(this.isDark);

  factory NeuShadows.of(BuildContext context) =>
      NeuShadows._(Theme.of(context).brightness == Brightness.dark);

  List<BoxShadow> get raised => isDark ? ShedeTheme.darkRaisedShadow : ShedeTheme.raisedShadow;
  List<BoxShadow> get raisedSm => isDark ? ShedeTheme.darkRaisedShadowSm : ShedeTheme.raisedShadowSm;
  List<BoxShadow> get inset => isDark ? ShedeTheme.darkInsetShadow : ShedeTheme.insetShadow;
  List<BoxShadow> get darkCard => ShedeTheme.darkCardShadow;
}
