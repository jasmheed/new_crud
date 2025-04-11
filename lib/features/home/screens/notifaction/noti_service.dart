import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  final bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  //intialize

  Future<void> initNotification() async {
    if (_isInitialized) return; // prevent re-initialization
    //prepare android init settings
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //init settings

    const initSettings = InitializationSettings(android: initSettingsAndroid);

    //initialize plugiin

    await notificationsPlugin.initialize(initSettings);
  }

//notification detail setup

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
      'daily_channel_id',
      'Daily Notifications',
      channelDescription: 'Daily Notification channel',
      importance: Importance.max,
      priority: Priority.high,
    ));
  }

  //show notification

  Future<void> showNotification(
      {int id = 0, String? title, String? body}) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(),
    );
  }
}
