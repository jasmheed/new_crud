import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_page.dart';

class PhoneAuthPage extends StatefulWidget {
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  TextEditingController numberController = TextEditingController();

  // Default to India
  Future<void> sendOTP(BuildContext context) async {
    String phno = numberController.text.trim();
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
        phoneNumber: phno,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          print(e.message.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpPage(
                  verificationId: verificationId,
                ),
              ));
        },
        codeAutoRetrievalTimeout: (String verificationID) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Authentication")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // CountryCodePicker(
            //   initialSelection: "IN",
            //   onChanged: (code) {
            //     setState(() {
            //       countryCode = code.dialCode!;
            //     });
            //   },
            // ),
            TextField(
              controller: numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Phone Number"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => sendOTP(context),
              child: Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
