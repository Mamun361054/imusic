import 'package:dhak_dhol/provider/profile_provider.dart';
import 'package:dhak_dhol/screens/home/album/album_details/album_details.dart';
import 'package:dhak_dhol/screens/profile/followers/followers_screen.dart';
import 'package:dhak_dhol/screens/profile/total_earning/total_earning_screen.dart';
import 'package:dhak_dhol/screens/profile/total_song/total_song_screen.dart';
import 'package:dhak_dhol/screens/profile/total_view/total_view_screen.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../home/album/all_album/song_upload/song_upload_screen.dart';
import 'add_album/add_album_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ProfileProvider(),
      child: Consumer<ProfileProvider>(
        builder: (BuildContext context, provider, _) {

          final profileData = provider.profile;

          return Scaffold(
            backgroundColor: AppColor.deepBlue,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              centerTitle: true,
              backgroundColor: AppColor.deepBlue,
              title: const Text('Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            body: Column(
              children: [
                Visibility(
                  visible: true,
                  child: Row(
                    children: [
                      ///////// Total View//////
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TotalViewScreen(),
                                ));
                          },
                          child: Card(
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColor.backgroundColor2,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/view_icon.png',
                                      fit: BoxFit.cover,
                                    ),
                                    const Text(
                                      'Total view',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      /////////Followers/////////
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FollowersScreen(),
                                ));
                          },
                          child: Card(
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColor.backgroundColor2,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/follow_icon.png',
                                      fit: BoxFit.cover,
                                    ),
                                    const Text(
                                      'Followers',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: true,
                  child: Row(
                    children: [
                      ////////////Total Song///////////
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TotalSong(),
                                ));
                          },
                          child: Card(
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColor.backgroundColor2,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/song_icon.png',
                                      fit: BoxFit.cover,
                                    ),
                                    const Text(
                                      'Total Song',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //////////Earnings//////////
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TotalEarningScreen(),
                                ));
                          },
                          child: Card(
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColor.backgroundColor2,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/earning_icon.png',
                                      fit: BoxFit.cover,
                                    ),
                                    const Text(
                                      'Earnings',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text('Hello bijoy'),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.albums?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      final data = provider.albums?[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return AlbumDetailsScreen(data);
                          }));
                        },
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.purple,
                              radius: 33,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "${data?.thumbnail}",
                                ),
                                radius: 31,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data?.name}",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(.8)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 8),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 0,
                                        ),
                                        Image.asset(
                                            'assets/images/music_handaler.png'),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "${data?.mediaCount} track",
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(.8)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        color: Colors.grey,
                      );
                    },
                  ),
                )
              ],
            ),
            floatingActionButton: SpeedDial(
              //margin bottom
              icon: Icons.add,
              //icon on Floating action button
              activeIcon: Icons.close,
              //icon when menu is expanded on button
              backgroundColor: Colors.red,
              //background color of button
              foregroundColor: Colors.white,
              //font color, icon color in button
              activeBackgroundColor: Colors.red,
              //background color when menu is expanded
              activeForegroundColor: Colors.white,
              //button size
              visible: true,
              closeManually: false,
              curve: Curves.bounceIn,
              overlayColor: Colors.black,
              overlayOpacity: 0.5,
              elevation: 8.0,
              //shadow elevation of button
              shape: const CircleBorder(),
              //shape of button
              children: [
                SpeedDialChild(
                  child: Image.asset('assets/images/all_song_handaler.png'),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  label: 'Album',
                  labelStyle: const TextStyle(fontSize: 18.0),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddAlbumScreen(),
                        ));
                  },
                ),
                SpeedDialChild(
                  child: Image.asset(
                    'assets/images/music_handaler.png',
                  ),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  label: 'Song',
                  labelStyle: const TextStyle(fontSize: 18.0),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SongUploadScreen(),
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
