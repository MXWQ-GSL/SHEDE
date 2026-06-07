import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/project_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/project.dart';
import '../../models/transaction.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';

/// 项目统计 - Neumorphism 风格 + 深色模式适配
class StatisticsScreen extends StatelessWidget {
  final String type;
  const StatisticsScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final sh = NeuShadows.of(context);

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('舍得', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: c.neuLabel, letterSpacing: 1.5)),
                  const SizedBox(height: 4),
                  Text('项目统计', style: TextStyle(fontSize: 13, color: c.neuSecondaryLabel)),
                ]),
                Row(children: [
                  _circleBtn(Icons.folder_outlined, () => context.push('/projects'), c, sh),
                  const SizedBox(width: 10),
                  _circleBtn(Icons.settings_outlined, () => context.push('/settings'), c, sh),
                ]),
              ]),
              const SizedBox(height: 24),
              _buildTotalBudgetCard(context, c, sh),
              const SizedBox(height: 28),
              Text('活跃项目', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: c.neuLabel)),
              const SizedBox(height: 12),
              _buildProjectList(context, c, sh),
              const SizedBox(height: 28),
              Text('资金流向', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: c.neuLabel)),
              const SizedBox(height: 12),
              _buildFundFlow(context, c, sh),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalBudgetCard(BuildContext context, ColorScheme c, NeuShadows sh) {
    return Consumer2<ProjectProvider, TransactionProvider>(builder: (ctx, pp, tx, _) {
      final projects = pp.activeProjects;
      final total = projects.fold<double>(0, (s, p) => s + (p.budget ?? 0));
      final spent = projects.fold<double>(0, (s, p) => s + tx.getProjectTotalInvested(p.id));
      final rem = total - spent;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF2D3748),
          borderRadius: BorderRadius.circular(24),
          boxShadow: sh.darkCard,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('总投资预算', style: TextStyle(fontSize: 14, color: Color(0xFF8E99A4), fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text('¥${_fmt(total)}', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.5), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _darkStat('已支出', spent)),
            Container(width: 1, height: 36, color: Colors.white.withOpacity(0.1)),
            Expanded(child: _darkStat('剩余', rem)),
          ]),
        ]),
      );
    });
  }

  Widget _darkStat(String label, double v) => Column(children: [
    Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF8E99A4))),
    const SizedBox(height: 6),
    Text('¥${_fmt(v)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
  ]);

  Widget _buildProjectList(BuildContext context, ColorScheme c, NeuShadows sh) {
    return Consumer2<ProjectProvider, TransactionProvider>(builder: (ctx, pp, tx, _) {
      final projects = pp.activeProjects;
      if (projects.isEmpty) return _emptyState(Icons.folder_open_outlined, '暂无项目', c, sh);

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(20), boxShadow: sh.raised),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projects.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (ctx, i) => _projectRow(projects[i], tx, ctx, c, sh),
        ),
      );
    });
  }

  Widget _projectRow(Project p, TransactionProvider tx, BuildContext ctx, ColorScheme c, NeuShadows sh) {
    final spent = tx.getProjectTotalInvested(p.id);
    final budget = p.budget ?? 0;
    final progress = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;

    return GestureDetector(
      onTap: () => ctx.push('/projects/${p.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(16), boxShadow: sh.raisedSm),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(p.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.neuLabel), maxLines: 1, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            Text('${(progress * 100).toInt()}%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: progress > 0.9 ? c.neuRed : c.neuSecondaryLabel)),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 20, color: c.neuSecondaryLabel),
          ]),
          const SizedBox(height: 12),
          _progressBar(progress, c, sh),
          const SizedBox(height: 8),
          Text('¥${_fmt(spent)} / ¥${_fmt(budget)}', style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel)),
        ]),
      ),
    );
  }

  Widget _buildFundFlow(BuildContext context, ColorScheme c, NeuShadows sh) {
    return Consumer<TransactionProvider>(builder: (ctx, tx, _) {
      final now = DateTime.now();
      final stats = tx.getCategoryStats(type: TransactionType.payable, year: now.year, month: now.month);
      if (stats.isEmpty) return _emptyState(Icons.pie_chart_outline, '暂无数据', c, sh);

      final total = stats.values.fold<double>(0, (s, v) => s + v);
      final sorted = stats.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      final top = sorted.take(5).toList();
      final flowColors = [c.neuTint, c.neuGreen, c.neuOrange, SheDeColors.systemTeal, c.neuIndigo];

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(20), boxShadow: sh.raised),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: top.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (_, i) {
            final e = top[i];
            final pct = (e.value / total * 100).toInt();
            return GestureDetector(
              onTap: () => ctx.push('/expense-manage', extra: {'category': e.key}),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(e.key, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.neuLabel), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Text('$pct%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c.neuSecondaryLabel)),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 18, color: c.neuSecondaryLabel),
                ]),
                const SizedBox(height: 10),
                _progressBar(e.value / total, c, sh, color: flowColors[i % flowColors.length]),
              ]),
            );
          },
        ),
      );
    });
  }

  Widget _progressBar(double value, ColorScheme c, NeuShadows sh, {Color? color}) {
    return Container(
      height: 8,
      decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(8), boxShadow: [
        BoxShadow(color: c.brightness == Brightness.dark ? Colors.black.withOpacity(0.4) : SheDeColors.shadowDark.withOpacity(0.3), offset: const Offset(2, 2), blurRadius: 3),
        BoxShadow(color: c.brightness == Brightness.dark ? const Color(0xFF404048).withOpacity(0.3) : SheDeColors.shadowLight.withOpacity(0.5), offset: const Offset(-2, -2), blurRadius: 3),
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(value: value, backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation(color ?? c.neuTint), minHeight: 8),
      ),
    );
  }

  Widget _emptyState(IconData icon, String text, ColorScheme c, NeuShadows sh) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(20), boxShadow: sh.raised),
      child: Center(child: Column(children: [
        Container(width: 56, height: 56, decoration: BoxDecoration(color: c.neuBg, shape: BoxShape.circle, boxShadow: sh.raisedSm),
          child: Icon(icon, size: 26, color: c.neuSecondaryLabel)),
        const SizedBox(height: 12),
        Text(text, style: TextStyle(fontSize: 15, color: c.neuSecondaryLabel, fontWeight: FontWeight.w500)),
      ])),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap, ColorScheme c, NeuShadows sh) {
    return GestureDetector(
      onTap: onTap,
      child: Container(width: 46, height: 46,
        decoration: BoxDecoration(color: c.neuBg, shape: BoxShape.circle, boxShadow: sh.raisedSm),
        child: Icon(icon, size: 22, color: c.neuSecondaryLabel)),
    );
  }

  String _fmt(double v) => v.abs() >= 10000 ? '${(v / 10000).toStringAsFixed(2)}万' : v.toStringAsFixed(2);
}
