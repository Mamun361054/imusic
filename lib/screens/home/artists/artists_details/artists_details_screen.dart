import 'package:dhak_dhol/provider/artists_provider.dart';
import 'package:dhak_dhol/screens/home/artists/artists_details/artists_details_page.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../widgets/custom_appbar.dart';
import '../../../drawer/drawer.dart';

class ArtistsDetailsScreen extends StatelessWidget {
  final bool? isAppBarVisible;

  const ArtistsDetailsScreen({Key? key, this.isAppBarVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => ArtistsProvider(),
        child: Scaffold(
          backgroundColor: AppColor.deepBlue,
          appBar: isAppBarVisible == false
              ? AppBar(
                  title: Text('Artists'),
                  backgroundColor: AppColor.deepBlue,
                  automaticallyImplyLeading: false,
                  leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                )
              : PreferredSize(
                  preferredSize: Size.fromHeight(55.0), child: CustomAppBar()),
          drawer: const AppDrawer(),
          body: const ArtistScreen(),
        ));
  }
}

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<ArtistsProvider>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArtistsProvider>(context);
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(),
      controller: provider.refreshController,
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
      child: SingleChildScrollView(
        child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 170.0,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0),
            itemCount: provider.mediaList.length,
            itemBuilder: (BuildContext ctx, index) {
              final artists = provider.mediaList[index];
              return ArtistsDetailsPage(
                artist: artists,
              );
            })
      ),
    );
  }
}
