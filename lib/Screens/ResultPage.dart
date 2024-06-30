import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../Constraints/constraints.dart';
import '../Widgets/App_Bar.dart';
import 'AllReultsPage.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String? todaysDate;

  @override
  void initState() {
    super.initState();
    todaysDate = formatCurrentTimestamp();
  }

  String formatCurrentTimestamp() {
    Timestamp now = Timestamp.now();
    DateTime nowDate = now.toDate();
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    String formatted = formatter.format(nowDate);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: App_Bar(
          title: "Results",
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Flexible(
              // Use Flexible instead of Expanded with ListView.builder
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Games').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  // Now ListView.builder can take the remaining space
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      var game = snapshot.data?.docs[index].data()
                          as Map<String, dynamic>; // Ensure proper data access
                      var gameName = game['GameName'];
                      var otherLanguageName = game['GameOtherLanguage'];
                      var gameImage = game['GameLogo'];

                      return Container(
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllResultsPage(
                                              gameName: gameName,
                                              TodayDate: todaysDate!,
                                            )));
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.remove_red_eye_rounded,
                                    color: textColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
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
