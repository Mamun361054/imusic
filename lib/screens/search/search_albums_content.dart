import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/album_model.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../provider/music/audio_provider.dart';
import '../home/album/album_page.dart';
import '../home/music_player_page/audio_player_new_page.dart';

class SearchAlbumsContent extends StatelessWidget {
  final List<Albums> albums;
  const SearchAlbumsContent({Key? key,required this.albums}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return albums.isNotEmpty ? GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 170.0,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0),
        itemCount: albums.length,
        itemBuilder: (BuildContext ctx, index) {
          final album = albums[index];
          return AlbumPage(
            albumList: album,
          );
        }) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
                "assets/images/music_not_found_one.json",
                height: 150.0,
                width: 150.0),
            Text(
              "No Albums Found",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ));
  }
}
