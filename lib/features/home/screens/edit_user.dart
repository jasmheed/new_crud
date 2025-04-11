import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/common/constants/color_const.dart';
import 'package:crud/common/constants/firebase_const.dart';
import 'package:crud/features/home/screens/current_users.dart';
import 'package:crud/features/home/screens/usermodel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/constants/icon_const.dart';
import '../../../main.dart';

class EditUser extends StatefulWidget {
  final String id;
  const EditUser({super.key, required this.id});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  var file;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.getImageFromSource(source: source);
    file = File(pickedFile!.path);

    uploadFile(file);
  }

  uploadFile(File file) async {
    String ext = file.path.split('.').last;

    var uploadTask = await FirebaseStorage.instance
        .ref('uploads')
        .child(DateTime.now().toString())
        .putFile(file, SettableMetadata(contentType: 'image/$ext'));

    var getUrl = await uploadTask.ref.getDownloadURL();

    if (mounted) {
      setState(() {
        // Update your state
        imgUrl = getUrl;
      });
    }
  }

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

  UserModel? currentUserModel;

  String? imgUrl;

  getData() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection(FirebaseConst.users)
        .doc(widget.id)
        .get();

    currentUserModel =
        UserModel.fromMap(userData.data() as Map<String, dynamic>);

    nameController.text = currentUserModel!.name.toString();
    passwordController.text = currentUserModel!.password.toString();
    emailController.text = currentUserModel!.email.toString();
    imgUrl = currentUserModel!.image.toString();

    if (mounted) {
      setState(() {});
    }
  }

  updateData() {
    if (currentUserModel != null) {
      UserModel updatedModel = currentUserModel!.copyWith(
          email: emailController.text,
          name: nameController.text,
          password: passwordController.text,
          image: imgUrl);

      FirebaseFirestore.instance
          .collection(FirebaseConst.users)
          .doc(widget.id)
          .update(updatedModel.toMap());
    }
  }

  alertConfirmCancel() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text(
            "Are you Sure You Want to Update Details?",
            style: TextStyle(
              color: ColorConst.triColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                updateData();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CurrentUsers(),
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
  }

  @override
  void initState() {
    getData();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.secondryColor,
      appBar: AppBar(
        backgroundColor: ColorConst.secondryColor,
        title: const Text(
          "Edit User",
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
      body: currentUserModel == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
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
                            file == null
                                ? CircleAvatar(
                                    radius: width * 0.25,
                                    backgroundImage: NetworkImage(imgUrl!),
                                  )
                                : CircleAvatar(
                                    radius: width * 0.25,
                                    backgroundImage: FileImage(file!),
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
                                        cancelButton:
                                            CupertinoActionSheetAction(
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
                              style: TextStyle(
                                color: ColorConst.triColor.withOpacity(0.5),
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    ColorConst.textformColor.withOpacity(0.2),
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
                                  borderRadius:
                                      BorderRadius.circular(width * 0.03),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(width * 0.03),
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: emailController,
                              style: TextStyle(
                                color: ColorConst.triColor.withOpacity(0.5),
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    ColorConst.textformColor.withOpacity(0.2),
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
                                  borderRadius:
                                      BorderRadius.circular(width * 0.03),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(width * 0.03),
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: passwordController,
                              style: TextStyle(
                                color: ColorConst.triColor.withOpacity(0.5),
                              ),
                              obscureText: pass1 ? true : false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    ColorConst.textformColor.withOpacity(0.2),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    pass1 = !pass1;
                                    setState(() {});
                                  },
                                  child: pass1
                                      ? Padding(
                                          padding:
                                              EdgeInsets.all(width * 0.028),
                                          child: SvgPicture.asset(
                                              IconConst.passOnIcon),
                                        )
                                      : Padding(
                                          padding:
                                              EdgeInsets.all(width * 0.0195),
                                          child: SvgPicture.asset(
                                            IconConst.passOffIcon,
                                            color: ColorConst.triColor
                                                .withOpacity(0.3),
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
                                  borderRadius:
                                      BorderRadius.circular(width * 0.03),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(width * 0.03),
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: confirmController,
                              style: TextStyle(
                                color: ColorConst.triColor.withOpacity(0.5),
                              ),
                              obscureText: pass2 ? true : false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    ColorConst.textformColor.withOpacity(0.2),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    pass2 = !pass2;
                                    setState(() {});
                                  },
                                  child: pass2
                                      ? Padding(
                                          padding:
                                              EdgeInsets.all(width * 0.028),
                                          child: SvgPicture.asset(
                                              IconConst.passOnIcon),
                                        )
                                      : Padding(
                                          padding:
                                              EdgeInsets.all(width * 0.0195),
                                          child: SvgPicture.asset(
                                            IconConst.passOffIcon,
                                            color: ColorConst.triColor
                                                .withOpacity(0.3),
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
                                  borderRadius:
                                      BorderRadius.circular(width * 0.03),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.circular(width * 0.03),
                                ),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
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
                              alertConfirmCancel();
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
                                "Edit User",
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

showUploadMessage(
  String text,
  BuildContext context,
) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(text)));
}
