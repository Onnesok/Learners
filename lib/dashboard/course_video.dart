import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/s1.png',
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Video Player
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

                  // Current Video Title
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    margin: EdgeInsets.only(
                      top: _controller.value.isFullScreen ? 40 : 0,
                    ),
                    color: Colors.black.withOpacity(0.6),
                    child: Text(
                      videoTitles[_currentVideoIndex],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),


                  const SizedBox(height: 10),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: List.generate(videoTitles.length, (index) {
                        return GestureDetector(
                          onTap: () => _changeVideo(index),
                          child: courseBlock(index, videoTitles[index]),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget courseBlock(int index, String videoTitle) {
    bool isPlaying = _currentVideoIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: isPlaying ? default_theme.orange.withOpacity(0.1) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: isPlaying
              ? default_theme.orange.withOpacity(0.7)
              : Colors.grey.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isPlaying
                ? default_theme.orange
                : default_theme.orange.withOpacity(0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        title: Text(
          videoTitle,
          style: default_theme.body_grey.copyWith(
            fontSize: 14,
            fontWeight: isPlaying ? FontWeight.bold : FontWeight.w500,
            color: isPlaying ? default_theme.orange : default_theme.body_grey.color,
          ),
        ),
        trailing: Icon(
          isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
          color: default_theme.orange,
          size: 24,
        ),
      ),
    );
  }
}
