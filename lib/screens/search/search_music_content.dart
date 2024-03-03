import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../provider/music/audio_provider.dart';
import '../../provider/search_provider.dart';
import '../home/music_player_page/audio_player_new_page.dart';

class SearchMediaScreen extends StatefulWidget {
  const SearchMediaScreen({Key? key}) : super(key: key);

  @override
  State<SearchMediaScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchMediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (BuildContext context, provider, _) {
        return provider.searchModel == null
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("assets/images/music_not_found_one.json",
                      height: 150.0, width: 150.0),
                  Text(
                    "Try Again Later",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ))
            : provider.searchModel!.musics.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: provider.searchModel?.musics.length,
                    itemBuilder: (context, index) {
                      return SearchMusicContent(
                        selectMusic:
                            provider.searchModel?.musics.elementAt(index),
                        mediaList: provider.searchModel?.musics,
                        index: index,
                      );
                    },
                  )
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/images/music_not_found_one.json",
                          height: 150.0, width: 150.0),
                      Text(
                        "No Music Found",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ));
      },
    );
  }
}

class SearchMusicContent extends StatelessWidget {
  final Media? selectMusic;
  final List<Media>? mediaList;
  final int? index;
  const SearchMusicContent(
      {Key? key, this.selectMusic, this.mediaList, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<AudioProvider>(context, listen: false)
            .preparePlaylist(mediaList!, selectMusic!, index);
        Navigator.of(context).pushNamed(AudioPlayerNewPage.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: CachedNetworkImage(
                    width: 80,
                    height: 80,
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
                            const SizedBox(
                              width: 50,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
