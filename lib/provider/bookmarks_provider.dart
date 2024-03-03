import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/database/sqflite_database_provider.dart';
import 'package:flutter/cupertino.dart';

class BookmarksProvider extends ChangeNotifier{
  List<Media> bookmarksList = [];

  BookmarksProvider(){
    getBookmarks();
  }

  getBookmarks() async{
    bookmarksList = await SQLiteDbProvider.db.getAllMediaBookmarks();
    notifyListeners();
  }

  bookmarkMedia(Media media) async {
    await SQLiteDbProvider.db.bookmarkMedia(media);
    getBookmarks();
  }

  unBookmarkMedia(Media media) async {
    await SQLiteDbProvider.db.deleteBookmarkedMedia(media.id!);
    getBookmarks();
  }

  bool isMediaBookmarked(Media? media) {
      final items = bookmarksList.where((itm) => itm.id == media?.id).toList();
      debugPrint(items.isNotEmpty.toString());
      return items.isNotEmpty ;
  }
}