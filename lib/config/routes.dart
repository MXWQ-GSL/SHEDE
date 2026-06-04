import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home/home_screen.dart';
import '../screens/add/add_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/statistics/statistics_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/settings/theme_settings_screen.dart';
import '../screens/settings/budget_settings_screen.dart';
import '../screens/settings/reminder_settings_screen.dart';
import '../screens/project/project_list_screen.dart';
import '../screens/project/project_detail_screen.dart';
import '../screens/export/export_screen.dart';
import '../screens/repayment/repayment_list_screen.dart';
import '../screens/repayment/repayment_form_screen.dart';
import '../screens/living_cost/living_cost_screen.dart';
import '../screens/budget/budget_manage_screen.dart';
import '../screens/expense_manage/expense_manage_screen.dart';
import '../widgets/main_scaffold.dart';

/// iOS 风格页面转场：从右侧滑入 + 淡入
CustomTransitionPage<T> _iosTransition<T>(BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 进入：从右侧滑入 + 渐显
      final slideIn = Tween<Offset>(begin: const Offset(0.25, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      final fadeIn = CurvedAnimation(parent: animation, curve: Curves.easeOut);

      return SlideTransition(
        position: slideIn,
        child: FadeTransition(
          opacity: fadeIn,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 250),
  );
}

/// 舍得 App 路由配置
/// 底部导航：首页 / 日历 / 记账(Modal) / 统计
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // 底部导航 Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/calendar', builder: (context, state) => const CalendarScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/stats', builder: (context, state) => const StatisticsScreen(type: 'monthly')),
          ]),
        ],
      ),

      // 记一笔 / 编辑记录
      GoRoute(
        path: '/add-record',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AddScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeOutCubic));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
        ),
      ),
      GoRoute(
        path: '/add-record/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: AddScreen(transactionId: id),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final tween = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeOutCubic));
              return SlideTransition(position: animation.drive(tween), child: child);
            },
            transitionDuration: const Duration(milliseconds: 400),
            reverseTransitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),

      // 统计详情
      GoRoute(
        path: '/statistics/:type',
        pageBuilder: (context, state) {
          final type = state.pathParameters['type']!;
          return _iosTransition(context, state, StatisticsScreen(type: type));
        },
      ),

      // 设置
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => _iosTransition(context, state, const SettingsScreen()),
        routes: [
          GoRoute(path: 'theme', pageBuilder: (context, state) => _iosTransition(context, state, const ThemeSettingsScreen())),
          GoRoute(path: 'budget', pageBuilder: (context, state) => _iosTransition(context, state, const BudgetSettingsScreen())),
          GoRoute(path: 'reminder', pageBuilder: (context, state) => _iosTransition(context, state, const ReminderSettingsScreen())),
        ],
      ),

      // 项目管理
      GoRoute(
        path: '/projects',
        pageBuilder: (context, state) => _iosTransition(context, state, const ProjectListScreen()),
        routes: [
          GoRoute(
            path: ':id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return _iosTransition(context, state, ProjectDetailScreen(projectId: id));
            },
          ),
        ],
      ),

      // 数据导出
      GoRoute(
        path: '/export',
        pageBuilder: (context, state) => _iosTransition(context, state, const ExportScreen()),
      ),

      // 生活成本（保留独立路由）
      GoRoute(
        path: '/living-cost',
        pageBuilder: (context, state) => _iosTransition(context, state, const LivingCostScreen()),
      ),

      // 预算管理
      GoRoute(
        path: '/budget-manage',
        pageBuilder: (context, state) => _iosTransition(context, state, const BudgetManageScreen()),
      ),

      // 舍得管理（统一支出入口）
      GoRoute(
        path: '/expense-manage',
        pageBuilder: (context, state) => _iosTransition(context, state, const ExpenseManageScreen()),
      ),

      // 还款管理
      GoRoute(
        path: '/repayment',
        pageBuilder: (context, state) => _iosTransition(context, state, const RepaymentListScreen()),
        routes: [
          GoRoute(
            path: 'add',
            pageBuilder: (context, state) => _iosTransition(context, state, const RepaymentFormScreen()),
          ),
          GoRoute(
            path: 'edit/:id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return _iosTransition(context, state, RepaymentFormScreen(planId: id));
            },
          ),
        ],
      ),
    ],
  );
}
