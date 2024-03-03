import 'package:dhak_dhol/screens/home/artists/artists_details/artists_details_screen.dart';
import 'package:dhak_dhol/screens/home/artists/artists_page.dart';
import 'package:flutter/material.dart';

import '../../../data/model/artist_model.dart';
import '../../../utils/app_const.dart';

class ProfileArtistsScreen extends StatelessWidget {
  final List<Artists> artists;

  const ProfileArtistsScreen({Key? key, required this.artists})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20,),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                "Liked Artists",
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
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArtistsDetailsScreen(isAppBarVisible: true,),
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
        SizedBox(
          height: 150,
          child: artists.isNotEmpty ?  ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: artists.length,
            itemBuilder: (context, index) {
              return ArtistsPage(
                artists: artists[index],
                paddingLeft: 0.0,
                paddingRight: 8.0,
              );
            },
          ) : Column(
            children: const [
              SizedBox(height: 50,),
              Text("Liked Artists Not Found",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),)
            ],
          ),
        ),
      ],
    );
  }
}
