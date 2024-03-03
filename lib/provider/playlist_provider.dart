import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/data/model/playlist_model.dart';
import 'package:dhak_dhol/database/sqflite_database_provider.dart';
import 'package:flutter/material.dart';

class PlaylistsProvider with ChangeNotifier {
  // Userdata userdata;
  List<Playlists> playlistsList = [];
  List<Media> playlistMedias = [];

  PlaylistsProvider() {
    getPlaylists();
  }

  getPlaylists() async {
    playlistsList = await SQLiteDbProvider.db.getAllPlaylists();
    playlistsList.reversed.toList();
    notifyListeners();
  }

  createPlaylist(String title, String type) async {
    await SQLiteDbProvider.db.newPlaylist(title, type);
    getPlaylists();
  }

  deletePlaylists(int id) async {
    await SQLiteDbProvider.db.deletePlaylist(id);
    await SQLiteDbProvider.db.deletePlaylistsMedia(id);
    getPlaylists();
  }

  deletePlaylistsMediaList(int id) async {
    await SQLiteDbProvider.db.deletePlaylistsMedia(id);
    getPlaylists();
  }

  Future<bool?> isMediaAddedToPlaylist(Media media, int id) async {
    // var isMedia = await SQLiteDbProvider.db.isMediaAddedToPlaylist(media, id);
    // return isMedia == true ? true : false;
    return await SQLiteDbProvider.db.isMediaAddedToPlaylist(media, id);
  }

  Future<String?> getPlayListFirstMediaThumbnail(int id) async {
    return await SQLiteDbProvider.db.getPlayListFirstMediaThumbnail(id);
  }

  Future<int> getPlaylistMediaCount(int id) async {
    return await SQLiteDbProvider.db.getPlaylistsMediaCount(id);
  }

  addMediaToPlaylist(Media media, int id) async {
    await SQLiteDbProvider.db.addMediaToPlaylists(media, id);
    getPlaylists();
  }

  deleteMediaFromPlaylist(Media media, int id) async {
    await SQLiteDbProvider.db.removeMediaFromPlaylist(media, id);
    getPlaylists();
  }

  Future<List<Media>> getPlaylistsMedia(int id) async {
    return await SQLiteDbProvider.db.getAllPlaylistsMedia(id);
  }
}
