import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constraints/constraints.dart';
import '../Widgets/App_Bar.dart';

class AllResultsPage extends StatefulWidget {
  final String gameName;
  final String TodayDate;
  const AllResultsPage(
      {super.key, required this.gameName, required this.TodayDate});

  @override
  State<AllResultsPage> createState() => _AllResultsPageState();
}

class _AllResultsPageState extends State<AllResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // Ensure primaryColor is defined
      appBar: AppBar(
        title: App_Bar(title: "Results"), // Ensure App_Bar is a defined widget
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: backgroundColor, // Ensure backgroundColor is defined
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Results')
                    .doc(widget.gameName)
                    .collection('Date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Text('No data available'));
                  }
                  return ListView.separated(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      var document = snapshot.data?.docs[index];
                      var documentID = document?.id ?? 'No ID';
                      return ListTile(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Colors.white54),
                            borderRadius: BorderRadius.circular(15)),
                        title: Column(
                          children: [
                            Text(
                              documentID,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                            Divider(),
                          ],
                        ),
                        subtitle: Container(
                          height:
                              50, // Specify a fixed height for the horizontal list
                          width: MediaQuery.of(context).size.width,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Results')
                                .doc(widget.gameName)
                                .collection('Date')
                                .doc(documentID)
                                .collection('Bids')
                                .snapshots(),
                            builder: (context, innerSnapshot) {
                              if (innerSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ));
                              }
                              if (!innerSnapshot.hasData) {
                                return Center(child: Text('No bids available'));
                              }
                              return GridView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: innerSnapshot.data?.docs.length ?? 0,
                                itemBuilder: (context, innerIndex) {
                                  var bidDoc =
                                      innerSnapshot.data?.docs[innerIndex];
                                  var data =
                                      bidDoc?.data() as Map<String, dynamic>;
                                  var number =
                                      data['Number']?.toString() ?? 'No number';
                                  var winners = data['Winners']?.toString() ??
                                      'No winners';
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      shape: BoxShape.rectangle,
                                      color: backgroundColor,
                                    ),
                                    margin: EdgeInsets.symmetric(horizontal: 3),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(number,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16)),
                                          Text(winners,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12)),
                                        ]),
                                  );
                                },
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 1,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 10,
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
