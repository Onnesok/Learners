import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:learners/profile/profile_provider.dart';

class home_contents extends StatefulWidget {
  final Function(int) onTabChange;

  const home_contents({required this.onTabChange, super.key});

  @override
  State<home_contents> createState() => _home_contentsState();
}

class _home_contentsState extends State<home_contents> {
  Future<void> _NavToProfile() async {
    widget.onTabChange(3);
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "learners",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  fontFamily: "shadow",
                ),
              ),
              GestureDetector(
                onTap: _NavToProfile,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          profileProvider.fullName,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Transform.rotate(
                              angle: 3 * 3.14159 / 2,
                              child: Icon(
                                Icons.arrow_back_ios_outlined,
                                color: Colors.black87,
                                size: 12,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              "ID: 56165",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 10,),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.orange,
                      backgroundImage: profileProvider.pickedImage != null
                          ? FileImage(profileProvider.pickedImage!)
                          : AssetImage('assets/images/demo.jpg') as ImageProvider,
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange[800],
          shadowColor: Colors.transparent,
          shape: const CustomAppBarShape(multi: 0.08),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for courses',
                  hintStyle: TextStyle(color: Colors.teal.shade300),
                  prefixIcon: Icon(Icons.search, color: Colors.teal),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "PermanentMarker",
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Fluttertoast.showToast(msg: "Not done yet");
                    },
                    child: Text(
                      "See more",
                      style: TextStyle(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.16,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(8, (index) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.24,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.8),),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/coin.png',
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Category $index',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 6,),
                            Text(
                              '5 Courses',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popular courses",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "PermanentMarker",
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Fluttertoast.showToast(msg: "Not done yet");
                    },
                    child: Text(
                      "See more",
                      style: TextStyle(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: ColorFilter.linearToSrgbGamma(),
                        image: AssetImage('assets/images/my_course1.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 8,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Course $index',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomAppBarShape extends ContinuousRectangleBorder {
  final double multi;
  const CustomAppBarShape({this.multi = 0.1});
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    double height = rect.height;
    double width = rect.width;
    var path = Path();
    path.lineTo(0, height + width * multi);
    path.arcToPoint(
      Offset(width * multi, height),
      radius: Radius.circular(width * multi),
    );
    path.lineTo(width * (1 - multi), height);
    path.arcToPoint(
      Offset(width, height + width * multi),
      radius: Radius.circular(width * multi),
    );
    path.lineTo(width, 0);
    path.close();

    return path;
  }
}
