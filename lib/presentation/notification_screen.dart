import 'package:flutter/material.dart';
import 'package:schedule/data/models/recieved_notification.dart';

import 'notification_plugin.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    NotificationPlugin.instance
        .setListenedForLowerVersions(onNotificationInLowerVersions);
    NotificationPlugin.instance.setOnNotificationClick(onNotificationClick);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () async {
              await NotificationPlugin.instance.showNotification();
            },
            child: Text('Send notification+'),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     await NotificationPlugin.instance.zonedScheduleNotification(DateTime.now() );
          //   },
          //   child: Text('zoned scheduled notification+'),
          // ),
          ElevatedButton(
            onPressed: () async {
              await NotificationPlugin.instance.showInsistentNotification();
            },
            child: Text('show Insistent notification+'),
          ),
          ElevatedButton(
            onPressed: () async {
             await NotificationPlugin.instance.showBigPictureNotification(
                 );

            },
            child: Text('download and save file notification+'),
          ),
          ElevatedButton(
            onPressed: () async {
              await NotificationPlugin.instance.checkPendingNotificationRequests(context);
            },
            child: Text('show pending notification+'),
          ),
           ElevatedButton(
            onPressed: () async {
              await NotificationPlugin.instance.getNotificationChannels(context);
            },
            child: Text('show  notification with attachment'),
          ),
        ],
      ),
    );
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {}

  onNotificationClick(String payload) {}
}
