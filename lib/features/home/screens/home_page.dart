import 'package:carousel_slider/carousel_slider.dart';
import 'package:crud/common/constants/color_const.dart';
import 'package:crud/features/home/screens/api_page.dart';
import 'package:crud/features/home/screens/banner_page.dart';
import 'package:crud/features/home/screens/current_users.dart';
import 'package:crud/features/home/screens/login_and_signup_page.dart';
import 'package:crud/features/home/screens/noti_page.dart';
import 'package:crud/features/home/screens/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../common/constants/icon_const.dart';
import '../../../common/constants/image_const.dart';
import '../../../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> img = [
    ImageConst.list_1_Image,
    ImageConst.list_1_Image,
    ImageConst.list_1_Image,
  ];
  int selectIndex = 0;

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserName = prefs.getString(
      'username',
    );
    setState(() {});
  }

  removeUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.clear();
    setState(() {});
  }

  @override
  void initState() {
    getUserName();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // avoid keyboard overflow error
      backgroundColor: ColorConst.secondryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: width * 0.02),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ));
                setState(() {});
              },
              child: CircleAvatar(
                radius: width * 0.05,
                backgroundImage: const AssetImage(ImageConst.profileImage),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.02),
            child: GestureDetector(
              onTap: () {
                getUserName();
                removeUserName();
                signOut(context);
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CarouselSlider.builder(
                itemCount: img.length,
                options: CarouselOptions(
                  height: height * 0.25,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(
                    seconds: 1,
                  ),
                  viewportFraction: 0.8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      selectIndex = index;
                    });
                  },
                ),
                itemBuilder: (BuildContext context, int index, realIndex) {
                  return Container(
                    height: height * 0.25,
                    width: width * 1,
                    margin: EdgeInsets.all(width * 0.025),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(width * 0.03),
                        image: DecorationImage(
                            image: AssetImage(img[index]), fit: BoxFit.fill)),
                  );
                },
              ),
              SizedBox(
                height: height * 0.01,
              ),
              AnimatedSmoothIndicator(
                activeIndex: selectIndex,
                count: img.length,
                effect: JumpingDotEffect(
                  activeDotColor: ColorConst.triColor,
                  dotColor: ColorConst.textformColor,
                  dotHeight: height * 0.01,
                  dotWidth: width * 0.02,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CurrentUsers(),
                      ));
                },
                child: Container(
                  height: height * 0.205,
                  width: width * 0.44,
                  decoration: BoxDecoration(
                    color: ColorConst.secondryColor,
                    borderRadius: BorderRadius.circular(width * 0.1),
                    boxShadow: const [
                      BoxShadow(
                        color: ColorConst.borderColor,
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ImageConst.firebase_logo_Image),
                      Text(
                        "CRUD",
                        style: TextStyle(
                          color: ColorConst.triColor,
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.056,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BannerPage(),
                      ));
                },
                child: Container(
                    height: height * 0.205,
                    width: width * 0.44,
                    decoration: BoxDecoration(
                      color: ColorConst.secondryColor,
                      borderRadius: BorderRadius.circular(width * 0.1),
                      boxShadow: const [
                        BoxShadow(
                          color: ColorConst.borderColor,
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      ImageConst.cloudImage,
                    )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ApiPage(),
                      ));
                },
                child: Container(
                  height: height * 0.205,
                  width: width * 0.44,
                  decoration: BoxDecoration(
                    color: ColorConst.secondryColor,
                    borderRadius: BorderRadius.circular(width * 0.1),
                    boxShadow: const [
                      BoxShadow(
                        color: ColorConst.borderColor,
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ImageConst.apiImage),
                      Text(
                        "API",
                        style: TextStyle(
                          color: ColorConst.triColor,
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.056,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotiPage(),
                      ));
                },
                child: Container(
                  height: height * 0.205,
                  width: width * 0.44,
                  decoration: BoxDecoration(
                    color: ColorConst.secondryColor,
                    borderRadius: BorderRadius.circular(width * 0.1),
                    boxShadow: const [
                      BoxShadow(
                        color: ColorConst.borderColor,
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.notifications,
                    size: height * 0.1,
                    color: ColorConst.borderColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginAndSignupPage()),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
