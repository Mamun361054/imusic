import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/music/audio_provider.dart';
import '../music_player_page/audio_player_new_page.dart';

class MyBookmarkContent extends StatelessWidget {
  final Media? myBookmark;
  final List<Media>? mediaList;
  final int? index;
  const MyBookmarkContent(
      {Key? key, this.myBookmark, this.mediaList, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Provider.of<MusicProvider>(context, listen: false).playCurrentMusic(
        //     media: myBookmark, listOfMedia: mediaList, playListIndex: index);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => MusicPlayerPage(
        //         playMusic: myBookmark,
        //       ),
        //     ));
        Provider.of<AudioProvider>(context, listen: false).preparePlaylist(mediaList!, myBookmark!,index);
        Navigator.of(context).pushNamed(AudioPlayerNewPage.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 8),
        child: SizedBox(
          height: 157,
          width: 115,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                color: Colors.transparent,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: 120,
                  width: 100,
                  imageUrl: "${myBookmark?.coverPhoto}",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset('assets/images/music_handaler.png'),
                  ),
                  Expanded(
                    child: Text(
                      myBookmark?.album ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                myBookmark?.title ?? '',
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
