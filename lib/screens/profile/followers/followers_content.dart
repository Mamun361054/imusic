import 'package:dhak_dhol/model/dummy_data.dart';
import 'package:flutter/material.dart';

class FollowersContent extends StatelessWidget {
  final Music? follower;
  const FollowersContent({Key? key, this.follower}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.8),
                radius: 33,
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    follower?.assetImage ?? "",
                  ),
                  radius: 31,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                follower?.author ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              )
            ],
          )
        ],
      ),
    );
  }
}
