import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:spoonshare/screens/home/home_page.dart';
import 'package:spoonshare/services/PushNotification.dart';
import 'package:spoonshare/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferences.getInstance();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);


  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      )
    ],
  );


  runApp(const MyApp());
}


Future<void> backgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
    PushNotificationService().getToken();


    // Configure onLaunch and onResume callbacks
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Handle notification click or tap here
    });


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('A new onMessage event was published! ${message.notification!.title}');
      _showNotification(
        message.notification!.title,
        message.notification!.body,
      );
    });
  }


  Future<void> requestNotificationPermissions() async {
    if (await AwesomeNotifications().isNotificationAllowed() == false) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }


  Future<void> _showNotification(String? title, String? body) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true),
      dark: ThemeData.dark(useMaterial3: true),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Spoon Share',
        theme: theme,
        darkTheme: darkTheme,
        home: const HomePage(name: '', role: ''),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

