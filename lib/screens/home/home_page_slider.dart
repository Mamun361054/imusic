import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/music/audio_provider.dart';
import 'music_player_page/audio_player_new_page.dart';

class HomePageSlider extends StatelessWidget {
  final Media? media;
  final List<Media>? mediaList;
  final int? index;

  const HomePageSlider(
      {Key? key, this.media, this.mediaList, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<AudioProvider>(context, listen: false).preparePlaylist(mediaList!, media!,index);
        Navigator.of(context).pushNamed(AudioPlayerNewPage.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          children: [
            SizedBox(
              width: 120.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(8)),
                        child: CachedNetworkImage(
                          width: 120.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                          imageUrl: "${media?.coverPhoto}",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress)),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Container(
                        height: 100.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Colors.transparent.withOpacity(0.0),
                              Colors.purple.withOpacity(0.6),
                            ],
                            stops: const [0.0, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0,),
                  Text(
                    media?.title ?? '',
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    media?.artist ?? '',
                    maxLines: 1,
                    style: TextStyle(
                      color: AppColor.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
