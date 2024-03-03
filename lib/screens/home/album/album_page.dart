import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/album_model.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/screens/home/album/album_details/album_details.dart';
import 'package:flutter/material.dart';

class AlbumPage extends StatelessWidget {
  final Albums? albumList;
  final Media? selectMusic;
  const AlbumPage({Key? key, this.albumList, this.selectMusic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlbumDetailsScreen(albumList!),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: CachedNetworkImage(
                width: 120.0,
                height: 100.0,
                fit: BoxFit.cover,
                imageUrl: "${albumList?.thumbnail}",
                errorWidget: (context, url, error) =>
                const Icon(Icons.error),
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
              albumList?.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child:
                  Image.asset('assets/images/music_handaler.png'),
                ),
                Text(
                  '${albumList?.mediaCount} Tracks',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            )
          ],
        )
      ),
    );
  }
}
