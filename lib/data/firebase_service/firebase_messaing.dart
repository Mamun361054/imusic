import 'dart:convert';
import 'dart:async';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import '../../utils/notification_plugin.dart';
import '../Repository/repositor.dart';
import '../model/media_model.dart';

var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
  FirebaseMessage.myBackgroundMessageHandler(message.data);
}

class FirebaseMessage {
  Function navigateMedia;
  Repository repository = Repository();
  FirebaseMessage(this.navigateMedia);
  late InitializationSettings initializationSettings;
  final didReceivedLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

  //updated myBackgroundMessageHandler
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    handleNotificationMessages(message);
    return Future<void>.value();
  }

  void init() async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');


    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (int? id, String? title, String? body, String? payload) async {
          ReceivedNotification receivedNotification = ReceivedNotification(id: id!, title: title!, body: body!, payload: payload!);
          didReceivedLocalNotificationSubject.add(receivedNotification);
        });

     initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onSelect);
    ///foreground message handler
    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint("onMessage: $message");
      handleNotificationMessages(message.data);
    });
    ///background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance.getToken().then((token) {
      if(token != null) {
        debugPrint("Push Messaging token: $token");
        // repository.sendFirebaseTokenToServer(token);
      }
    });
  }

  static handleNotificationMessages(Map<String, dynamic> message) {
    var data = message;
    debugPrint("myBackgroundMessageHandler message: $data");
    var action = data["action"];
    String title = "";
    String msg = "";
    if (action == "newMedia") {
      Map<String, dynamic> arts = json.decode(data['media']);
      Media articles = Media.fromJson(arts);
      title = articles.artist ?? '';
      msg = articles.title ?? '';
    }

    if (title != "" && msg != "") {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'streamit', 'streamit',
          color: AppColor.buttonColor,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
      var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      flutterLocalNotificationsPlugin.show(
          100, title, msg, platformChannelSpecifics,
          payload: json.encode(message));
    }
  }

  void onSelect(NotificationResponse response) async {
    debugPrint("onSelectNotification ${response.payload}");
    Map<String, dynamic> message = json.decode(response.payload??'');
    var data = message['data'];
    var action = data["action"];
    debugPrint("pushNotification = $action");
    if (action == "newMedia") {
      Map<String, dynamic> arts = json.decode(data['media']);
      Media media = Media.fromJson(arts);
      navigateMedia(media);
    }
  }

  setOnNotificationClick(Function onNotificationClick) async {
    final details =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      ReceivedNotification receivedNotification = ReceivedNotification(
          id: 0, title: '', body: '', payload: details.notificationResponse?.payload);
      didReceivedLocalNotificationSubject.add(receivedNotification);
    }

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
          onNotificationClick(payload);
          return;
        });
  }
}
