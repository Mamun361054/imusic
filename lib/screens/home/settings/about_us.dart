import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.deepBlue,
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: const [
          Text(
            'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn\'t anything embarrassing hidden in software like Aldus PageMake',
            style: TextStyle(color: Colors.white, fontSize: 16),
          )
        ]),
      ),
    );
  }
}
