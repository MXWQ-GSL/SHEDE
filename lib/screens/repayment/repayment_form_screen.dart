import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/repayment_provider.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';
import '../../widgets/neu_date_picker.dart';

/// 创建/编辑还款计划 - Neumorphism 风格
class RepaymentFormScreen extends StatefulWidget {
  final String? planId;
  const RepaymentFormScreen({super.key, this.planId});

  @override
  State<RepaymentFormScreen> createState() => _RepaymentFormScreenState();
}

class _RepaymentFormScreenState extends State<RepaymentFormScreen> {
  final _nameController = TextEditingController();
  int _totalMonths = 12;
  int _dueDay = 15;
  bool _isFixedAmount = true;
  double _fixedAmount = 0;
  DateTime _startDate = DateTime.now();
  // 浮动金额：monthIndex -> amount
  final Map<int, double> _variableAmounts = {};
  late ColorScheme c;
  late NeuShadows sh;

  bool get isEditing => widget.planId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadPlan());
    }
  }

  void _loadPlan() {
    final provider = context.read<RepaymentProvider>();
    final plans = provider.plans.where((p) => p.id == widget.planId);
    if (plans.isNotEmpty) {
      final plan = plans.first;
      setState(() {
        _nameController.text = plan.name;
        _totalMonths = plan.totalMonths;
        _dueDay = plan.defaultDueDay;
        _isFixedAmount = plan.isFixedAmount;
        _fixedAmount = plan.fixedAmount;
        _startDate = plan.startDate;
        for (int i = 0; i < plan.entries.length; i++) {
          _variableAmounts[i] = plan.entries[i].amount;
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    c = Theme.of(context).colorScheme; sh = NeuShadows.of(context);
    return Scaffold(
      backgroundColor: c.neuBg,
      appBar: AppBar(
        title: Text(isEditing ? '编辑还款计划' : '新建还款计划'),
        leading: IconButton(icon: const Icon(Icons.close, size: 22), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(children: [
        Expanded(child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [
            // 计划名称
            _buildSection('计划名称', child: _neuTextField(_nameController, '如：XX银行房贷')),
            const SizedBox(height: 20),

            // 开始日期
            _buildSection('开始还款日期', child: _buildDatePicker()),
            const SizedBox(height: 20),

            // 还款月数
            _buildSection('还款月数', child: _buildMonthSelector()),
            const SizedBox(height: 20),

            // 每月还款日
            _buildSection('每月还款日', child: _buildDaySelector()),
            const SizedBox(height: 20),

            // 金额模式
            _buildSection('金额模式', child: _buildAmountModeToggle()),
            const SizedBox(height: 16),

            // 金额输入
            if (_isFixedAmount)
              _buildSection('每月还款金额', child: _buildFixedAmountInput())
            else
              _buildSection('各月还款金额', child: _buildVariableAmountInputs()),
          ],
        )),

        // 保存按钮
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.of(context).padding.bottom),
          child: GestureDetector(
            onTap: _save,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: c.neuTint,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: c.neuTint.withOpacity(0.4), offset: const Offset(0, 4), blurRadius: 12)],
              ),
              child: Center(child: Text(isEditing ? '保存修改' : '创建计划',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))),
            ),
          ),
        ),
      ]),
    );
  }

  // ==================== 组件 ====================

  Widget _buildSection(String title, {required Widget child}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.neuSecondaryLabel)),
      const SizedBox(height: 8),
      child,
    ]);
  }

  Widget _neuTextField(TextEditingController controller, String hint, {TextInputType? keyboard, ValueChanged<String>? onChanged}) {
    return Container(
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: sh.inset,
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: c.neuTertiaryLabel),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: TextStyle(fontSize: 15, color: c.neuLabel),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final d = await showNeuDatePicker(context, initialDate: _startDate, firstDate: DateTime(2020), lastDate: DateTime(2035));
        if (d != null) setState(() => _startDate = d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: c.neuBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: sh.raisedSm,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(DateFormat('yyyy年M月d日').format(_startDate), style: TextStyle(fontSize: 15, color: c.neuLabel)),
          Icon(Icons.calendar_today_outlined, size: 18, color: c.neuSecondaryLabel),
        ]),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: sh.inset,
      ),
      child: Row(children: [
        _monthBtn('-', () { if (_totalMonths > 1) setState(() => _totalMonths--); }),
        Expanded(child: Center(child: Text('$_totalMonths 个月',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.neuLabel)))),
        _monthBtn('+', () { if (_totalMonths < 360) setState(() => _totalMonths++); }),
      ]),
    );
  }

  Widget _monthBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(12), boxShadow: sh.raisedSm),
        child: Center(child: Text(label, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: c.neuLabel))),
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: sh.inset,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _dueDay,
          isExpanded: true,
          dropdownColor: c.neuBg,
          style: TextStyle(fontSize: 15, color: c.neuLabel),
          items: List.generate(28, (i) => DropdownMenuItem(value: i + 1, child: Text('每月 ${i + 1} 日'))),
          onChanged: (v) { if (v != null) setState(() => _dueDay = v); },
        ),
      ),
    );
  }

  Widget _buildAmountModeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: sh.inset,
      ),
      child: Row(children: [
        Expanded(child: _modeBtn('固定金额', _isFixedAmount, () => setState(() => _isFixedAmount = true))),
        Expanded(child: _modeBtn('浮动金额', !_isFixedAmount, () => setState(() => _isFixedAmount = false))),
      ]),
    );
  }

  Widget _modeBtn(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: c.neuBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected ? sh.raisedSm : null,
        ),
        child: Center(child: Text(label, style: TextStyle(
          fontSize: 14, fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? c.neuTint : c.neuSecondaryLabel,
        ))),
      ),
    );
  }

  Widget _buildFixedAmountInput() {
    return Container(
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: sh.inset,
      ),
      child: TextField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          hintText: '输入每月还款金额',
          hintStyle: TextStyle(color: c.neuTertiaryLabel),
          prefixText: '¥ ',
          prefixStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.neuLabel),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.neuLabel),
        onChanged: (v) => _fixedAmount = double.tryParse(v) ?? 0,
      ),
    );
  }

  Widget _buildVariableAmountInputs() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.neuBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: sh.raised,
      ),
      child: Column(children: List.generate(_totalMonths, (i) {
        final date = DateTime(_startDate.year, _startDate.month + i, 1);
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(children: [
            SizedBox(width: 80, child: Text(
              DateFormat('yyyy年M月').format(date),
              style: TextStyle(fontSize: 13, color: c.neuSecondaryLabel),
            )),
            const SizedBox(width: 12),
            Expanded(child: Container(
              decoration: BoxDecoration(
                color: c.neuBg,
                borderRadius: BorderRadius.circular(12),
                boxShadow: sh.inset,
              ),
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: '金额',
                  hintStyle: TextStyle(color: c.neuTertiaryLabel, fontSize: 14),
                  prefixText: '¥ ',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  isDense: true,
                ),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c.neuLabel),
                onChanged: (v) => _variableAmounts[i] = double.tryParse(v) ?? 0,
              ),
            )),
          ]),
        );
      })),
    );
  }

  // ==================== 保存 ====================

  void _save() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入计划名称')));
      return;
    }
    if (_isFixedAmount && _fixedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入还款金额')));
      return;
    }

    final provider = context.read<RepaymentProvider>();

    if (isEditing) {
      // 编辑模式：删除旧的重新创建（简单实现）
      provider.deletePlan(widget.planId!);
    }

    provider.addPlan(
      name: _nameController.text.trim(),
      totalMonths: _totalMonths,
      defaultDueDay: _dueDay,
      isFixedAmount: _isFixedAmount,
      fixedAmount: _fixedAmount,
      startDate: _startDate,
      variableAmounts: _isFixedAmount ? null : _variableAmounts.entries.toList(),
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isEditing ? '✓ 已更新' : '✓ 还款计划已创建'),
      backgroundColor: c.neuGreen,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
    Navigator.pop(context);
  }
}
