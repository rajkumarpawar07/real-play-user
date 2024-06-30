import 'package:firstinternshipproject/Constraints/constraints.dart';
import 'package:firstinternshipproject/Screens/Account.dart';
import 'package:firstinternshipproject/Screens/BidHistory.dart';
import 'package:firstinternshipproject/Screens/Contact.dart';
import 'package:firstinternshipproject/Screens/ResultPage.dart';
import 'package:firstinternshipproject/Screens/home.dart';
import 'package:flutter/material.dart';

import '../Screens/bottom_navigation_screens/bid_history_screens_list.dart';
import '../Screens/bottom_navigation_screens/home_screens_list.dart';
import '../Screens/bottom_navigation_screens/results_screens_list.dart';

class Bottom_Navigation_bar extends StatefulWidget {
  @override
  State<Bottom_Navigation_bar> createState() => _Bottom_Navigation_barState();
}

class _Bottom_Navigation_barState extends State<Bottom_Navigation_bar> {
  int _currentIndex = 0;
  List<Widget> pages = [
    HomeScreensList(),
    BidHistoryScreenList(),
    ResultsScreenList(),
    ContactPage(),
    AccountPage()
  ];

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: backgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "My Bids",
            backgroundColor: backgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Results",
            backgroundColor: backgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: "Contact",
            backgroundColor: backgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
            label: "Account",
            backgroundColor: backgroundColor,
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _changePage,
      ),
    );
  }
}
