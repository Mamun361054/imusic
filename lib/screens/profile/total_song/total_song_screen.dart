import 'package:dhak_dhol/model/dummy_data.dart';
import 'package:dhak_dhol/screens/profile/total_song/total_song_content.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';

class TotalSong extends StatelessWidget {
  const TotalSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.deepBlue,
      appBar: AppBar(
        title: const Text('Total songs'),
        backgroundColor: AppColor.deepBlue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: false,
              scrollDirection: Axis.vertical,
              itemCount: DummyData().selectMusic.length,
              itemBuilder: (context, index) {
                return TotalSongContent(
                  selectMusic: DummyData().selectMusic[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
