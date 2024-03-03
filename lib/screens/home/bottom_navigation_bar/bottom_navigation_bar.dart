import 'package:dhak_dhol/screens/home/album/all_album/all_album_screen.dart';
import 'package:dhak_dhol/screens/home/home_screen.dart';
import 'package:dhak_dhol/screens/profile/profile_new/profile_new.dart';
import 'package:dhak_dhol/screens/webview/webview_screen.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/home_provider.dart';
import '../../../provider/profile_provider.dart';
import '../../mini_audio_player/mini_player.dart';
import '../artists/artists_details/artists_details_screen.dart';
import '../genre_screen/genre_home_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    GenreHomeScreen(),
    ProfileNew(),
    ArtistsDetailsScreen(isAppBarVisible: true),
    WebViewScreen(url: 'https://baddest.ng/post/'),
    AllAlbumScreen(isAppBarVisible: true)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: Scaffold(
        backgroundColor: AppColor.appBar,
        body: Column(
          children: [
            Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
            const MiniPlayer(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(1, 1),
              ),
            ],
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          ),
          child: BottomNavigationBar(
            elevation: 4,
            backgroundColor: AppColor.deepBlue,
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: IconThemeData(color: AppColor.secondary),
            selectedItemColor: Colors.orange,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.grey,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/home.png',
                  height: 35.0,
                  width: 35.0,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/mood.png',
                  height: 35.0,
                  width: 35.0,
                ),
                label: 'Genre',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/profile.png',
                    height: 35.0, width: 35.0),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/artist.png',
                  height: 35.0,
                  width: 35.0,
                ),
                label: 'Artists',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/post.png',
                  height: 35.0,
                  width: 35.0,
                ),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/album.png',
                  height: 35.0,
                  width: 35.0,
                ),
                label: 'Album',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
