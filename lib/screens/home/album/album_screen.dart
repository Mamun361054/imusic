import 'package:dhak_dhol/provider/home_provider.dart';
import 'package:dhak_dhol/screens/home/album/album_page.dart';
import 'package:dhak_dhol/screens/home/album/all_album/all_album_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({Key? key}) : super(key: key);

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
                  'Album',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
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
                        builder: (context) => const AllAlbumScreen(isAppBarVisible: false),
                      ));
                },
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text(
                        'More',
                        style: TextStyle(
                            color: Color(0xffE9EDEC),
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Image.asset('assets/images/forward.png'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.homeModel?.albums?.length ?? 0,
            padding: const EdgeInsets.only(left: 16.0),
            itemBuilder: (context, index) {
              final data = provider.homeModel?.albums?[index];
              return AlbumPage(
                albumList: data,
              );
            },
          ),
        )
      ],
    );
  }
}
