import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/profile_provider.dart';

class CustomProfileImage extends StatelessWidget {
  const CustomProfileImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<ProfileProvider>();

    // return Center(
    //   child: provider.attachmentFile == null ? CircleAvatar(
    //     radius: 45.0,
    //     backgroundColor: Colors.transparent,
    //     backgroundImage: NetworkImage('${provider.profile?.thumbnail}'),
    //   ) : CircleAvatar(
    //     backgroundColor: Colors.transparent,
    //     radius: 45.0,
    //     backgroundImage: FileImage(provider.attachmentFile ?? File('${provider.profile?.thumbnail}')),
    //   ),
    // );

    return Center(
      child: provider.attachmentFile == null ? ClipOval(
        child: CachedNetworkImage(
          height: 80,
          width: 80,
          fit: BoxFit.cover,
          imageUrl: provider.profile?.thumbnail ??
              "https://www.w3schools.com/howto/img_avatar.png",
          placeholder: (context, url) => Center(
            child: Image.asset(
                "assets/images/app_logo.png"),
          ),
          errorWidget: (context, url, error) =>
              Image.asset(
              "assets/images/ic_profile.png"),
        ),

    ) : CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 45.0,
        backgroundImage: FileImage(provider.attachmentFile ?? File('${provider.profile?.thumbnail}')),
      ), );
  }
}
