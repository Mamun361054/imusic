import 'package:dhak_dhol/data/model/album_model.dart';
import 'package:dhak_dhol/provider/album_details_provider.dart';
import 'package:dhak_dhol/screens/category/song_category/song_category_content.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AlbumDetailsScreen extends StatelessWidget {
  const AlbumDetailsScreen(this.albums, {Key? key}) : super(key: key);
  final Albums? albums;

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
        create: (BuildContext context) => AlbumDetailsProvider(albums),
        child: Scaffold(
          backgroundColor: AppColor.signInPageBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: Image.network(
                        albums?.thumbnail ?? '',
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                        left: 8,
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
                      left: -5.0,
                      right: -5.0,
                      bottom: -20.0,
                      child: Container(
                        height: 55.0,
                        decoration:  BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24.0),topRight: Radius.circular(24.0)),
                          boxShadow: [
                            BoxShadow(
                                color: AppColor.signInPageBackgroundColor,
                                blurRadius: 30.0,
                                spreadRadius: 16.0,
                                offset: const Offset(0.0, 0.0)
                            )
                          ],
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 120,
                      left: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.purple,
                        radius: 53,
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/images/mansinging.png",
                          ),
                          radius: 50,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),

                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        '${albums?.name.toString()}',
                        style: TextStyle(
                            color: AppColor.secondary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/music_handaler.png',
                                color: AppColor.textColor,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Tracks ${albums?.mediaCount}',
                                style: TextStyle(
                                    color: AppColor.textColor, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Duration : ${albums?.albumDuration.toString()}",
                            style: TextStyle(
                                color: AppColor.textColor, fontSize: 12),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const Expanded(
                  child: AlbumDetailsContent(),
                ),
              ],
            ),
          ),
        ));
  }
}

class AlbumDetailsContent extends StatefulWidget {
  const AlbumDetailsContent({
    Key? key,
  }) : super(key: key);

  @override
  State<AlbumDetailsContent> createState() => _AlbumDetailsContentState();
}

class _AlbumDetailsContentState extends State<AlbumDetailsContent> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<AlbumDetailsProvider>(context, listen: false).loadItems();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AlbumDetailsProvider>(context);
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
