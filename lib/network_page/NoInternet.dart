import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:learners/home_page.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      }

      if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const home_page())
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) {
          return ErrorContent(
            controller: animationController,
            onRetry: _checkInternetConnection,
          );
        },
      ),
    );
  }
}

class ErrorContent extends StatelessWidget {
  final NetworkErrorAnimation animation;
  final VoidCallback onRetry;

  ErrorContent({super.key, required AnimationController controller, required this.onRetry})
      : animation = NetworkErrorAnimation(controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CloudCutColoredImage(
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 16.0,
                  left: 0,
                  right: 0,
                  child: Transform(
                    transform: Matrix4.diagonal3Values(
                      1.4 - animation.sizeTranslation.value,
                      1.4 - animation.sizeTranslation.value,
                      1.0,
                    ),
                    alignment: Alignment.center,
                    child: SafeArea(
                      child: Icon(
                        Icons.signal_wifi_off,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16.0,
                  right: 8.0,
                  child: Transform(
                    transform: Matrix4.translationValues(
                      1 - animation.xTranslation.value,
                      0.0,
                      0.0,
                    ),
                    child: SafeArea(
                      child: Icon(
                        Icons.cloud,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 24.0,
                  left: 8.0,
                  child: Transform(
                    transform: Matrix4.translationValues(
                      animation.xTranslation.value,
                      0.0,
                      0.0,
                    ),
                    child: SafeArea(
                      child: Icon(
                        Icons.cloud,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 48),
              Transform(
                transform: Matrix4.diagonal3Values(
                  animation.sizeTranslation.value * 2,
                  animation.sizeTranslation.value * 2,
                  1.0,
                ),
                alignment: Alignment.center,
                child: const AutoSizeText(
                  'Ooops!',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              const AutoSizeText(
                'No internet connection !\nPlease check your connection.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.height * 0.05,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: onRetry,
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CloudCutColoredImage extends StatelessWidget {
  const CloudCutColoredImage(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomShapeClipper(),
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.orange),
        child: child,
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 60);

    var zeroControlPoint = Offset(size.width / 8, size.height - 20);
    var zeroPoint = Offset(size.width / 4, size.height - 40);
    path.quadraticBezierTo(
      zeroControlPoint.dx,
      zeroControlPoint.dy,
      zeroPoint.dx,
      zeroPoint.dy,
    );

    var firstControlPoint = Offset(size.width * (3 / 8), size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstPoint.dx,
      firstPoint.dy,
    );

    var secondControlPoint = Offset(size.width * (5 / 8), size.height);
    var secondPoint = Offset(size.width * (6 / 8), size.height - 40);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondPoint.dx,
      secondPoint.dy,
    );

    var thirdControlPoint = Offset(size.width * (7 / 8), size.height - 20);
    var thirdPoint = Offset(size.width * (8 / 8), size.height - 70);
    path.quadraticBezierTo(
      thirdControlPoint.dx,
      thirdControlPoint.dy,
      thirdPoint.dx,
      thirdPoint.dy,
    );

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class NetworkErrorAnimation {
  NetworkErrorAnimation(this.controller)
      : sizeTranslation = Tween(begin: 0.4, end: 0.7).animate(
    CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    ),
  ),
        labelOpacity = Tween(begin: 0.4, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.ease,
          ),
        ),
        xTranslation = Tween(begin: 60.0, end: 0.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.ease,
          ),
        ),
        _colorTween = ColorTween(begin: Colors.red, end: Colors.deepOrangeAccent).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.ease,
          ),
        );

  final AnimationController controller;
  final Animation<double> sizeTranslation;
  final Animation<double> labelOpacity;
  final Animation<double> xTranslation;
  final Animation _colorTween;
}
