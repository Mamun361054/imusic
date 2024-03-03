import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../data/model/artist_model.dart';
import '../home/artists/artists_details/artists_details_page.dart';

class SearchArtistsContent extends StatelessWidget {
  final List<Artists> artists;

  const SearchArtistsContent({Key? key, required this.artists})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return artists.isNotEmpty
        ? GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 170.0,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0),
            itemCount: artists.length,
            itemBuilder: (BuildContext ctx, index) {
              final artist = artists[index];
              return ArtistsDetailsPage(
                artist: artist,
              );
            })
        : Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset("assets/images/music_not_found_one.json",
                  height: 150.0, width: 150.0),
              Text(
                "No Artists Found",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ));
  }
}
