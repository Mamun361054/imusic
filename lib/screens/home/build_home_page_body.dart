import 'package:dhak_dhol/screens/home/playlists/playlists.screen.dart';
import 'package:dhak_dhol/screens/home/popular/popular_screen.dart';
import 'package:dhak_dhol/screens/home/tracks/tracks_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../provider/home_provider.dart';
import '../../utils/app_const.dart';
import '../../widgets/ads_content.dart';
import 'album/album_screen.dart';
import 'artists/artists_screen.dart';
import 'home_page_slider.dart';
import 'moods/moods_screen.dart';
import 'my_bookmark/my_bookmark_screen.dart';

class BuildHomePageBody extends StatelessWidget {

  const BuildHomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<HomeProvider>(context);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.deepBlue,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            provider.homeModel?.sliderMedias != null
                ? SizedBox(
              height: 170.0,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.homeModel?.sliderMedias?.length ?? 0,
                padding: const EdgeInsets.only(left: 16.0,top: 16.0),
                itemBuilder: (context, index) {

                  final data = provider.homeModel?.sliderMedias?[index];

                  return HomePageSlider(
                    media: data,
                    mediaList:
                    provider.homeModel?.sliderMedias,
                    index: index,
                  );
                },
              ),
            ) : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: List.generate(
                    6, (index) => Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 150.0,
                          width: 150.0,
                          child: Shimmer.fromColors(
                            baseColor: const Color(0xFF102345),
                            highlightColor:
                            const Color(0xFF102345)
                                .withOpacity(0.3),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 2),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(5)),
                                color: const Color(0xFFE8E8E8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// ================= Album Screen =========
            provider.homeModel?.sliderMedias != null ?
            const AlbumScreen() : Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: 120.0,
                        height: 70.0,
                        child: Shimmer.fromColors(
                          baseColor: const Color(0xFF102345),
                          highlightColor:
                          const Color(0xFF102345)
                              .withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 2),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              color: const Color(0xFFE8E8E8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 120.0,
                      height: 70.0,
                      child: Shimmer.fromColors(
                        baseColor: const Color(0xFF102345),
                        highlightColor:
                        const Color(0xFF102345)
                            .withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 2),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(5)),
                            color: const Color(0xFFE8E8E8),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: List.generate(
                        6,
                            (index) => Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 170.0,
                              height: 230.0,
                              child: Shimmer.fromColors(
                                baseColor: const Color(0xFF102345),
                                highlightColor:
                                const Color(0xFF102345)
                                    .withOpacity(0.3),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 2),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(5)),
                                    color: const Color(0xFFE8E8E8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            /// ================= ADS ======================
            // AdsContent(press: () {  },),
            /// ================= Artist Screen ===============
            provider.homeModel?.sliderMedias != null ? const ArtistsScreen() : Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 120.0,
                      height: 70.0,
                      child: Shimmer.fromColors(
                        baseColor: const Color(0xFF102345),
                        highlightColor:
                        const Color(0xFF102345)
                            .withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 2),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(5)),
                            color: const Color(0xFFE8E8E8),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: 120.0,
                        height: 70.0,
                        child: Shimmer.fromColors(
                          baseColor: const Color(0xFF102345),
                          highlightColor:
                          const Color(0xFF102345)
                              .withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 2),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(5)),
                              color: const Color(0xFFE8E8E8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: List.generate(
                        6, (index) => Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 170.0,
                              height: 230.0,
                              child: Shimmer.fromColors(
                                baseColor: const Color(0xFF102345),
                                highlightColor:
                                const Color(0xFF102345)
                                    .withOpacity(0.3),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 2),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(5)),
                                    color: const Color(0xFFE8E8E8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            /// ================= Moods Screen ===============
            const MoodsScreen(),
            const SizedBox(
              height: 16.0,
            ),

            /// ================= Popular Screen ===============
            const PopularScreen(),

            const SizedBox(
              height: 16.0,
            ),
            ///============= TracksScreen ======================
            const TracksScreen(),
            const SizedBox(
              height: 16.0,
            ),
            ///============= PlaylistsScreen ======================
            const PlaylistsScreen(),
            const SizedBox(
              height: 16.0,
            ),
            ///============= MyBookmarkScreen ======================
            const MyBookmarkScreen(),
          ],
        ),
      ),
    );
  }
}
