import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/artist_model.dart';
import 'package:dhak_dhol/provider/artist_details_provider.dart';
import 'package:dhak_dhol/screens/home/artists/artists_song_details/artists_song_details_content.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistsSongDetailsScreen extends StatefulWidget {
  const ArtistsSongDetailsScreen({Key? key, required this.artists})
      : super(key: key);
  final Artists? artists;

  @override
  State<ArtistsSongDetailsScreen> createState() =>
      _ArtistsSongDetailsScreenState();
}

class _ArtistsSongDetailsScreenState extends State<ArtistsSongDetailsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ArtistDetailsProvider(widget.artists),
      child: Scaffold(
        backgroundColor: AppColor.signInPageBackgroundColor,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        imageUrl: "${widget.artists?.thumbnail}",
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress)),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      left: -16.0,
                      right: -16.0,
                      bottom: -30.0,
                      child: Container(
                        height: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24.0),
                              topRight: Radius.circular(24.0)),
                          boxShadow: [
                            BoxShadow(
                                color: AppColor.signInPageBackgroundColor,
                                blurRadius: 30.0,
                                spreadRadius: 16.0,
                                offset: const Offset(0.0, 0.0))
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        left: 10,
                        top: 10,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ))),
                    Positioned(
                        bottom: 16.0,
                        left: 24.0,
                        right: 0,
                        child: Text(
                          '${widget.artists?.title}',
                          style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
                TabBar(
                    indicator: BoxDecoration(
                      color: AppColor.secondary,
                    ),
                    tabs: const [
                      Tab(
                        text: 'Track',
                      ),
                      Tab(
                        text: 'Album',
                      ),
                    ],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab),
                Divider(
                  color: AppColor.secondary,
                  height: 0.0,
                  thickness: 2.0,
                ),
                SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.0),
                          child: ArtistsSongDetails(),
                        ),
                        // AllAlbumWidget(),
                        Text("")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
