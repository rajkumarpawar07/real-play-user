import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firstinternshipproject/Constraints/constraints.dart';
import 'package:firstinternshipproject/Screens/home.dart';
import 'package:firstinternshipproject/Widgets/App_Bar.dart';
import 'package:firstinternshipproject/Widgets/Bottom_Navigation_Bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../common/custom_textfield.dart';
import 'LoginScreen.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  var userData;
  User? currentUser = FirebaseAuth.instance.currentUser;
  File? image;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController paytmController = TextEditingController();
  TextEditingController googlepayController = TextEditingController();

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

  Future<void> uploadProfilePic() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) {
        // User canceled the picking operation
        return;
      }

      final imageTemp = File(pickedImage.path);

      setState(() {
        isLoading = true;
      });
      String filename = '${currentUser!.phoneNumber}_profilepic.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profileImages/$filename');
      UploadTask uploadTask = storageReference.putFile(imageTemp);
      await uploadTask;

      String downloadURL = await storageReference.getDownloadURL();

      await firestore
          .collection('users')
          .doc('${currentUser!.phoneNumber}')
          .update({
        'profilepic': downloadURL,
      });

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully Updated.'),
        duration: Duration(seconds: 3),
      ));

      print('Image Uploaded');
      // Fetch updated user data
      await fetchUserData();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      // Provide feedback to the user (e.g., show a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to pick image. Please try again.'),
        duration: Duration(seconds: 3),
      ));
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
    print("${userData}");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to home screen when the back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen()), // Replace HomeScreen with your actual home screen
        );

        // Prevent default back button behavior
        return false;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          title: App_Bar(title: 'Account'),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: backgroundColor,
        ),
        body: Body(),
      ),
    );
  }

  Widget Body() {
    if (userData == null) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    final String? profilePic = userData['profilepic'] ?? '';
    final String name = userData['name'] ?? '';
    final String phoneNumber = userData['phonenumber'] ?? '';

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Personal Information",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (isLoading)
                    const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  else
                    CircleAvatar(
                      backgroundImage: NetworkImage('$profilePic'),
                      radius: 45,
                    ),
                  Column(
                    children: [
                      Text(
                        "$name",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      Text(
                        "$phoneNumber",
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await uploadProfilePic();
                          },
                          child: isLoading
                              ? Text("Updating.... ")
                              : Text("Update image")),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              const Text(
                "Account Information",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BANK Name : \t\t${userData['bankname']}",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    "Account Number : \t\t${userData['accountnumber']}",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    "IFSC Code : \t\t${userData['ifsccode']}",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    "Paytm : \t\t${userData['paytm']}",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    "Google Pay : \t\t${userData['googlepay']}",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              const Text(
                "Update Account Information",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              customTextField(
                textController: bankNameController,
                hintText: 'Bank Name',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              customTextField(
                textController: accountController,
                hintText: 'Account Number',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              customTextField(
                textController: ifscController,
                hintText: 'IFSC Code',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              customTextField(
                textController: paytmController,
                hintText: 'Paytm',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              customTextField(
                textController: googlepayController,
                hintText: 'Google Pay',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    await firestore
                        .collection('users')
                        .doc('${currentUser!.phoneNumber}')
                        .update({
                      'bankname': bankNameController.text.toString(),
                      'accountnumber': accountController.text.toString(),
                      'ifsccode': ifscController.text.toString(),
                      'paytm': paytmController.text.toString(),
                      'googlepay': googlepayController.text.toString()
                    });

                    bankNameController.clear();
                    accountController.clear();
                    ifscController.clear();
                    paytmController.clear();
                    googlepayController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Successfully Updated.'),
                      duration: Duration(seconds: 3),
                    ));

                    fetchUserData();
                  },
                  child: Text("UPDATE"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
