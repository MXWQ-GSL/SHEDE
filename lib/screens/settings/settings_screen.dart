import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';

/// 设置页面 - Neumorphism 风格
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme; final sh = NeuShadows.of(context);
    return Scaffold(
      backgroundColor: c.neuBg,
      appBar: AppBar(
        title: const Text('设置'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          _sectionTitle('个性化', c),
          const SizedBox(height: 10),
          _menuItem(context, c, sh, icon: Icons.palette_outlined, title: '主题设置', subtitle: '浅色模式',
            onTap: () => context.push('/settings/theme')),
          const SizedBox(height: 20),

          _sectionTitle('预算', c),
          const SizedBox(height: 10),
          _menuItem(context, c, sh, icon: Icons.account_balance_wallet_outlined, title: '预算设置', subtitle: '设置月度预算上限',
            onTap: () => context.push('/settings/budget')),
          const SizedBox(height: 20),

          _sectionTitle('提醒', c),
          const SizedBox(height: 10),
          _menuItem(context, c, sh, icon: Icons.notifications_outlined, title: '提醒设置', subtitle: '设置提醒时间和方式',
            onTap: () => context.push('/settings/reminder')),
          const SizedBox(height: 20),

          _sectionTitle('数据', c),
          const SizedBox(height: 10),
          _menuItem(context, c, sh, icon: Icons.upload_outlined, title: '数据导出', subtitle: '导出为 CSV 文件',
            onTap: () => context.push('/export')),
          _menuItem(context, c, sh, icon: Icons.cloud_outlined, title: '云同步', subtitle: '功能开发中',
            onTap: () => _showComingSoon(context, '云同步', c)),
          _menuItem(context, c, sh, icon: Icons.storage_outlined, title: '本地数据', subtitle: '查看和管理本地数据',
            onTap: () => _showComingSoon(context, '本地数据管理', c)),
          const SizedBox(height: 20),

          _sectionTitle('关于', c),
          const SizedBox(height: 10),
          _menuItem(context, c, sh, icon: Icons.info_outline, title: '关于舍得', subtitle: '版本 1.0.0',
            onTap: () => _showAbout(context, c)),
          _menuItem(context, c, sh, icon: Icons.description_outlined, title: '用户协议',
            onTap: () => _showComingSoon(context, '用户协议', c)),
          _menuItem(context, c, sh, icon: Icons.shield_outlined, title: '隐私政策',
            onTap: () => _showComingSoon(context, '隐私政策', c)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, ColorScheme c) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 8),
      child: Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.neuSecondaryLabel)),
    );
  }

  Widget _menuItem(BuildContext context, ColorScheme c, NeuShadows sh, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.neuBg,
            borderRadius: BorderRadius.circular(18),
            boxShadow: sh.raisedSm,
          ),
          child: Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: c.neuBg,
                borderRadius: BorderRadius.circular(12),
                boxShadow: sh.raisedSm,
              ),
              child: Icon(icon, size: 20, color: c.neuTint),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.neuLabel)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel)),
                ],
              ],
            )),
            Icon(Icons.chevron_right, size: 20, color: c.neuSecondaryLabel),
          ]),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature, ColorScheme c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.neuBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(feature, style: TextStyle(fontWeight: FontWeight.w700, color: c.neuLabel)),
        content: Text('此功能正在开发中，敬请期待！', style: TextStyle(color: c.neuSecondaryLabel)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('好的', style: TextStyle(color: c.neuTint))),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context, ColorScheme c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.neuBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(Icons.account_balance_wallet, color: c.neuTint, size: 28),
          const SizedBox(width: 10),
          Text('舍得', style: TextStyle(fontWeight: FontWeight.w700, color: c.neuLabel)),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('版本：1.0.0', style: TextStyle(color: c.neuSecondaryLabel)),
            const SizedBox(height: 8),
            Text('舍去繁杂，得享从容。', style: TextStyle(color: c.neuLabel, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text('一款简洁高效的个人财务管理应用，帮助你清晰记录每一笔收支。', style: TextStyle(color: c.neuSecondaryLabel, fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('好的', style: TextStyle(color: c.neuTint))),
        ],
      ),
    );
  }
}
