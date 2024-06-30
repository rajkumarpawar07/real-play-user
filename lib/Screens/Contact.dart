import 'package:firstinternshipproject/Constraints/constraints.dart';
import 'package:firstinternshipproject/Screens/home.dart';
import 'package:firstinternshipproject/Widgets/App_Bar.dart';
import 'package:firstinternshipproject/Widgets/Bottom_Navigation_Bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

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
        appBar: AppBar(
          title: App_Bar(
            title: 'Contact',
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: backgroundColor,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: primaryColor,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://imgs.search.brave.com/0LQ0fZcracY92LMgzdD4PXoUtnehzOKs7wlRl4Md10U/rs:fit:860:0:0/g:ce/aHR0cHM6Ly90aHVt/YnMuZHJlYW1zdGlt/ZS5jb20vYi9jdXN0/b21lci1zZXJ2aWNl/LTE4MjA2NzEuanBn'),
                        fit: BoxFit.fill)),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.05,
                color: backgroundColor,
                child: Center(
                  child: Text(
                    "We are Happy to Help you",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Center(
                  child: Text(
                    "Just give us a Call or Whatsapp your Query",
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Row(
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
                    child: Column(
                      children: [
                        Image.network(
                          'https://pngimg.com/d/phone_PNG49006.png',
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Call Helpine",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Text(
                    "|",
                    style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.w200,
                        color: backgroundColor),
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
                    child: Column(
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/WhatsApp_icon.png/479px-WhatsApp_icon.png',
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "whatsapp",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
