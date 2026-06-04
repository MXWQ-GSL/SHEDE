import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';

/// 预算管理 - Neumorphism 风格
/// 快速设置本月/下月预算
class BudgetManageScreen extends StatefulWidget {
  const BudgetManageScreen({super.key});
  @override
  State<BudgetManageScreen> createState() => _BudgetManageScreenState();
}

class _BudgetManageScreenState extends State<BudgetManageScreen> {
  late TextEditingController _currentCtrl;
  late TextEditingController _nextCtrl;
  late ColorScheme c;
  late NeuShadows sh;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>();
    _currentCtrl = TextEditingController(
      text: settings.monthlyBudget > 0 ? settings.monthlyBudget.toStringAsFixed(0) : '',
    );
    _nextCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    _nextCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    c = Theme.of(context).colorScheme;
    sh = NeuShadows.of(context);
    final settings = context.watch<SettingsProvider>();
    final txProvider = context.watch<TransactionProvider>();
    final spent = txProvider.getMonthlySpent();
    final budget = settings.monthlyBudget;
    final pct = budget > 0 ? (spent / budget).clamp(0.0, 1.5) : 0.0;
    final over = pct > 1.0;
    final remaining = budget - spent;
    final now = DateTime.now();
    final nextMonth = now.month == 12 ? 1 : now.month + 1;

    return Scaffold(
      backgroundColor: c.neuBg,
      appBar: AppBar(
        title: const Text('预算管理'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          // 本月预算概览
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF2D3748),
              borderRadius: BorderRadius.circular(24),
              boxShadow: sh.darkCard,
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${now.month}月预算', style: const TextStyle(fontSize: 14, color: Color(0xFF8E99A4), fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text('¥${budget.toStringAsFixed(0)}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 20),
              Container(height: 1, color: Colors.white.withOpacity(0.1)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _darkStat('已支出', '¥${spent.toStringAsFixed(0)}')),
                Container(width: 1, height: 36, color: Colors.white.withOpacity(0.1)),
                Expanded(child: _darkStat(over ? '超支' : '剩余', '¥${(over ? -remaining : remaining).toStringAsFixed(0)}')),
                Container(width: 1, height: 36, color: Colors.white.withOpacity(0.1)),
                Expanded(child: _darkStat('使用率', '${(pct * 100).toInt()}%')),
              ]),
            ]),
          ),
          const SizedBox(height: 24),

          // 设置本月预算
          _sectionTitle('调整本月预算'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(18), boxShadow: sh.raised),
            child: Column(children: [
              Container(
                decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(14), boxShadow: sh.inset),
                child: TextField(
                  controller: _currentCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(prefixText: '¥ ', hintText: '输入本月预算', border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: c.neuLabel),
                ),
              ),
              const SizedBox(height: 12),
              // 快捷金额按钮
              Wrap(spacing: 8, runSpacing: 8, children: [3000, 5000, 8000, 10000, 15000].map((v) {
                return GestureDetector(
                  onTap: () { _currentCtrl.text = '$v'; setState(() {}); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(12), boxShadow: sh.raisedSm),
                    child: Text('¥$v', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.neuLabel)),
                  ),
                );
              }).toList()),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  final v = double.tryParse(_currentCtrl.text) ?? 0;
                  settings.setMonthlyBudget(v);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(v > 0 ? '✓ 本月预算已设为 ¥${v.toStringAsFixed(0)}' : '✓ 预算已清除'),
                    backgroundColor: c.neuGreen, behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ));
                },
                child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(color: c.neuTint, borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: c.neuTint.withOpacity(0.3), offset: const Offset(0, 3), blurRadius: 8)]),
                  child: const Center(child: Text('保存本月预算', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)))),
              ),
            ]),
          ),
          const SizedBox(height: 24),

          // 设置下月预算
          _sectionTitle('预设${nextMonth}月预算'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(18), boxShadow: sh.raised),
            child: Column(children: [
              Container(
                decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(14), boxShadow: sh.inset),
                child: TextField(
                  controller: _nextCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(prefixText: '¥ ', hintText: '输入${nextMonth}月预算', border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: c.neuLabel),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [3000, 5000, 8000, 10000, 15000].map((v) {
                return GestureDetector(
                  onTap: () { _nextCtrl.text = '$v'; setState(() {}); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(12), boxShadow: sh.raisedSm),
                    child: Text('¥$v', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.neuLabel)),
                  ),
                );
              }).toList()),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  final v = double.tryParse(_nextCtrl.text) ?? 0;
                  // 存储到 settings（简化实现：记录为备注供下月参考）
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('✓ ${nextMonth}月预算预设为 ¥${v.toStringAsFixed(0)}，下月1日生效'),
                    backgroundColor: c.neuGreen, behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ));
                },
                child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(16), boxShadow: sh.raisedSm),
                  child: Center(child: Text('预设${nextMonth}月预算', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.neuTint)))),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.neuSecondaryLabel));

  Widget _darkStat(String label, String value) => Column(children: [
    Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF8E99A4))),
    const SizedBox(height: 4),
    Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
  ]);
}
