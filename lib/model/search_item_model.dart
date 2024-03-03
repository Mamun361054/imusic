import 'package:flutter/material.dart';

enum Filter {albums, genre, music, user, playlist, artists}

class SearchItem{
  final String title;
  final IconData icon;
  final Filter filter;

  SearchItem({required this.title,required this.icon,required this.filter});
}


final searchItems = [
  SearchItem(title: 'Albums', icon: Icons.album, filter: Filter.albums),
  SearchItem(title: 'Artists', icon: Icons.article, filter: Filter.artists),
  SearchItem(title: 'Music', icon: Icons.headset, filter: Filter.music),
  SearchItem(title: 'Playlist', icon: Icons.playlist_play, filter: Filter.playlist),
  SearchItem(title: 'Genre', icon: Icons.link, filter: Filter.genre),
  SearchItem(title: 'Chat', icon: Icons.image, filter: Filter.user),
];
