import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/genres_model.dart';
import 'package:dhak_dhol/data/model/playlist_model.dart';
import 'package:dhak_dhol/provider/playlist_provider.dart';
import 'package:dhak_dhol/screens/home/playlists/playlist_mdia_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/search_playlist.dart';
import '../genre_screen/gener_screen.dart';

class PlaylistsContent extends StatelessWidget {
  final Playlists? playlists;
  final SearchPlayList? searchPlayList;
  final double paddingLeft;

  const PlaylistsContent(
      {Key? key, this.playlists, this.searchPlayList, this.paddingLeft = 12.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlaylistsProvider provider = Provider.of<PlaylistsProvider>(context);

    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return PlaylistMediaScreen(
            playlists: playlists,
            searchPlayList: searchPlayList,
            fromLocal: searchPlayList == null,
          );
        }));
      },
      child: Padding(
        padding: EdgeInsets.only(left: paddingLeft, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: <Widget>[
                SizedBox(
                  height: 90.0,
                  width: 108.0,
                  child: searchPlayList == null
                      ? FutureBuilder<String?>(
                          initialData: "",
                          future: provider.getPlayListFirstMediaThumbnail(
                              playlists!.id!), //returns bool
                          builder: (BuildContext context,
                              AsyncSnapshot<String?> value) {
                            if (value.data == null || value.data == "") {
                              return Icon(
                                Icons.music_note,
                                size: 30,
                                color: Colors.primaries[
                                    Random().nextInt(Colors.primaries.length)],
                              );
                            } else {
                              return CachedNetworkImage(
                                imageUrl: value.data!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => const Center(
                                    child: CupertinoActivityIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                        child: Icon(
                                  Icons.error,
                                  color: Colors.grey,
                                )),
                              );
                            }
                          })
                      : CachedNetworkImage(
                          imageUrl: searchPlayList?.image ?? '',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const Center(child: CupertinoActivityIndicator()),
                          errorWidget: (context, url, error) => const Center(
                              child: Icon(
                            Icons.error,
                            color: Colors.grey,
                          )),
                        ),
                ),
                if (searchPlayList == null)
                  Container(
                    height: 91,
                    width: 107,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          const Color(0xff7001B6).withOpacity(0.9),
                          const Color(0xffFB7159).withOpacity(0.6),
                        ],
                        stops: const [0.0, 5.0],
                      ),
                    ),
                  ),
                Positioned(
                    left: 0,
                    bottom: 0,
                    top: 0,
                    right: 0,
                    child: Image.asset('assets/images/play_handaler.png'))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset('assets/images/music_handaler.png'),
                ),
                Text(
                  playlists?.title ?? searchPlayList?.name ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GenreListContent extends StatelessWidget {
  final Genres? genres;
  final double paddingLeft;

  const GenreListContent({Key? key, this.genres, this.paddingLeft = 12.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return GenreScreen(
            genreTitle: genres,
          );
        }));
      },
      child: Padding(
        padding: EdgeInsets.only(left: paddingLeft, top: 16.0,bottom: 16.0),
        child:  Text(
          genres?.name ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
