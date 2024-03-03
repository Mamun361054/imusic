import 'package:dhak_dhol/data/model/genres_model.dart';
import 'package:dhak_dhol/provider/ads_provider.dart';
import 'package:dhak_dhol/screens/home/genre_screen/gener_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/ads_content.dart';

class SongCategory extends StatelessWidget {
  final Genres? songCategory;
  final bool isAdsVisible;
  const SongCategory({Key? key, this.songCategory,this.isAdsVisible = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return  GenreScreen(genreTitle: songCategory,);
            }));
          },
          child: Card(
            elevation: 4,
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                gradient: LinearGradient(
                    colors: [
                      Color(0xFFFB7159),
                      Color(0xFF7001B6),
                    ],
                    begin: FractionalOffset(3.0, 2.0),
                    end: FractionalOffset(0.0, 4.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Image.asset('assets/images/music_handaler.png'),
                  ),
                  Text(
                    songCategory?.name ?? "",
                    style: const TextStyle(color: Colors.white, fontSize: 15.0),
                  )
                ],
              ),
            ),
          ),
        ),
        /// ================= ADS ======================
        Visibility(
          visible: isAdsVisible && context.read<AdsProvider>().ads.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: AdsContent(press: () {  },),
          ),
        ),
      ],
    );
  }
}
