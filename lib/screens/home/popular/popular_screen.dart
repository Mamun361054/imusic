import 'package:dhak_dhol/provider/home_provider.dart';
import 'package:dhak_dhol/screens/home/popular/popular_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularScreen extends StatelessWidget {
  const PopularScreen({Key? key}) : super(key: key);

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
                  'Popular',
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
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 160.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemExtent: 130.0,
            itemCount: provider.homeModel?.trendingAudios?.length ?? 0,
            padding: const EdgeInsets.only(left: 16.0),
            itemBuilder: (context, index) {
              final popular = provider.homeModel?.trendingAudios?[index];
              return PopularContent(
                popular: popular,
                mediaList: provider.homeModel?.trendingAudios,
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }
}
