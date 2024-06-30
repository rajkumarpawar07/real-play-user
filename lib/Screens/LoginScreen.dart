import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firstinternshipproject/Constraints/constraints.dart';
import 'package:firstinternshipproject/Screens/SignUpScreen.dart';
import 'package:firstinternshipproject/Screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/custom_snackbars.dart';
import '../common/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String number = " ";
  String password = " ";
  Country country = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");
  TextEditingController phoneController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, primaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 155),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: customTextField(
                    showLine: true,
                    keyboardType: TextInputType.number,
                    textController: phoneController,
                    hintText: 'Phone Number',
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: () {
                          showCountryPicker(
                              countryListTheme: const CountryListThemeData(
                                  bottomSheetHeight: 600),
                              context: context,
                              onSelect: (value) {
                                setState(() {
                                  country = value;
                                });
                              });
                        },
                        child: Text(
                          "${country.flagEmoji}" + "  +${country.phoneCode}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    suffixIcon: number.length == 10
                        ? Icon(
                            Icons.check_circle_sharp,
                            color: Colors.green,
                          )
                        : null),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 60,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  print('${phoneController.text.trim().length}');
                  if (phoneController.text.trim() != '' &&
                      phoneController.text.trim().length == 10) {
                    var existingUser = await FirebaseFirestore.instance
                        .collection('users')
                        .where('phonenumber',
                            isEqualTo:
                                '+${country.phoneCode}${phoneController.text}')
                        .get();

                    var userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(phoneController.text.toString())
                        .get();

                    if (existingUser.docs.isEmpty) {
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('User not Exists'),
                        duration: Duration(seconds: 3),
                      ));
                    } else {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber:
                              '+${country.phoneCode}${phoneController.text}',
                          verificationCompleted:
                              (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException ex) {},
                          codeSent: (String verificationID, int? resendToken) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtpScreen(
                                          verificationID: verificationID,
                                          phoneNumber:
                                              phoneController.text.trim(),
                                        )));
                          },
                          codeAutoRetrievalTimeout: (String verificationid) {});
                    }
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackBars.errorSnackBar('Enter valid number.'));
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: textColor,
                  shadowColor: Colors.white,
                  elevation: 5, // Add elevation for a 3D effect
                ),
                child: isLoading
                    ? const Center(
                        child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ))
                    : Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                GestureDetector(
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUp_Screen()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
