import 'package:dhak_dhol/provider/bookmarks_provider.dart';
import 'package:dhak_dhol/screens/home/my_bookmark/my_bookmark_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBookmarkScreen extends StatelessWidget {
  const MyBookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookmarksProvider = Provider.of<BookmarksProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text(
                  'My bookmark',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/headphone_handaler.png'),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        bookmarksProvider.bookmarksList.isNotEmpty
            ? SizedBox(
                height: 195,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bookmarksProvider.bookmarksList.length,
                  itemBuilder: (context, index) {
                    final data = bookmarksProvider.bookmarksList[index];
                    return MyBookmarkContent(
                      myBookmark: data,
                      mediaList: bookmarksProvider.bookmarksList,
                      index: index,
                    );
                  },
                ),
              )
            : SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    'No bookmarks added',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
      ],
    );
  }
}
