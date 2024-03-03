import 'package:dhak_dhol/provider/sign_in_provider.dart';
import 'package:dhak_dhol/screens/auth/forget_password/forget_password_screen.dart';
import 'package:dhak_dhol/screens/auth/sign_up.dart/sign_up_screen.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {

  static const routeName = "/SignInScreen";

  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SignInProvider(),
      child: Consumer<SignInProvider>(
        builder: (BuildContext ctx, provider, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100.0,
                  ),
                  Center(
                    child: Image.asset('assets/images/app_logo.png',scale: 2,),
                  ),
                  Text('Music + Fun + Meetup',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          color: AppColor.backgroundColor,
                          fontSize: 12)),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Container(
                      height: ScreenUtil.defaultSize.height,
                      decoration: BoxDecoration(
                        color: AppColor.signInPageBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 25.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  'Sign in',
                                  style: GoogleFonts.manrope(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                              ),
                              child: Text(
                                AppText.typeEmail,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.manrope(color: AppColor.grey),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding:const EdgeInsets.only(left: 16.0, right: 16),
                              child: TextFormField(
                                controller: provider.nameController,
                                style: const TextStyle(color: Colors.white),
                                cursorColor: AppColor.signInPageBackgroundColor,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(20, 40, 0, 0),
                                    filled: true,
                                    fillColor: AppColor.inputBackgroundColor.withOpacity(0.7),
                                    enabledBorder : OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),borderSide: const BorderSide(color: Colors.transparent)),
                                    disabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),borderSide: const BorderSide(color: Colors.transparent)),
                                    focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),borderSide: const BorderSide(color: Colors.transparent)),
                                    hintText: AppText.typeEmail,
                                    hintStyle: GoogleFonts.manrope(
                                        color: Colors.white.withOpacity(.2))),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Field can't be Empty";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                              ),
                              child: Text(
                                AppText.typePassword,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.manrope(color: AppColor.grey),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: TextFormField(
                                controller: provider.passController,
                                style: const TextStyle(color: Colors.white),
                                obscureText: _isObscure,
                                cursorColor: AppColor.signInPageBackgroundColor,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(20, 40, 0, 0),
                                    filled: true,
                                    fillColor: AppColor.inputBackgroundColor.withOpacity(0.7),
                                    enabledBorder : OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),borderSide: const BorderSide(color: Colors.transparent)),
                                    disabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),borderSide: const BorderSide(color: Colors.transparent)),
                                    focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10.0),borderSide: const BorderSide(color: Colors.transparent)),
                                    hintText: AppText.hintPassword,
                                    hintStyle: GoogleFonts.manrope(
                                        color: Colors.white.withOpacity(.2)),
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          _isObscure
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.white.withOpacity(.2),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        })),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Field can't be Empty";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgetPasswordScreen(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text('Forget Your Password',
                                        style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.grey,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 8.0),
                              child: InkWell(
                                onTap: () {
                                  !formKey.currentState!.validate()
                                      ? debugPrint('error')
                                      : provider.doSignIn(context);
                                },
                                child: Container(
                                  height: 45.0,
                                  width: ScreenUtil.defaultSize.width/2.5,
                                  decoration: BoxDecoration(
                                      borderRadius:const BorderRadius.all(Radius.circular(24.0)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.topRight,
                                        colors: <Color>[
                                          AppColor.buttonColor,
                                          AppColor.buttonColor
                                        ],
                                      )),
                                  child: Center(
                                    child: provider.isLoading ?  CircularProgressIndicator(color: AppColor.signInPageBackgroundColor,strokeWidth: 2,) : Text(AppText.signin,
                                        style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.deepBlue,
                                            fontSize: 16)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    AppText.accountText,
                                    style: GoogleFonts.manrope(color: Colors.grey, fontSize: 15.0),
                                  ),
                                  const SizedBox(
                                    width: 4.0,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpScreen(),
                                          ));
                                    },
                                    child: Text(
                                      'SignUp',
                                      style: GoogleFonts.manrope(
                                          color: AppColor.secondary,
                                          fontSize: 16),
                                    ),
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
