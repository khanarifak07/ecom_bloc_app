import 'dart:developer';
import 'dart:io';

import 'package:ecom_app_bloc/src/models/quotes_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  //
  final bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  //Initialize
  Future<void> initNotifications() async {
    if (_isInitialized) return;

    //initialize timezone
    tz.initializeTimeZones();
    final currentTimeZome = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZome));

    //android init settings
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    //ios init settings
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    //combine both settings
    const initializationSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );
    //initialize
    await notificationsPlugin.initialize(initializationSettings);
    //
    _requestPermission();
  }

  //
  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      // Android 13+ permission
      final androidImplementation = notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidImplementation?.requestNotificationsPermission();
      //
      await androidImplementation?.createNotificationChannel(
        AndroidNotificationChannel(
          'channelId',
          'Scheduled Notifications',
          description: 'This channel is used for scheduled quote notifications',
          importance: Importance.max,
          enableVibration: true,
          playSound: true,
        ),
      );
    } else if (Platform.isIOS) {
      // iOS permission
      final iosImplementation = notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      await iosImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  //notification details setup
  NotificationDetails notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        priority: Priority.high,
        importance: Importance.max,

        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  //show notificaton
  Future<void> showNotification(QuotesModel model) async {
    log('Show Notification');
    notificationsPlugin.show(
      model.id!,
      model.author,
      model.quote,
      notificationDetails(),
    );
  }

  //scheduled notification
  Future<void> shceduledNotification({
    required QuotesModel model,
    required int hour,
    required int minute,
  }) async {
    log('Scheduled Notification');
    //get device local timezone
    final now = tz.TZDateTime.now(tz.local);
    //create a date/time for today at specified hour/min
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    await notificationsPlugin.zonedSchedule(
      model.id!,
      model.author,
      model.quote,
      scheduledDate,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  //FOR TESTING
  // void shceduledNotification(QuotesModel model) {
  //   for (int i = 1; i <= 5; i++) {
  //     notificationsPlugin.zonedSchedule(
  //       model.id! + i,
  //       model.author,
  //       model.quote,
  //       tz.TZDateTime.now(tz.local).add(Duration(seconds: i * 10)),
  //       NotificationDetails(
  //         android: AndroidNotificationDetails('quotes_channel', 'Quotes'),
  //       ),
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     );
  //   }
  // }
}
