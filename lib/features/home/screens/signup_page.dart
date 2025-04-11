import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/common/constants/color_const.dart';
import 'package:crud/features/home/screens/home_page.dart';
import 'package:crud/features/home/screens/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constants/icon_const.dart';
import '../../../common/constants/image_const.dart';
import '../../../main.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? image;
  String imgUrl =
      "https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI=";

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      image = File(pickedFile!.path);
    });
  }

  userSignUP() async {
    if (emailController.text.isEmpty) {
      return showUploadMessage('enter email', context);
    }
    if (passwordController.text.isEmpty) {
      return showUploadMessage('enter password', context);
    }
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) async {
      UserModel userModel = UserModel(
        id: value.user?.uid ?? '',
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        image: imgUrl,
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(userModel.id)
          .set(userModel.toMap());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', nameController.text);

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

  final emailValidation = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final passwordValidation =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  final confirmValidation =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  bool pass1 = false;
  bool pass2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.secondryColor,
      appBar: AppBar(
        backgroundColor: ColorConst.secondryColor,
        title: const Text(
          "User Registration",
          style: TextStyle(
            color: ColorConst.triColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(width * 0.015),
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(IconConst.backIcon)),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: SingleChildScrollView(
            child: SizedBox(
              width: width,
              height: height * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    children: [
                      image == null
                          ? CircleAvatar(
                              radius: width * 0.25,
                              backgroundImage:
                                  const AssetImage(ImageConst.profileImage),
                            )
                          : CircleAvatar(
                              radius: width * 0.25,
                              backgroundImage: FileImage(image!),
                            ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: GestureDetector(
                          onTap: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return CupertinoActionSheet(
                                  actions: [
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        _pickImage(ImageSource.gallery);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Photo Gallery",
                                        style: TextStyle(
                                          color: ColorConst.alertColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        _pickImage(ImageSource.camera);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Camera",
                                        style: TextStyle(
                                          color: ColorConst.alertColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: ColorConst.alertColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: ColorConst.primaryColor,
                            child: SvgPicture.asset(
                              IconConst.editIcon,
                              color: ColorConst.secondryColor,
                              height: height * 0.03,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: width * 0.03,
                      ),
                      TextFormField(
                        controller: nameController,
                        style: TextStyle(
                          color: ColorConst.triColor.withOpacity(0.5),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorConst.textformColor.withOpacity(0.2),
                          suffixIcon: Padding(
                            padding: EdgeInsets.all(width * 0.03),
                            child: SvgPicture.asset(IconConst.userIcon),
                          ),
                          counterText: "",
                          hintText: "Full name",
                          hintStyle: GoogleFonts.montserrat(
                            color: ColorConst.triColor.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: width * 0.03,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (!emailValidation.hasMatch(value!)) {
                            return "Please enter your email";
                          } else {
                            return null;
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: emailController,
                        style: TextStyle(
                          color: ColorConst.triColor.withOpacity(0.5),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorConst.textformColor.withOpacity(0.2),
                          suffixIcon: Padding(
                            padding: EdgeInsets.all(width * 0.03),
                            child: SvgPicture.asset(IconConst.mailIcon),
                          ),
                          counterText: "",
                          hintText: "Valid email",
                          hintStyle: GoogleFonts.montserrat(
                            color: ColorConst.triColor.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: width * 0.03,
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
                        style: TextStyle(
                          color: ColorConst.triColor.withOpacity(0.5),
                        ),
                        obscureText: pass1 ? true : false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorConst.textformColor.withOpacity(0.2),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              pass1 = !pass1;
                              setState(() {});
                            },
                            child: pass1
                                ? Padding(
                                    padding: EdgeInsets.all(width * 0.028),
                                    child:
                                        SvgPicture.asset(IconConst.passOnIcon),
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(width * 0.0195),
                                    child: SvgPicture.asset(
                                      IconConst.passOffIcon,
                                      color:
                                          ColorConst.triColor.withOpacity(0.3),
                                    ),
                                  ),
                          ),
                          counterText: "",
                          hintText: "Password",
                          hintStyle: GoogleFonts.montserrat(
                            color: ColorConst.triColor.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: width * 0.03,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (!passwordValidation.hasMatch(value!)) {
                            return "Please re enter your password";
                          } else {
                            return null;
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: confirmController,
                        style: TextStyle(
                          color: ColorConst.triColor.withOpacity(0.5),
                        ),
                        obscureText: pass2 ? true : false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorConst.textformColor.withOpacity(0.2),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              pass2 = !pass2;
                              setState(() {});
                            },
                            child: pass2
                                ? Padding(
                                    padding: EdgeInsets.all(width * 0.028),
                                    child:
                                        SvgPicture.asset(IconConst.passOnIcon),
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(width * 0.0195),
                                    child: SvgPicture.asset(
                                      IconConst.passOffIcon,
                                      color:
                                          ColorConst.triColor.withOpacity(0.3),
                                    ),
                                  ),
                          ),
                          counterText: "",
                          hintText: "Confirm Password",
                          hintStyle: GoogleFonts.montserrat(
                            color: ColorConst.triColor.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: width * 0.03,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      userSignUP();

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const HomePage(),
                      //     ));
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
                  SizedBox(
                    height: height * 0.1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an Account ",
                        style: TextStyle(
                          color: ColorConst.triColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ));
                        },
                        child: Text(
                          " Login?",
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
}
