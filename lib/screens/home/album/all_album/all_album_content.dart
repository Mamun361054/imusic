import 'package:dhak_dhol/data/model/album_model.dart';
import 'package:dhak_dhol/screens/home/album/album_details/album_details.dart';
import 'package:flutter/material.dart';

class AllAlbumContent extends StatelessWidget {
  final Albums? albumList;
  const AllAlbumContent({Key? key, this.albumList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlbumDetailsScreen(albumList!),
              ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 53,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage("${albumList?.thumbnail}"),
                      radius: 50,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    albumList?.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  Text(
                    albumList?.artist ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 11.0),
                  ),
                  Text(
                    "${albumList?.mediaCount} Track",
                    style: const TextStyle(color: Colors.white, fontSize: 9.0),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
