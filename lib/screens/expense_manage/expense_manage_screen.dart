import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/repayment_provider.dart';
import '../../providers/living_cost_provider.dart';
import '../../models/repayment.dart';
import '../../models/living_cost.dart';
import '../../widgets/neu_date_picker.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';

/// 舍得管理 - 统一支出/收入入口
/// 整合生活成本 + 还款管理
class ExpenseManageScreen extends StatefulWidget {
  const ExpenseManageScreen({super.key});
  @override
  State<ExpenseManageScreen> createState() => _ExpenseManageScreenState();
}

class _ExpenseManageScreenState extends State<ExpenseManageScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _year;
  late int _month;
  late ColorScheme c;
  late NeuShadows sh;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    c = Theme.of(context).colorScheme;
    sh = NeuShadows.of(context);
    final repProvider = context.watch<RepaymentProvider>();
    final lcProvider = context.watch<LivingCostProvider>();
    final lcData = lcProvider.getMonth(_year, _month);
    final repEntries = repProvider.getEntriesByMonth(_year, _month);

    return Scaffold(
      backgroundColor: c.neuBg,
      appBar: AppBar(
        title: const Text('舍得管理'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          // 月份切换 + 总览卡片
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(children: [
              _buildMonthNav(),
              const SizedBox(height: 16),
              _buildOverviewCard(lcData, repEntries),
            ]),
          ),
          const SizedBox(height: 16),

          // Tab 切换
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: c.neuBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: sh.inset,
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: c.neuBg,
                borderRadius: BorderRadius.circular(12),
                boxShadow: sh.raisedSm,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: c.neuTint,
              unselectedLabelColor: c.neuSecondaryLabel,
              labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: '生活成本'),
                Tab(text: '还款计划'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Tab 内容
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLivingCostTab(lcData, lcProvider),
                _buildRepaymentTab(repEntries, repProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 月份切换 ====================

  Widget _buildMonthNav() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: sh.inset,
      ),
      child: Row(children: [
        _navBtn(Icons.chevron_left, () => setState(() {
          _month--;
          if (_month < 1) { _month = 12; _year--; }
        })),
        Expanded(child: Center(child: Text(
          '$_year年$_month月',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: c.neuLabel),
        ))),
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
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: c.neuBg,
          shape: BoxShape.circle,
          boxShadow: sh.raisedSm,
        ),
        child: Icon(icon, size: 20, color: c.neuLabel),
      ),
    );
  }

  // ==================== 总览卡片 ====================

  Widget _buildOverviewCard(LivingCostMonth lcData, List<({RepaymentPlan plan, RepaymentEntry entry})> repEntries) {
    final lcSpent = lcData.totalSpent;
    final repTotal = repEntries.fold<double>(0, (s, e) => s + e.entry.amount);
    final totalOut = lcSpent + repTotal;
    // 固定/非固定拆分
    final fixedTotal = lcData.entries.where((e) => e.isRecurring).fold<double>(0, (s, e) => s + e.amount);
    final variableTotal = lcSpent - fixedTotal;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3748),
        borderRadius: BorderRadius.circular(24),
        boxShadow: sh.darkCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$_month月总支出', style: const TextStyle(fontSize: 14, color: Color(0xFF8E99A4), fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text('¥${totalOut.toStringAsFixed(0)}', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.5)),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 14),
          Row(children: [
            _darkStat('固定支出', '¥${fixedTotal.toStringAsFixed(0)}'),
            Container(width: 1, height: 36, color: Colors.white.withOpacity(0.1)),
            _darkStat('临时支出', '¥${variableTotal.toStringAsFixed(0)}'),
            Container(width: 1, height: 36, color: Colors.white.withOpacity(0.1)),
            _darkStat('还款总额', '¥${repTotal.toStringAsFixed(0)}'),
          ]),
        ],
      ),
    );
  }

  Widget _darkStat(String label, String value) {
    return Expanded(child: Column(children: [
      Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF8E99A4))),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
    ]));
  }

  // ==================== 生活成本 Tab ====================

  Widget _buildLivingCostTab(LivingCostMonth data, LivingCostProvider provider) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      children: [
        // 添加按钮 + 标题
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('支出明细', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: c.neuLabel)),
          _addButton(() => _showAddLcSheet(provider)),
        ]),
        const SizedBox(height: 12),

        if (data.entries.isEmpty)
          _emptyState(Icons.shopping_bag_outlined, '暂无生活成本记录')
        else
          ...data.entries.map((e) => _lcEntryCard(e, data, provider)),
      ],
    );
  }

  Widget _lcEntryCard(LivingCostEntry entry, LivingCostMonth data, LivingCostProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onLongPress: () => _confirmDelete(
          '删除「${entry.name}」？',
          () => provider.deleteEntry(_year, _month, entry.id),
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: c.neuBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: sh.raisedSm,
          ),
          child: Row(children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: c.neuBg,
                borderRadius: BorderRadius.circular(10),
                boxShadow: sh.raisedSm,
              ),
              child: Icon(_lcCategoryIcon(entry.category), size: 18, color: c.neuOrange),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(entry.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c.neuLabel)),
                  if (entry.isRecurring) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: c.neuTint.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('固定', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: c.neuTint)),
                    ),
                  ],
                ]),
                const SizedBox(height: 2),
                Text('${entry.category} · ${DateFormat('M月d日').format(entry.date)}', style: TextStyle(fontSize: 11, color: c.neuSecondaryLabel)),
              ],
            )),
            Text('¥${entry.amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: c.neuLabel)),
          ]),
        ),
      ),
    );
  }

  // ==================== 还款计划 Tab ====================

  Widget _buildRepaymentTab(
    List<({RepaymentPlan plan, RepaymentEntry entry})> entries,
    RepaymentProvider provider,
  ) {
    // 按还款计划分组
    final plans = provider.plans;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      children: [
        // 还款概览
        _repSummaryCard(entries),
        const SizedBox(height: 16),

        // 添加按钮 + 标题
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('还款计划', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: c.neuLabel)),
          _addButton(() => context.push('/repayment/add')),
        ]),
        const SizedBox(height: 12),

        if (plans.isEmpty)
          _emptyState(Icons.receipt_long_outlined, '暂无还款计划')
        else
          ...plans.map((plan) => _repPlanCard(plan, entries, provider)),
      ],
    );
  }

  Widget _repSummaryCard(List<({RepaymentPlan plan, RepaymentEntry entry})> entries) {
    final total = entries.fold<double>(0, (s, e) => s + e.entry.amount);
    final done = entries.where((e) => e.entry.isCompleted).fold<double>(0, (s, e) => s + e.entry.amount);
    final pending = total - done;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: sh.raised,
      ),
      child: Row(children: [
        _repStat('本月还款', '¥${total.toStringAsFixed(0)}', c.neuLabel),
        Container(width: 1, height: 36, color: c.neuSeparator),
        _repStat('已还', '¥${done.toStringAsFixed(0)}', c.neuGreen),
        Container(width: 1, height: 36, color: c.neuSeparator),
        _repStat('待还', '¥${pending.toStringAsFixed(0)}', c.neuOrange),
      ]),
    );
  }

  Widget _repStat(String label, String value, Color valueColor) {
    return Expanded(child: Column(children: [
      Text(label, style: TextStyle(fontSize: 11, color: c.neuSecondaryLabel)),
      const SizedBox(height: 4),
      Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: valueColor)),
    ]));
  }

  Widget _repPlanCard(
    RepaymentPlan plan,
    List<({RepaymentPlan plan, RepaymentEntry entry})> allEntries,
    RepaymentProvider provider,
  ) {
    // 找出该计划在本月的条目
    final monthEntry = plan.getEntryForMonth(_year, _month);
    if (monthEntry == null) return const SizedBox();

    final isDone = monthEntry.isCompleted;
    final isOverdue = monthEntry.isOverdue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: c.neuBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: sh.raisedSm,
        ),
        child: Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: c.neuBg,
              borderRadius: BorderRadius.circular(10),
              boxShadow: sh.raisedSm,
            ),
            child: Icon(
              isDone ? Icons.check_circle_outline : Icons.receipt_long_outlined,
              size: 18,
              color: isDone ? c.neuGreen : (isOverdue ? c.neuRed : c.neuOrange),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(plan.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c.neuLabel), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(
                '${monthEntry.dueDay}日还款 · ${isDone ? "已还" : (isOverdue ? "逾期" : "待还")}',
                style: TextStyle(
                  fontSize: 11,
                  color: isDone ? c.neuGreen : (isOverdue ? c.neuRed : c.neuSecondaryLabel),
                ),
              ),
            ],
          )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('¥${monthEntry.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDone ? c.neuGreen : c.neuLabel,
                )),
              const SizedBox(height: 4),
              if (!isDone)
                GestureDetector(
                  onTap: () => provider.markAsCompleted(plan.id, _year, _month),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: c.neuTint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('标记已还', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
            ],
          ),
        ]),
      ),
    );
  }

  // ==================== 公共组件 ====================

  Widget _addButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: c.neuBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: sh.raisedSm,
        ),
        child: Row(children: [
          Icon(Icons.add, size: 16, color: c.neuTint),
          SizedBox(width: 4),
          Text('添加', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.neuTint)),
        ]),
      ),
    );
  }

  Widget _emptyState(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: sh.raised,
      ),
      child: Center(child: Column(children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: c.neuBg,
            shape: BoxShape.circle,
            boxShadow: sh.raisedSm,
          ),
          child: Icon(icon, size: 26, color: c.neuSecondaryLabel),
        ),
        const SizedBox(height: 12),
        Text(text, style: TextStyle(fontSize: 15, color: c.neuSecondaryLabel, fontWeight: FontWeight.w500)),
      ])),
    );
  }

  // ==================== 弹窗 ====================

  void _showAddLcSheet(LivingCostProvider provider) {
    String name = '';
    double amount = 0;
    String category = LivingCostProvider.categories.first;
    bool isRecurring = false;
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Container(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + MediaQuery.of(context).padding.bottom),
            decoration: BoxDecoration(
              color: c.neuBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: sh.raised,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: c.neuSecondaryLabel.withOpacity(0.3), borderRadius: BorderRadius.circular(3)))),
                const SizedBox(height: 16),
                Text('添加生活成本', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: c.neuLabel)),
                const SizedBox(height: 16),
                // 分类选择
                Wrap(spacing: 8, runSpacing: 8, children: LivingCostProvider.categories.map((cat) {
                  final sel = category == cat;
                  return GestureDetector(
                    onTap: () => setSheetState(() => category = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: c.neuBg,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: sel ? sh.inset : sh.raisedSm,
                      ),
                      child: Text(cat, style: TextStyle(
                        fontSize: 13,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                        color: sel ? c.neuTint : c.neuSecondaryLabel,
                      )),
                    ),
                  );
                }).toList()),
                const SizedBox(height: 16),
                // 名称
                _inputField('名称（如：房租）', (v) => name = v),
                const SizedBox(height: 12),
                // 金额
                _inputField('金额', (v) => amount = double.tryParse(v) ?? 0, prefix: '¥ ', keyboard: TextInputType.number),
                const SizedBox(height: 12),
                // 日期选择
                GestureDetector(
                  onTap: () async {
                    final d = await showNeuDatePicker(context, initialDate: selectedDate);
                    if (d != null) setSheetState(() => selectedDate = d);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: c.neuBg,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: sh.raisedSm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('yyyy年M月d日').format(selectedDate),
                          style: TextStyle(fontSize: 15, color: c.neuLabel),
                        ),
                        Icon(Icons.calendar_today_outlined, size: 18, color: c.neuSecondaryLabel),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // 每月固定支出开关
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.neuBg,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: sh.raisedSm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('每月固定支出', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c.neuLabel)),
                          const SizedBox(height: 2),
                          Text('开启后每月自动添加，日历同步显示', style: TextStyle(fontSize: 11, color: c.neuSecondaryLabel)),
                        ],
                      ),
                      Switch(
                        value: isRecurring,
                        onChanged: (v) => setSheetState(() => isRecurring = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _saveButton(isRecurring ? '添加为固定支出' : '添加', () {
                  if (name.isNotEmpty && amount > 0) {
                    provider.addEntry(
                      year: _year,
                      month: _month,
                      name: name,
                      amount: amount,
                      category: category,
                      date: selectedDate,
                      isRecurring: isRecurring,
                    );
                    Navigator.pop(ctx);
                  }
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.neuBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('删除'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () { onConfirm(); Navigator.pop(ctx); },
            child: Text('删除', style: TextStyle(color: c.neuRed)),
          ),
        ],
      ),
    );
  }

  Widget _inputField(String hint, ValueChanged<String> onChanged, {String? prefix, TextInputType? keyboard}) {
    return Container(
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: sh.inset,
      ),
      child: TextField(
        keyboardType: keyboard,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: c.neuTertiaryLabel),
          prefixText: prefix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: TextStyle(fontSize: 15, color: c.neuLabel),
      ),
    );
  }

  Widget _saveButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: c.neuTint,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: c.neuTint.withOpacity(0.3), offset: const Offset(0, 3), blurRadius: 8)],
        ),
        child: Center(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white))),
      ),
    );
  }

  IconData _lcCategoryIcon(String category) {
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
