import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';

/// 提醒设置 - Neumorphism 风格
class ReminderSettingsScreen extends StatelessWidget {
  const ReminderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme; final sh = NeuShadows.of(context);
    return Scaffold(
      backgroundColor: c.neuBg,
      appBar: AppBar(title: const Text('提醒设置'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context))),
      body: Consumer<SettingsProvider>(
        builder: (ctx, settings, _) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            // 启用提醒
            _card(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('启用提醒', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.neuLabel)),
                const SizedBox(height: 2),
                Text('开启后会在到期前提醒您', style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel)),
              ]),
              Switch(value: settings.reminderEnabled, onChanged: (v) => settings.setReminderEnabled(v)),
            ]), c, sh),

            if (settings.reminderEnabled) ...[
              const SizedBox(height: 16),
              // 提醒时间
              _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('提醒时间', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.neuLabel)),
                const SizedBox(height: 4),
                Text('每天几点发送提醒', style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel)),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () async {
                    final t = await showTimePicker(context: context, initialTime: settings.reminderTime);
                    if (t != null) settings.setReminderTime(t);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(14), boxShadow: sh.raisedSm),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(
                        '${settings.reminderTime.hour.toString().padLeft(2, '0')}:${settings.reminderTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: c.neuLabel)),
                      Icon(Icons.access_time_outlined, size: 22, color: c.neuSecondaryLabel),
                    ]),
                  ),
                ),
              ]), c, sh),
              const SizedBox(height: 16),
              // 提前提醒
              _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('提前提醒', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.neuLabel)),
                const SizedBox(height: 4),
                Text('提前几天提醒', style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel)),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(14), boxShadow: sh.inset),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: settings.reminderAdvanceDays,
                      isExpanded: true,
                      dropdownColor: c.neuBg,
                      style: TextStyle(fontSize: 15, color: c.neuLabel),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('当天提醒')),
                        DropdownMenuItem(value: 1, child: Text('提前 1 天')),
                        DropdownMenuItem(value: 2, child: Text('提前 2 天')),
                        DropdownMenuItem(value: 3, child: Text('提前 3 天')),
                        DropdownMenuItem(value: 7, child: Text('提前 1 周')),
                      ],
                      onChanged: (v) { if (v != null) settings.setReminderAdvanceDays(v); },
                    ),
                  ),
                ),
              ]), c, sh),
            ],
          ],
        ),
      ),
    );
  }

  Widget _card(Widget child, ColorScheme c, NeuShadows sh) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(18), boxShadow: sh.raised),
    child: child,
  );
}
