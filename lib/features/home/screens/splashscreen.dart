import 'package:crud/common/constants/color_const.dart';
import 'package:crud/features/home/screens/login_and_signup_page.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(
      seconds: 4,
    )).then((value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginAndSignupPage(),
        )));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "CRUD",
              style: TextStyle(
                color: ColorConst.secondryColor,
                fontSize: width * 0.08,
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
