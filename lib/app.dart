import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme/shede_theme.dart';
import 'config/routes.dart';
import 'providers/settings_provider.dart';

/// 舍得 App 根组件
class ShedeApp extends StatelessWidget {
  const ShedeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
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
