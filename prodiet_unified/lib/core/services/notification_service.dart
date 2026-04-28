import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    // Create Android channels
    const androidPlugin = FlutterLocalNotificationsPlugin();
    await androidPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          'prodiet_reminders',
          'ProDiet Reminders',
          description: 'General reminders for meals and water',
          importance: Importance.max,
        ));
        
    await androidPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          'meal_reminders',
          'Meal Reminders',
          description: 'Notifications for upcoming meals',
          importance: Importance.high,
        ));
  }

  Future<void> scheduleMealReminder(String mealName, DateTime scheduledTime) async {
    final reminderTime = scheduledTime.subtract(const Duration(minutes: 10));
    if (reminderTime.isBefore(DateTime.now())) return;

    await _notifications.zonedSchedule(
      mealName.hashCode,
      'Upcoming Meal: $mealName',
      'It\'s almost time for your scheduled meal. Get ready!',
      tz.TZDateTime.from(reminderTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'meal_reminders',
          'Meal Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'meal|$mealName',
    );
  }

  Future<void> scheduleWaterReminder(int intervalHours) async {
    // Basic implementation: Schedule for the next occurrence
    // In a real app, you might use a work manager or multiple scheduled notifications
    await _notifications.periodicallyShow(
      999, // Static ID for water
      'Time to hydrate!',
      'Drink a glass of water to stay on track with your goal.',
      RepeatInterval.everyTwoHours, // IntervalHours support is limited in periodicShow
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prodiet_reminders',
          'ProDiet Reminders',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleLowStockAlert(String ingredientName) async {
    await _notifications.show(
      ingredientName.hashCode,
      'Low stock: $ingredientName',
      'You are running low on $ingredientName. Consider adding it to your shopping list.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prodiet_reminders',
          'ProDiet Reminders',
          importance: Importance.high,
        ),
      ),
    );
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  Future<void> cancelMealReminders() async {
    // This requires tracking IDs or using a specific range
    // For now, simple implementation
    await _notifications.cancelAll();
  }
}
