import 'dart:async';
import 'dart:convert';
import 'package:dhak_dhol/provider/home_provider.dart';
import 'package:dhak_dhol/provider/music/audio_provider.dart';
import 'package:dhak_dhol/provider/search_provider.dart';
import 'package:dhak_dhol/screens/drawer/drawer.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/firebase_service/firebase_messaing.dart';
import '../../data/firebase_service/firebase_service.dart';
import '../../data/model/media_model.dart';
import '../../data/model/notification_data_model.dart';
import '../../main.dart';
import '../../provider/profile_provider.dart';
import '../../utils/notification_plugin.dart';
import '../../utils/shared_pref.dart';
import '../../widgets/custom_appbar.dart';
import 'build_home_page_body.dart';
import 'music_player_page/audio_player_new_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? token;

  navigateMedia(Media media) {
    debugPrint("push notification media = ${media.title}");
    List<Media> mediaList = [];
    mediaList.add(media);
    Provider.of<AudioProvider>(context, listen: false)
        .preparePlaylist(mediaList, media, 0);
    navigatorKey.currentState?.pushNamed(AudioPlayerNewPage.routeName);
  }

  /// multiple subscription on topics
  Future subscribeTopics() async {
    var userId = await SharedPref.getValue(SharedPref.keyId);
    var roleId = await SharedPref.getValue(SharedPref.keyRoleId);
    debugPrint("subscribe to channel : role_$roleId");
    debugPrint("subscribe to channel : user_$userId");
    await FirebaseMessaging.instance.subscribeToTopic('user_$userId');
    await FirebaseMessaging.instance.subscribeToTopic('role_$roleId');
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    subscribeTopics();
    FirebaseMessage(navigateMedia).init();
    _firebaseMessaging.getToken().then((value) {
      debugPrint('token is $value');
      token = value!;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final encodedString = json.encode(message.data);

      NotificationDataModel notification =
          NotificationDataModel.fromJson(message.data);

      ///checking if title null or not if null no notification wi show
      if (notification.image == null) {
        await notificationPlugin.showNotification(
            title: notification.title ?? message.notification?.title,
            body: notification.body ?? message.notification?.body,
            payload: encodedString);
        return;
      } else {
        await notificationPlugin.showNotificationWithAttachment(
            title: notification.title ?? message.notification?.title,
            body: notification.body ?? message.notification?.body,
            image: notification.image,
            payload: encodedString);
      }
    });

    notificationPlugin.didReceivedLocalNotificationSubject.listen((value) {
      onNotificationClick(value.payload);
    });

    ///setNotificationClickListenerForLowerVersion
    notificationPlugin
        .setListenerForLowerVersion(onNotificationInLowerVersions);

    ///setNotificationClickListener
    notificationPlugin.setOnNotificationClick(onNotificationClick);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<ProfileProvider>();

    SharedPref.getValue(SharedPref.keyId).then((uid) {
      if (uid != null) {
        ///update token to firebase fireStore in users/uid/ path
        FirebaseService().updateUserToken(token: token, uid: '$uid');

        ///updateStatusDataWIthGivenDurationPeriodically
        Timer.periodic(Duration(seconds: 10), (timer) {
          Debounce(milliseconds: 1000).run(() {
            FirebaseService().updateStatusData(uid: uid);
          });
        });
      }
    });

    return Consumer<HomeProvider>(
      builder: (BuildContext context, provider, _) {
        return Scaffold(
          backgroundColor: AppColor.backgroundColor,
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(55.0), child: CustomAppBar()),
          drawer: const AppDrawer(),
          body: const BuildHomePageBody(),
        );
      },
    );
  }

  ///notification click event for lower version
  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    if (kDebugMode) {
      print(receivedNotification.body);
    }
  }

  ///notification click event
  onNotificationClick(payload) {
    if (payload != null) {
      if (kDebugMode) {
        print('payload: $payload');
      }

      final map = json.decode(payload);

      NotificationDataModel notificationData =
          NotificationDataModel.fromJson(map);
    }
  }
}
