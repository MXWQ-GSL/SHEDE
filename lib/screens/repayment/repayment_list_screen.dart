import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/repayment_provider.dart';
import '../../models/repayment.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';

/// 还款管理列表 - Neumorphism 风格
class RepaymentListScreen extends StatelessWidget {
  const RepaymentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme; final sh = NeuShadows.of(context);
    return Scaffold(
      backgroundColor: c.neuBg,
      appBar: AppBar(
        title: const Text('还款管理'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, size: 26),
            onPressed: () => context.push('/repayment/add'),
          ),
        ],
      ),
      body: Consumer<RepaymentProvider>(
        builder: (ctx, provider, _) {
          final plans = provider.plans;

          if (plans.isEmpty) {
            return Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(color: c.neuBg, shape: BoxShape.circle, boxShadow: sh.raised),
                  child: Icon(Icons.receipt_long_outlined, size: 34, color: c.neuSecondaryLabel),
                ),
                const SizedBox(height: 16),
                Text('暂无还款计划', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: c.neuLabel)),
                const SizedBox(height: 6),
                Text('点击右上角 + 创建第一个', style: TextStyle(fontSize: 14, color: c.neuSecondaryLabel)),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => context.push('/repayment/add'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: c.neuTint,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: c.neuTint.withOpacity(0.4), offset: const Offset(0, 4), blurRadius: 12)],
                    ),
                    child: const Text('创建还款计划', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ));
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            itemCount: plans.length,
            itemBuilder: (ctx, i) => _buildPlanCard(ctx, plans[i], provider, c, sh),
          );
        },
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, RepaymentPlan plan, RepaymentProvider provider, ColorScheme c, NeuShadows sh) {
    final pending = plan.pendingEntries;
    final completed = plan.entries.where((e) => e.isCompleted).length;
    final total = plan.entries.length;
    final progress = total > 0 ? completed / total : 0.0;
    final pendingAmount = pending.fold<double>(0, (s, e) => s + e.amount);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: () => context.push('/repayment/edit/${plan.id}'),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: c.neuBg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: sh.raised,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // 标题行
            Row(children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(14), boxShadow: sh.raisedSm),
                child: Icon(Icons.receipt_long_outlined, size: 22, color: c.neuTint),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: c.neuLabel)),
                  const SizedBox(height: 2),
                  Text(
                    plan.isFixedAmount
                        ? '每月固定 ¥${plan.fixedAmount.toStringAsFixed(2)}'
                        : '浮动金额 · ${plan.totalMonths}期',
                    style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel),
                  ),
                ],
              )),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, size: 20, color: c.neuSecondaryLabel),
                color: c.neuBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onSelected: (v) {
                  if (v == 'delete') {
                    showDialog(
                      context: context,
                      builder: (dCtx) => AlertDialog(
                        backgroundColor: c.neuBg,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: const Text('删除计划'),
                        content: Text('确定删除「${plan.name}」？'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('取消')),
                          TextButton(
                            onPressed: () { provider.deletePlan(plan.id); Navigator.pop(dCtx); },
                            child: Text('删除', style: TextStyle(color: c.neuRed)),
                          ),
                        ],
                      ),
                    );
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'delete', child: Text('删除计划', style: TextStyle(color: c.neuRed))),
                ],
              ),
            ]),
            const SizedBox(height: 16),

            // 进度条
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: c.neuSeparator,
                valueColor: AlwaysStoppedAnimation(c.neuTint),
              ),
            ),
            const SizedBox(height: 12),

            // 统计行
            Row(children: [
              _statItem('总期数', '$total期', c),
              _statItem('已完成', '$completed期', c),
              _statItem('待还', '¥${pendingAmount.toStringAsFixed(0)}', c),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, ColorScheme c) {
    return Expanded(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: c.neuSecondaryLabel)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c.neuLabel)),
      ],
    ));
  }
}
