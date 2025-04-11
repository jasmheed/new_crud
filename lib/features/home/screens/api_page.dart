import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/constants/color_const.dart';
import '../../../common/constants/icon_const.dart';
import '../../../main.dart';
import 'package:http/http.dart' as http;

class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  List post = [];

  getData() async {
    Uri? uri = Uri.tryParse(
        'https://api.postalpincode.in/pincode/${numberController.text}');
    http.Response data = await http.get(uri!);
    var apiResponse = data.body;
    List apiData = jsonDecode(apiResponse);
    post = apiData;
    setState(() {});
  }

  final numberValidation = RegExp(r"[0-9]{6}$");
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.secondryColor,
      appBar: AppBar(
        backgroundColor: ColorConst.secondryColor,
        title: const Text(
          "API",
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (!numberValidation.hasMatch(value!)) {
                      return "Please enter valid pincode";
                    } else {
                      return null;
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: numberController,
                  style: const TextStyle(
                    color: ColorConst.triColor,
                  ),
                  decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: ColorConst.primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(width * 0.03),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: ColorConst.primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(width * 0.03),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorConst.primaryColor,
                        ),
                      )),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  maxLength: 6,
                ),
              ),
              post.isEmpty
                  ? Container()
                  : SizedBox(
                      height: height * 0.5,
                      child: ListView.builder(
                        itemCount: post[0]['PostOffice'].length,
                        itemBuilder: (context, index) {
                          String name =
                              post[0]['PostOffice'][index]['Name'].toString();
                          String pincode = post[0]['PostOffice'][index]
                                  ['Pincode']
                              .toString();

                          return ListTile(
                            title: Text('Name: $name'),
                            subtitle: Text('Pincode: $pincode'),
                          );
                        },
                      ),
                    ),
              ElevatedButton(
                onPressed: () {
                  getData();
                },
                child: Text(
                  "GET",
                  style: GoogleFonts.montserrat(
                    color: ColorConst.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
