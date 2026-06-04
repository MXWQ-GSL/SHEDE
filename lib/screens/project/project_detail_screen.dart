import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/project_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/project.dart';
import '../../models/transaction.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';

/// 项目详情 - Neumorphism 风格
class ProjectDetailScreen extends StatelessWidget {
  final String projectId;
  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme; final sh = NeuShadows.of(context);
    return Consumer2<ProjectProvider, TransactionProvider>(
      builder: (ctx, pp, tx, _) {
        final project = pp.getProjectById(projectId);
        if (project == null) {
          return Scaffold(
            backgroundColor: c.neuBg,
            appBar: AppBar(title: const Text('项目详情')),
            body: const Center(child: Text('项目不存在')),
          );
        }

        final transactions = tx.transactions
            .where((t) => t.projectId == projectId)
            .toList()
          ..sort((a, b) => b.dueDate.compareTo(a.dueDate));
        final invested = tx.getProjectTotalInvested(projectId);
        final budget = project.budget ?? 0;
        final progress = budget > 0 ? (invested / budget).clamp(0.0, 1.0) : 0.0;

        return Scaffold(
          backgroundColor: c.neuBg,
          appBar: AppBar(
            title: Text(project.name),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, size: 22, color: c.neuSecondaryLabel),
                color: c.neuBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onSelected: (v) {
                  if (v == 'archive') pp.archiveProject(projectId);
                  if (v == 'unarchive') pp.unarchiveProject(projectId);
                  if (v == 'delete') _confirmDelete(context, pp, c, sh);
                },
                itemBuilder: (_) => [
                  if (project.status == ProjectStatus.active)
                    const PopupMenuItem(value: 'archive', child: Text('归档'))
                  else
                    const PopupMenuItem(value: 'unarchive', child: Text('取消归档')),
                  PopupMenuItem(value: 'delete', child: Text('删除', style: TextStyle(color: c.neuRed))),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              // 项目概览
              _buildOverviewCard(project, context, c, sh),
              const SizedBox(height: 16),

              // 投入统计
              _buildStatsCard(project, invested, budget, progress, context, c, sh),
              const SizedBox(height: 20),

              // 投入记录标题
              Text(
                '投入记录 (${transactions.length})',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.neuSecondaryLabel),
              ),
              const SizedBox(height: 10),

              // 投入记录列表
              if (transactions.isEmpty)
                _buildEmptyCard(c, sh)
              else
                _buildTransactionList(transactions, c, sh),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewCard(Project project, BuildContext context, ColorScheme c, NeuShadows sh) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: sh.raised,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: c.neuBg,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: sh.raisedSm,
                ),
                child: Icon(Icons.folder_outlined, size: 22, color: c.neuTint),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: c.neuLabel),
                    ),
                    if (project.description != null && project.description!.isNotEmpty)
                      Text(
                        project.description!,
                        style: TextStyle(fontSize: 13, color: c.neuSecondaryLabel),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _infoItem('开始日期', DateFormat('yyyy-MM-dd').format(project.startDate), c),
              _infoItem('状态', project.status == ProjectStatus.active ? '进行中' : '已归档', c),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(Project project, double invested, double budget, double progress, BuildContext context, ColorScheme c, NeuShadows sh) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: sh.raised,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('投入统计', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.neuLabel)),
          const SizedBox(height: 14),
          Row(
            children: [
              _infoItem('总投入', '¥${invested.toStringAsFixed(0)}', c),
              if (budget > 0) _infoItem('预算', '¥${budget.toStringAsFixed(0)}', c),
              if (budget > 0) _infoItem('剩余', '¥${(budget - invested).toStringAsFixed(0)}', c),
            ],
          ),
          if (budget > 0) ...[
            const SizedBox(height: 14),
            _buildProgressBar(progress, c),
            const SizedBox(height: 6),
            Text(
              '已完成 ${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: progress > 0.9 ? c.neuRed : c.neuSecondaryLabel,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress, ColorScheme c) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: c.brightness == Brightness.dark ? Colors.black.withOpacity(0.4) : SheDeColors.shadowDark.withOpacity(0.3), offset: const Offset(2, 2), blurRadius: 3),
          BoxShadow(color: c.brightness == Brightness.dark ? const Color(0xFF404048).withOpacity(0.3) : SheDeColors.shadowLight.withOpacity(0.5), offset: const Offset(-2, -2), blurRadius: 3),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation(
            progress > 0.9 ? c.neuRed : c.neuTint,
          ),
          minHeight: 8,
        ),
      ),
    );
  }

  Widget _buildEmptyCard(ColorScheme c, NeuShadows sh) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: sh.raised,
      ),
      child: Center(
        child: Text('暂无投入记录', style: TextStyle(fontSize: 14, color: c.neuSecondaryLabel)),
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions, ColorScheme c, NeuShadows sh) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: sh.raised,
      ),
      child: Column(
        children: transactions.asMap().entries.map((entry) {
          final t = entry.value;
          final isLast = entry.key == transactions.length - 1;
          final r = t.type == TransactionType.receivable;
          final amountColor = r ? c.neuGreen : c.neuRed;

          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: c.neuBg,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: sh.raisedSm,
                  ),
                  child: Icon(
                    r ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                    size: 16,
                    color: amountColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.neuLabel)),
                      Text(DateFormat('yyyy-MM-dd').format(t.dueDate), style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('¥${t.amount.toStringAsFixed(0)}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: amountColor)),
                    if (t.status == TransactionStatus.completed)
                      Text('已完成', style: TextStyle(fontSize: 11, color: c.neuGreen)),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _infoItem(String label, String value, ColorScheme c) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: c.neuSecondaryLabel)),
          const SizedBox(height: 3),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c.neuLabel)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ProjectProvider pp, ColorScheme c, NeuShadows sh) {
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        backgroundColor: c.neuBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('删除'),
        content: const Text('确定删除此项目？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('取消')),
          TextButton(
            onPressed: () {
              pp.deleteProject(projectId);
              Navigator.pop(dCtx);
              Navigator.pop(context);
            },
            child: Text('删除', style: TextStyle(color: c.neuRed)),
          ),
        ],
      ),
    );
  }
}
