import 'package:dhak_dhol/model/dummy_data.dart';
import 'package:dhak_dhol/screens/profile/followers/followers_content.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';

class FollowersScreen extends StatelessWidget {
  const FollowersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.deepBlue,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Followers"),
          backgroundColor: AppColor.deepBlue,
        ),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: DummyData().follower.length,
          itemBuilder: (context, index) {
            return FollowersContent(
              follower: DummyData().follower[index],
            );
          },
        ));
  }
}
