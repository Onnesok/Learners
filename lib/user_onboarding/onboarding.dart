import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learners/user_onboarding/login_page.dart';

class UnbordingContent {
  String image;
  String title;
  String description;

  UnbordingContent({required this.image, required this.title, required this.description});
}

List<UnbordingContent> contents = [
  UnbordingContent(
    title: 'Empower your mind with learners',
    image: 'assets/onboarding/ob1_im.svg',
    description: "Grow together in a like minded community",
  ),
  UnbordingContent(
    title: 'Build your career with learners',
    image: 'assets/onboarding/ob2_im.svg',
    description: "Learn the secrets of industry to get a boost.",
  ),
  UnbordingContent(
    title: 'Catch your dream with learners',
    image: 'assets/onboarding/ob3_im.svg',
    description: "Dreams are not far. catch it with learners app.",
  ),
];

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;
  PageController _controller = PageController(initialPage: 0);

  @override
  void initState() {
    checkIfOnboardingShown();
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  void checkIfOnboardingShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingShown = prefs.getBool('onboardingShown') ?? false;
    if (onboardingShown) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => login(),
        ),
      );
    }
  }

  void markOnboardingAsShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingShown', true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/ob1.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (_, i) {
                    return Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            contents[i].image,
                            height: MediaQuery.of(context).size.height * 0.2,
                          ),
                          SizedBox(height: 20,),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              textAlign: TextAlign.center,
                              contents[i].title,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            contents[i].description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.black87.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: 100,),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                contents.length,
                                    (index) => buildDot(index, context),
                              ),
                            ),
                          ),
                          Container(
                            height: 60,
                            margin: EdgeInsets.only(top: 40, bottom: 40),
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text(
                                currentIndex == contents.length - 1 ? "Get Started" : "Next",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xfff3834d),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                if (currentIndex == contents.length - 1) {
                                  markOnboardingAsShown(); // Mark onboarding as shown
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => login(),
                                    ),
                                  );
                                }
                                _controller.nextPage(
                                  duration: Duration(milliseconds: 10),
                                  curve: Curves.bounceIn,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 8,
      width: currentIndex == index ? 30 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xfff3834d),
      ),
    );
  }
}
