import 'package:dhak_dhol/data/model/profile_model.dart';
import 'package:dhak_dhol/screens/home/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:dhak_dhol/screens/profile/profile_new/custom_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/model/artist_model.dart';
import '../../data/model/update_profile.dart';
import '../../provider/profile_provider.dart';
import '../../utils/app_const.dart';
import '../../utils/shared_pref.dart';
import '../onboarding_screen/onboarding_screen.dart';
import '../search/search_screen.dart';

class ProfileEditScreen extends StatefulWidget {
  final Profile? profile;

  const ProfileEditScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  Widget build(BuildContext context) {
    UpdateProfile updateProfile = UpdateProfile(
        email: widget.profile?.email,
        name: widget.profile?.name,
        facebook: widget.profile?.facebook ?? '',
        instagram: widget.profile?.instagram ?? '',
        snapshot: widget.profile?.snapchat ?? '',
        about: widget.profile?.about,
        artists: widget.profile?.favArtists?.join(','),
        interests: widget.profile?.interests?.join(','));

    updateProfile.email = widget.profile?.email;
    final formKey = GlobalKey<FormState>();
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColor.signInPageBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.backgroundColor,
        title: Image.asset(
          AppImage.iconWhite,
          height: 50.0,
          fit: BoxFit.fitHeight,
        ),
        actions: [
          const Center(
              child: Text(
            "Edit Profile",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          )),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchScreen()));
              },
              icon: const Icon(Icons.search_rounded)),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      body: Center(
        child: !provider.isUpdating
            ? Container(
                height: ScreenUtil.defaultSize.height + 35.0,
                decoration: BoxDecoration(
                  color: AppColor.signInPageBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 25.0,
                          ),
                          InkWell(
                            onTap: () {
                              provider.uploadImage(context);
                            },
                            child: const CustomProfileImage(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                            ),
                            child: Text(
                              "Profile Display Name",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.manrope(color: AppColor.grey),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              controller: TextEditingController(
                                  text: widget.profile?.name ?? ''),
                              cursorColor: AppColor.signInPageBackgroundColor,
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 40, 0, 0),
                                  filled: true,
                                  fillColor: AppColor.inputBackgroundColor
                                      .withOpacity(0.7),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent)),
                                  hintText: "Profile Display Name",
                                  hintStyle: GoogleFonts.manrope(
                                      color: Colors.white.withOpacity(.2))),
                              onChanged: (val) {
                                updateProfile.name = val;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                            ),
                            child: Text(
                              "Enter your Bio",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.manrope(color: AppColor.grey),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              cursorColor: AppColor.signInPageBackgroundColor,
                              controller: TextEditingController(
                                  text: widget.profile?.about ?? ''),
                              maxLines: 4,
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 40, 0, 0),
                                  filled: true,
                                  fillColor: AppColor.inputBackgroundColor
                                      .withOpacity(0.7),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent)),
                                  hintText: "Enter your Bio",
                                  hintStyle: GoogleFonts.manrope(
                                      color: Colors.white.withOpacity(.2))),
                              onChanged: (val) {
                                updateProfile.about = val;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                            ),
                            child: Text(
                              "Select Favorite Artists",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.manrope(color: AppColor.grey),
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),

                          ///=================== add album ==================
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: AppColor.inputBackgroundColor
                                    .withOpacity(0.7)),
                            child: DropdownButton<Artists>(
                              dropdownColor: AppColor.inputBackgroundColor
                                  .withOpacity(0.7),
                              isExpanded: true,
                              value: provider.selectedArtist,
                              icon: const Icon(
                                Icons.arrow_downward,
                                color: Colors.white,
                                size: 18,
                              ),
                              underline: const SizedBox(),
                              elevation: 16,
                              hint: Text(
                                'Artists',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.white),
                              ),
                              focusColor: Colors.white,
                              onChanged: (newValue) {
                                provider.onItemChanged(newValue);
                              },
                              items: provider.allArtists
                                  .map<DropdownMenuItem<Artists>>((value) {
                                return DropdownMenuItem<Artists>(
                                  value: value,
                                  child: Text(value.title!,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                            ),
                          ),
                          Visibility(
                            visible: provider.selectedArtists.isNotEmpty,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Wrap(
                                  spacing: 8.0,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children:
                                      provider.selectedArtists.map((data) {
                                    return Chip(
                                      label: Text(data.title ?? ''),
                                      deleteIcon: const Icon(
                                        Icons.cancel,
                                        size: 25.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      onDeleted: () {
                                        provider.onItemRemove(data);
                                      },
                                    );
                                  }).toList()),
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          InkWell(
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                updateProfile.artists = provider.selectedArtists
                                    .map((e) => e.id)
                                    .toList()
                                    .join(',');

                                provider
                                    .onUpdateProfile(
                                        updateProfile: updateProfile)
                                    .then((isUpdated) async {
                                  if (isUpdated) {
                                    provider.getProfile().then((profile) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BottomNavigationScreen(),
                                          ));
                                    });
                                  }
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              child: Container(
                                height: 50.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.topRight,
                                      colors: <Color>[
                                        AppColor.buttonColor,
                                        AppColor.buttonColor
                                      ],
                                    )),
                                child: Center(
                                  child: Text('Update my Profile',
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.backgroundColor,
                                          fontSize: 16)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              )
            : Padding(
                padding: EdgeInsets.only(top: ScreenUtil.defaultSize.height / 2),
                child: const CircularProgressIndicator(),
              ),
      ),
    );
  }
}
