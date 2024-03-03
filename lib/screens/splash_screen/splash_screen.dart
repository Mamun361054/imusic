import 'package:dhak_dhol/screens/splash_screen/splash_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashScreenProvider(context),
      child: Consumer<SplashScreenProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Image.asset('assets/images/app_logo.png',scale: 2,)),
              ],
            ),
          );
        },
      ),
    );
  }
}
