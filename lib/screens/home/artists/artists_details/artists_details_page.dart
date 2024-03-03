import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/artist_model.dart';
import 'package:dhak_dhol/screens/home/artists/artists_song_details/artists_song_details_Screen.dart';
import 'package:flutter/material.dart';

class ArtistsDetailsPage extends StatelessWidget {
  final Artists? artist;
  const ArtistsDetailsPage({Key? key, this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  ArtistsSongDetailsScreen(artists: artist,),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Stack(
          children: [
            CachedNetworkImage(
              width: 200,
              fit: BoxFit.cover,
              imageUrl: "${artist?.thumbnail}",
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Positioned(
              left: -16.0,
              right: -16.0,
              bottom: -30.0,
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(80),
                      topLeft: Radius.circular(80)),
                  gradient: LinearGradient(
                      colors: [
                        Color(0xFF7001B6),
                        Color(0xFFFB7159),
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
                      artist?.title ?? '',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child:
                              Image.asset('assets/images/music_handaler.png'),
                        ),
                        Text(
                          "${artist?.mediaCount} Track",
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
