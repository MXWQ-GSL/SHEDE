import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../models/transaction.dart';

/// 本地通知服务
/// 负责到期提醒的调度和推送
class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// 初始化通知服务
  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);

    // 请求通知权限（Android 13+）
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  /// 为单条账款安排到期提醒
  /// [advanceDays] 提前几天提醒（0=当天）
  /// [hour] 提醒小时
  /// [minute] 提醒分钟
  Future<void> scheduleReminder({
    required Transaction txn,
    required int advanceDays,
    required int hour,
    required int minute,
  }) async {
    final reminderDate = txn.dueDate.subtract(Duration(days: advanceDays));
    var scheduledDate = tz.TZDateTime(
      tz.local,
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      hour,
      minute,
    );

    // 如果提醒时间已过，跳过
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    final isReceivable = txn.type == TransactionType.receivable;
    final emoji = isReceivable ? '📥' : '📤';
    final typeLabel = isReceivable ? '应收款' : '应付款';

    await _plugin.zonedSchedule(
      txn.id.hashCode,
      '$emoji $typeLabel到期提醒',
      '${txn.name}：¥${txn.amount.toStringAsFixed(2)}',
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'shede_reminder',
          '账款到期提醒',
          channelDescription: '舍得App应收/应付款项到期提醒',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: txn.cycle == CycleType.monthly
          ? DateTimeComponents.dayOfMonthAndTime
          : txn.cycle == CycleType.weekly
              ? DateTimeComponents.dayOfWeekAndTime
              : txn.cycle == CycleType.yearly
                  ? DateTimeComponents.dateAndTime
                  : null,
    );
  }

  /// 取消单条账款的提醒
  Future<void> cancelReminder(String txnId) async {
    await _plugin.cancel(txnId.hashCode);
  }

  /// 取消所有提醒
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// 重新调度所有活跃账款的提醒
  Future<void> rescheduleAll({
    required List<Transaction> transactions,
    required bool enabled,
    required int advanceDays,
    required int hour,
    required int minute,
  }) async {
    await cancelAll();
    if (!enabled) return;

    final now = DateTime.now();
    for (final txn in transactions) {
      // 跳过已完成的
      if (txn.status == TransactionStatus.completed) continue;
      // 跳过过期太久的（超过30天）
      if (txn.dueDate.isBefore(now.subtract(const Duration(days: 30)))) continue;

      await scheduleReminder(
        txn: txn,
        advanceDays: advanceDays,
        hour: hour,
        minute: minute,
      );
    }
  }
}
