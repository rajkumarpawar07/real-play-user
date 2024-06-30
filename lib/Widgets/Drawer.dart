import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstinternshipproject/Constraints/constraints.dart';
import 'package:firstinternshipproject/Screens/Account.dart';
import 'package:firstinternshipproject/Screens/AddMoney.dart';
import 'package:firstinternshipproject/Screens/Game%20Rules.dart';
import 'package:firstinternshipproject/Screens/GamesTiming.dart';
import 'package:firstinternshipproject/Screens/LoginScreen.dart';
import 'package:firstinternshipproject/Screens/Withdraw.dart';
import 'package:firstinternshipproject/Screens/bottom_navigation_screens/bid_history_screens_list.dart';
import 'package:firstinternshipproject/Screens/home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class Drawer_ extends StatefulWidget {
  @override
  State<Drawer_> createState() => _DrawerState();
}

class _DrawerState extends State<Drawer_> {
  var userData;
  User? currentUser = FirebaseAuth.instance.currentUser;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    if (currentUser == null) {
      // Navigate to the login screen or perform authentication
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      fetchUserData();
    }
  }

  Future<void> fetchUserData() async {
    DocumentSnapshot documentSnapshot = await firestore
        .collection('users')
        .doc('${currentUser!.phoneNumber}')
        .get();
    setState(() {
      userData = documentSnapshot.data();
    });
  }

  Future<void> handleLogout() async {
    try {
      Get.offAll(() => const LoginScreen());
      await FirebaseAuth.instance.signOut();
      // Navigate to your login screen or splash screen after successful logout
    } catch (e) {
      print("Logout error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const List<String> items = [
      "Home",
      "Add Balance",
      "Withdraw Money",
      "Update Account",
      "Balance History",
      "Games Timing",
      "Game Rules",
    ];
    const List<Widget> pages = [
      HomeScreen(),
      Add_Money(),
      Withdraw_Money(),
      AccountPage(),
      BidHistoryScreenList(),
      GamesTiming(),
      GameRules(),
    ];
    const List<Widget> itemIcon = [
      Icon(Icons.home),
      Icon(Icons.account_balance_wallet),
      Icon(Icons.money),
      Icon(Icons.account_balance_outlined),
      Icon(Icons.history_edu),
      Icon(Icons.timer),
      Icon(Icons.rule),
    ];

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            color: backgroundColor,
            child: (userData == null)
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage('${userData?['profilepic'] ?? ''}'),
                        minRadius: 38.0,
                        maxRadius: 40.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${userData?['name'] ?? ''}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "${userData?['phonenumber'] ?? ''}",
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final call = Uri.parse('tel:+91 8770684866');
                      if (await canLaunchUrl(call)) {
                        launchUrl(call);
                      } else {
                        throw 'Could not launch $call';
                      }
                    },
                    child: FaIcon(FontAwesomeIcons.phone, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final web = Uri.parse('https://wa.me/+918770684866');
                      if (await canLaunchUrl(web)) {
                        launchUrl(web);
                      } else {
                        throw 'Could not launch $web';
                      }
                    },
                    child:
                        FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
                  ),
                  GestureDetector(
                    child: FaIcon(FontAwesomeIcons.share, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: handleLogout,
                    child: const Icon(Icons.logout, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Expanded(
              child: ListView.builder(
                itemCount: 7,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => pages[index]),
                      );
                    },
                    child: ListTile(
                      title: Text("${items[index]}"),
                      leading: itemIcon[index],
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
