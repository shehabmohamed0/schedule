import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show File, Platform;

import 'package:rxdart/rxdart.dart';

class NotificationPlugin {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  late InitializationSettings initializationSettings;

  NotificationPlugin._() {
    init();
  }

  void init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    if (Platform.isIOS) {
      _requestIosPermissions();
    }
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    var initializationSettingsForAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsForIos = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceivedNotification receivedNotification = ReceivedNotification(
              id: id, title: title, body: body, payload: payload);
          didReceivedLocalNotificationSubject.add(receivedNotification);
        });

    initializationSettings = InitializationSettings(
        android: initializationSettingsForAndroid,
        iOS: initializationSettingsForIos);
  }

  void _requestIosPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(alert: false, badge: true, sound: true);
  }

  setListenedForLowerVersions(Function onNotificationInLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification() async {
    var androidChanelSpecifics = AndroidNotificationDetails(
        'Schedule', 'ScheduleChanel',
        channelDescription: 'Shit no',
        importance: Importance.max,
        priority: Priority.high);
    var iosChanelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChanelSpecifics, iOS: iosChanelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'Test title', 'Test body', platformChannelSpecifics,
        payload: 'Test payload');
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}
