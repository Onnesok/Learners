import 'package:flutter/material.dart';
import 'package:learners/home/all_courses/all_course_fetch.dart';
import 'package:learners/home/enroll_course.dart';
import 'package:learners/themes/default_theme.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../api/api_root.dart';

class CourseListView extends StatefulWidget {
  final String category;

  const CourseListView({
    super.key,
    required this.category,
  });

  @override
  State<CourseListView> createState() => _CourseListViewState();
}

class _CourseListViewState extends State<CourseListView> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero, () {
      final allCourseProvider =
          Provider.of<AllCourseProvider>(context, listen: false);
      allCourseProvider.fetchAllCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final allCourseProvider = Provider.of<AllCourseProvider>(context);

    List<AllCourse> filteredCourses = widget.category == 'All'
        ? allCourseProvider.courses
        : allCourseProvider.courses
            .where((course) => course.categoryTitle == widget.category)
            .toList();

    return Scaffold(
      backgroundColor: default_theme.white,
      appBar: AppBar(
        title: Text(
          widget.category == 'All' ? 'All Courses' : "${widget.category}",
        ),
        scrolledUnderElevation: 0,
        backgroundColor: default_theme.white,
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/s1.png'),
            fit: BoxFit.cover,
          ),
        ),
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
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "No courses available",
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
                            courseId: course.courseId,
                            title: course.title,
                            image: api_root + course.image,
                            stars: course.stars,
                            instructorName: course.instructorName,
                            duration: course.duration,
                            price: course.price,
                            releaseDate: course.releaseDate,
                            videoContent: course.videoContent,
                            videoTitle: course.videoTitle,
                            description: course.description,
                            introVideo: course.introVideo,
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height:
                                        MediaQuery.of(context).size.width * 0.25,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.broken_image,
                                          size: 50);
                                    },
                                  ),
                                )
                              : const Icon(Icons.image, size: 100),

                          SizedBox(width: 8.0), // Space between image and text

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)), //Reminder:  add maxlines 2 but in themes
                                  SizedBox(height: 4.0),
                                  Text('Instructor: ${course.instructorName}'),
                                  Text('Category: ${course.categoryTitle}'),
                                  Text('Duration: ${course.duration}'),
                                  Text('Price: \$${course.price.toStringAsFixed(2)}'),
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
    );
  }
}
