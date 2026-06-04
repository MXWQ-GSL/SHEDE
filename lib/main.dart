import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/transaction.dart';
import 'models/project.dart';
import 'models/repayment.dart';
import 'models/living_cost.dart';
import 'providers/transaction_provider.dart';
import 'providers/project_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/repayment_provider.dart';
import 'providers/living_cost_provider.dart';
import 'config/constants.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 设置状态栏样式
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // 初始化 Hive
  await Hive.initFlutter();

  // 注册 TypeAdapter（顺序不能变，先注册枚举再注册模型）
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionStatusAdapter());
  Hive.registerAdapter(CycleTypeAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(ProjectStatusAdapter());
  Hive.registerAdapter(ProjectAdapter());
  Hive.registerAdapter(RepaymentPlanAdapter());
  Hive.registerAdapter(RepaymentEntryAdapter());
  Hive.registerAdapter(LivingCostMonthAdapter());
  Hive.registerAdapter(LivingCostEntryAdapter());

  // 打开 Hive Box
  await Hive.openBox<Transaction>(AppConstants.transactionsBox);
  await Hive.openBox<Project>(AppConstants.projectsBox);
  await Hive.openBox(AppConstants.settingsBox);
  await Hive.openBox<RepaymentPlan>(AppConstants.repaymentBox);
  await Hive.openBox<LivingCostMonth>(AppConstants.livingCostBox);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => RepaymentProvider()),
        ChangeNotifierProvider(create: (_) => LivingCostProvider()),
      ],
      child: const ShedeApp(),
    ),
  );
}
