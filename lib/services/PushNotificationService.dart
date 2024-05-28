import 'package:firebase_messaging/firebase_messaging.dart';


import '../main.dart';


class PushNotificationService {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;


  Future initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');


      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });


    FirebaseMessaging.onBackgroundMessage(backgroundHandler);


    // Get the token
    await getToken();
  }


  Future<String?> getToken() async {
    String? token = await _fcm.getToken();
    print('Token: $token');
    return token;
  }
}

