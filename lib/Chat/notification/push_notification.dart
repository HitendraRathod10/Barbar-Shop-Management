import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class PushNotification extends ChangeNotifier{
  late String token;

  getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    print('Token => $token');
  }

  getNotification(context) {
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings(
        requestSoundPermission: false,
      requestBadgePermission: false, requestAlertPermission: false);
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid,iOS: initializationSettingsIOS,);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // DarwinNotificationDetails? ios = message.notification?.apple as DarwinNotificationDetails?;

      // FlutterLocalNotificationsPlugin localNotifPlugin = FlutterLocalNotificationsPlugin();
      // var androidChannelSpecifics = const AndroidNotificationDetails('default', 'Test App Notifications',);
      // var iOSChannelSpecifics = const DarwinNotificationDetails();
      // var platformChannelSpecifics = NotificationDetails(
      //     android: androidChannelSpecifics, iOS: iOSChannelSpecifics);
      // localNotifPlugin.show(0, notification?.title, notification?.body, platformChannelSpecifics)

      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                icon: "@mipmap/ic_launcher",
              ),
              iOS: const DarwinNotificationDetails(),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      // DarwinNotificationDetails? ios = message.notification?.apple as DarwinNotificationDetails?;
    });
    getToken();
  }


  chatMessageNotification(notificationToken,userName1,userName2,message,currentEmail,opponentUserEmail) async{
    // debugPrint("Method called $notificationToken");
    // debugPrint("Method called.... $userName1");
    // debugPrint("Method called....... $opponentUserEmail");
    final msg = jsonEncode({
      "registration_ids": <String>[
        "$notificationToken",
      ],
      "notification": {
        "title": "$userName1",
        "body": "$message",
        "android_channel_id": "babershopmanagement",
        "sound": true,
      },
      "data":{
        "opponentUserEmail":"$opponentUserEmail",
        "chatUserEmail":"$currentEmail",
      }
    });

    try {
      var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Authorization': 'key=AAAA2L_n9b8:APA91bG5wLS93tJN1WII5DPgu7TxOUDftuzH_vWz-uG4AAgZYgvsE1Mfzt35sG-GlYM1l9118aBlj4rN4En083xCbuwTuJHVvEcDCoab1MI4zvo4VbDEla5WjJDWlZR3USJ0L1iTK5Qa',
          'Content-Type': 'application/json'
        },
        body: msg,
      );

      if(response.statusCode==200){
        debugPrint("Notification Send");
      }
      else{
        debugPrint("Notification Send Error");
      }
    }catch(e){
      debugPrint("Debug print Catch $e");
    }
  }
}
