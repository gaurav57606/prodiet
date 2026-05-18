import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:logger/logger.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final _logger = Logger();

  Future<void> initialize() async {
    // Initialized in main.dart

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
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    // Create Android channels
    final androidPlugin = FlutterLocalNotificationsPlugin();
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
      id: mealName.hashCode,
      title: 'Upcoming Meal: $mealName',
      body: 'It\'s almost time for your scheduled meal. Get ready!',
      scheduledDate: tz.TZDateTime.from(reminderTime, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'meal_reminders',
          'Meal Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'meal|$mealName',
    );
  }

  Future<void> scheduleWaterReminder(int intervalHours) async {
    // Cancel any existing water reminder first
    await _notifications.cancel(id: 999);

    final scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(hours: intervalHours));

    await _notifications.zonedSchedule(
      id: 999,
      title: 'Time to hydrate! 💧',
      body: 'Drink a glass of water to stay on track with your goal.',
      scheduledDate: scheduledTime,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'prodiet_reminders',
          'ProDiet Reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'water|reminder',
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    Importance importance = Importance.high,
  }) async {
    await _notifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'prodiet_reminders',
          'ProDiet Reminders',
          importance: importance,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  Future<void> scheduleLowStockAlert(String ingredientName) async {
    await showNotification(
      id: ingredientName.hashCode,
      title: 'Low stock: $ingredientName',
      body: 'You are running low on $ingredientName. Consider adding it to your shopping list.',
      importance: Importance.high,
    );
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  Future<void> cancelMealReminders() async {
    // TODO: Implement selective cancel using stored meal notification IDs.
    // Do NOT call _notifications.cancelAll() — it also cancels water reminders (ID: 999).
    _logger.d('[NotificationService] cancelMealReminders called — selective cancel not yet implemented');
  }
}
