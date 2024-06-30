import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstinternshipproject/Constraints/constraints.dart';
import 'package:firstinternshipproject/Widgets/App_Bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Widgets/Bottom_Navigation_Bar.dart';

class BetHistory extends StatefulWidget {
  @override
  State<BetHistory> createState() => _BetHistoryState();
}

class _BetHistoryState extends State<BetHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: App_Bar(
          title: "Bid History",
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Games').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Loading indicator while fetching data
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  // Use ListView.builder to display data from Firestore
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      var game = snapshot.data?.docs[index];
                      var gameName = game?['GameName'];
                      var otherLanguageName = game?['GameOtherLanguage'];
                      var gameImage = game?['GameLogo'];

                      return Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 2.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(gameImage),
                              ),
                              title: Text(
                                otherLanguageName ?? '',
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 10),
                              ),
                              subtitle: Text(
                                gameName ?? '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BidHistoryTableScreen(
                                                  gameName: gameName)));
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.remove_red_eye,
                                    color: textColor,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BidHistoryTableScreen extends StatefulWidget {
  final String gameName;
  const BidHistoryTableScreen({super.key, required this.gameName});

  @override
  State<BidHistoryTableScreen> createState() => _BidHistoryTableScreenState();
}

class _BidHistoryTableScreenState extends State<BidHistoryTableScreen> {
  List<Map<dynamic, dynamic>> userHistory = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? user;

  @override
  void initState() {
    super.initState();
    retrivedata();
  }

  void retrivedata() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.phoneNumber.toString())
          .collection('BidHistory')
          .doc(widget.gameName.toString())
          .collection('BidHistoryInGame')
          .orderBy('timestamp', descending: true)
          .get()
          .then((value) {
        setState(() {
          userHistory = value.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });
      });
      print("$userHistory");
    } else {
      print("user not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: App_Bar(
            title: "Bid History",
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: backgroundColor,
        ),
        backgroundColor: primaryColor,
        body: Padding(
          padding: EdgeInsets.all(0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.phoneNumber.toString())
                .collection('BidHistory')
                .doc(widget.gameName.toString())
                .collection('BidsHistoryInGame')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text(
                  'No bid history available.',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                );
              }

              List<DataRow> rows = snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return DataRow(cells: [
                  DataCell(Text(data['Date'] ?? 'N/A',
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.white,
                      ))),
                  DataCell(Text(data['Bid'] ?? 'N/A',
                      maxLines: 2, style: TextStyle(color: Colors.white))),
                  DataCell(Text(data['Amount'] ?? 'N/A',
                      maxLines: 2,
                      style: const TextStyle(color: Colors.white))),
                  DataCell(Text(data['Number'] ?? 'N/A',
                      maxLines: 2, style: TextStyle(color: Colors.white))),
                  DataCell(Text(data['Result'] ?? 'Pending',
                      maxLines: 2, style: TextStyle(color: Colors.white))),
                ]);
              }).toList();

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor:
                        MaterialStateProperty.all<Color>(backgroundColor),
                    border: TableBorder.all(
                      style: BorderStyle.solid,
                      width: 1.0,
                      color: Colors.white,
                    ),
                    columns: const [
                      DataColumn(
                          label: Text('Date',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16))),
                      DataColumn(
                          label: Text('Bid',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16))),
                      DataColumn(
                          label: Text('Amount',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16))),
                      DataColumn(
                          label: Text('Number',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16))),
                      DataColumn(
                          label: Text('Result',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16))),
                    ],
                    rows: rows,
                  ),
                ),
              );
            },
          ),
        )
        // Expanded(
        //   flex: 1,
        //   child: DataTable(
        //       border: TableBorder.all(color: Colors.white),
        //       columnSpacing: MediaQuery.of(context).size.width * 0.03,
        //       decoration: BoxDecoration(color: backgroundColor),
        //       columns: const <DataColumn>[
        //         DataColumn(
        //           label: Center(
        //               child: Text(
        //             'Date',
        //             style: TextStyle(
        //                 fontSize: 13,
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.white),
        //           )),
        //         ),
        //         DataColumn(
        //             label: Center(
        //                 child: Text("Game",
        //                     style: TextStyle(
        //                         fontSize: 13,
        //                         fontWeight: FontWeight.bold,
        //                         color: Colors.white)))),
        //         DataColumn(
        //           label: Center(
        //               child: Text('Bazi',
        //                   style: TextStyle(
        //                       fontSize: 13,
        //                       fontWeight: FontWeight.bold,
        //                       color: Colors.white))),
        //         ),
        //         DataColumn(
        //           label: Center(
        //               child: Text('Digit',
        //                   style: TextStyle(
        //                       fontSize: 13,
        //                       fontWeight: FontWeight.bold,
        //                       color: Colors.white))),
        //         ),
        //         DataColumn(
        //           label: Center(
        //               child: Text('Amount',
        //                   style: TextStyle(
        //                       fontSize: 13,
        //                       fontWeight: FontWeight.bold,
        //                       color: Colors.white))),
        //         ),
        //         DataColumn(
        //           label: Center(
        //               child: Text('Result',
        //                   style: TextStyle(
        //                       fontSize: 13,
        //                       fontWeight: FontWeight.bold,
        //                       color: Colors.white))),
        //         ),
        //       ],
        //       // rows: userHistory.map((data) {
        //       //   return DataRow(
        //       //     cells: <DataCell>[
        //       //       DataCell(Center(
        //       //         child: Text(
        //       //           data['date'].toString(),
        //       //           style: TextStyle(fontSize: 10, color: Colors.white),
        //       //         ),
        //       //       )), // Replace 'column1' with the actual key in your data
        //       //       DataCell(Center(
        //       //         child: Text(
        //       //           data['gameName'].toString(),
        //       //           style: TextStyle(fontSize: 10, color: Colors.white),
        //       //         ),
        //       //       )),
        //       //       DataCell(Center(
        //       //         child: Text(
        //       //           data['bazi_name'].toString(),
        //       //           style: TextStyle(fontSize: 10, color: Colors.white),
        //       //         ),
        //       //       )), // Replace 'column2' with the actual key in your data
        //       //       DataCell(Center(
        //       //         child: Text(
        //       //           data['digit'].toString(),
        //       //           style: TextStyle(fontSize: 10, color: Colors.white),
        //       //         ),
        //       //       )), // Replace 'column2' with the actual key in your data
        //       //       DataCell(Center(
        //       //         child: Text(
        //       //           data['amount'].toString(),
        //       //           style: TextStyle(fontSize: 10, color: Colors.white),
        //       //         ),
        //       )), // Replace 'column2' with the actual key in your data
        //       DataCell(Center(
        //         child: Text(
        //           data['result'].toString(),
        //           style: TextStyle(fontSize: 10, color: Colors.white),
        //         ),
        //       )),
        //       // Replace 'column2' with the actual key in your data
        //       // Add more DataCell as needed
        //     ],
        //   );
        // }).toList(),
        // rows: []),
        // ),

        );
  }
}
