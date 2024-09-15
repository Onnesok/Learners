import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learners/themes/default_theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseVideo extends StatefulWidget {
  final String videoContent;
  final String videoTitle;

  const CourseVideo({
    super.key,
    required this.videoContent,
    required this.videoTitle,
  });

  @override
  State<CourseVideo> createState() => _CourseVideoState();
}

class _CourseVideoState extends State<CourseVideo> {
  late YoutubePlayerController _controller;
  late List<String> videoIds;
  late List<String> videoTitles;
  int _currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();

    // Split the comma-separated videoContent and videoTitle strings into lists
    videoIds = widget.videoContent.split(',').map((id) => id.trim()).toList();
    videoTitles = widget.videoTitle.split(',').map((title) => title.trim()).toList();

    _controller = YoutubePlayerController(
      initialVideoId: videoIds[_currentVideoIndex],
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
  }

  @override
  void dispose() {
    if (_controller.value.isFullScreen) {
      _controller.toggleFullScreenMode();
    }
    _controller.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  void _changeVideo(int index) {
    setState(() {
      _currentVideoIndex = index;
      _controller.load(videoIds[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: default_theme.white,
      appBar: _controller.value.isFullScreen
          ? null
          : AppBar(
        title: Text("Course"),
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
                  // Video list as tappable containers
                  ...List.generate(videoTitles.length, (index) {
                    return GestureDetector(
                      onTap: () => _changeVideo(index),
                      child: courseBlock(index, videoTitles[index]),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget courseBlock(int index, String videoTitle) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: default_theme.orange.withOpacity(0.6),
            child: Text(
              '${index + 1}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              videoTitle,
              style: default_theme.body_grey,
            ),
          ),
        ],
      ),
    );
  }
}
