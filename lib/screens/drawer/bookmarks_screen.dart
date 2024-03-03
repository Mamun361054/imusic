import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/provider/bookmarks_provider.dart';
import 'package:dhak_dhol/screens/category/song_category/song_category_content.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookmarksProvider = Provider.of<BookmarksProvider>(context);
    List<Media>? items = bookmarksProvider.bookmarksList;
    debugPrint('${items.length}');
    return Scaffold(
      backgroundColor: AppColor.deepBlue,
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        title: const Text('Bookmarks'),
      ),
      body: SafeArea(
        child: items.isEmpty
            ? Center(
                child: Text(
                  'No item to display',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, int index) {
                  final data = items[index];
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
}
