import 'package:dhak_dhol/data/model/search_model.dart';
import 'package:dhak_dhol/screens/search/search_albums_content.dart';
import 'package:dhak_dhol/screens/search/search_artists_content.dart';
import 'package:dhak_dhol/screens/search/search_chat_content.dart';
import 'package:dhak_dhol/screens/search/search_genre_content.dart';
import 'package:dhak_dhol/screens/search/search_music_content.dart';
import 'package:dhak_dhol/screens/search/search_playlist_content.dart';
import 'package:flutter/material.dart';

class SearchContent extends StatelessWidget {
  final int viewIndex;
  final SearchModel? searchModel;

  const SearchContent(
      {Key? key, required this.viewIndex, required this.searchModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (viewIndex) {
      case 0:
        return SearchAlbumsContent(
          albums: searchModel?.albums ?? [],
        );
      case 1:
        return SearchArtistsContent(artists: searchModel?.artists ?? []);
      case 2:
        return SearchMediaScreen();
      case 3:
        return SearchPlaylistContent(
          playlists: searchModel?.playlists ?? [],
        );
      case 4:
        return SearchGenreContent(
          genres: searchModel?.genres ?? [],
        );
      case 5:
        return SearchChatContent(users: searchModel?.users ?? []);
      default:
        return SearchMediaScreen();
    }
  }
}
