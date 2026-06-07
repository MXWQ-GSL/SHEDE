import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'config/theme/shede_theme.dart';
import 'config/theme/shede_colors.dart';
import 'config/routes.dart';
import 'providers/settings_provider.dart';

/// 舍得 App 根组件
class ShedeApp extends StatelessWidget {
  const ShedeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        final isDark = settings.themeMode == ThemeMode.dark ||
            (settings.themeMode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);

        // 根据主题切换导航栏颜色
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: isDark ? SheDeColors.darkBackground : SheDeColors.background,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ));

        return MaterialApp.router(
          title: '舍得',
          debugShowCheckedModeBanner: false,
          theme: ShedeTheme.lightTheme,
          darkTheme: ShedeTheme.darkTheme,
          themeMode: settings.themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
