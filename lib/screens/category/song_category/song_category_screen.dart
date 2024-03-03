import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';

class SongCategoryScreen extends StatefulWidget {
  const SongCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SongCategoryScreen> createState() => _SongCategoryScreenState();
}

class _SongCategoryScreenState extends State<SongCategoryScreen> {
  int tag = 0;
  int val = 0;

  List<String> options = [
    'English',
    'Bangla',
    'Hindi',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.deepBlue,
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        title: const Text('English'),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(
          children: [
            ChipsChoice<int>.single(
              value: tag,
              onChanged: (val) => setState(() => tag = val),
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
              choiceStyle: C2ChoiceStyle(
                  color: const Color(0xffB1B1B1),
                  borderColor: AppColor.backgroundColor2,
                  backgroundColor: AppColor.backgroundColor2,
                  showCheckmark: false),
              choiceActiveStyle: C2ChoiceStyle(
                showCheckmark: false,
                color: AppColor.backgroundColor2,
              ),
            )
          ],
        ),
        // Expanded(
        //   child: ListView.builder(
        //     scrollDirection: Axis.vertical,
        //     itemCount: DummyData().selectMusic.length,
        //     itemBuilder: (context, index) {
        //       return SongCategoryContent(
        //         selectMusic: DummyData().selectMusic[index],
        //       );
        //     },
        //   ),
        // ),
      ]),
    );
  }
}
