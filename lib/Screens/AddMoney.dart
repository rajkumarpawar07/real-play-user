import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstinternshipproject/Constraints/constraints.dart';
import 'package:firstinternshipproject/Screens/home.dart';
import 'package:firstinternshipproject/common/custom_snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/custom_textfield.dart';
import 'LoginScreen.dart';

class Add_Money extends StatefulWidget {
  const Add_Money({super.key});

  @override
  State<Add_Money> createState() => _Add_MoneyState();
}

class _Add_MoneyState extends State<Add_Money> {
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

  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
        foregroundColor: Colors.white,
        title: Text(
          "Add Money",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor, // Set your desired app bar color
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
          SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: backgroundColor, // Set your desired container color
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white54,
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "756656565",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  "Phone Pay - 7512151544",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  "Google Pay- 754545454545",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  "Minimum Add Rs300/-",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                // Handle the logic to add data to Firestore
                requestBalance();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    backgroundColor, // Set your desired button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Request Balance",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Previous Requests',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Requests')
                .doc('${userData?['phonenumber']}')
                .collection('RequestMoney')
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

  void requestBalance() async {
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

    // Check if the amount is less than 300
    if (double.parse(amount) < 300) {
      // Display an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Minimum amount to add is ₹300.'),
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

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String? phoneNumber = user.phoneNumber;
      String? name = '${userData?['name']}';
      print(name);

      // Check if the phoneNumber is not null
      if (phoneNumber != null && name != null) {
        // Reference to Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Data to be saved
        Map<String, dynamic> requestData = {
          'PaymentType': selectedPaymentType,
          'Amount': amount,
          'PhoneNumber': '+91${phoneNumberController.text}',
          'Date': DateTime.now().toString(),
          'UserNumber': phoneNumber,
          'Status': 'Pending',
          'Name': name
        };

        await firestore
            .collection('Requests')
            .doc(phoneNumber)
            .set({'PhoneNumber': phoneNumber, 'name': name});
        // Create a document in the 'requests' collection with the user's UID as the document ID
        await firestore
            .collection('Requests')
            .doc(phoneNumber)
            .collection('RequestMoney')
            .doc()
            .set(requestData)
            .catchError((e) {
          print(e); // Handle any errors here
        }).then((value) {
          // Show success message or navigate to the next screen
          ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBars.successSnackBar("Request Successfully Sent"));

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        });

        print('Request created successfully.');
      }
    }
  }
}
