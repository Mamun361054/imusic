import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/moods_model.dart';
import 'package:dhak_dhol/provider/mood_media_provier.dart';
import 'package:dhak_dhol/screens/category/song_category/song_category_content.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MoodMediaScreen extends StatelessWidget {
  const MoodMediaScreen({Key? key, this.moods}) : super(key: key);
  final Moods? moods;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MoodsMediaProvider(moods),
      child: Scaffold(
        backgroundColor: AppColor.deepBlue,
        body: SafeArea(
          child: Column(
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CachedNetworkImage(
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: "${moods?.thumbnail}",
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress)),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    Positioned(
                        left: 10,
                        top: 5,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ))),
                    Positioned(
                      bottom: -30,
                      left: 100,
                      right: 100,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF300040),
                              Color(0xFF300040),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [0.0, 1.5],
                          ),
                        ),
                        height: 55.0,
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                moods?.title ?? '',
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: VerticalDivider(color: Colors.white,),
                              ),
                              Text(
                                "${moods?.mediaCount} Track",
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Expanded(child: MoodsMediaListWidget()),
            ],
          ),
        ),
      ),
    );
  }
}

class MoodsMediaListWidget extends StatefulWidget {
  const MoodsMediaListWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MoodsMediaListWidget> createState() => _MoodsListWidgetState();
}

class _MoodsListWidgetState extends State<MoodsMediaListWidget> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<MoodsMediaProvider>(context, listen: false).loadItems();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MoodsMediaProvider>(context);
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
