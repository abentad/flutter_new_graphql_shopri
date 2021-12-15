import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController {
  String? _token;
  String? get token => _token;
  final List<NotificationChannel> _notificationChannels = [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic Channel',
      defaultColor: Colors.teal,
      importance: NotificationImportance.High,
      // channelShowBadge: true,
      playSound: true,
      defaultPrivacy: NotificationPrivacy.Private,
      defaultRingtoneType: DefaultRingtoneType.Notification,
      enableVibration: true,
      enableLights: true,
    ),
  ];
  List<NotificationChannel> get notificationChannels => _notificationChannels;

  NotificationController() {
    _getToken();
    _setupNotificationListener();
  }

  _getToken() async {
    _token = await FirebaseMessaging.instance.getToken();
    print("Token " + _token.toString());
  }

  _setupNotificationListener() {
    print('listener is on');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        createBasicNotificaton(title: notification.title!.capitalize.toString(), body: notification.body.toString());
      }
      print(notification.hashCode);
      print(notification!.title);
      print(notification.body.toString());
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  //for sending notification by using device token
  Future<bool> sendNotificationUsingDeviceToken(String deviceToken, String messageTitle, String messageBody) async {
    String _serverKey = "AAAA7GChulM:APA91bF8YKCfXwWHbvuxg5vLcXqfSJ2qgRKIZngx7vxzwxHiI-a0L2onsXGbxU5LSg_S2RjYOgGn6VpMu0I1BCipG_Ln4Ceqe5iRQraPWlXv8nVeO0LsgdzE6SgMKyD2plMYfUsa9ERw";

    final response = await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"), headers: {
      "Content-Type": "application/json",
      "Authorization": "key=$_serverKey"
    }, body: {
      "to": deviceToken,
      "notification": {"title": messageTitle, "body": messageBody, "mutable_content": true},
      // "data": {"url": "<url of media image>", "dl": "<deeplink action on tap of notification>"}
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }

    // Dio _dio = Dio(BaseOptions(
    //   baseUrl: "https://fcm.googleapis.com",
    //   connectTimeout: 20000,
    //   receiveTimeout: 100000,
    //   headers: {"Content-Type": "application/json", "Authorization": "key=$_serverKey"},
    //   responseType: ResponseType.json,
    // ));
    // // try {
    // final response = await _dio.post(
    //   '/fcm/send',
    //   data: {
    //     "to": deviceToken,
    //     "notification": {"title": messageTitle, "body": messageBody, "mutable_content": true},
    //     // "data": {"url": "<url of media image>", "dl": "<deeplink action on tap of notification>"}
    //   },
    // );
    // if (response.statusCode == 200) {
    //   return true;
    // } else {
    //   return false;
    // }
    // } catch (e) {
    //   print(e);
    //   return false;
    // }
  }

  //
  //
  //
  Future<void> createBasicNotificaton({required String title, required String body, String channelKey = 'basic_channel'}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: channelKey,
        title: title.capitalize,
        body: body,
        createdDate: DateTime.now().toString(),
        notificationLayout: NotificationLayout.Inbox,
      ),
    );
  }

  int createUniqueId() {
    return DateTime.now().millisecond;
  }
}
