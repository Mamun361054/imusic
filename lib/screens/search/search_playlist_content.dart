import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/data/model/playlist_model.dart';
import 'package:flutter/material.dart';
import '../../model/search_playlist.dart';
import '../home/playlists/playlists_content.dart';

class SearchPlaylistContent extends StatelessWidget {
  final List<SearchPlayList> playlists;
  const SearchPlaylistContent({Key? key,required this.playlists}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 130.0,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0),
        itemCount: playlists.length,
        itemBuilder: (BuildContext ctx, index) {
          final playlist = playlists[index];
          return PlaylistsContent(searchPlayList: playlist,);
        });
  }
}
