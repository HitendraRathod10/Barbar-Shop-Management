import 'package:barber_booking_management/Addshop/provider/add_shop_provider.dart';
import 'package:barber_booking_management/Login/provider/loading_provider.dart';
import 'package:barber_booking_management/Login/provider/login_provider.dart';
import 'package:barber_booking_management/Login/screen/splash_screen.dart';
import 'package:barber_booking_management/utils/app_color.dart';
import 'package:barber_booking_management/widget/loading_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'Category/provider/appointment_provider.dart';
import 'Chat/notification/push_notification.dart';
import 'Profile/profile_screen.dart';

var uuid = Uuid();


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications',
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: "AIzaSyCMsG4P6AbzmKg_myvwV_oVefsW2pG0EL8",
  //         projectId: "babershopmanagement",
  //         messagingSenderId: "930932585919",
  //         appId: "1:930932585919:web:c58e5571fb816a548ddd0a"
  //     )
  // );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, badge: true, sound: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
          ChangeNotifierProvider<AddShopProvider>(create: (_) => AddShopProvider()),
          ChangeNotifierProvider<AppointmentProvider>(create: (_) => AppointmentProvider()),
          ChangeNotifierProvider<LoadingProvider>(create: (_) => LoadingProvider()),
        ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(AppColor.whiteColor))),
            appBarTheme: const AppBarTheme(
              color: AppColor.whiteColor,
              elevation: 0.0,
              centerTitle: true,
              titleTextStyle:  TextStyle(
                color: AppColor.appColor,
              ),
              iconTheme:  IconThemeData(
                color: AppColor.appColor,
              ),
            ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColor.appColor),
          ),
          home: const SplashScreen(),
        builder: (context, child) {
          return Loading(child: child!);
        },
      ),
    );
  }
}

