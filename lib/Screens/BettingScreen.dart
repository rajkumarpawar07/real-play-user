import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstinternshipproject/Constraints/constraints.dart';
import 'package:firstinternshipproject/Screens/home.dart';
import 'package:firstinternshipproject/Widgets/App_Bar.dart';
import 'package:firstinternshipproject/Widgets/Bottom_Navigation_Bar.dart';
import 'package:firstinternshipproject/common/custom_snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Betting_screen extends StatefulWidget {
  final String gameName;

  const Betting_screen({super.key, required this.gameName});

  @override
  State<Betting_screen> createState() => _Betting_screenState();
}

class _Betting_screenState extends State<Betting_screen> {
  // Check if bazi is open based on string time
  bool isBaziOpen(String fromTime, String toTime) {
    final now = DateTime.now();
    final fromDateTime = convertStringToDateTime(fromTime);
    final toDateTime = convertStringToDateTime(toTime);
    return now.isAfter(fromDateTime) && now.isBefore(toDateTime);
  }

  DateTime convertStringToDateTime(String timeStr) {
    final format = DateFormat('hh:mm a');
    final time = format.parse(timeStr);

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: backgroundColor,
        title: App_Bar(
          title: "Home",
        ),
      ),
      body: Body(),
    );
  }

  Widget Body() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: primaryColor,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "${widget.gameName}",
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Games')
                    .doc(widget.gameName)
                    .collection('Bids')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ));
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  // Format the timestamp for display
                  final dateFormat = DateFormat('hh:mm a');

                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      var bazi = snapshot.data?.docs[index].data()
                          as Map<String, dynamic>;
                      var baziName = bazi['BidName'] as String? ?? 'Unknown';
                      var endTime = bazi['end'];
                      var startTime = bazi['start'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: ListTile(
                            leading: const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/jackpot.jpeg'),
                              radius: 35.0,
                            ),
                            title: Text(
                              baziName ?? '',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            subtitle: Text(
                              'Time: $startTime - $endTime',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: GestureDetector(
                                onTap: () {
                                  isBaziOpen(startTime, endTime)
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Select_Bet(
                                              gameName: widget.gameName,
                                              baziName: baziName,
                                              Totime: endTime,
                                            ),
                                          ),
                                        )
                                      : ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              CustomSnackBars.infoSnackBar(
                                                  "Not Opened"));
                                },
                                child: isBaziOpen(startTime!, endTime!)
                                    ? Container(
                                        height: 40,
                                        width: 40,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.play_circle,
                                          color: Colors.green,
                                          size: 40,
                                        ),
                                      )
                                    : Container(
                                        height: 40,
                                        width: 40,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                      )),
                          )),
                        ),
                      );
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}

class Select_Bet extends StatefulWidget {
  final String gameName;
  final String baziName;
  final String Totime;

  const Select_Bet(
      {super.key,
      required this.gameName,
      required this.baziName,
      required this.Totime});

  @override
  State<Select_Bet> createState() => _Select_BetState();
}

class _Select_BetState extends State<Select_Bet> {
  late Timer timer;
  late String timeRemaining;

  @override
  void initState() {
    super.initState();
    // Initialize the timer to update time every second
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      updateRemainingTime();
    });
    // Initial update
    updateRemainingTime();
  }

  @override
  void dispose() {
    // Dispose the timer when the widget is disposed
    timer.cancel();
    super.dispose();
  }

  void updateRemainingTime() {
    setState(() {
      timeRemaining = calculateTimeRemaining(widget.Totime);
    });
  }

  String calculateTimeRemaining(String toTimeString) {
    // Parse the current date and the target time
    final DateFormat timeFormat = DateFormat('hh:mm a');
    final DateTime now = DateTime.now();
    DateTime toTime = timeFormat.parse(toTimeString);

    // Reconstruct the target time using the current date
    toTime = DateTime(now.year, now.month, now.day, toTime.hour, toTime.minute);

    // If the target time is before the current time, assume it's for the next day
    if (toTime.isBefore(now)) {
      toTime = toTime.add(Duration(days: 1));
    }

    // Calculate the time difference
    final Duration difference = toTime.difference(now);

    // Format the difference as a string
    final int hours = difference.inHours;
    final int minutes = difference.inMinutes %
        60; // Remainder of minutes not forming a complete hour
    final int seconds = difference.inSeconds %
        60; // Remainder of minutes not forming a complete hour

    return '$hours hr $minutes min $seconds sec';
  }

  DateTime? _convertStringToDateTime(String timeString) {
    List<String> parts = timeString.split(':');
    if (parts.length != 2) {
      return null; // Invalid format
    }

    int hours = int.tryParse(parts[0]) ?? 0;
    int minutes = int.tryParse(parts[1].substring(0, 2)) ?? 0;

    // Check if the timeString contains "am" or "pm"
    if (parts[1].length >= 4) {
      String amPm = parts[1].substring(2).toLowerCase();
      if (amPm == 'pm' && hours < 12) {
        hours += 12;
      } else if (amPm == 'am' && hours == 12) {
        hours = 0;
      }
    }

    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hours,
      minutes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: App_Bar(
          title: "Back",
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: backgroundColor,
      ),
      body: Body(),
    );
  }

  Widget Body() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              widget.gameName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: textColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Closing in",
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.lock_clock_sharp,
                          color: Colors.white,
                        ),
                        Text(
                          timeRemaining,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BetMoney(
                                toTime: widget.Totime,
                                BaziName: widget.baziName,
                                gameName: widget.gameName,
                              )),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet_sharp,
                          size: 35,
                          color: backgroundColor,
                        ),
                        Text(
                          "Single",
                          style: TextStyle(
                            color: backgroundColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}

class Bet {
  String date;
  int amount;
  int digit;
  String result;

  Bet(
      {required this.date,
      required this.amount,
      required this.digit,
      required this.result});
}

/// Bet Money Screen
class BetMoney extends StatefulWidget {
  final String toTime;
  final String BaziName;
  final String gameName;

  const BetMoney(
      {Key? key,
      required this.toTime,
      required this.BaziName,
      required this.gameName})
      : super(key: key);

  @override
  State<BetMoney> createState() => _BetMoneyState();
}

class _BetMoneyState extends State<BetMoney> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  late Timer timer;
  late String timeRemaining;
  bool _isLoading = false;

  List<Map<String, dynamic>> betData = [];

  TextEditingController digitController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the timer to update time every second
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      updateRemainingTime();
    });
    // Initial update
    updateRemainingTime();
  }

  @override
  void dispose() {
    // Dispose the timer when the widget is disposed
    digitController.clear();
    amountController.clear();
    timer.cancel();
    super.dispose();
  }

  void updateRemainingTime() {
    setState(() {
      timeRemaining = calculateTimeRemaining(widget.toTime);
    });
  }

  String calculateTimeRemaining(String toTimeString) {
    // Parse the current date and the target time
    final DateFormat timeFormat = DateFormat('hh:mm a');
    final DateTime now = DateTime.now();
    DateTime toTime = timeFormat.parse(toTimeString);

    // Reconstruct the target time using the current date
    toTime = DateTime(now.year, now.month, now.day, toTime.hour, toTime.minute);

    // If the target time is before the current time, assume it's for the next day
    if (toTime.isBefore(now)) {
      toTime = toTime.add(Duration(days: 1));
    }

    // Calculate the time difference
    final Duration difference = toTime.difference(now);

    // Format the difference as a string
    final int hours = difference.inHours;
    final int minutes = difference.inMinutes %
        60; // Remainder of minutes not forming a complete hour
    final int seconds = difference.inSeconds %
        60; // Remainder of minutes not forming a complete ho
    return '$hours hr $minutes min $seconds sec';
  }

  DateTime? _convertStringToDateTime(String timeString) {
    List<String> parts = timeString.split(':');
    if (parts.length != 2) {
      return null; // Invalid format
    }

    int hours = int.tryParse(parts[0]) ?? 0;
    int minutes = int.tryParse(parts[1].substring(0, 2)) ?? 0;

    // Check if the timeString contains "am" or "pm"
    if (parts[1].length >= 4) {
      String amPm = parts[1].substring(2).toLowerCase();
      if (amPm == 'pm' && hours < 12) {
        hours += 12;
      } else if (amPm == 'am' && hours == 12) {
        hours = 0;
      }
    }

    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hours,
      minutes,
    );
  }

  void storeBetInFirestore(Map<String, dynamic> bet) async {
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];
    String? currentUserPhoneNumber = currentUser!.phoneNumber;

    await FirebaseFirestore.instance
        .collection('usersbet')
        .doc('UserBets')
        .collection('$currentUserPhoneNumber')
        .add({
      'bazi_name': widget.BaziName,
      'gameName': widget.gameName,
      'date': currentDate,
      'digit': bet['digit'].toString(),
      'amount': bet['amount'].toString(),
      'result': 'Pending',
    });
  }

  int calculateTotalBetAmount() {
    int totalAmount = 0;
    for (var bet in betData) {
      totalAmount += int.parse(bet['amount']);
    }
    return totalAmount;
  }

  Future<int> getUserCoins() async {
    if (currentUser != null) {
      String? uid = currentUser!.phoneNumber;

      try {
        // Reference to the Firestore collection
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(uid);

        // Get the document snapshot
        DocumentSnapshot userSnapshot = await userDocRef.get();

        // Check if the document exists
        if (userSnapshot.exists) {
          // Get the 'coins' field from the document data
          int? coins = userSnapshot['coins'];
          return coins!;
        } else {
          print('User document does not exist');
          return 0;
        }
      } catch (e) {
        print('Error fetching user coins: $e');
        return 0;
      }
    } else {
      print('User is not logged in');
      return 0;
    }
  }

  Future<void> placeBets() async {
    int totalBetAmount = calculateTotalBetAmount();
    int userCoins = await getUserCoins();

    if (totalBetAmount > userCoins) {
      // Show an error message or handle insufficient coins
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insufficient coins to place bets!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Deduct the total bet amount from the user's coins
    int newCoins = userCoins - totalBetAmount;
    // await updateUserCoins();

    // Store the bets in Firestore
    for (var bet in betData) {
      storeBetInFirestore(bet);
    }

    // Clear the betData list and show success message
    setState(() {
      betData.clear();
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bets placed successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> updateUserCoins(int totalBetAmount, int userCoins) async {
    // int totalBetAmount = calculateTotalBetAmount();
    // int userCoins = await getUserCoins();
    int newCoins = userCoins - totalBetAmount;
    if (currentUser != null) {
      String? uid = currentUser!.phoneNumber;

      try {
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(uid);

        await userDocRef.update({'coins': newCoins});
      } catch (e) {
        print('Error updating user coins: $e');
      }
    } else {
      print('User is not logged in');
    }
    print('Updating user coins to $newCoins');
  }

  void updateDocumentsForCurrentDate(
      String gameName, String number, int index) async {
    // Get the current date
    DateTime currentDate = DateTime.now();
    String formattedCurrentDate =
        '${currentDate.day}-${currentDate.month}-${currentDate.year}';

    // Get the documents that match the specified condition
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collectionGroup('${gameName} :result')
        .where('Date', isEqualTo: formattedCurrentDate)
        .get();

    // Update each matching document
    querySnapshot.docs.forEach((document) async {
      // Explicitly cast the result to Map<String, dynamic>
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

      if (data != null) {
        // Get the current count value (modify this based on your data structure)
        int currentCount = data['Bazi 1 - Count']?['1'] ?? 0;

        // Update the count value (modify this based on your requirements)
        int newCount = currentCount + 1;

        // Update the Firestore document with the new value
        await document.reference.update({
          'Bazi 1 - Count.1': newCount,
        });

        print('Document updated successfully: $newCount');
      } else {
        print('Document data is null.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: App_Bar(
              title: "Back",
            )),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${widget.gameName} - ${widget.BaziName}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(50)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Closing in", style: TextStyle(color: Colors.white)),
                  Row(
                    children: [
                      Icon(
                        Icons.lock_clock_rounded,
                        color: Colors.white,
                      ),
                      Text('$timeRemaining',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: digitController,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(10),
                          labelText: "Enter Digit",
                          border: InputBorder.none,
                          filled: true,
                          counterText: '',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          // FilteringTextInputFormatter.deny(RegExp(r'0')),
                          // Exclude 0
                          // Exclude digits 2 to 9
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: amountController,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(10),
                          labelText: "Enter Amount",
                          border: InputBorder.none,
                          filled: true,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Amount cannot be empty';
                          }
                          int amount = int.tryParse(value) ?? 0;
                          if (amount < 1) {
                            return 'Amount must be at least 1';
                          }
                          return null; // Validation passed
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 40,
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  if (digitController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackBars.errorSnackBar(
                            'Please enter valid digit.'));
                  } else if (amountController.text.trim().isEmpty ||
                      amountController.text.trim().toString() == '0') {
                    ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackBars.errorSnackBar('Amount cannot be 0.'));
                  } else {
                    setState(() {
                      // if (betData.length >= 1) {
                      //   betData.removeAt(0);
                      // }
                      betData.add({
                        'digit': digitController.text.toString(),
                        'amount': amountController.text.toString(),
                      });
                    });
                  }
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: backgroundColor),
                child: const Text("Add Bid",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 40),
            DataTable(
              border: TableBorder.all(),
              decoration: const BoxDecoration(color: Colors.white),
              headingTextStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              columns: const [
                DataColumn(
                  label: Text("Digit",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16)),
                ),
                DataColumn(
                  label: Text("Amount",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16)),
                ),
                DataColumn(
                  label: Text("Action",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16)),
                ),
              ],
              rows: betData.map((bet) {
                return DataRow(
                  cells: [
                    DataCell(
                      Container(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            bet['digit'].toString(),
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          '₹ ${bet['amount'].toString()}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            betData.remove(bet);
                          });
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 40,
              width: 150,
              child: ElevatedButton(
                onPressed: () async {
                  for (var data in betData) {
                    print(data['digit']);
                    print(data['amount']);
                  }
                  setState(() {
                    _isLoading = true;
                  });
                  if (currentUser != null) {
                    if (digitController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBars.errorSnackBar(
                              'Please enter valid digit.'));
                    } else if (amountController.text.trim().isEmpty ||
                        amountController.text.trim().toString() == '0') {
                      ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBars.errorSnackBar('Amount cannot be 0.'));
                    } else if (betData.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBars.errorSnackBar('Add a bid.'));
                    } else {
                      int totalBetAmount = calculateTotalBetAmount();
                      int userCoins = await getUserCoins();

                      if (totalBetAmount > userCoins) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBars.errorSnackBar(
                              'Insufficient coins to place bets!'),
                        );
                        setState(() {
                          _isLoading = false;
                        });
                        return;
                      }
                      final formattedDate = formatCurrentTimestamp();

                      bool? success;
                      for (var data in betData) {
                        success = await placeNumberBet(
                          amount: int.parse(data['amount']),
                          gameLocation: widget.gameName,
                          bazi: widget.BaziName,
                          date: formattedDate.toString(),
                          chosenNumber: data['digit'].toString().trim(),
                          userId: currentUser!.phoneNumber
                              .toString(), // The user's ID
                        );

                        if (success!) {
                          await updateUserCoins(totalBetAmount, userCoins);
                          ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBars.successSnackBar(
                                  "Bid placed successfully."));
                          // update the bid history of user
                          await updateBidHistoryOfUser(
                            currentUser!.phoneNumber.toString(),
                            widget.gameName,
                            formattedDate,
                            widget.BaziName,
                            int.parse(data['amount']).toString(),
                            data['digit'].toString(),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBars.errorSnackBar(
                                  "Can't use same number twice, try different number or different bid."));
                        }
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackBars.errorSnackBar(
                            "User not found. Please login again."));
                  }
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: backgroundColor),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text("Play Now",
                        style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateBidHistoryOfUser(String userId, String gameName,
      String Date, String bidName, String amount, String number) async {
    final col = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('BidHistory')
        .doc(gameName);

    await col.set({'GameName': gameName});

    final CollectionReference collection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('BidHistory')
        .doc(gameName)
        .collection('BidsHistoryInGame');

    // Example data to be added
    final Map<String, dynamic> data = {
      'Date': Date, // Current timestamp as an example
      'Bid': bidName,
      'Amount': amount,
      'Number': number,
      'Result': 'Pending',
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Adding the document to the collection
    await collection
        .add(data)
        .then((docRef) => print("Document added with ID: ${docRef.id}"))
        .catchError((error) => print("Error adding document: $error"));
  }

  String formatCurrentTimestamp() {
    Timestamp now = Timestamp.now();
    DateTime nowDate = now.toDate();
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    String formatted = formatter.format(nowDate);
    return formatted;
  }

  Future<bool> placeNumberBet({
    required String gameLocation,
    required String bazi,
    required String date,
    required String chosenNumber,
    required int amount,
    required String userId,
  }) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Games')
        .doc(gameLocation)
        .collection('Bids')
        .doc(bazi)
        .collection('Date')
        .doc(date);

    bool betPlaced = false; // Flag to track if the bet was successfully placed

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (!snapshot.exists) {
          // If the document doesn't exist, create it with the initial bet
          transaction.set(documentReference, {
            "1": [],
            "2": [],
            "3": [],
            "4": [],
            "5": [],
            "6": [],
            "7": [],
            "8": [],
            "9": [],
            "Date": date,
            chosenNumber: [
              {"userId": userId, "amount": amount}
            ],
            "WinnerNumber": "",
          });
          betPlaced = true;
        } else {
          // If the document exists, update the amount for the userId if it exists, otherwise add it
          List<dynamic> existingBets =
              List.from(snapshot.get(chosenNumber) ?? []);
          Map<String, dynamic>? userBet = existingBets.firstWhere(
            (bet) => bet['userId'] == userId,
            orElse: () => null,
          );

          if (userBet != null) {
            // If the user has already placed a bet, update the amount
            userBet['amount'] += amount;
          } else {
            // If the user hasn't placed a bet, add a new entry
            existingBets.add({"userId": userId, "amount": amount});
          }

          transaction.update(documentReference, {chosenNumber: existingBets});
          betPlaced = true;
        }
      });
    } catch (error) {
      print("Error placing/updating bet: $error");
      betPlaced = false; // Ensure betPlaced is false in case of error
    }

    return betPlaced; // Return the status of bet placement
  }

  int extractAndConvertNumericValue(String inputString) {
    // Use a regular expression to extract the numeric part
    RegExp regex = RegExp(r'\d+');
    Match? match = regex.firstMatch(inputString);

    // Convert the matched substring to an integer
    if (match != null) {
      String numericPart = match.group(0)!;
      return int.parse(numericPart);
    } else {
      // Return a default value or handle the case where no numeric value is found
      return 0;
    }
  }
}
