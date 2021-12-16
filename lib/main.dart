import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shopri/src/controllers/chat_controller.dart';
import 'package:shopri/src/controllers/notification_controller.dart';
import 'src/controllers/api_controller.dart';
import 'src/controllers/category_controller.dart';
import 'src/controllers/my_camera_controller.dart';
import 'src/controllers/query_controller.dart';
import 'src/root.dart';

//
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //!fix sending two notifications when app is in background or terminated
  //!createBasicNotificaton(title: message.notification!.title.toString(), body: message.notification!.body.toString());
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Get.put<ApiController>(ApiController());
  Get.put<ChatController>(ChatController());
  Get.put<NotificationController>(NotificationController());
  Get.put<MyCameraController>(MyCameraController());
  Get.put<QueryController>(QueryController());
  Get.put<CategoryController>(CategoryController());
  if (!kIsWeb) {
    AwesomeNotifications().initialize(null, Get.find<NotificationController>().notificationChannels);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: false, sound: true);
  }
  //disable screenshot or screen recording
  //! turn it on for publish
  // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopri',
      home: Root(),
    );
  }
}
