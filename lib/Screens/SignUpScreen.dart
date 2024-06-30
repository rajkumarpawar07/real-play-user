import 'package:country_picker/country_picker.dart';
import 'package:firstinternshipproject/Constraints/constraints.dart';
import 'package:firstinternshipproject/Screens/otp_screen.dart';
import 'package:firstinternshipproject/common/custom_snackbars.dart';
import 'package:firstinternshipproject/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../common/custom_textfield.dart';

class SignUp_Screen extends StatefulWidget {
  const SignUp_Screen({super.key});

  @override
  State<SignUp_Screen> createState() => _SignUp_ScreenState();
}

class _SignUp_ScreenState extends State<SignUp_Screen> {
  GlobalKey<FormState> _formKey = GlobalKey();

  String? _validateEmail(String value) {
    // Email validation regex pattern
    String pattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  AuthService authService = AuthService();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String phoneNumber = "";
  bool isLoading = false;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: customTextField(
                        textController: nameController,
                        hintText: 'Name',
                      ),
                    ),
                    const SizedBox(height: 20),
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
                                    countryListTheme:
                                        const CountryListThemeData(
                                            bottomSheetHeight: 600),
                                    context: context,
                                    onSelect: (value) {
                                      setState(() {
                                        country = value;
                                      });
                                    });
                              },
                              child: Text(
                                "${country.flagEmoji}" +
                                    "  +${country.phoneCode}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          suffixIcon: phoneNumber.length == 10
                              ? const Icon(
                                  Icons.check_circle_sharp,
                                  color: Colors.green,
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (nameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackBars.errorSnackBar(
                                    'Enter valid name.'));
                          } else if (phoneController.text.trim().isEmpty ||
                              phoneController.text.trim().length < 10) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackBars.errorSnackBar(
                                    'Enter valid Phone Number.'));
                          } else {
                            setState(() {
                              isLoading = true;
                            });

                            await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber:
                                    '+${country.phoneCode}${phoneController.text.trim()}',
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {},
                                verificationFailed:
                                    (FirebaseAuthException ex) {},
                                codeSent:
                                    (String verificationID, int? resendToken) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OtpScreen(
                                                verificationID: verificationID,
                                                email: emailController.text
                                                    .toString(),
                                                name: nameController.text
                                                    .toString(),
                                                phoneNumber:
                                                    phoneController.text.trim(),
                                                countrycode: country.phoneCode,
                                              )));
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationid) {});
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
                          "Create Account",
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
                        Text(
                          "Already have an Account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01),
                        GestureDetector(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
