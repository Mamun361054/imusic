import 'package:dhak_dhol/provider/artist_details_provider.dart';
import 'package:dhak_dhol/screens/category/song_category/song_category_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ArtistsSongDetails extends StatefulWidget {
  const ArtistsSongDetails({Key? key}) : super(key: key);

  @override
  State<ArtistsSongDetails> createState() => _ArtistsSongDetailsState();
}

class _ArtistsSongDetailsState extends State<ArtistsSongDetails> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<ArtistDetailsProvider>(context, listen: false).loadItems();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArtistDetailsProvider>(context);
    return SmartRefresher(
      controller: provider.refreshController,
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(),
      onRefresh: provider.loadItems,
      onLoading: provider.loadMoreItems,
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget? body;
          if (mode == LoadStatus.idle) {
            body = const Text('Pull up load');
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = const Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = const Text("release to load more");
          } else {
            body = const Text("No more Data");
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: provider.mediaList.length,
        itemBuilder: (context, index) {
          final data = provider.mediaList[index];
          return SongCategoryContent(
            selectMusic: data,
            mediaList: provider.mediaList,
            index: index,
          );
        },
      ),
    );
  }
}
