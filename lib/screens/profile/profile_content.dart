import 'package:dhak_dhol/model/dummy_data.dart';
import 'package:dhak_dhol/screens/profile/total_earning/total_earning_screen.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';

class ProfileContent extends StatelessWidget {
  final Music? profile;
  const ProfileContent({Key? key, this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TotalEarningScreen(),
            ));
      },
      child: Card(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: AppColor.backgroundColor2,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                profile?.assetImage ?? '',
                fit: BoxFit.cover,
              ),
              Text(
                profile?.title ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
