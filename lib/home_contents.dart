import 'package:flutter/cupertino.dart';
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
      appBar: AppBar(
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
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "My course",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "PermanentMarker",
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.linearToSrgbGamma(),
                image: AssetImage('assets/images/my_course2.png'),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 8,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "My courses",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "PermanentMarker",
                  color: Colors.black87,
                  backgroundColor: Colors.orange,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Category",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "PermanentMarker",
              ),
            ),
          ),
          Container(
            height: 150,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(8, (index) {
                  return Container(
                    width: 130,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: ColorFilter.linearToSrgbGamma(),
                        image: AssetImage('assets/images/my_course.png'),
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
                        'Category $index',
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
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Popular courses",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "PermanentMarker",
              ),
            ),
          ),

          Container(
            height: 300, // Specify a height to prevent overflow issues
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(8, (index) {
                return Container(
                  width: 130,
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
            ),
          )

        ],
      ),
    );
  }
}



