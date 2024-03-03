import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/moods_model.dart';
import 'package:dhak_dhol/provider/moods_provider.dart';
import 'package:dhak_dhol/screens/home/moods/moods_content.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../music_player_page/audio_player_new_page.dart';

class MoodDetailsScreen extends StatelessWidget {
  const MoodDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MoodsProvider(),
      child: Scaffold(
        backgroundColor: AppColor.deepBlue,
        appBar: AppBar(
          title: const Text("All Moods"),
          backgroundColor: AppColor.deepBlue,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              children: const [
                Expanded(child: MoodsListWidget()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MoodsListWidget extends StatefulWidget {
  const MoodsListWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MoodsListWidget> createState() => _MoodsListWidgetState();
}

class _MoodsListWidgetState extends State<MoodsListWidget> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<MoodsProvider>(context, listen: false).loadItems();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MoodsProvider>(context);
    return SmartRefresher(
      controller: provider.refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: provider.loadItems,
      onLoading: provider.loadMoreItems,
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
      child: GridView.count(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 8.0),
        crossAxisCount: 3,
        childAspectRatio: 1,
        children:
            provider.moodsList.map((e) => MoodsContent(moods: e)).toList(),
      ),
    );
  }
}

class MoodListContent extends StatelessWidget {
  final Moods? selectMusic;
  const MoodListContent({Key? key, this.selectMusic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(AudioPlayerNewPage.routeName);
        },
        child: Column(
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  width: 70,
                  height: 80,
                  fit: BoxFit.cover,
                  imageUrl: "${selectMusic?.thumbnail}",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Image.asset('assets/images/music_handaler.png'),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              selectMusic?.title ?? "",
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.8)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                "${selectMusic?.mediaCount} Track",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(.8)),
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Text(
                              '00:03:59',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.8)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
