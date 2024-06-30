import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstinternshipproject/Constraints/constraints.dart';
import 'package:firstinternshipproject/Screens/home.dart';
import 'package:firstinternshipproject/Widgets/Bottom_Navigation_Bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  String verificationID;
  String phoneNumber;
  String? name;
  String? email;
  String? countrycode;

  OtpScreen(
      {super.key,
      required this.verificationID,
      this.email,
      this.name,
      required this.phoneNumber,
      this.countrycode});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();

  String? otp;
  bool isLoading = false;

  Future<void> createUser() async {
    try {
      // Check if a user with the same phone number already exists
      var existingUser = await FirebaseFirestore.instance
          .collection('users')
          .where('phonenumber', isEqualTo: widget.phoneNumber)
          .get();

      if (existingUser.docs.isEmpty) {
        // User with the phone number doesn't exist, create a new user

        await FirebaseFirestore.instance
            .collection('users')
            .doc('+' + widget.countrycode! + widget.phoneNumber)
            .set({
          'name': widget.name,
          'email': widget.email,
          'phonenumber': '+' + widget.countrycode! + widget.phoneNumber,
          'profilepic':
              'https://firebasestorage.googleapis.com/v0/b/real-play-app.appspot.com/o/GPTlogo.jpg?alt=media&token=c9cd70f0-e96e-4909-878e-281797ac875c',
          'bankname': '',
          'accountnumber': '',
          'ifdccode': '',
          'paytm': '',
          'googlepay': '',
          'coins': 0
          // Add any additional user data you want to store
        });

        print("User Created");
      } else {
        // User with the phone number already exists, you might want to handle this case
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User Already Exists'),
          duration: Duration(seconds: 3),
        ));
        print("User with the phone number already exists");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Something went wrong!'),
        duration: Duration(seconds: 3),
      ));
      print("CANT CREATE USER ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: color),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    const Text(
                      "VERIFICATION",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    const Text(
                      "OTP is sent to your Mobile Number",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${widget.phoneNumber}",
                      style: TextStyle(
                          color: textColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Pinput(
                        length: 6,
                        onCompleted: (pin) {
                          otp = pin.toString();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            PhoneAuthCredential credential =
                                await PhoneAuthProvider.credential(
                                    verificationId: widget.verificationID,
                                    smsCode: otp.toString());

                            FirebaseAuth.instance
                                .signInWithCredential(credential)
                                .then((value) async {
                              await createUser();
                              saveUserInfoToPrefs(widget.phoneNumber);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Bottom_Navigation_bar()));
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Please enter valid OTP'),
                              duration: Duration(seconds: 3),
                            ));
                            print(e.toString());
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: textColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: isLoading
                            ? const Center(
                                child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    )),
                              )
                            : const Text(
                                "VERIFY OTP",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                )),
    );
  }

  Future<void> saveUserInfoToPrefs(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phoneNumber', phoneNumber);
  }
}
