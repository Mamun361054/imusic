import 'package:dhak_dhol/data/model/playlist_model.dart';
import 'package:dhak_dhol/provider/playlist_provider.dart';
import 'package:dhak_dhol/screens/home/playlists/playlists_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_const.dart';

class ProfilePlaylistsScreen extends StatefulWidget {

  const ProfilePlaylistsScreen({Key? key}) : super(key: key);

  @override
  State<ProfilePlaylistsScreen> createState() => _ProfilePlaylistsScreenState();
}

class _ProfilePlaylistsScreenState extends State<ProfilePlaylistsScreen> {
  @override
  Widget build(BuildContext context) {
    PlaylistsProvider provider = Provider.of<PlaylistsProvider>(context);
    provider.getPlaylists();
    List<Playlists> items = provider.playlistsList;
    return Column(
      children: [
        Row(
          children: [
             Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                'Playlists',
                style: TextStyle(
                    color: AppColor.titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/headphone_handaler.png'),
            ),
          ],
        ),
        items.isNotEmpty
            ? SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return PlaylistsContent(
                      playlists: items[index],
                      paddingLeft: 0.0,
                    );
                  },
                ),
              )
            : SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    'No playlist added',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
      ],
    );
  }
}
