import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../api/api_root.dart';
import '../themes/default_theme.dart';
import 'all_courses/all_course_fetch.dart';
import 'package:provider/provider.dart';

import 'enroll_course.dart';

class Search_bar extends StatefulWidget {
  @override
  _Search_barState createState() => _Search_barState();
}

class _Search_barState extends State<Search_bar> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero, () {
      final allCourseProvider = Provider.of<AllCourseProvider>(context, listen: false);
      allCourseProvider.fetchAllCourses();
      //this is for opening keyboard ...................
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allCourseProvider = Provider.of<AllCourseProvider>(context);
    List<AllCourse> filteredCourses = allCourseProvider.courses
        .where((course) =>
            course.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            course.instructorName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            course.categoryTitle
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: default_theme.white,
      appBar: AppBar(
        title: Text('Search Courses'),
        backgroundColor: default_theme.white,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 20,),

            TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Search",
                hintStyle: TextStyle(color: default_theme.grey.withOpacity(0.6), fontStyle: FontStyle.normal, letterSpacing: 1),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      searchQuery = '';
                    });
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: default_theme.orange),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),

            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 24),
                child: Text("Results : ", style: default_theme.header,),
            ),
            //SizedBox(height: 20,),

            Expanded(
              child: filteredCourses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/animation/empty.json',
                            repeat: true,
                          ),
                          Text(
                            'No results found',
                            style: default_theme.header_grey,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredCourses.length,
                      itemBuilder: (context, index) {
                        final course = filteredCourses[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => enroll(
                                  title: course.title,
                                  image: api_root + course.image,
                                  stars: course.stars,
                                  discount: course.discount,
                                  //duration: course.duration,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 4.0,
                            color: default_theme.white,
                            child: Row(
                              children: [
                                course.image.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          api_root + course.image,
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          height: MediaQuery.of(context).size.width * 0.25,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(Icons.broken_image, size: 50);
                                          },
                                        ),
                                      )
                                    : const Icon(Icons.image, size: 100),

                                SizedBox(width: 8.0), // Space between image and text

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(course.title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 4.0),
                                        Text(
                                            'Instructor: ${course.instructorName}'),
                                        Text(
                                            'Category: ${course.categoryTitle}'),
                                        Text('Duration: ${course.duration}'),
                                        Text(
                                            'Price: \$${course.price.toStringAsFixed(2)}'),
                                      ],
                                    ),
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

