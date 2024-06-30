import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstinternshipproject/Constraints/constraints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class App_Bar extends StatefulWidget {
  String title;

  App_Bar({required this.title});

  @override
  State<App_Bar> createState() => _App_BarState();
}

class _App_BarState extends State<App_Bar> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  late Future<int?> coinsFuture;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      coinsFuture = getUserCoins();
    }
  }

  Future<int?> getUserCoins() async {
    if (currentUser != null) {
      String? uid = currentUser!.phoneNumber;

      try {
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(uid);
        var userDoc = await userDocRef.get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          int? coins = userData['coins'];
          return coins;
        } else {
          print('User document not found');
          return null;
        }
      } catch (e) {
        print('Error fetching user coins: $e');
        return null; // Handle the error as needed
      }
    } else {
      print('User is not logged in');
      return null; // Handle the case where the user is not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              widget.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          if (currentUser != null)
            FutureBuilder<int?>(
              future: coinsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(
                    color: backgroundColor,
                    strokeWidth: 1,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error loading coins');
                } else {
                  int? coins = snapshot.data;
                  return Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.yellow,
                        size: 22,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${coins ?? 0} Coins",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
