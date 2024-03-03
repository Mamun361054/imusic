import 'package:dhak_dhol/model/dummy_data.dart';
import 'package:flutter/material.dart';

class TotalViewContent extends StatelessWidget {
  final Music? totalView;
  const TotalViewContent({Key? key, this.totalView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                totalView?.assetImage ?? '',
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 0,
                        ),
                        Image.asset('assets/images/music_handaler.png'),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          totalView?.title ?? "",
                          style: TextStyle(
                              color: Colors.white.withOpacity(.8),
                              fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        Image.asset('assets/images/thumbs_up.png'),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          totalView?.text ?? "",
                          style: TextStyle(
                              color: Colors.white.withOpacity(.8),
                              fontSize: 14),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Image.asset('assets/images/comment.png'),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          totalView?.text1 ?? "",
                          style: TextStyle(
                              color: Colors.white.withOpacity(.8),
                              fontSize: 14),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Image.asset('assets/images/eye_visible_icon.png'),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          totalView?.text2 ?? "",
                          style: TextStyle(
                              color: Colors.white.withOpacity(.8),
                              fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 50,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
