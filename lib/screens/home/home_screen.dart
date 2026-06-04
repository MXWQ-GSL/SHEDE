import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/repayment_provider.dart';
import '../../providers/living_cost_provider.dart';
import '../../models/transaction.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';

/// 首页 - Neumorphism 风格
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  ColorScheme get _c => Theme.of(context).colorScheme;
  NeuShadows get _s => NeuShadows.of(context);
  bool _isAmountVisible = true;
  late AnimationController _stagger;
  late final List<Animation<double>> _fades;
  late final List<Animation<Offset>> _slides;

  @override
  void initState() {
    super.initState();
    _stagger = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _fades = List.generate(5, (i) {
      final s = (i * 0.15).clamp(0.0, 1.0);
      return CurvedAnimation(parent: _stagger, curve: Interval(s, (s + 0.6).clamp(0.0, 1.0), curve: Curves.easeOut));
    });
    _slides = List.generate(5, (i) {
      final s = (i * 0.15).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
        CurvedAnimation(parent: _stagger, curve: Interval(s, (s + 0.6).clamp(0.0, 1.0), curve: Curves.easeOutCubic)),
      );
    });
    _stagger.forward();
  }

  @override
  void dispose() { _stagger.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 28),
              _anim(0, _buildNetWorthCard(context)),
              const SizedBox(height: 24),
              _anim(1, _buildQuickActions(context)),
              const SizedBox(height: 24),
              _anim(2, _buildBudgetCard(context)),
              const SizedBox(height: 24),
              _anim(3, _buildRepaymentSection(context)),
              const SizedBox(height: 24),
              _anim(4, _buildLcPayableSection(context)),
              const SizedBox(height: 24),
              _buildUpcomingSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _anim(int i, Widget child) {
    return FadeTransition(opacity: _fades[i], child: SlideTransition(position: _slides[i], child: child));
  }

  // ==================== 顶部标题 ====================

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('舍得', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: _c.neuLabel.withOpacity(0.9), letterSpacing: 1.5)),
          const SizedBox(height: 4),
          Text('舍去繁杂，得享从容', style: TextStyle(fontSize: 13, color: _c.neuSecondaryLabel)),
        ]),
        Row(children: [
          _neuCircleButton(Icons.folder_outlined, () => context.push('/projects')),
          const SizedBox(width: 10),
          _neuCircleButton(Icons.settings_outlined, () => context.push('/settings')),
        ]),
      ],
    );
  }

  // ==================== 净资产卡片（含还款负债） ====================

  Widget _buildNetWorthCard(BuildContext context) {
    final p = context.watch<TransactionProvider>();
    final repProvider = context.watch<RepaymentProvider>();
    final lcProvider = context.watch<LivingCostProvider>();
    final rec = p.getMonthlyReceivable();
    final pay = p.getMonthlyPayable();
    // 还款负债
    final repDebt = repProvider.allPendingEntries.fold<double>(0, (s, e) => s + e.entry.amount);
    // 生活成本负债（本月总支出）
    final now = DateTime.now();
    final lcData = lcProvider.getMonth(now.year, now.month);
    final lcDebt = lcData.totalSpent;
    final totalLiability = pay + repDebt + lcDebt;
    final net = rec - totalLiability;

    return _neuCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('净资产', style: TextStyle(fontSize: 13, color: _c.neuSecondaryLabel, fontWeight: FontWeight.w500)),
          GestureDetector(
            onTap: () => setState(() => _isAmountVisible = !_isAmountVisible),
            child: Icon(_isAmountVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20, color: _c.neuSecondaryLabel),
          ),
        ]),
        const SizedBox(height: 8),
        Text(_isAmountVisible ? '¥${_fmt(net)}' : '¥ ****',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: _c.neuLabel, letterSpacing: -0.5),
          maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 20),
        Container(height: 2, decoration: BoxDecoration(color: _c.neuSeparator.withOpacity(0.5), borderRadius: BorderRadius.circular(1))),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _buildAssetItem('总资产', rec, _c.neuGreen)),
          Container(width: 1, height: 40, color: _c.neuSeparator),
          Expanded(child: _buildAssetItem('总负债', totalLiability, _c.neuRed)),
        ]),
        if (repDebt > 0 || lcDebt > 0) ...[
          const SizedBox(height: 8),
          Center(child: Text(
            '还款 ¥${_fmt(repDebt)} · 生活 ¥${_fmt(lcDebt)}',
            style: TextStyle(fontSize: 11, color: _c.neuOrange, fontWeight: FontWeight.w500),
          )),
        ],
      ]),
    );
  }

  Widget _buildAssetItem(String label, double amount, Color color) {
    return Column(children: [
      Text(label, style: TextStyle(fontSize: 12, color: _c.neuSecondaryLabel, fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      Text(_isAmountVisible ? '¥${_fmt(amount)}' : '¥ ****',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color), maxLines: 1, overflow: TextOverflow.ellipsis),
    ]);
  }

  // ==================== 常用功能 ====================

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _neuAction(Icons.account_balance_wallet_outlined, '预算管理', _c.neuTint, () => context.push('/budget-manage')),
        _neuAction(Icons.payments_outlined, '舍得管理', _c.neuOrange, () => context.push('/expense-manage')),
        _neuAction(Icons.folder_outlined, '项目管理', _c.neuIndigo, () => context.push('/projects')),
      ],
    );
  }

  Widget _neuAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return _TapScale(
      onTap: onTap,
      child: Column(children: [
        Container(width: 56, height: 56,
          decoration: BoxDecoration(color: _c.neuBg, shape: BoxShape.circle, boxShadow: _s.raisedSm),
          child: Icon(icon, size: 24, color: color)),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: _c.neuSecondaryLabel, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  // ==================== 预算卡片 ====================

  Widget _buildBudgetCard(BuildContext context) {
    final p = context.watch<TransactionProvider>();
    final repProvider = context.watch<RepaymentProvider>();
    final budget = context.watch<SettingsProvider>().monthlyBudget;
    final spent = p.getMonthlySpent();
    // 当月还款金额同步到预算支出
    final now = DateTime.now();
    final repEntries = repProvider.getEntriesByMonth(now.year, now.month);
    final repSpent = repEntries.where((e) => e.entry.isCompleted).fold<double>(0, (s, e) => s + e.entry.amount);
    final repPending = repEntries.where((e) => !e.entry.isCompleted).fold<double>(0, (s, e) => s + e.entry.amount);
    final totalSpent = spent + repSpent + repPending; // 已支出 + 已还 + 待还（均计入本月预算消耗）
    final pct = budget > 0 ? (totalSpent / budget).clamp(0.0, 1.5) : 0.0;
    final over = pct > 1.0;
    final rem = budget - totalSpent;

    return _neuCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('本月预算', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _c.neuLabel)),
        Text('${(pct * 100).toInt()}%', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: over ? _c.neuRed : _c.neuTint)),
      ]),
      const SizedBox(height: 16),
      Container(height: 10, decoration: BoxDecoration(color: _c.neuBg, borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: _c.brightness == Brightness.dark ? Colors.black.withOpacity(0.4) : SheDeColors.shadowDark.withOpacity(0.4), offset: const Offset(2, 2), blurRadius: 4), BoxShadow(color: _c.brightness == Brightness.dark ? const Color(0xFF404048).withOpacity(0.3) : SheDeColors.shadowLight.withOpacity(0.6), offset: const Offset(-2, -2), blurRadius: 4)]),
        child: ClipRRect(borderRadius: BorderRadius.circular(10), child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: pct.clamp(0.0, 1.0)), duration: const Duration(milliseconds: 800), curve: Curves.easeOutCubic,
          builder: (_, v, __) => LinearProgressIndicator(value: v, backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(over ? _c.neuRed : _c.neuTint), minHeight: 10)))),
      const SizedBox(height: 14),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('预算 ¥${_fmt(budget)}', style: TextStyle(fontSize: 14, color: _c.neuSecondaryLabel)),
        Text(over ? '超支 ¥${_fmt(-rem)}' : '剩余 ¥${_fmt(rem)}',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: over ? _c.neuRed : _c.neuGreen)),
      ]),
      if (repSpent + repPending > 0) ...[
        const SizedBox(height: 8),
        Text('含还款 ¥${_fmt(repSpent + repPending)} · 消费 ¥${_fmt(spent)}',
          style: TextStyle(fontSize: 11, color: _c.neuTertiaryLabel, fontWeight: FontWeight.w500)),
      ],
    ]));
  }

  // ==================== 还款提醒 ====================

  Widget _buildRepaymentSection(BuildContext context) {
    final provider = context.watch<RepaymentProvider>();
    final upcoming = provider.upcomingEntries;
    if (upcoming.isEmpty) return const SizedBox();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('近期还款', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _c.neuLabel)),
        GestureDetector(onTap: () => context.push('/expense-manage'),
          child: Text('查看全部', style: TextStyle(fontSize: 13, color: _c.neuTint, fontWeight: FontWeight.w500))),
      ]),
      const SizedBox(height: 12),
      ...upcoming.take(3).map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: _c.neuBg, borderRadius: BorderRadius.circular(16), boxShadow: _s.raisedSm),
          child: Row(children: [
            Container(width: 38, height: 38,
              decoration: BoxDecoration(color: _c.neuBg, borderRadius: BorderRadius.circular(10), boxShadow: _s.raisedSm),
              child: Icon(Icons.receipt_long_outlined, size: 18, color: _c.neuOrange)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.plan.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _c.neuLabel), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(DateFormat('M月d日还款').format(item.entry.dueDate), style: TextStyle(fontSize: 12, color: _c.neuSecondaryLabel)),
            ])),
            Text('¥${item.entry.amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _c.neuOrange)),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => provider.markAsCompleted(item.plan.id, item.entry.year, item.entry.month),
              child: Container(padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: _c.neuBg, shape: BoxShape.circle, boxShadow: _s.raisedSm),
                child: Icon(Icons.check, size: 16, color: _c.neuGreen)),
            ),
          ]),
        ),
      )),
    ]);
  }

  // ==================== 近期应付（生活成本） ====================

  Widget _buildLcPayableSection(BuildContext context) {
    final lcProvider = context.watch<LivingCostProvider>();
    final now = DateTime.now();
    final lcData = lcProvider.getMonth(now.year, now.month);
    final entries = lcData.entries;

    if (entries.isEmpty) return const SizedBox();

    final recurring = entries.where((e) => e.isRecurring).toList();
    final variable = entries.where((e) => !e.isRecurring).toList();
    final recurringTotal = recurring.fold<double>(0, (s, e) => s + e.amount);
    final variableTotal = variable.fold<double>(0, (s, e) => s + e.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('近期应付', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _c.neuLabel)),
          GestureDetector(
            onTap: () => context.push('/expense-manage'),
            child: Text('查看全部', style: TextStyle(fontSize: 13, color: _c.neuTint, fontWeight: FontWeight.w500)),
          ),
        ]),
        const SizedBox(height: 12),

        // 总览条
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _c.neuBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _s.raisedSm,
          ),
          child: Row(children: [
            _lcSummaryItem('固定支出', recurringTotal, _c.neuOrange),
            Container(width: 1, height: 32, color: _c.neuSeparator),
            _lcSummaryItem('临时支出', variableTotal, _c.neuTeal),
            Container(width: 1, height: 32, color: _c.neuSeparator),
            _lcSummaryItem('合计', recurringTotal + variableTotal, _c.neuLabel),
          ]),
        ),
        const SizedBox(height: 10),

        // 条目列表（最多显示5条）
        ...entries.take(5).map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _c.neuBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: _s.raisedSm,
            ),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: _c.neuBg,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _s.raisedSm,
                ),
                child: Icon(_lcIcon(entry.category), size: 18, color: _c.neuTeal),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(entry.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _c.neuLabel), maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (entry.isRecurring) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _c.neuTint.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('固定', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: _c.neuTint)),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 2),
                  Text('${entry.category} · ${DateFormat('M月d日').format(entry.date)}', style: TextStyle(fontSize: 11, color: _c.neuSecondaryLabel)),
                ],
              )),
              Text('¥${entry.amount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _c.neuTeal)),
            ]),
          ),
        )),
      ],
    );
  }

  Widget _lcSummaryItem(String label, double amount, Color color) {
    return Expanded(child: Column(children: [
      Text(label, style: TextStyle(fontSize: 11, color: _c.neuSecondaryLabel)),
      const SizedBox(height: 3),
      Text('¥${_fmt(amount)}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
    ]));
  }

  IconData _lcIcon(String category) {
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

  // ==================== 待办账单 ====================

  Widget _buildUpcomingSection(BuildContext context) {
    final p = context.watch<TransactionProvider>();
    final upcoming = p.upcomingTransactions;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('本月待办', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _c.neuLabel)),
        GestureDetector(onTap: () => context.go('/calendar'),
          child: Text('查看全部', style: TextStyle(fontSize: 13, color: _c.neuTint, fontWeight: FontWeight.w500))),
      ]),
      const SizedBox(height: 14),
      if (upcoming.isEmpty)
        _neuCard(child: Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(children: [
            Container(width: 64, height: 64, decoration: BoxDecoration(color: _c.neuBg, shape: BoxShape.circle, boxShadow: _s.raisedSm),
              child: Icon(Icons.check_circle_outline_rounded, size: 30, color: _c.neuGreen)),
            const SizedBox(height: 14),
            Text('全部搞定！', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: _c.neuLabel)),
            const SizedBox(height: 6),
            Text('近期没有待处理的账单', style: TextStyle(fontSize: 14, color: _c.neuSecondaryLabel)),
          ]))))
      else
        SizedBox(height: 124, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: upcoming.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14), itemBuilder: (ctx, i) => _billCard(upcoming[i]))),
    ]);
  }

  Widget _billCard(Transaction t) {
    final r = t.type == TransactionType.receivable;
    final c = r ? _c.neuGreen : _c.neuRed;

    return GestureDetector(
      onLongPress: () => _showBillMenu(t),
      child: _TapScale(
        onTap: () => context.push('/add-record/${t.id}'),
        child: Container(width: 150, padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: _c.neuBg, borderRadius: BorderRadius.circular(20), boxShadow: _s.raisedSm),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Container(width: 28, height: 28,
                decoration: BoxDecoration(color: _c.neuBg, shape: BoxShape.circle, boxShadow: _s.raisedSm),
                child: Icon(r ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, size: 14, color: c)),
              const SizedBox(width: 8),
              Expanded(child: Text(t.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _c.neuLabel), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ]),
            Text('${r ? '+' : '-'}¥${_fmt(t.amount)}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: c), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(_fmtDate(t.dueDate), style: TextStyle(fontSize: 12, color: _c.neuSecondaryLabel)),
          ])),
      ),
    );
  }

  void _showBillMenu(Transaction t) {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        decoration: BoxDecoration(color: _c.neuBg, borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), boxShadow: _s.raised),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 5, decoration: BoxDecoration(color: _c.neuSecondaryLabel.withOpacity(0.3), borderRadius: BorderRadius.circular(3))),
          const SizedBox(height: 16),
          Text(t.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _c.neuLabel)),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: GestureDetector(
              onTap: () { Navigator.pop(ctx); context.push('/add-record/${t.id}'); },
              child: Container(padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: _c.neuBg, borderRadius: BorderRadius.circular(14), boxShadow: _s.raisedSm),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.edit_outlined, size: 18, color: _c.neuTint), SizedBox(width: 6),
                  Text('编辑', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _c.neuTint)),
                ])),
            )),
            const SizedBox(width: 12),
            Expanded(child: GestureDetector(
              onTap: () { context.read<TransactionProvider>().deleteTransaction(t.id); Navigator.pop(ctx); },
              child: Container(padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: _c.neuBg, borderRadius: BorderRadius.circular(14), boxShadow: _s.raisedSm),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.delete_outline, size: 18, color: _c.neuRed), SizedBox(width: 6),
                  Text('删除', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _c.neuRed)),
                ])),
            )),
          ]),
        ]),
      ),
    );
  }

  // ==================== 工具 ====================

  Widget _neuCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(width: double.infinity, padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(color: _c.neuBg, borderRadius: BorderRadius.circular(20), boxShadow: _s.raised), child: child);
  }

  Widget _neuCircleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(width: 46, height: 46,
      decoration: BoxDecoration(color: _c.neuBg, shape: BoxShape.circle, boxShadow: _s.raisedSm),
      child: Icon(icon, size: 22, color: _c.neuSecondaryLabel)));
  }

  String _fmt(double v) => v.abs() >= 10000 ? '${(v / 10000).toStringAsFixed(2)}万' : v.toStringAsFixed(2);
  String _fmtDate(DateTime d) {
    final diff = d.difference(DateTime.now()).inDays;
    if (diff == 0) return '今天到期';
    if (diff == 1) return '明天到期';
    if (diff <= 7) return '${diff}天后到期';
    return DateFormat('MM月dd日').format(d);
  }
}

class _TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _TapScale({required this.child, this.onTap});
  @override
  State<_TapScale> createState() => _TapScaleState();
}
class _TapScaleState extends State<_TapScale> {
  bool _p = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _p = true),
      onTapUp: (_) { setState(() => _p = false); widget.onTap?.call(); },
      onTapCancel: () => setState(() => _p = false),
      child: AnimatedScale(scale: _p ? 0.96 : 1.0, duration: const Duration(milliseconds: 100), curve: Curves.easeOut, child: widget.child),
    );
  }
}
