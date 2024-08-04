import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learners/home/custom_appbar.dart';
import 'package:learners/home/enroll_course.dart';
import 'package:provider/provider.dart';
import 'package:learners/profile/profile_provider.dart';
import 'package:learners/home/category/category_fetch.dart';
import 'package:learners/home/searchbar.dart';
import 'package:learners/home/popular_courses/popular_courses_fetch.dart';

class home_contents extends StatefulWidget {
  final Function(int) onTabChange;

  const home_contents({required this.onTabChange, super.key});

  @override
  State<home_contents> createState() => _home_contentsState();
}

class _home_contentsState extends State<home_contents> {
  @override
  void initState() {
    super.initState();
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.fetchCategories();

    final popularCourseProvider =
        Provider.of<PopularCourseProvider>(context, listen: false);
    popularCourseProvider.fetchPopularCourses();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final popularCourseProvider = Provider.of<PopularCourseProvider>(context);

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
                      overflow: TextOverflow.ellipsis,
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
                          fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),

            /////////////////////////////// Categories of all courses :)   ////////////////////////////

            Container(
              height: MediaQuery.of(context).size.height * 0.12,
              child: categoryProvider.categories.isEmpty
                  ? Center(
                      child: Text(
                        "Categories not available right now",
                        style: TextStyle(
                          color: Colors.black87.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categoryProvider.categories.map((category) {
                          return GestureDetector(
                            onTap: () {
                              Fluttertoast.showToast(msg: "Tapped on ${category.name}");
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.24,
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.8),
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      category.image,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      category.name,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      '${category.courseCount} Courses',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        overflow: TextOverflow.ellipsis,
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
            SizedBox(
              height: 10,
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
                      overflow: TextOverflow.ellipsis,
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
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ////////////////////////// These courses are popular within my bros :')   ///////////////////////

            popularCourseProvider.courses.isEmpty
                ? Center(
                    child: Text(
                      "Popular courses not available right now",
                      style: TextStyle(
                        color: Colors.black87.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 30,
                        childAspectRatio: 1,
                      ),
                      itemCount: popularCourseProvider.courses.length,
                      itemBuilder: (context, index) {
                        final course = popularCourseProvider.courses[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => enroll(
                                  title: course.title,
                                  image: course.image,
                                  stars: course.stars,
                                  discount: course.discount,
                                ),
                                ),
                            );
                          },
                          child: Container(
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
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.network(
                                      course.image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4,),
                                Text(
                                  course.title,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  color: Colors.green[200],
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${course.stars}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          overflow: TextOverflow.ellipsis,
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
                                Text(
                                  "${course.discount} discount",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
