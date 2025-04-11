import 'dart:io';

import 'package:crud/common/constants/color_const.dart';
import 'package:crud/features/home/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/constants/icon_const.dart';
import '../../../common/constants/image_const.dart';
import '../../../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      image = File(pickedFile!.path);
    });
  }

  final emailValidation = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final passwordValidation =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool pass1 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.secondryColor,
      appBar: AppBar(
        backgroundColor: ColorConst.secondryColor,
        title: const Text(
          "Profile",
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      TextFormField(
                        controller: nameController,
                        style: const TextStyle(
                          color: ColorConst.triColor,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: "Username",
                          labelStyle: const TextStyle(
                            color: ColorConst.triColor,
                          ),
                          hintText: "Please enter your name",
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
                          counterText: "",
                          labelText: "Email",
                          labelStyle: const TextStyle(
                            color: ColorConst.triColor,
                          ),
                          hintText: "Enter your email",
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
                        keyboardType: TextInputType.emailAddress,
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
                        obscureText: pass1 ? true : false,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                pass1 = !pass1;
                                setState(() {});
                              },
                              child: pass1
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
                  GestureDetector(
                    onTap: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            actions: [
                              const CupertinoDialogAction(
                                child: Text(
                                  "Are you Sure You Want to Update Details?",
                                  style: TextStyle(
                                    color: ColorConst.triColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomePage(),
                                      ));
                                },
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(
                                    color: ColorConst.alertColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: ColorConst.alertRedColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
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
                          "Update",
                          style: GoogleFonts.montserrat(
                            color: ColorConst.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
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
