import 'dart:convert';
import 'dart:io';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/provider/DownloadsModel.dart';
import 'package:dhak_dhol/provider/ads_provider.dart';
import 'package:dhak_dhol/provider/bookmarks_provider.dart';
import 'package:dhak_dhol/provider/music/audio_provider.dart';
import 'package:dhak_dhol/provider/music/music_provider.dart';
import 'package:dhak_dhol/provider/profile_provider.dart';
import 'package:dhak_dhol/provider/upload_songs_provider.dart';
import 'package:dhak_dhol/screens/auth/sign_in/sign_in_screen.dart';
import 'package:dhak_dhol/screens/comments/comments_screen.dart';
import 'package:dhak_dhol/screens/home/home_screen.dart';
import 'package:dhak_dhol/screens/home/music_player_page/audio_player_new_page.dart';
import 'package:dhak_dhol/screens/splash_screen/splash_screen.dart';
import 'package:dhak_dhol/utils/notification_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'data/model/comments_arguement.dart';
import 'data/model/notification_data_model.dart';
import 'provider/playlist_provider.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(debug: true);
  await Firebase.initializeApp();

  ///disable http certificate checking
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  ///top-level function
  ///to handle background messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // subscribe to topic on each app start-up

  await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => DownloadsModel()),
    ChangeNotifierProvider(create: (_) => MusicProvider()),
    ChangeNotifierProvider(create: (_) => AudioProvider()),
    ChangeNotifierProvider(create: (_) => UploadSongProvider()),
    ChangeNotifierProvider(create: (_) => BookmarksProvider()),
    ChangeNotifierProvider(create: (_) => PlaylistsProvider()),
    ChangeNotifierProvider(
      create: (_) => AdsProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: const SplashScreen(),
      title: 'Baddest Music',
      onGenerateRoute: (settings) {
        if (settings.name == AudioPlayerNewPage.routeName) {
          return MaterialPageRoute(
            builder: (context) {
              return const AudioPlayerNewPage();
            },
          );
        }
        if (settings.name == SignInScreen.routeName) {
          return MaterialPageRoute(
            builder: (context) {
              return const SignInScreen();
            },
          );
        }
        if (settings.name == CommentsScreen.routeName) {
          // Cast the arguments to the correct type: ScreenArguments.
          final CommentsArgument? args =
              settings.arguments as CommentsArgument?;
          return MaterialPageRoute(
            builder: (context) {
              return CommentsScreen(
                item: args?.item as Media,
                commentCount: args?.commentCount as int,
              );
            },
          );
        }
        return MaterialPageRoute(
          builder: (context) {
            return const HomeScreen();
          },
        );
      },
      theme: ThemeData(
          textTheme: GoogleFonts.manropeTextTheme(
            Theme.of(context).textTheme,
          ),
          iconTheme: const IconThemeData(size: 30)),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

///handle background messaging
///It must not be an anonymous function.
/// It must be a top-level function (e.g. not a class method which requires initialization).
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

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

  // await notificationPlugin.showNotification(
  //     title: message.notification?.title, body: message.notification?.body);
}
