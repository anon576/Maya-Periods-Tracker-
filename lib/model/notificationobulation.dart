import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final InitializationSettings initializationSettings =
      InitializationSettings(
    android: AndroidInitializationSettings('app_icon'),
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationPage(),
    );
  }
}

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Call scheduleNotification when appropriate, for example, in initState()
    scheduleNotification();

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Example'),
      ),
      body: Center(
        child: Text('Notification scheduled!'),
      ),
    );
  }
}

Future<void> scheduleNotification() async {
  // Get remaining days until ovulation (replace this with your logic)
  int remainingDays = 10;

  var androidDetails = AndroidNotificationDetails(
    'Ovulation Reminder',
    'Notification for ovulation reminder',
    importance: Importance.max,
  );

  var platformChannelSpecifics =
      NotificationDetails(android: androidDetails);

  // Schedule the notification if only 10 days remain for ovulation
  if (remainingDays == 10) {
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Ovulation Reminder',
      'Only 10 days left until ovulation!',
      DateTime.now().add(Duration(seconds: 5)), // Replace with desired date
      platformChannelSpecifics,
    );
  }
}
