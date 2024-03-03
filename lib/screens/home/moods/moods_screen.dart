import 'package:dhak_dhol/provider/home_provider.dart';
import 'package:dhak_dhol/screens/home/moods/mood_details/mood_details_screen.dart';
import 'package:dhak_dhol/screens/home/moods/moods_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoodsScreen extends StatelessWidget {
  const MoodsScreen({Key? key}) : super(key: key);

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
                  'Moods',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
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
                        builder: (context) => const MoodDetailsScreen(),
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
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 120.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.homeModel?.moods?.length ?? 0,
            padding: const EdgeInsets.only(left: 16.0),
            itemBuilder: (context, index) {
              final mood = provider.homeModel?.moods?[index];
              return MoodsContent(
                moods: mood,
              );
            },
          ),
        ),
      ],
    );
  }
}
