import 'package:flutter/material.dart';

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
    notificationPlugin
        .setListenedForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
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
              await notificationPlugin.showNotification();
            },
            child: Text('Send notification+'),
          )
        ],
      ),
    );
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {}

  onNotificationClick(String payload) {}
}
