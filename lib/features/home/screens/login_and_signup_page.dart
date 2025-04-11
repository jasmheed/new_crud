import 'package:crud/features/home/screens/login_page.dart';
import 'package:crud/features/home/screens/signup_page.dart';
import 'package:crud/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/constants/color_const.dart';
import '../../../common/constants/image_const.dart';

class LoginAndSignupPage extends StatefulWidget {
  const LoginAndSignupPage({super.key});

  @override
  State<LoginAndSignupPage> createState() => _LoginAndSignupPageState();
}

class _LoginAndSignupPageState extends State<LoginAndSignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.secondryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(ImageConst.login_and_signup_Image),
            Column(
              children: [
                Text(
                  "CRUD",
                  style: TextStyle(
                      color: ColorConst.primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: width * 0.075),
                ),
                SizedBox(
                  height: width * 0.05,
                ),
                const Text(
                  "Create, Read, Update ,Delete",
                  style: TextStyle(
                    color: ColorConst.primaryColor,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                  },
                  child: Container(
                    height: height * 0.08,
                    width: width * 0.7,
                    decoration: BoxDecoration(
                      color: ColorConst.primaryColor,
                      borderRadius: BorderRadius.circular(width * 0.1),
                    ),
                    child: Center(
                      child: Text(
                        "Login",
                        style: GoogleFonts.montserrat(
                          color: ColorConst.secondryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: width * 0.05,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ));
                  },
                  child: Container(
                    height: height * 0.08,
                    width: width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.1),
                      border: Border.all(
                          color: ColorConst.primaryColor, width: width * 0.005),
                    ),
                    child: Center(
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.montserrat(
                          color: ColorConst.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
