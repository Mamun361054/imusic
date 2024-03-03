import 'package:dhak_dhol/provider/registration_provider.dart';
import 'package:dhak_dhol/screens/auth/sign_in/sign_in_screen.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isObscure = true;
  final formKey = GlobalKey<FormState>();

  // bool _validate = false;
  // bool _validate1 = false;
  // bool _validate2 = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RegistrationProvider(),
      child: Consumer<RegistrationProvider>(
          builder: (BuildContext ctx, provider, _) {
        return Scaffold(
          backgroundColor: AppColor.signInPageBackgroundColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 35.0,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    'assets/images/icon_white.png',
                    scale: 2.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Sign up',
                      style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Center(
                  child: SizedBox(
                    height: 540,
                    width: double.infinity,
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 28,
                            ),

                            ///Write your from////
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                              ),
                              child: Text(
                                AppText.typeName,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.manrope(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: TextFormField(
                                controller: provider.nameController,
                                style: const TextStyle(color: Colors.white),
                                cursorColor: AppColor.signInPageBackgroundColor,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(20, 38, 0, 0),
                                    filled: true,
                                    fillColor: AppColor.inputBackgroundColor
                                        .withOpacity(0.7),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent)),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent)),
                                    hintText: AppText.hintName,
                                    hintStyle:
                                        GoogleFonts.manrope(color: Colors.white.withOpacity(.2))),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Field can't be Empty";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            /////Email from//////
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                              ),
                              child: Text(
                                AppText.emailType,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.manrope(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: TextFormField(
                                controller: provider.emailController,
                                style: const TextStyle(color: Colors.white),
                                cursorColor: AppColor.signInPageBackgroundColor,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(20, 40, 0, 0),
                                    filled: true,
                                    fillColor: AppColor.inputBackgroundColor
                                        .withOpacity(0.7),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent)),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent)),
                                    hintText: AppText.hintEmail,
                                    hintStyle:
                                        GoogleFonts.manrope(color: Colors.white.withOpacity(.2))),
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

                            ///password from////
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                              ),
                              child: Text(
                                AppText.typePassword,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.manrope(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: TextFormField(
                                controller: provider.passwordController,
                                obscureText: _isObscure,
                                style: const TextStyle(color: Colors.grey),
                                cursorColor: AppColor.signInPageBackgroundColor,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(20.0),
                                    filled: true,
                                    fillColor: AppColor.inputBackgroundColor
                                        .withOpacity(0.7),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent)),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent)),
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
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: InkWell(
                                onTap: () {
                                  !formKey.currentState!.validate()
                                      ? debugPrint('error')
                                      : provider.registration(context);
                                },
                                child: Container(
                                  height: 45.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(24.0)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.topRight,
                                        colors: <Color>[
                                          AppColor.buttonColor,
                                          AppColor.buttonColor
                                        ],
                                      )),
                                  child: Center(
                                    child: provider.isLoading
                                        ? CircularProgressIndicator(
                                            color: AppColor
                                                .signInPageBackgroundColor,
                                            strokeWidth: 2,
                                          )
                                        : Text(AppText.signUp,
                                            style: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w600,
                                                color: AppColor.backgroundColor,
                                                fontSize: 16)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account',
                                  style: GoogleFonts.manrope(
                                      color: Colors.grey, fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SignInScreen(),
                                        ));
                                  },
                                  child: Text(
                                    'Sign in',
                                    style: GoogleFonts.manrope(
                                        color: AppColor.secondary,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
