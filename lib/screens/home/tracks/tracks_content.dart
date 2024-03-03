import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/music/audio_provider.dart';
import '../music_player_page/audio_player_new_page.dart';

class TracksContent extends StatelessWidget {
  final Media? tracks;
  final List<Media>? mediaList;
  final int? index;
  const TracksContent({Key? key, this.tracks, this.mediaList, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<AudioProvider>(context, listen: false).preparePlaylist(mediaList!, tracks!,index);
        Navigator.of(context).pushNamed(AudioPlayerNewPage.routeName);
      },
      child: SizedBox(
        width: 130.0,
        height: 165.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                width: 120,
                height: 100,
                fit: BoxFit.cover,
                imageUrl: "${tracks?.coverPhoto}",
                progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              tracks?.title ?? '',
              maxLines: 1,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              tracks?.artist ?? '',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
