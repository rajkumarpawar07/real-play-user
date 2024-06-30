import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstinternshipproject/Constraints/constraints.dart';
import 'package:firstinternshipproject/Screens/AddMoney.dart';
import 'package:firstinternshipproject/Screens/BettingScreen.dart';
import 'package:firstinternshipproject/Screens/BidHistory.dart';
import 'package:firstinternshipproject/Screens/Contact.dart';
import 'package:firstinternshipproject/Screens/ResultPage.dart';
import 'package:firstinternshipproject/Screens/Withdraw.dart';
import 'package:firstinternshipproject/Widgets/App_Bar.dart';
import 'package:firstinternshipproject/Widgets/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:neon_widgets/neon_widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../common/marquee_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? currentBackPressTime;
  List<Map<dynamic, dynamic>> initialize = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var runningText;
  VideoPlayerController? _controller;

  String nextGameTime = '';

  @override
  void initState() {
    super.initState();
    getVideo();
    getTime();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

// This function fetches the video URL and initializes the video player
  Future<void> getVideo() async {
    try {
      // Fetch the document
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Videos')
          .doc('GameVideos')
          .get();

      // Extract the videoUrl from the document
      if (documentSnapshot.exists) {
        final videoUrl = documentSnapshot.get('VideoUrl');

        FileInfo? fileInfo =
            await DefaultCacheManager().getFileFromCache(videoUrl);

        if (fileInfo == null) {
          await DefaultCacheManager().downloadFile(videoUrl).then((fileInfo) {
            _initializeVideoPlayer(fileInfo.file.path);
          });
        } else {
          _initializeVideoPlayer(fileInfo.file.path);
        }
      }
    } catch (e) {
      print('Error fetching video: $e');
    }
  }

  void _initializeVideoPlayer(String filePath) {
    _controller = VideoPlayerController.file(File(filePath))
      ..initialize().then((_) {
        if (mounted) {
          // Check if the widget is still in the tree
          setState(() {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          });
          _controller?.setVolume(0);
          _controller?.play(); // Automatically play the video
          _controller?.setLooping(true);
          //   // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        }
      });
  }

  DateTime getNext90MinutesSlot(DateTime currentTime, DateTime baseTime) {
    // Calculate difference in minutes from base time
    int minutesSinceBase = currentTime.difference(baseTime).inMinutes;

    // Calculate how many slots of 90 minutes have passed
    int slotsPassed = (minutesSinceBase / 30).ceil();

    // Calculate the next slot time
    return baseTime.add(Duration(minutes: slotsPassed * 30));
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  void getTime() {
    DateTime currentTime = DateTime.now(); // Year, Month, Day, Hour, Minute
    DateTime baseTime =
        DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0);

    // Find the next slot 90 minutes after 12:00 AM considering the current time
    DateTime nextSlot = getNext90MinutesSlot(currentTime, baseTime);

    // Format and print the next slot time
    nextGameTime = formatDateTime(nextSlot);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentBackPressTime == null ||
            DateTime.now().difference(currentBackPressTime!) >
                Duration(seconds: 2)) {
          currentBackPressTime = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Press again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        SystemNavigator.pop();
        return true; // exit the app
      },
      child: Scaffold(
        drawer: Drawer_(),
        appBar: AppBar(
          title: App_Bar(
            title: "Real Play",
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: backgroundColor,
        ),
        body: Body(),
      ),
    );
  }

  Widget Body() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: primaryColor,
      child: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.03,
          color: Colors.black,
          child: Center(
            child: Marquee(
              text:
                  'Next game starts at $nextGameTime. अगला गेम शुरू होता है $nextGameTime बजे.',
              style: TextStyle(color: Colors.white),
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 10.0,
              velocity: 50.0,
              startPadding: 10.0,
              accelerationCurve: Curves.linear,
            ),
          ),
        ),

        Expanded(
          child: _controller != null && _controller!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!))
              : const Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                )),
        ),
        // ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Add_Money()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF4A900),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                child: Text(
                  "Add Money",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.3 * 0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BetHistory()));
                },
                child: Text(
                  "My Bid",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.3 * 0.11,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF84C3BE),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ResultPage()));
                },
                child: Text(
                  "Result",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.3 * 0.11,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE1CC4F),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Withdraw_Money()));
                },
                child: Text(
                  "Withdraw",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.3 * 0.11,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA65E2E),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BetHistory()));
                },
                child: Text(
                  "History",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.3 * 0.11,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD95030),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ContactPage()));
                },
                child: Text(
                  "Contact",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.3 * 0.11,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7E7B52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Games').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: SizedBox(
                        child: CircularProgressIndicator(
                  color: Colors.white,
                ))); // Loading indicator while fetching data
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
                    padding: EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 1.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(color: Colors.white38),
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(gameImage),
                          ),
                          title: Text(
                            otherLanguageName ?? '',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                          subtitle: Text(
                            gameName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Betting_screen(gameName: gameName)));
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Lottie.asset(
                                    'assets/animations/Animation_button.json'),

                                // Icon(
                                //   Icons.play_circle_fill_rounded,
                                //   color: textColor,
                                //   size: 40,
                                // ),
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
      ]),
    );
  }
}
