import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/data/model/playlist_model.dart';
import 'package:dhak_dhol/provider/playlist_provider.dart';
import 'package:dhak_dhol/screens/category/song_category/song_category_content.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/search_playlist.dart';

class PlaylistMediaScreen extends StatelessWidget {

  ///if data load from local fromLocal will be true
  ///if it's from server fromLocal will be false
  final bool fromLocal;

  const PlaylistMediaScreen({Key? key,  this.playlists,this.searchPlayList,this.fromLocal = true})
      : super(key: key);
  final Playlists? playlists;
  final SearchPlayList? searchPlayList;

  @override
  Widget build(BuildContext context) {
    PlaylistsProvider provider = Provider.of<PlaylistsProvider>(context);
    List<Playlists> itemsPlaylists = provider.playlistsList;

    return Scaffold(
      backgroundColor: AppColor.deepBlue,
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        title: Text(
          'Playlist',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: fromLocal ? FutureBuilder<List<Media>>(
          future: provider.getPlaylistsMedia(playlists?.id??0), //returns bool
          builder: (BuildContext context, AsyncSnapshot<List<Media>> value) {
            if (value.data == null) {
              return const Center();
            }
            List<Media>? items = value.data;
            if (items?.isEmpty == true) {
              return Center(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("No item display",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: ListView.builder(
                    itemCount: items?.length ?? 0,
                    itemBuilder: (context, index) {
                      final data = items![index];
                      return SongCategoryContent(
                        selectMusic: data,
                        mediaList: items,
                        index: index,
                      );
                    },
                  ),
                ),
              );
            }
          }): Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(0),
          child: ListView.builder(
            itemCount: searchPlayList?.list?.length ?? 0,
            itemBuilder: (context, index) {
              final data = searchPlayList!.list![index];
              return SongCategoryContent(
                selectMusic: data,
                mediaList: searchPlayList!.list,
                index: index,
              );
            },
          ),
        ),
      ),
    );
  }
}
