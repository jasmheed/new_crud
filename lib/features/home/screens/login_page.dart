import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/common/constants/color_const.dart';
import 'package:crud/common/constants/firebase_const.dart';
import 'package:crud/common/constants/icon_const.dart';
import 'package:crud/features/home/screens/home_page.dart';
import 'package:crud/features/home/screens/phone_page.dart';
import 'package:crud/features/home/screens/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constants/image_const.dart';
import '../../../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordValidation =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  final emailValidation = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool tap = false;

  String imgUrl =
      "https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI=";

  setUserName() async {
    String? userId =
        FirebaseAuth.instance.currentUser?.uid; // Get current user's UID

    if (userId != null && userId.isNotEmpty) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(FirebaseConst.users)
          .doc(userId) // Get the document for the logged-in user
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        currentUserName =
            userData['name'] ?? "Unknown"; // Extract the 'name' field

        // Save to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', currentUserName!);

        print("Username saved successfully: $currentUserName");
      } else {
        print("User document does not exist.");
      }
    } else {
      print("Error: No user logged in.");
    }
  }

  loginWithgetMethod() async {
    if (userNameController.text == '') {
      showUploadMessage('please enter username', context);
    }
    if (passwordController.text == '') {
      showUploadMessage('please enter password', context);
    }
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection(FirebaseConst.users)
        .where('name', isEqualTo: userNameController.text)
        .get();

    if (data.docs.isEmpty) {
      showUploadMessage('User does not exist', context);
    } else {
      if (data.docs[0]['password'] == passwordController.text) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ));
      } else {
        showUploadMessage('Wrong password', context);
      }
    }
  }

  loginWithAuthMethod() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: userNameController.text, password: passwordController.text)
        .then((value) async {
      // print(id);
      setUserName();
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => HomePage(),
        ),
        (route) => false,
      );
    }).catchError((error) {
      showUploadMessage(error.code, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorConst.secondryColor,
      appBar: AppBar(
        backgroundColor: ColorConst.secondryColor,
        title: const Text(
          "CRUD",
          style: TextStyle(
            color: ColorConst.triColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: SingleChildScrollView(
            child: SizedBox(
              width: width,
              height: height * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    ImageConst.loginImage,
                    height: height * 0.27,
                  ),
                  Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (!emailValidation.hasMatch(value!)) {
                            return "Please enter your email";
                          } else {
                            return null;
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: userNameController,
                        style: const TextStyle(
                          color: ColorConst.triColor,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: "Username",
                          labelStyle: const TextStyle(
                            color: ColorConst.triColor,
                          ),
                          hintText: "Please enter your username",
                          hintStyle: const TextStyle(
                            color: ColorConst.triColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorConst.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorConst.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorConst.primaryColor,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: width * 0.05,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (!passwordValidation.hasMatch(value!)) {
                            return "Please enter your password";
                          } else {
                            return null;
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
                        style: const TextStyle(
                          color: ColorConst.triColor,
                        ),
                        obscureText: tap ? true : false,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                tap = !tap;
                                setState(() {});
                              },
                              child: tap
                                  ? Padding(
                                      padding: EdgeInsets.all(width * 0.03),
                                      child:
                                          SvgPicture.asset(IconConst.eyeOnIcon),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.all(width * 0.03),
                                      child: SvgPicture.asset(
                                          IconConst.eyeOffIcon),
                                    )),
                          counterText: "",
                          labelText: "Password",
                          labelStyle: const TextStyle(
                            color: ColorConst.triColor,
                          ),
                          hintText: "Enter your password",
                          hintStyle: const TextStyle(
                            color: ColorConst.triColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorConst.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorConst.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorConst.primaryColor,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // loginWithgetMethod();

                          setState(() {
                            loginWithAuthMethod();
                          });
                        },
                        child: Container(
                          height: height * 0.08,
                          width: width * 0.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.1),
                            border: Border.all(
                                color: ColorConst.primaryColor,
                                width: width * 0.005),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(width * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(IconConst.lockIcon),
                                Text(
                                  "Login",
                                  style: GoogleFonts.montserrat(
                                    color: ColorConst.primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.05,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: width * 0.05,
                      ),
                      GestureDetector(
                        onTap: () {
                          signInWithGoogle(context);
                        },
                        child: Container(
                          height: height * 0.08,
                          width: width * 0.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.1),
                            border: Border.all(
                                color: ColorConst.primaryColor,
                                width: width * 0.005),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(width * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(IconConst.googleIcon),
                                Text(
                                  " Sign in with Google",
                                  style: GoogleFonts.montserrat(
                                    color: ColorConst.primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.05,
                                )
                              ],
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
                                builder: (context) => PhoneAuthPage(),
                              ));
                          setState(() {});
                        },
                        child: Container(
                          height: height * 0.08,
                          width: width * 0.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.1),
                            border: Border.all(
                                color: ColorConst.primaryColor,
                                width: width * 0.005),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(width * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(IconConst.lockIcon),
                                Text(
                                  "OTP sign in",
                                  style: GoogleFonts.montserrat(
                                    color: ColorConst.primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.05,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account ? ",
                        style: GoogleFonts.montserrat(
                          color: ColorConst.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupPage(),
                              ));
                          setState(() {});
                        },
                        child: Text(
                          "Create Now",
                          style: GoogleFonts.montserrat(
                            color: ColorConst.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User canceled the sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        currentUserName = userCredential.user?.displayName ?? "Guest";
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', currentUserName!);
        await FirebaseFirestore.instance
            .collection(FirebaseConst.users)
            .doc(userCredential.user!.uid)
            .set({
          'id': userCredential.user!.uid,
          'name': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'image': imgUrl,
        });

        print("User name: $currentUserName");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      print("Error signing in with Google: $e");
    }
  }
}

showUploadMessage(
  String text,
  BuildContext context,
) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(text)));
}
