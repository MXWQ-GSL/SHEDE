import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/project_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/project.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';

/// 项目列表 - Neumorphism 风格
class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme; final sh = NeuShadows.of(context);
    return Scaffold(
      backgroundColor: c.neuBg,
      appBar: AppBar(
        title: const Text('项目管理'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, size: 26),
            onPressed: () => _showAddDialog(context, c, sh),
          ),
        ],
      ),
      body: Consumer2<ProjectProvider, TransactionProvider>(
        builder: (ctx, pp, tx, _) {
          final active = pp.activeProjects;
          final archived = pp.archivedProjects;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              Text(
                '进行中 (${active.length})',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.neuSecondaryLabel),
              ),
              const SizedBox(height: 10),
              if (active.isEmpty)
                _emptyState(Icons.folder_open_outlined, '暂无项目', '点击右上角 + 创建', () => _showAddDialog(context, c, sh), c, sh)
              else
                ...active.map((p) => _projectCard(ctx, p, tx, pp, c, sh)),
              if (archived.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  '已归档 (${archived.length})',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.neuSecondaryLabel),
                ),
                const SizedBox(height: 10),
                ...archived.map((p) => _projectCard(ctx, p, tx, pp, c, sh, isArchived: true)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _projectCard(
    BuildContext ctx,
    Project p,
    TransactionProvider tx,
    ProjectProvider pp,
    ColorScheme c,
    NeuShadows sh, {
    bool isArchived = false,
  }) {
    final invested = tx.getProjectTotalInvested(p.id);
    final budget = p.budget ?? 0;
    final progress = budget > 0 ? (invested / budget).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => ctx.push('/projects/${p.id}'),
        child: Container(
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
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: c.neuBg,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: sh.raisedSm,
                    ),
                    child: Icon(
                      Icons.folder_outlined,
                      size: 20,
                      color: isArchived ? c.neuSecondaryLabel : c.neuTint,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isArchived ? c.neuSecondaryLabel : c.neuLabel,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (p.description != null && p.description!.isNotEmpty)
                          Text(
                            p.description!,
                            style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, size: 20, color: c.neuSecondaryLabel),
                    color: c.neuBg,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onSelected: (v) {
                      if (v == 'archive') pp.archiveProject(p.id);
                      if (v == 'unarchive') pp.unarchiveProject(p.id);
                      if (v == 'delete') _confirmDelete(ctx, p, pp, c, sh);
                    },
                    itemBuilder: (_) => [
                      if (isArchived)
                        const PopupMenuItem(value: 'unarchive', child: Text('取消归档'))
                      else
                        const PopupMenuItem(value: 'archive', child: Text('归档项目')),
                      PopupMenuItem(value: 'delete', child: Text('删除', style: TextStyle(color: c.neuRed))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _stat('已投入', '¥${_fmt(invested)}', c),
                  if (budget > 0) _stat('预算', '¥${_fmt(budget)}', c),
                ],
              ),
              if (budget > 0) ...[
                const SizedBox(height: 10),
                _buildProgressBar(progress, c),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: progress > 0.9 ? c.neuRed : c.neuSecondaryLabel,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress, ColorScheme c) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: c.brightness == Brightness.dark ? Colors.black.withOpacity(0.4) : SheDeColors.shadowDark.withOpacity(0.3), offset: const Offset(1, 1), blurRadius: 3),
          BoxShadow(color: c.brightness == Brightness.dark ? const Color(0xFF404048).withOpacity(0.3) : SheDeColors.shadowLight.withOpacity(0.5), offset: const Offset(-1, -1), blurRadius: 3),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation(
            progress > 0.9 ? c.neuRed : c.neuTint,
          ),
          minHeight: 6,
        ),
      ),
    );
  }

  Widget _stat(String label, String value, ColorScheme c) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: c.neuSecondaryLabel)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c.neuLabel)),
        ],
      ),
    );
  }

  Widget _emptyState(IconData icon, String title, String subtitle, VoidCallback onTap, ColorScheme c, NeuShadows sh) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: sh.raised,
      ),
      child: Center(
        child: Column(
          children: [
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
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.neuLabel)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 13, color: c.neuSecondaryLabel)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: c.neuTint,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: c.neuTint.withOpacity(0.3), offset: const Offset(0, 3), blurRadius: 8)],
                ),
                child: const Text('创建项目', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, Project p, ProjectProvider pp, ColorScheme c, NeuShadows sh) {
    showDialog(
      context: ctx,
      builder: (dCtx) => AlertDialog(
        backgroundColor: c.neuBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('删除项目'),
        content: Text('确定删除「${p.name}」？关联记录不会被删除。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('取消')),
          TextButton(
            onPressed: () {
              pp.deleteProject(p.id);
              Navigator.pop(dCtx);
            },
            child: Text('删除', style: TextStyle(color: c.neuRed)),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, ColorScheme c, NeuShadows sh) {
    final nameCtrl = TextEditingController();
    final budgetCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.neuBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('新建项目'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: '项目名称')),
            const SizedBox(height: 12),
            TextField(controller: budgetCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: '预算（可选）', prefixText: '¥ ')),
            const SizedBox(height: 12),
            TextField(controller: descCtrl, decoration: const InputDecoration(hintText: '描述（可选）')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                context.read<ProjectProvider>().addProject(
                  name: nameCtrl.text,
                  budget: double.tryParse(budgetCtrl.text),
                  startDate: DateTime.now(),
                  description: descCtrl.text.isNotEmpty ? descCtrl.text : null,
                );
                Navigator.pop(ctx);
              }
            },
            child: Text('创建', style: TextStyle(color: c.neuTint)),
          ),
        ],
      ),
    );
  }

  String _fmt(double v) => v.abs() >= 10000 ? '${(v / 10000).toStringAsFixed(2)}万' : v.toStringAsFixed(0);
}
