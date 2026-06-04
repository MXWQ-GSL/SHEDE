import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../providers/transaction_provider.dart';
import '../../config/theme/shede_colors.dart';
import '../../config/theme/shede_theme.dart';
import '../../config/theme/neu_context.dart';

/// 数据导出 - Neumorphism 风格
class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme; final sh = NeuShadows.of(context);
    return Scaffold(
      backgroundColor: c.neuBg,
      appBar: AppBar(title: const Text('数据导出'), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          // 导出卡片
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(20), boxShadow: sh.raised),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 44, height: 44,
                  decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(14), boxShadow: sh.raisedSm),
                  child: Icon(Icons.description_outlined, size: 22, color: c.neuTint)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('导出为 CSV', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.neuLabel)),
                  const SizedBox(height: 2),
                  Text('导出所有交易记录', style: TextStyle(fontSize: 12, color: c.neuSecondaryLabel)),
                ])),
              ]),
              const SizedBox(height: 20),
              Text('导出内容包括：', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.neuLabel)),
              const SizedBox(height: 10),
              ...['交易类型（应收/应付）', '分类', '名称', '金额', '到期日', '周期', '状态', '备注'].map((item) =>
                Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [
                  Icon(Icons.check_circle_outline, size: 16, color: c.neuGreen),
                  const SizedBox(width: 8),
                  Text(item, style: TextStyle(fontSize: 14, color: c.neuLabel)),
                ]))),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _exportCsv(context, c),
                child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(color: c.neuTint, borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: c.neuTint.withOpacity(0.4), offset: const Offset(0, 4), blurRadius: 12)]),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.download_outlined, size: 20, color: Colors.white),
                    SizedBox(width: 8),
                    Text('导出 CSV', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                  ])),
              ),
            ]),
          ),
          const SizedBox(height: 20),

          // 提示
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: c.neuBg, borderRadius: BorderRadius.circular(14), boxShadow: sh.inset),
            child: Row(children: [
              Icon(Icons.info_outline, size: 18, color: c.neuTint),
              const SizedBox(width: 10),
              Expanded(child: Text('导出的 CSV 文件可用 Excel、Numbers 等表格软件打开。', style: TextStyle(fontSize: 13, color: c.neuSecondaryLabel))),
            ]),
          ),
        ],
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context, ColorScheme c) async {
    try {
      final provider = context.read<TransactionProvider>();
      final csvData = provider.exportToCsv();
      final directory = await getTemporaryDirectory();
      final now = DateTime.now();
      final fileName = '舍得_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}.csv';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(csvData);
      await Share.shareXFiles([XFile(file.path)], subject: '舍得 - 数据导出');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('✓ 导出成功'),
          backgroundColor: c.neuGreen, behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('导出失败: $e'),
          backgroundColor: c.neuRed, behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    }
  }
}
