import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme/shede_colors.dart';
import '../config/theme/shede_theme.dart';
import '../config/theme/neu_context.dart';

/// Neumorphism 风格自定义日期选择器
/// 替代原生 showDatePicker，完全匹配 App 视觉风格
Future<DateTime?> showNeuDatePicker(
  BuildContext context, {
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (ctx) => _NeuDatePickerDialog(
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2035),
    ),
  );
}

class _NeuDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const _NeuDatePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<_NeuDatePickerDialog> createState() => _NeuDatePickerDialogState();
}

class _NeuDatePickerDialogState extends State<_NeuDatePickerDialog> {
  late DateTime _selectedDate;
  late DateTime _focusedMonth;
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;
  bool _showYearPicker = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _focusedMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
    _selectedDay = widget.initialDate.day;
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final sh = NeuShadows.of(context);
    return Dialog(
      backgroundColor: c.neuBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: c.neuBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: sh.raised,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 年月选择头
            _buildHeader(c, sh),
            const SizedBox(height: 16),

            if (_showYearPicker) ...[
              _buildYearPicker(c, sh),
            ] else ...[
              // 星期头部
              _buildWeekdayHeader(c),
              const SizedBox(height: 8),
              // 日期网格
              _buildDayGrid(c, sh),
            ],

            const SizedBox(height: 20),

            // 底部按钮
            _buildActions(c, sh),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme c, NeuShadows sh) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 上个月
        _headerBtn(Icons.chevron_left, () {
          setState(() {
            _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
          });
        }, c, sh),
        // 年月标题（点击切换年份选择器）
        GestureDetector(
          onTap: () => setState(() => _showYearPicker = !_showYearPicker),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: c.neuBg,
              borderRadius: BorderRadius.circular(12),
              boxShadow: sh.raisedSm,
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(
                DateFormat('yyyy年 M月').format(_focusedMonth),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: c.neuLabel),
              ),
              const SizedBox(width: 4),
              Icon(
                _showYearPicker ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 20,
                color: c.neuSecondaryLabel,
              ),
            ]),
          ),
        ),
        // 下个月
        _headerBtn(Icons.chevron_right, () {
          setState(() {
            _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
          });
        }, c, sh),
      ],
    );
  }

  Widget _headerBtn(IconData icon, VoidCallback onTap, ColorScheme c, NeuShadows sh) {
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

  Widget _buildWeekdayHeader(ColorScheme c) {
    const days = ['日', '一', '二', '三', '四', '五', '六'];
    return Row(
      children: days.map((d) => Expanded(
        child: Center(child: Text(d, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c.neuSecondaryLabel))),
      )).toList(),
    );
  }

  Widget _buildDayGrid(ColorScheme c, NeuShadows sh) {
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final startOffset = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        final dayOffset = index - startOffset;
        if (dayOffset < 0 || dayOffset >= daysInMonth) return const SizedBox();

        final date = DateTime(_focusedMonth.year, _focusedMonth.month, dayOffset + 1);
        final isSelected = date.year == _selectedYear && date.month == _selectedMonth && date.day == _selectedDay;
        final isToday = date.year == DateTime.now().year && date.month == DateTime.now().month && date.day == DateTime.now().day;
        final isBeforeStart = date.isBefore(widget.firstDate);
        final isAfterEnd = date.isAfter(widget.lastDate);
        final isDisabled = isBeforeStart || isAfterEnd;

        return GestureDetector(
          onTap: isDisabled ? null : () {
            setState(() {
              _selectedDate = date;
              _selectedYear = date.year;
              _selectedMonth = date.month;
              _selectedDay = date.day;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: c.neuBg,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected ? sh.inset : (isToday ? sh.raisedSm : null),
            ),
            child: Center(
              child: Text(
                '${dayOffset + 1}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isDisabled
                      ? c.neuTertiaryLabel
                      : isSelected
                          ? c.neuTint
                          : isToday
                              ? c.neuTint
                              : c.neuLabel,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildYearPicker(ColorScheme c, NeuShadows sh) {
    final years = List.generate(
      widget.lastDate.year - widget.firstDate.year + 1,
      (i) => widget.firstDate.year + i,
    );

    return SizedBox(
      height: 200,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.8,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: years.length,
        itemBuilder: (ctx, i) {
          final year = years[i];
          final isSelected = year == _focusedMonth.year;
          return GestureDetector(
            onTap: () {
              setState(() {
                _focusedMonth = DateTime(year, _focusedMonth.month);
                _showYearPicker = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: c.neuBg,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected ? sh.inset : sh.raisedSm,
              ),
              child: Center(
                child: Text(
                  '$year',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? c.neuTint : c.neuLabel,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions(ColorScheme c, NeuShadows sh) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: c.neuBg,
              borderRadius: BorderRadius.circular(12),
              boxShadow: sh.raisedSm,
            ),
            child: Text('取消', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c.neuSecondaryLabel)),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => Navigator.pop(context, _selectedDate),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: c.neuTint,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: c.neuTint.withOpacity(0.3), offset: const Offset(0, 3), blurRadius: 8)],
            ),
            child: const Text('确定', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
