import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';

/// 主题设置 - Neumorphism 风格
class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final sh = NeuShadows.of(context);
    return Scaffold(
      backgroundColor: c.neuBg,
      appBar: AppBar(title: const Text('主题设置'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context))),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            Text('外观模式', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.neuSecondaryLabel)),
            const SizedBox(height: 12),
            _option(context, settings, ThemeMode.system, Icons.phone_iphone_outlined, '跟随系统', '根据系统设置自动切换', c, sh),
            const SizedBox(height: 12),
            _option(context, settings, ThemeMode.light, Icons.light_mode_outlined, '浅色模式', '始终使用浅色主题', c, sh),
            const SizedBox(height: 12),
            _option(context, settings, ThemeMode.dark, Icons.dark_mode_outlined, '深色模式', '始终使用深色主题', c, sh),
          ],
        ),
      ),
    );
  }

  Widget _option(BuildContext ctx, SettingsProvider s, ThemeMode mode, IconData icon, String title, String subtitle, ColorScheme c, NeuShadows sh) {
    final sel = s.themeMode == mode;
    return GestureDetector(
      onTap: () => s.setThemeMode(mode),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.neuBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: sel ? sh.inset : sh.raisedSm,
        ),
        child: Row(children: [
          Container(width: 42, height: 42,
            decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(12), boxShadow: sh.raisedSm),
            child: Icon(icon, size: 22, color: sel ? c.neuTint : c.neuSecondaryLabel)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 15, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, color: sel ? c.neuTint : c.neuLabel)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel)),
          ])),
          if (sel) Icon(Icons.check_circle, size: 22, color: c.neuTint),
        ]),
      ),
    );
  }
}
