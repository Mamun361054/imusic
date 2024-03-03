import 'package:dhak_dhol/model/dummy_data.dart';
import 'package:flutter/material.dart';

class SelectMusicContent extends StatelessWidget {
  final Music? selectMusic;
  const SelectMusicContent({Key? key, this.selectMusic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                selectMusic?.assetImage ?? '',
                fit: BoxFit.cover,
                width: 80,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Image.asset('assets/images/music_handaler.png'),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          selectMusic?.title ?? "",
                          style: TextStyle(color: Colors.white.withOpacity(.8)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          selectMusic?.author ?? "",
                          style: TextStyle(color: Colors.white.withOpacity(.8)),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(
                          selectMusic?.time ?? "",
                          style: TextStyle(color: Colors.white.withOpacity(.8)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.more_vert,
                color: Colors.white,
              )
            ],
          ),
        ),
      ],
    );
  }
}
