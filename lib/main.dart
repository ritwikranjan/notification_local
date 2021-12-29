import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

void main() {
  AwesomeNotifications().initialize('resource://drawable/res_app_icon', [
    NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white),
  ], channelGroups: [
    NotificationChannelGroup(
      channelGroupkey: 'basic_channel_group',
      channelGroupName: 'Basic notifications',
    ),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AwesomeNotifications().actionStream.listen((ReceivedNotification receivedNotification) {
      Navigator.of(context).pushNamed('/NotificationPage', arguments: {
        'id': receivedNotification.id,
      });
    });
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void _incrementCounter() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecond,
        notificationLayout: NotificationLayout.BigPicture,
        channelKey: 'basic_channel',
        title: 'Merry Christmas',
        body: 'Wish you a merry Christmas',
        icon: 'resource://drawable/res_app_icon',
        bigPicture: 'asset://assets/images/christmas.webp',
      ),
    );
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
