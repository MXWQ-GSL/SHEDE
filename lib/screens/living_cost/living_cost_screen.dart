import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/living_cost_provider.dart';
import '../../models/living_cost.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';

/// 生活成本管理 - Neumorphism 风格
class LivingCostScreen extends StatefulWidget {
  const LivingCostScreen({super.key});
  @override
  State<LivingCostScreen> createState() => _LivingCostScreenState();
}

class _LivingCostScreenState extends State<LivingCostScreen> {
  late int _year;
  late int _month;
  late ColorScheme c;
  late NeuShadows sh;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
  }

  @override
  Widget build(BuildContext context) {
    c = Theme.of(context).colorScheme;
    sh = NeuShadows.of(context);
    final provider = context.watch<LivingCostProvider>();
    final data = provider.getMonth(_year, _month);

    return Scaffold(
      backgroundColor: c.neuBg,
      appBar: AppBar(
        title: const Text('生活成本'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          // 月份切换
          _buildMonthNav(),
          const SizedBox(height: 20),

          // 预算概览卡片
          _buildBudgetOverview(data, provider),
          const SizedBox(height: 24),

          // 支出列表
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('支出明细', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: c.neuLabel)),
            GestureDetector(
              onTap: () => _showAddSheet(provider),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(12), boxShadow: sh.raisedSm),
                child: Row(children: [
                  Icon(Icons.add, size: 16, color: c.neuTint),
                  SizedBox(width: 4),
                  Text('添加', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.neuTint)),
                ]),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          if (data.entries.isEmpty)
            _emptyState()
          else
            ...data.entries.map((e) => _buildEntryCard(e, data, provider)),
        ],
      ),
    );
  }

  Widget _buildMonthNav() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(16), boxShadow: sh.inset),
      child: Row(children: [
        _navBtn(Icons.chevron_left, () => setState(() {
          _month--;
          if (_month < 1) { _month = 12; _year--; }
        })),
        Expanded(child: Center(child: Text('$_year年$_month月', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: c.neuLabel)))),
        _navBtn(Icons.chevron_right, () => setState(() {
          _month++;
          if (_month > 12) { _month = 1; _year++; }
        })),
      ]),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(width: 36, height: 36, decoration: BoxDecoration(color: c.neuBg, shape: BoxShape.circle, boxShadow: sh.raisedSm),
        child: Icon(icon, size: 20, color: c.neuLabel)),
    );
  }

  Widget _buildBudgetOverview(LivingCostMonth data, LivingCostProvider provider) {
    final budget = data.monthlyBudget;
    final spent = data.totalSpent;
    final remaining = data.remaining;
    final pct = budget > 0 ? (spent / budget).clamp(0.0, 1.5) : 0.0;
    final over = pct > 1.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(20), boxShadow: sh.raised),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('本月生活成本', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.neuLabel)),
          GestureDetector(
            onTap: () => _showBudgetDialog(data, provider),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(10), boxShadow: sh.raisedSm),
              child: Text(budget > 0 ? '¥${budget.toStringAsFixed(0)}' : '设置预算',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: budget > 0 ? c.neuTint : c.neuSecondaryLabel)),
            ),
          ),
        ]),
        const SizedBox(height: 16),
        Text('¥${spent.toStringAsFixed(2)}', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: c.neuLabel)),
        const SizedBox(height: 12),
        if (budget > 0) ...[
          Container(
            height: 8,
            decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: c.brightness == Brightness.dark ? Colors.black.withOpacity(0.4) : SheDeColors.shadowDark.withOpacity(0.3), offset: const Offset(2, 2), blurRadius: 3), BoxShadow(color: c.brightness == Brightness.dark ? const Color(0xFF404048).withOpacity(0.3) : SheDeColors.shadowLight.withOpacity(0.5), offset: const Offset(-2, -2), blurRadius: 3)]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(value: pct.clamp(0.0, 1.0), backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(over ? c.neuRed : c.neuTint), minHeight: 8),
            ),
          ),
          const SizedBox(height: 8),
          Text(over ? '超支 ¥${(-remaining).toStringAsFixed(0)}' : '剩余 ¥${remaining.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: over ? c.neuRed : c.neuGreen)),
        ],
      ]),
    );
  }

  Widget _buildEntryCard(LivingCostEntry entry, LivingCostMonth data, LivingCostProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onLongPress: () {
          showDialog(context: context, builder: (dCtx) => AlertDialog(
            backgroundColor: c.neuBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('删除'),
            content: Text('删除「${entry.name}」？'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('取消')),
              TextButton(onPressed: () { provider.deleteEntry(_year, _month, entry.id); Navigator.pop(dCtx); },
                child: Text('删除', style: TextStyle(color: c.neuRed))),
            ],
          ));
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(16), boxShadow: sh.raisedSm),
          child: Row(children: [
            Container(width: 38, height: 38,
              decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(10), boxShadow: sh.raisedSm),
              child: Icon(_categoryIcon(entry.category), size: 18, color: c.neuOrange)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(entry.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.neuLabel)),
              Text(entry.category, style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel)),
            ])),
            Text('¥${entry.amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: c.neuLabel)),
          ]),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36),
      decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(20), boxShadow: sh.raised),
      child: Center(child: Column(children: [
        Container(width: 56, height: 56, decoration: BoxDecoration(color: c.neuBg, shape: BoxShape.circle, boxShadow: sh.raisedSm),
          child: Icon(Icons.shopping_bag_outlined, size: 26, color: c.neuSecondaryLabel)),
        const SizedBox(height: 12),
        Text('暂无支出记录', style: TextStyle(fontSize: 15, color: c.neuSecondaryLabel, fontWeight: FontWeight.w500)),
      ])),
    );
  }

  void _showBudgetDialog(LivingCostMonth data, LivingCostProvider provider) {
    final controller = TextEditingController(text: data.monthlyBudget > 0 ? data.monthlyBudget.toStringAsFixed(0) : '');
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: c.neuBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('设置生活成本预算'),
      content: TextField(controller: controller, keyboardType: TextInputType.number,
        decoration: const InputDecoration(prefixText: '¥ ', hintText: '输入月度预算金额')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
        TextButton(onPressed: () {
          final v = double.tryParse(controller.text) ?? 0;
          provider.setMonthlyBudget(_year, _month, v);
          Navigator.pop(ctx);
        }, child: Text('保存', style: TextStyle(color: c.neuTint))),
      ],
    ));
  }

  void _showAddSheet(LivingCostProvider provider) {
    String name = '';
    double amount = 0;
    String category = LivingCostProvider.categories.first;
    final amountCtrl = TextEditingController();

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setSheetState) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(color: c.neuBg, borderRadius: const BorderRadius.vertical(top: Radius.circular(28)), boxShadow: sh.raised),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: c.neuSecondaryLabel.withOpacity(0.3), borderRadius: BorderRadius.circular(3)))),
            const SizedBox(height: 16),
            Text('添加生活成本', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: c.neuLabel)),
            const SizedBox(height: 16),
            // 分类
            Wrap(spacing: 8, runSpacing: 8, children: LivingCostProvider.categories.map((cat) {
              final sel = category == cat;
              return GestureDetector(
                onTap: () => setSheetState(() => category = cat),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(16),
                    boxShadow: sel ? sh.inset : sh.raisedSm),
                  child: Text(cat, style: TextStyle(fontSize: 13, fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                    color: sel ? c.neuTint : c.neuSecondaryLabel))),
              );
            }).toList()),
            const SizedBox(height: 16),
            // 名称
            Container(decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(14), boxShadow: sh.inset),
              child: TextField(onChanged: (v) => name = v, decoration: const InputDecoration(hintText: '名称（如：本月房租）', border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)))),
            const SizedBox(height: 12),
            // 金额
            Container(decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(14), boxShadow: sh.inset),
              child: TextField(controller: amountCtrl, keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: '金额', prefixText: '¥ ', border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                onChanged: (v) => amount = double.tryParse(v) ?? 0)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (name.isNotEmpty && amount > 0) {
                  provider.addEntry(year: _year, month: _month, name: name, amount: amount, category: category);
                  Navigator.pop(ctx);
                }
              },
              child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: c.neuTint, borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: c.neuTint.withOpacity(0.3), offset: const Offset(0, 3), blurRadius: 8)]),
                child: const Center(child: Text('添加', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)))),
            ),
          ]),
        );
      }),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case '房租/房贷': return Icons.home_outlined;
      case '餐饮': return Icons.restaurant_outlined;
      case '交通': return Icons.directions_car_outlined;
      case '水电燃气': return Icons.bolt_outlined;
      case '通讯': return Icons.phone_outlined;
      case '日用品': return Icons.shopping_bag_outlined;
      case '医疗': return Icons.local_hospital_outlined;
      case '教育': return Icons.school_outlined;
      default: return Icons.more_horiz;
    }
  }
}
