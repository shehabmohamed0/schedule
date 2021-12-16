import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show File, Platform;
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:schedule/data/models/recieved_notification.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationPlugin {
  static late NotificationPlugin instance;

  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late InitializationSettings initializationSettings;

  NotificationPlugin._() {
    _init();
  }

  static void initialize() {
    instance = NotificationPlugin._();
  }

  void _init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _configureLocalTimeZone();
    if (Platform.isIOS) {
      _requestIosPermissions();
    }
    _initializePlatformSpecifics();
  }

  _initializePlatformSpecifics() {
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
        priority: Priority.high,
        playSound: true);
    var iosChanelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChanelSpecifics, iOS: iosChanelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'Test title', 'Test body', platformChannelSpecifics,
        payload: 'AD');
  }

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  Future<void> zonedScheduleNotification({required int id,required String title ,String? body,required DateTime dateTime}) async {

   print( tz.TZDateTime.from(dateTime, tz.local).add(Duration(seconds: 5)).toIso8601String());
    var androidChanelSpecifics = AndroidNotificationDetails(
        'Schedule', 'ScheduleChanel',
        channelDescription: 'Shit no',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true);
    var iosChanelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChanelSpecifics, iOS: iosChanelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> showInsistentNotification() async {
    // This value is from: https://developer.android.com/reference/android/app/Notification.html#FLAG_INSISTENT
    const int insistentFlag = 4;
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            additionalFlags: Int32List.fromList(<int>[insistentFlag]));
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'insistent title', 'insistent body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> deleteNotificationChannel(BuildContext context) async {
    const String channelId = 'your channel id 2';
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(channelId);

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Channel with id $channelId deleted'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteNotificationChannelGroup(BuildContext context) async {
    const String channelGroupId = 'your channel group id';
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup(channelGroupId);

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Channel group with id $channelGroupId deleted'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> showBigPictureNotification() async {
    final String largeIconPath = await _downloadAndSaveFile(
        'https://via.placeholder.com/48x48', 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(
        'https://via.placeholder.com/400x800', 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
            largeIcon: FilePathAndroidBitmap(largeIconPath),
            contentTitle: 'overridden <b>big</b> content title',
            htmlFormatContentTitle: true,
            summaryText: 'summary <i>text</i>',
            htmlFormatSummaryText: true);

    final IOSNotificationDetails iosPlatformChannelSpecifics =
        IOSNotificationDetails(
            attachments: [IOSNotificationAttachment(bigPicturePath)]);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'big text channel id', 'big text channel name',
            channelDescription: 'big text channel description',
            styleInformation: bigPictureStyleInformation);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  Future<void> showNotificationWithAttachment() async {
    final String bigPicturePath = await _downloadAndSaveFile(
        'https://via.placeholder.com/600x200', 'bigPicture.jpg');
    final IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(attachments: <IOSNotificationAttachment>[
      IOSNotificationAttachment(bigPicturePath)
    ]);
    final MacOSNotificationDetails macOSPlatformChannelSpecifics =
        MacOSNotificationDetails(attachments: <MacOSNotificationAttachment>[
      MacOSNotificationAttachment(bigPicturePath)
    ]);
    final NotificationDetails notificationDetails = NotificationDetails(
        iOS: iOSPlatformChannelSpecifics, macOS: macOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'notification with attachment title',
        'notification with attachment body',
        notificationDetails);
  }

  Future<Widget> _getNotificationChannelsDialogContent() async {
    try {
      final List<AndroidNotificationChannel>? channels =
          await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()!
              .getNotificationChannels();

      return Container(
        width: double.maxFinite,
        child: ListView(
          children: <Widget>[
            const Text(
              'Notifications Channels',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.black),
            if (channels?.isEmpty ?? true)
              const Text('No notification channels')
            else
              for (AndroidNotificationChannel channel in channels!)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('id: ${channel.id}\n'
                        'name: ${channel.name}\n'
                        'description: ${channel.description}\n'
                        'groupId: ${channel.groupId}\n'
                        'importance: ${channel.importance.value}\n'
                        'playSound: ${channel.playSound}\n'
                        'sound: ${channel.sound?.sound}\n'
                        'enableVibration: ${channel.enableVibration}\n'
                        'vibrationPattern: ${channel.vibrationPattern}\n'
                        'showBadge: ${channel.showBadge}\n'
                        'enableLights: ${channel.enableLights}\n'
                        'ledColor: ${channel.ledColor}\n'),
                    const Divider(color: Colors.black),
                  ],
                ),
          ],
        ),
      );
    } on PlatformException catch (error) {
      return Text(
        'Error calling "getNotificationChannels"\n'
        'code: ${error.code}\n'
        'message: ${error.message}',
      );
    }
  }

  Future<void> getNotificationChannels(BuildContext context) async {
    final Widget notificationChannelsDialogContent =
        await _getNotificationChannelsDialogContent();
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: notificationChannelsDialogContent,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> startForegroundService() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channasdklasdel id', 'your channelaslkdmq name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.startForegroundService(1, 'plain title', 'plain body',
            notificationDetails: androidPlatformChannelSpecifics,
            payload: 'item x');
  }

  Future<void> stopForegroundService() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.stopForegroundService();
  }

  Future<void> checkPendingNotificationRequests(BuildContext context) async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}


