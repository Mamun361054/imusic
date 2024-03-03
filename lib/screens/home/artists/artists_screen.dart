import 'package:dhak_dhol/provider/home_provider.dart';
import 'package:dhak_dhol/screens/home/artists/artists_details/artists_details_screen.dart';
import 'package:dhak_dhol/screens/home/artists/artists_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistsScreen extends StatelessWidget {
  const ArtistsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    return Column(
      children: [
        const SizedBox(
          height: 8.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text('Artists',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    )),
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
                        builder: (context) =>
                            const ArtistsDetailsScreen(isAppBarVisible: false),
                      ));
                },
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text(
                        'More',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
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
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 150.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.homeModel?.artists?.length ?? 0,
            padding: const EdgeInsets.only(left: 16.0),
            itemBuilder: (context, index) {
              return ArtistsPage(
                artists: provider.homeModel?.artists?[index],
                paddingRight: 8.0,
                paddingLeft: 0.0,
              );
            },
          ),
        ),
      ],
    );
  }
}
