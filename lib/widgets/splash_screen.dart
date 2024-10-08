import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';

import '../database/storages/user_secure_storage.dart';
import '../helpers/custome_color.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    // await UserSecureStorage.setToken(
    //     "21|2Nw1fLAMXbvdYs3oYqbdiUZnDCwItORwaFd4sWd3f219b5a9");

    var token = await UserSecureStorage.getToken();
    await Future.delayed(const Duration(seconds: 3), () {});
    token != null ? Get.to(() => HomePage()) : Get.to(() => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CustomColors().primaryColor,
                  CustomColors().extraColor2
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or app icon
                Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/growth.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // App name with animated text
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Buktor Grow',
                      textStyle: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 1,
                  pause: const Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
                const SizedBox(height: 10),
                // Tagline or a welcome message
                const Text(
                  'Growing Together!',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
