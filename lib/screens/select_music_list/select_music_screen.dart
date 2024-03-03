import 'package:dhak_dhol/model/dummy_data.dart';
import 'package:dhak_dhol/screens/select_music_list/select_music_content.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';

class SelectMusicScreen extends StatefulWidget {
  const SelectMusicScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectMusicScreen> createState() => _SelectMusicScreenState();
}

class _SelectMusicScreenState extends State<SelectMusicScreen> {
  int _value = 6;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.deepBlue,
        appBar: AppBar(
          title: const Text('Select Music'),
          backgroundColor: AppColor.deepBlue,
          actions: const [Icon(Icons.more_vert)],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 430,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: DummyData().selectMusic.length,
                itemBuilder: (context, index) {
                  return SelectMusicContent(
                    selectMusic: DummyData().selectMusic[index],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(children: [
              Expanded(
                  child: Slider(
                      value: _value.toDouble(),
                      min: 1.0,
                      max: 20.0,
                      activeColor: const Color(0xffFC455D),
                      inactiveColor: Colors.grey,
                      onChanged: (double newValue) {
                        setState(() {
                          _value = newValue.round();
                        });
                      },
                      semanticFormatterCallback: (double newValue) {
                        return '${newValue.round()} dollars';
                      })),
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    '03:59',
                    style: TextStyle(color: Colors.white.withOpacity(.4)),
                  ),
                  const Spacer(),
                  Text(
                    '5:00',
                    style: TextStyle(color: Colors.white.withOpacity(.4)),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset("assets/images/love_icon.png"),
                Image.asset('assets/images/equlizer.png'),
                Image.asset('assets/images/backword_play.png'),
                Image.asset('assets/images/music_paly_handaler.png'),
                Image.asset('assets/images/forward_play.png'),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectMusicScreen(),
                          ));
                    },
                    child: Image.asset('assets/images/mark_category_icon.png')),
                Image.asset('assets/images/replay_icon.png'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Image.asset('assets/images/music_bit.png')
          ],
        ));
  }
}
