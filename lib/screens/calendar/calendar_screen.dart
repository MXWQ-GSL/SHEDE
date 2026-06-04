import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/repayment_provider.dart';
import '../../providers/living_cost_provider.dart';
import '../../providers/settings_provider.dart';
import '../../models/transaction.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';

/// 账单日历 - Neumorphism 风格
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  late ColorScheme c;
  late NeuShadows sh;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

    c = Theme.of(context).colorScheme;
    sh = NeuShadows.of(context);

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部标题
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('舍得', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: c.neuLabel, letterSpacing: 1.5)),
                    const SizedBox(height: 4),
                    Text('账单日历', style: TextStyle(fontSize: 13, color: c.neuSecondaryLabel)),
                  ]),
                  Row(children: [
                    _navSmall(Icons.folder_outlined, () => context.push('/projects')),
                    const SizedBox(width: 8),
                    _navSmall(Icons.settings_outlined, () => context.push('/settings')),
                  ]),
                ],
              ),
              const SizedBox(height: 24),

              // 日历卡片
              _buildCalendarCard(provider),
              const SizedBox(height: 16),

              // 图例
              _buildLegend(),
              const SizedBox(height: 20),

              // 日期标题
              _buildDateHeader(),
              const SizedBox(height: 12),

              // 时间线
              _buildTimeline(provider),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== 日历 ====================

  Widget _buildCalendarCard(TransactionProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: sh.raised,
      ),
      child: Column(children: [
        _monthNav(),
        const SizedBox(height: 16),
        _weekdayHeader(),
        const SizedBox(height: 8),
        _dateGrid(provider),
      ]),
    );
  }

  Widget _monthNav() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _navArrow(Icons.chevron_left, () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1))),
      GestureDetector(
        onTap: () => setState(() { _selectedDate = DateTime.now(); _focusedMonth = DateTime.now(); }),
        child: Text(DateFormat('yyyy年M月').format(_focusedMonth), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: c.neuLabel)),
      ),
      _navArrow(Icons.chevron_right, () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1))),
    ]);
  }

  Widget _navArrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: c.neuBg,
          shape: BoxShape.circle,
          boxShadow: sh.raisedSm,
        ),
        child: Icon(icon, size: 22, color: c.neuLabel),
      ),
    );
  }

  Widget _navSmall(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: c.neuBg,
          shape: BoxShape.circle,
          boxShadow: sh.raisedSm,
        ),
        child: Icon(icon, size: 20, color: c.neuSecondaryLabel),
      ),
    );
  }

  Widget _weekdayHeader() {
    const days = ['日', '一', '二', '三', '四', '五', '六'];
    return Row(children: days.map((d) => Expanded(
      child: Center(child: Text(d, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.neuSecondaryLabel))),
    )).toList());
  }

  Widget _dateGrid(TransactionProvider provider) {
    final repProvider = context.watch<RepaymentProvider>();
    final lcProvider = context.watch<LivingCostProvider>();
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final startOffset = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
      itemCount: 42,
      itemBuilder: (context, index) {
        final dayOffset = index - startOffset;
        if (dayOffset < 0 || dayOffset >= daysInMonth) return const SizedBox();
        final date = DateTime(_focusedMonth.year, _focusedMonth.month, dayOffset + 1);
        final txs = provider.getTransactionsByDate(date);
        final hasRepayment = repProvider.getEntriesByDate(date).isNotEmpty;
        final hasLc = lcProvider.getEntriesByDate(date).isNotEmpty;
        final sel = _selectedDate.year == date.year && _selectedDate.month == date.month && _selectedDate.day == date.day;
        final today = DateTime.now().year == date.year && DateTime.now().month == date.month && DateTime.now().day == date.day;
        final hasRec = txs.any((t) => t.type == TransactionType.receivable);
        final hasPay = txs.any((t) => t.type == TransactionType.payable);

        return GestureDetector(
          onTap: () => setState(() => _selectedDate = date),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: c.neuBg,
              borderRadius: BorderRadius.circular(14),
              boxShadow: sel
                  ? sh.inset
                  : today
                      ? sh.raisedSm
                      : null,
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${date.day}', style: TextStyle(
                fontSize: 15,
                fontWeight: (sel || today) ? FontWeight.w700 : FontWeight.w500,
                color: sel ? c.neuTint : (today ? c.neuTint : c.neuLabel),
              )),
              if (hasPay || hasRec || hasRepayment || hasLc) ...[
                const SizedBox(height: 2),
                Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                  if (hasPay) Container(width: 5, height: 5, decoration: BoxDecoration(color: c.neuRed, shape: BoxShape.circle)),
                  if (hasPay && (hasRec || hasRepayment || hasLc)) const SizedBox(width: 2),
                  if (hasRepayment) Container(width: 5, height: 5, decoration: BoxDecoration(color: c.neuOrange, shape: BoxShape.circle)),
                  if (hasRepayment && (hasRec || hasLc)) const SizedBox(width: 2),
                  if (hasLc) Container(width: 5, height: 5, decoration: BoxDecoration(color: c.neuTeal, shape: BoxShape.circle)),
                  if (hasLc && hasRec) const SizedBox(width: 2),
                  if (hasRec) Container(width: 5, height: 5, decoration: BoxDecoration(color: c.neuGreen, shape: BoxShape.circle)),
                ]),
              ],
            ]),
          ),
        );
      },
    );
  }

  Widget _buildLegend() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _dot(c.neuRed, '待付'),
      const SizedBox(width: 12),
      _dot(c.neuOrange, '还款'),
      const SizedBox(width: 12),
      _dot(c.neuTeal, '生活'),
      const SizedBox(width: 12),
      _dot(c.neuGreen, '待收'),
    ]);
  }

  Widget _dot(Color dotColor, String l) => Row(children: [
    Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
    const SizedBox(width: 6),
    Text(l, style: TextStyle(fontSize: 13, color: c.neuSecondaryLabel, fontWeight: FontWeight.w500)),
  ]);

  Widget _buildDateHeader() {
    const wd = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return Text(
      '${DateFormat('M月d日').format(_selectedDate)} · ${wd[_selectedDate.weekday - 1]}',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: c.neuLabel),
    );
  }

  // ==================== 时间线 ====================

  Widget _buildTimeline(TransactionProvider provider) {
    final txs = provider.getTransactionsByDate(_selectedDate);
    final repProvider = context.watch<RepaymentProvider>();
    final lcProvider = context.watch<LivingCostProvider>();
    final repEntries = repProvider.getEntriesByDate(_selectedDate);
    final lcEntries = lcProvider.getEntriesByDate(_selectedDate);
    final hasAny = txs.isNotEmpty || repEntries.isNotEmpty || lcEntries.isNotEmpty;

    if (!hasAny) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 36),
        decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(20), boxShadow: sh.raised),
        child: Center(child: Column(children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: c.neuBg, shape: BoxShape.circle, boxShadow: sh.raisedSm),
            child: Icon(Icons.event_busy_outlined, size: 26, color: c.neuSecondaryLabel),
          ),
          const SizedBox(height: 12),
          Text('当日无记录', style: TextStyle(fontSize: 15, color: c.neuSecondaryLabel, fontWeight: FontWeight.w500)),
        ])),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(20), boxShadow: sh.raised),
      child: Column(
        children: [
          // 还款条目
          ...repEntries.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildRepaymentRow(item.plan.name, item.entry.amount, item.entry.isCompleted, item.plan.id, item.entry.year, item.entry.month, repProvider),
          )),
          // 生活成本条目
          ...lcEntries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildLcRow(entry),
          )),
          // 交易条目
          ...txs.asMap().entries.map((e) => Padding(
            padding: EdgeInsets.only(bottom: e.key < txs.length - 1 ? 12 : 0),
            child: _buildRow(e.value),
          )),
        ],
      ),
    );
  }

  Widget _buildRepaymentRow(String planName, double amount, bool isCompleted, String planId, int year, int month, RepaymentProvider provider) {
    return GestureDetector(
      onTap: () {
        if (!isCompleted) {
          showDialog(
            context: context,
            builder: (dCtx) => AlertDialog(
              backgroundColor: c.neuBg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('标记已还'),
              content: Text('确认「$planName」本月 ¥${amount.toStringAsFixed(2)} 已还？'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('取消')),
                TextButton(
                  onPressed: () { provider.markAsCompleted(planId, year, month); Navigator.pop(dCtx); },
                  child: Text('确认', style: TextStyle(color: c.neuGreen)),
                ),
              ],
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: c.neuBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: sh.raisedSm,
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(12), boxShadow: sh.raisedSm),
            child: Icon(Icons.receipt_long_outlined, size: 18, color: c.neuOrange),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(planName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted ? c.neuSecondaryLabel : c.neuLabel,
            ), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(isCompleted ? '已还' : '待还', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
              color: isCompleted ? c.neuGreen : c.neuOrange)),
          ])),
          Text('¥${amount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
              color: isCompleted ? c.neuSecondaryLabel : c.neuOrange)),
        ]),
      ),
    );
  }

  Widget _buildLcRow(dynamic entry) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: sh.raisedSm,
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(12), boxShadow: sh.raisedSm),
          child: Icon(Icons.shopping_bag_outlined, size: 18, color: c.neuTeal),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(entry.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.neuLabel), maxLines: 1, overflow: TextOverflow.ellipsis),
            if (entry.isRecurring) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: c.neuTint.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                child: Text('固定', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: c.neuTint)),
              ),
            ],
          ]),
          const SizedBox(height: 2),
          Text('生活成本 · ${entry.category}', style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel)),
        ])),
        Text('¥${entry.amount.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: c.neuTeal)),
      ]),
    );
  }

  Widget _buildRow(Transaction t) {
    final r = t.type == TransactionType.receivable;
    final done = t.status == TransactionStatus.completed;
    final ac = r ? c.neuGreen : c.neuRed;
    String st; Color sc;
    if (done) { st = '已完成'; sc = c.neuSecondaryLabel; }
    else if (t.isOverdue) { st = '已逾期'; sc = c.neuRed; }
    else { st = r ? '待收' : '待付'; sc = c.neuOrange; }

    return GestureDetector(
      onTap: () => _showDetail(t),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: c.neuBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: sh.raisedSm,
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(12), boxShadow: sh.raisedSm),
            child: Icon(r ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, size: 18, color: ac),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
              decoration: done ? TextDecoration.lineThrough : null,
              color: done ? c.neuSecondaryLabel : c.neuLabel,
            ), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(st, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: sc)),
          ])),
          Text('${r ? '+' : '-'}¥${t.amount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: done ? c.neuSecondaryLabel : ac),
            maxLines: 1, overflow: TextOverflow.ellipsis),
        ]),
      ),
    );
  }

  // ==================== 详情弹窗 ====================

  void _showDetail(Transaction t) {
    final r = t.type == TransactionType.receivable;
    final done = t.status == TransactionStatus.completed;
    final ac = r ? c.neuGreen : c.neuRed;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        decoration: BoxDecoration(
          color: c.neuBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: sh.raised,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // 拖拽条
          Container(width: 40, height: 5, decoration: BoxDecoration(
            color: c.neuSecondaryLabel.withOpacity(0.3),
            borderRadius: BorderRadius.circular(3),
          )),
          const SizedBox(height: 20),
          Text(t.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: c.neuLabel)),
          const SizedBox(height: 8),
          Text('${r ? '+' : '-'}¥${t.amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: ac)),
          const SizedBox(height: 24),
          _detailRow('类型', r ? '应收款' : '应付款'),
          _detailRow('分类', t.category),
          _detailRow('到期日', DateFormat('yyyy-MM-dd').format(t.dueDate)),
          _detailRow('周期', t.cycleDescription),
          if (t.note != null && t.note!.isNotEmpty) _detailRow('备注', t.note!),
          const SizedBox(height: 24),
          if (!done)
            GestureDetector(
              onTap: () {
                context.read<TransactionProvider>().markAsCompleted(t.id);
                Navigator.pop(ctx);
                setState(() {});
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: ac,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: ac.withOpacity(0.4), offset: const Offset(0, 4), blurRadius: 12)],
                ),
                child: Center(child: Text(r ? '标记为已入账' : '标记为已支付',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white))),
              ),
            )
          else
            GestureDetector(
              onTap: () {
                context.read<TransactionProvider>().markAsPending(t.id);
                Navigator.pop(ctx);
                setState(() {});
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: c.neuBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: sh.inset,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.check_circle, size: 20, color: c.neuGreen),
                  const SizedBox(width: 6),
                  Text('已完成 · 点击撤销', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: c.neuSecondaryLabel)),
                ]),
              ),
            ),
          const SizedBox(height: 16),
          // 编辑/删除 按钮行
          Row(children: [
            Expanded(child: GestureDetector(
              onTap: () {
                Navigator.pop(ctx);
                context.push('/add-record/${t.id}');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: c.neuBg,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: sh.raisedSm,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.edit_outlined, size: 18, color: c.neuTint),
                  const SizedBox(width: 6),
                  Text('编辑', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c.neuTint)),
                ]),
              ),
            )),
            const SizedBox(width: 12),
            Expanded(child: GestureDetector(
              onTap: () => _confirmDelete(ctx, t),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: c.neuBg,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: sh.raisedSm,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.delete_outline, size: 18, color: c.neuRed),
                  const SizedBox(width: 6),
                  Text('删除', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c.neuRed)),
                ]),
              ),
            )),
          ]),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.pop(ctx),
            child: Text('关闭', style: TextStyle(fontSize: 15, color: c.neuSecondaryLabel, fontWeight: FontWeight.w500)),
          ),
        ]),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: 14, color: c.neuSecondaryLabel)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c.neuLabel)),
      ]),
    );
  }

  void _confirmDelete(BuildContext sheetCtx, Transaction t) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: c.neuBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('删除记录', style: TextStyle(fontWeight: FontWeight.w700, color: c.neuLabel)),
        content: Text('确定删除「${t.name}」？此操作不可撤销。', style: TextStyle(color: c.neuSecondaryLabel)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: Text('取消', style: TextStyle(color: c.neuSecondaryLabel))),
          TextButton(
            onPressed: () {
              context.read<TransactionProvider>().deleteTransaction(t.id);
              Navigator.pop(dialogCtx);
              Navigator.pop(sheetCtx);
              setState(() {});
            },
            child: Text('删除', style: TextStyle(color: c.neuRed, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
