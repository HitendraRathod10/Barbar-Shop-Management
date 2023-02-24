// import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class FCM {
//
//   final streamCtlr = StreamController<String>.broadcast();
//   final titleCtlr = StreamController<String>.broadcast();
//   final bodyCtlr = StreamController<String>.broadcast();
//
//   setNotifications() {
//     FirebaseMessaging.onMessage.listen((message) async {
//       if (message.data.containsKey('data')) {
//         streamCtlr.sink.add(message.data['data']);
//       }
//       if (message.data.containsKey('notification')) {
//         streamCtlr.sink.add(message.data['notification']);
//       }
//       titleCtlr.sink.add(message.notification!.title!);
//       bodyCtlr.sink.add(message.notification!.body!);
//     },
//     );
//   }
//
//   dispose() {
//     streamCtlr.close();
//     bodyCtlr.close();
//     titleCtlr.close();
//   }
// }