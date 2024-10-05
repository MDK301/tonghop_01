import 'package:flutter/material.dart';

import '../../res/fonts.dart';
import '../../view_model/services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Splash_Services services = Splash_Services();

  @override
  void initState() {
    super.initState();

    services.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/images/logo.jpg')),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
                child: Text(
              'Welcome to Note Master',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: AppFonts.sfProDisplayBold,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.pinkAccent),
            )),
          )
        ],
      )),
    );
  }
}
