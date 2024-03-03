import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/artist_model.dart';
import 'package:flutter/material.dart';

import 'artists_song_details/artists_song_details_Screen.dart';

class ArtistsPage extends StatelessWidget {
  final Artists? artists;
  final double paddingLeft;
  final double paddingRight;
  const ArtistsPage({Key? key, this.artists,this.paddingLeft = 16,this.paddingRight = 0.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArtistsSongDetailsScreen(
                artists: artists,
              ),
            ));
      },
      child: Padding(
        padding: EdgeInsets.only(left: paddingLeft,right: paddingRight, top: 8),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Stack(
            children: [
              CachedNetworkImage(
                width: 120.0,
                height: 100.0,
                fit: BoxFit.cover,
                imageUrl: "${artists?.thumbnail}",
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  height: 45,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.black54,
                          Colors.black87,
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
                        artists?.title ?? '',
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w800),maxLines: 1,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${artists?.mediaCount} Track',
                        style: const TextStyle(
                          fontSize: 9.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
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
