import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../../models/transaction.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/project_provider.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';
import '../../widgets/neu_date_picker.dart';

/// 记一笔 / 编辑记录 - Neumorphism 风格
class AddScreen extends StatefulWidget {
  final String? transactionId;
  const AddScreen({super.key, this.transactionId});
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late ColorScheme c;
  late NeuShadows sh;

  TransactionType _type = TransactionType.payable;
  String _category = AppConstants.payableCategories.first;
  String _amountInput = ''; // 原始输入缓冲（如 "10.5"）
  DateTime _dueDate = DateTime.now();
  CycleType _cycle = CycleType.monthly;
  String? _projectId;
  String? _note;
  bool _reminderEnabled = false;
  Transaction? _editingTransaction; // 编辑模式时的原始记录

  bool get isEditing => widget.transactionId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      // 延迟到 build 完成后加载数据，因为需要访问 Provider
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadTransaction());
    }
  }

  void _loadTransaction() {
    final provider = context.read<TransactionProvider>();
    final tx = provider.transactions.where((t) => t.id == widget.transactionId);
    if (tx.isNotEmpty) {
      final t = tx.first;
      setState(() {
        _editingTransaction = t;
        _type = t.type;
        _category = t.category;
        _amountInput = t.amount.toStringAsFixed(2);
        _dueDate = t.dueDate;
        _cycle = t.cycle;
        _projectId = t.projectId;
        _note = t.note;
      });
    }
  }

  List<String> get _categories => _type == TransactionType.receivable
      ? AppConstants.receivableCategories
      : AppConstants.payableCategories;

  @override
  Widget build(BuildContext context) {
    c = Theme.of(context).colorScheme;
    sh = NeuShadows.of(context);
    return Scaffold(
      backgroundColor: c.neuBg,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: c.neuBg,
              shape: BoxShape.circle,
              boxShadow: sh.raisedSm,
            ),
            child: Icon(Icons.close, size: 20, color: c.neuLabel),
          ),
        ),
        title: Text(isEditing ? '编辑记录' : '记一笔'),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [
            _buildTypeToggle(),
            const SizedBox(height: 28),
            _buildAmountDisplay(),
            const SizedBox(height: 28),
            _buildCategorySection(),
            const SizedBox(height: 20),
            _buildFormSection(),
            const SizedBox(height: 20),
          ],
        )),
        _buildNumberKeyboard(),
      ]),
    );
  }

  // ==================== 类型切换（Neumorphism 凹陷/凸起） ====================

  Widget _buildTypeToggle() {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: sh.inset, // 凹陷容器
      ),
      child: Row(children: [
        Expanded(child: _typeButton(0, '应付')),
        Expanded(child: _typeButton(1, '应收')),
      ]),
    );
  }

  Widget _typeButton(int value, String label) {
    final isSelected = (_type == TransactionType.payable ? 0 : 1) == value;
    return GestureDetector(
      onTap: () => setState(() {
        _type = value == 0 ? TransactionType.payable : TransactionType.receivable;
        _category = _categories.first;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: c.neuBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected ? sh.raisedSm : null,
        ),
        child: Center(child: Text(label, style: TextStyle(
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? c.neuTint : c.neuSecondaryLabel,
        ))),
      ),
    );
  }

  // ==================== 金额显示 ====================

  Widget _buildAmountDisplay() {
    final display = _amountInput.isEmpty ? '0.00' : _amountInput;

    return Center(child: Column(children: [
      Text('¥ $display',
        style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300, color: c.neuLabel, letterSpacing: -1)),
      const SizedBox(height: 8),
      _BlinkingCursor(),
    ]));
  }

  // ==================== 分类选择 ====================

  Widget _buildCategorySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: sh.raised,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('分类', style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Wrap(spacing: 10, runSpacing: 10, children: [
          ..._categories.map((cat) {
            final sel = _category == cat;
            return GestureDetector(
              onTap: () => setState(() => _category = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: c.neuBg,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: sel ? sh.inset : sh.raisedSm,
                ),
                child: Text(cat, style: TextStyle(
                  fontSize: 14, fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                  color: sel ? c.neuTint : c.neuSecondaryLabel,
                )),
              ),
            );
          }),
        ]),
      ]),
    );
  }

  // ==================== 表单区域 ====================

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: sh.raised,
      ),
      child: Column(children: [
        _formRow(icon: Icons.calendar_today_outlined, label: '日期',
          trailing: Text(DateFormat('yyyy-MM-dd').format(_dueDate), style: TextStyle(fontSize: 15, color: c.neuSecondaryLabel)),
          onTap: () async {
            final d = await showNeuDatePicker(context, initialDate: _dueDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
            if (d != null) setState(() => _dueDate = d);
          }),
        _formDivider(),
        _formRow(icon: Icons.notifications_outlined, label: '提醒',
          trailing: Switch(value: _reminderEnabled, onChanged: (v) => setState(() => _reminderEnabled = v))),
        _formDivider(),
        _formRow(icon: Icons.folder_outlined, label: '关联项目',
          trailing: _projectTrailing(), onTap: _showProjectPicker),
        _formDivider(),
        _formRow(icon: Icons.notes_outlined, label: '备注',
          trailing: SizedBox(width: 160, child: TextField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(hintText: '添加备注', hintStyle: TextStyle(color: c.neuTertiaryLabel), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 2)),
            style: const TextStyle(fontSize: 15), onChanged: (v) => _note = v.isNotEmpty ? v : null,
          ))),
      ]),
    );
  }

  Widget _formRow({required IconData icon, required String label, required Widget trailing, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(10), boxShadow: sh.raisedSm),
            child: Icon(icon, size: 18, color: c.neuTint),
          ),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: c.neuLabel)),
          const SizedBox(width: 12),
          Expanded(child: Align(alignment: Alignment.centerRight, child: trailing)),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 20, color: c.neuSecondaryLabel),
          ],
        ]),
      ),
    );
  }

  Widget _formDivider() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(height: 1, color: c.neuSeparator),
  );

  Widget _projectTrailing() {
    return Consumer<ProjectProvider>(builder: (ctx, prov, _) {
      final projects = prov.activeProjects;
      String name = '未选择';
      if (_projectId != null && projects.isNotEmpty) {
        final m = projects.where((p) => p.id == _projectId);
        name = m.isNotEmpty ? m.first.name : projects.first.name;
      }
      return Text(name, style: TextStyle(fontSize: 15, color: c.neuSecondaryLabel), maxLines: 1, overflow: TextOverflow.ellipsis);
    });
  }

  void _showProjectPicker() {
    final projects = context.read<ProjectProvider>().activeProjects;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        decoration: BoxDecoration(
          color: c.neuBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: sh.raised,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 5, decoration: BoxDecoration(color: c.neuSecondaryLabel.withOpacity(0.3), borderRadius: BorderRadius.circular(3))),
          const SizedBox(height: 16),
          Text('关联项目', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: c.neuLabel)),
          const SizedBox(height: 16),
          ListTile(leading: const Icon(Icons.not_interested), title: const Text('不关联项目'), onTap: () { setState(() => _projectId = null); Navigator.pop(ctx); }),
          ...projects.map((p) => ListTile(leading: const Icon(Icons.folder_outlined), title: Text(p.name), onTap: () { setState(() => _projectId = p.id); Navigator.pop(ctx); })),
        ]),
      ),
    );
  }

  // ==================== Neumorphism 数字键盘 ====================

  Widget _buildNumberKeyboard() {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 16, 12, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: c.brightness == Brightness.dark ? Colors.black.withOpacity(0.4) : SheDeColors.shadowDark.withOpacity(0.3), offset: const Offset(0, -4), blurRadius: 12),
          BoxShadow(color: c.brightness == Brightness.dark ? const Color(0xFF404048).withOpacity(0.3) : SheDeColors.shadowLight.withOpacity(0.5), offset: const Offset(0, -2), blurRadius: 6),
        ],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 3, child: Column(mainAxisSize: MainAxisSize.min, children: [
          _keyRow(['7', '8', '9']), const SizedBox(height: 10),
          _keyRow(['4', '5', '6']), const SizedBox(height: 10),
          _keyRow(['1', '2', '3']), const SizedBox(height: 10),
          _keyRow(['.', '0', '⌫']),
        ])),
        const SizedBox(width: 10),
        // 保存按钮
        Expanded(child: GestureDetector(
          onTap: _save,
          child: Container(
            height: 56 * 4 + 10 * 3,
            decoration: BoxDecoration(
              color: c.neuTint,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: c.neuTint.withOpacity(0.4), offset: const Offset(4, 4), blurRadius: 12),
                BoxShadow(color: c.neuTint.withOpacity(0.2), offset: const Offset(-2, -2), blurRadius: 6),
              ],
            ),
            child: const Center(child: Text('保存', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white))),
          ),
        )),
      ]),
    );
  }

  Widget _keyRow(List<String> keys) => Row(children: keys.map(_buildKey).toList());

  Widget _buildKey(String key) {
    final del = key == '⌫';
    return Expanded(
      child: GestureDetector(
        onTap: () => _onKey(key),
        child: Container(
          height: 56,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: c.neuBg,
            borderRadius: BorderRadius.circular(14),
            boxShadow: sh.raisedSm,
          ),
          child: Center(
            child: del
                ? Icon(Icons.backspace_outlined, size: 20, color: c.neuLabel)
                : Text(key, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: c.neuLabel)),
          ),
        ),
      ),
    );
  }

  void _onKey(String key) {
    setState(() {
      if (key == '⌫') {
        if (_amountInput.isNotEmpty) {
          _amountInput = _amountInput.substring(0, _amountInput.length - 1);
        }
      } else if (key == '.') {
        if (!_amountInput.contains('.')) {
          _amountInput = _amountInput.isEmpty ? '0.' : '$_amountInput.';
        }
      } else {
        if (_amountInput.contains('.')) {
          final dotIdx = _amountInput.indexOf('.');
          if (_amountInput.length - dotIdx > 2) return;
        }
        if (_amountInput.length >= 10) return;
        _amountInput += key;
      }
    });
  }

  void _save() {
    final amount = double.tryParse(_amountInput);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('请输入有效金额'),
        backgroundColor: c.neuRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }

    if (isEditing && _editingTransaction != null) {
      // 编辑模式：更新现有记录
      final updated = _editingTransaction!.copyWith(
        type: _type,
        category: _category,
        amount: amount,
        dueDate: _dueDate,
        cycle: _cycle,
        customCycleDays: _cycle == CycleType.custom ? 30 : null,
        projectId: _projectId,
        note: _note,
      );
      context.read<TransactionProvider>().updateTransaction(updated);
    } else {
      // 新建模式
      context.read<TransactionProvider>().addTransaction(
        type: _type, category: _category, name: _category, amount: amount,
        dueDate: _dueDate, cycle: _cycle, projectId: _projectId, note: _note,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isEditing ? '✓ 记录已更新' : '✓ 记录已保存'),
      backgroundColor: c.neuGreen,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 1),
    ));
    Future.delayed(const Duration(milliseconds: 800), () { if (mounted) Navigator.pop(context); });
  }
}

/// 闪烁光标动画
class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 24,
        height: 3,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.neuTint,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
