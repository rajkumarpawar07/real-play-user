import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstinternshipproject/Constraints/constraints.dart';
import 'package:firstinternshipproject/Widgets/App_Bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/custom_snackbars.dart';
import '../common/custom_textfield.dart';
import 'LoginScreen.dart';
import 'home.dart';

class Withdraw_Money extends StatefulWidget {
  const Withdraw_Money({Key? key});

  @override
  State<Withdraw_Money> createState() => _Withdraw_MoneyState();
}

class _Withdraw_MoneyState extends State<Withdraw_Money> {
  String selectedItem = "Paytm";
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  List<DropdownMenuItem<String>> dropdownItems = [
    DropdownMenuItem(child: Text("Paytm"), value: "Paytm"),
    DropdownMenuItem(child: Text("Google Pay"), value: "Google Pay"),
    DropdownMenuItem(child: Text("Phone Pay"), value: "Phone Pay"),
    DropdownMenuItem(child: Text("Bank"), value: "Bank"),
  ];
  var userData;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (currentUser == null) {
      // Navigate to the login screen or perform authentication
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      fetchUserData();
    }
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> fetchUserData() async {
    DocumentSnapshot documentSnapshot = await firestore
        .collection('users')
        .doc('${currentUser!.phoneNumber}')
        .get();
    setState(() {
      userData = documentSnapshot.data();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: App_Bar(
          title: "Withdraw",
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: backgroundColor,
      ),
      body: Body(),
    );
  }

  Widget Body() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Enter Amount",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          customTextField(
            keyboardType: TextInputType.number,
            textController: amountController,
            hintText: "Enter Amount",
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Enter Phone Number",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          customTextField(
            keyboardType: TextInputType.number,
            textController: phoneNumberController,
            hintText: "Enter Phone Number",
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Select Payment Type",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [primaryColor, primaryColor]),
                borderRadius: BorderRadius.circular(5),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                      blurRadius: 5) //blur radius of shadow
                ]),
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: DropdownButton<String>(
                value: selectedItem,
                items: dropdownItems,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedItem = newValue!;
                  });
                },
                // style: const TextStyle(color: Colors.black, fontSize: 25),
                alignment: Alignment.center,
                isExpanded: true, //make true to take width of parent widget
                underline: Container(), //empty line
                style: TextStyle(fontSize: 18, color: Colors.white),
                dropdownColor: backgroundColor,
                iconEnabledColor: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                // Handle the logic to add data to Firestore
                withdrawMoney();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Withdraw Request",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Withdraw Time Monday to Saturday => 2 Times in a day Time => 10:00AM - 09:00PM\n"
                      "For Sunday => 1 Time a day Time = > 10:00AM - 03:00 PM \nWithdraw wait time: 1hour",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Previous Withdraws',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Withdraw')
                .doc('${userData?['phonenumber']}')
                .collection('WithdrawMoney')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: SizedBox(
                        child: CircularProgressIndicator(
                  color: Colors.white,
                ))); // Loading indicator while fetching data
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                  DateTime dateTime = DateTime.parse(data['Date'].toString());

                  // Specify the format you want
                  String formattedDate =
                      DateFormat("dd MMMM yyyy").format(dateTime);

                  return Card(
                    color: backgroundColor,
                    child: ListTile(
                      title: Text(
                        'Amount - ${data['Amount'].toString()}',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Date - ${formattedDate}',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        data['Status'],
                        style: TextStyle(
                            color: data['Status'] == 'Pending'
                                ? Colors.blue
                                : Colors.green),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void withdrawMoney() async {
    String phoneNumber = phoneNumberController.text;
    String selectedPaymentType = selectedItem;
    String amount = amountController.text;

    // Validate inputs
    if (phoneNumber.isEmpty || amount.isEmpty) {
      // Show an error message or handle invalid inputs
      ScaffoldMessenger.of(context)
          .showSnackBar(CustomSnackBars.infoSnackBar("Enter valid Details"));
      return;
    }

    if (double.parse(amount) < 500) {
      // Display an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Minimum withdraw amount is ₹500.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      // Get the current user
      User? currentUser = FirebaseAuth.instance.currentUser;

      // Check if the current user is not null
      if (currentUser != null) {
        String phone = currentUser.phoneNumber!;

        // Fetch the user's coins
        int? userCoins = await getUserCoins(phone);

        // Check if the user has sufficient coins
        if (userCoins != null &&
            userCoins >= int.parse(amount) &&
            int.parse(amount) >= 500) {
          FirebaseFirestore firestore = FirebaseFirestore.instance;
          String? name = '${userData?['name']}';

          await firestore
              .collection('Withdraw')
              .doc(phone)
              .set({'PhoneNumber': phone, 'name': name});

          Map<String, dynamic> withdrawtData = {
            'PaymentType': selectedPaymentType,
            'Amount': amount,
            'PhoneNumber': '+91${phoneNumberController.text}',
            'Date': DateTime.now().toString(),
            'UserNumber': phone,
            'Status': 'Pending',
            'Name': name
          };

          await firestore
              .collection('Withdraw')
              .doc(phone)
              .collection('WithdrawMoney')
              .doc()
              .set(withdrawtData)
              .catchError((e) {
            print(e); // Handle any errors here
          }).then((value) {
            // Show success message or navigate to the next screen
            ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBars.successSnackBar("Withdraw request Sent."));

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          });

          // Show success message or navigate to the next screen
          print('Withdraw request added successfully!');
        } else {
          // Show Snackbar for insufficient coins or amount less than 500
          if (int.parse(amount) < 500) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBars.errorSnackBar(
                'Minimum amount 500.',
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBars.errorSnackBar(
                'Insufficient coins',
              ),
            );
          }
        }
      }
    } catch (e) {
      // Handle the error
      print('Error adding withdraw request: $e');
    }
  }

  Future<int?> getUserCoins(String uid) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(uid);
      var userDoc = await userDocRef.get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

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
  }
}
