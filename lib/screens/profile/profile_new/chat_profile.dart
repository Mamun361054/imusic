import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/data/model/profile_model.dart';
import 'package:dhak_dhol/provider/profile_provider.dart';
import 'package:dhak_dhol/screens/home/artists/profile_artists_view.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/model/artist_model.dart';
import '../../../data/model/user_model.dart';

class ChatProfileScreen extends StatelessWidget {
  final UserModel? friend;

  const ChatProfileScreen({super.key, this.friend});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.backgroundColor,
              title: const Text("Profile"),
            ),
            body: ColoredBox(
              color: AppColor.backgroundColor,
              child: SafeArea(
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        AppImage.iconWhite,
                        height: 480.0,
                        width: 480.0,
                        fit: BoxFit.fitHeight,
                        opacity: const AlwaysStoppedAnimation(.1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: provider.attachmentFile == null
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                        imageUrl: friend?.user?.image ??
                                            "https://www.w3schools.com/howto/img_avatar.png",
                                        placeholder: (context, url) => Center(
                                          child: Image.asset(
                                              "assets/images/app_logo.png"),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 45.0,
                                      backgroundImage: FileImage(
                                          provider.attachmentFile ??
                                              File('${friend?.user?.image}')),
                                    ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                // '${friend?.user?.name}',
                                '${friend?.user?.name}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.titleColor,
                                    fontSize: 20),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                friend?.user?.email ?? '',
                                maxLines: 7,
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            ///=============Bio=================
                            Text(
                              "About",
                              style: TextStyle(
                                  color: AppColor.titleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                              friend?.user?.about != 'null'
                                  ? friend?.user?.about ?? 'NA'
                                  : 'NA',
                              maxLines: 7,
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600),
                            ),

                            ///============= Artists ======================
                            FutureBuilder(
                              future: getArtistsList(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Artists>?> snapshot) {
                                return ProfileArtistsScreen(
                                  artists: snapshot.data ?? [],
                                  // artists: provider.profile?.favArtists ?? [],
                                );
                              },
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // FutureBuilder<String?>(
                    //   future: SharedPref.getValue(SharedPref.keyEmail),
                    //   builder: (_,data){
                    //     if(!data.hasData){
                    //       return Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Align(
                    //               child: Lottie.asset(
                    //                   'assets/images/login_screen_lotte.json',
                    //                   height: 250.0)),
                    //           const SizedBox(
                    //             height: 16.0,
                    //           ),
                    //           Align(
                    //             alignment: Alignment.center,
                    //             child: ElevatedButton(
                    //               onPressed: () {
                    //                 Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                       builder: (context) => const SignInScreen(),
                    //                     ));
                    //               },
                    //               style: ElevatedButton.styleFrom(
                    //                   backgroundColor: AppColor.buttonColor,
                    //                   padding:
                    //                   const EdgeInsets.symmetric(horizontal: 24.0)),
                    //               child: Text(
                    //                 'Sign in',
                    //                 style: GoogleFonts.manrope(
                    //                     color: AppColor.signInPageBackgroundColor,
                    //                     fontSize: 16),
                    //               ),
                    //             ),
                    //           )
                    //         ],
                    //       );
                    //     }
                    //     return SizedBox.shrink();
                    //       },
                    //     ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Future<List<Artists>?> getArtistsList() async {
    String? email = friend?.user?.email;

    // ignore: unused_local_variable
    final data = FormData.fromMap({"email": email});
    final response = await Repository().getProfileData();

    if (response?.statusCode == 200) {
      final arr = response!.data.toString().split('</div>');
      final res = jsonDecode(arr.last);
      Profile? profile =
          res['user'] != null ? Profile.fromJson(res['user']) : null;
      List<Artists> selectedArtists = profile?.favArtists ?? [];

      return selectedArtists;
    }
    return null;
  }
}
