import 'package:dhak_dhol/provider/album_provider.dart';
import 'package:dhak_dhol/screens/home/album/all_album/all_album_content.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../widgets/custom_appbar.dart';
import '../../../drawer/drawer.dart';

class AllAlbumScreen extends StatelessWidget {
  final bool? isAppBarVisible;
  const AllAlbumScreen({Key? key, this.isAppBarVisible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AlbumProvider(),
      child: Scaffold(
        backgroundColor: AppColor.deepBlue,
        appBar: isAppBarVisible == false
            ? AppBar(
                title: Text('Album'),
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
        body: const AllAlbumWidget(),
      ),
    );
  }
}

class AllAlbumWidget extends StatefulWidget {
  const AllAlbumWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AllAlbumWidget> createState() => _AllAlbumWidgetState();
}

class _AllAlbumWidgetState extends State<AllAlbumWidget> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<AlbumProvider>(context, listen: false).loadItems();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AlbumProvider>(context);
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
      child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                // height: MediaQuery.of(context).size.height * 0.5,
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  childAspectRatio: 0.65,
                  children: provider.mediaList
                      .map((e) => AllAlbumContent(
                            albumList: e,
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
