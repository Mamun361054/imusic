import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';

class TotalEarningScreen extends StatelessWidget {
  const TotalEarningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor2,
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        title: const Text('Total Earning'),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.8),
                  blurRadius: 2,
                  offset: const Offset(1, 6),
                ),
              ],
              color: AppColor.deepBlue,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            // ignore: sort_child_properties_last
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Available balance',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const Text(
                    '\$58,69329',
                    style: TextStyle(color: Colors.red, fontSize: 40),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Select payment methode',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 16),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/visa.png',
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'assets/images/paypal.png',
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'assets/images/master card.png',
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            'Frequently asked questions',
            style: TextStyle(color: Colors.red[400], fontSize: 18),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  ' Their infancy. Various versions ?',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8), fontSize: 18),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  ' Various versions have evolved ?',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8), fontSize: 18),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  ' Praising pain was born ?',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8), fontSize: 18),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
