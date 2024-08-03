import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learners/home/custom_appbar.dart';
import 'package:learners/home/home_contents.dart';
import 'package:provider/provider.dart';
import 'package:learners/profile/profile_provider.dart';
import 'package:learners/home/category/category_fetch.dart';
import 'package:learners/home/searchbar.dart';


class PopularCourse {
  final String title;
  final String image;

  PopularCourse({
    required this.title,
    required this.image,
  });
}


final List<PopularCourse> popularCourses = [
  PopularCourse(
    title: 'App Development',
    image: 'assets/images/designer.png',
  ),
  PopularCourse(
    title: 'UX Design Essentials',
    image: 'assets/images/management.png',
  ),
  PopularCourse(
    title: 'Digital Marketing 101',
    image: 'assets/images/marketing.png',
  ),
  PopularCourse(
    title: 'Mara khawya 101',
    image: 'assets/images/coin.png',
  ),
  PopularCourse(
    title: 'Bash 101',
    image: 'assets/images/robotics.png',
  ),
];



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
  void initState() {
    super.initState();
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: CustomAppBar(
          onTabChange: widget.onTabChange,
          profileProvider: profileProvider,
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Search_bar(),

            SizedBox(height: 10,),

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
                      //fontFamily: "PermanentMarker",
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

            SizedBox(height: 10,),

            //////////////////////// Courses categories :)
            Container(
              height: MediaQuery.of(context).size.height * 0.12,
              child: categoryProvider.categories.isEmpty ?
                  Center(
                    child: Text(
                        "Categories not available right now", style: TextStyle(
                      color: Colors.black87.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    ),
                  ) :
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categoryProvider.categories.map((category) {
                    return GestureDetector(
                      onTap: () {
                        Fluttertoast.showToast(msg: "Tapped on ${category.name}");
                        print('Tapped on ${category.name}');
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.24,
                        margin: EdgeInsets.symmetric(horizontal: 10,),
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
                                category.image,
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(height: 8),
                              Text(
                                category.name,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 6,),
                              Text(
                                '${category.courseCount} Courses',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            SizedBox(height: 10,),

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
                      //fontFamily: "PermanentMarker",
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

            ///////////////////////// These courses became popular within my bros :')
            Container(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: popularCourses.length,
                itemBuilder: (context, index) {
                  final course = popularCourses[index];

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
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
                    child: Column(
                      children: [
                        Image.asset(
                          course.image,
                          width: 100,
                          height: 100,
                        ),
                        Text(
                          course.title,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          color: Colors.green[200],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "5 stars",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87
                                ),
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.orange[800],
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                        Text("5% discount", style: TextStyle(fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),),
                      ],
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



