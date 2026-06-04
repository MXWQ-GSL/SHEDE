import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';

/// 预算设置 - Neumorphism 风格
class BudgetSettingsScreen extends StatefulWidget {
  const BudgetSettingsScreen({super.key});
  @override
  State<BudgetSettingsScreen> createState() => _BudgetSettingsScreenState();
}

class _BudgetSettingsScreenState extends State<BudgetSettingsScreen> {
  late TextEditingController _budgetCtrl;

  @override
  void initState() {
    super.initState();
    final s = context.read<SettingsProvider>();
    _budgetCtrl = TextEditingController(text: s.monthlyBudget > 0 ? s.monthlyBudget.toStringAsFixed(0) : '');
  }

  @override
  void dispose() { _budgetCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme; final sh = NeuShadows.of(context);
    return Scaffold(
      backgroundColor: c.neuBg,
      appBar: AppBar(title: const Text('预算设置'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context))),
      body: Consumer<SettingsProvider>(
        builder: (ctx, settings, _) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            // 月度预算
            _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('月度预算', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.neuLabel)),
              const SizedBox(height: 4),
              Text('设置每月支出上限', style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel)),
              const SizedBox(height: 14),
              _inputField(_budgetCtrl, '¥ ', '输入预算金额', (v) => settings.setMonthlyBudget(double.tryParse(v) ?? 0), c, sh),
            ]), c, sh),
            const SizedBox(height: 16),

            // 预算重置日
            _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('预算重置日', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.neuLabel)),
              const SizedBox(height: 4),
              Text('每月几号重置预算', style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(14), boxShadow: sh.inset),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: settings.budgetResetDay,
                    isExpanded: true,
                    dropdownColor: c.neuBg,
                    style: TextStyle(fontSize: 15, color: c.neuLabel),
                    items: List.generate(28, (i) => DropdownMenuItem(value: i + 1, child: Text('每月 ${i + 1} 日'))),
                    onChanged: (v) { if (v != null) settings.setBudgetResetDay(v); },
                  ),
                ),
              ),
            ]), c, sh),
            const SizedBox(height: 16),

            // 超支提醒
            _card(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('超支提醒', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.neuLabel)),
                const SizedBox(height: 2),
                Text('超出预算时提醒', style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel)),
              ]),
              Switch(value: settings.overBudgetAlert, onChanged: (v) => settings.setOverBudgetAlert(v)),
            ]), c, sh),
            const SizedBox(height: 24),

            // 提示
            _tipBox('当支出达到预算的 80% 时显示黄色警告，达到 100% 时显示红色提醒。', c),
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

  Widget _inputField(TextEditingController ctrl, String prefix, String hint, ValueChanged<String> onChanged, ColorScheme c, NeuShadows sh) {
    return Container(
      decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(14), boxShadow: sh.inset),
      child: TextField(
        controller: ctrl, keyboardType: TextInputType.number, onChanged: onChanged,
        decoration: InputDecoration(prefixText: prefix, hintText: hint, hintStyle: TextStyle(color: c.neuTertiaryLabel), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.neuLabel),
      ),
    );
  }

  Widget _tipBox(String text, ColorScheme c) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Icon(Icons.info_outline, size: 18, color: c.neuTint),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: c.neuSecondaryLabel))),
      ]),
    );
  }
}
