import 'dart:io';

import 'package:crud/common/constants/color_const.dart';
import 'package:crud/common/constants/image_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/constants/icon_const.dart';
import '../../../main.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({super.key});

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  File? image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      image = File(pickedFile!.path);
    });
  }

  TextEditingController bannerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.secondryColor,
      appBar: AppBar(
        backgroundColor: ColorConst.secondryColor,
        title: const Text(
          "Banner",
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
      body: Column(
        children: [
          GestureDetector(
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
            child: Image.asset(ImageConst.bannerImage),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                width * 0.1, width * 0.06, width * 0.1, width * 0.06),
            child: TextFormField(
              controller: bannerController,
              style: GoogleFonts.muktaVaani(
                color: ColorConst.bannerColor,
              ),
              decoration: InputDecoration(
                counterText: "",
                labelText: "Title",
                labelStyle: GoogleFonts.muktaVaani(
                  color: ColorConst.bannerColor,
                ),
                hintText: "Banner 4",
                hintStyle: GoogleFonts.muktaVaani(
                  color: ColorConst.bannerColor,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorConst.bannerColor,
                    width: width * 0.005,
                  ),
                  borderRadius: BorderRadius.circular(width * 0.03),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorConst.bannerColor,
                    width: width * 0.005,
                  ),
                  borderRadius: BorderRadius.circular(width * 0.03),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorConst.bannerColor,
                    width: width * 0.005,
                  ),
                  borderRadius: BorderRadius.circular(width * 0.03),
                ),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: height * 0.07,
              width: width * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width * 0.03),
                border: Border.all(
                    color: ColorConst.primaryColor, width: width * 0.005),
              ),
              child: Center(
                child: Text(
                  "Upload Banner",
                  style: GoogleFonts.montserrat(
                    color: ColorConst.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: width * 0.03,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: width * 0.07);
              },
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                  child: Container(
                    height: height * 0.13,
                    width: width,
                    decoration: BoxDecoration(
                      color: ColorConst.secondryColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(width * 0.02),
                      boxShadow: const [
                        BoxShadow(
                          color: ColorConst.borderColor,
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.05),
                          ),
                          child: Image.asset(
                            ImageConst.list_1_Image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          "Banner 1",
                          style: GoogleFonts.jacquesFrancois(
                              color: ColorConst.bannerTitleColor,
                              fontWeight: FontWeight.w400,
                              fontSize: width * 0.05),
                        ),
                        subtitle: Text(
                          "2 May",
                          style: GoogleFonts.inter(
                              color: ColorConst.triColor,
                              fontWeight: FontWeight.w400,
                              fontSize: width * 0.04),
                        ),
                        trailing: GestureDetector(
                            onTap: () {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    actions: [
                                      const CupertinoDialogAction(
                                        child: Text(
                                          "Are you Sure You Want to delete Banner ?",
                                          style: TextStyle(
                                            color: ColorConst.triColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      const CupertinoDialogAction(
                                        child: Text(
                                          "Yes",
                                          style: TextStyle(
                                            color: ColorConst.alertRedColor,
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
                                            color: ColorConst.alertColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: SvgPicture.asset(IconConst.deleteRedIcon)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
