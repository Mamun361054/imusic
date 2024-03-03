import 'dart:io';
import 'package:dhak_dhol/data/model/profile_model.dart';
import 'package:dhak_dhol/provider/profile_provider.dart';
import 'package:dhak_dhol/screens/profile/profile_edit_screen.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:dhak_dhol/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../widgets/custom_appbar.dart';
import '../../auth/sign_in/sign_in_screen.dart';
import '../../drawer/drawer.dart';
import '../../home/artists/profile_artists_view.dart';
import '../../home/playlists/profile_playlists.screen.dart';
import '../../onboarding_screen/delete_screen.dart';
import 'custom_profile_image.dart';

class ProfileNew extends StatefulWidget {
  final int? id;

  const ProfileNew({Key? key, this.id}) : super(key: key);

  @override
  State<ProfileNew> createState() => _ProfileNewState();
}

class _ProfileNewState extends State<ProfileNew> {

  @override
  void initState() {
    if(widget.id != null)
    context.read<ProfileProvider>().getProfile(pid: widget.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, provider, child) {
          return Scaffold(
                    backgroundColor: AppColor.backgroundColor,
                    appBar: const PreferredSize(preferredSize: Size.fromHeight(55.0), child: CustomAppBar()),
                    drawer: const AppDrawer(),
                    body: provider.loadingProfile != true ? SafeArea(
                      child: Stack(
                        children: [
                          if (provider.profile != null) ...[
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const CustomProfileImage(),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            FutureBuilder<String?>(
                                              future: SharedPref.getValue(SharedPref.keyId),
                                              builder: (context,snapshot){
                                                if(snapshot.hasData){
                                                  return '${provider.profile!.id}' == '${snapshot.data}' ?  InkWell(
                                                    onTap: () async {
                                                      Profile? p = await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) => ProfileEditScreen(
                                                                profile: provider.profile,
                                                              )));

                                                      if (p != null) {
                                                        context.read<ProfileProvider>().updateProfile1(provider.profile);
                                                      }
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Edit Profile",
                                                          style: TextStyle(
                                                              color: AppColor.textColor,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Image.asset(
                                                          "assets/images/ic_edit.png",
                                                          height: 20,
                                                          width: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ) : SizedBox.shrink();
                                                }
                                                return SizedBox.shrink();
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${provider.profile?.name}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor.titleColor,
                                                  fontSize: 20),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Visibility(
                                                  visible:
                                                  provider.profile?.snapchat != null,
                                                  child: Image.asset(
                                                    'assets/images/ic_snapchat_one.png',
                                                    height: 30,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible:
                                                  provider.profile?.instagram != null,
                                                  child: Image.asset(
                                                    'assets/images/ic_instagram.png',
                                                    height: 36,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible:
                                                  provider.profile?.facebook != null,
                                                  child: Image.asset(
                                                    'assets/images/ic_facebook.png',
                                                    height: 32,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Divider(
                                      height: 1,
                                      color: Colors.white30,
                                      thickness: 1,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      "About",
                                      style: TextStyle(
                                          color: AppColor.titleColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      provider.profile?.about ?? 'Edit Profile',
                                      maxLines: 7,
                                      style: const TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),

                                    ///============= Artists ======================
                                    ProfileArtistsScreen(
                                      artists: provider.profile?.favArtists ?? [],
                                    ),
                                    const SizedBox(
                                      height: 16.0,
                                    ),

                                    ///============= Playlists ======================
                                    const ProfilePlaylistsScreen(),
                                    const SizedBox(
                                      height: 8.0,
                                    ),

                                    Text(
                                      "Interests",
                                      style: TextStyle(
                                          color: AppColor.titleColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    if(provider.profile?.interests != null)
                                    Row(
                                        children: provider.profile!.interests!
                                            .map((e) => Text(
                                          '$e  ',
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w600),
                                        )).toList(),
                                      ),
                                    FutureBuilder<String?>(
                                      future: SharedPref.getValue(SharedPref.keyId),
                                      builder: (context,snapshot){
                                        if(snapshot.hasData){
                                          return '${provider.profile!.id}' == '${snapshot.data}' && Platform.isIOS ?   InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  content: const Text('Are you sure? you want to delete the account',style: TextStyle(fontWeight: FontWeight.bold),),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () => Navigator.of(context).pop(),
                                                        child: const Text('No')),
                                                    TextButton(
                                                        onPressed: () async {
                                                          provider.profile = null;
                                                          await SharedPref.deleteKey(SharedPref.keyEmail);
                                                          await SharedPref.deleteKey(SharedPref.keyId);
                                                          await SharedPref.deleteKey(SharedPref.isFirstTimeLogin);
                                                          await SharedPref.deleteKey(SharedPref.keyToken);
                                                          await SharedPref.deleteKey(SharedPref.keyRoleId);
                                                          await SharedPref.deleteKey(SharedPref.keyProfileImage);

                                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const DeleteScreen()), (Route<dynamic> route) => false);
                                                        }, child: const Text('Yes')),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0,),
                                              child: Container(
                                                height: 50.0,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(8.0)),
                                                    color: Colors.red),
                                                child: Center(
                                                  child: Text('Delete Account',
                                                      style: GoogleFonts.manrope(
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white,
                                                          fontSize: 16)),
                                                ),
                                              ),
                                            ),
                                          ) : SizedBox.shrink();
                                        }
                                        return SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          Visibility(
                            visible: provider.profile == null,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                    child: Lottie.asset(
                                        'assets/images/login_screen_lotte.json',
                                        height: 250.0)),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const SignInScreen(),
                                          ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.buttonColor,
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 24.0)),
                                    child: Text(
                                      'Sign in',
                                      style: GoogleFonts.manrope(
                                          color: AppColor.signInPageBackgroundColor,
                                          fontSize: 16),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ):Center(child: CircularProgressIndicator()));


    });
  }
}
