import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'config/theme/shede_theme.dart';
import 'config/theme/shede_colors.dart';
import 'config/routes.dart';
import 'providers/settings_provider.dart';

/// 舍得 App 根组件
class ShedeApp extends StatefulWidget {
  const ShedeApp({super.key});

  @override
  State<ShedeApp> createState() => _ShedeAppState();
}

class _ShedeAppState extends State<ShedeApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 亮暗变化时更新导航栏颜色
  @override
  void didChangePlatformBrightness() {
    _updateNavBar();
  }

  void _updateNavBar() {
    final settings = context.read<SettingsProvider>();
    final platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final isDark = settings.themeMode == ThemeMode.dark ||
        (settings.themeMode == ThemeMode.system && platformBrightness == Brightness.dark);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDark ? SheDeColors.darkBackground : SheDeColors.background,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        // 主题变化时也更新导航栏
        WidgetsBinding.instance.addPostFrameCallback((_) => _updateNavBar());

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
