import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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
              height: 30,
            ),
            Center(
              child: Image.asset(
                'assets/images/forget_img.png',
                height: 168,
                width: 139,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              AppText.reset,
              style: GoogleFonts.manrope(
                  color: AppColor.secondary,
                  fontSize: 28,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 45,
            ),
            Center(
              child: Container(
                height: 422,
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
                        AppText.newPassword,
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
                          hintText: AppText.hintNewPassword,
                          hintStyle: GoogleFonts.manrope(
                              color: Colors.white.withOpacity(.2)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                      ),
                      child: Text(
                        AppText.typeConfirmPassword,
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
                          hintText: AppText.hintConfirmPassword,
                          hintStyle: GoogleFonts.manrope(
                              color: Colors.white.withOpacity(.2)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => const BottomNavBar(),
                          //     ));
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
                            child: Text(AppText.submit,
                                style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 16)),
                          ),
                        ),
                      ),
                    ),
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
