import 'package:firstinternshipproject/Widgets/App_Bar.dart';
import 'package:firstinternshipproject/Widgets/Bottom_Navigation_Bar.dart';
import 'package:flutter/material.dart';

import '../Constraints/constraints.dart';

class GamesTiming extends StatelessWidget {
  const GamesTiming({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: App_Bar(
          title: "Timing",
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: backgroundColor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: primaryColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "KOLKATA FATAFAT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                DataTable(
                    columnSpacing: MediaQuery.of(context).size.width * 0.05,
                    columns: [
                      DataColumn(
                          label: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: Center(
                            child: Text(
                          "Last Play Time",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      )),
                      DataColumn(
                          label: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: Center(
                            child: Text(
                          "Result Time",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      )),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                    ]),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Text(
                  "KOLKATA FATAFAT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                DataTable(
                    columnSpacing: MediaQuery.of(context).size.width * 0.05,
                    columns: [
                      DataColumn(
                          label: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: Center(
                            child: Text(
                          "Last Play Time",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      )),
                      DataColumn(
                          label: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: Center(
                            child: Text(
                          "Result Time",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      )),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                      DataRow(cells: [
                        DataCell(Center(
                            child: Text(
                          "Bazi 1: 10:00 am",
                          style: TextStyle(color: Colors.white),
                        ))),
                        DataCell(Center(
                            child: Text(
                          "10:10 am",
                          style: TextStyle(color: Colors.white),
                        )))
                      ]),
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
