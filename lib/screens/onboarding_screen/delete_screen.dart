import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home/bottom_navigation_bar/bottom_navigation_bar.dart';

class DeleteScreen extends StatelessWidget {
  const DeleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100.0,
            ),
            Center(
              child: Image.asset(
                'assets/images/app_logo.png',
                scale: 2,
              ),
            ),
            Text('Music + Fun + Meetup',
                style: GoogleFonts.manrope(
                    fontWeight: FontWeight.bold,
                    color: AppColor.backgroundColor,
                    fontSize: 12)),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              width: MediaQuery.of(context).size.width,
              height: ScreenUtil.defaultSize.height,
              decoration: BoxDecoration(
                color: AppColor.signInPageBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 25.0,
                  ),
                  const Text(
                    "Your account deleted. Hope you will join again",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BottomNavigationScreen()),
                          (Route<dynamic> route) => false);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      decoration: BoxDecoration(
                          color: AppColor.buttonColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        'Back to home',
                        style: GoogleFonts.manrope(
                            color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 45.0,
                  ),
                ],
              ),
            ),

            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   child: Center(
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: AppColor.deepBlue,
            //         borderRadius: const BorderRadius.only(
            //           topLeft: Radius.circular(60),
            //           topRight: Radius.circular(60),
            //         ),
            //       ),
            //       height: 330,
            //       width: double.infinity,
            //       child: Column(
            //         children: [
            //           const SizedBox(
            //             height: 50,
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.symmetric(horizontal: 53.0),
            //             child: Text(
            //               AppText.onboardingText,
            //               textAlign: TextAlign.center,
            //               style: const TextStyle(
            //                   color: Colors.white, fontSize: 24, height: 1.2),
            //             ),
            //           ),
            //           const SizedBox(
            //             height: 30,
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: InkWell(
            //               onTap: () {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                       builder: (context) => const SignInScreen(),
            //                       // builder: (context) => provider.userEmail != null ?
            //                       //     const BottomNavBar() : const SignInScreen(),
            //                     ));
            //               },
            //               child: Container(
            //                 height: 60,
            //                 width: double.infinity,
            //                 decoration:  BoxDecoration(
            //                     borderRadius:
            //                         const BorderRadius.all(Radius.circular(10)),
            //                     gradient: LinearGradient(
            //                       begin: Alignment.topCenter,
            //                       end: Alignment.bottomCenter,
            //                       colors: <Color>[
            //                         AppColor.buttonColor,
            //                         AppColor.buttonColor
            //                       ],
            //                     )),
            //                 child: Center(
            //                   child: Text(AppText.getStarted,
            //                       style: GoogleFonts.manrope(
            //                           fontWeight: FontWeight.w600,
            //                           color: Colors.white,
            //                           fontSize: 20)),
            //                 ),
            //               ),
            //             ),
            //           ),
            //           const SizedBox(
            //             height: 20,
            //           ),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Text(
            //                 AppText.accountText,
            //                 style: GoogleFonts.manrope(
            //                     color: Colors.white, fontSize: 16),
            //               ),
            //               const SizedBox(
            //                 width: 3,
            //               ),
            //               TextButton(
            //                 onPressed: () {
            //                   Navigator.push(context, MaterialPageRoute(
            //                       builder: (BuildContext context) {
            //                     return const SignUpScreen();
            //                   }));
            //                 },
            //                 child: Text(
            //                   'SignUp',
            //                   style: GoogleFonts.manrope(
            //                       color: AppColor.secondary, fontSize: 16),
            //                 ),
            //               ),
            //             ],
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            //
          ],
        ),
      ),
    );
  }
}
