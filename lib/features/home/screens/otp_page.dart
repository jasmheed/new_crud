import 'package:crud/features/home/screens/user%20_info.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;
  OtpPage({required this.verificationId});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController otpController = TextEditingController();
  Future<void> verifyOTP(context) async {
    String otp = otpController.text.trim(); // Trim any spaces from OTP
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      if (otp.isEmpty) {
        print("OTP field is empty!");
        return;
      }

      // Create PhoneAuthCredential using the verificationId and OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: otp);

      // Sign in the user with the credential
      await auth.signInWithCredential(credential);
      print("OTP verified successfully");

      // Navigate to HomePage on successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserInfoPage()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase exceptions
      print("FirebaseAuthException: ${e.message}");
      if (e.code == 'invalid-verification-code') {
        print("Invalid OTP entered. Please try again.");
      } else if (e.code == 'too-many-requests') {
        print("Too many attempts. Try again later.");
      } else if (e.code == 'quota-exceeded') {
        print("Quota exceeded, too many requests. Try again later.");
      } else {
        print("Unknown Firebase error: ${e.message}");
      }
    } catch (e) {
      // Handle other errors
      print("General error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify OTP")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Enter OTP"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => verifyOTP(context),
              child: const Text("Verify OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
