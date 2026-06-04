class AppConstants {
  // 应用名称
  static const String appName = '舍得';
  
  // 预算警告阈值
  static const double budgetWarningThreshold = 0.8; // 80%
  static const double budgetDangerThreshold = 1.0; // 100%
  
  // 应收款分类
  static const List<String> receivableCategories = [
    '工资',
    '投资收益',
    '借款归还',
    '奖金',
    '其他收入',
  ];
  
  // 应付款分类
  static const List<String> payableCategories = [
    '房贷',
    '车贷',
    '信用卡',
    '网贷',
    '水电煤',
    '保险',
    '教育',
    '其他支出',
  ];
  
  // 周期类型
  static const List<String> cycleTypes = [
    '一次性',
    '每月',
    '每周',
    '每年',
    '自定义',
  ];
  
  // 分类图标映射
  static const Map<String, String> categoryIcons = {
    '工资': 'briefcase',
    '投资收益': 'trending-up',
    '借款归还': 'undo-2',
    '奖金': 'gift',
    '其他收入': 'plus-circle',
    '房贷': 'home',
    '车贷': 'car',
    '信用卡': 'credit-card',
    '网贷': 'landmark',
    '水电煤': 'zap',
    '保险': 'shield',
    '教育': 'book-open',
    '其他支出': 'minus-circle',
  };
  
  // 存储 Key
  static const String settingsBox = 'settings';
  static const String transactionsBox = 'transactions';
  static const String projectsBox = 'projects';
  static const String repaymentBox = 'repayments';
  static const String livingCostBox = 'living_costs';
  
  // 设置 Key
  static const String themeKey = 'theme_mode';
  static const String budgetKey = 'monthly_budget';
  static const String budgetResetDayKey = 'budget_reset_day';
  static const String reminderEnabledKey = 'reminder_enabled';
  static const String reminderTimeKey = 'reminder_time';
  static const String reminderAdvanceDaysKey = 'reminder_advance_days';
  static const String overBudgetAlertKey = 'over_budget_alert';
}
