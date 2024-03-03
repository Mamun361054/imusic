import 'package:dhak_dhol/screens/auth/reset_password/reset_password.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.backgroundColor,
      ),
      backgroundColor: AppColor.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Image.asset(
                'assets/images/forget_img.png',
                height: 168,
                width: 139,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              AppText.verification,
              style: GoogleFonts.manrope(
                  color: AppColor.secondary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: Text(
                AppText.verificationContent,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Center(
              child: Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.deepBlue,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 28,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                      ),
                      child: Text(
                        AppText.codeType,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.manrope(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 40, 0, 0),
                            filled: true,
                            fillColor: AppColor.fromFillColor,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: AppText.hintCode,
                            hintStyle: GoogleFonts.manrope(
                                color: Colors.white.withOpacity(.2))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResetPassword(),
                              ));
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.topRight,
                                colors: <Color>[
                                  Color(0xffFB7B58),
                                  Color(0xffFC455D),
                                ],
                              )),
                          child: Center(
                            child: Text(AppText.verifyCode,
                                style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 16)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        AppText.resend,
                        style: GoogleFonts.manrope(
                            color: Colors.white, fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
