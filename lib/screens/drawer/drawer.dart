import 'package:dhak_dhol/screens/downloader/downloader_page.dart';
import 'package:dhak_dhol/screens/drawer/bookmarks_screen.dart';
import 'package:dhak_dhol/screens/home/playlists/drawer_playlist/drawer_playlist_screen.dart';
import 'package:dhak_dhol/screens/onboarding_screen/onboarding_screen.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:dhak_dhol/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/profile_provider.dart';
import '../../widgets/ads_content.dart';
import '../auth/sign_in/sign_in_screen.dart';
import '../home/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../home/moods/mood_details/mood_details_screen.dart';
import '../tracks/track_list_view.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Drawer(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: ColoredBox(
          color: AppColor.signInPageBackgroundColor,
          child: Column(
            children: [
              const SizedBox(
                height: 16.0,
              ),
              ListTile(
                title: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => BottomNavigationScreen()), (route) => false);
                },
              ),
              ListTile(
                title: const Text(
                  'Tracks',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MediaListView(
                            'Tracks', 'New Audios from all categories'),
                      ));
                },
              ),
              ListTile(
                title: const Text(
                  'Playlist',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const DrawerPlaylistScreen();
                  }));
                },
              ),
              ListTile(
                title: const Text(
                  'Moods',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const MoodDetailsScreen();
                  }));
                },
              ),

              /// ================= ADS ======================
              AdsContent(
                press: () {},
              ),
              ListTile(
                title: const Text(
                  'Downloads',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return DownloaderPage(downloads: null, platform: Theme.of(context).platform);
                  }));
                },
              ),
              ListTile(
                title: const Text(
                  'BookMarks',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const BookmarksScreen();
                  }));
                },
              ),
              // ExpansionTile(
              //   title: const Text(
              //     "Settings",
              //     style: TextStyle(color: Colors.white, fontSize: 16),
              //   ),
              //   childrenPadding:
              //   const EdgeInsets.only(left: 5), //children padding
              //   children: [
              //     ListTile(
              //       title: const Text(
              //         "About Us",
              //         style: TextStyle(color: Colors.white, fontSize: 16),
              //       ),
              //       onTap: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => const AboutUsScreen(),
              //             ));
              //       },
              //     ),
              //
              //     ListTile(
              //       title: const Text(
              //         "App Terms",
              //         style: TextStyle(color: Colors.white, fontSize: 16),
              //       ),
              //       onTap: () {
              //         //action on press
              //       },
              //     ),
              //
              //     //more child menu
              //   ],
              // ),
              ListTile(
                title: Text(
                  provider.profile != null ? 'Logout' : 'Login',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                onTap: () async {
                  if (provider.profile != null) {
                    provider.profile = null;
                    await SharedPref.deleteKey(SharedPref.keyEmail);
                    await SharedPref.deleteKey(SharedPref.keyId);
                    await SharedPref.deleteKey(SharedPref.isFirstTimeLogin);
                    await SharedPref.deleteKey(SharedPref.keyToken);
                    await SharedPref.deleteKey(SharedPref.keyRoleId);
                    setState(() {
                      if (mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const OnboardingScreen()),
                            (Route<dynamic> route) => false);
                      }
                    });
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
