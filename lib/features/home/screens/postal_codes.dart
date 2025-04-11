import 'package:crud/common/constants/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/constants/icon_const.dart';
import '../../../main.dart';

class PostalCodes extends StatefulWidget {
  const PostalCodes({super.key});

  @override
  State<PostalCodes> createState() => _PostalCodesState();
}

class _PostalCodesState extends State<PostalCodes> {
  TextEditingController postalController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.secondryColor,
      appBar: AppBar(
        backgroundColor: ColorConst.secondryColor,
        title: const Text(
          "Postal Codes",
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
      body: Padding(
        padding: EdgeInsets.all(width * 0.03),
        child: Column(
          children: [
            TextFormField(
              controller: postalController,
              style: TextStyle(
                color: ColorConst.triColor.withOpacity(0.5),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorConst.textformColor.withOpacity(0.2),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(width * 0.03),
                  child: SvgPicture.asset(
                    IconConst.searchIcon,
                    color: ColorConst.searchColor,
                  ),
                ),
                counterText: "",
                hintText: "Enter pincode",
                hintStyle: GoogleFonts.sourceSans3(
                  color: ColorConst.triColor,
                  fontWeight: FontWeight.w600,
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
              height: width * 0.1,
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: width * 0.05);
                },
                itemCount: 20,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: height * 0.1,
                    width: width,
                    decoration: BoxDecoration(
                      color: ColorConst.textformColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(width * 0.02),
                    ),
                    child: Center(
                      child: ListTile(
                        title: Text(
                          "Postoffice : Perinthalmanna",
                          style: GoogleFonts.sourceSans3(
                              color: ColorConst.triColor,
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.035),
                        ),
                        subtitle: Text(
                          "Pincode : 679322",
                          style: GoogleFonts.sourceSans3(
                              color: ColorConst.triColor,
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.03),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
