import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../provider/tracks_provider.dart';
import '../../utils/TextStyles.dart';
import '../../utils/app_const.dart';
import '../../widgets/mediaItemTile.dart';

class MediaListView extends StatelessWidget {
  const MediaListView(this.header, this.subHeader, {super.key});

  final String header;
  final String subHeader;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TracksProvider(),
      child: Scaffold(
        backgroundColor: AppColor.deepBlue,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.backgroundColor,
          title: Text(header,
              textAlign: TextAlign.center,
              style: TextStyles.medium(context).copyWith(color: Colors.white)),
        ),
        body: const MediaListPage(),
      ),
    );
  }
}

class MediaListPage extends StatefulWidget {
  const MediaListPage({Key? key}) : super(key: key);

  @override
  State<MediaListPage> createState() => _MediaListPageState();
}

class _MediaListPageState extends State<MediaListPage> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<TracksProvider>(context, listen: false).loadItems();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tracksProvider = Provider.of<TracksProvider>(context);

    return SmartRefresher(
      controller: tracksProvider.refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: tracksProvider.loadItems,
      onLoading: tracksProvider.loadMoreItems,
      header: const WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
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
        itemCount: tracksProvider.mediaList.length + 1,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(3),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Container();
          } else {
            int tmpIndex = index - 1;
            return ItemTile(
              mediaList: tracksProvider.mediaList,
              index: tmpIndex,
              media: tracksProvider.mediaList[tmpIndex],
            );
          }
        },
      ),
    );
  }
}
