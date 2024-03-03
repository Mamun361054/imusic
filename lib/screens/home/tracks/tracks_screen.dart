import 'package:dhak_dhol/provider/home_provider.dart';
import 'package:dhak_dhol/screens/home/tracks/tracks_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tracks/track_list_view.dart';

class TracksScreen extends StatelessWidget {
  const TracksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<HomeProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text(
                  'Tracks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/headphone_handaler.png'),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MediaListView(
                            'Tracks',
                            'New Audios from all categories'),
                      ));
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text(
                    'More',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Image.asset('assets/images/forward.png'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.homeModel?.latestAudios?.length,
            padding: const EdgeInsets.only(left: 16.0,top: 8.0),
            itemBuilder: (context, index) {
              final tracks = provider.homeModel?.latestAudios?[index];
              return TracksContent(
                tracks: tracks,
                mediaList: provider.homeModel?.latestAudios,
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }
}
