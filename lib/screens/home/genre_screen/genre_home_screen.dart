import 'package:dhak_dhol/provider/genre_provider.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/home_provider.dart';
import '../../../widgets/custom_appbar.dart';
import '../../drawer/drawer.dart';
import '../song_category.dart';

class GenreHomeScreen extends StatefulWidget {
  const GenreHomeScreen({Key? key}) : super(key: key);

  @override
  State<GenreHomeScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => GenreProvider('Genre'),
      child: Consumer<HomeProvider>(
        builder: (BuildContext context, provider, _) {
          return Scaffold(
            backgroundColor: AppColor.deepBlue,
            appBar: const PreferredSize(
                preferredSize: Size.fromHeight(55.0), child: CustomAppBar()),
            drawer: const AppDrawer(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: provider.homeModel?.genres?.length,
                      itemBuilder: (context, index) {
                        return SongCategory(
                          songCategory: provider.homeModel?.genres?[index],
                          isAdsVisible: index == 4,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
