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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CustomAppBar(
          onTabChange: widget.onTabChange,
          profileProvider: profileProvider,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Search_bar(),

            const SizedBox(height: 10,),

            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
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
            const SizedBox(
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
                              margin: const EdgeInsets.symmetric(horizontal: 10,),

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
                                      //layout builder seems messy at this point and thats why used all the available screen of the device * 1 or 10% of the entire screen
                                      // Made it same for square value
                                      width: MediaQuery.of(context).size.width * 0.1,
                                      height: MediaQuery.of(context).size.width * 0.1,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      category.name,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    const SizedBox(height: 4,),

                                    Text(
                                      '${category.courseCount} Courses',
                                      style: const TextStyle(
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

            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      double imageWidth = constraints.maxWidth;
                                      // for the maxheight and api image is giving mismatch kinda result...
                                      // so using 50% of the available width as the height
                                      double imageHeight = constraints.maxWidth * 0.5;

                                      return Container(
                                        width: imageWidth,
                                        height: imageHeight,
                                        child: Image.network(
                                          course.image,
                                          width: imageWidth,
                                          height: imageHeight,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                ),


                                const SizedBox(height: 4,),

                                Text(
                                  course.title,
                                  style: const TextStyle(
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
                                        course.stars,
                                        style: const TextStyle(
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
                                  style: const TextStyle(
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
