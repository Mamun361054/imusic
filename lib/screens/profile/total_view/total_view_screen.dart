import 'package:dhak_dhol/model/dummy_data.dart';
import 'package:dhak_dhol/screens/profile/total_view/total_view_content.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';

class TotalViewScreen extends StatelessWidget {
  const TotalViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.deepBlue,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.deepBlue,
          title: const Text('Total view'),
        ),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: DummyData().totalView.length,
          itemBuilder: (context, index) {
            return TotalViewContent(
              totalView: DummyData().totalView[index],
            );
          },
        ));
  }
}
