import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/common/constants/color_const.dart';
import 'package:crud/common/constants/firebase_const.dart';
import 'package:crud/common/constants/icon_const.dart';
import 'package:crud/features/home/screens/add_user.dart';
import 'package:crud/features/home/screens/edit_user.dart';
import 'package:crud/features/home/screens/home_page.dart';
import 'package:crud/features/home/screens/usermodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/constants/image_const.dart';
import '../../../main.dart';
import 'login_and_signup_page.dart';

class CurrentUsers extends StatefulWidget {
  const CurrentUsers({super.key});

  @override
  State<CurrentUsers> createState() => _CurrentUsersState();
}

class _CurrentUsersState extends State<CurrentUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.secondryColor,
      appBar: AppBar(
        backgroundColor: ColorConst.secondryColor,
        title: Padding(
          padding: EdgeInsets.only(left: width * 0.01),
          child: Text(
            "Hello,$currentUserName",
            style: const TextStyle(
              color: ColorConst.triColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.all(width * 0.015),
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              },
              child: SvgPicture.asset(IconConst.backIcon)),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: width * 0.02),
            child: CircleAvatar(
              radius: width * 0.05,
              backgroundImage: const AssetImage(ImageConst.profileImage),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.02),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginAndSignupPage(),
                    ));
              },
              child: SizedBox(
                height: height * 0.04,
                width: width * 0.1,
                child: SvgPicture.asset(IconConst.logOutIcon),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(left: width * 0.02),
              child: Title(
                color: ColorConst.triColor,
                child: Text(
                  "Current Users",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: width * 0.05),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(FirebaseConst.users)
                      .snapshots()
                      .map((event) => event.docs
                          .map((e) => UserModel.fromMap(e.data()))
                          .toList()),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var data = snapshot.data!;
                    return ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: width * 0.07);
                      },
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: height * 0.1,
                          width: width,
                          decoration: BoxDecoration(
                            color: ColorConst.listColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(width * 0.02),
                          ),
                          child: Center(
                            child: ListTile(
                              // contentPadding:
                              //     EdgeInsets.zero, // remove given padding
                              leading: CircleAvatar(
                                backgroundColor:
                                    ColorConst.profileColor.withOpacity(0.2),
                                radius: width * 0.07,
                                backgroundImage:
                                    NetworkImage(data[index].image.toString()),
                              ),
                              title: Text(
                                data[index].name.toString(),
                                style: GoogleFonts.roboto(
                                    color: ColorConst.triColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: width * 0.035),
                              ),

                              subtitle: Text(
                                data[index].email.toString(),
                                style: GoogleFonts.roboto(
                                    color: ColorConst.triColor,
                                    fontWeight: FontWeight.w300,
                                    fontSize: width * 0.03),
                              ),
                              trailing: SizedBox(
                                width: width * 0.2,
                                child: Padding(
                                  padding: EdgeInsets.only(right: width * 0.03),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return CupertinoAlertDialog(
                                                  actions: [
                                                    const CupertinoDialogAction(
                                                      child: Text(
                                                        "Are you Sure You Want to delete User ?",
                                                        style: TextStyle(
                                                          color: ColorConst
                                                              .triColor,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    CupertinoDialogAction(
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                FirebaseConst
                                                                    .users)
                                                            .doc(data[index].id)
                                                            .delete();
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                          color: ColorConst
                                                              .alertRedColor,
                                                          fontWeight:
                                                              FontWeight.w400,
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
                                                          color: ColorConst
                                                              .alertColor,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              IconConst.deleteIcon)),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditUser(
                                                  id: data[index].id!,
                                                ),
                                              ));
                                        },
                                        child: SizedBox(
                                          height: height * 0.06,
                                          width: width * 0.06,
                                          child: SvgPicture.asset(
                                              IconConst.editIcon),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddUser(),
              ));
        },
        backgroundColor: ColorConst.primaryColor,
        shape: const CircleBorder(),
        child: SvgPicture.asset(IconConst.plusIcon),
      ),
    );
  }
}
