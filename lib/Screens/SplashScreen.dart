import 'package:firstinternshipproject/Constraints/constraints.dart';
import 'package:firstinternshipproject/Screens/LoginScreen.dart';
import 'package:firstinternshipproject/Screens/home.dart';
import 'package:firstinternshipproject/Widgets/Bottom_Navigation_Bar.dart';
// Import your HomeScreen

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Splash_Screen extends StatelessWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if the user is already authenticated
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    Future.delayed(Duration(seconds: 3), () {
      if (user != null) {
        // User is authenticated, navigate to HomeScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Bottom_Navigation_bar(),
          ),
        );
      } else {
        // User is not authenticated, navigate to LoginScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    });

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [backgroundColor, primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Image.asset('assets/images/logo.png',
            height: MediaQuery.of(context).size.height * 0.3),
      ),
    );
  }
}
