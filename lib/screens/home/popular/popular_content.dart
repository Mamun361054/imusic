import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/provider/music/music_provider.dart';
import 'package:dhak_dhol/screens/home/music_player_page/music_player_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/music/audio_provider.dart';
import '../music_player_page/audio_player_new_page.dart';

class PopularContent extends StatelessWidget {
  final Media? popular;
  final List<Media>? mediaList;
  final int? index;
  const PopularContent({Key? key, this.popular, this.mediaList, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<AudioProvider>(context, listen: false).preparePlaylist(mediaList!, popular!,index);
        Navigator.of(context).pushNamed(AudioPlayerNewPage.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                width: 120.0,
                height: 100.0,
                fit: BoxFit.cover,
                imageUrl: "${popular?.coverPhoto}",
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              popular?.title ?? '',
              maxLines: 1,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              popular?.artist ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
