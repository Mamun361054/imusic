import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/moods_model.dart';
import 'package:dhak_dhol/screens/home/moods/mood_details/mood_details_screen.dart';
import 'package:dhak_dhol/screens/home/moods/moods_media_screen.dart';
import 'package:flutter/material.dart';

class MoodsContent extends StatelessWidget {
  final Moods? moods;
  const MoodsContent({Key? key, this.moods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  MoodMediaScreen(moods: moods,),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, top: 8.0),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: CachedNetworkImage(
                  width: 120.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                  imageUrl: "${moods?.thumbnail}",
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10.0),bottomRight:Radius.circular(10.0)),
                    gradient: LinearGradient(
                        colors: [
                          Color(0xFF300040),
                          Color(0xFF300040),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.5],
                        tileMode: TileMode.clamp),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        moods?.title ?? '',
                        style: const TextStyle(
                            fontSize: 13.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
