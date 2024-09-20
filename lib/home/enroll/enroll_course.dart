import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learners/api/api_root.dart';
import 'package:learners/dashboard/course_video.dart';
import 'package:learners/themes/default_theme.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../profile/profile_provider.dart';
import 'addEnrollment.dart';

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
  final String videoContent;  /// video id here and separated with coma ","
  final String description;
  final String videoTitle;
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
    required this.videoContent,
    required this.description,
    required this.videoTitle,
    required this.prerequisite,
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
  bool isEnrolled = false;

  Future<void> checkEnrollment(String email, int courseId, String video_title, String videoId) async {
    final url = Uri.parse('${api_root}/check_enrollment.php');

    try {
      final response = await http.get(url.replace(queryParameters: {
        'email': email,
        'courseId': courseId.toString(),
      }));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['enrolled'] == 'yes') {
          if (mounted) {
            setState(() {
              isEnrolled = true;
            });
          }
        } else {
          print("Not enrolled");  // Dont do anything
        }
      } else {
        Fluttertoast.showToast(msg: 'Failed to check enrollment: ${response.statusCode}');
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred: $e');
      print('Exception: $e');
    }
  }



  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.introVideo, // Youtube video ID for bionic arm df1MDyeAJ_Q
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
      if (mounted) {
        setState(() {});
      }
    });

    animationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profileProvider = Provider.of<ProfileProvider>(context);
    final email = profileProvider.email;
    checkEnrollment(email, widget.courseId, widget.videoTitle, widget.videoContent);
  }

  @override
  void dispose() {
    if (_controller.value.isFullScreen) {
      _controller.toggleFullScreenMode();
    }

    _controller.removeListener(() {});
    _controller.dispose();
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
                  videoPlayer(),
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


  Widget videoPlayer() {
    return Container(
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
    );
  }

  Widget buildDescription(String email) {
    return Column(
      mainAxisSize: MainAxisSize.min,  // Change from max to min
      children: <Widget>[
        Container(
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
                    style: default_theme.title_green,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Course Details (Classes, Time, Seats)
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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

              // Description
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: opacity2,
                child: Text(
                  widget.description,
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

              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(4, 4),
                      spreadRadius: 10,
                      blurRadius: 24,
                    ),
                  ],
                ),
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
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(4, 4),
                      spreadRadius: 10,
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Prerequisites",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                    Text(
                      " ${widget.prerequisite}",
                      style: default_theme.body_grey,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(4, 4),
                      spreadRadius: 10,
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: Image.network(
                  widget.image,
                ),
              ),

              // Extra spacing to ensure the button stays at the bottom
              SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
            ],
          ),
        ),
      ],
    );
  }


  Widget buildJoinCourse(String email) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0), // Slide from right to left
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: isEnrolled
            ? Container(
          key: ValueKey(1),
          width: MediaQuery.of(context).size.width * 0.8, // More compact width
          margin: const EdgeInsets.only(bottom: 16), // Space from the bottom
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Padding for spacing
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                offset: const Offset(0, 3),
                spreadRadius: 4,
                blurRadius: 10,
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseVideo(
                    videoContent: widget.videoContent,
                    videoTitle: widget.videoTitle,
                  ),
                ),
              );
            },
            child: const Text(
              'See Course',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        )
            : AnimatedOpacity(
          key: ValueKey(2),
          duration: const Duration(milliseconds: 500),
          opacity: opacity3,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  offset: const Offset(0, 3),
                  spreadRadius: 4,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: widget.price != 0.0 ? Text(
                    "Price: ${widget.price}",
                    style: default_theme.header_green.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ) : Text(
                    "Free",
                    style: default_theme.header_green.copyWith(
                      letterSpacing: 2,
                    ),
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 10),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      backgroundColor: default_theme.orangeButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async{
                      await addEnrollment(email, widget.courseId);
                      await checkEnrollment(email, widget.courseId, widget.videoTitle, widget.videoContent);
                      if (isEnrolled) {
                        setState(() {});
                      }
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
              ],
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

