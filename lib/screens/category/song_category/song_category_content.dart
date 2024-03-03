import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/provider/music/music_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/music/audio_provider.dart';
import '../../home/music_player_page/audio_player_new_page.dart';

class SongCategoryContent extends StatelessWidget {
  final Media? selectMusic;
  final List<Media>? mediaList;
  final int? index;

  const SongCategoryContent(
      {Key? key, this.selectMusic, this.mediaList, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    MusicProvider provider = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Provider.of<AudioProvider>(context, listen: false)
              .preparePlaylist(mediaList!, selectMusic!, index);
          Navigator.of(context).pushNamed(AudioPlayerNewPage.routeName);
        },
        child: Column(
          children: [
            Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                    imageUrl: "${selectMusic?.coverPhoto}",
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress)),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Image.asset('assets/images/music_handaler.png'),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                selectMusic?.title ?? "",
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(.8)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                selectMusic?.artist ?? "",
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(.8)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  selectMusic?.durationInMin ?? "N/A",
                  style: TextStyle(color: Colors.white.withOpacity(.8)),
                )
                // const Spacer(),
                // const Icon(
                //   Icons.more_vert,
                //   color: Colors.white,
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
