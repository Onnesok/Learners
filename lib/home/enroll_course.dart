import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learners/api/api_root.dart';
import 'package:learners/themes/default_theme.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../profile/profile_provider.dart';

class enroll extends StatefulWidget {
  final int courseId;
  final String title;
  final String image;
  final String stars;
  final String discount;
  final String instructorName;
  final String duration;
  final double price;
  final String releaseDate;
  final String content;  /// video id here and separated with coma ","
  final String prerequisite;
  final int ratingCount;
  final String certificate;
  final String introVideo;

  const enroll({
    super.key,
    required this.courseId,   /// Most important ... yo
    required this.title,
    required this.image,
    required this.stars,
    this.discount = "No",
    required this.instructorName,
    required this.duration,
    required this.price,
    required this.releaseDate,
    required this.content,
    this.prerequisite = "No prerequisite",
    this.ratingCount = 0000,
    this.certificate = "No",
    this.introVideo = "lxRwEPvL-mQ",
  });

  @override
  State<enroll> createState() => _enrollState();
}



class _enrollState extends State<enroll> with TickerProviderStateMixin {
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  late YoutubePlayerController _controller;
  late final AnimationController animationController;
  late final Animation<double> animation;


  Future<void> addEnrollment(String email, int courseId) async {
    final Uri apiUrl = Uri.parse('${api_root}/enroll.php');

    final Map<String, dynamic> requestBody = {
      'uemail': email,
      'course_id': courseId,
    };

    try {
      final http.Response response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        Fluttertoast.showToast(msg: 'Enrollment added successfully');
      } else if (response.statusCode == 409) {
        Fluttertoast.showToast(msg: 'You are already enrolled in this course');
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: 'Bad request: ${response.body}');
      } else if (response.statusCode == 500) {
        Fluttertoast.showToast(msg: "Server error 500");
      } else {
        Fluttertoast.showToast(msg: 'Unexpected error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred");
    }
  }


  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: 'lxRwEPvL-mQ', // Youtube video ID for bionic arm df1MDyeAJ_Q
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        showLiveFullscreenButton: false,
        enableCaption: false,
        loop: true,
        controlsVisibleAtStart: true,
      ),
    );
    _controller.addListener(() {
      if (_controller.value.isFullScreen) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
      setState(() {});
    });

    animationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
  }

  @override
  void dispose() async {
    if (_controller.value.isFullScreen) {
      _controller.toggleFullScreenMode();
    } else {
      await Future.delayed(const Duration(milliseconds: 200));
      _controller.dispose();
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }



  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        opacity1 = 1.0;
      });
    }
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        opacity2 = 1.0;
      });
    }
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        opacity3 = 1.0;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final email = profileProvider.email;

    return Scaffold(
      backgroundColor: default_theme.white,
      appBar: _controller.value.isFullScreen
          ? null
          : AppBar(
        title: Text(widget.title),
        backgroundColor: default_theme.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (_controller.value.isFullScreen) {
            _controller.toggleFullScreenMode();
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: _controller.value.isFullScreen
                        ? MediaQuery.of(context).size.height
                        : MediaQuery.of(context).size.height * 0.4,
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: default_theme.orange,
                      onReady: () {},
                      width: double.infinity,
                    ),
                  ),
                  // scrollable.
                  buildDescription(email),
                  if (_controller.value.isFullScreen)
                    buildJoinCourse(email),
                ],
              ),
            ),
            if (!_controller.value.isFullScreen)
              buildJoinCourse(email),
          ],
        ),
      ),
    );
  }






  Widget buildDescription(String email) {
    return Positioned(
      top: _controller.value.isFullScreen
          ? MediaQuery.of(context).size.height
          : MediaQuery.of(context).size.height * 0.4,
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: <Widget>[
          Container(
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Course Title
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        letterSpacing: 0.27,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Rating and Stars
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        widget.stars,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      // Discount (will be removed)
                      Text(
                        widget.discount.isNotEmpty ? 'Discount: ${widget.discount}' : '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: opacity2,
                    child: const Text(
                      'This course provides comprehensive knowledge on the topic. It is designed to help you master the subject with ease and gain practical insights.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 14,
                        letterSpacing: 0.27,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Course Details (Classes, Time, Seats)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        getTimeBoxUI("Duration:", "${widget.duration}"),
                        getTimeBoxUI("Release Date:", "${widget.releaseDate}"),
                          getTimeBoxUI("Certificate:", "${widget.certificate}"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Instructor:",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),

                        Text(
                          " ${widget.instructorName}",
                          style: default_theme.body_grey,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),


                  // Extra spacing to ensure the button stays at the bottom
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
                ],
              ),
            ),
          ),
          //////////////
        ],
      ),
    );
  }


  Widget buildJoinCourse(String email)  {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: opacity3,
        child: Container(
          margin: EdgeInsets.only(bottom: 20, top: 10),
          width: MediaQuery.of(context).size.width * 0.6,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 20,
              backgroundColor: default_theme.orangeButton,
            ),
            onPressed: () {
              addEnrollment(email, widget.courseId);
            },
            child: const Text(
              'Join Course',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget wishlist() {
    return Positioned(
      top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
      right: 35,
      child: ScaleTransition(
        scale: CurvedAnimation(
            parent: animationController, curve: Curves.fastOutSlowIn),
        child: Card(
          color: Colors.orange,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0)),
          elevation: 10.0,
          child: SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  minimumSize: const Size(60, 60),
                ),
                onPressed: () {},
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                offset: const Offset(1.1, 1.1),
                spreadRadius: 6,
                blurRadius: 10.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: Colors.orange,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

