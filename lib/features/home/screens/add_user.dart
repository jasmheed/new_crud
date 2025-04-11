import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/common/constants/color_const.dart';
import 'package:crud/features/home/screens/home_page.dart';
import 'package:crud/features/home/screens/usermodel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/constants/icon_const.dart';
import '../../../main.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  String imgUrl =
      "https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI=";

  var file;

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

  // Function to add user data to Firestore
  addUserFunction() {
    UserModel userModel = UserModel(
      id: "",
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      image: imgUrl,
    );

    FirebaseFirestore.instance.collection('users').add(userModel.toMap()).then(
      (value) {
        value.update({"id": value.id});
      },
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  // Show alert when a required field is empty
  showEmptyFieldAlert(String field) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Missing Field'),
          content: Text('Please fill in the $field field before proceeding.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show password validation error message
  showPasswordErrorAlert(String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Password Error'),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.getImageFromSource(source: source);
    file = File(pickedFile!.path);
    if (mounted) {
      setState(() {
        file = File(pickedFile.path);
      });
    }

    uploadFile(file);

    Navigator.pop(context);
  }

  // Upload image to Firebase Storage
  uploadFile(File file) async {
    String ext = file.path.split('.').last;

    var uploadTask = await FirebaseStorage.instance
        .ref('uploads')
        .child(DateTime.now().toString())
        .putFile(file, SettableMetadata(contentType: 'image/$ext'));

    var getUrl = await uploadTask.ref.getDownloadURL();
    imgUrl = getUrl;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.secondryColor,
      appBar: AppBar(
        backgroundColor: ColorConst.secondryColor,
        title: const Text(
          "Add User",
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
                      CircleAvatar(
                        radius: width * 0.25,
                        backgroundImage: NetworkImage(imgUrl),
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
                      // Name Text Field
                      TextFormField(
                        controller: nameController,
                        style: TextStyle(
                            color: ColorConst.triColor.withOpacity(0.5)),
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
                      SizedBox(height: width * 0.03),

                      // Email Text Field
                      TextFormField(
                        controller: emailController,
                        style: TextStyle(
                            color: ColorConst.triColor.withOpacity(0.5)),
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
                      SizedBox(height: width * 0.03),

                      // Password Text Field
                      TextFormField(
                        controller: passwordController,
                        style: TextStyle(
                            color: ColorConst.triColor.withOpacity(0.5)),
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
                                    child:
                                        SvgPicture.asset(IconConst.passOffIcon),
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
                      SizedBox(height: width * 0.03),

                      // Confirm Password Text Field
                      TextFormField(
                        controller: confirmController,
                        style: TextStyle(
                            color: ColorConst.triColor.withOpacity(0.5)),
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
                                    child:
                                        SvgPicture.asset(IconConst.passOffIcon),
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
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // Validate fields on button tap
                      if (nameController.text.isEmpty) {
                        showEmptyFieldAlert('Name');
                      } else if (emailController.text.isEmpty) {
                        showEmptyFieldAlert('Email');
                      } else if (passwordController.text.isEmpty) {
                        showEmptyFieldAlert('Password');
                      } else if (confirmController.text.isEmpty) {
                        showEmptyFieldAlert('Confirm Password');
                      } else if (!emailValidation
                          .hasMatch(emailController.text)) {
                        showEmptyFieldAlert('Valid Email');
                      } else if (passwordController.text !=
                          confirmController.text) {
                        showPasswordErrorAlert('Passwords do not match');
                      } else if (!passwordValidation
                          .hasMatch(passwordController.text)) {
                        showPasswordErrorAlert(
                            'Password must meet the required strength');
                      } else {
                        addUserFunction();
                      }
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
                          "Add User",
                          style: GoogleFonts.montserrat(
                            color: ColorConst.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
